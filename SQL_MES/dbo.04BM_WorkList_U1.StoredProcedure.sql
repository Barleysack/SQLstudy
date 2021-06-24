USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[04BM_WorkList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보성
-- Create date: <Create Date,,>
-- Description:	업데이트 작업자
-- =============================================
CREATE PROCEDURE [dbo].[04BM_WorkList_U1]
	-- Add the parameters for the stored procedure here
		 @PLANTCODE  VARCHAR(10) -- 공장
	,@WORKERID	 VARCHAR(20) -- 작업자 ID 
	,@WORKERNAME VARCHAR(20) -- 작업자 명
	,@BANCODE	VARCHAR(10) -- 그룹
	,@GRPID		VARCHAR(10) -- 부서코드
	,@DEPTCODE	VARCHAR(10) -- 반코드
	,@USEFLAG	VARCHAR(1)  -- 사용여부
	,@PHONENO	VARCHAR(20) -- 연락처
	,@INDATE		VARCHAR(10) -- 입사일자
	,@OUTDATE	VARCHAR(10) -- 퇴사일자
	,@EDITOR	    VARCHAR(10) -- 수정자
	
	,@LANG		VARCHAR(10) = 'KO'
	,@RS_CODE	VARCHAR(1)	 OUTPUT
	,@RS_MSG		VARCHAR(200) OUTPUT
AS
BEGIN
UPDATE TB_WorkerList
	   SET WORKERNAME = @WORKERNAME
		  ,WORKERID   = @WORKERID
		  ,BANCODE	  = @BANCODE
		  ,GRPID	  = @GRPID
		  ,DEPTCODE	  = @DEPTCODE
		  ,PHONENO	  = @PHONENO
		  ,INDATE	  = @INDATE
		  ,OUTDATE	  = @OUTDATE
		  ,USEFLAG	  = @USEFLAG
		  ,EDITDATE   = GETDATE()
		  ,EDITOR	  = @EDITOR
	    WHERE PLANTCODE = @PLANTCODE
		  AND WORKERID = @WORKERID

		SET @RS_CODE = 'S'
END
GO
