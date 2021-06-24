USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[24PP_WCTRunStopList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		홍건의
-- Create date: 2021-06-15
-- Description:	생산 대상. 작업지시 조회
-- =============================================
CREATE PROCEDURE [dbo].[24PP_WCTRunStopList_S1]
	@PLANTCODE			VARCHAR(10)
   ,@WORKCENTERCODE		VARCHAR(10)
   ,@STARTDATE			VARCHAR(10)
   ,@ENDDATE			VARCHAR(10)

   ,@LANG       VARCHAR(10) = 'KO'
   ,@RS_CODE	VARCHAR(1)    OUTPUT
   ,@RS_MSG		CHAR(200)  OUTPUT
	
AS
BEGIN
	SELECT A.PLANTCODE				                   AS PLANTCODE
		  ,A.RSSEQ				                       AS RSSEQ
		  ,A.WORKCENTERCODE			                   AS WORKCENTERCODE
		  ,B.WORKCENTERNAME			                   AS WORKCENTERNAME
		  ,A.ORDERNO				                   AS ORDERNO
		  ,A.ITEMCODE				                   AS ITEMCODE
		  ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,'KO')AS ITEMNAME	      -- 품목 코드
		  ,DBO.FN_WORKERNAME(A.MAKER)		           AS WORKER         -- 작업자
		  ,CASE 
		       WHEN A.STATUS = 'R' THEN '가동중'
			   WHEN A.STATUS = 'S' THEN '비가동' END   AS STATUS
		  ,A.RSSTARTDATE		                       AS STARTDATE
		  ,A.RSENDDATE			                       AS ENDDATE
		  ,DATEDIFF(MI,A.RSSTARTDATE,A.RSENDDATE)	   AS PRODTIME	  -- 소요시간(분)
		  ,A.PRODQTY				                   AS PRODQTY
		  ,A.BADQTY 				                   AS BADQTY
		  ,A.REMARK 				                   AS REMARK 
		  ,DBO.FN_WORKERNAME(A.MAKER)				   AS MAKER      -- 등록자
		  ,CONVERT(VARCHAR,A.MAKEDATE,120)			   AS MAKEDATE   -- 등록일시
		  ,DBO.FN_WORKERNAME(A.EDITOR)				   AS EDITOR     -- 수정자 
		  ,CONVERT(VARCHAR,A.EDITDATE,120)			   AS EDITDATE   -- 수정일시


	FROM TP_WorkcenterStatusRec A WITH(NOLOCK) LEFT JOIN TB_WorkCenterMaster B WITH(NOLOCK)
		ON A.WORKCENTERCODE = B.WORKCENTERCODE

	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND A.WORKCENTERCODE			   LIKE '%' + @WORKCENTERCODE + '%'
	   AND A.RSSTARTDATE			   BETWEEN @STARTDATE AND @ENDDATE
END
GO
