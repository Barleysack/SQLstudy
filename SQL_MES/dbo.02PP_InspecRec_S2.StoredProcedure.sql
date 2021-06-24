USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02PP_InspecRec_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-18
-- Description:	수입검사 상세 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[02PP_InspecRec_S2]
	 @PLANTCODE VARCHAR(10)
	,@INSPNO    VARCHAR(30)

	,@LANG      VARCHAR(10)  = 'KO'
	,@RS_CODE   VARCHAR(1)   OUTPUT
	,@RS_MSG    VARCHAR(200) OUTPUT	
AS
BEGIN
	SELECT A.INSPSEQ			                                 AS SHIPSEQ		  --수입검사 순서
		  ,A.LOTNO				                                 AS LOTNO		  --lot번호
		  ,A.ITEMCODE			                                 AS ITEMCODE	  --품목
		  ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,@LANG)		 AS ITEMNAME	  --품목명		   	  
		  ,A.INSP												 AS INSP		  --수입검사 항목
		  ,A.INSPRESULT_B										 AS INSPRESULT_B  --수입검사 항목 결과
	  FROM TB_4_FERTINSPrec_B A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											 ON A.PLANTCODE = B.PLANTCODE
											AND A.ITEMCODE  = B.ITEMCODE
	 WHERE A.PLANTCODE = @PLANTCODE
	   AND A.INSPNO    = @INSPNO
END
GO
