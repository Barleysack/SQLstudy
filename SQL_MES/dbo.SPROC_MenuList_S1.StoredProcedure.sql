USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_MenuList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_MenuList_S1]
(
	   @WORKERID           VARCHAR(20)
	  ,@USEFLAG            VARCHAR(1)
      ,@LANG         	   VARCHAR(10)='KO'
      ,@RS_CODE            VARCHAR(1)      OUTPUT
      ,@RS_MSG             VARCHAR(200)    OUTPUT 
)
AS
BEGIN
	SET NOCOUNT ON;
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
		 WHERE PARMENUID = 0
		   AND WORKERID  LIKE @WORKERID + '%'
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
