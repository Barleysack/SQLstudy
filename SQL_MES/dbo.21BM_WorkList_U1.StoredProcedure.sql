USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[21BM_WorkList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		최민준
-- Create date: 2021-06-07
-- Description:	작업자 마스터 추가
-- =============================================
CREATE PROCEDURE [dbo].[21BM_WorkList_U1]
	@PLANTCODE VARCHAR(10),
	@WORKERID VARCHAR(20),
	@WORKERNAME VARCHAR(20),
	@GRPID VARCHAR(10),
	@DEPTCODE VARCHAR(10),
	@BANCODE VARCHAR(10), 
	@USEFLAG VARCHAR(1), 
	@PHONENO VARCHAR(20), 
	@INDATE VARCHAR(20), 
	@OUTDATE VARCHAR(10), 
	@EDITOR VARCHAR(10),

	@LANG VARCHAR(10) = 'KO',
	@RS_CODE VARCHAR(10) OUTPUT,   -- 성공여부
	@RS_MSG VARCHAR(200) OUTPUT    -- 성공여부 관련 메세지
AS
BEGIN
	UPDATE TB_WorkerList
	SET WORKERNAME = @WORKERNAME,
		GRPID = @GRPID ,
		DEPTCODE = @DEPTCODE ,
		BANCODE = @BANCODE ,
		USEFLAG = @USEFLAG ,
		PHONENO = @PHONENO ,
		INDATE = @INDATE ,
		OUTDATE = @OUTDATE ,
		EDITDATE = GETDATE(),
		EDITOR = @EDITOR
	WHERE PLANTCODE = @PLANTCODE
	AND WORKERID = @WORKERID

	SET @RS_CODE = 'S'
END
GO
