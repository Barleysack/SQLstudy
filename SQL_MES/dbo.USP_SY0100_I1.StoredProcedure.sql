USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0100_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0100_I1]
(
	   @WORKERID         VARCHAR(50)
	  ,@MENUID           VARCHAR(50)
	  ,@MENUNAME         VARCHAR(255)  
	  ,@PARMENUID        VARCHAR(50)
	  ,@SORT             INT
	  ,@PROGRAMID        VARCHAR(50)
	  ,@MENUTYPE         VARCHAR(5)
	  ,@USEFLAG          VARCHAR(1)
	  ,@REMARK           VARCHAR(500)
	  ,@MAKER            VARCHAR(10)
	  ,@EDITOR           VARCHAR(10)
	  ,@PROGRAMNAME      VARCHAR(255)
	  ,@PROGTYPE         VARCHAR(255)
	  ,@FILEID           VARCHAR(255)
	  ,@NAMESPACE        VARCHAR(255)
	  ,@SYSTEMID         VARCHAR(20)
      ,@UIDNAME          VARCHAR(200)
      ,@LANG        	 VARCHAR(5)
      ,@RS_CODE          VARCHAR(1)      OUTPUT
      ,@RS_MSG           VARCHAR(200)    OUTPUT  
)
AS
/**********************************************************************************************
1. 작성자 : 
2. 최초 작성 날짜 : 
3. 최종 수정 날짜 : 년 월 일 
4. 기능 : 메뉴 추가(SYSTEM)
5. 연관 테이블 : TSY0200
6. 연관 폼 : SY0100
--SELECT * FROM TSY0200
**********************************************************************************************/
BEGIN
	DECLARE @V_STAMP DATETIME
	SELECT  @V_STAMP = GETDATE()
	
    BEGIN TRY
    
    	IF (@LANG='KO')
      	BEGIN
        	EXEC USP_ZZ9100_I1 @LANG,@MENUNAME,'MN'
      	END
      
        SELECT @MENUID = ISNULL(MAX(MENUID), 0) + 1
	      FROM TSY0200
	     WHERE WORKERID = @WORKERID;

        IF(@MENUTYPE = 'M')
        BEGIN
            DECLARE @UIDSYS VARCHAR(20)
            SELECT @UIDSYS = 'M' + @MENUID
         
            INSERT INTO TSY0200(MENUID,  WORKERID,  MENUNAME,  PARMENUID,  SORT,  PROGRAMID,  MENUTYPE,  USEFLAG,  REMARK,  MAKER,  MAKEDATE, SYSTEMID)  
                 	     VALUES(@MENUID, 'SYSTEM', @MENUNAME,  @PARMENUID, @SORT, @UIDSYS,   @MENUTYPE, @USEFLAG, @REMARK, @MAKER, @V_STAMP, @SYSTEMID);
        END
        ELSE
        BEGIN
            
            INSERT INTO TSY0200(MENUID,  WORKERID,  MENUNAME,  PARMENUID,  SORT,  PROGRAMID,  MENUTYPE,  USEFLAG,  REMARK,  MAKER,   MAKEDATE, SYSTEMID)  
                         VALUES(@MENUID, 'SYSTEM', @MENUNAME,  @PARMENUID, @SORT, @PROGRAMID, @MENUTYPE, @USEFLAG, @REMARK, @MAKER, @V_STAMP, @SYSTEMID)
            
        END
        
        SELECT @RS_CODE = 'S'
   	END TRY	
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
		
		INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER() AS ERRORNUMBER
				 , ERROR_LINE() AS ERRORLINE
				 , ERROR_MESSAGE() AS ERRORMESSAGE
				 , GETDATE()       
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]메뉴관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0100_I1'
GO
