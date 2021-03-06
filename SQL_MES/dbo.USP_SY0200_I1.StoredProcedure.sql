USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0200_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0200_I1]
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
	    INSERT INTO TSY0300(WORKERID,  WORKERNAME,  PWD, GRPID, LANG, USEFLAG, PLANTCODE,  MAKER,  MAKEDATE)
	    			 VALUES(@WORKERID, @WORKERNAME, @PWD, @GRPID, @LANG, @USEFLAG, @PLANTCODE, @MAKER, GETDATE());
	    			 
 		SELECT @RS_CODE = 'S'                                                
	  
	  	IF NOT EXISTS(SELECT 1 FROM TSY0100 WHERE WORKERID = @WORKERID)
	  		EXEC USP_SY0200_P1 'SYSTEM', @WORKERID, 'SMARTMES', 'KO', '', ''
	END TRY  
	
	BEGIN CATCH                                                              
	         SELECT  @RS_MSG = ERROR_MESSAGE()                               
	         SELECT  @RS_CODE = 'E'                                           
	
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]사용자관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0200_I1'
GO
