USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ9100_I2]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
  언어  EXEC USP_ZZ9100_S1 'EN','아니오','DB'
**/
CREATE PROCEDURE [dbo].[USP_ZZ9100_I2]
(
    @LANG             VARCHAR(10)
    ,@WKEY             VARCHAR(850)
    ,@OPKEY             VARCHAR(10)=''
    ,@TRANSLATE			NVARCHAR(100)
)
AS
BEGIN
    BEGIN TRY    
		IF NOT EXISTS (SELECT 1 
			  FROM TZZ9100 (NOLOCK)
			 WHERE WKEY = @WKEY
			   AND OPKEY = @OPKEY
			   AND LANG  = @LANG )
		BEGIN
			INSERT INTO TZZ9100(LANG,WKEY,OPKEY,TRANSLATE)
						 VALUES(@LANG,@WKEY,@OPKEY,@TRANSLATE)
		END
    END TRY
	BEGIN CATCH                                                              
         RETURN                          
	END CATCH
END
GO
