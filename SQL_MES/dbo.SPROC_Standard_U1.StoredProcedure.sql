USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_Standard_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_Standard_U1]
(
     @MAJORCODE        VARCHAR(30)
    ,@CODENAME         VARCHAR(100)
    ,@SYSFLAG          BIT
    ,@USEFLAG          VARCHAR(1)
    ,@MINORLEN         SMALLINT
    ,@EDITOR           VARCHAR(20)
    ,@UID              VARCHAR(50)
    ,@UIDNAME          VARCHAR(200)
    ,@SYSTEMID         VARCHAR(20)
    ,@LANG			   VARCHAR(10)='KO'
	,@RS_CODE          VARCHAR(1)    OUTPUT
    ,@RS_MSG           VARCHAR(200)  OUTPUT
)
AS
	SELECT @MAJORCODE = LTRIM(RTRIM(ISNULL(@MAJORCODE, '')))
		, @CODENAME   = LTRIM(RTRIM(ISNULL(@CODENAME, '')))
		, @SYSFLAG    = LTRIM(RTRIM(ISNULL(@SYSFLAG, 0)))
		, @USEFLAG    = LTRIM(RTRIM(ISNULL(@USEFLAG, '')))
		, @MINORLEN   = LTRIM(RTRIM(ISNULL(@MINORLEN, 0)))
		, @EDITOR     = LTRIM(RTRIM(ISNULL(@EDITOR, '')))
		, @UIDNAME    = LTRIM(RTRIM(ISNULL(@UIDNAME, 0)))
		, @UID        = LTRIM(RTRIM(ISNULL(@UID, '')))
/**********************************************************************************************
기준정보 업데이트
**********************************************************************************************/
BEGIN
    DECLARE @ID VARCHAR(20)
    BEGIN TRY 
        UPDATE TB_Standard
           SET CODENAME  = CASE WHEN @LANG=DBO.FN_DEFAULTLANG() THEN  @CODENAME ELSE CODENAME END
              ,SYSFLAG   = @SYSFLAG	 
              ,USEFLAG   = @USEFLAG	 
              ,MINORLEN  = @MINORLEN 
              ,EDITOR    = @EDITOR   
              ,EDITDATE  = GETDATE() 
         WHERE MAJORCODE = @MAJORCODE
           AND MINORCODE = '$'

        SELECT @RS_CODE = 'S' 
                                                       
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
         PRINT   @RS_MSG                                                   
END CATCH
END
GO
