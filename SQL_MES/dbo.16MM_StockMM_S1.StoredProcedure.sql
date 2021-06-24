USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[16MM_StockMM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이진
-- Create date: 2021-06-09
-- Description:	자재 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[16MM_StockMM_S1]
	 @PLANTCODE   VARCHAR(10)  --공장
	,@ITEMCODE    VARCHAR(30)   --품목 
	,@ITEMNAME    VARCHAR(30)  --품목 명
	
	,@LANG       VARCHAR(10)  = 'KO'    --언어
	,@RS_CODE    VARCHAR(1)  OUTPUT   --성공 여부
	,@RS_MSG     VARCHAR(200) OUTPUT    --성공관련메세지
AS
BEGIN

	SELECT A.PLANTCODE, A.ITEMCODE, B.ITEMNAME, A.MATLOTNO, A.WHCODE, A.STOCKQTY, A.UNITCODE, A.CUSTCODE, C.CUSTNAME, A.MAKER , A.MAKEDATE 
	  FROM TB_StockMM A WITH(NOLOCK) JOIN TB_ItemMaster B WITH(NOLOCK)
									   ON A.ITEMCODE = B.ITEMCODE
						             JOIN TB_CustMaster C WITH(NOLOCK)
						               ON A.CUSTCODE = C.CUSTCODE
	  
	  WHERE A.PLANTCODE  LIKE '%' + @PLANTCODE + '%' 
	  AND   A.ITEMCODE   LIKE '%' + @ITEMCODE    + '%'
	  AND   B.ITEMNAME   LIKE '%' + @ITEMNAME  + '%'
	  AND   B.ITEMTYPE = 'ROH'

END
GO
