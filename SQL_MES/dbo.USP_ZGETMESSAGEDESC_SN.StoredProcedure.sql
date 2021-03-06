USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZGETMESSAGEDESC_SN]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ZGETMESSAGEDESC_SN]
(
	   @MESSAGEID           VARCHAR(30)
      ,@LANG				VARCHAR(10) = 'KO'
      ,@RS_CODE				VARCHAR(1)   OUTPUT
      ,@RS_MSG				VARCHAR(200)='' OUTPUT 
)
AS 
BEGIN TRY
     DECLARE @MSG VARCHAR(100)

    SELECT 
       @MSG=A.MESSAGEDESC  
      FROM TB_SystemMessage A with(nolock)
     WHERE A.MESSAGEID  = @MESSAGEID
     
    -- 개발모드  
    IF ( @MSG IS NULL)
    BEGIN
       SELECT @RS_MSG = '등록되지 않은 메세지 입니다.' 
       SELECT @RS_CODE = 'E'    
       SELECT '' 
       RETURN
    END 
    IF (@LANG='KO')
    BEGIN
     EXEC  SPROC_TransLang_I @LANG,@MSG,'MSG'
    END
    SELECT DBO.FN_TRANSLATE(@LANG,@MSG,'MSG')
   -- 개발모드 END 
	SELECT @RS_CODE = 'S'
	END TRY                           

BEGIN CATCH

     SELECT @RS_MSG = ERROR_MESSAGE()
     SELECT @RS_CODE = 'E'                 
END CATCH

GO
