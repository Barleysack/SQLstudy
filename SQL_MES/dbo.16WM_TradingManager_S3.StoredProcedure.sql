USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[16WM_TradingManager_S3]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이진
-- Create date: 2021-06-21
-- Description:	거래 명세표 발행을 위한 데이터 조회
-- =============================================
CREATE PROCEDURE [dbo].[16WM_TradingManager_S3]
     @PLANTCODE       VARCHAR(10),     --공장 코드
	 @TRADINGNO       VARCHAR(30),	   --거래 번호
	
     @LANG	  VARCHAR(10) ='KO',   --언어
     @RS_CODE VARCHAR(10) OUTPUT,  --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT  --성공 관련 메세지

AS
BEGIN
	SELECT A.TRADINGSEQ									   AS ROWNO
	     , A.TRADINGNO							           AS TRADINGNO
		 , A.ITEMCODE									   AS ITEMCODE
		 , DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE, 'KO')   AS ITEMNAME
		 , B.CARNO										   AS CARNO
		 , CONVERT(VARCHAR,A.MAKEDATE,120)				   AS MAKEDATE
		 , DBO.FN_WORKERNAME(A.MAKER)					   AS MAKER
		 , A.LOTNO										   AS LOTNO
		 , A.TRADINGQTY									   AS TRADINGQTY
		 , DBO.FN_CUSTNAME(A.PLANTCODE,B.CUSTCODE)         AS CUSTNAME

	  FROM TB_TradingWM_B A WITH(NOLOCK)
	  LEFT JOIN TB_ShipWM B WITH(NOLOCK)
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.SHIPNO    = B.SHIPNO

	 WHERE A.PLANTCODE = @PLANTCODE
	   AND A.TRADINGNO = @TRADINGNO

END

GO
