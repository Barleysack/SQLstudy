USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ9001_S1]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
  즐겨찾기  
**/
CREATE PROCEDURE [dbo].[USP_ZZ9001_S1]
(
     @USERID        VARCHAR(20)
    ,@LANG             VARCHAR(10)
    ,@RS_CODE          VARCHAR(1)='S'    OUTPUT
    ,@RS_MSG           VARCHAR(200)='' OUTPUT 
)
AS
BEGIN
    BEGIN TRY
         SELECT  DBO.FN_TRANSLATE(@LANG,( SELECT  MENUNAME  FROM TSY0200 MENU WHERE MENU.MENUID=TZZ9001.MENUID  AND  MENU.WORKERID  = @USERID AND MENU.USEFLAG   = 'Y' ),'MN') AS NAME
          , TAG
          FROM TZZ9001   WITH(NOLOCK) 
         WHERE USERID = @USERID 
         ORDER BY  MENUNAME      

    SELECT @RS_CODE = 'S'
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
        -- PRINT   @RS_MSG    
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]즐겨찾기' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZZ9001_S1'
GO
