USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0100_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0100_S1]  
(  
     @WORKERID    VARCHAR(30)  
    ,@SYSTEMID    VARCHAR(20)
    ,@LANG        VARCHAR(5)='KO'
    ,@RS_CODE     VARCHAR(1)      OUTPUT
    ,@RS_MSG      VARCHAR(200)    OUTPUT 
)  
AS 
BEGIN
	BEGIN TRY
	     SELECT MENU.WORKERID       AS WORKERID
	           ,MENU.MENUID         AS MENUID
	           ,DBO.FN_TRANSLATE(@LANG,MENU.MENUNAME,'MN')        AS MENUNAME
	           ,MENU.PARMENUID      AS PARMENUID
	           ,MENU.SORT           AS SORT
	           ,MENU.PROGRAMID      AS PROGRAMID
	           ,MENU.MENUTYPE       AS MENUTYPE
	           ,MENU.REMARK         AS REMARK
	           ,MENU.USEFLAG        AS USEFLAG
	           ,MENU.MAKER          AS MAKER
	           ,MENU.EDITOR         AS EDITOR
	           ,DBO.FN_TRANSLATE(@LANG,PROGRAM.PROGRAMNAME,'SY0100') AS PROGRAMNAME
	           ,PROGRAM.PROGTYPE    AS PROGTYPE
	           ,PROGRAM.INQFLAG     AS INQFLAG
	           ,PROGRAM.NEWFLAG     AS NEWFLAG
	           ,PROGRAM.DELFLAG     AS DELFLAG
	           ,PROGRAM.SAVEFLAG    AS SAVEFLAG
	           ,PROGRAM.EXCELFLAG   AS EXCELFLAG
	           ,PROGRAM.PRNFLAG     AS PRNFLAG
	           ,PROGRAM.NAMESPACE   AS NAMESPACE
	           ,PROGRAM.FILEID      AS FILEID
	           ,PROGRAM.REMARK      AS PROGRAMREMARK
	           ,PROGRAM.SYSTEMID           AS SYSTEMID
	           ,@LANG               AS LANG
	            ,DBO.FN_TRANSLATE(@LANG,MENU.MENUNAME,'MN') AS UIDNAME
	       FROM TSY0200 MENU WITH(NOLOCK) LEFT OUTER JOIN TSY0100 PROGRAM WITH(NOLOCK)
	                                      ON MENU.PROGRAMID 	= PROGRAM.PROGRAMID
	                                     AND PROGRAM.WORKERID   = 'SYSTEM' 
	      WHERE MENU.WORKERID 	=  'SYSTEM'
	         AND MENU.SYSTEMID 	= @SYSTEMID
	   ORDER BY MENU.PARMENUID, MENU.SORT
	   
		SELECT @RS_CODE = 'S'
		RETURN
	END TRY
	
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]메뉴관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0100_S1'
GO
