USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[16PP_WorkerPerProd_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이진
-- Create date: 2021-06-15
-- Description:	작업자 일별 생산실적 조회
-- =============================================
CREATE PROCEDURE [dbo].[16PP_WorkerPerProd_S1]
	 @PLANTCODE VARCHAR(10)  --공장
	,@STARTDATE VARCHAR(10)  --시작일자
    ,@ENDDATE   VARCHAR(10)  --종료일자
	,@WORKERNAME VARCHAR(10)  --작업자

	,@LANG     VARCHAR(5) = 'KO'
    ,@RS_CODE  VARCHAR(1)   OUTPUT
    ,@RS_MSG   VARCHAR(200) OUTPUT
AS
BEGIN 
	SELECT A.PLANTCODE
	      ,B.WORKERNAME
		  ,A.PRODDATE
		  ,A.WORKCENTERCODE
		  ,C.WORKCENTERNAME
		  ,A.ITEMCODE
		  ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,'KO') as itemname
		  ,A.PRODQTY
		  ,A.BADQTY
		  ,A.TOTALQTY
		  , CASE 
		      WHEN A.TOTALQTY = 0    THEN '0%'
              WHEN A.TOTALQTY =NULL  THEN '0%'
              ELSE CONCAT( ROUND(A.BADQTY*100/A.TOTALQTY,1), '%' )
			END AS ERRORPER
		  ,CONVERT(VARCHAR, A.MAKEDATE, 23) AS MAKEDATE
	  
	  FROM TP_WorkcenterPerProd A JOIN TB_WorkerList B
	                         ON  A.PLANTCODE = B.PLANTCODE
							AND  A.MAKER      = B.WORKERID
							 JOIN TB_WorkCenterMaster C
							   ON  A.PLANTCODE = C.PLANTCODE
							   AND A.WORKCENTERCODE = C.WORKCENTERCODE

	 WHERE A.PLANTCODE  LIKE '%' + @PLANTCODE    + '%'
	   AND B.WORKERNAME LIKE '%' + @WORKERNAME   + '%'
	   AND A.PRODDATE BETWEEN @STARTDATE AND @ENDDATE
	   ORDER BY A.MAKER, A.PRODDATE, A.WORKCENTERCODE, A.MAKEDATE
END
GO
