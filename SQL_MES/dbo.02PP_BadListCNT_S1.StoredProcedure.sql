USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02PP_BadListCNT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-21
-- Description:	수입검사 진행 품목 조회
-- =============================================
CREATE PROCEDURE [dbo].[02PP_BadListCNT_S1]
	 @PLANTCODE	    VARCHAR(10)
	,@ITEMCODE	    VARCHAR(30)	

	,@LANG          VARCHAR(10) = 'KO'
	,@RS_CODE	    VARCHAR(1)    OUTPUT
	,@RS_MSG	    VARCHAR(200)  OUTPUT

AS
BEGIN

	SELECT DISTINCT PLANTCODE									AS PLANTCODE
				   ,ITEMCODE									AS ITEMCODE
				   ,DBO.FN_ITEMNAME(ITEMCODE,PLANTCODE,@LANG)	AS ITEMNAME	  --품목명		  
			   FROM TB_4_FERTINSPrec_B WITH(NOLOCK)
			  WHERE PLANTCODE    LIKE '%' + @PLANTCODE + '%'
			    AND ITEMCODE     LIKE '%' + @ITEMCODE  + '%'
				AND INSPRESULT_B LIKE '%' + 'N' + '%'

END
GO
