USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_Standard_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_Standard_I1]
(
	   @MAJORCODE        VARCHAR(30)
	  ,@CODENAME         VARCHAR(100)
	  ,@SYSFLAG          VARCHAR(100)
	  ,@MAKER            VARCHAR(20)
      ,@SYSTEMID         VARCHAR(20)
      ,@UIDNAME          VARCHAR(200)
	  ,@LANG             VARCHAR(10)='KO'
      ,@RS_CODE          VARCHAR(1)    OUTPUT                            
      ,@RS_MSG           VARCHAR(200)  OUTPUT   
)
AS
	SELECT @MAJORCODE = LTRIM(RTRIM(ISNULL(@MAJORCODE, '')))
		 , @CODENAME  = LTRIM(RTRIM(ISNULL(@CODENAME, '')))
		 , @SYSFLAG   = LTRIM(RTRIM(ISNULL(@SYSFLAG, 0)))
	     , @MAKER     = LTRIM(RTRIM(ISNULL(@MAKER, '')))
	   	 , @SYSTEMID  = LTRIM(RTRIM(ISNULL(@SYSTEMID, 0)))
	     , @LANG      = LTRIM(RTRIM(ISNULL(@LANG, '')))
	   	 , @UIDNAME   = LTRIM(RTRIM(ISNULL(@UIDNAME, '')))
/**********************************************************************************************
기준정보 등록
**********************************************************************************************/
BEGIN TRY
       DECLARE @UID VARCHAR(20)

       INSERT INTO TB_Standard
                  (
                   MAJORCODE
                  ,MINORCODE
                  ,CODENAME 
                  ,SYSFLAG  
                  ,UIDSYS
                  ,USEFLAG  
                  ,MAKER
                  ,MAKEDATE   
                  )
            VALUES 
                  (
                   @MAJORCODE
                  ,'$'       
                  ,@CODENAME
                  ,@SYSFLAG	
                  ,@UID 
                  ,'Y'		 
                  ,@MAKER
                  ,GETDATE() 
                  );         
    SELECT @RS_CODE = 'S'                                                
END TRY                                                                                                                                           
BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
END CATCH
GO
