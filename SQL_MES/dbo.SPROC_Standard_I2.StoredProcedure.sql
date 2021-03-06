USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_Standard_I2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_Standard_I2]
(
     @MAJORCODE      VARCHAR(30)
    ,@MINORCODE      VARCHAR(30)
    ,@CODENAME       VARCHAR(100)
    ,@DISPLAYNO      INT
    ,@RELCODE1       VARCHAR(100)
    ,@RELCODE2       VARCHAR(100)
    ,@RELCODE3       VARCHAR(100)
    ,@RELCODE4       VARCHAR(100)
    ,@RELCODE5       VARCHAR(100)
    ,@USEFLAG		 VARCHAR(5)    
    ,@MAKER          VARCHAR(20)       
    ,@UIDNAME        VARCHAR(200)
    ,@SYSFLAG        BIT   
    ,@SYSTEMID       VARCHAR(10) 
    ,@LANG           VARCHAR(10)   ='KO'
	,@RS_CODE        VARCHAR(1)    OUTPUT                            
    ,@RS_MSG         VARCHAR(200)  OUTPUT    

    
)
AS
	SELECT @MAJORCODE = LTRIM(RTRIM(ISNULL(@MAJORCODE, '')))
	     , @MINORCODE = LTRIM(RTRIM(ISNULL(@MINORCODE, '')))
	     , @CODENAME  = LTRIM(RTRIM(ISNULL(@CODENAME, '')))
		 , @SYSFLAG   = LTRIM(RTRIM(ISNULL(@SYSFLAG, 0)))
		 , @MAKER     = LTRIM(RTRIM(ISNULL(@MAKER, '')))
/**********************************************************************************************
기준코드 상세 등록
**********************************************************************************************/		 
BEGIN
    DECLARE @UID VARCHAR(20)
    BEGIN TRY
       	DECLARE @DNOWTIME DATETIME
	    SELECT @DNOWTIME = GETDATE()
	    IF ISNULL(@DISPLAYNO, '') = '' 
		BEGIN
			SELECT @DISPLAYNO = MAX(DISPLAYNO) + 1
			  FROM TB_Standard WITH(NOLOCK)
			 WHERE MAJORCODE = @MAJORCODE
			 
			IF ISNULL(@DISPLAYNO, '') = ''
				SET @DISPLAYNO = 1
		END
    
       INSERT INTO TB_Standard
                  (MAJORCODE, MINORCODE, CODENAME,    
                   RELCODE1,  RELCODE2,  RELCODE3, RELCODE4, RELCODE5, 
                   DISPLAYNO, SYSFLAG,   USEFLAG, UIDSYS,     
                   MAKER,     MAKEDATE)               
            VALUES(@MAJORCODE, @MINORCODE, @CODENAME , 
                   @RELCODE1,  @RELCODE2,  @RELCODE3, @RELCODE4, @RELCODE5, 
                   @DISPLAYNO, @SYSFLAG,   'Y', @UID, 
                   @MAKER,     @DNOWTIME)
   
   
   SELECT @RS_CODE = 'S'                                                
END TRY                                                                                                                                           
BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
END CATCH
END
GO
