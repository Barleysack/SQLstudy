USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-09
-- Description:	자재 생성 출고 조회
-- =============================================
CREATE PROCEDURE [dbo].[18MM_StockOUT_S1]
	 @PLANTCODE       VARCHAR(10)
    ,@ITEMCODE        VARCHAR(20)
    ,@MATLOTNO    	  VARCHAR(30)
    ,@WHCODE	      VARCHAR(20)
    ,@STORAGELOCCODE  VARCHAR(20)
    ,@STARTDATE	      VARCHAR(10)
    ,@ENDDATE	      VARCHAR(10)

	,@LANG            VARCHAR(5)   = 'KO'
	,@RS_CODE         VARCHAR(1)   OUTPUT
	,@RS_MSG          VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT  0 AS CHK
	       ,A.PLANTCODE
		   ,CONVERT(VARCHAR, A.MAKEDATE, 23) AS MAKEDATE
		   ,A.ITEMCODE
		   ,B.ITEMNAME
		   ,A.MATLOTNO AS LOTNO
		   ,A.STOCKQTY
		   ,A.UNITCODE
		   ,A.WHCODE
		   ,DBO.FN_WORKERNAME(A.MAKER) AS MAKER

	  FROM TB_StockMM AS A WITH (NOLOCK)
      JOIN TB_ItemMaster AS B WITH(NOLOCK) 
        ON A.ITEMCODE = B.ITEMCODE 
	   AND A.PLANTCODE = B.PLANTCODE

	 WHERE A.PLANTCODE    LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE     LIKE '%' + @ITEMCODE + '%'
	   AND A.MATLOTNO     LIKE '%' + @MATLOTNO + '%'
	   AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN @STARTDATE AND @ENDDATE
	   AND ISNULL(A.STOCKQTY,0) <> 0
END
GO
