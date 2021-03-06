USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZA0000_S3]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ZA0000_S3]
(
   @LANG			VARCHAR(10)
  ,@RS_CODE         VARCHAR(1) OUTPUT
  ,@RS_MSG          VARCHAR(200) OUTPUT 
)                                  
AS                                 
BEGIN TRY 
     SELECT MINORCODE
           ,CODENAME
       FROM TBM0000 WITH(NOLOCK)
      WHERE MAJORCODE =  'LANG'
        AND MINORCODE <> '$'
        AND USEFLAG ='Y'
   ORDER BY DISPLAYNO
   SELECT @RS_CODE = 'S'
END TRY                           

BEGIN CATCH

     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT @RS_CODE = 'E'                 
END CATCH
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]메인화면_언어' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZA0000_S3'
GO
