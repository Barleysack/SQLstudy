USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0100_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0100_U1]
(
	   @WORKERID         VARCHAR(50)
	  ,@MENUID           VARCHAR(50)
	  ,@MENUNAME         VARCHAR(255)  
	  ,@PARMENUID        VARCHAR(50)
	  ,@SORT             INT
	  ,@PROGRAMID        VARCHAR(50)
	  ,@MENUTYPE         VARCHAR(5)
	  ,@USEFLAG          VARCHAR(1)
	  ,@REMARK           VARCHAR(500)
	  ,@EDITOR           VARCHAR(10)
      ,@UIDNAME          VARCHAR(200)
      ,@SYSTEMID         VARCHAR(20)
      ,@LANG             VARCHAR(5)
	  ,@RS_CODE          VARCHAR(1)   OUTPUT
      ,@RS_MSG           VARCHAR(200) OUTPUT    
)
AS
BEGIN
    DECLARE @MENYUID VARCHAR(20)
	BEGIN TRY
    	
      	IF (@LANG='KO')
      	BEGIN
        	EXEC  USP_ZZ9100_I1 @LANG,@MENUNAME,'MN'
      	END
      
        UPDATE TSY0200
           SET MENUNAME  = CASE WHEN @LANG='KO' THEN @MENUNAME   ELSE MENUNAME END 
              ,PARMENUID = @PARMENUID 
              ,SORT      = @SORT	   
              ,PROGRAMID = @PROGRAMID 
              ,MENUTYPE  = @MENUTYPE  
              ,USEFLAG   = @USEFLAG   
              ,REMARK    = @REMARK	   
              ,EDITOR    = @EDITOR	   
              ,EDITDATE  = GETDATE() 
         WHERE MENUID    = @MENUID
           AND WORKERID  = 'SYSTEM'
           AND SYSTEMID = @SYSTEMID 
    
	    SELECT @RS_CODE = 'S'
		RETURN
	END TRY
                                
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH                
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]메뉴관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0100_U1'
GO
