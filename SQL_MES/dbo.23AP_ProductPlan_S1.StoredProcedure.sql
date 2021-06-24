USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[23AP_ProductPlan_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		한정은
-- Create date: 2021-06-09
-- Description:	생산 계획 및 작업지기 편성 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[23AP_ProductPlan_S1]
	@PLANTCODE       VARCHAR(10) --공장
	,@WORKCENTERCODE VARCHAR(10) --작업장
	,@ORDERNO        VARCHAR(20) --작업지시 번호
	,@ORDERCLOSEFLAG  VARCHAR(1) -- 작업지시 종료 여부

	,@LANG           VARCHAR(5) = 'OK'
	,@RS_CODE        VARCHAR(1)   OUTPUT
	,@RS_MSG         VARCHAR(200) OUTPUT

AS
BEGIN
	SELECT PLANTCODE                                        -- 공장
		   ,PLANNO		                                    -- 계획번호
		   ,ITEMCODE	                                    -- 품목코드
		   ,PLANQTY		                                    -- 계획수량 
		   ,UNITCODE	                                    -- 단위
		   ,WORKCENTERCODE                                  -- 작업장
		   ,CASE WHEN ISNULL(ORDERFLAG, 'N') = 'Y' THEN 1
				ELSE 0 END                  AS CHK          --설명      
		   ,ORDERNO                                         -- 작업지시
		   ,ORDERDATE	                                    -- 확장일시
		   ,DBO.FN_WORKERNAME(ORDERWORKER)  AS ORDERWORKER  -- 확정자
		   ,ORDERCLOSEFLAG                                  -- 지시종료 여부
		   ,DBO.FN_WORKERNAME(MAKER)        AS MAKER		   -- 등록자
		   ,CONVERT(VARCHAR, MAKEDATE, 120) AS MAKEDATE     -- 등록 일시
		   ,DBO.FN_WORKERNAME(EDITOR)       AS EDITTOR      -- 수정자
		   ,CONVERT(VARCHAR, EDITDATE, 120) AS EDITDATE     -- 수정일시

		FROM TB_ProductPlan WITH (NOLOCK)
	WHERE PLANTCODE                LIKE '%' + @PLANTCODE      + '%'
	AND WORKCENTERCODE             LIKE '%' + @WORKCENTERCODE + '%'
	AND ISNULL(ORDERNO, '')        LIKE '%' + @ORDERNO        + '%'
	AND ISNULL(ORDERCLOSEFLAG, '') LIKE '%' + @ORDERCLOSEFLAG + '%'

END
GO
