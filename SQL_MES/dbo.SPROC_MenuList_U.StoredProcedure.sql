USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_MenuList_U]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_MenuList_U]
(
	   @MENUID			   INT
	  ,@MENUNAME	       VARCHAR(50)
	  ,@PARMENUID		   INT
	  ,@SORT			   INT
	  ,@PROGRAMID          VARCHAR(20)
	  ,@MENUTYPE		   VARCHAR(1)
	  ,@USEFLAG			   VARCHAR(1)
	  ,@WORKERID		   VARCHAR(10)
      ,@LANG         	   VARCHAR(10)='KO'
      ,@RS_CODE            VARCHAR(1)      OUTPUT
      ,@RS_MSG             VARCHAR(200)    OUTPUT 
)
AS
BEGIN
    BEGIN TRY 
        UPDATE SysMenuList
		   SET  MENUNAME  = @MENUNAME
		      , SORT      = @SORT
			  , PROGRAMID = @PROGRAMID
			  , MENUTYPE  = @MENUTYPE
			  , USEFLAG   = @USEFLAG
		 WHERE MENUID	  = @MENUID
		   AND PARMENUID  = @PARMENUID
		   AND WORKERID   = @WORKERID


	    SELECT @RS_CODE   = 'S'
	END TRY
	
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
	
	SET NOCOUNT OFF;
END



GO
