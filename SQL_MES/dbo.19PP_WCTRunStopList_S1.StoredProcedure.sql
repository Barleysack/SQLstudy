USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19PP_WCTRunStopList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-15
-- Description:	작업장 비가동 현황 및 사유 관리
-- =============================================
CREATE PROCEDURE [dbo].[19PP_WCTRunStopList_S1]
     @PLANTCODE       VARCHAR(10),     --공장 코드
	 @WORKCENTERCODE  VARCHAR(30),     --작업장
     @STARTDATE       VARCHAR(10),     --시작 일자
     @ENDDATE         VARCHAR(10),     --끝 일자

     @LANG	  VARCHAR(10) ='KO',      --언어
     @RS_CODE VARCHAR(10) OUTPUT,     --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT     --성공 관련 메세지

AS
BEGIN

	SELECT B.PLANTCODE                                  AS PLANTCODE
		 , B.RSSEQ								        AS RSSEQ
		 , B.WORKCENTERCODE								AS WORKCENTERCODE
		 , C.WORKCENTERNAME								AS WORKCENTERNAME
		 , B.ORDERNO       								AS ORDERNO
		 , B.ITEMCODE      								AS ITEMCODE
		 , D.ITEMNAME      								AS ITEMNAME
		 , DBO.FN_WORKERNAME(B.MAKER)        			AS WORKER
		 , CASE WHEN B.STATUS = 'R' THEN  '가동'        
		        WHEN B.STATUS = 'S' THEN '비가동'		
				END										AS RUNSTOP
		 , B.RSSTARTDATE    							AS RSSTARTDATE
		 , B.RSENDDATE      							AS RSENDDATE
		 , CONCAT(DATEDIFF(MI,B.RSSTARTDATE,B.RSENDDATE),'분') 
													    AS SPENDTIME
		 , B.PRODQTY       								AS PRODQTY
		 , B.BADQTY 									AS BADQTY
		 , B.REMARK										AS REMARK
		 , DBO.FN_WORKERNAME(B.MAKER)         			AS MAKER
		 , B.MAKEDATE      								AS MAKEDATE
		 , B.EDITOR        								AS EDITOR
		 , B.EDITDATE      								AS EDITDATE

	  FROM TP_WorkcenterStatusRec B WITH(NOLOCK) 

	  LEFT JOIN TB_WorkCenterMaster C WITH(NOLOCK)
	     ON B.PLANTCODE = C.PLANTCODE
	    AND B.WORKCENTERCODE = C.WORKCENTERCODE

	  LEFT JOIN TB_ItemMaster D WITH(NOLOCK)
	     ON B.PLANTCODE = D.PLANTCODE
	    AND B.ITEMCODE = D.ITEMCODE



     WHERE B.PLANTCODE        LIKE '%' + @PLANTCODE + '%'
       AND B.WORKCENTERCODE   LIKE '%' + @WORKCENTERCODE + '%'
	   AND B.EDITDATE         BETWEEN @STARTDATE AND @ENDDATE

END


GO
