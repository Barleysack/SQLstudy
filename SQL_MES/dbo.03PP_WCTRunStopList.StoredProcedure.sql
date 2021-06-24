USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03PP_WCTRunStopList]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보민
-- Create date: 21-06-10
-- Description:	작업장 비가동 현황 및 사유 관리 
-- =============================================
CREATE PROCEDURE [dbo].[03PP_WCTRunStopList]
	@PLANTCODE      VARCHAR(10)
   ,@WORKCENTERCODE			VARCHAR(30)
   ,@STARTDATE      VARCHAR(10)
   ,@ENDDATE        VARCHAR(10)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE	    VARCHAR(1)    OUTPUT
   ,@RS_MSG			VARCHAR(200)  OUTPUT
	
AS
BEGIN
DECLARE @TOTAL INT

SELECT A.PLANTCODE,
	   A.WORKCENTERCODE, 
	   A.WORKCENTERCODE		AS WORKCENTERNAME,
	   A.ORDERNO,
	   B.ITEMCODE,
	   C.ITEMNAME,
	   DBO.FN_WORKERNAME(A.WORKER), 
	   CASE WHEN A.STATUS = 'S' THEN '비가동'
		    WHEN A.STATUS = 'R' THEN '가동'
			END,
	   A.RSSTARTDATE,
	   A.RSENDDATE,
	   DATEDIFF(m, A.RSSTARTDATE, A.RSENDDATE)  AS RUNNINGTIME,
	   A.PRODQTY,
	   A.BADQTY,
	   D.REMARK
	FROM TP_WorkcenterStatusRec A LEFT JOIN TP_WorkcenterStatus D
											ON A.ORDERNO = D.ORDERNO
										   AND A.PLANTCODE = D.PLANTCODE
										   AND A.WORKCENTERCODE = D.WORKCENTERCODE
										 , TB_ProductPlan B, TB_ItemMaster C
	WHERE B.ITEMCODE		= C.ITEMCODE
	  AND A.ORDERNO			= B.ORDERNO
	  AND A.PLANTCODE		= B.PLANTCODE
	  AND A.WORKCENTERCODE	= B.WORKCENTERCODE
	  AND A.WORKCENTERCODE			LIKE	'%'+@WORKCENTERCODE+'%'
	  AND CONVERT(VARCHAR,A.MAKEDATE,23)	BETWEEN @STARTDATE AND @ENDDATE
	  AND A.PLANTCODE		LIKE '%' + @PLANTCODE + '%'

END

GO
