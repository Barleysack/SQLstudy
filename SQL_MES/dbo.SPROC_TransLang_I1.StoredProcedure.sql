USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_TransLang_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
  언어  EXEC USP_ZZ9100_S1 'EN','아니오','DB'
**/
CREATE PROCEDURE [dbo].[SPROC_TransLang_I1]
(
     @LANG              VARCHAR(10)
    ,@WKEY              VARCHAR(850)
    ,@OPKEY             VARCHAR(10)=''
)
AS
BEGIN
    BEGIN TRY
    IF (@LANG <> DBO.FN_DEFAULTLANG())
    BEGIN
      RETURN
    END
    
	IF (SELECT COUNT(*) 
		  FROM TB_TransLang (NOLOCK)
		 WHERE WKEY = @WKEY
		   AND OPKEY = @OPKEY ) = 0
	BEGIN
		INSERT INTO TB_TransLang
  
		( LANG,WKEY,OPKEY,TRANSLATE)
		SELECT MINORCODE,@WKEY,@OPKEY,@WKEY
		   FROM TB_Standard WITH(NOLOCK)
		  WHERE MAJORCODE =  'LANG'
			AND MINORCODE <> '$'
			AND MINORCODE <> DBO.FN_DEFAULTLANG() 
			AND USEFLAG = 'Y' 
			AND MINORCODE NOT IN  (SELECT LANG   FROM  TB_TransLang with(nolock) WHERE  WKEY = @WKEY AND OPKEY = @OPKEY)
	END
    END TRY
	BEGIN CATCH                                                              
         RETURN                          
	END CATCH
END
GO
