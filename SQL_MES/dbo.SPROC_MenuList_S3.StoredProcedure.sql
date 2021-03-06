USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_MenuList_S3]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_MenuList_S3]
(
	   @WORKERID           VARCHAR(20)
	  ,@MENUID             VARCHAR(10)
	  ,@USEFLAG			   VARCHAR(1)
      ,@LANG         	   VARCHAR(10)='KO'
      ,@RS_CODE            VARCHAR(1)      OUTPUT
      ,@RS_MSG             VARCHAR(200)    OUTPUT 
)
AS
BEGIN
	SET NOCOUNT ON;
	IF ISNULL(@MENUID,'') = ''
	BEGIN
		SET @MENUID = 'X'
	END
    BEGIN TRY 
    	SELECT  'False' AS CHK
			  , MENUID 
			  , WORKERID 
			  , MENUNAME 
			  , PARMENUID 
			  , SORT
			  , PROGRAMID 
			  , MENUTYPE 
			  , USEFLAG
		  FROM SYSMENULIST WITH(NOLOCK)
		 WHERE PARMENUID = @MENUID
		   AND WORKERID  = @WORKERID 
		   AND USEFLAG   LIKE @USEFLAG  + '%'
		ORDER BY PARMENUID ,SORT 

     
	    SELECT @RS_CODE = 'S'
	END TRY
	
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
	
	SET NOCOUNT OFF;
END

GO
