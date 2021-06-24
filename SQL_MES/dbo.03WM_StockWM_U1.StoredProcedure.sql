USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03WM_StockWM_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보민
-- Create date: 210616
-- Description:	상차등록
-- =============================================
CREATE PROCEDURE [dbo].[03WM_StockWM_U1]
	@PLANTCODE  VARCHAR(10) --공장
   ,@WORKER		VARCHAR(30)
   ,@LOTNO	    VARCHAR(30)
   ,@ITEMCODE   VARCHAR(10)
   ,@MAKER		VARCHAR(10)
   ,@STOCKQTY   VARCHAR(10)
   ,@SHIPNO     VARCHAR(30)

   ,@LANG            VARCHAR(10)    ='KO'
   ,@RS_CODE         VARCHAR(1)     OUTPUT
   ,@RS_MSG		     VARCHAR(200)   OUTPUT
AS
BEGIN
	DECLARE @LS_SHIPNO VARCHAR(30)
	DECLARE @LI_SHIPSEQ VARCHAR(30)
	--1. 작업장 등록 작업자 정보 조회
	-- 등록된 작업자 인지 확인
	IF (SELECT COUNT(*)
	  FROM TB_WorkerList WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKERID  = @WORKER) <> 1
	BEGIN
		 SET @RS_CODE = 'E'
		 SET @RS_MSG  = '등록 된 작업자 정보가 아닙니다.'
		 RETURN;
	END


	--2. 거래처 코드 확인

	--3. 이미 상차된 내역 확인
	IF(SELECT ISNULL(SHIPFLAG,'N')
		  FROM TB_StockWM
		  WHERE PLANTCODE = @PLANTCODE
			AND LOTNO	  = @LOTNO) = 'Y'
		  BEGIN
			SET @RS_CODE = 'E'
			SET @RS_MSG  = '이미 상차처리된 차량입니다.'
			RETURN;
		  END
	--4. 상차내역 업데이트
	UPDATE TB_StockWM
	   SET SHIPFLAG ='Y'
		  ,EDITDATE = GETDATE()
		  ,EDITOR   =   @MAKER
	WHERE PLANTCODE = @PLANTCODE
	  AND LOTNO	    = @LOTNO

	--5.상차 번호 채번
	IF @SHIPNO = '0'
	BEGIN
		SET @LS_SHIPNO = 'SHIP' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),' ','')
	END
	ELSE
	BEGIN 
		SET @LS_SHIPNO = @SHIPNO
	END

	--6. 상차내역 등록(상세)
	SELECT @LI_SHIPSEQ = ISNULL(MAX(SHIPSEQ),0) + 1
		FROM TB_SHIPWM_B WITH(NOLOCK) 
	 WHERE PLANTCODE = @PLANTCODE 
	   AND SHIPNO = @LS_SHIPNO 

	INSERT INTO TB_SHIPWM_B (PLANTCODE, SHIPNO, SHIPSEQ, LOTNO, ITEMCODE, SHIPQTY, MAKEDATE, MAKER)
					 VALUES (@PLANTCODE, @LS_SHIPNO, @LI_SHIPSEQ, @LOTNO,@ITEMCODE, @STOCKQTY, GETDATE(), @MAKER)

	SET @RS_CODE = 'S'
	SET @RS_MSG = @LS_SHIPNO
	
END
GO
