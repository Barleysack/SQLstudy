USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_Standard_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_Standard_S2]
(
     @MAJORCODE        VARCHAR(30)
    ,@USEFLAG          VARCHAR(1)
    ,@SYSTEMID         VARCHAR(20)
    ,@LANG			   VARCHAR(10)='KO'
	,@RS_CODE          VARCHAR(1)    OUTPUT
    ,@RS_MSG           VARCHAR(200)  OUTPUT
)
AS
	SELECT @MAJORCODE = LTRIM(RTRIM(ISNULL(@MAJORCODE, '')))
		 , @USEFLAG   = LTRIM(RTRIM(ISNULL(@USEFLAG, '')))
		 , @LANG      = LTRIM(RTRIM(ISNULL(@LANG, '')))
		 , @SYSTEMID  = LTRIM(RTRIM(ISNULL(@SYSTEMID, '')))
/**********************************************************************************************
기준정보 상세 조회
**********************************************************************************************/		 
BEGIN
    BEGIN TRY
       SELECT A.MAJORCODE
             ,A.MINORCODE 
             ,DBO.FN_TRANSLATE(@LANG,A.CODENAME,'DC00_Standard') AS CODENAME
             ,A.RELCODE1	
             ,A.RELCODE2	
             ,A.RELCODE3	
             ,A.RELCODE4	
             ,A.RELCODE5	
             ,A.DISPLAYNO
             ,A.SYSFLAG  
             ,A.USEFLAG  
             ,DBO.FN_WORKERNAME(A.MAKER) AS MAKER
             ,A.MAKEDATE 
             ,DBO.FN_WORKERNAME(A.MAKER) AS EDITOR
             ,A.EDITDATE 
             ,@SYSTEMID AS SYSTEMID
             ,A.UIDSYS
             ,'' AS UIDNAME -- B.UIDNAME
             ,@LANG AS LANG
       FROM TB_Standard A WITH(NOLOCK) 
        WHERE MAJORCODE =    @MAJORCODE
          AND MINORCODE <>   '$'
          AND USEFLAG   LIKE @USEFLAG + '%'
     ORDER BY MAJORCODE, DISPLAYNO
    SELECT @RS_CODE = 'S'                                                
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
	END CATCH
    RETURN
END
GO
