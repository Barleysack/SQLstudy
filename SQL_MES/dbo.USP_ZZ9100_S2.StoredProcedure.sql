USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ9100_S2]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
  언어  
**/
CREATE PROCEDURE [dbo].[USP_ZZ9100_S2]
(
    @LANG             VARCHAR(10)='KO'
    ,@RS_CODE          VARCHAR(1)='S' OUTPUT
    ,@RS_MSG           VARCHAR(200)='' OUTPUT 
)
AS
BEGIN
    BEGIN TRY
    
	SELECT * 
	  FROM TZZ9100 (NOLOCK)
	 WHERE LANG LIKE  @LANG+'%'
	  AND OPKEY IN ('','MN','MSG','FILTER')
    
    SELECT @RS_CODE = 'S'
    
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]다국어' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZZ9100_S2'
GO
