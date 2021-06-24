USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19WM_ProdInStock_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-16
-- Description:	제품창고 입고 대상 조회(완제품)
-- =============================================
CREATE PROCEDURE [dbo].[19WM_ProdInStock_S1]
     @PLANTCODE   VARCHAR(10),     --공장 코드
	 @STARTDATE	  VARCHAR(30),	   --시작 일자
	 @ENDDATE     VARCHAR(30),	   --종료 일자
	 @ITEMCODE    VARCHAR(20),     --품목 코드

     @LANG	  VARCHAR(10) ='KO',   --언어
     @RS_CODE VARCHAR(10) OUTPUT,  --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT  --성공 관련 메세지

AS
BEGIN
	SELECT 0                                           AS CHK        -- 출고 체크박스
		 , A.PLANTCODE                                 AS PLANTCODE  -- 공장 코드
		 , A.LOTNO     		                           AS LOTNO	     -- LOT 번호
		 , A.ITEMCODE  		                           AS ITEMCODE	 -- 품목 코드
		 , B.ITEMNAME  		                           AS ITEMNAME	 -- 품목 명
		 , A.STOCKQTY  		                           AS STOCKQTY	 -- 완제품 수량
		 , B.BASEUNIT  		                           AS UNITCODE	 -- 단위
		 , A.MAKEDATE  		                           AS MAKEDATE	 -- 등록일시
		 , DBO.FN_CODENAME('ITEMTYPE',B.ITEMTYPE,'KO') AS ITEMTYPE	 -- 품목 코드
		 , DBO.FN_CODENAME('WHCODE',A.WHCODE,'KO')     AS WHCODE	 -- 창고 코드
		 , DBO.FN_WORKERNAME(A.MAKER)     		       AS MAKER	     -- 등록자

	  FROM TB_StockPP A WITH(NOLOCK) 
	  LEFT JOIN TB_ItemMaster B 
	    ON A.PLANTCODE= B.PLANTCODE
	   AND A.ITEMCODE = B.ITEMCODE

	 WHERE A.PLANTCODE LIKE '%'+ @PLANTCODE + '%'
	   AND B.ITEMCODE  LIKE '%'+ @ITEMCODE  + '%'
	   AND A.MAKEDATE BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'
	   AND B.ITEMTYPE = 'FERT'
END

GO
