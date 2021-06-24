USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[13WM_StockWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		원지윤
-- Create date: 2021.06.16
-- Description:	제품창고 입고 등록
-- =============================================
CREATE PROCEDURE [dbo].[13WM_StockWM_S1]
	  @PLANTCODE VARCHAR(10)
	 ,@LOTNO     VARCHAR(30)
	 ,@ITEMCODE  VARCHAR(30)
	 ,@SHIPFLAG  VARCHAR(1)
	 ,@STARTDATE VARCHAR(10)
	 ,@ENDDATE   VARCHAR(10)

     ,@LANG      VARCHAR(10)  = 'KO'
     ,@RS_CODE   VARCHAR(1)   OUTPUT
     ,@RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN
	 SELECT CASE WHEN A.SHIPFLAG = 'Y' THEN 1
				 ELSE 0
			END								AS CHK       
		   ,A.PLANTCODE						AS PLANTCODE 
		   ,A.ITEMCODE						AS ITEMCODE  
		   ,B.ITEMNAME						AS ITEMNAME  
		   ,ISNULL(A.SHIPFLAG,'N')			AS SHIPFLAG  
		   ,A.LOTNO							AS LOTNO	 
		   ,A.WHCODE					    AS WHCODE	 
		   ,A.STOCKQTY						AS STOCKQTY  
		   ,B.BASEUNIT						AS UNITCODE  
		   ,A.MAKEDATE						AS INDATE  
		   ,DBO.FN_WORKERNAME(A.MAKER)      AS MAKER  
	 FROM TB_StockWM A WITH(NOLOCK) 
	 LEFT JOIN TB_ItemMaster B
	 ON  A.PLANTCODE = B.PLANTCODE
	 AND A.ITEMCODE  = B.ITEMCODE

	   WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	     AND A.LOTNO     LIKE '%' + @LOTNO     + '%'
	     AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
		 AND ISNULL(A.SHIPFLAG,'') LIKE '%' + '' + '%'
	     AND A.MAKEDATE  BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'

		SET @RS_CODE = 'S'

END

GO
