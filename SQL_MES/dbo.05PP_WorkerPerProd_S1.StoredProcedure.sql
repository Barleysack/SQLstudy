USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[05PP_WorkerPerProd_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김수연
-- Create date: 2021-06-14
-- Description:	작업자 일별 생산 실적
-- =============================================
CREATE PROCEDURE [dbo].[05PP_WorkerPerProd_S1]
	@PLANTCODE      VARCHAR(10)
   ,@WORKER		    VARCHAR(10)
   ,@STARTDATE      VARCHAR(10)
   ,@ENDDATE        VARCHAR(10)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE	    VARCHAR(1)    OUTPUT
   ,@RS_MSG			VARCHAR(200)  OUTPUT
	
AS
BEGIN
	SELECT A.PLANTCODE													AS PLANTCODE
		  ,DBO.FN_WORKERNAME(A.MAKER)									AS MAKER
		  ,A.PRODDATE													AS PRODDATE
		  ,A.WORKCENTERCODE												AS WORKCENTERCODE
		  ,DBO.FN_WORKCENTERNAME(A.WORKCENTERCODE,A.PLANTCODE,@LANG)	AS WORKCENTERNAME -- 작업장명
		  ,A.ITEMCODE													AS ITEMCODE
		  ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,@LANG)			    AS ITEMNAME	     
		  ,A.PRODQTY													AS PRODQTY
		  ,A.BADQTY														AS BADQTY
		  ,A.TOTALQTY													AS TOTALQTY
		  ,CASE WHEN ISNULL(A.BADQTY,0) = 0 THEN '0%'					
				WHEN ISNULL(A.TOTALQTY,0) = 0 THEN '0%'	
				ELSE CONVERT(VARCHAR,ROUND((A.BADQTY*100/A.TOTALQTY),1))+'%' 	
		   END															AS BADRATE
		  ,CONVERT(VARCHAR,A.MAKEDATE,120)								AS MAKEDATE
	FROM TP_WorkcenterPerProd A WITH(NOLOCK)

	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND A.MAKER					   LIKE '%' + @WORKER + '%'
	   AND A.MAKEDATE				   BETWEEN @STARTDATE AND @ENDDATE

	 ORDER BY A.MAKER, A.PRODDATE, A.WORKCENTERCODE, A.MAKEDATE
END
GO
