USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZA0000_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ZA0000_S1]
(
   @WORKERID         VARCHAR(30)
  ,@SYSTEMID		 VARCHAR(50)
  ,@LANG             VARCHAR(10)
  ,@RS_CODE          VARCHAR(1) OUTPUT
  ,@RS_MSG           VARCHAR(200) OUTPUT 
)
AS
BEGIN
  SELECT MENU.MENUID
        ,DBO.FN_TRANSLATE(@LANG, MENU.MENUNAME ,'MN') AS MENUNAME
        ,MENU.PARMENUID
        ,MENU.SORT
        ,MENU.PROGRAMID
	    ,MENU.MENUTYPE
	    ,PROGRAM.NAMESPACE	  
        ,PROGRAM.FILEID
    FROM TSY0200 MENU LEFT OUTER JOIN TSY0100 PROGRAM
                                   ON MENU.PROGRAMID = PROGRAM.PROGRAMID        
                                  AND MENU.WORKERID = PROGRAM.WORKERID
   WHERE MENU.WORKERID = @WORKERID
     AND MENU.USEFLAG  = 'Y'
     AND MENU.SYSTEMID = @SYSTEMID
   ORDER BY MENU.SORT
	RETURN
END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]메인화면메뉴_트리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZA0000_S1'
GO
