USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[TB_BadStockList]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[TB_BadStockList]
	@PLANTCODE       VARCHAR(10)
   ,@MAKER			 VARCHAR(10)
   ,@STARTDATE		 VARCHAR(10)
   ,@ENDDATE		 VARCHAR(10)

   ,@LANG            VARCHAR(10) = 'KO'
   ,@RS_CODE	     VARCHAR(1)    OUTPUT
   ,@RS_MSG		 	 VARCHAR(200)  OUTPUT
	
AS
BEGIN
	SELECT A.PLANTCODE                                              AS PLANTCODE      -- 공장   
		  ,A.MAKER		                                            AS MAKER         -- 작업자
		  ,A.WORKCENTERCODE	                                        AS WORKCENTERCODE -- 작업장
		  ,C.WORKCENTERNAME											AS WORKCENTERNAME -- 작업장
	      ,D.ITEMCODE												AS ITEMCODE
		  ,D.ITEMNAME												AS ITEMNAME
		  ,A.PRODQTY                                                AS PRODQTY		  -- 양품수량
		  ,A.BADQTY                                                 AS BADQTY         -- 불량수량
		  ,A.PRODQTY+A.BADQTY										AS TOTALQTY
		  ,CASE 
            WHEN A.TOTALQTY = 0 THEN '0 %'
             ELSE  CONVERT(VARCHAR, (A.BADQTY * 100)/A.TOTALQTY )+ '%'
			END  AS ERRORPER
		  ,A.PRODDATE                                           AS MAKEDATE    
	  
	  FROM TP_WorkcenterPerProd A WITH(NOLOCK) LEFT JOIN TB_WorkCenterMaster C
												ON A.PLANTCODE      = C.PLANTCODE
												AND A.WORKCENTERCODE = C.WORKCENTERCODE

												LEFT JOIN TB_ItemMaster D
												ON A.ITEMCODE      = D.ITEMCODE

	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND A.MAKER                     LIKE '%' + @MAKER      + '%'
	   AND A.PRODDATE			   BETWEEN @STARTDATE AND @ENDDATE

	   ORDER BY A.MAKER,A.PRODDATE,A.WORKCENTERCODE
     

END
GO
