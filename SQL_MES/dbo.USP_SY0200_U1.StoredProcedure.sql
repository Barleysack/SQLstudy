USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0200_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0200_U1]
(
	   @WORKERID        VARCHAR(30)
	  ,@WORKERNAME      VARCHAR(50)
	  ,@PWD             VARCHAR(100)
	  ,@GRPID			VARCHAR(10)
	  ,@PLANTCODE			VARCHAR(10)
	  ,@USEFLAG			VARCHAR(1)
	  ,@EDITOR          VARCHAR(20)
      ,@LANG         	VARCHAR(10) ='KO' 
 	  ,@RS_CODE         VARCHAR(1)='S' OUTPUT
      ,@RS_MSG          VARCHAR(200) OUTPUT 
)
AS
SET NOCOUNT ON;                                              
BEGIN               
	BEGIN TRY   
	    UPDATE TSY0300
	       SET WORKERNAME = @WORKERNAME
	          ,PWD        = CASE WHEN @PWD = '' THEN PWD ELSE @PWD END
	       	  ,GRPID	  = @GRPID
	       	  ,PLANTCODE  = @PLANTCODE
	       	  ,LANG       = @LANG
	          ,USEFLAG    = @USEFLAG
	          ,EDITOR     = @EDITOR
	          ,EDITDATE   = GETDATE()
	     WHERE WORKERID   = @WORKERID
	       
  
		SELECT @RS_CODE = 'S'
    END TRY
	BEGIN CATCH
		INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER() AS ERRORNUMBER
				 , ERROR_LINE() AS ERRORLINE
				 , ERROR_MESSAGE() AS ERRORMESSAGE
				 , GETDATE()
		
		SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
	END CATCH                 
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]사용자관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0200_U1'
GO
