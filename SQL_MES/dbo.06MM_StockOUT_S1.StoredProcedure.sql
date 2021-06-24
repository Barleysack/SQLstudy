USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[06MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      김얼
-- Create date: 2021-06-09
-- Description: 자재 생산 출고 관리
-- =============================================
CREATE PROCEDURE [dbo].[06MM_StockOUT_S1]
   @PLANTCODE   VARCHAR(10)   
  ,@ITEMCODE    VARCHAR(30)
  ,@MATLOTNO    VARCHAR(30)
  ,@STARTDATE   VARCHAR(10)    
  ,@ENDDATE     VARCHAR(10)

   ,@LANG     VARCHAR(5) = 'KO'
   ,@RS_CODE  VARCHAR(1)   OUTPUT
   ,@RS_MSG   VARCHAR(200) OUTPUT
AS
BEGIN
	BEGIN TRY
	SELECT 0 AS CHK,
	       A.PLANTCODE AS PLANTCODE,
		   CONVERT(VARCHAR,A.MAKEDATE,23) AS MAKEDATE,
		   A.ITEMCODE AS ITEMCODE,
		   DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,@LANG),
		   A.MATLOTNO AS MATLOTNO,
		   A.STOCKQTY AS STOCKQTY,
		   A.UNITCODE AS UNITCODE,
		   A.WHCODE AS WHCODE,
		   DBO.FN_WORKERNAME(A.MAKER) AS MAKER
	  FROM TB_StockMM A WITH(NOLOCK)  LEFT JOIN TB_ItemMaster B
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.ITEMCODE = B.ITEMCODE
	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
	   AND A.MATLOTNO	   LIKE '%' + @MATLOTNO  + '%'
	   AND ISNULL(A.STOCKQTY,0)  <> 0
	   AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN @STARTDATE AND @ENDDATE

	   SELECT @RS_CODE = 'S'
     
END TRY                                
BEGIN CATCH
   SELECT @RS_CODE = 'E'
   SELECT @RS_MSG 	= ERROR_MESSAGE()
END CATCH   
END
GO
