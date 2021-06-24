USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[06PP_WorkerPerProd_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[06PP_WorkerPerProd_S1]
	@PLANTCODE      VARCHAR(10)
   ,@WORKER         VARCHAR(10)
   ,@STARTDATE      VARCHAR(10)
   ,@ENDDATE        VARCHAR(10)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE        VARCHAR(1)    OUTPUT
   ,@RS_MSG         VARCHAR(200)  OUTPUT
AS
BEGIN
	SELECT A.PLANTCODE													AS PLANTCODE
		  ,B.WORKERNAME													AS WORKER
		  ,A.PRODDATE													AS PRODDATE
		  ,A.WORKCENTERCODE												AS WORKCENTERCODE
		  ,DBO.FN_WORKCENTERNAME(A.WORKCENTERCODE,A.PLANTCODE,'KO')		AS WORKCENTERCODENAME
		  ,A.ITEMCODE													AS ITEMCODE
		  ,C.ITEMNAME													AS ITEMNAME
		  ,A.PRODQTY													AS PRODQTY
		  ,A.BADQTY														AS BADQTY
		  ,A.TOTALQTY													AS TOTALQTY
		  ,CASE 
            WHEN A.BADQTY  = 0 THEN CONVERT(VARCHAR,'0 %')
            WHEN A.TOTALQTY = 0 THEN CONVERT(VARCHAR,'0 %')
            ELSE CONCAT(ROUND(A.BADQTY / ISNULL(A.TOTALQTY,0) * 100,1),' %')
         END  AS BADRATIO
		  ,CONVERT(VARCHAR, A.MAKEDATE, 23) AS MAKEDATE
		FROM TP_WorkcenterPerProd A WITH(NOLOCK) LEFT JOIN TB_WorkerList B WITH(NOLOCK)
													  ON A.PLANTCODE = B.PLANTCODE
													 AND A.MAKER = B.WORKERID
											   LEFT JOIN TB_ItemMaster C WITH(NOLOCK)
											          ON A.PLANTCODE = C.PLANTCODE
													 AND A.ITEMCODE = C.ITEMCODE
											  
		WHERE B.WORKERNAME LIKE '%' + @WORKER + '%'
		AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN @STARTDATE AND @ENDDATE
		ORDER BY A.MAKER, A.PRODDATE, A.WORKCENTERCODE, A.MAKEDATE

	    SET @RS_CODE = 'S'

END
GO
