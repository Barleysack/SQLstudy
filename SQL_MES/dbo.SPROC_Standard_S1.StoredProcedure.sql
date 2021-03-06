USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_Standard_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_Standard_S1]
(
     @MAJORCODE     VARCHAR(30)
    ,@CODENAME      VARCHAR(50)
    ,@USEFLAG       VARCHAR(1)
    ,@SYSTEMID      VARCHAR(20)
    ,@LANG			VARCHAR(10)='KO'
	,@RS_CODE       VARCHAR(1)    OUTPUT
    ,@RS_MSG        VARCHAR(200)  OUTPUT
)
AS
	SELECT @MAJORCODE = LTRIM(RTRIM(ISNULL(@MAJORCODE, '')))
		  , @USEFLAG = LTRIM(RTRIM(ISNULL(@USEFLAG, '')))
/**********************************************************************************************
시스템 기준 정보 조회 1 
**********************************************************************************************/		
BEGIN
    BEGIN TRY
       SELECT A.MAJORCODE
			 ,A.MINORCODE 
             ,DBO.FN_TRANSLATE(@LANG,A.CODENAME,'DC00_Standard') AS CODENAME
             ,A.MINORLEN
             ,A.SYSFLAG
             ,A.USEFLAG
             ,DBO.FN_WORKERNAME(A.MAKER)  AS  MAKER
             ,A.MAKEDATE
             ,DBO.FN_WORKERNAME(A.EDITOR) AS EDITOR
             ,A.EDITDATE
             ,A.UIDSYS
             ,''                          AS UIDNAME 
             ,@SYSTEMID                   AS SYSTEMID
             ,@LANG                       AS LANG
         FROM TB_Standard A WITH(NOLOCK)
        WHERE A.MAJORCODE LIKE @MAJORCODE + '%'
          AND A.MINORCODE =    '$'
          AND ISNULL(DBO.FN_TRANSLATE(@LANG,A.CODENAME,'DC00_Standard'),'')  LIKE '%' + @CODENAME + '%'  
          AND A.USEFLAG   LIKE @USEFLAG  + '%'
     ORDER BY A.MAJORCODE
     
    SELECT @RS_CODE = 'S'                                                
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
 	END CATCH 
END
GO
