USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[05WM_StockOUTWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김수연
-- Create date: 2021-06-17
-- Description:	제품 출고 대상 상차 공통 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[05WM_StockOUTWM_S1]
     @PLANTCODE      VARCHAR(10),     --공장 코드
	 @CUSTCODE       VARCHAR(10),	  --거래처 코드
	 @CARNO          VARCHAR(20),	  --상차 차량번호
	 @SHIPNO         VARCHAR(30),	  --상차 번호
	 @STARTDATE      VARCHAR(10),	  --조회 시작
	 @ENDDATE        VARCHAR(10),	  --조회 끝

     @LANG	  VARCHAR(10) ='KO',   --언어
     @RS_CODE VARCHAR(10) OUTPUT,  --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT  --성공 관련 메세지

AS
BEGIN
	SELECT 0				        AS CHK          --체크박스
	     , A.PLANTCODE	            AS PLANTCODE	--공장코드
		 , A.SHIPNO		            AS SHIPNO	    --상차번호
		 , A.SHIPDATE		        AS SHIPDATE	    --상차일자
		 , A.CARNO		            AS CARNO	    --차량번호
		 , A.CUSTCODE	            AS CUSTCODE	    --거래처코드
		 , B.CUSTNAME	            AS CUSTNAME	    --거래처명   
		 --, DBO.FN_CUSTNAME(a.PLANTCODE,a.CUSTCODE) 
		 , A.WORKER		            AS WORKER	    --상차자
		 , A.TRADINGNO		        AS TRADINGNO	--명세서번호
		 , A.TRADINGDATE			AS TRADINGDATE  --출고일자
		 , A.MAKEDATE		        AS MAKEDATE     --등록일시
		 , A.MAKER		            AS MAKER	    --등록자
		 , A.EDITDATE		        AS EDITDATE	    --수정일시
		 , A.EDITOR		            AS EDITOR	    --수정자
	  FROM TB_ShipWM A WITH(NOLOCK) 
	  LEFT JOIN TB_CustMaster B WITH(NOLOCK)
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.CUSTCODE  = B.CUSTCODE

	 WHERE A.PLANTCODE LIKE '%'+ @PLANTCODE   + '%'
	   AND A.SHIPNO    LIKE '%'+ @SHIPNO      + '%'
	   AND A.CARNO     LIKE '%'+ @CARNO       + '%'
	   AND A.CUSTCODE  LIKE '%'+ @CUSTCODE    + '%'
	   AND A.SHIPDATE  BETWEEN @STARTDATE AND @ENDDATE
	   AND A.TRADINGNO IS  NULL

END

GO
