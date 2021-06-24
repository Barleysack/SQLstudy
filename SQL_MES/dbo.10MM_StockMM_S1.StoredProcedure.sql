USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10MM_StockMM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<마상우>
-- Create date: <Create Date,,>
-- Description:	작업자 마스터 조회
-- =============================================
CREATE PROCEDURE [dbo].[10MM_StockMM_S1]
	-- Add the parameters for the stored procedure here
	@PLANTCODE  VARCHAR(10),        --공장
	@ITEMCODE   VARCHAR(30),
	@ITEMNAME   VARCHAR(20),


	@LANG       VARCHAR(10) = 'KO',   -- 언어
	@RS_CODE    VARCHAR(10) output,          -- 성공여부
	@RS_MSG     VARCHAR(200) output          -- 성공관련 메세지

AS
BEGIN
	SELECT A.PLANTCODE,
		   A.ITEMCODE,
		   B.ITEMNAME,
		   A.MATLOTNO,
		   A.WHCODE,
		   A.STOCKQTY,
		   A.UNITCODE,
		   A.CUSTCODE,
		   C.CUSTNAME,
		   A.MAKER,
		   A.MAKEDATE
	  FROM TB_StockMM A WITH(NOLOCK) 
		LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
	    ON A.ITEMCODE = B.ITEMCODE
		LEFT JOIN TB_CustMaster C WITH(NOLOCK)
		ON A.CUSTCODE = C.CUSTCODE
	  WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	    AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
		AND B.ITEMNAME  LIKE '%' + @ITEMNAME  + '%'
		AND B.ITEMTYPE = 'ROH'
	 



END
GO
