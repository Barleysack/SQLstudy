USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_LangSeeting]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_LangSeeting]
(
   @LANG			VARCHAR(10)
  ,@RS_CODE         VARCHAR(1) OUTPUT
  ,@RS_MSG          VARCHAR(200) OUTPUT 
)                                  
AS                                 
BEGIN TRY 
     SELECT MINORCODE
           ,CODENAME
       FROM TB_Standard WITH(NOLOCK)
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
