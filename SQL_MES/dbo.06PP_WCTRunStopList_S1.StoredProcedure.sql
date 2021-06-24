USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[06PP_WCTRunStopList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김얼
-- Create date: 2021-06-15
-- Description:	작업장 비가동 현황 및 사유 관리 조회
-- =============================================
CREATE PROCEDURE [dbo].[06PP_WCTRunStopList_S1]
	@PLANTCODE				VARCHAR(10)
   ,@WORKCENTERCODE         VARCHAR(10)
   ,@STARTDATE				VARCHAR(10)
   ,@ENDDATE				VARCHAR(10)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE        VARCHAR(1)    OUTPUT
   ,@RS_MSG         VARCHAR(200)  OUTPUT
AS
BEGIN
	SELECT A.PLANTCODE												     AS PLANTCODE
		  ,A.RSSEQ													     AS RSSEQ
		  ,A.WORKCENTERCODE											     AS WORKCENTERCODE
		  ,C.WORKCENTERNAME											     AS WORKCENTERNAME
		  ,A.ORDERNO												     AS ORDERNO
		  ,A.ITEMCODE												     AS ITEMCODE
		  ,B.ITEMNAME												     AS ITEMNAME
		  ,A.WORKER													     AS WORKER
		  ,CASE WHEN A.STATUS = 'R' THEN '가동' ELSE '비가동' END		 AS WORKSTATUS
		  ,CONVERT(VARCHAR,A.RSSTARTDATE,120)							 AS RSSTARTDATE
		  ,CONVERT(VARCHAR,A.RSENDDATE,120)							     AS RSENDDATE
		  ,DATEDIFF(mi,A.RSSTARTDATE,A.RSENDDATE)						 AS DURATION
		  ,A.PRODQTY													 AS PRODQTY
		  ,A.BADQTY														 AS BADQTY
		  ,A.REMARK														 AS REMARK
		  ,A.MAKER														 AS MAKER
		  ,A.MAKEDATE													 AS MAKEDATE
		  ,A.EDITOR														 AS EDITOR
		  ,A.EDITDATE													 AS EDITDATE
	  FROM TP_WorkcenterStatusRec A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
														ON A.PLANTCODE = B.PLANTCODE
													   AND A.ITEMCODE  = B.ITEMCODE
												 LEFT JOIN TB_WorkCenterMaster C WITH(NOLOCK)
														ON A.PLANTCODE		= C.PLANTCODE
													   AND A.WORKCENTERCODE = C.WORKCENTERCODE
	  WHERE A.WORKCENTERCODE LIKE '%' + @WORKCENTERCODE + '%'
		AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN @STARTDATE AND @ENDDATE
													   SET @RS_CODE = 'S'
END
GO
