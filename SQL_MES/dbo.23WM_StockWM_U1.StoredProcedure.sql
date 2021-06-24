USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[23WM_StockWM_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		한정은
-- Create date: 2021-06-16
-- Description:	저장
-- =============================================
CREATE PROCEDURE [dbo].[23WM_StockWM_U1]
	 @PLANTCODE  VARCHAR(10) -- 공장
	,@ITEMCODE  VARCHAR(20) -- 품목
	,@LOTNO	    VARCHAR(20)	-- LOT번호
	,@CARNO		VARCHAR(10) -- 차량번호
	,@CUSTCODE	VARCHAR(30) -- 거래처명
	,@WORKER	VARCHAR(10) -- 작업자 코드 MAKER로 받기.
	,@SHIPQTY   FLOAT
	,@EDITOR    VARCHAR(10) -- 수정자
	,@SHIPNO    VARCHAR(30)

    ,@LANG      VARCHAR(10)  = 'KO'
    ,@RS_CODE   VARCHAR(1)   OUTPUT
    ,@RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN
	-- 현재 시간 정의
		DECLARE @LD_NOWDATE DATETIME
			,@LS_NOWDATE VARCHAR(10)
		SET @LD_NOWDATE = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE, 23) 

	-- 등록된 작업자인지 확인
	IF (SELECT COUNT(*)
		FROM TB_STOCKWM WITH(NOLOCK)
		WHERE PLANTCODE = @PLANTCODE
		AND MAKER = @WORKER) = 0 
	BEGIN 
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '등록된 작업자가 없습니다.: ' + @WORKER
		RETURN;
	END

	-- 거래처 존재여부 확인
	IF (SELECT COUNT(*)
		FROM TB_CustMaster WITH(NOLOCK)
		WHERE PLANTCODE = @PLANTCODE
		   AND CUSTCODE = @CUSTCODE) = 0

	BEGIN 
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '거래처 정보가 없습니다.: ' + @CUSTCODE
		RETURN;
	END

	DECLARE @LS_SHIPNO VARCHAR(30)
	IF (ISNULL(@SHIPNO,'') = '')
	BEGIN
	    --상차 번호 채번 
	    SET @LS_SHIPNO = 'SHIP' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),' ','')
	    
	    --상차 내역 등록(공통)
	    	INSERT INTO TB_SHIPWM (PLANTCODE,  SHIPNO,	   CARNO,	SHIPDATE,    CUSTCODE,  WORKER,    MAKEDATE,    MAKER) 
	    	               VALUES (@PLANTCODE, @LS_SHIPNO, @CARNO,  @LS_NOWDATE, @CUSTCODE, @WORKER,   @LS_NOWDATE, @EDITOR)
    END
	--상차 내역 등록(상세)
	DECLARE @LI_SHIPSEQ INT
	SELECT @LI_SHIPSEQ = ISNULL(MAX(SHIPSEQ),0) + 1
			FROM TB_SHIPWM_B WITH(NOLOCK) 
			WHERE PLANTCODE = @PLANTCODE 
			  AND SHIPNO    = @LS_SHIPNO 
	
	INSERT INTO TB_SHIPWM_B (PLANTCODE,  SHIPNO,     SHIPSEQ,     LOTNO,    ITEMCODE,    SHIPQTY, MAKEDATE,     MAKER)
	                  VALUES(@PLANTCODE, @LS_SHIPNO, @LI_SHIPSEQ, @LOTNO,   @ITEMCODE,   @SHIPQTY, @LD_NOWDATE, @EDITOR)
    SET @RS_MSG = ISNULL(@LS_SHIPNO,@SHIPNO)
	SET @RS_CODE = 'S'
END
GO
