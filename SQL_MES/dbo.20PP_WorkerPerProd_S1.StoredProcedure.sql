USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[20PP_WorkerPerProd_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		정유경
-- Create date: 2021-06-15
-- Description:	작업자 일별 생산 실적 조회
-- =============================================
CREATE PROCEDURE [dbo].[20PP_WorkerPerProd_S1]
	@PLANTCODE         VARCHAR(10)
   ,@WORKER			   VARCHAR(30)
   ,@STARTDATE         VARCHAR(10)
   ,@ENDDATE           VARCHAR(10)

   ,@LANG              VARCHAR(10) = 'KO'
   ,@RS_CODE           VARCHAR(1)    OUTPUT
   ,@RS_MSG            VARCHAR(200)  OUTPUT

AS
BEGIN
	SELECT A.PLANTCODE                                              AS PLANTCODE        -- 공장
		 , DBO.FN_WORKERNAME(A.MAKER)                               AS WORKER	        -- 작업자
		 , CONVERT(VARCHAR,A.PRODDATE,23)							AS PRODDATE			-- 생산 일자
		 , A.WORKCENTERCODE											AS WORKCENTERCODE	-- 작업장
		 , B.WORKCENTERNAME                                         AS WORKCENTERNAME   -- 작업장 명
		 , A.ITEMCODE                                               AS ITEMCODE         -- 품목
		 , C.ITEMNAME												AS ITEMNAME			-- 품목명
		 , A.PRODQTY                                                AS PRODQTY          -- 생산수량
		 , A.BADQTY                                                 AS BADQTY           -- 불량수량
		 , A.TOTALQTY												AS TOTALQTY			-- 총생산량
		 ,CASE WHEN A.TOTALQTY = 0 THEN ''
			   WHEN A.TOTALQTY IS NULL THEN ''
			   ELSE CONCAT(ROUND(A.BADQTY*100/A.TOTALQTY,2),'%')
			   END													AS BADRATIO			-- 불량률
		 , A.PRODDATE												AS PRODDATETIME	    -- 생산 일시 시간

	  FROM TP_WorkcenterPerProd A WITH(NOLOCK) LEFT JOIN TB_WorkCenterMaster B WITH(NOLOCK)
											    ON A.PLANTCODE       = B.PLANTCODE
											   AND A.WORKCENTERCODE  = B.WORKCENTERCODE

									     LEFT JOIN TB_ItemMaster C WITH(NOLOCK) 
												ON A.PLANTCODE = C.PLANTCODE
											   AND A.ITEMCODE  = C.ITEMCODE

	WHERE A.PLANTCODE                  LIKE '%' + @PLANTCODE + '%'
	  AND DBO.FN_WORKERNAME(A.MAKER)   LIKE '%' + @WORKER    + '%'
	  AND A.PRODDATE                   BETWEEN    @STARTDATE AND @ENDDATE
	  order by a.MAKER,a.PRODDATE
END


GO
