USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03ER_REPAIRUPDATE_S33]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		정유경
-- Create date: 2021-06-18
-- Description:	고장/수리 등록 조회
-- =============================================
CREATE PROCEDURE [dbo].[03ER_REPAIRUPDATE_S33]
	 @PLANTCODE				VARCHAR(10) -- 공장      
	,@WORKCENTERCODE       	VARCHAR(10) -- 작업장
	,@STARTDATE 			VARCHAR(10) -- 조회 시작 일자
	,@ENDDATE				VARCHAR(10) -- 조회 종료 일자

	,@LANG					VARCHAR(5)    = 'KO' -- 언어
	,@RS_CODE				VARCHAR(1)   OUTPUT  -- 에러코드
	,@RS_MSG				VARCHAR(200) OUTPUT  -- 메세지
AS
BEGIN
	SELECT 0                                AS CHK				-- 수리 여부
	     , A.PLANTCODE                      AS PLANTCODE		-- 공장
		 , A.WORKCENTERCODE                 AS WORKCENTERCODE	-- 작업장 코드
		 , B.WORKCENTERNAME	                AS WORKCENTERNAME	-- 작업장 명
		 , A.MAKER			                AS MAKER			-- 고장 등록자
		 , CONVERT(VARCHAR, A.MAKEDATE,120) AS MAKEDATE			-- 고장 등록일시
		 , A.REMARK			                AS REMARK			-- 수리 내역
		 , A.REPAIRDATE		                AS REPAIRDATE		-- 수리 일시
		 , A.REPAIRMAN                      AS REPAIRMAN		-- 수리자(외부업체)
		 , A.REPAIRMAKER                    AS REPAIRMAKER		-- 수리 등록자
		 , A.ERRORSEQ                       AS ERRORSEQ			-- 고장 순번
		FROM TB_ErrorRec A WITH(NOLOCK) LEFT JOIN TB_WorkCenterMaster B WITH(NOLOCK)
											   ON A.PLANTCODE       = B.PLANTCODE
											  AND A.WORKCENTERCODE  = B.WORKCENTERCODE
		 
       WHERE A.PLANTCODE	  = B.PLANTCODE
         AND A.WORKCENTERCODE = B.WORKCENTERCODE
		 AND A.MAKEDATE    BETWEEN   @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'
		 AND A.REPAIRMAN IS NULL;

	SET @RS_CODE = 'S'
END

GO
