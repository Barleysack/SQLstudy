USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_SY_ProgramVersion_I2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_SY_ProgramVersion_I2]
/*******************************************************************************
패치 버전 등록
********************************************************************************/  
(
     @SYSTEMID         VARCHAR(020)
    ,@FILEID           VARCHAR(255)
    ,@FILEVER          VARCHAR(20)
    ,@SPATH            VARCHAR(255)
    ,@CPATH            VARCHAR(255)
    ,@PROCGB           VARCHAR(010)
    ,@FILESIZE         NUMERIC(18, 3)
    ,@FILEIMAGE        IMAGE
    ,@DESCRIPT         VARCHAR(200)
    ,@MAKER            VARCHAR(020)
    ,@LANG      	   VARCHAR(10)='KO'
	,@RS_CODE          VARCHAR(1)    OUTPUT                            
    ,@RS_MSG           VARCHAR(200)  OUTPUT  
)
AS
BEGIN
	DECLARE @V_JOBSEQ INT
	
	BEGIN TRY
		SELECT @V_JOBSEQ = ISNULL((MAX(JOBID)), 0) + 1 FROM SysPatchFile WITH(NOLOCK) WHERE SYSTEMID = @SYSTEMID
		
	    INSERT INTO SysPatchFile
	               (SYSTEMID
	               ,JOBID
	               ,JOBSEQ
	               ,FILEID
	               ,FILEVER
	               ,SPATH
	               ,CPATH
	               ,PROCGB
	               ,FILESIZE
	               ,FILEIMAGE
	               ,DESCRIPT
	               ,MAKER
	               ,MAKEDATE)
	         SELECT @SYSTEMID
	               ,@V_JOBSEQ
	               ,@V_JOBSEQ
	               ,@FILEID
	               ,@FILEVER
	               ,@SPATH
	               ,@CPATH
	               ,@PROCGB
	               ,@FILESIZE
	               ,@FILEIMAGE
	               ,@DESCRIPT
	               ,@MAKER
	               ,GETDATE()
	    
	    SELECT @RS_CODE = 'S'
	END TRY
	BEGIN CATCH
	         SELECT  @RS_MSG = ERROR_MESSAGE()
	         SELECT  @RS_CODE = 'E'
	         PRINT   @RS_MSG
	END CATCH
END
GO
