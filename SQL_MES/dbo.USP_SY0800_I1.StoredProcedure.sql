USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0800_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0800_I1]
(
    @GRPID    	VARCHAR(20)
   ,@GRPNAME  	VARCHAR(20)
   ,@DISPLAYNO 	INT
   ,@MAKER    	VARCHAR(20)
   ,@EDITOR   	VARCHAR(20)
   ,@AS_SYSTEMID VARCHAR(20)
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
	
		IF @GRPID <> ''
		BEGIN
			IF EXISTS (SELECT 1 FROM TSY0300 WHERE WORKERID = @GRPID UNION SELECT 1 FROM TSY0310 WHERE GRPID = @GRPID)
			BEGIN
				SELECT @RS_CODE = 'E', @RS_MSG = DBO.FN_GETMESSAGE('R00126', @LANG)
				RETURN
			END
		    INSERT INTO TSY0310 (GRPID,   GRPNAME,  MAKER, MAKEDATE, DISPLAYNO)
		                  VALUES(@GRPID, @GRPNAME, @MAKER, GETDATE(), @DISPLAYNO)
		                  
		    IF @@ROWCOUNT > 0
		    BEGIN
		    	EXEC USP_SY0200_P1 'SYSTEM', @GRPID, @AS_SYSTEMID, @LANG, '', ''
				
		    END
		END                  
	END TRY
	BEGIN CATCH
         SELECT  @RS_MSG = ERROR_MESSAGE()
         SELECT  @RS_CODE = 'E'
	
	END CATCH            
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]그룹관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0800_I1'
GO
