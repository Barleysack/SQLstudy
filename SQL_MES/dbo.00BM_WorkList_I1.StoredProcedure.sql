USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[00BM_WorkList_I1]    Script Date: 2021-06-22 오후 5:42:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		동상현
-- Create date: 2021-06-08
-- Description:	작업자 마스터 등록
-- =============================================
CREATE PROCEDURE [dbo].[00BM_WorkList_I1]
	 @PLANTCODE  VARCHAR(10) -- 공장
	,@WORKERID   VARCHAR(20) -- 작업자 ID
	,@WORKERNAME VARCHAR(20) -- 작업자 명
	,@GRPID      VARCHAR(10) -- 그룹
	,@DEPTCODE   VARCHAR(10) -- 부서코드
	,@BANCODE    VARCHAR(10) -- 반 코드
	,@USEFLAG    VARCHAR(1)  -- 사용여부
	,@PHONENO    VARCHAR(20) -- 연락처
	,@INDATE	 VARCHAR(10) -- 입사일자
	,@OUTDATE    VARCHAR(10) -- 퇴사일자
	,@MAKER      VARCHAR(10) -- 등록자

	,@LANG        VARCHAR(10) = 'KO' 
	,@RS_CODE     VARCHAR(1)   OUTPUT
	,@RS_MSG      VARCHAR(200) OUTPUT
	
AS
BEGIN
   DECLARE @CNT INT -- 작업자 등록 여부 확인용
   SET  @CNT = 0;

   BEGIN
        SELECT @CNT = COUNT(*)
	      FROM TB_WorkerList WITH(NOLOCK)
		 WHERE PLANTCODE = @PLANTCODE
		   AND WORKERID  = @WORKERID

		IF (@CNT > 0)
		BEGIN 
			SET @RS_CODE = 'E'
			SET @RS_MSG  = '이미 등록된 사용자 입니다.'
			RETURN
		END
   END

   INSERT INTO TB_WorkerList
   (PLANTCODE,    WORKERID,    WORKERNAME,     BANCODE,     GRPID,      PHONENO,     INDATE,    OUTDATE,
    MAKER,        MAKEDATE,	   USEFLAG,        DEPTCODE)
   VALUES
   (@PLANTCODE,   @WORKERID,   @WORKERNAME,    @BANCODE,    @GRPID,     @PHONENO,    @INDATE,   @OUTDATE,
   @MAKER,        GETDATE(),   @USEFLAG,       @DEPTCODE)

   SET @RS_CODE = 'S'
END
GO
