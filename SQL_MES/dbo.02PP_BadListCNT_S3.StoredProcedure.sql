USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02PP_BadListCNT_S3]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-21
-- Description:	NG 항목 정보 조회
-- =============================================
CREATE PROCEDURE [dbo].[02PP_BadListCNT_S3]	
	@ITEMCODE    VARCHAR(20)
   ,@INSP		 VARCHAR(200)

   ,@LANG        VARCHAR(10) = 'KO'
   ,@RS_CODE	 VARCHAR(1)    OUTPUT
   ,@RS_MSG	     VARCHAR(200)  OUTPUT
AS
BEGIN
	SELECT A.ITEMCODE				    AS ITEMCODE
	      ,B.LOTNO						AS LOTNO
		  ,A.WORKCENTERCODE				AS WORKCENTERCODE
		  ,DBO.FN_WORKERNAME(C.MAKER)	AS MAKER 
		  ,C.MAKEDATE					AS MAKEDATE
	  FROM TP_LotTracking A WITH(NOLOCK) LEFT JOIN TB_4_FERTINSPrec_B B WITH(NOLOCK)
									          ON A.LOTNO     = B.LOTNO
											 AND A.PLANTCODE = B.PLANTCODE
											 AND A.ITEMCODE  = B.ITEMCODE
										 LEFT JOIN TP_WorkcenterPerProd C WITH(NOLOCK)
										        ON A.ORDERNO   = C.ORDERNO
											   AND A.PLANTCODE = C.PLANTCODE
											   AND A.LOTNO     = C.LOTNO
	  WHERE A.ITEMCODE     LIKE '%' +  @ITEMCODE + '%' 
	    AND B.INSP         = @INSP
		AND B.INSPRESULT_B LIKE '%' + 'N'       + '%'
		AND B.LOTNO        LIKE '%' + 'LTFERT'	 + '%'

--	SELECT A.ITEMCODE				    AS ITEMCODE
--	      ,B.LOTNO						AS LOTNO
--		  ,B.WORKCENTERCODE				AS WORKCENTERCODE
--		  ,DBO.FN_WORKERNAME(C.MAKER)	AS MAKER 
--		  ,C.MAKEDATE					AS MAKEDATE
--	  FROM TB_4_FERTINSPrec_B A WITH(NOLOCK) LEFT JOIN TP_LotTracking B WITH(NOLOCK)
--									          ON A.LOTNO     = B.LOTNO
--											 AND A.PLANTCODE = B.PLANTCODE
--											 AND A.ITEMCODE  = B.ITEMCODE
--										 LEFT JOIN TP_WorkcenterPerProd C WITH(NOLOCK)
--										        ON B.ORDERNO   = C.ORDERNO
--											   AND A.PLANTCODE = C.PLANTCODE
--											   AND B.LOTNO     = C.LOTNO
--	  WHERE A.ITEMCODE     LIKE '%' +  @ITEMCODE + '%' 
--	    AND A.INSP         =   @INSP
--		AND A.INSPRESULT_B LIKE '%' + 'N'       + '%'
--		AND A.LOTNO        LIKE '%' + 'LTFERT'	 + '%'
END
GO
