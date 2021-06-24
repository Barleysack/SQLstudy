USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[04PP_WCTRunStopList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보성
-- Create date: 2021-06-10
-- Description:	생산 대상. 작업지시 조회
-- =============================================
CREATE PROCEDURE [dbo].[04PP_WCTRunStopList_S1]
	@PLANTCODE      VARCHAR(10)
   ,@WORKCENTERCODE VARCHAR(10)
   ,@STARTDATE      VARCHAR(10)
   ,@ENDDATE        VARCHAR(10)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE	    VARCHAR(1)    OUTPUT
   ,@RS_MSG			VARCHAR(200)  OUTPUT
	
AS
BEGIN
	SELECT A.PLANTCODE													AS PLANTCODE      -- 공장   
		  ,A.RSSEQ														AS RSSEQ -- 작업장
		  ,A.WORKCENTERCODE												AS WORKCENTERCODE -- 작업장
		  ,C.WORKCENTERNAME												AS WORKCENTERNAME -- 작업장명
	      ,A.ORDERNO   													AS ORDERNO		  -- 작업지시 번호
		  ,A.ITEMCODE													AS ITEMCODE	      -- 품목 코드
		  ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,'KO')				AS ITEMNAME	      -- 품목 코드
		  ,DBO.FN_WORKERNAME(A.MAKER)									AS WORKER         -- 작업자
		  ,CASE WHEN A.STATUS = 'R' THEN '가동중' ELSE '비가동' END		AS WORKSTATUS     -- 가동/비가동 상태
		  ,A.RSSTARTDATE												AS STARTDATE      -- 시작 시간
		  ,A.RSENDDATE													AS ENDDATE        -- 종료 시간
		  ,DATEDIFF(MI,A.RSSTARTDATE,A.RSENDDATE)						AS SPENTTIME	  -- 소요시간(분)
		  ,A.PRODQTY													AS PRODQTY		  -- 양품수량
		  ,A.BADQTY														AS BADQTY         -- 불량수량
		  ,A.REMARK														AS REMARK		  -- 사유
		  ,DBO.FN_WORKERNAME(A.MAKER)									AS MAKER      -- 등록자
		  ,CONVERT(VARCHAR,A.MAKEDATE,120)								AS MAKEDATE   -- 등록일시
		  ,DBO.FN_WORKERNAME(A.EDITOR)									AS EDITOR     -- 수정자 
		  ,CONVERT(VARCHAR,A.EDITDATE,120)								AS EDITDATE   -- 수정일시

	  FROM TP_WorkcenterStatusRec A WITH(NOLOCK) 
		LEFT JOIN TB_WorkCenterMaster C WITH(NOLOCK)
		ON A.WORKCENTERCODE = C.WORKCENTERCODE

	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND A.WORKCENTERCODE            LIKE '%' + @WORKCENTERCODE + '%'
	   AND A.RSSTARTDATE			   BETWEEN @STARTDATE AND @ENDDATE
END


GO
