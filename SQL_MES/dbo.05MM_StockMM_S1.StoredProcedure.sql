USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[05MM_StockMM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김수연
-- Create date: 2021-06-07
-- Description:	자재 재고 현황 조회
-- =============================================
CREATE PROCEDURE [dbo].[05MM_StockMM_S1]
	@PLANTCODE  VARCHAR(10),          -- 공장 코드
	@ITEMCODE   VARCHAR(20),          -- 품목 코드
	@ITEMNAME   VARCHAR(100),		  -- 품목 명

	@LANG VARCHAR(10) = 'KO',
	@RS_CODE VARCHAR(1) OUTPUT,
	@RS_MSG  VARCHAR(200) OUTPUT

	
AS
BEGIN
	SELECT A.PLANTCODE,
		   A.ITEMCODE ,
		   B.ITEMNAME ,
		   A.MATLOTNO ,
		   A.WHCODE   ,
		   A.STOCKQTY ,
		   A.UNITCODE ,
		   A.CUSTCODE ,
		   C.CUSTNAME ,
		   A.MAKER,
		   A.MAKEDATE

	FROM TB_StockMM AS A WITH(NOLOCK) LEFT JOIN TB_ItemMaster AS B WITH(NOLOCK)
		ON A.ITEMCODE = B.ITEMCODE
		LEFT JOIN TB_CustMaster AS C WITH(NOLOCK)
		ON A.CUSTCODE=C.CUSTCODE

	WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	  AND A.ITEMCODE LIKE '%' + @ITEMCODE + '%'
	  AND B.ITEMNAME LIKE '%' + @ITEMNAME + '%'
	  AND B.ITEMTYPE = 'ROH'

END
GO
