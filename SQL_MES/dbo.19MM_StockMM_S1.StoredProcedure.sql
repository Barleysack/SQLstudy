USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19MM_StockMM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-08
-- Description:	입출력 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[19MM_StockMM_S1]
     @PLANTCODE   VARCHAR(10),     --공장 코드
     @ITEMCODE    VARCHAR(20),     --품목 코드
     @ITEMNAME    VARCHAR(30),     --품목 명
    
	 --패키지 DB helper 내부에 자동으로 추가되도록 시스템을 만들어 뒀음
	 --parameter 까먹지 말고 설정해주어야한다.
     @LANG	  VARCHAR(10) ='KO',   --언어
     @RS_CODE VARCHAR(10) OUTPUT,  --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT  --성공 관련 메세지

AS
BEGIN
	SELECT A.PLANTCODE
		 , A.ITEMCODE 
		 , B.ITEMNAME 
		 , A.MATLOTNO
		 , A.WHCODE  
		 , A.STOCKQTY 
		 , A.UNITCODE
		 , A.CUSTCODE
		 , C.CUSTNAME
		 , DBO.FN_WORKERNAME(A.MAKER)      AS MAKER	     -- 등록자
		 , CONVERT(VARCHAR,A.MAKEDATE,120) AS MAKEDATE   -- 등록일시
	  FROM TB_StockMM A WITH(NOLOCK) 
	  JOIN TB_ItemMaster B 
	    ON A.ITEMCODE = B.ITEMCODE
	  JOIN TB_CustMaster C
		ON A.CUSTCODE = C.CUSTCODE
	 WHERE A.PLANTCODE LIKE '%'+ @PLANTCODE +'%'
	   AND A.ITEMCODE  LIKE '%'+ @ITEMCODE  +'%'
	   AND B.ITEMNAME  LIKE '%'+ @ITEMNAME  +'%'
	   AND  B.ITEMTYPE ='ROH';

END

GO
