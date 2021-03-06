USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[PORC_ZZ0300_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PORC_ZZ0300_U1]
(
	 @PWORKERID VARCHAR(10)
	,@PPWD      VARCHAR(100)
	,@PCHGPWD   VARCHAR(100)
    ,@LANG             VARCHAR(10)
    ,@RS_CODE          VARCHAR(1)='S'    OUTPUT
    ,@RS_MSG           VARCHAR(200)=''  OUTPUT 

)
AS
	SELECT @PWORKERID = LTRIM(RTRIM(ISNULL(@PWORKERID, '')))
		 , @PPWD      = LTRIM(RTRIM(ISNULL(@PPWD, '')))
		 , @PCHGPWD   = LTRIM(RTRIM(ISNULL(@PCHGPWD, '')))
/**********************************************************************************************
1. 기능 : 사용자 비밀번호 변경
2. 연관 테이블 : SysManList
**********************************************************************************************/
BEGIN
	BEGIN TRY
		IF ( @PPWD = @PCHGPWD )
		BEGIN
			SET @RS_MSG = '변경 비밀번호가 일치 합니다.' 
			RETURN
		END		-- 사용자가 없을 때
		IF NOT EXISTS ( SELECT 1 FROM SysManList
								WHERE WORKERID = @PWORKERID )
		BEGIN
			SET @RS_MSG = '시스템 사용자가 등록되지 않았습니다.' 
			RETURN
		END
		
		-- 비밀번호가 일치하지 않을 때
		IF NOT EXISTS ( SELECT 1 FROM SysManList
								WHERE WORKERID = @PWORKERID 
								  AND PWD      = @PPWD )
		BEGIN
			SET @RS_MSG = '비밀번호가 일치하지 않습니다.' 
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
