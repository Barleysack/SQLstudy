USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ9001_I1]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
  즐겨찾기 저장
**/
CREATE PROCEDURE [dbo].[USP_ZZ9001_I1]
(
     @USERID        VARCHAR(20)
    ,@MENUID        INT
    ,@MENUNAME       VARCHAR(50)
    ,@TAG             VARCHAR(200)
    ,@LANG             VARCHAR(10)
    ,@RS_CODE          VARCHAR(1)='S'    OUTPUT
    ,@RS_MSG           VARCHAR(200)=''  OUTPUT 
)
AS
BEGIN
    BEGIN TRY
   
      IF (
        SELECT COUNT(*)
          FROM TZZ9001  WITH(NOLOCK) 
         WHERE USERID = @USERID 
           AND MENUID = @MENUID ) = 0
     BEGIN
       INSERT INTO TZZ9001 (USERID,MENUID,MENUNAME,TAG)
       VALUES (@USERID,@MENUID,@MENUNAME,@TAG)
        SELECT @RS_CODE = 'S'
     END
     ELSE
     BEGIN
	  SELECT @RS_CODE = 'E'
	  SELECT  @RS_MSG =  'ALREADY EXISTS.' 
     END 
      
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
        -- PRINT   @RS_MSG    
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]즐겨찾기' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZZ9001_I1'
GO
