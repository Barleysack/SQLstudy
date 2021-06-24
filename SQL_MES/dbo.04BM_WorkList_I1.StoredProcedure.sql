USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[04BM_WorkList_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보성
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

	-- Add the parameters for the stored procedure here
	CREATE PROCEDURE [dbo].[04BM_WorkList_I1] 
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
	,@MAKER	    VARCHAR(10) -- 등록자
	
	,@LANG		VARCHAR(10) = 'KO'
	,@RS_CODE	VARCHAR(1)	 OUTPUT
	,@RS_MSG		VARCHAR(200) OUTPUT
	    
	
AS
BEGIN
	DECLARE @CNT INT -- 작업자 등록 여부 확인용
	SET	@CNT =0;
	
	BEGIN
		SELECT @CNT = COUNT(*)
		  FROM TB_WorkerList WITH(NOLOCK)
		 WHERE PLANTCODE = @PLANTCODE
		   AND WORKERID = @WORKERID
		IF(@CNT > 0)
		BEGIN
			SET @RS_CODE = 'E'
			SET @RS_MSG = '이미 등록된 사용자입니다'
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
