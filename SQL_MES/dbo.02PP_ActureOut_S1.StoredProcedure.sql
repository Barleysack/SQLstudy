USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02PP_ActureOut_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-10
-- Description:	생산 대상, 작업지시 조회
-- =============================================
CREATE PROCEDURE [dbo].[02PP_ActureOut_S1]
	 @PLANTCODE		VARCHAR(10)
	,@WORKCENTER	VARCHAR(10)
	,@STARTDATE		VARCHAR(10)
	,@ENDDATE		VARCHAR(10)
	,@ORDERNO		VARCHAR(30)

	,@LANG			VARCHAR(10) = 'KO'
	,@RS_CODE		VARCHAR(1)	 OUTPUT
	,@RS_MSG		VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT A.PLANTCODE												AS  PLANTCODE		--공장
		  ,A.ORDERNO												AS  ORDERNO			--작업지시 번호
		  ,A.ITEMCODE												AS	ITEMCODE		--품목 코드
		  ,A.PLANQTY												AS	PLANQTY			--계획수량
		  ,B.PRODQTY												AS	PRODQTY			--양품수량
		  ,B.BADQTY													AS	BADQTY			--불량수량
		  ,A.UNITCODE												AS	UNITCODE		--단위
		  ,B.COMPONENT												AS	COMPONENT		-- 투입품목(원자재에 관한)
		  ,B.COMPONENTQTY											AS	COMPONENTQTY	--투입수량
		  ,B.CUNITCODE												AS	CUNITCODE		--작업장
		  ,A.WORKCENTERCODE											AS 	WORKCENTERCODE	--가동/바가동 상태
		  ,B.STATUS													AS  WORKSTATUSCOE	--가동/비가동 상태
		  ,CASE WHEN B.STATUS = 'R' THEN '가동중' ELSE '비가동' END AS WORKSTATUS		--가동/비가동 
		  ,B.WORKER													AS	WORKER			--작업자
		  ,DBO.FN_WORKERNAME(B.WORKER)								AS	WORKERNAME		--작업자명  (이름으로 코드를 찾아내는 작업)
		  ,B.ORDENDDATE												AS	ENDDATE			--작업지시 종료 시간
		  ,B.ORDSTARTDATE											AS	STARTDATE		--최초 가동 시작 시간
	  FROM TB_ProductPlan A WITH(NOLOCK) LEFT JOIN TP_WorkcenterStatus B WITH(NOLOCK)
												ON A.PLANTCODE		 = B.PLANTCODE
											   AND A.ORDERNO		 = B.ORDERNO
											   AND A.WORKCENTERCODE  = B.WORKCENTERCODE
	WHERE	A.ORDERFLAG					 = 'Y' --작업지시 확정된것
	  AND	ISNULL(A.ORDERCLOSEFLAG,'') <> 'Y'
	  AND	A.PLANTCODE					LIKE '%' + @PLANTCODE  + '%'
	  AND	A.WORKCENTERCODE			LIKE '%' + @WORKCENTER + '%'
	  AND	A.ORDERNO					LIKE '%' + @ORDERNO	   + '%'
	  AND	A.ORDERDATE					BETWEEN @STARTDATE AND @ENDDATE
END
GO
