USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ0300_U1]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_ZZ0300_U1]
(
	 @PWORKERID VARCHAR(10)
	,@PPWD      VARCHAR(20)
	,@PCHGPWD   VARCHAR(20)
    ,@LANG             VARCHAR(10)
    ,@RS_CODE          VARCHAR(1)='S'    OUTPUT
    ,@RS_MSG           VARCHAR(200)=''  OUTPUT 

)
AS
	SELECT @PWORKERID = LTRIM(RTRIM(ISNULL(@PWORKERID, '')))
		, @PPWD = LTRIM(RTRIM(ISNULL(@PPWD, '')))
		, @PCHGPWD = LTRIM(RTRIM(ISNULL(@PCHGPWD, '')))
/**********************************************************************************************
1. 기능 : 사용자 비밀번호 변경
2. 연관 테이블 : SysManList
**********************************************************************************************/
BEGIN
	BEGIN TRY
		IF ( @PPWD = @PCHGPWD )
		BEGIN
			EXEC USP_ZGETMESSAGEDESC_S 'R00117'
			RETURN
		END		-- 사용자가 없을 때
		IF NOT EXISTS ( SELECT 1 FROM TSY0300
								WHERE WORKERID = @PWORKERID )
		BEGIN
			EXEC USP_ZGETMESSAGEDESC_S 'R00115'
			RETURN
		END
		
		-- 비밀번호가 일치하지 않을 때
		IF NOT EXISTS ( SELECT 1 FROM TSY0300
								WHERE WORKERID = @PWORKERID 
								  AND  @PPWD=PWD )
		BEGIN
			EXEC USP_ZGETMESSAGEDESC_S 'R00116'
			RETURN
		END
			
		UPDATE SysManList SET
			PWD = @PCHGPWD
		 WHERE WORKERID  = @PWORKERID

        SELECT @RS_CODE = 'S'

	END TRY
	BEGIN CATCH

		INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER()    AS ERRORNUMBER
				 , ERROR_LINE()      AS ERRORLINE
				 , ERROR_MESSAGE()   AS ERRORMESSAGE
				 , GETDATE()                                           
        SELECT  @RS_MSG = ERROR_MESSAGE()                               
        SELECT  @RS_CODE = 'E' 
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[로그인창]비밀번호 변경' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZZ0300_U1'
GO
