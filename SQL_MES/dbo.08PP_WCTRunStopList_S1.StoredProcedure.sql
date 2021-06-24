USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[08PP_WCTRunStopList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김종우
-- Create date: 2021-06-15
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[08PP_WCTRunStopList_S1] 
	@PLANTCODE      VARCHAR(10)
   ,@WORKCENTERCODE VARCHAR(10)
   ,@STARTDATE      VARCHAR(10)
   ,@ENDDATE        VARCHAR(10)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE	    VARCHAR(1)    OUTPUT
   ,@RS_MSG			VARCHAR(200)  OUTPUT
AS
BEGIN
	SELECT A.PLANTCODE                                              AS PLANTCODE      -- 공장   
		  ,A.WORKCENTERCODE	                                        AS WORKCENTERCODE -- 작업장
		  ,B.WORKCENTERNAME	                                        AS WORKCENTERCODE -- 작업장 명
	      ,A.ORDERNO   		                                        AS ORDERNO		  -- 작업지시 번호
		  ,A.ITEMCODE		                                        AS ITEMCODE	      -- 품목 코드
		  ,ITEMNAME												    AS ITEMNAME		  -- 품목 명
		  ,DBO.FN_WORKERNAME(WORKER)                                AS WORKERNAME     -- 작업자명
		  ,CASE WHEN A.STATUS = 'R' THEN '가동중' ELSE '비가동' END AS WORKSTATUS     -- 가동/비가동 상태
		  ,A.RSSTARTDATE                                            AS STARTDATE      -- 최초 가동 시작 시간
		  ,A.RSENDDATE                                              AS ENDDATE        -- 작업지시  종료 시간
		  ,A.PRODQTY                                                AS PRODQTY		  -- 양품수량
		  ,A.BADQTY                                                 AS BADQTY         -- 불량수량
		  ,A.REMARK												    AS REMARK		  -- 사유
		  ,A.MAKEDATE
		  ,A.MAKER
		  ,A.EDITDATE
		  ,A.EDITOR


	  
	  FROM  TP_WorkcenterStatusRec A WITH(NOLOCK) LEFT JOIN TB_WorkCenterMaster B WITH(NOLOCK) ON A.WORKCENTERCODE = B.WORKCENTERCODE 
												  LEFT JOIN TB_ItemMaster C WITH(NOLOCK)       ON A.ITEMCODE	   = C.ITEMCODE

	 WHERE  A.PLANTCODE         LIKE '%' + @PLANTCODE      + '%'
	   AND  A.WORKCENTERCODE	LIKE '%' + @WORKCENTERCODE + '%'
	   AND  A.MAKEDATE			BETWEEN    @STARTDATE AND @ENDDATE
END
GO
