USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[13PP_WCTRunStopList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		원지윤
-- Create date: 2021.06.15
-- Description:	작업장 비가동 현황 및 사유 관리
-- =============================================
CREATE PROCEDURE [dbo].[13PP_WCTRunStopList_S1]
	@PLANTCODE			VARCHAR(10)
   ,@WORKCENTERCODE		VARCHAR(10)
   ,@STARTDATE			VARCHAR(10)
   ,@ENDDATE			VARCHAR(10)

   ,@LANG				VARCHAR(10) = 'KO'
   ,@RS_CODE			VARCHAR(1) OUTPUT
   ,@RS_MSG				CHAR(200)  OUTPUT
	
AS
BEGIN
	SELECT  A.PLANTCODE		                                           AS PLANTCODE		
		   ,A.RSSEQ													   AS RSSEQ
		   ,A.WORKCENTERCODE										   AS WORKCENTERCODE
		   ,B.WORKCENTERNAME										   AS WORKCENTERNAME
		   ,A.ORDERNO   											   AS ORDERNO   	
		   ,A.ITEMCODE												   AS ITEMCODE		
		   ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,@LANG)			   AS ITEMNAME		
		   ,DBO.FN_WORKERNAME(A.MAKER)								   AS WORKER			
		   ,CASE WHEN A.STATUS = 'R' THEN '가동' ELSE '비가동' END     AS STATUS
		   ,A.RSSTARTDATE											   AS RSSTARTDATE	
		   ,A.RSENDDATE												   AS RSENDDATE		
		   ,DATEDIFF(MI,A.RSSTARTDATE, A.RSENDDATE)					   AS WORKTIME
		   ,A.PRODQTY												   AS PRODQTY	
		   ,A.BADQTY												   AS BADQTY	
		   ,A.REMARK												   AS REMARK
		   ,DBO.FN_WORKERNAME(A.MAKER)								   AS MAKER		
		   ,A.MAKEDATE												   AS MAKEDATE
		   ,DBO.FN_WORKERNAME(A.EDITOR)								   AS EDITOR	
		   ,A.EDITDATE												   AS EDITDATE

		FROM TP_WorkcenterStatusRec A WITH(NOLOCK)
		LEFT JOIN TB_WorkCenterMaster B WITH(NOLOCK)
		ON A.WORKCENTERCODE = B.WORKCENTERCODE

		WHERE A.PLANTCODE    LIKE '%' + @PLANTCODE      + '%'
	   AND A.WORKCENTERCODE  LIKE '%' + @WORKCENTERCODE + '%'
	   AND A.RSSTARTDATE	 BETWEEN @STARTDATE AND @ENDDATE

END



GO
