USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[15WM_StockWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이승수
-- Create date: 2021-06-16
-- Description:	제공제품 관리 및 조회
-- =============================================
CREATE PROCEDURE [dbo].[15WM_StockWM_S1]
	@PLANTCODE		VARCHAR(10)
   ,@SHIPFLAG		VARCHAR(10)
   ,@STARTDATE		VARCHAR(20)
   ,@ENDDATE		VARCHAR(20)
   ,@LOTNO			VARCHAR(30)

   ,@LANG			VARCHAR(10) = 'KO'
   ,@RS_CODE		VARCHAR(1)   OUTPUT
   ,@RS_MSG			VARCHAR(200) OUTPUT

AS
BEGIN
	SELECT CASE WHEN A.SHIPFLAG = 'Y' THEN 1 ELSE 0 END AS CHK
		  ,A.PLANTCODE									AS PLANTCODE	
		  ,A.ITEMCODE									AS ITEMCODE	
		  ,B.ITEMNAME									AS ITEMNAME	
		  ,CASE WHEN A.SHIPFLAG = 'Y' THEN '[Y]예'
		   ELSE '[N]아니오' END							AS SHIPFLAG	
		  ,A.LOTNO										AS LOTNO		
		  ,A.WHCODE										AS WHCODE		
		  ,A.STOCKQTY									AS STOCKQTY	
		  ,B.BASEUNIT									AS UNITCODE	
		  ,CONVERT(VARCHAR,A.MAKEDATE,23)				AS INDATE
		  ,A.MAKEDATE									AS MAKEDATE
		  ,A.MAKER										AS MAKER
	  FROM TB_StockWM A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											ON A.PLANTCODE = B.PLANTCODE
										   AND A.ITEMCODE  = B.ITEMCODE
	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE  LIKE '%' + @SHIPFLAG  + '%'
	   AND A.MAKEDATE  BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:50:59'
	   AND A.LOTNO	   LIKE '%' + @LOTNO  + '%'

								
END
GO
