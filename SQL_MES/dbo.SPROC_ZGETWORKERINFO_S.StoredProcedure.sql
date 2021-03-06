USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_ZGETWORKERINFO_S]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SPROC_ZGETWORKERINFO_S]
(
	 @PWORKERID        VARCHAR(10)
    ,@LANG      VARCHAR(10)='KO'
    ,@RS_CODE          VARCHAR(1)    OUTPUT
    ,@RS_MSG           VARCHAR(200)  OUTPUT 
)
AS
	SELECT @PWORKERID = LTRIM(RTRIM(ISNULL(@PWORKERID, '')))
/**********************************************************************************************
1. 기능        : 사용자 정보 조회
2. 연관 테이블 : SysManList
3. 연관 폼     : ZZ0000
**********************************************************************************************/
BEGIN
	BEGIN TRY
		
		SELECT WORKERNAME, PWD AS PASSWORD, 'SYSTEM' AS GRPID
		  FROM SysManList	 
		 WHERE WORKERID  = @PWORKERID
        SELECT @RS_CODE = 'S'
		RETURN
	END TRY
	BEGIN CATCH

		INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER() AS ERRORNUMBER
				 , ERROR_LINE() AS ERRORLINE
				 , ERROR_MESSAGE() AS ERRORMESSAGE
				 , GETDATE()                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
	END CATCH
END

GO
