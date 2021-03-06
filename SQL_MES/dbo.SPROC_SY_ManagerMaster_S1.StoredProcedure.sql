USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_SY_ManagerMaster_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_SY_ManagerMaster_S1]
(
	   @WORKERID        VARCHAR(30)
	  ,@WORKERNAME		VARCHAR(30)
	  ,@USEFLAG 		VARCHAR(1)
	  ,@LANG            VARCHAR(10)
	  ,@RS_CODE         VARCHAR(1)      OUTPUT
      ,@RS_MSG          VARCHAR(200)    OUTPUT  
)
AS
BEGIN
	BEGIN TRY
	      SELECT WORKERID						 AS WORKERID  
	            ,WORKERNAME						 AS WORKERNAME 	
		        ,'DC00'							 AS PWD	
		        ,GRPID					         AS GRPID			
		        ,PLANTCODE						 AS PLANTCODE
		        ,LANG							 AS LANG
		        ,USEFLAG						 AS USEFLAG
		        ,DBO.FN_WORKERNAME(MAKER)	     AS MAKER
		        ,MAKEDATE					     AS MAKEDATE
		        ,DBO.FN_WORKERNAME(MAKER)	     AS EDITOR
		        ,EDITDATE						 AS EDITDATE
	        FROM SysManList	WITH(NOLOCK)
	       WHERE WORKERID 	LIKE '%' + @WORKERID + '%'
	         AND WORKERNAME LIKE '%' + @WORKERNAME + '%'
	         AND USEFLAG  	LIKE @USEFLAG + '%'
	         AND WORKERID 	<> 'SYSTEM'
	    ORDER BY WORKERNAME
	    
	    SELECT @RS_CODE = 'S'
	END TRY
	
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
	END CATCH
END

GO
