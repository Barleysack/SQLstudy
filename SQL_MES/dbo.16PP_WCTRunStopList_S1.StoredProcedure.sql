USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[16PP_WCTRunStopList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이진
-- Create date: 2021-06-15
-- Description:	작업장 비가동 현황 및 사유 관리
-- =============================================
CREATE PROCEDURE [dbo].[16PP_WCTRunStopList_S1]
	 @PLANTCODE      VARCHAR(10)  --공장
	,@WORKCENTERCODE VARCHAR(30)  --작업장
	,@STARTDATE      VARCHAR(10)  --시작일자
    ,@ENDDATE        VARCHAR(10)  --종료일자
	
	
	,@LANG     VARCHAR(5) = 'KO'
    ,@RS_CODE  VARCHAR(1)   OUTPUT
    ,@RS_MSG   VARCHAR(200) OUTPUT
AS
BEGIN 
	SELECT A.PLANTCODE
	      ,A.RSSEQ
		  ,A.WORKCENTERCODE
		  ,B.WORKCENTERNAME
		  ,A.ORDERNO
		  ,A.ITEMCODE
		  ,C.ITEMNAME
		  ,A.WORKER
		  ,CASE 
			 WHEN A.STATUS = 'S' THEN '비가동' 
			 WHEN A.STATUS = 'R' THEN '가동'
			END AS STATUS
		  ,A.RSSTARTDATE
		  ,A.RSENDDATE
		  ,CONCAT( DATEDIFF(MI, A.RSSTARTDATE, A.RSENDDATE) , '분') AS MI
		  ,A.PRODQTY
		  ,A.BADQTY
		  ,A.REMARK

	  FROM TP_WorkcenterStatusRec A WITH(NOLOCK) LEFT JOIN TB_WorkCenterMaster B
	                                               ON  A.PLANTCODE = B.PLANTCODE
									              AND A.WORKCENTERCODE = B.WORKCENTERCODE
									             LEFT JOIN TB_ItemMaster C
									                ON A.PLANTCODE = C.PLANTCODE
													AND A.ITEMCODE = C.ITEMCODE
									             	LEFT JOIN TP_WorkcenterStatus D
									             	  ON A.PLANTCODE = D.PLANTCODE
									             	 AND A.ORDERNO = D.ORDERNO
									             	 AND A.WORKER = D.WORKER
							

	 WHERE A.PLANTCODE      LIKE '%' + @PLANTCODE       + '%'
	   AND A.WORKCENTERCODE LIKE '%' + @WORKCENTERCODE  + '%'
	   AND A.EDITDATE BETWEEN @STARTDATE AND @ENDDATE
END
GO
