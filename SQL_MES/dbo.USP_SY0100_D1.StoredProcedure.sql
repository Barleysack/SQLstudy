USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0100_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0100_D1]
(
	   @WORKERID         VARCHAR(30)
	  ,@MENUID           VARCHAR(50)
	  ,@PROGRAMID        VARCHAR(50)
      ,@LANG        	 VARCHAR(5)
	  ,@RS_CODE          VARCHAR(1)      OUTPUT
      ,@RS_MSG           VARCHAR(200)    OUTPUT   
)
AS
/**********************************************************************************************
1. 작성자 : 
2. 최초 작성 날짜 : 
3. 최종 수정 날짜 : 년 월 일 
4. 기능 : 프로그램 삭제
5. 연관 테이블 : TSY0200
6. 연관 폼 : SY0100
--SELECT * FROM TSY0200
**********************************************************************************************/
BEGIN
    BEGIN TRY
        DELETE FROM TSY0200
	     WHERE WORKERID = @WORKERID
	       AND MENUID   = @MENUID;
	    
        SELECT @RS_CODE = 'S'
    END TRY                       
    BEGIN CATCH
        SELECT  @RS_MSG = ERROR_MESSAGE()
        SELECT @RS_CODE = 'E'   
        
		INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER() AS ERRORNUMBER
				 , ERROR_LINE() AS ERRORLINE
				 , ERROR_MESSAGE() AS ERRORMESSAGE
				 , GETDATE()              
    END CATCH  
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]메뉴관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0100_D1'
GO
