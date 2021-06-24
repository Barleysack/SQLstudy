USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[24BM_WorkList_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		홍건의
-- Create date: 2021-06-08
-- Description:	작업자 마스터 등록
-- =============================================
CREATE PROCEDURE [dbo].[24BM_WorkList_I1]
	@PLANTCODE  VARCHAR(10) 
	,@WORKERID   VARCHAR(20)  
	,@WORKERNAME VARCHAR(20)
	,@GRPID      VARCHAR(10)     
	,@DEPTCODE   VARCHAR(10)  
	,@BANCODE    VARCHAR(10) 
	,@USEFLAG    VARCHAR(1)   
	,@PHONENO    VARCHAR(20)   
	,@INDATE     VARCHAR(10)    
	,@OUTDATE    VARCHAR(10)   
	,@MAKER      VARCHAR(10)
	
	,@LANG       VARCHAR(10) = 'KO'
	,@RS_CODE    VARCHAR(1) OUTPUT
	,@RS_MSG     VARCHAR(200) OUTPUT
AS
BEGIN
  DECLARE @CNT INT
      SET @CNT = 0;

	  BEGIN
		   SELECT @CNT = COUNT(*)
		     FROM TB_WorkerList WITH(NOLOCK)
		    WHERE PLANTCODE = @PLANTCODE
			  AND WORKERID = @WORKERID

			   IF (@CNT > 0)
			   BEGIN
			     SET @RS_CODE = 'E'
				 SET @RS_MSG = '이미 등록된 사용자입니다.'
				 RETURN
			   END
	 END
	INSERT INTO TB_WorkerList
	(PLANTCODE, WORKERID, WORKERNAME, BANCODE, GRPID, PHONENO, INDATE, OUTDATE, MAKER, MAKEDATE, USEFLAG, DEPTCODE)
	VALUES
	(@PLANTCODE, @WORKERID, @WORKERNAME, @BANCODE, @GRPID, @PHONENO, @INDATE, @OUTDATE, @MAKER, GETDATE(), @USEFLAG, @DEPTCODE)
		   SET @RS_CODE = 'S'

END
GO
