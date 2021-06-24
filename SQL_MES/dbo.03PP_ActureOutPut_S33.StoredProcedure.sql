USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03PP_ActureOutPut_S33]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		3조 프로젝트
-- Create date: 2021-06-18
-- Description:	생산 대상. 작업지시 조회, ERROR버튼
-- =============================================
CREATE PROCEDURE [dbo].[03PP_ActureOutPut_S33]
     @PLANTCODE      VARCHAR(10),     --공장 코드
     @WORKCENTERCODE VARCHAR(10),     --작업장 코드
     @STARTDATE      VARCHAR(10),     --시작 일자
     @ENDDATE        VARCHAR(10),     --끝 일자
     @ORDERNO        VARCHAR(30),     --작업 지시 번호

     @LANG	  VARCHAR(10) ='KO',      --언어
     @RS_CODE VARCHAR(10) OUTPUT,     --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT     --성공 관련 메세지

AS
BEGIN
	SELECT A.PLANTCODE								 AS PLANTCODE       --공장
	     , A.ORDERNO								 AS ORDERNO			--작업 지시 번호
		 , A.ITEMCODE								 AS ITEMCODE		--품목 코드
		 , A.PLANQTY								 AS PLANQTY			--계획 수량
		 , B.PRODQTY								 AS PRODQTY			--양품 수량
		 , B.BADQTY									 AS BADQTY			--불량 수량
		 , A.UNITCODE								 AS UNITCODE		--단위
		 , B.INLOTNO								 AS MATLOTNO		--단위
		 , B.COMPONENT								 AS COMPONENT		--투입 품목
		 , B.COMPONENTQTY							 AS COMPONENTQTY	--투입 수량
		 , B.CUNITCODE								 AS CUNITCODE		--투입 단위
		 , A.WORKCENTERCODE							 AS WORKCENTERCODE	--작업장 
		 , B.STATUS									 AS WORKSTATUSCODE  --가동/비가동 상태
		 , CASE WHEN B.STATUS = 'R' THEN '가동중'
		   ELSE '비가동'  END                        AS WORKSTATUS      --가동/비가동 상태
		 , ISNULL(C.ERRORFLAG, 'N')                  AS ERRORFLAG       --고장/정상 상태
		 , B.WORKER                                  AS WORKER 			--작업자
		 , DBO.FN_WORKERNAME(B.WORKER)               AS WORKERNAME		--작업자명
		 , B.ORDSTARTDATE							 AS ORDSTARTDATE    --최초 가동 시작 시간
		 , B.ORDENDDATE								 AS ORDENDDATE		--작업 지시 종료 시간
	  
	  FROM TB_ProductPlan A WITH(NOLOCK) 			
	  LEFT JOIN TP_WorkcenterStatus B WITH(NOLOCK)
	    ON A.PLANTCODE      = B.PLANTCODE
	   AND A.ORDERNO        = B.ORDERNO
	   AND A.WORKCENTERCODE = B.WORKCENTERCODE
	  LEFT JOIN TB_WorkCenterMaster C WITH(NOLOCK)
	    ON A.PLANTCODE = C.PLANTCODE
	   AND A.WORKCENTERCODE = C.WORKCENTERCODE

		WHERE  A.ORDERFLAG                    =  'Y'
			  AND ISNULL(A.ORDERCLOSEFLAG,'') <> 'Y'
			  AND A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
			  AND A.WORKCENTERCODE            LIKE '%' + @WORKCENTERCODE + '%'
			  AND A.ORDERNO                   LIKE '%' + @ORDERNO        + '%'
			  AND A.ORDERDATE                 BETWEEN @STARTDATE AND @ENDDATE


END
GO
