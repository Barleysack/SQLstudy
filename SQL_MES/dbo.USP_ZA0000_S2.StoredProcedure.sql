USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZA0000_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ZA0000_S2]
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
          FROM TSY0300
         WHERE WORKERID = @WORKERID;
        
        IF @CNT > 0
        BEGIN
            SELECT @GRPID = CASE WHEN ISNULL(GRPID, '') = '' THEN NULL ELSE GRPID END
              FROM TSY0300
             WHERE WORKERID = @WORKERID;
        END;

        IF @WORKERID = 'SYSTEM'
        BEGIN
             SELECT @GRPID = 'SYSTEM';
        END;
        
            SELECT DISTINCT MENU.MENUID
	             , DBO.FN_TRANSLATE(@LANG,MENUNAME,'MN') AS MENUNAME
	              ,MENU.PARMENUID
	              ,MENU.SORT
	              ,MENU.PROGRAMID
	              ,MENU.MENUTYPE
	              ,PROGRAM.NAMESPACE
	              ,PROGRAM.FILEID
	        FROM TSY0200 MENU LEFT OUTER JOIN TSY0100 PROGRAM
	                                         ON MENU.PROGRAMID   = PROGRAM.PROGRAMID
	                                        AND PROGRAM.WORKERID = ISNULL(@GRPID, @WORKERID)
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
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]메인화면메뉴_탑' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZA0000_S2'
GO
