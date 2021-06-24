USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02PP_BadListCNT_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-21
-- Description:	NG 품목 및 항목 조회
-- =============================================
CREATE PROCEDURE [dbo].[02PP_BadListCNT_S2]
	 @PLANTCODE VARCHAR(10)
	,@ITEMCODE VARCHAR(20)
	,@INSPRESULT_B VARCHAR(1)

	,@LANG          VARCHAR(10) = 'KO'
	,@RS_CODE	    VARCHAR(1)    OUTPUT
	,@RS_MSG	    VARCHAR(200)  OUTPUT
AS
BEGIN
	SELECT PLANTCODE	AS PLANTCODE
	      ,ITEMCODE		AS ITEMCODE
		 -- ,DBO.FN_ITEMNAME(ITEMCODE,PLANTCODE,@LANG)	AS ITEMNAME	  --품목명		  
		  ,INSP			AS INSP
		  ,COUNT(*)		AS NGCOUNT 
	  FROM TB_4_FERTINSPrec_B with(nolock) 
	 WHERE ITEMCODE     LIKE '%' + @ITEMCODE + '%'
	   AND PLANTCODE    LIKE '%' + @PLANTCODE + '%'
	   AND INSPRESULT_B LIKE '%' + @INSPRESULT_B + '%'
	   AND LOTNO        LIKE '%' + 'LTFERT'	 + '%'
	 GROUP BY PLANTCODE, ITEMCODE, INSP
END
GO
