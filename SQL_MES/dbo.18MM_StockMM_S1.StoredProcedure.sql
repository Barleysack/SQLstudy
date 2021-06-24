USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18MM_StockMM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-08
-- Description:	자재 재고 현황 조회
-- =============================================
CREATE PROCEDURE [dbo].[18MM_StockMM_S1]
     @PLANTCODE  VARCHAR(10),  --공장 코드
     @ITEMCODE   VARCHAR(20),  --품목 코드
     @ITEMNAME   VARCHAR(20),  --품목 이름

	 --패키지 DB helper 내부에 자동으로 추가되도록 시스템을 만들어 뒀음
	 --parameter 까먹지 말고 설정해주어야한다.
     @LANG	  VARCHAR(10) ='KO',  --언어
     @RS_CODE VARCHAR(10) OUTPUT, --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT --성공 관련 메세지

AS
BEGIN
	SELECT A.PLANTCODE,                               --공장 코드
	       A.ITEMCODE,	                              --작업자 ID
		   B.ITEMNAME,	                              --작업자 이름
		   A.MATLOTNO,		                          --작업 반
		   A.WHCODE,		                          --그룹 ID
		   A.STOCKQTY,                                --부서코드
		   A.UNITCODE,		                          --연락처
		   A.CUSTCODE,	                              --입사일자
		   C.CUSTNAME,                                --퇴사일자
		   --A.MAKER,                                   --사용여부
		   DBO.FN_WORKERNAME(A.MAKER) AS MAKER,       --등록자 , LEFT JOIN 1번 함수를 사용하여 JOIN없이도 사용할 수 있게 한다.
		   A.MAKEDATE	                              --등록일시
	  FROM TB_StockMM AS A WITH(NOLOCK)
LEFT JOIN TB_ItemMaster AS B WITH(NOLOCK) ON A.ITEMCODE = B.ITEMCODE 
LEFT JOIN TB_CustMaster AS C WITH(NOLOCK) ON A.CUSTCODE = C.CUSTCODE 

	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE  + '%'
	   AND A.ITEMCODE  LIKE '%' + @ITEMCODE   + '%'
	   AND B.ITEMNAME  LIKE '%' + @ITEMNAME   + '%'
	   AND B.ITEMTYPE  = 'ROH'
END
GO
