USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_SY_ManagerMaster_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_SY_ManagerMaster_I1]
(
	   @WORKERID         VARCHAR(30)
	  ,@WORKERNAME       VARCHAR(50)
	  ,@PWD              VARCHAR(100)
	  ,@GRPID			 VARCHAR(10)
	  ,@PLANTCODE	     VARCHAR(10)
	  ,@USEFLAG			 VARCHAR(1)
	  ,@MAKER            VARCHAR(20)
      ,@LANG         	 VARCHAR(10) ='KO' 
 	  ,@RS_CODE          VARCHAR(1) OUTPUT
      ,@RS_MSG           VARCHAR(200) OUTPUT  
      )                                                              
AS        
BEGIN                                                     
	BEGIN TRY   			
	    INSERT INTO SysManList(WORKERID,  WORKERNAME,  PWD, GRPID, LANG, USEFLAG, PLANTCODE,  MAKER,  MAKEDATE)
	         VALUES           (@WORKERID, @WORKERNAME, @PWD, @GRPID, @LANG, @USEFLAG, @PLANTCODE, @MAKER, GETDATE());
 		SELECT @RS_CODE = 'S'                                                
	END TRY  
	
	BEGIN CATCH                                                              
	         SELECT  @RS_MSG = ERROR_MESSAGE()                               
	         SELECT  @RS_CODE = 'E'                                           
	
	END CATCH
END
GO
