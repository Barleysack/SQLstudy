USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[01PP_WCTRunStopList_S1]    Script Date: 2021-06-22 오후 5:42:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강유정
-- Create date: 2021-06-10
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[01PP_WCTRunStopList_S1]
	@PLANTCODE       VARCHAR(10)
   ,@MAKER		 VARCHAR(10)
   ,@STARTDATE    VARCHAR(10)
   ,@ENDDATE		 VARCHAR(10)

   ,@LANG            VARCHAR(10) = 'KO'
   ,@RS_CODE	     VARCHAR(1)    OUTPUT
   ,@RS_MSG		 	 VARCHAR(200)  OUTPUT
	
AS
BEGIN
	SELECT A.PLANTCODE                                              AS PLANTCODE      -- 공장   
	      ,A.RSSEQ												    AS RSSEQ
		  ,A.WORKCENTERCODE	                                        AS WORKCENTERCODE -- 작업장
		  ,C.WORKCENTERNAME											AS WORKCENTERNAME -- 작업장
		  ,A.ORDERNO												AS ORDERNO
		  ,D.ITEMCODE												AS ITEMCODE
		  ,D.ITEMNAME												AS ITEMNAME	                                           
		  ,A.MAKER													AS MAKER         -- 작업자
		  ,A.MAKEDATE	                                            AS MAKEDATE     
		  ,A.WORKER													AS WORKER

		  ,CASE 
				WHEN A.STATUS = 'R' THEN '가동중' ELSE '비가동' END AS WORKSTATUS     -- 가동/비가동 상
	      ,A.RSSTARTDATE                                           AS STARTDATE      -- 최초 가동 시작 시간
		  ,A.RSENDDATE                                             AS ENDDATE        -- 작업지시  종료 시간
		  ,CONVERT(VARCHAR, A.RSENDDATE - A.RSSTARTDATE)+'분'	AS TIMER
		  ,A.PRODQTY                                                AS PRODQTY		  -- 양품수량
		  ,A.BADQTY                                                 AS BADQTY         -- 불량수량
		  ,A.REMARK													AS REMARK
		  ,A.MAKER													AS MAKER
		  ,A.MAKEDATE												AS STARTDATE    
		  ,A.EDITOR													AS EDITOR
		  ,A.EDITDATE												AS EDITDATE										

	  
	  FROM TP_WorkcenterStatusRec A WITH(NOLOCK)  LEFT JOIN TB_WorkCenterMaster C
												ON A.PLANTCODE      = C.PLANTCODE
												AND A.WORKCENTERCODE = C.WORKCENTERCODE

												LEFT JOIN TB_ItemMaster D
												ON A.ITEMCODE      = D.ITEMCODE

	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND A.MAKER                     LIKE '%' + @MAKER      + '%'
	   AND A.MAKEDATE			   BETWEEN @STARTDATE AND @ENDDATE
	   AND A.PRODQTY IS NOT NULL

END
GO
