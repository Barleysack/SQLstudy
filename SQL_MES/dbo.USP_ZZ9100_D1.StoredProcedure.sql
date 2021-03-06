USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ9100_D1]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ZZ9100_D1]
(
     @LANG             VARCHAR(10)
    ,@WKEY             VARCHAR(850) 
    ,@OPKEY             VARCHAR(10) 
    ,@RS_CODE          VARCHAR(1)='S' OUTPUT
    ,@RS_MSG           VARCHAR(200)='' OUTPUT 
)
/*
	언어 관리
*/
AS
BEGIN
    BEGIN TRY
    
	DELETE FROM  TZZ9100 
	 WHERE LANG = @LANG
	   AND WKEY = @WKEY 
	   AND OPKEY = @OPKEY
    
    SELECT @RS_CODE = 'S'
    
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]다국어' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZZ9100_D1'
GO
