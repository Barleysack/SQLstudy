USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03WM_StockWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보민
-- Create date: 210616
-- Description:	재품 재고 관리 조회
-- =============================================
CREATE PROCEDURE [dbo].[03WM_StockWM_S1]
	@PLANTCODE	VARCHAR(10)
	,@STARTDATE	VARCHAR(10)
	,@ENDDATE	VARCHAR(10)
	,@LOTNO		VARCHAR(30)
	,@ITEMCODE	VARCHAR(30)
	,@SHIPFLAG	VARCHAR(2)

	,@LANG	    VARCHAR(10)  = 'KO'
   ,@RS_CODE	VARCHAR(1)   OUTPUT
   ,@RS_MSG		VARCHAR(200) OUTPUT
AS
BEGIN
SELECT
    CASE WHEN A.SHIPFLAG = 'Y' THEN 1
	     ELSE				0
		 END					AS SHIPCHECK
	,A.PLANTCODE
	,A.ITEMCODE
	,B.ITEMNAME
	,ISNULL(A.SHIPFLAG,'N') AS SHIPFLAG
	,A.LOTNO
	,A.WHCODE
	,A.STOCKQTY
	,B.BASEUNIT
	,CONVERT(VARCHAR, A.MAKEDATE, 23)					AS INDATE
	,A.MAKEDATE
	,A.MAKER
	FROM TB_StockWM A , TB_ItemMaster B
	WHERE A.ITEMCODE = B.ITEMCODE
	  AND A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	  AND A.LOTNO LIKE '%' + @LOTNO+ '%'
	  AND A.ITEMCODE LIKE '%' + @ITEMCODE + '%'
	  AND ISNULL(A.SHIPFLAG,'N') LIKE '%' + @SHIPFLAG + '%'
	  AND A.MAKEDATE  BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'


	SET @RS_MSG = 'S'
END
GO
