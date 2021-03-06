USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_Standard_U2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_Standard_U2]
(
     @MAJORCODE        VARCHAR(30)
    ,@MINORCODE        VARCHAR(30)
    ,@CODENAME         VARCHAR(100)
    ,@RELCODE1         VARCHAR(100)
    ,@RELCODE2         VARCHAR(100)
    ,@RELCODE3         VARCHAR(100)
    ,@RELCODE4         VARCHAR(100)
    ,@RELCODE5         VARCHAR(100)
    ,@DISPLAYNO        INT
    ,@SYSFLAG          BIT
    ,@USEFLAG          VARCHAR(1)
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
		, @EDITOR     = LTRIM(RTRIM(ISNULL(@EDITOR, '')))
		, @UIDNAME    = LTRIM(RTRIM(ISNULL(@UIDNAME, 0)))
		, @UID        = LTRIM(RTRIM(ISNULL(@UID, '')))
/**********************************************************************************************
기준정보 상세 업데이트
**********************************************************************************************/
BEGIN
    DECLARE @ID VARCHAR(20)
    BEGIN TRY 
        UPDATE TB_Standard
           SET CODENAME  = CASE WHEN @LANG=DBO.FN_DEFAULTLANG() THEN  @CODENAME ELSE CODENAME END
              ,RELCODE1  = @RELCODE1
              ,RELCODE2  = @RELCODE2
              ,RELCODE3  = @RELCODE3
              ,RELCODE4  = @RELCODE4
              ,RELCODE5  = @RELCODE5
              ,DISPLAYNO = @DISPLAYNO
              ,SYSFLAG   = @SYSFLAG	 
              ,USEFLAG   = @USEFLAG	 
              ,EDITOR    = @EDITOR   
              ,EDITDATE  = GETDATE() 
         WHERE MAJORCODE = @MAJORCODE
           AND MINORCODE = @MINORCODE

        SELECT @RS_CODE = 'S'                                                
     END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
 END CATCH
END

GO
