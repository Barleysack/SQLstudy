USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0200_D2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0200_D2]
(
	   @WORKERID        	VARCHAR(30)
	  ,@LANG             	VARCHAR(10)
	  ,@RS_CODE            	VARCHAR(1)      OUTPUT
      ,@RS_MSG             	VARCHAR(200)    OUTPUT  
)
AS
BEGIN
	BEGIN TRY
	  
	      DELETE TSY0301 
	       WHERE WORKERID = @WORKERID 
	 
	    SELECT @RS_CODE = 'S'
	END TRY
	
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]사용자관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0200_D2'
GO
