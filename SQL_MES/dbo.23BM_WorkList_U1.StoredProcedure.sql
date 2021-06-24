USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[23BM_WorkList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		한정은
-- Create date: 2021-06-08
-- Description:	작업자 마스터 갱신
-- =============================================
CREATE PROCEDURE [dbo].[23BM_WorkList_U1]
      @PLANTCODE  VARCHAR(10) -- 공장
     ,@WORKERID   VARCHAR(20) -- 작업자 ID
     ,@WORKERNAME VARCHAR(20) -- 작업자 명
     ,@GRPID      VARCHAR(10) -- 그룹
     ,@DEPTCODE   VARCHAR(10) -- 부서코드
     ,@BANCODE    VARCHAR(10) -- 반 코드
     ,@USEFLAG    VARCHAR(1)  -- 사용여부 
     ,@PHONENO    VARCHAR(20) -- 연락처
     ,@INDATE     VARCHAR(10) -- 입사일자
     ,@OUTDATE    VARCHAR(10) -- 퇴사일자
     ,@EDITOR   	  VARCHAR(10) -- 등록자

	 ,@LANG       VARCHAR(10) = 'OK'
	 ,@RS_CODE    VARCHAR(1)  OUTPUT
	 ,@RS_MSG    VARCHAR(200) OUTPUT
AS
BEGIN
	UPDATE TB_WorkerList
		SET WORKERNAME = @WORKERNAME
			,BANCODE   = @BANCODE
			,GRPID     = @GRPID
			,DEPTCODE  = @DEPTCODE
			,PHONENO   = @PHONENO
			,INDATE    = @INDATE
			,OUTDATE   = @OUTDATE
			,USEFLAG   = @USEFLAG
			,EDITDATE  = GETDATE()
			,EDITOR    = @EDITOR
	WHERE PLANTCODE    = @PLANTCODE
		AND WORKERID   = @WORKERID

	SET @RS_CODE = 'S'
END
GO
