USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_BookMark]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
  즐겨찾기  
**/
CREATE PROCEDURE [dbo].[SPROC_BookMark]
(
     @USERID        VARCHAR(20)
    ,@LANG          VARCHAR(10)
    ,@RS_CODE       VARCHAR(1)='S'    OUTPUT
    ,@RS_MSG        VARCHAR(200)='' OUTPUT 
)
AS
BEGIN
    BEGIN TRY
         SELECT  DBO.FN_TRANSLATE(@LANG,( SELECT  MENUNAME  FROM SysMenuList MENU WHERE MENU.MENUID=TB_MenuTag.MENUID  AND  MENU.WORKERID  = @USERID AND MENU.USEFLAG   = 'Y' ),'MN') AS NAME
          , TAG
          FROM TB_MenuTag   WITH(NOLOCK) 
         WHERE USERID = @USERID 
         ORDER BY  MENUNAME      

    SELECT @RS_CODE = 'S'
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_CODE = 'E'                                           
	END CATCH
END

         SELECT  @RS_MSG = ERROR_MESSAGE()                               
GO
