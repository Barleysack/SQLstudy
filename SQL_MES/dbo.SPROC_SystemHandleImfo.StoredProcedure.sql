USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_SystemHandleImfo]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_SystemHandleImfo]
(
	  @PROGRAMID	VARCHAR(10)
	, @WORKERID	    VARCHAR(20)
	, @WORKTYPE	    VARCHAR(20)
	, @IP			VARCHAR(20)
	, @COMNAME		VARCHAR(30)
    , @LANG         VARCHAR(10)='KO'
	, @RS_CODE		VARCHAR(10)      OUTPUT
	, @RS_MSG	    VARCHAR(100)     OUTPUT
)
AS
	SELECT @PROGRAMID 	= LTRIM(RTRIM(ISNULL(@PROGRAMID, '')))
		 , @WORKERID 	= LTRIM(RTRIM(ISNULL(@WORKERID,  '')))
		 , @WORKTYPE 	= LTRIM(RTRIM(ISNULL(@WORKTYPE,  '')))
		 , @IP 		    = LTRIM(RTRIM(ISNULL(@IP, 		  '')))
		 , @COMNAME 	= LTRIM(RTRIM(ISNULL(@COMNAME,   '')))
/**********************************************************************************************
작업자 UI 사용내역 등록
**********************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @DNOWDATE DATETIME
		DECLARE @VRECDATE VARCHAR(10)
		DECLARE @V_SEQ BIGINT
		
		SELECT @DNOWDATE = GETDATE()
		
		SELECT @VRECDATE = DBO.FN_RECDATE(@DNOWDATE)

		INSERT INTO sysActiveImfo ( PROGID, WORKDATE, WORKERID, SEQ, WORKTYPE, WORKTIME, CONNECTIP )
				SELECT @PROGRAMID, @VRECDATE, @WORKERID
					, ISNULL( (SELECT MAX(SEQ) + 1 
								FROM sysActiveImfo 
								WHERE PROGID = @PROGRAMID
								  AND WORKDATE = @VRECDATE
								  AND WORKERID = @WORKERID), 1)
					, @WORKTYPE, @DNOWDATE, @IP
		
		BEGIN TRY
			IF LEFT(@PROGRAMID, 2) <> 'SY'
			IF @WORKTYPE = 'LOGIN'
			BEGIN
				INSERT INTO SysActiveLog(WORKERID, WORKERNAME, SDATE, STIME, SSTAMP, EDATE, ETIME, ESTAMP, STATE, 
       								PROGID, RUNTIME, RUNSTR, IPADDRESS, COMNAME, REMARK)
       						 VALUES(@WORKERID, DBO.FN_WORKERNAME(@WORKERID), CONVERT(VARCHAR, @DNOWDATE, 23), CONVERT(VARCHAR, @DNOWDATE, 24), @DNOWDATE, NULL, NULL, NULL, @WORKTYPE,
       						 		@PROGRAMID, 0, '0', @IP, @COMNAME, NULL)
			END
			ELSE IF @WORKTYPE = 'LOGOUT'
			BEGIN
				SELECT TOP 1 @V_SEQ = SEQNO
				  FROM SysActiveLog
				 WHERE WORKERID = @WORKERID
				   AND PROGID   = @PROGRAMID
				   AND STATE    = 'LOGIN'
				   AND EDATE IS NULL
				 ORDER BY SEQNO DESC
				 
				IF ISNULL(@V_SEQ, '') <> ''
				BEGIN
					UPDATE SysActiveLog
					   SET EDATE = CONVERT(VARCHAR, @DNOWDATE, 23)
					      ,ETIME = CONVERT(VARCHAR, @DNOWDATE, 24)
					      ,ESTAMP = @DNOWDATE
					      ,RUNTIME = DATEDIFF(S, SSTAMP, @DNOWDATE)
					      ,RUNSTR = DBO.FN_GETHHMISS(DATEDIFF(S, SSTAMP, @DNOWDATE))
					 WHERE SEQNO = @V_SEQ
				END
			END
			ELSE IF @WORKTYPE = 'OPEN'
			BEGIN
				INSERT INTO SysActiveLog(WORKERID, WORKERNAME, SDATE, STIME, SSTAMP, EDATE, ETIME, ESTAMP, STATE, 
       								PROGID, RUNTIME, RUNSTR, IPADDRESS, COMNAME, REMARK)
       						 VALUES(@WORKERID, DBO.FN_WORKERNAME(@WORKERID), CONVERT(VARCHAR, @DNOWDATE, 23), CONVERT(VARCHAR, @DNOWDATE, 24), @DNOWDATE, NULL, NULL, NULL, @WORKTYPE,
       						 		@PROGRAMID, 0, '0', @IP, @COMNAME, NULL)
			END
			ELSE IF @WORKTYPE = 'CLOSE'
			BEGIN
				SELECT TOP 1 @V_SEQ = SEQNO
				  FROM SysActiveLog
				 WHERE WORKERID = @WORKERID
				   AND PROGID   = @PROGRAMID
				   AND STATE    = 'OPEN'
				   AND EDATE IS NULL
				 ORDER BY SEQNO DESC
				 
				IF ISNULL(@V_SEQ, '') <> ''
				BEGIN
					UPDATE SysActiveLog
					   SET EDATE = CONVERT(VARCHAR, @DNOWDATE, 23)
					      ,ETIME = CONVERT(VARCHAR, @DNOWDATE, 24)
					      ,ESTAMP = @DNOWDATE
					      ,RUNTIME = DATEDIFF(S, SSTAMP, @DNOWDATE)
					      ,RUNSTR = DBO.FN_GETHHMISS(DATEDIFF(S, SSTAMP, @DNOWDATE))
					 WHERE SEQNO = @V_SEQ
				END
			END
			ELSE
			BEGIN
				INSERT INTO SysActiveLog(WORKERID, WORKERNAME, SDATE, STIME, SSTAMP, EDATE, ETIME, ESTAMP, STATE, 
       								PROGID, RUNTIME, RUNSTR, IPADDRESS, COMNAME, REMARK)
       						 VALUES(@WORKERID, DBO.FN_WORKERNAME(@WORKERID), CONVERT(VARCHAR, @DNOWDATE, 23), CONVERT(VARCHAR, @DNOWDATE, 24), @DNOWDATE, CONVERT(VARCHAR, @DNOWDATE, 23), CONVERT(VARCHAR, @DNOWDATE, 24), @DNOWDATE, @WORKTYPE,
       						 		@PROGRAMID, 0, '0', @IP, @COMNAME, NULL)
			END
		END TRY
		
		BEGIN CATCH
			
			SELECT @RS_CODE = 'E'
			SELECT @RS_MSG = ERROR_MESSAGE()
		END CATCH
	END TRY
	BEGIN CATCH
		INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER() AS ERRORNUMBER
				 , ERROR_LINE() AS ERRORLINE
				 , ERROR_MESSAGE() AS ERRORMESSAGE
				 , GETDATE()
		
		SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
	END CATCH
END

GO
