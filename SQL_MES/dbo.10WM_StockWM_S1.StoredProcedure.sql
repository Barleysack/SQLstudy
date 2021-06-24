USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10WM_StockWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		마상우
-- Create date: 2021-06-16
-- Description:	제품 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[10WM_StockWM_S1]
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
	 SELECT CASE WHEN 
			 A.SHIPFLAG = 'Y' THEN 1
	        ELSE 0 END					            AS CHK		   --체크박스
		   ,A.PLANTCODE                            AS PLANTCODE   --공장 
		   ,A.ITEMCODE                             AS ITEMCODE    --품목 코드 
		   ,B.ITEMNAME                             AS ITEMNAME    --품명 
		   ,ISNULL(A.SHIPFLAG ,'N')                AS SHIPFLAG    --상차 여부 
		   ,A.LOTNO                                AS LOTNO       --LOTNO 
		   ,A.WHCODE                               AS WHCODE      --창고 번호 
		   ,A.STOCKQTY                             AS STOCKQTY    --재고 수량 
		   ,B.BASEUNIT                             AS BASEUNIT    --단위 
		   ,CONVERT(VARCHAR, A.MAKEDATE, 23)       AS INDATE      --입고일자 
		   ,A.MAKEDATE                             AS MAKEDATE    --등록일시 
		   ,A.MAKER                                AS MAKER       --등록자 


	 FROM TB_StockWM A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B
											 ON A.PLANTCODE = B.PLANTCODE
											AND A.ITEMCODE  = B.ITEMCODE

	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND A.LOTNO     LIKE '%' + @LOTNO     + '%'
	   AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
	   AND ISNULL(A.SHIPFLAG,'') LIKE '%' + @SHIPFLAG  + '%'
	  -- AND A.MAKEDATE  BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'

END
GO
