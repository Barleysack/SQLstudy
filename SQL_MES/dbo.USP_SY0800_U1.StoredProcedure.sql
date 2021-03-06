USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0800_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0800_U1]
(
    @GRPID    	VARCHAR(20)
   ,@GRPNAME  	VARCHAR(20)
   ,@DISPLAYNO 	INT
   ,@EDITOR   	VARCHAR(20)
   ,@LANG 		VARCHAR(10) = 'KO'
   ,@RS_CODE 	VARCHAR(1) OUTPUT
   ,@RS_MSG		NVARCHAR(255) OUTPUT
)
AS
	SELECT @GRPID = RTRIM(LTRIM(ISNULL(@GRPID, '')))
	      ,@GRPNAME = RTRIM(LTRIM(ISNULL(@GRPNAME, '')))
	      ,@RS_CODE = 'S'
BEGIN
	BEGIN TRY
	    UPDATE TSY0310 
	       SET GRPNAME  = @GRPNAME
	       	  ,DISPLAYNO= @DISPLAYNO
	          ,EDITOR   = @EDITOR
	          ,EDITDATE = GETDATE()
	     WHERE GRPID    = @GRPID
	END TRY
	BEGIN CATCH
         SELECT  @RS_MSG = ERROR_MESSAGE()
         SELECT  @RS_CODE = 'E'
	END CATCH            
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]그룹관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0800_U1'
GO
