USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_ProgramList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************
1. 작성자         : DSH
2. 최초 작성 날짜 : 2020/08
3. 최종 수정 날짜 : 년 월 일 
4. 기능			  : 프로그램 수정
5. 연관 테이블	  : sysProgramList
6. 연관 폼		  : SY_ProgramList[프로그램관리]
**********************************************************************************************/
CREATE PROCEDURE [dbo].[SPROC_ProgramList_U1]
(
     @PROGRAMID   VARCHAR(50)
    ,@PROGRAMNAME VARCHAR(255)
    ,@PROGTYPE    VARCHAR(255)
    ,@INQFLAG     BIT
    ,@NEWFLAG     BIT
    ,@SAVEFLAG    BIT
    ,@DELFLAG     BIT
    ,@EXCELFLAG   BIT
    ,@PRNFLAG     BIT
    ,@FILEID      VARCHAR(255)
    ,@NAMESPACE   VARCHAR(255)
    ,@DEVELOPER   VARCHAR(255)
    ,@CONTACT     VARCHAR(255)
    ,@AUTHDATE    VARCHAR(8)
    ,@PARAM       VARCHAR(255)
    ,@USEFLAG     VARCHAR(1)
    ,@REMARK      VARCHAR(255)
    ,@EDITOR      VARCHAR(20)
    ,@SYSTEMID    VARCHAR(20)
    ,@UIDNAME     VARCHAR(200)
    ,@TOPICID     INT
    ,@LANG        VARCHAR(5)
    ,@RS_CODE     VARCHAR(1)      OUTPUT
    ,@RS_MSG      VARCHAR(200)    OUTPUT  
)

AS
	SELECT @PROGRAMID 	= LTRIM(RTRIM(ISNULL(@PROGRAMID, '')))
		 , @PROGRAMNAME = LTRIM(RTRIM(ISNULL(@PROGRAMNAME, '')))
		 , @NAMESPACE 	= LTRIM(RTRIM(ISNULL(@NAMESPACE, '')))
		 , @UIDNAME 	= LTRIM(RTRIM(ISNULL(@UIDNAME, '')))
		 , @PROGTYPE 	= LTRIM(RTRIM(ISNULL(@PROGTYPE, '')))
		 , @SYSTEMID 	= LTRIM(RTRIM(ISNULL(@SYSTEMID, '')))
BEGIN
    BEGIN TRY
    	--IF (@LANG='KO')
     -- 	BEGIN
     --   	EXEC USP_ZZ9100_I1 @LANG,@PROGRAMNAME,'SY0100'
     -- 	END
      
       	UPDATE sysProgramList
           SET PROGRAMNAME   = CASE WHEN @LANG='KO' THEN @PROGRAMNAME  ELSE PROGRAMNAME END 
              ,PROGTYPE      = @PROGTYPE 	  
              ,INQFLAG       = @INQFLAG 	  
              ,NEWFLAG       = @NEWFLAG 	  
              ,SAVEFLAG      = @SAVEFLAG	  
              ,DELFLAG       = @DELFLAG 	  
              ,EXCELFLAG     = @EXCELFLAG   
              ,PRNFLAG       = @PRNFLAG 	  
              ,FILEID        = @FILEID 	  
              ,NAMESPACE     = @NAMESPACE	  
              ,DEVELOPER     = @DEVELOPER	  
              ,CONTACT       = @CONTACT 	  
              ,AUTHDATE      = @AUTHDATE	  
              ,PARAM         = @PARAM 	  
              ,USEFLAG       = @USEFLAG 	  
              ,REMARK        = @REMARK	  
              ,EDITDATE      = GETDATE()	  
              ,EDITOR        = @EDITOR	 
              ,TOPICID		 = @TOPICID
         WHERE PROGRAMID     = @PROGRAMID   
           AND WORKERID	   	 = @EDITOR
           AND SYSTEMID      = @SYSTEMID 
              
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
