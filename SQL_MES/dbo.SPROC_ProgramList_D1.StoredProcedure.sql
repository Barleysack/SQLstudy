USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_ProgramList_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_ProgramList_D1]
(
    @PROGRAMID      VARCHAR(50)
   ,@WORKERID		VARCHAR(20)
   ,@LANG      		VARCHAR(10)	=	'KO'
   ,@RS_CODE        VARCHAR(1) 		OUTPUT
   ,@RS_MSG         VARCHAR(200) 	OUTPUT 
)
AS
/**********************************************************************************************
프로그램 리스트 삭제
**********************************************************************************************/
BEGIN
	BEGIN TRY
		
		-- 1. 프로그램 관리 테이블 데이터 삭제
	    DELETE sysProgramList
	     WHERE PROGRAMID = @PROGRAMID
		   AND WORKERID  = @WORKERID
	     
	    -- 2. 메뉴 관리 테이블 데이터 삭제 
	    DELETE SysMenuList
	     WHERE PROGRAMID = @PROGRAMID
	       AND MENUTYPE  = 'P'
		   AND WORKERID  = @WORKERID
	      
	    SELECT @RS_CODE  = 'S'
	    
    END TRY                           
    BEGIN CATCH
        SELECT  @RS_MSG  = ERROR_MESSAGE()
        SELECT  @RS_CODE  = 'E'       
        
		INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER() AS ERRORNUMBER
				 , ERROR_LINE() AS ERRORLINE
				 , ERROR_MESSAGE() AS ERRORMESSAGE
				 , GETDATE()          
    END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]프로그램관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'SPROC_ProgramList_D1'
GO
