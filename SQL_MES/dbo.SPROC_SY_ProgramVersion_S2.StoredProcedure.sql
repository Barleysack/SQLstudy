USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_SY_ProgramVersion_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_SY_ProgramVersion_S2]    
/*******************************************************************************
 파일버전 조회 2
********************************************************************************/                                 
 ( 
     @SYSTEMID						VARCHAR(20)
    ,@LANG							VARCHAR(10)='KO'
	,@RS_CODE						VARCHAR(1)    OUTPUT
    ,@RS_MSG						VARCHAR(200)  OUTPUT
               
 )                                                                 
AS                                                                 
BEGIN         
                                                          
    BEGIN TRY                                                                  
 	  SELECT A.SYSTEMID    AS SYSTEMID
             , A.JOBID       AS JOBID
             , A.JOBSEQ      AS JOBSEQ
             , A.FILEID      AS FILEID
             , A.FILEVER     AS FILEVER
             , A.SPATH       AS SPATH
             , A.CPATH       AS CPATH
             , A.PROCGB      AS PROCGB
             , A.FILESIZE    AS FILESIZE
             , FILEIMAGE	 AS FILEIMAGE   -- UI에서 FILE IMAGE를 확인하지 않기 때문에 EMPTY FILEIMAGE 사용(속도 개선)
             , A.DESCRIPT    AS DESCRIPT
             , A.MAKER       AS MAKER
             , A.MAKEDATE    AS MAKEDATE
             , A.EDITOR      AS EDITOR
             , A.EDITDATE    AS EDITDATE
             , ''            AS UPLOADPATH
          FROM SysPatchFile A
         WHERE A.SYSTEMID =  @SYSTEMID
         ORDER BY A.JOBSEQ, A.JOBID;

                                                                                         
    SELECT @RS_CODE = 'S'                                                                
 END TRY                                                                                  
                                                                                         
BEGIN CATCH                                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                            
         SELECT @RS_CODE = 'E'           
 END CATCH    
END

GO
