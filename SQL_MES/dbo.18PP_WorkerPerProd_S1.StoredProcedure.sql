USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18PP_WorkerPerProd_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-15
-- Description:	작업자 일별 생산실적 조회
-- =============================================
CREATE PROCEDURE [dbo].[18PP_WorkerPerProd_S1]
	@PLANTCODE      VARCHAR(10)
   ,@WORKER         VARCHAR(10)  
   ,@STARTDATE      VARCHAR(10)
   ,@ENDDATE        VARCHAR(10)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE	    VARCHAR(1)    OUTPUT
   ,@RS_MSG			VARCHAR(200)  OUTPUT
AS
BEGIN
	SELECT A.PLANTCODE                                              AS PLANTCODE      
		  ,DBO.FN_WORKERNAME(B.MAKER)      		                    AS WORKER	  
		  ,A.PRODDATE		                                        AS PRODDATE	      
		  ,A.WORKCENTERCODE		                                    AS WORKCENTERCODE		
		  ,C.WORKCENTERNAME                                         AS WORKCENTERNAME		  
		  ,A.ITEMCODE                                               AS ITEMCODE        
		  ,D.ITEMNAME		                                        AS ITEMNAME	     
		  ,A.PRODQTY                                                AS PRODQTY
		  ,A.BADQTY		                                            AS BADQTY	 
		  ,A.TOTALQTY	                                            AS TOTALQTY   
		  ,CONCAT(ROUND((A.BADQTY/A.TOTALQTY) * 100,1),'%')	        AS FAILIURE	 
		  ,A.MAKEDATE	                                            AS MAKEDATE 
     FROM  TP_WorkcenterPerProd A WITH(NOLOCK) LEFT JOIN TP_WorkcenterStatus B WITH(NOLOCK)
	                                             ON A.PLANTCODE      = B.PLANTCODE
												AND A.ORDERNO        = B.ORDERNO
												AND A.WORKCENTERCODE = B.WORKCENTERCODE
											   LEFT JOIN TB_WorkCenterMaster C WITH(NOLOCK)
											     ON A.PLANTCODE      = C.PLANTCODE
												AND A.WORKCENTERCODE = C.WORKCENTERCODE
											   LEFT JOIN TB_ItemMaster D WITH(NOLOCK)
											     ON A.PLANTCODE      = D.PLANTCODE
												AND A.ITEMCODE       = D.ITEMCODE
	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND B.WORKER                    LIKE '%' + @WORKER + '%'
	   AND A.PRODDATE				   BETWEEN @STARTDATE AND @ENDDATE
END
GO
