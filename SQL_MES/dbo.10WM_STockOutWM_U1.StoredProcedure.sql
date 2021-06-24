USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10WM_STockOutWM_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<마상우>
-- Create date: <2021-06-17>
-- Description:	<출고대상 상차 공통내역 기준 출고처리 및 명세서 번호 발행>
-- =============================================
CREATE PROCEDURE [dbo].[10WM_STockOutWM_U1]
	@PLANTCODE VARCHAR(10)
   ,@SHIPNO    VARCHAR(30)
   ,@TRADINGNO VARCHAR(30)
   ,@MAKER	   VARCHAR(20)

   ,@LANG      VARCHAR(10) = 'KO'
   ,@RS_CODE   VARCHAR(1)   OUTPUT
   ,@RS_MSG    VARCHAR(200) OUTPUT
AS
BEGIN
	-- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
           ,@LS_NOWDATE VARCHAR(10)
		SET @LD_NOWDATE = GETDATE()  
        SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)
	
	-- 이미 출고된 내역인지 확인
	DECLARE @LS_TRADINGNO VARCHAR(30)

	SELECT @LS_TRADINGNO = TRADINGNO
	  FROM TB_ShipWM WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND SHIPNO    = @SHIPNO
	IF ISNULL(@LS_TRADINGNO,'') <> ''
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '이미 출고 처리된 상차 번호 입니다. : '  + @SHIPNO
		RETURN;
	END

	-- 상차 취소된 내역인지 확인
	IF (SELECT COUNT(*)
	      FROM TB_ShipWM WITH(NOLOCK)
		 WHERE PLANTCODE = @PLANTCODE
		   AND SHIPNO   = @SHIPNO) = 0
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '취소 된 상차 번호 입니다. : '  + @SHIPNO
		RETURN;
	END


	DECLARE @LS_CARNO	 VARCHAR(20) -- 차량번호
	       ,@LS_CUSTCODE VARCHAR(10) -- 거래처 코드

	SELECT @LS_CARNO    = CARNO
	      ,@LS_CUSTCODE = CUSTCODE
	  FROM TB_ShipWM WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND SHIPNO    = @SHIPNO


	-- 가장 첫 행일 경우 거래명세 번호 채번 및 공통내역 등록
	IF ISNULL(@TRADINGNO,'') = ''
	BEGIN
		SET @LS_TRADINGNO = 'INVO' 
		                + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),' ','')
        -- 거래 명세 헤더 등록
		INSERT INTO TB_TradingWM (PLANTCODE,   TRADINGNO,     TRADINGDATE,   CARNO,      MAKEDATE,		MAKER)
						   VALUES(@PLANTCODE,  @LS_TRADINGNO, @LS_NOWDATE,   @LS_CARNO,  @LD_NOWDATE,	@MAKER) 
	END

	DECLARE @LI_TRADINGSEQ   INT		  -- 거래명세 순번
	       ,@LS_LOTNO        VARCHAR(30)  -- 제품 LOT
		   ,@LS_ITEMCODE     VARCHAR(30)  -- 제품 품목코드
		   ,@LF_SHIPQTY      FLOAT        -- 출고수량
		   ,@LI_INOUTSEQ     INT	      -- 제품창고 출고 순번
		   ,@LS_UNITCODE     VARCHAR(10)  -- 단위
		   ,@LS_FINTRADINGNO VARCHAR(30)  -- 신규/기존 거래명세 번호
	
	SET @LS_FINTRADINGNO = ISNULL(@LS_TRADINGNO,@TRADINGNO)


	SET @RS_CODE = 'S'
END

GO
