USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02BM_Inspection_S1]    Script Date: 2021-06-22 오후 5:42:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[02BM_Inspection_S1]
	@PLANTCODE  VARCHAR(10)
   ,@ITEMTYPE   VARCHAR(10)
   ,@ITEMCODE   VARCHAR(20)

   ,@LANG       VARCHAR(10) = 'KO'
   ,@RS_CODE    VARCHAR(1)   OUTPUT
   ,@RS_MSG     VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT A.PLANTCODE                          AS PLANTCODE
		  ,A.ITEMCODE                           AS ITEMCODE
		  ,A.ITEMNAME                           AS ITEMNAME
		  ,B.WHCODE	                            AS WHCODE
		  ,B.STOCKQTY							AS STOCKQTY
		  ,CASE WHEN A.INSPFLAG = 'U' THEN 'Y'	   
		        ELSE 'N' END                 AS INSPFLAG
		  ,B.INSPRESULT                         AS INSPRESULT
	  FROM TB_ItemMaster A WITH(NOLOCK) LEFT JOIN TB_StockPP B WITH (NOLOCK) 
											   ON A.ITEMCODE = B.ITEMCODE
		 WHERE A.ITEMCODE  LIKE '%' + 'KFQS' + '%'
		   AND A.ITEMTYPE  LIKE '%' + 'FERT' + '%'
		   AND A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
		   AND A.ITEMTYPE  LIKE '%' + @ITEMTYPE  + '%'
		   AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
END
GO
