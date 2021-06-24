USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[24WM_StockWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		홍건의
-- Create date: 2021-06-16
-- Description:	상차 등록 조회
-- =============================================
CREATE PROCEDURE [dbo].[24WM_StockWM_S1]
	 @PLANTCODE	     VARCHAR(10)
    ,@LOTNO		     VARCHAR(30)
	,@STARTDATE	     VARCHAR(10)
	,@ENDDATE        VARCHAR(10)
	,@SHIPFLAG		 VARCHAR(1)

    ,@LANG           VARCHAR(10)  = 'KO'
    ,@RS_CODE        VARCHAR(1)   OUTPUT
    ,@RS_MSG         VARCHAR(200) OUTPUT
AS
BEGIN
	DECLARE @LD_STARTDATE DATETIME
	      , @LD_ENDDATE   DATETIME

     SELECT @LD_STARTDATE =  CONVERT(DATETIME,@STARTDATE + ' 00:00:00')
	       ,@LD_ENDDATE   =  CONVERT(DATETIME,@ENDDATE + ' 23:59:59')
	SELECT CASE WHEN ISNULL(A.SHIPFLAG,'Y') ='Y' THEN 1
				ELSE 0 END                   AS CHK
	      ,A.PLANTCODE						 AS PLANTCODE
		  ,A.ITEMCODE						 AS ITEMCODE
		  ,B.ITEMNAME						 AS ITEMNAME
		  ,A.SHIPFLAG						 AS SHIPFLAG
		  ,A.LOTNO							 AS LOTNO
		  ,A.WHCODE							 AS WHCODE
		  ,A.STOCKQTY						 AS STOCKQTY
		  ,B.BASEUNIT						 AS BASEUNIT
		  ,CONVERT(VARCHAR, A.MAKEDATE, 23)  AS INDATE
		  ,A.MAKEDATE						 AS MAKEDATE
		  ,A.MAKER							 AS MAKER 
	  FROM TB_StockWM A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											ON A.PLANTCODE = B.PLANTCODE
										   AND A.ITEMCODE  = B.ITEMCODE
     WHERE 
	   A.PLANTCODE                          LIKE '%' + @PLANTCODE + '%'
	   AND A.LOTNO                          LIKE '%' + @LOTNO     + '%'
	   AND ISNULL(A.SHIPFLAG,'')            LIKE '%' + @SHIPFLAG  + '%'
END

GO
