USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZGETPROGRAMINFOR_S]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ZGETPROGRAMINFOR_S]
(
	   @USERID               VARCHAR(30)
	  ,@FORMID               VARCHAR(20)
      ,@LANG                 VARCHAR(10)='KO'
      ,@RS_CODE              VARCHAR(1)      OUTPUT
      ,@RS_MSG               VARCHAR(200)='' OUTPUT 
)                                  
AS                                 
BEGIN TRY 
  SELECT PROGRAMID
        ,CASE WHEN PROGRAMNAME IS NULL THEN (SELECT MENUNAME FROM SysMenuList WITH(NOLOCK) WHERE WORKERID = @USERID AND PROGRAMID = @FORMID) ELSE PROGRAMNAME END PROGRAMNAME
        ,PROGTYPE
        ,INQFLAG
        ,NEWFLAG
        ,SAVEFLAG
        ,DELFLAG
        ,EXCELFLAG
        ,PRNFLAG 
        ,(SELECT SUMFLAG FROM sysProgramList WITH(NOLOCK) WHERE WORKERID = 'SYSTEM' AND PROGRAMID = @FORMID) AS SUMFLAG
    FROM sysProgramList WITH(NOLOCK)
   WHERE WORKERID  = @USERID
     AND PROGRAMID = @FORMID
     
		SELECT @RS_CODE = 'S'
   RETURN
END TRY                           

BEGIN CATCH

     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT @RS_CODE = 'E'                 
END CATCH

GO
