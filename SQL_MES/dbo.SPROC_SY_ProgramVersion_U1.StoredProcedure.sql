USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_SY_ProgramVersion_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_SY_ProgramVersion_U1] 
/*******************************************************************************
파일 패치 관리 시스템 리스트 수정
********************************************************************************/  
(
     @SYSTEMID					VARCHAR(20)	
    ,@REGUSERID					VARCHAR(20)
    ,@DESCRIPT					VARCHAR(20)
    ,@EDITOR					VARCHAR(20)
    ,@LANG						VARCHAR(10)='KO'
	,@RS_CODE					VARCHAR(1)    OUTPUT
    ,@RS_MSG					VARCHAR(200)  OUTPUT
) 
AS
BEGIN 
  BEGIN TRY
  
        UPDATE SysSYstemList
           SET REGUSERID = @REGUSERID
              ,DESCRIPT  = @DESCRIPT
              ,EDITOR    = @EDITOR
              ,EDITDATE  = GETDATE()
         WHERE SYSTEMID = @SYSTEMID;
      SET @RS_CODE = 'S';
      
	END TRY
	BEGIN CATCH
	 			 
		INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER() AS ERRORNUMBER
				 , ERROR_LINE() AS ERRORLINE
				 , ERROR_MESSAGE() AS ERRORMESSAGE
				 , GETDATE()
				 
		SELECT @RS_CODE = 'E', @RS_MSG = ERROR_MESSAGE()
	END CATCH
END
GO
