USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[16WM_StockOutWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이진
-- Create date: 2021-06-17
-- Description:	제품 출고 대상 상차 공통 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[16WM_StockOutWM_S1]
	 @PLANTCODE  VARCHAR(10)  --공장
	,@CUSTCODE   VARCHAR(10)  --거래처 코드
	,@STARTDATE  VARCHAR(10)  --조회 시작일자
	,@ENDDAETE   VARCHAR(10)  --조회 종료일자
	,@CARNO      VARCHAR(10)  --차량 번호
	,@SHIPNO     VARCHAR(10)  --상차 번호

	,@LANG       VARCHAR(10)  = 'KO'    --언어
	,@RS_CODE    VARCHAR(1)  OUTPUT     --성공 여부
	,@RS_MSG     VARCHAR(200) OUTPUT    --성공관련메세지
AS
BEGIN
	SELECT  0                                   AS CHK     
		   ,PLANTCODE                           AS PLANTCODE 
		   ,SHIPNO  							AS SHIPNO  
		   ,SHIPDATE							AS SHIPDATE
		   ,CARNO  								AS CARNO  
		   ,CUSTCODE 							AS CUSTCODE 
		   ,DBO.FN_CUSTNAME(PLANTCODE,CUSTCODE) AS CUSTNAME
		   ,WORKER                              AS WORKER                      
		   ,TRADINGNO							AS TRADINGNO
		   ,TRADINGDATE							AS TRADINGDATE
		   ,MAKEDATE							AS MAKEDATE
		   ,MAKER 								AS MAKER 
		   ,EDITDATE 							AS EDITDATE 
		   ,EDITOR   							AS EDITOR   

	  FROM TB_ShipWM WITH(NOLOCK)
	 WHERE PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND CUSTCODE  LIKE '%' + @CUSTCODE  + '%'
	   AND CARNO     LIKE '%' + @CARNO     + '%'
	   AND SHIPNO    LIKE '%' + @SHIPNO    + '%'
	   AND SHIPDATE  BETWEEN @STARTDATE AND @ENDDAETE
	   AND TRADINGNO IS NULL
END
GO
