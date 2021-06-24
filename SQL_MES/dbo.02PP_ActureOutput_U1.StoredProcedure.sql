USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02PP_ActureOutput_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-11
-- Description:	가동/비가동 등록
-- =============================================
CREATE PROCEDURE [dbo].[02PP_ActureOutput_U1]
	 @PLANTCODE      VARCHAR(10) --공장
	,@WORKCENTERCODE VARCHAR(10) --작업장
	,@ORDERNO        VARCHAR(20) --작업지시
	,@ITEMCODE       VARCHAR(30) --생산 품목
	,@UNITCODE       VARCHAR(10) --생산 단위
	,@STATUS		 VARCHAR(1)  --상태

	,@LANG            VARCHAR(10)  ='KO'
    ,@RS_CODE         VARCHAR(1)   OUTPUT
    ,@RS_MSG          VARCHAR(200) OUTPUT	
AS
BEGIN
		-- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
	       ,@LS_WORKER  VARCHAR(20)
	   SET @LD_NOWDATE = GETDATE()
	   SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

	--작업자 등록 여부 가져오기
	SELECT @LS_WORKER = WORKER
	  FROM TP_WorkcenterStatus WITH(NOLOCK)
	 WHERE PLANTCODE	= @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO		  = @ORDERNO

	IF(ISNULL(@LS_WORKER,'') = '')
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '투입 작업자의 정보가 없습니다.'
		RETURN;
	END

	--선택 작업장이 가동 중인지 확인
	IF(SELECT COUNT(*)
		 FROM TP_WorkcenterStatus WITH(NOLOCK)
		WHERE PLANTCODE	= @PLANTCODE
		  AND WORKCENTERCODE = @WORKCENTERCODE
		  AND ORDERNO		 <> @ORDERNO -- 내가 선택한 작업지시 외에 돌아가고 있는 상태가 있으면 등록하지 마라.(작업자, 작업장, 작업지시)
		  AND STATUS		 = 'R') <> 0
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '해당 작업장에 가동이 진행중인 작업지시가 있습니다.'
		RETURN;
	END

	--최초 가동 시 상태 테이블에 가동 시간 등록
	UPDATE TP_WorkcenterStatus  --작업장 작업지시 별 상태 테이블, 작업자/lot번호 투입하면서 insert해서 여기서는 update 맞나??
	   SET STATUS		    = @STATUS
	      ,ORDSTARTDATE     = CASE WHEN ORDSTARTDATE IS NULL  -- 작업 시작을 안누른 상태
		                           THEN @LS_NOWDATE ELSE ORDSTARTDATE END  --THEN : 현재 시간을 오더 시간, ELSE : ORDSTARTDATE 원래 있던 값
	 WHERE PLANTCODE	    = @PLANTCODE
	   AND WORKCENTERCODE   = @WORKCENTERCODE
	   AND ORDERNO			= @ORDERNO
	
	--작업장 별 가동 현환 테이블 TP_WorcenterStatusRec
	DECLARE @LI_RSSEQ INT
	 SELECT @LI_RSSEQ = ISNULL(MAX(RSSEQ),0)  -- 업데이트 될 제일 마지막 SEQ를 찾는 것, 0인것은 안하겠다는 뜻, 0이면 가동/비가동을 전혀 선택 안한것
	   FROM TP_WorkcenterStatusRec WITH(NOLOCK)
	  WHERE PLANTCODE		= @PLANTCODE
	    AND WORKCENTERCODE	= @WORKCENTERCODE
		AND ORDERNO			= @ORDERNO

	--이전 가동 정보 업데이트
	UPDATE TP_WorkcenterStatusRec -- RSSEQ가 0이면 update 안함
	   SET RSENDDATE		= @LD_NOWDATE
	      ,EDITDATE			= @LD_NOWDATE
		  ,EDITOR			= @LS_WORKER
	 WHERE PLANTCODE		= @PLANTCODE
	   AND WORKCENTERCODE	= @WORKCENTERCODE
	   AND ORDERNO			= @ORDERNO
	   AND RSSEQ			= @LI_RSSEQ
	
	--새로운 가동 상태 인서트
	SET @LI_RSSEQ	= @LI_RSSEQ + 1
	INSERT INTO TP_WorkcenterStatusRec(PLANTCODE, WORKCENTERCODE, ORDERNO, RSSEQ, WORKER, ITEMCODE, STATUS, RSSTARTDATE, MAKER,MAKEDATE)
							   VALUES(@PLANTCODE, @WORKCENTERCODE, @ORDERNO, @LI_RSSEQ, @LS_WORKER, @ITEMCODE, @STATUS, @LD_NOWDATE, @LS_WORKER,@LS_NOWDATE)

	SET @RS_CODE = 'S'
END
GO
