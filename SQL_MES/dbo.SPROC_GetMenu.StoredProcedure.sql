USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_GetMenu]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_GetMenu]
(
      @WORKERID            VARCHAR(20)
     ,@SYSTEMID			   VARCHAR(50)
     ,@PARMENUID           INTEGER
     ,@LANG                VARCHAR(10)='KO'
     ,@RS_CODE             VARCHAR(1) OUTPUT
     ,@RS_MSG              VARCHAR(200) OUTPUT 
)                                  
AS                                 
BEGIN
    DECLARE @CNT          INTEGER
    DECLARE @GRPID        VARCHAR(20)
    
	BEGIN TRY
        SELECT @CNT = COUNT(*)
          FROM SysManList WITH(NOLOCK)
         WHERE WORKERID = @WORKERID;
        
        IF @CNT > 0
        BEGIN
            SELECT @GRPID = CASE WHEN ISNULL(GRPID, '') = '' THEN NULL ELSE GRPID END
              FROM SysManList WITH(NOLOCK)
             WHERE WORKERID = @WORKERID;
        END;

        IF @WORKERID = 'SYSTEM'
        BEGIN
             SELECT @GRPID = 'SYSTEM';
        END;
        
            SELECT DISTINCT MENU.MENUID
	              ,MENUNAME   AS MENUNAME
	              ,MENU.PARMENUID
	              ,MENU.SORT
	              ,MENU.PROGRAMID
	              ,MENU.MENUTYPE
	              ,PROGRAM.NAMESPACE
	              ,PROGRAM.FILEID
	        FROM SysMenuList MENU  with(nolock)  LEFT OUTER JOIN sysProgramList PROGRAM WITH(NOLOCK)
															  ON MENU.PROGRAMID   = PROGRAM.PROGRAMID
														     AND PROGRAM.WORKERID = @WORKERID
															 AND PROGRAM.SYSTEMID = @SYSTEMID
	     WHERE MENU.WORKERID   = @WORKERID 
	        AND MENU.USEFLAG   = 'Y'
	        AND MENU.SYSTEMID  = @SYSTEMID
	        AND MENU.PARMENUID = @PARMENUID
	   ORDER BY MENU.PARMENUID, MENU.SORT;  
    
		SELECT @RS_CODE = 'S'

	END TRY                           
	BEGIN CATCH
	
	     SELECT  @RS_MSG = ERROR_MESSAGE()
	     SELECT @RS_CODE = 'E'                 
	END CATCH    
END



GO
