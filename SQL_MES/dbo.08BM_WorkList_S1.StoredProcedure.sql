USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[08BM_WorkList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김종우
-- Create date: 2021-06-07
-- Description:	작업자 마스터 조회
-- =============================================
CREATE PROCEDURE [dbo].[08BM_WorkList_S1] 
	@PLANTCODE VARCHAR(10),         -- 공장코드
	@WORKERID VARCHAR(20),	        -- 작업자 id
	@WORKERNAME VARCHAR(20),        -- 작업자 명
	@BANCODE VARCHAR(10),	        -- 작업반
	@USEFLAG VARCHAR(10),	        -- 사용여부

	@LANG VARCHAR(10)    = 'KO',    -- 언어
	@RS_CODE VARCHAR(10) OUTPUT,	-- 성공 여부
	@RS_MSG VARCHAR(200) OUTPUT		-- 성공 관련 메세지

AS
BEGIN
	SELECT A.PLANTCODE       -- 공장
		 , A.WORKERID		 -- 작업자ID
		 , A.WORKERNAME	     -- 작업자이름
		 , A.BANCODE		 -- 작업반
		 , A.GRPID		     -- 그룹ID
		 , A.DEPTCODE		 -- 부서코드
		 , A.PHONENO		 -- 연락처
		 , A.INDATE		     -- 입사일자
		 , A.OUTDATE		 -- 퇴사일자
		 , A.USEFLAG		 -- 사용여부
		 , DBO.FN_WORKERNAME(A.MAKER) AS MAKER	   -- 등록자
		 , A.MAKEDATE		 -- 등록일시
		 , DBO.FN_WORKERNAME(A.EDITOR) AS EDITOR   -- 수정자
		 , A.EDITDATE		 -- 수정일시
	  FROM TB_WorkerList A WITH(NOLOCK)
	 WHERE A.PLANTCODE           LIKE '%' + @PLANTCODE + '%'
	   AND A.WORKERID            LIKE '%' + @WORKERID + '%'
	   AND A.WORKERNAME          LIKE '%' + @WORKERNAME + '%'
	   AND ISNULL(A.BANCODE, '') LIKE '%' + @BANCODE + '%'
	   AND A.USEFLAG             LIKE '%' + @USEFLAG + '%'
END
GO
