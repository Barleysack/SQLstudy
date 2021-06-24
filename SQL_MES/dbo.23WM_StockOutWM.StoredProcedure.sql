USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[23WM_StockOutWM]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		한정은
-- Create date: 2021-06-17
-- Description:	제품 출고 대상 상차 공통 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[23WM_StockOutWM]
	@PLANTCODE   Varchar(10) -- 공장
	,@CUSTCODE   Varchar(10) -- 거래처 코드
	,@STARTDATE	 Varchar(10) -- 조회 시작일자
	,@ENDDATE	 Varchar(10) -- 조회 종료일자
	,@CARNO		 Varchar(20) -- 차량 번호
	,@SHIPNO	 Varchar(30) -- 상차번호

	,@LANG      VARCHAR(10)  = 'KO'
    ,@RS_CODE   VARCHAR(1)   OUTPUT
    ,@RS_MSG    VARCHAR(200) OUTPUT
	
AS
BEGIN
	SELECT 0									 AS CHK
	       ,PLANTCODE                            AS PLANTCODE
	       ,SHIPNO								 AS SHIPNO	
	       ,SHIPDATE							 AS SHIPDATE
	       ,CARNO								 AS CARNO	
	       ,CUSTCODE							 AS CUSTCODE
	       ,DBO.FN_CUSTNAME(PLANTCODE, CUSTCODE) AS CUSTNAME
	       ,WORKER								 AS WORKER		
	       ,TRADINGNO							 AS	TRADINGNO	
	       ,TRADINGDATE							 AS	TRADINGDATE	
	       ,MAKEDATE							 AS	MAKEDATE	
	       ,MAKER								 AS	MAKER		
	       ,EDITDATE							 AS	EDITDATE	
	       ,EDITOR								 AS	EDITOR		
		FROM TB_ShipWM WITH(NOLOCK)
		WHERE PLANTCODE LIKE '%' + @PLANTCODE + '%'
		AND   CUSTCODE  LIKE '%' + @CUSTCODE  + '%'
		AND   CARNO     LIKE '%' + @CARNO     + '%'
		AND   SHIPNO    LIKE '%' + @SHIPNO    + '%'
		AND   SHIPDATE  BETWEEN @STARTDATE AND @ENDDATE
		AND   TRADINGNO IS NULL




















END
GO
