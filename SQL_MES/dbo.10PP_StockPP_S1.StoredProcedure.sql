USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10PP_StockPP_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<마상우>
-- Create date: <2021-06-10>
-- Description:	자재생산출고관리 조회
-- =============================================
CREATE PROCEDURE [dbo].[10PP_StockPP_S1]
	-- Add the parameters for the stored procedure here
	 @PLANTCODE			 VARCHAR(10) -- 공장      
	,@ITEMTYPE       	 VARCHAR(10) -- 품목
	,@MATLOTNO 			 VARCHAR(20) -- LOTNO
	
	,@LANG				 VARCHAR(5)    = 'KO'
	,@RS_CODE			 VARCHAR(1)   OUTPUT
	,@RS_MSG			 VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT 0 AS CHK 
	       ,A.PLANTCODE
		   ,CONVERT(VARCHAR, A.MAKEDATE, 23) AS MAKEDATE
		   ,A.ITEMCODE
	       ,B.ITEMNAME
	       ,A.MATLOTNO
		   ,B.ITEMTYPE
	       ,A.STOCKQTY
	       ,A.UNITCODE
	       ,A.WHCODE
	       ,DBO.FN_WORKERNAME(A.MAKER)	AS MAKER
  FROM TB_StockMM A , TB_ItemMaster B
    WHERE A.PLANTCODE = B.PLANTCODE
      AND A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
      AND B.ITEMTYPE  LIKE '%' + @ITEMTYPE + '%'
	  AND A.MATLOTNO  LIKE '%' + @MATLOTNO + '%'
      AND ISNULL(STOCKQTY,0) <> 0



	SET @RS_CODE = 'S'

END
GO
