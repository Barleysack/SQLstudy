USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[20PP_WCTRunStopList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		정유경
-- Create date: 2021-06-15
-- Description:	작업장 비가동 현황 및 사유관리
-- =============================================
CREATE PROCEDURE [dbo].[20PP_WCTRunStopList_S1]
	@PLANTCODE         VARCHAR(10)
   ,@WORKCENTERCODE    VARCHAR(30)
   ,@STARTDATE         VARCHAR(10)
   ,@ENDDATE           VARCHAR(10)

   ,@LANG              VARCHAR(10) = 'KO'
   ,@RS_CODE           VARCHAR(1)    OUTPUT
   ,@RS_MSG            VARCHAR(200)  OUTPUT

AS
BEGIN
	SELECT A.PLANTCODE                                              AS PLANTCODE        -- 공장
		 , A.WORKCENTERCODE											AS WORKCENTERCODE	-- 작업장
		 , B.WORKCENTERNAME                                         AS WORKCENTERNAME   -- 작업장 명
		 , A.ORDERNO												AS ORDERNO			-- 작업지시 번호
		 , A.ITEMCODE                                               AS ITEMCODE         -- 품목 코드
		 , C.ITEMNAME												AS ITEMNAME			-- 품명
		 , DBO.FN_WORKERNAME(A.MAKER)                               AS WORKER		    -- 작업자
		 , CASE WHEN A.STATUS = 'R' THEN '가동' 
				ELSE '비가동'
				END													AS WORKSTATUS       -- 가동/비가동 상태
		 , A.RSSTARTDATE                                            AS STARTDATE        -- 시작 일시
		 , A.RSENDDATE                                              AS ENDDATE          -- 종료 일시
		 , CASE WHEN A.RSENDDATE IS NULL THEN ''
				ELSE DATEDIFF(mi, A.RSSTARTDATE, A.RSENDDATE)
				END													AS SPENDTIME		-- 소요 시간(분)
		 , A.PRODQTY												AS PRODQTY			-- 양품 수량
		 , A.BADQTY													AS BADQTY			-- 불량 수량
		 , CASE WHEN A.REMARK IS NULL THEN ''
				ELSE A.REMARK
				END													AS REMARK			-- 사유
		 , A.MAKER													AS MAKER			-- 등록자
		 , A.MAKEDATE												AS MAKEDATE			-- 등록일시
		 , A.EDITOR													AS EDITOR			-- 수정자
		 , A.EDITDATE												AS EDITDATE			-- 수정일시
		 , A.RSSEQ													AS RSSEQ			-- 순번

	  FROM TP_WorkcenterStatusRec A WITH(NOLOCK) LEFT JOIN TB_WorkCenterMaster B WITH(NOLOCK)
											       ON A.PLANTCODE       = B.PLANTCODE
											      AND A.WORKCENTERCODE  = B.WORKCENTERCODE

											     LEFT JOIN TB_ItemMaster C WITH(NOLOCK) 
												   ON A.PLANTCODE = C.PLANTCODE
											      AND A.ITEMCODE  = C.ITEMCODE
											  

	WHERE A.PLANTCODE                  LIKE '%' + @PLANTCODE + '%'
	  AND A.WORKCENTERCODE             LIKE '%' + @WORKCENTERCODE + '%'
	  AND A.RSENDDATE                  BETWEEN    @STARTDATE AND @ENDDATE
END
GO
