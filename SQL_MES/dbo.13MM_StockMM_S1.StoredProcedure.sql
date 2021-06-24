USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[13MM_StockMM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		원지윤
-- Create date: 2021.06,08
-- Description:	자재 재고 현황
-- =============================================
CREATE PROCEDURE [dbo].[13MM_StockMM_S1]
	 @PLANTCODE VARCHAR(20)
	,@ITEMCODE  VARCHAR(20)
	,@ITEMNAME  VARCHAR(20)
AS
BEGIN
	SELECT A.PLANTCODE
		  ,A.ITEMCODE
		  ,B.ITEMNAME
		  ,A.MATLOTNO
		  ,A.WHCODE
		  ,A.STOCKQTY
		  ,A.CUSTCODE
		  ,C.CUSTNAME
		  ,A.MAKER
		  ,A.MAKEDATE
	  FROM TB_StockMM A
	      ,TB_ItemMaster B
		  ,TB_CustMaster C
	 WHERE A.ITEMCODE = B.ITEMCODE 
	  AND  A.CUSTCODE = C.CUSTCODE
	  AND  B.ITEMTYPE = 'ROH'
	  AND A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	  AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
	  AND B.ITEMNAME  LIKE '%' + @ITEMNAME  + '%'
END
GO
