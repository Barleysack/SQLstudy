USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03PP_ActureOutput_U33]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		3조 프로젝트
-- Create date: 2021-06-18
-- Description:	고장버튼시 처리
-- =============================================
CREATE PROCEDURE [dbo].[03PP_ActureOutput_U33]
      @PLANTCODE       VARCHAR(10)    -- 공장
     ,@WORKCENTERCODE  VARCHAR(10)    -- 작업장
     ,@WORKER          VARCHAR(30)    -- 작업자
	 ,@ORDERNO         VARCHAR(30)    -- 작업지시번호
	 ,@ITEMCODE        VARCHAR(30)    -- 품목코드
	 ,@MAKER	       VARCHAR(30)    -- 등록자

	 ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT

AS
BEGIN
	-- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
           ,@LS_NOWDATE VARCHAR(10)
		   ,@RUN_ORDERNO VARCHAR(30)
		SET @LD_NOWDATE = GETDATE()  
        SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

    --1. 고장처리된 작업장인지 확인
	IF(SELECT ERRORFLAG
	     FROM TB_WorkCenterMaster WITH(NOLOCK)
		WHERE WORKCENTERCODE = @WORKCENTERCODE) = 'Y'
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '이미 고장 처리된 작업장입니다.'
		RETURN
	END

	--2. 선택한 작업지시의 작업장에 다른 작업지시가 가동중인지 확인하고 ORDERNO 얻기
	SELECT @RUN_ORDERNO = ISNULL(ORDERNO, '')
	      FROM TP_WorkcenterStatus WITH(NOLOCK)
		 WHERE PLANTCODE      = @PLANTCODE
		   AND WORKCENTERCODE = @WORKCENTERCODE
		   AND ORDERNO       <> @ORDERNO
		   AND STATUS         = 'R'
   
    IF(@RUN_ORDERNO IS NULL)
    BEGIN
	  SET @RUN_ORDERNO = @ORDERNO
    END

	--3. 가동 중이라면 해당 작업장을 종료
    UPDATE TP_WorkcenterStatus
       SET STATUS = 'S'
     WHERE PLANTCODE = @PLANTCODE
       AND WORKCENTERCODE = @WORKCENTERCODE
       AND ORDERNO        = @RUN_ORDERNO


	--4. 작업장 별 가동 현황 테이블 TP_WorkcenterStatusRec(선택된 작업장 처리)
	DECLARE @LI_RSSEQ INT
	--선택되어지지 않은 작업장에서 비가동시 처리
	IF (@RUN_ORDERNO != @ORDERNO)
	BEGIN
	SELECT @LI_RSSEQ = ISNULL(MAX(RSSEQ),0)  -- 제일 마지막으로 생성된 SEQ를 사용한다. 왜? 가동 비가동은 여러번 반복될 수 있다.
      FROM TP_WorkcenterStatusRec WITH (NOLOCK)
     WHERE PLANTCODE      = @PLANTCODE
 	  AND WORKCENTERCODE = @WORKCENTERCODE
 	  AND ORDERNO        = @RUN_ORDERNO         -- 세가지 사항이 겹치지 않는 한줄
	  
    -- 이전 가동 정보가 있다면 그 정보에 업데이트
    IF (SELECT COUNT(*)
  	    FROM TP_WorkcenterStatusRec
  	   WHERE PLANTCODE      = @PLANTCODE
  		 AND WORKCENTERCODE = @WORKCENTERCODE
  		 AND ORDERNO        = @RUN_ORDERNO     
  		 AND RSSEQ          = @LI_RSSEQ
  		 AND RSENDDATE IS NULL) <> 0
    BEGIN
    UPDATE TP_WorkcenterStatusRec
       SET RSENDDATE      = @LD_NOWDATE      -- 종료시각만 업데이트 된다는 것
  	   , EDITOR           = @MAKER           -- 작업자
  	   , EDITDATE         = @LD_NOWDATE      -- 등록 시간
     WHERE PLANTCODE      = @PLANTCODE
       AND WORKCENTERCODE = @WORKCENTERCODE
  	   AND ORDERNO        = @RUN_ORDERNO     
  	   AND RSSEQ          = @LI_RSSEQ
    END

	END

	   
    SELECT @LI_RSSEQ = ISNULL(MAX(RSSEQ),0)  -- 제일 마지막으로 생성된 SEQ를 사용한다. 왜? 가동 비가동은 여러번 반복될 수 있다.
      FROM TP_WorkcenterStatusRec WITH (NOLOCK)
     WHERE PLANTCODE      = @PLANTCODE
 	  AND WORKCENTERCODE = @WORKCENTERCODE
 	  AND ORDERNO        = @ORDERNO         -- 세가지 사항이 겹치지 않는 한줄
	  
    -- 이전 가동 정보가 있다면 그 정보에 업데이트
    IF (SELECT COUNT(*)
  	    FROM TP_WorkcenterStatusRec
  	   WHERE PLANTCODE      = @PLANTCODE
  		 AND WORKCENTERCODE = @WORKCENTERCODE
  		 AND ORDERNO        = @ORDERNO     
  		 AND RSSEQ          = @LI_RSSEQ
  		 AND RSENDDATE IS NULL) <> 0
    BEGIN
    UPDATE TP_WorkcenterStatusRec
       SET RSENDDATE      = @LD_NOWDATE      -- 종료시각만 업데이트 된다는 것
  	   , EDITOR           = @MAKER           -- 작업자
  	   , EDITDATE         = @LD_NOWDATE      -- 등록 시간
     WHERE PLANTCODE      = @PLANTCODE
       AND WORKCENTERCODE = @WORKCENTERCODE
  	   AND ORDERNO        = @ORDERNO     
  	   AND RSSEQ          = @LI_RSSEQ
    END

    -- 새로운 가동 상태 인서트
    SET @LI_RSSEQ = @LI_RSSEQ +1 -- 새로운 가동 상태니깐 RSSEQ에 새로운 시퀀스 지정'
    INSERT INTO TP_WorkcenterStatusRec
    (PLANTCODE, WORKCENTERCODE, ORDERNO, RSSEQ, WORKER
    , ITEMCODE, STATUS, RSSTARTDATE, MAKER,MAKEDATE, REMARK)
    VALUES
    (@PLANTCODE, @WORKCENTERCODE, @ORDERNO, @LI_RSSEQ, @WORKER
    , @ITEMCODE, 'S', @LD_NOWDATE, @MAKER,@LD_NOWDATE, '설비 고장')
  
  
  
  
    --5. 해당 작업장 에러처리  
    -- TB_WORKCENTERMASTER에 ERRORFLAG = 'Y'로 업데이트
  	UPDATE TB_WorkCenterMaster
  	   SET ERRORFLAG = 'Y'
  	 WHERE PLANTCODE = @PLANTCODE
  	   AND WORKCENTERCODE = @WORKCENTERCODE


	
	--6. Error 이력 추가
	DECLARE @ER_SEQ VARCHAR(30)
	 SELECT @ER_SEQ = ISNULL(MAX(CONVERT(INT,SEQ)),0)+ 1
	   FROM TB_ErrorRec WITH(NOLOCK)
	  WHERE PLANTCODE      = @PLANTCODE
	    AND WORKCENTERCODE = @WORKCENTERCODE

		
    --TB_ERRORREC 채번
    DECLARE @ERROR_SEQ VARCHAR(30)
      SET   @ERROR_SEQ = 'ERROR' 
  	                + RIGHT(@WORKCENTERCODE,4) + '-' 
  	                + RIGHT('0000' + CONVERT(VARCHAR,@ER_SEQ),4)
	
	-- TB_ERRORREC에 고장이력 생성
	INSERT INTO TB_ErrorRec
	(ERRORSEQ, PLANTCODE, SEQ, WORKCENTERCODE, MAKEDATE, MAKER)
	VALUES
	(@ERROR_SEQ, @PLANTCODE,@ER_SEQ, @WORKCENTERCODE, @LD_NOWDATE,@MAKER)

	
	

	SET @RS_CODE = 'S'
	SET @RS_MSG  = '고장 처리가 완료되었습니다.'

END





GO
