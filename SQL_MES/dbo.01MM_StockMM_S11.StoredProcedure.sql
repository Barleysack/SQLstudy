USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[01MM_StockMM_S11]    Script Date: 2021-06-22 오후 5:42:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강유정
-- Create date: 2021-06-07
-- Description:	자재 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[01MM_StockMM_S11]
	@PLANTCODE VARCHAR(10),
	@ITEMCODE VARCHAR(20),
	@ITEMNAME VARCHAR(20),

	@LANG VARCHAR(10) = 'KO',
	@RS_CODE VARCHAR(10) OUTPUT,   -- 성공여부
	@RS_MSG VARCHAR(200) OUTPUT    -- 성공여부 관련 메세지
AS
BEGIN
	SELECT A.PLANTCODE, 
		   B.ITEMCODE,
		   B.ITEMNAME,
		   A.MATLOTNO,
		   A.WHCODE,
		   A.STOCKQTY,
		   A.UNITCODE,
		   A.CUSTCODE,
		   C.CUSTNAME, 
		   DBO.FN_WORKERNAME(A.MAKER) AS MAKER, 
		   A.MAKEDATE, 
		   DBO.FN_WORKERNAME(A.EDITOR) AS EDITOR, 
		   A.EDITDATE 
	FROM TB_STOCKMM A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B
										  ON A.PLANTCODE  = B.PLANTCODE
										 AND A.ITEMCODE   = B.ITEMCODE
	                               LEFT JOIN TB_CustMaster C WITH(NOLOCK)
								          ON A.CUSTCODE   = C.CUSTCODE
										 AND A.PLANTCODE  = C.PLANTCODE
	
	WHERE B.ITEMTYPE LIKE 'ROH'
	  AND A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	  AND B.ITEMCODE LIKE '%' + @ITEMCODE + '%'
	  AND B.ITEMNAME LIKE '%' + @ITEMNAME + '%'

	
END
GO
