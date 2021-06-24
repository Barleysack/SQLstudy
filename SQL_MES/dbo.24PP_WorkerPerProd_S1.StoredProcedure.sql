USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[24PP_WorkerPerProd_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		홍건의
-- Create date: 2021-06-15
-- Description:	생산 대상. 작업지시 조회
-- =============================================
CREATE PROCEDURE [dbo].[24PP_WorkerPerProd_S1]
	@PLANTCODE  VARCHAR(10)
   ,@WORKER		VARCHAR(10)
   ,@STARTDATE  VARCHAR(10)
   ,@ENDDATE    VARCHAR(10)

   ,@LANG       VARCHAR(10) = 'KO'
   ,@RS_CODE	VARCHAR(1)    OUTPUT
   ,@RS_MSG		CHAR(200)  OUTPUT
	
AS
BEGIN
	SELECT A.PLANTCODE													AS PLANTCODE
		  ,D.WORKERNAME													AS WORKER
		  ,A.PRODDATE													AS PRODDATE
		  ,A.WORKCENTERCODE												AS WORKCENTERCODE
		  ,C.WORKCENTERNAME												AS WORKCENTER
		  ,A.ITEMCODE													AS ITEMCODE
		  ,B.ITEMNAME													AS ITEMNAME
		  ,A.PRODQTY													AS PRODQTY
		  ,A.BADQTY														AS BADQTY
		  ,A.TOTALQTY													AS TOTALQTY
		  ,CASE WHEN ISNULL(A.BADQTY,0) = 0 THEN '0%'					
				WHEN ISNULL((A.BADQTY*100/A.TOTALQTY),0) = 0 THEN '0%'	
				ELSE CONCAT(ROUND((A.BADQTY*100/A.TOTALQTY),1),'%') 	
		   END															AS BADRATE
		  
		  ,A.MAKEDATE													AS MAKEDATE
	FROM TP_WorkcenterPerProd A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
		ON A.ITEMCODE = B.ITEMCODE
		LEFT JOIN TB_WorkCenterMaster C WITH(NOLOCK)
		ON A.WORKCENTERCODE = C.WORKCENTERCODE
		LEFT JOIN TB_WorkerList D WITH(NOLOCK)
		ON A.MAKER = D.WORKERID

	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND A.MAKER					   LIKE '%' + @WORKER + '%'
	   AND A.MAKEDATE				   BETWEEN @STARTDATE AND @ENDDATE
END
GO
