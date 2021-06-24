USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-09
-- Description:	자재 생산 출고 관리 조회
-- =============================================
CREATE PROCEDURE [dbo].[19MM_StockOUT_S1]
     @PLANTCODE   VARCHAR(10),     --공장 코드
     @ITEMCODE    VARCHAR(20),     --품목 코드
     @MATLOTNO    VARCHAR(30),     --LOT번호
     @STARTDATE   VARCHAR(30),     --조회시작
     @ENDDATE    VARCHAR(30),     --조회끝

	 --패키지 DB helper 내부에 자동으로 추가되도록 시스템을 만들어 뒀음
	 --parameter 까먹지 말고 설정해주어야한다.
     @LANG	  VARCHAR(10) ='KO',   --언어
     @RS_CODE VARCHAR(10) OUTPUT,  --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT  --성공 관련 메세지

AS
BEGIN
	SELECT 0                               AS CHK
	     , A.PLANTCODE                     AS PLANTCODE -- 공장
		 , CONVERT(VARCHAR, A.MAKEDATE,23) AS MAKEDATE
		 , A.ITEMCODE                      AS ITEMCODE
		 , B.ITEMNAME
		 , A.MATLOTNO
		 , A.STOCKQTY
		 , A.UNITCODE
		 , A.WHCODE
		 , DBO.FN_WORKERNAME(A.MAKER)      AS MAKER
	  FROM TB_StockMM A WITH(NOLOCK) 
	  JOIN TB_ItemMaster B 
	    ON A.PLANTCODE= B.PLANTCODE
	   AND A.ITEMCODE = B.ITEMCODE

	 WHERE A.PLANTCODE LIKE '%'+ @PLANTCODE +'%'
	   AND A.ITEMCODE  LIKE '%'+ @ITEMCODE  +'%'
	   AND A.MATLOTNO  LIKE '%'+ @MATLOTNO  +'%'
	   AND CONVERT(VARCHAR, A.MAKEDATE,23) BETWEEN @STARTDATE AND @ENDDATE
	   AND ISNULL(STOCKQTY,0) <> 0


END

GO
