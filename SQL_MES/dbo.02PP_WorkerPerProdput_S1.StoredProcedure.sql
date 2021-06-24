USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02PP_WorkerPerProdput_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-15
-- Description:	작업자 일별 생산 실적 조회
-- =============================================
CREATE PROCEDURE [dbo].[02PP_WorkerPerProdput_S1]
	@PLANTCODE	    VARCHAR(10)		 -- 공장
   ,@WORKER         VARCHAR(10)      -- 작업자
   ,@STARTDATE     VARCHAR(20)
   ,@ENDDATE	    VARCHAR(20)

   ,@LANG			VARCHAR(5)   = 'KO'
   ,@RS_CODE		VARCHAR(1)   OUTPUT
   ,@RS_MSG			VARCHAR(200) OUTPUT
AS
BEGIN

SELECT A.PLANTCODE									  AS PLANTCODE		--공장
      ,DBO.FN_WORKERNAME(A.MAKER)					  AS WORKER			--작업자
	  ,CONVERT(VARCHAR, A.MAKEDATE, 23)				  AS MAKEDATE		--생산 일자		
	  ,A.WORKCENTERCODE								  AS WORKCENTERCODE	-- 작업장
	  ,B.WORKCENTERNAME							  AS WORKCENTERNAME	--작업장 명
	  ,A.ITEMCODE									  AS ITEMCODE		--품목
	  ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,@LANG)  AS ITEMNAME		--품명
      ,A.PRODQTY									  AS PRODQTY	    --생산수량
	  ,A.BADQTY										  AS BADQTY			--불량수량
	  ,A.TOTALQTY									  AS TOTALQTY		--총 수량
	  ,CONVERT(VARCHAR, CONVERT(DECIMAL(4,1),(CONVERT(FLOAT,A.BADQTY)/CONVERT(FLOAT,A.TOTALQTY)* 100))) + '%'  AS BADRATE
	  ,A.MAKEDATE									  AS EDITDATE		--생산일시
  FROM TP_WorkcenterPerProd A WITH(NOLOCK) LEFT JOIN TB_WorkCenterMaster B WITH(NOLOCK)
												  ON A.PLANTCODE = B.PLANTCODE
												 AND A.WORKCENTERCODE = B.WORKCENTERCODE
			   WHERE A.PLANTCODE			    LIKE '%' + @PLANTCODE  + '%'
				   AND A.MAKER			        LIKE '%' + @WORKER	  + '%'
				   AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN @STARTDATE AND @ENDDATE	
END
GO
