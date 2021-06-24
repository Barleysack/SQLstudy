USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[24MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		홍건의
-- Create date: 2021-06-10
-- Description:	조회
-- =============================================
CREATE PROCEDURE [dbo].[24MM_StockOUT_S1]
	@PLANTCODE  VARCHAR(10) 
	,@STARTDATE VARCHAR(10) 
	,@ENDDATE   VARCHAR(20) 
	,@ITEMCODE  VARCHAR(30)
	,@MATLOTNO  VARCHAR(30)
	
	,@LANG      VARCHAR(5) = 'OK'
	,@RS_CODE   VARCHAR(1)   OUTPUT
	,@RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN
	SELECT   0                                AS CHK 
			,A.PLANTCODE                      AS PLANCODE
			,CONVERT(VARCHAR, A.MAKEDATE, 23) AS MAKEDATE
			,A.ITEMCODE                       AS ITEMCODE
			,B.ITEMNAME                       AS ITEMNAME
			,A.MATLOTNO                       AS MATLOTNO
			,A.STOCKQTY                       AS STOCKQTY
			,A.UNITCODE                       AS UNITCODE
			,A.WHCODE                         AS WHCODE
			,DBO.FN_WORKERNAME(A.MAKER) AS MAKER
		FROM TB_StockMM A WITH (NOLOCK) 
		LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
	    ON A.PLANTCODE = B.PLANTCODE
		AND A.ITEMCODE  = B.ITEMCODE
	    WHERE A.PLANTCODE LIKE '%' + @PLANTCODE  + '%'
	    AND A.ITEMCODE    LIKE '%' + @ITEMCODE   + '%'
	    AND MATLOTNO      LIKE '%' + @MATLOTNO   + '%'
	    AND Convert(VARCHAR, A.MAKEDATE, 23) BETWEEN @STARTDATE AND @ENDDATE
	    AND ISNULL(STOCKQTY, 0) <> 0

END
GO
