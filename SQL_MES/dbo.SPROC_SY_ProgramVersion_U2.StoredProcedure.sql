USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_SY_ProgramVersion_U2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_SY_ProgramVersion_U2]
/*******************************************************************************
패치 버전 갱신
********************************************************************************/  
(
     @SYSTEMID         VARCHAR(020)
    ,@JOBID            INT
    ,@FILEID           VARCHAR(255)
    ,@FILEVER          VARCHAR(255)
    ,@SPATH            VARCHAR(255)
    ,@CPATH            VARCHAR(255)
    ,@PROCGB           VARCHAR(010)
    ,@FILESIZE         NUMERIC(18, 3)
    ,@FILEIMAGE        IMAGE
    ,@DESCRIPT         VARCHAR(200)
    ,@EDITOR           VARCHAR(020)
    ,@LANG             VARCHAR(10)='KO'
	,@RS_CODE          VARCHAR(1)    OUTPUT                            
    ,@RS_MSG           VARCHAR(200)  OUTPUT  
)
AS
BEGIN TRY
    UPDATE SysPatchFile
       SET FILEID     = @FILEID   
          ,FILEVER    = @FILEVER
          ,SPATH      = @SPATH   
          ,CPATH      = @CPATH 
          ,PROCGB     = @PROCGB   
          ,FILESIZE   = @FILESIZE 
          ,FILEIMAGE  = @FILEIMAGE
          ,DESCRIPT   = @DESCRIPT 
          ,EDITOR     = @EDITOR   
          ,EDITDATE   = GETDATE()
     WHERE SYSTEMID   = @SYSTEMID 
       AND JOBID      = @JOBID;
    
    SELECT @RS_CODE = 'S'
END TRY
BEGIN CATCH
         SELECT  @RS_MSG = ERROR_MESSAGE()
         SELECT  @RS_CODE = 'E'
END CATCH
GO
