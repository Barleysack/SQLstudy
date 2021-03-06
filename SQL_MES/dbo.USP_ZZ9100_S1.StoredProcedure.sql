USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ9100_S1]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
  언어  EXEC USP_ZZ9100_S1 'EN','작업라인 마스터','MN'  
  한글로 개발된 프로그램내의 CONTROL,MESSAGE,프로그램목록,MENU  처리용 
  DB내 언어변환용으로 사용치 말것
**/
CREATE PROCEDURE [dbo].[USP_ZZ9100_S1]
(
    @WKEY             VARCHAR(850)
    ,@OPKEY             VARCHAR(10)=''
    ,@LANG             VARCHAR(10)='KO'
    ,@RS_CODE          VARCHAR(1)='S'    OUTPUT
    ,@RS_MSG           VARCHAR(200)='' OUTPUT 
)
AS
BEGIN
    BEGIN TRY
    SET @RS_CODE = 'S'
    IF (@LANG='KO' OR @WKEY='')
    BEGIN
     SELECT @WKEY
     RETURN
    END 
    DECLARE @TR VARCHAR(1000)
	SELECT @TR=TRANSLATE 
	  FROM TZZ9100 (NOLOCK)
	 WHERE LANG = @LANG
	   AND WKEY =@WKEY
	   AND OPKEY = @OPKEY 
	   
	IF @@ROWCOUNT = 0 
	BEGIN
	  
		INSERT INTO TZZ9100  
		( LANG,WKEY,OPKEY,TRANSLATE)
		SELECT MINORCODE,@WKEY,@OPKEY,@WKEY
		   FROM TBM0000 WITH(NOLOCK)
		  WHERE MAJORCODE =  'LANG'
			AND MINORCODE <> '$'
			AND MINORCODE <> 'KO' 
			AND USEFLAG = 'Y' 
		 	AND MINORCODE NOT IN  (SELECT LANG   FROM  TZZ9100 WHERE  WKEY =@WKEY AND OPKEY = @OPKEY)
			
	     SELECT @WKEY

	END
	ELSE
	BEGIN
	 SELECT ISNULL(@TR,@WKEY)
    END 
    
    END TRY
	BEGIN CATCH                                                              
         SET  @RS_MSG = ERROR_MESSAGE()                               
         SET  @RS_CODE = 'E'  
         SELECT ''                                        
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]다국어' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZZ9100_S1'
GO
