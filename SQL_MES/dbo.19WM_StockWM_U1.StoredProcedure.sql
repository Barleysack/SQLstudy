USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19WM_StockWM_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-16
-- Description:	상차 등록 , 저장 프로시져
-- =============================================
CREATE PROCEDURE [dbo].[19WM_StockWM_U1]
  @PLANTCODE       VARCHAR(10),      -- 공장번호
  @LOTNO           VARCHAR(30),      -- LOT 번호
  @ITEMCODE        VARCHAR(30),      -- 품목 코드
  @CUSTCODE        VARCHAR(30),      -- 거래처 코드
  @CARNO       	   VARCHAR(30), 	 -- 상차 차량 번호
  @STOCKQTY        FLOAT,            -- 수량
  @WORKER          VARCHAR(30), 	 -- 담당자
  @SHIPNO          VARCHAR(30),      -- 채번 번호
  @LANG      VARCHAR(10) ='KO',
  @RS_CODE   VARCHAR(1) OUTPUT,
  @RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN 
	--현재시간 정의
    DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
		   ,@LI_SHIPSEQ INT
	    SET @LD_NOWTIME = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)
	
	--VALIDATION CHECK

	--이미 상차된 내역인지 확인
	   IF (SELECT SHIPFLAG
		   FROM TB_StockWM WITH(NOLOCK)
		   WHERE PLANTCODE = @PLANTCODE
		     AND LOTNO = @LOTNO) = 'Y'
	   BEGIN
		  SET @RS_CODE = 'E'
		  SET @RS_MSG  = '이미 상차된 내역입니다.'
		  RETURN
	   END


	-- 상차 번호 채번
	DECLARE @LS_SHIPNO VARCHAR(30)
	IF @SHIPNO = '0'
	BEGIN
		SET @LS_SHIPNO = 'SHIP' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),' ','')
			BEGIN
			INSERT INTO TB_ShipWM
			(PLANTCODE, SHIPNO, CARNO, SHIPDATE, CUSTCODE, WORKER, MAKEDATE, MAKER)
			VALUES
			(@PLANTCODE, @LS_SHIPNO,@CARNO, @LS_NOWDATE, @CUSTCODE, @WORKER, @LD_NOWTIME, @WORKER )
			END
    END
	ELSE
	BEGIN 
		SET @LS_SHIPNO = @SHIPNO
	END

	-- 상차 내역 UPDATE
	 UPDATE TB_StockWM
	   SET SHIPFLAG = 'Y'
	 WHERE PLANTCODE = @PLANTCODE 
	   AND LOTNO = @LOTNO


	-- 상차 내역 등록(상세)
	SELECT @LI_SHIPSEQ = ISNULL(MAX(SHIPSEQ),0)+1
	  FROM TB_ShipWM_B WITH (NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND SHIPNO = @LS_SHIPNO

	INSERT INTO TB_ShipWM_B
	(PLANTCODE, SHIPNO, SHIPSEQ, LOTNO, ITEMCODE, SHIPQTY, MAKEDATE, MAKER)
	VALUES
	(@PLANTCODE, @LS_SHIPNO,@LI_SHIPSEQ, @LOTNO, @ITEMCODE, @STOCKQTY, @LD_NOWTIME, @WORKER )

	SET @RS_MSG = @LS_SHIPNO

	SELECT @RS_CODE = 'S'

END 
 
GO
