USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[16WW_StockWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이진
-- Create date: 2021-06-16
-- Description:	제품 재고 관리 및 상차 등록 조회
-- =============================================
CREATE PROCEDURE [dbo].[16WW_StockWM_S1]
	 @PLANTCODE  VARCHAR(10)
	,@ITEMCODE   VARCHAR(30)
	,@STARTDATE  VARCHAR(10)
	,@ENDDATE    VARCHAR(10)
	,@LOTNO      VARCHAR(10)
	,@SHIPFLAG   VARCHAR(10)

	,@LANG     VARCHAR(10) ='KO'   --언어
    ,@RS_CODE VARCHAR(10) OUTPUT  --성공 여부
    ,@RS_MSG  VARCHAR(200) OUTPUT  --성공 관련 메세지


AS
BEGIN
	SELECT CASE
		       WHEN  ISNULL(A.SHIPFLAG,'N') = 'N' THEN 0 
			   ELSE 1 
			END                                   AS CHK       --체크박스           
	      ,A.PLANTCODE
		  ,A.ITEMCODE
		  ,B.ITEMNAME
		  , ISNULL(A.SHIPFLAG,'N') AS SHIPFLAG
		  ,A.LOTNO
		  ,A.WHCODE
		  ,A.STOCKQTY
		  ,B.BASEUNIT
		  ,A.MAKEDATE
		  ,A.MAKER 
	  FROM TB_StockWM A LEFT JOIN TB_ItemMaster B 
							   ON A.PLANTCODE = B.PLANTCODE
							  AND A.ITEMCODE  = B.ITEMCODE
	 
	 WHERE A.PLANTCODE LIKE '%'+ @PLANTCODE   + '%'
       AND A.LOTNO     LIKE '%'+ @LOTNO       + '%'
       AND A.ITEMCODE  LIKE '%'+ @ITEMCODE    + '%'
	   AND ISNULL(A.SHIPFLAG,'N')  LIKE '%'+ @SHIPFLAG  + '%'
       AND CONVERT(VARCHAR,A.MAKEDATE,23)  BETWEEN @STARTDATE AND @ENDDATE
       AND ISNULL(STOCKQTY,0) <> 0


END
GO
