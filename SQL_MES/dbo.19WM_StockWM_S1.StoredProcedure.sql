USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19WM_StockWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-16
-- Description:	상차 할 제품 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[19WM_StockWM_S1]
     @PLANTCODE   VARCHAR(10),     --공장 코드
	 @LOTNO       VARCHAR(20),	   --LOT 번호
	 @ITEMCODE    VARCHAR(20),	   --품목 코드
	 @YESNO       VARCHAR(20),	   --품목 코드
	 @STARTDATE   VARCHAR(20),	   --조회 시작
	 @ENDDATE     VARCHAR(20),	   --조회 끝

     @LANG	  VARCHAR(10) ='KO',   --언어
     @RS_CODE VARCHAR(10) OUTPUT,  --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT  --성공 관련 메세지

AS
BEGIN
	SELECT CASE WHEN  ISNULL(A.SHIPFLAG,'N') = 'N' 
				THEN 0 
				ELSE 1 END AS CHK       --체크박스
	     , A.PLANTCODE                     AS PLANTCODE	--공장코드
		 , A.ITEMCODE                      AS ITEMCODE	--품목코드
		 , B.ITEMNAME					   AS ITEMNAME	--품목명
		 , ISNULL(A.SHIPFLAG,'N')          AS YESNO	    --상차여부
		 , A.LOTNO					       AS LOTNO		--LOT번호
		 , A.WHCODE					       AS WHCODE	--창고번호
		 , A.STOCKQTY					   AS STOCKQTY	--재고수량
		 , B.BASEUNIT					   AS UNITCODE	--단위
		 , A.MAKEDATE					   AS MAKEDATE	--등록일자
		 , A.MAKER						   AS MAKER		--등록자
	  FROM TB_StockWM A WITH(NOLOCK) 
	  LEFT JOIN TB_ItemMaster B 
	    ON A.PLANTCODE= B.PLANTCODE
	   AND A.ITEMCODE = B.ITEMCODE

	 WHERE A.PLANTCODE LIKE '%'+ @PLANTCODE   + '%'
	   AND A.LOTNO     LIKE '%'+ @LOTNO       + '%'
	   AND ISNULL(A.SHIPFLAG,'N')  LIKE '%'+ @YESNO       + '%'
	   AND A.ITEMCODE  LIKE '%'+ @ITEMCODE    + '%'
	   AND CONVERT(VARCHAR,A.MAKEDATE,23)  BETWEEN @STARTDATE AND @ENDDATE
	   AND ISNULL(STOCKQTY,0) <> 0


END

SELECT * FROM TB_StockWM
GO
