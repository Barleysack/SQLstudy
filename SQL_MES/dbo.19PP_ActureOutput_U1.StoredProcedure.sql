USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19PP_ActureOutput_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-11
-- Description:	가동 비가동 등록
-- =============================================
CREATE PROCEDURE [dbo].[19PP_ActureOutput_U1]
  @PLANTCODE       VARCHAR(10),      -- 공장번호
  @WORKCENTERCODE  VARCHAR(10), 	 -- 작업장 코드
  @ORDERNO    	   VARCHAR(20), 	 -- 작업 지시
  @ITEMCODE        VARCHAR(30),      -- 생산 품목
  @UNITCODE        VARCHAR(10),      -- 단위
  @STATUS     	   VARCHAR(1), 	     -- 상태

  @LANG      VARCHAR(10) ='KO',
  @RS_CODE   VARCHAR(1) OUTPUT,
  @RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN     

	   --현재시간 정의
	   DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
		   ,@LS_WORKER  VARCHAR(20)
		   ,@LS_NOWTIME VARCHAR(50)
	    SET @LD_NOWTIME = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)
		SET @LS_NOWTIME = CONVERT(VARCHAR,GETDATE(),120)
		
	   
	   --작업자 등록 여부 가져오기
	   SELECT @LS_WORKER = WORKER
	     FROM TP_WorkcenterStatus WITH (NOLOCK)
	    WHERE PLANTCODE = @PLANTCODE
	      AND WORKCENTERCODE = @WORKCENTERCODE
	      AND ORDERNO=@ORDERNO
	   IF(ISNULL(@LS_WORKER,''))=''
	   BEGIN
		  SET @RS_CODE = 'E'
		  SET @RS_MSG = '투입 작업자의 정보가 없습니다.'
		  RETURN
	   END
	   -- 선택 작업장이 가동 중인지 확인
	   IF(SELECT COUNT(*)
	        FROM TP_WorkcenterStatus WITH(NOLOCK)
		   WHERE PLANTCODE      = @PLANTCODE
		     AND WORKCENTERCODE = @WORKCENTERCODE
			 AND ORDERNO        <> @ORDERNO--내가 선택한 작업지시 이외에 R로 돌아가고 있는 상태가 있으면 에러			 
			 AND STATUS         = 'R') <> 0
	   BEGIN
	   
	   	SET @RS_CODE = 'E'
	       SET @RS_MSG = '선택하신 작업장에 가동이 진행중인 작업지시가 있습니다.'
	       RETURN
	   END
	   
	   -- 선택한 작업장이 고장인지 확인
	   IF(SELECT COUNT(*)
	        FROM TB_WorkCenterMaster WITH(NOLOCK)
		   WHERE PLANTCODE      = @PLANTCODE
		     AND WORKCENTERCODE = @WORKCENTERCODE
			 AND ERRORFLAG      = 'Y') <> 0
		BEGIN
		   SET @RS_CODE = 'E'
	       SET @RS_MSG = '해당 작업장은 고장났다.'
	       RETURN
		END
	   --최초 가동 시작 일 경우 가동 시간 등록
	   UPDATE TP_WorkcenterStatus  -- 작업장 작업지시 별 상태 테이블
	      SET STATUS         = @STATUS
		    , ORDSTARTDATE   = CASE WHEN ORDSTARTDATE IS NULL 
			                        THEN @LS_NOWTIME ELSE ORDSTARTDATE 
									END
		WHERE PLANTCODE      = @PLANTCODE
		  AND WORKCENTERCODE = @WORKCENTERCODE
		  AND ORDERNO        = @ORDERNO

	  -- 작업장 별 가동 현황 테이블 TP_WorkcenterStatusRec
      DECLARE @LI_RSSEQ INT
	   SELECT @LI_RSSEQ = ISNULL(MAX(RSSEQ),0)  -- 제일 마지막으로 생성된 SEQ를 사용한다. 왜? 가동 비가동은 여러번 반복될 수 있다.
	     FROM TP_WorkcenterStatusRec WITH (NOLOCK)
	    WHERE PLANTCODE      = @PLANTCODE
		  AND WORKCENTERCODE = @WORKCENTERCODE
		  AND ORDERNO        = @ORDERNO         -- 세가지 사항이 겹치지 않는 한줄
	  
	  -- 이전 가동 정보가 있다면 그 정보에 업데이트
	  UPDATE TP_WorkcenterStatusRec
	     SET RSENDDATE      = @LD_NOWTIME      -- 종료시각만 업데이트 된다는 것
		   , EDITOR         = @LS_WORKER       -- 작업자
		   , EDITDATE       = @LD_NOWTIME      -- 등록 시간
	   WHERE PLANTCODE      = @PLANTCODE
	     AND WORKCENTERCODE = @WORKCENTERCODE
		 AND ORDERNO        = @ORDERNO    
		 AND RSSEQ          = @LI_RSSEQ

	  -- 새로운 가동 상태 인서트
	  SET @LI_RSSEQ = @LI_RSSEQ +1 -- 새로운 가동 상태니깐 RSSEQ에 새로운 시퀀스 지정'
	  INSERT INTO TP_WorkcenterStatusRec
	  (PLANTCODE, WORKCENTERCODE, ORDERNO, RSSEQ, WORKER
	  , ITEMCODE, STATUS, RSSTARTDATE, MAKER,MAKEDATE)
	  VALUES
	  (@PLANTCODE, @WORKCENTERCODE, @ORDERNO, @LI_RSSEQ, @LS_WORKER
	  , @ITEMCODE, @STATUS, @LS_NOWTIME, @LS_WORKER,@LS_NOWTIME)

	  SET @RS_CODE = 'S'

END                         
GO
