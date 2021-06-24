USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19AP_ProductPlan_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-09
-- Description:	생산 및 계획 및 작업지시 편성 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[19AP_ProductPlan_S1]
     @PLANTCODE			  VARCHAR(10),     --공장 코드
     @WORKCENTERCODE    VARCHAR(10),     --작업장 코드
     @ORDERNO			  VARCHAR(20),     --주문 번호
	 @ORDERCLOSEFLAG      VARCHAR(1),      --주문 처리상태
    
	 --패키지 DB helper 내부에 자동으로 추가되도록 시스템을 만들어 뒀음
	 --parameter 까먹지 말고 설정해주어야한다.
     @LANG	  VARCHAR(10) ='KO',   --언어
     @RS_CODE VARCHAR(10) OUTPUT,  --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT  --성공 관련 메세지

AS
BEGIN
	SELECT PLANTCODE                                       --공장
		 , PLANNO                                          --계획번호
		 , ITEMCODE                                        --품목코드
		 , PLANQTY                                         --계획수량
	     , UNITCODE                                        --단위
	     , WORKCENTERCODE                                  --작업장
		 , ORDERNO                                         --작업지시
		 , ORDERDATE                                       --확정일시
		 , ORDERCLOSEFLAG                                  --지시종료 여부
		 , CASE WHEN ISNULL(ORDERFLAG,'N') = 'Y' THEN 1	   
		        ELSE 0 END                 AS CHK          --선택
		 , DBO.FN_WORKERNAME(ORDERWORKER)  AS ORDERWORKER  -- 확정자
		 , DBO.FN_WORKERNAME(A.MAKER)      AS MAKER	       -- 등록자
		 , CONVERT(VARCHAR,A.MAKEDATE,120) AS MAKEDATE     -- 등록일시
		 , DBO.FN_WORKERNAME(A.EDITOR)     AS EDITOR	   -- 수정자
		 , CONVERT(VARCHAR,A.EDITDATE,120) AS EDITDATE     -- 수정일시
		 

	  FROM TB_ProductPlan A  WITH(NOLOCK)
	 WHERE PLANTCODE                 LIKE '%'+ @PLANTCODE +'%'
	   AND WORKCENTERCODE            LIKE '%'+ @WORKCENTERCODE  +'%'
	   AND ISNULL(ORDERNO,'')        LIKE '%'+ @ORDERNO  +'%'
	   AND ISNULL(ORDERCLOSEFLAG,'') LIKE '%'+ @ORDERCLOSEFLAG  +'%'

END

GO
