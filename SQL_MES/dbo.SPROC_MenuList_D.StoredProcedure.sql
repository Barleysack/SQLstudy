USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_MenuList_D]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_MenuList_D]
(
	   @MENUID             VARCHAR(20)
	  ,@PARMENUID          VARCHAR(20)
	  ,@WORKERID           VARCHAR(20)
      ,@LANG         	   VARCHAR(10)='KO'
      ,@RS_CODE            VARCHAR(1)      OUTPUT
      ,@RS_MSG             VARCHAR(200)    OUTPUT 
)
AS
BEGIN
    BEGIN TRY 
        DELETE SYSMENULIST 
		 WHERE PARMENUID = @PARMENUID
		   AND MENUID    = @MENUID
		   AND WORKERID  = @WORKERID
     
	    SELECT @RS_CODE = 'S'
	END TRY
	
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
	
	SET NOCOUNT OFF;
END

GO
