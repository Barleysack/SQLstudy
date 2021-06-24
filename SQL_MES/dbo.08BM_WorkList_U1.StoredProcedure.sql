USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[08BM_WorkList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김종우
-- Create date: 2021-06-08
-- Description:	작업자 마스터 갱신
-- =============================================
CREATE PROCEDURE [dbo].[08BM_WorkList_U1] 
	@PLANTCODE  VARCHAR(10),
	@WORKERID   VARCHAR(20), 
	@WORKERNAME VARCHAR(20),
	@GRPID      VARCHAR(10),    
	@DEPTCODE   VARCHAR(10), 
	@BANCODE    VARCHAR(10),  
	@USEFLAG    VARCHAR(1),  
	@PHONENO    VARCHAR(20),  
	@INDATE     VARCHAR(10),   
	@OUTDATE    VARCHAR(10),  
	@EDITOR     VARCHAR(10),
	
	@LANG       VARCHAR(10) = 'KO',
	@RS_CODE	VARCHAR(1)     OUTPUT,
	@RS_MSG		VARCHAR(200)   OUTPUT
AS
BEGIN
	UPDATE TB_WorkerList
	   SET WORKERNAME = @WORKERNAME
	      ,BANCODE    = @BANCODE
		  ,GRPID	  = @GRPID
		  ,DEPTCODE   = @DEPTCODE
		  ,PHONENO    = @PHONENO
		  ,INDATE     = @INDATE
		  ,OUTDATE    = @OUTDATE
		  ,USEFLAG    = @USEFLAG
		  ,EDITDATE   = GETDATE()
		  ,EDITOR	  = @EDITOR
	 WHERE PLANTCODE  = @PLANTCODE
	   AND WORKERID   = @WORKERID

	   SET @RS_CODE = 'S'
END
GO
