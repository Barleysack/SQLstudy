USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_GetPatchVersion]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_GetPatchVersion]    
/*******************************************************************************
패치 파일버전 조회
********************************************************************************/                                 
 ( 
     @AS_SYSTEMID				VARCHAR(20)
    ,@AS_FILEID					VARCHAR(30)
    ,@LANG					    VARCHAR(10)='KO'
   	,@RS_CODE				    VARCHAR(1)    OUTPUT
    ,@RS_MSG				    VARCHAR(200)  OUTPUT
               
 )                                                                 
AS                                                                 
BEGIN                                                              
    BEGIN TRY                                                                  
      	SELECT T1.SYSTEMID,
               T1.JOBID,
               T1.FILEID,
               T1.FILEVER,
               T1.SPATH,
               T1.CPATH,
               T1.PROCGB,
               T1.FILESIZE,
               T1.FILEIMAGE
          FROM SysPatchFile T1 WITH(NOLOCK)
         WHERE T1.SYSTEMID = @AS_SYSTEMID
           AND T1.FILEID   = @AS_FILEID
         ORDER BY T1.JOBID;
                                                                                         
    SELECT @RS_CODE = 'S'                                                                
 END TRY                                                                                  
                                                                                         
BEGIN CATCH                                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                            
         SELECT @RS_CODE = 'E'           
 END CATCH    
END

GO
