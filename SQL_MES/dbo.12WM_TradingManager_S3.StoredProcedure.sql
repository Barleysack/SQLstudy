USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[12WM_TradingManager_S3]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	출하 거래 명세서 출력
-- =============================================
CREATE PROCEDURE [dbo].[12WM_TradingManager_S3]
		@PLANTCODE  VARCHAR(10),
		@TRADINGNO  VARCHAR(30),

		@LANG		VARCHAR(10) = 'KO',
		@RS_CODE	VARCHAR(1)   OUTPUT,
		@RS_MSG		VARCHAR(200) OUTPUT
	
AS
BEGIN
	SELECT A.TRADINGSEQ								        AS ROWNO
		  ,A.TRADINGNO								        AS TRADINGNO
		  ,A.ITEMCODE									    AS ITEMCODE
		  ,DBO.FN_ITEMNAME(A.ITEMCODE, A.PLANTCODE, 'KO')   AS ITEMNAME
		  ,A.TRADINGQTY								        AS TRADINGQTY
		  ,DBO.FN_CUSTNAME(A.PLANTCODE, B.CUSTCODE)			AS CUSTNAME
		  ,DBO.FN_WORKERNAME(A.MAKER)						AS MAKER
		  ,B.CARNO											AS CARNO
		  ,CONVERT(VARCHAR, A.MAKEDATE,120)					AS MAKEDATE

	  FROM TB_TradingWM_B A WITH(NOLOCK) LEFT JOIN TB_ShipWM B WITH(NOLOCK)
												ON A.PLANTCODE = B.PLANTCODE
											   AND A.SHIPNO	   = B.SHIPNO
	 WHERE A.PLANTCODE = @PLANTCODE
	   AND A.TRADINGNO = @TRADINGNO

END
GO
