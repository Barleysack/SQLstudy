USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[WM_4_Inspection_S2]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-18
-- Description:	LOT별 검사내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[WM_4_Inspection_S2]
	@LOTNO VARCHAR(30) -- LOTNO

   ,@LANG      VARCHAR(10)  = 'KO'
   ,@RS_CODE   VARCHAR(1)   OUTPUT
   ,@RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN
	SELECT 0            AS CHK
	      ,A.PLANTCODE  AS PLANTCODE
		  ,A.ITEMCODE   AS ITEMCODE
		  ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,'KO') AS ITEMNAME
		  ,B.INSPCODE 	AS INSPCODE
		  ,ISNULL(B.INSPDETAIL,'E')	AS INSPDETAIL
		  --,A.STOCKQTY   AS STOCKQTY

	  FROM TB_StockPP A WITH(NOLOCK) LEFT JOIN TB_4_INSPItem B WITH(NOLOCK)
	                                        ON A.PLANTCODE = B.PLANTCODE
										   AND A.ITEMCODE  = B.ITEMCODE
	 WHERE A.LOTNO = @LOTNO
	
END
GO
