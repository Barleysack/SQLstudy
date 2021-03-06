USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0101_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0101_U1]
(
	   @AS_WORKERID         VARCHAR(50)
	  ,@AS_MENUID           VARCHAR(50)
	  ,@AS_MENUNAME         VARCHAR(255)  
	  ,@AS_PARMENUID        VARCHAR(50)
	  ,@AS_SORT             INT
	  ,@AS_PROGRAMID        VARCHAR(50)
	  ,@AS_MENUTYPE         VARCHAR(5)
	  ,@AS_USEFLAG          VARCHAR(1)
	  ,@AS_REMARK           VARCHAR(500)
	  ,@AS_MAKER            VARCHAR(10)
	  ,@AS_EDITOR           VARCHAR(10)
	  ,@AS_PROGRAMNAME      VARCHAR(255)
	  ,@AS_PROGTYPE         VARCHAR(255)
	  ,@AS_FILEID           VARCHAR(255)
	  ,@AS_NAMESPACE        VARCHAR(255)
	  ,@AS_INQFLAG			BIT
	  ,@AS_NEWFLAG			BIT
	  ,@AS_DELFLAG			BIT
	  ,@AS_SAVEFLAG			BIT
	  ,@AS_EXCELFLAG		BIT
	  ,@AS_PRNFLAG			BIT
	  ,@AS_PROGRAMREMARK 	VARCHAR(255)
      ,@LANG         		VARCHAR(10) ='KO' 
 	  ,@RS_CODE         	VARCHAR(1) OUTPUT
      ,@RS_MSG          	VARCHAR(200) OUTPUT   
)
AS
BEGIN
	DECLARE @V_MENUTYPE VARCHAR(1)
	BEGIN TRY
	
		UPDATE TSY0200
	        SET MENUNAME  = @AS_MENUNAME  
	           ,PARMENUID = @AS_PARMENUID 
	           ,SORT	  = @AS_SORT	   
	           ,PROGRAMID = CASE WHEN @AS_MENUTYPE = 'M' THEN 'M' + CONVERT(VARCHAR, MENUID) ELSE @AS_PROGRAMID END
	           ,MENUTYPE  = @AS_MENUTYPE  
	           ,USEFLAG	  = @AS_USEFLAG   
	           ,REMARK	  = @AS_REMARK	   
	           ,EDITOR	  = @AS_EDITOR	   
	           ,EDITDATE  = GETDATE()  
	      WHERE MENUID    = @AS_MENUID
	        AND WORKERID  = @AS_WORKERID;       
     
	    SELECT @RS_CODE = 'S'
	END TRY
                                
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
		
		
	END CATCH  
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]사용자권한관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0101_U1'
GO
