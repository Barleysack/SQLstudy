USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[06PP_StockPP_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      김얼
-- Create date: 2021-06-09
-- Description: 자재 생산 출고 관리
-- =============================================
CREATE PROCEDURE [dbo].[06PP_StockPP_S1]
   @PLANTCODE   VARCHAR(10)   
  ,@ITEMTYPE    VARCHAR(30)
  ,@LOTNO    VARCHAR(30)

   ,@LANG     VARCHAR(5) = 'KO'
   ,@RS_CODE  VARCHAR(1)   OUTPUT
   ,@RS_MSG   VARCHAR(200) OUTPUT
AS
BEGIN
	BEGIN TRY
	BEGIN 
	SELECT 0 AS CHK,
	       A.PLANTCODE AS PLANTCODE,
		   CONVERT(VARCHAR,A.MAKEDATE,23) AS MAKEDATE,
		   A.ITEMCODE AS ITEMCODE,
		   B.ITEMNAME AS ITEMNAME,
		   A.LOTNO AS LOTNO,
		   B.ITEMTYPE AS ITEMTYPE,
		   A.STOCKQTY AS STOCKQTY,
		   A.UNITCODE AS UNITCODE,
		   A.WHCODE AS WHCODE,
		   DBO.FN_WORKERNAME(A.MAKER) AS MAKER	
	  FROM TB_StockPP A WITH(NOLOCK)  LEFT JOIN TB_ItemMaster B
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.ITEMCODE = B.ITEMCODE
	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND B.ITEMTYPE  LIKE '%' + @ITEMTYPE  + '%'
	   AND A.LOTNO  LIKE '%' + @LOTNO  + '%'
	   AND ISNULL(A.STOCKQTY,0) <> 0
	END

	SELECT @RS_CODE = 'S'
     
END TRY                                
BEGIN CATCH
   SELECT @RS_CODE = 'E'
   SELECT @RS_MSG 	= ERROR_MESSAGE()
END CATCH   
END
GO
