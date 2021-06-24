USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02AP_ProductPlan_S1]    Script Date: 2021-06-22 오후 5:42:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-09
-- Description:	생산 계획 및 작업 지시 편성 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[02AP_ProductPlan_S1]
	@PLANTCODE	    VARCHAR(10)		 -- 공장
   ,@WORKCENTERCODE VARCHAR(10) -- 작업장
   ,@ORDERNO		VARCHAR(20)			 -- 작업지시 번호
   ,@ORDERCLOSEFLAG VARCHAR(1)		 -- 작업지시 종료 여부

   ,@LANG			VARCHAR(5) = 'KO'
   ,@RS_CODE		VARCHAR(1) OUTPUT
   ,@RS_MSG			VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT PLANTCODE												--공장
		       ,PLANNO													--계획번호
		       ,ITEMCODE												--품목코드
		       ,PLANQTY													--계획수량
		       ,UNITCODE													--단위
		       ,WORKCENTERCODE									--작업장
		       ,CASE WHEN ISNULL(ORDERFLAG,'N') = 'Y' THEN 1
				 ELSE 0 END				   AS CHK					--선택
			   ,ORDERNO													--작업지시
			   ,ORDERDATE												--확정일시
			   ,DBO.FN_WORKERNAME(ORDERWORKER) AS ORDERWORKER	--확정자
			   ,ORDERCLOSEFLAG																	--지시종료 여부
			   ,DBO.FN_WORKERNAME(MAKER)       AS MAKER	--등록자
			   ,CONVERT(VARCHAR, MAKEDATE, 120)	  AS MAKEDATE				--등록 일시
			   ,DBO.FN_WORKERNAME(EDITOR)	   AS EDITOR		--수정자
			   ,CONVERT(VARCHAR, EDITDATE, 120)		 AS EDITDATE			--수정일시
	  FROM TB_ProductPlan WITH(NOLOCK)
	 WHERE PLANTCODE							  LIKE '%' + @PLANTCODE			 + '%'
	   AND WORKCENTERCODE                 LIKE '%' + @WORKCENTERCODE + '%'
	   AND ISNULL(ORDERNO,'')				  LIKE '%' + @ORDERNO				 + '%'  --처음엔 오더가 없으니 null이 들어가 있다.
	   AND ISNULL(ORDERCLOSEFLAG,'')   LIKE '%' + @ORDERCLOSEFLAG    + '%'  --ORDERCLOSEFLAG만 작성 하고 새로 추가하면, 
																		--지시종료여부 값이 Y, N이 없는 NULL임. 그래서 ISNULL
END
GO
