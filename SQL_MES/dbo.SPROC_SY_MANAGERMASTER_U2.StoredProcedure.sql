USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_SY_MANAGERMASTER_U2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 시스템 사용자 매뉴 갱신 및 신규 등록
-- 2020.08.09 DSH
CREATE PROCEDURE [dbo].[SPROC_SY_MANAGERMASTER_U2]
(
	   @WORKERID        VARCHAR(30)
      ,@LANG         	VARCHAR(10) ='KO' 
 	  ,@RS_CODE         VARCHAR(1)='S' OUTPUT
      ,@RS_MSG          VARCHAR(200) OUTPUT 
)
AS
SET NOCOUNT ON;                                              
BEGIN               
	BEGIN TRY   
	-- 프로스램 권한 등 리스트 갱신 및 등록
	BEGIN
		DECLARE  @PROGRAMID    VARCHAR(50) ,
				 @PROGRAMNAME  NVARCHAR(255),
				 @PROGTYPE     NVARCHAR(255) ,
				 @INQFLAG      VARCHAR(1) ,
				 @NEWFLAG      VARCHAR(1) ,
				 @SAVEFLAG     VARCHAR(1) ,
				 @DELFLAG      VARCHAR(1) ,
				 @EXCELFLAG    VARCHAR(1) ,
				 @PRNFLAG      VARCHAR(1) ,
				 @FILEID       VARCHAR(255) ,
				 @NAMESPACE    VARCHAR(255) ,
				 @DEVELOPER    NVARCHAR(255) ,
				 @CONTACT      NVARCHAR(255) ,
				 @AUTHDATE     VARCHAR(8) ,
				 @PARAM        VARCHAR(255) ,
				 @USEFLAG      VARCHAR(1) ,
				 @REMARK       NVARCHAR(255) ,
				 @SUMFLAG      VARCHAR(1) ,
				 @SYSTEMID     VARCHAR(30) ,
				 @TOPICID      VARCHAR(1) 

		DECLARE UPDATE_PROGRAMLIST CURSOR READ_ONLY FAST_FORWARD FOR
			SELECT PROGRAMID   ,PROGRAMNAME ,PROGTYPE    ,INQFLAG     
				   ,NEWFLAG     ,SAVEFLAG    ,DELFLAG     ,EXCELFLAG   ,PRNFLAG     
				   ,FILEID      ,NAMESPACE   ,DEVELOPER   ,CONTACT     ,AUTHDATE    
				   ,PARAM       ,USEFLAG     ,REMARK      
				   ,SUMFLAG     ,SYSTEMID    ,TOPICID   
	          FROM sysProgramList A WITH(NOLOCK) 
			 WHERE WORKERID = 'SYSTEM'
			   AND PROGRAMID NOT IN ('SY0101'					-- 사용자별 권한 관리
									,'SY_PROGRAMVERSION'		-- 프로그램 버젼 관리
									,'SY_MANAGERMASTER'			-- 시스템 사용자관리
									,'SY0300'					-- 사용자 접속이력 관리
									,'SY0800'					-- 그룹별 권한 관리
									,'SY0320'					-- 외주 시스템 사용자 관리

									-- 학생들이 등록해야 할 화면들
									,'AP_ProductPlan'			-- 생산 계획 및 확정
									,'MM_StockMM'				-- 자재 재고 관리
									,'PP_ProdPerErrorChart'     -- 작업장 기간별 생산 실적
									)
	      OPEN UPDATE_PROGRAMLIST
	      FETCH NEXT FROM UPDATE_PROGRAMLIST INTO   @PROGRAMID  ,@PROGRAMNAME ,@PROGTYPE   ,@INQFLAG    
												   ,@NEWFLAG    ,@SAVEFLAG    ,@DELFLAG    ,@EXCELFLAG  ,@PRNFLAG    
												   ,@FILEID     ,@NAMESPACE   ,@DEVELOPER  ,@CONTACT    ,@AUTHDATE   
												   ,@PARAM      ,@USEFLAG     ,@REMARK     
												   ,@SUMFLAG    ,@SYSTEMID    ,@TOPICID    



	      WHILE (@@FETCH_STATUS = 0)
	      BEGIN
				IF (SELECT COUNT(*) 
				      FROM sysProgramList
					 WHERE WORKERID  = @WORKERID
					   AND PROGRAMID = @PROGRAMID) = 0
				BEGIN
					INSERT INTO sysProgramList  (PROGRAMID   ,PROGRAMNAME ,PROGTYPE    ,INQFLAG     ,WORKERID
												,NEWFLAG     ,SAVEFLAG    ,DELFLAG     ,EXCELFLAG   ,PRNFLAG     
												,FILEID      ,NAMESPACE   ,DEVELOPER   ,CONTACT     ,AUTHDATE    
												,PARAM       ,USEFLAG     ,REMARK      
												,SUMFLAG     ,SYSTEMID    ,TOPICID     ,MAKER       ,MAKEDATE)
								        VALUES ( @PROGRAMID  ,@PROGRAMNAME ,@PROGTYPE   ,@INQFLAG   ,@WORKERID
									    		,@NEWFLAG    ,@SAVEFLAG    ,@DELFLAG    ,@EXCELFLAG ,@PRNFLAG    
									    		,@FILEID     ,@NAMESPACE   ,@DEVELOPER  ,@CONTACT   ,@AUTHDATE   
									    		,@PARAM      ,@USEFLAG     ,@REMARK     
									    		,@SUMFLAG    ,@SYSTEMID    ,@TOPICID   ,'SYSTEM'    ,GETDATE())
				END
				FETCH NEXT FROM UPDATE_PROGRAMLIST INTO @PROGRAMID  ,@PROGRAMNAME ,@PROGTYPE   ,@INQFLAG    
													   ,@NEWFLAG    ,@SAVEFLAG    ,@DELFLAG    ,@EXCELFLAG  ,@PRNFLAG    
													   ,@FILEID     ,@NAMESPACE   ,@DEVELOPER  ,@CONTACT    ,@AUTHDATE   
													   ,@PARAM      ,@USEFLAG     ,@REMARK     
													   ,@SUMFLAG    ,@SYSTEMID    ,@TOPICID 
	      END
	CLOSE UPDATE_PROGRAMLIST
	DEALLOCATE UPDATE_PROGRAMLIST
	END

	-- 매뉴 리스트 갱신 및 등록
	BEGIN
		DECLARE  @MENUID      INT
				,@MENUNAME   VARCHAR(255)
				,@PARMENUID  INT 
				,@SORT       INT 
				--,@PROGRAMID  VARCHAR(50)
				,@MENUTYPE   VARCHAR (5)
				--,@USEFLAG    VARCHAR(1)
				--,@REMARK     NVARCHAR(500)
				--,@SYSTEMID   VARCHAR(30)
				,@URL        VARCHAR(255)

		DECLARE UPDATE_MENULIST CURSOR READ_ONLY FAST_FORWARD FOR
			SELECT MENUID,    MENUNAME, PARMENUID, SORT, PROGRAMID
				  ,MENUTYPE,  USEFLAG,  REMARK,    SYSTEMID 
	          FROM SYSMENULIST A WITH(NOLOCK) 
			 WHERE WORKERID = 'SYSTEM'
			   AND PROGRAMID NOT IN ('SY0101'					-- 사용자별 권한 관리
									,'SY_PROGRAMVERSION'		-- 프로그램 버젼 관리
									,'SY_MANAGERMASTER'			-- 시스템 사용자관리
									,'SY0300'					-- 사용자 접속이력 관리
									,'SY0800'					-- 그룹별 권한 관리
									,'SY0320'					-- 외주 시스템 사용자 관리

									-- 학생들이 등록해야 할 화면들
									,'AP_ProductPlan'			-- 생산 계획 및 확정
									,'MM_StockMM'				-- 자재 재고 관리
									,'PP_ProdPerErrorChart'     -- 작업장 기간별 생산 실적
									)
	      OPEN UPDATE_MENULIST
	      FETCH NEXT FROM UPDATE_MENULIST INTO @MENUID,    @MENUNAME, @PARMENUID, @SORT,    @PROGRAMID
											   ,@MENUTYPE,  @USEFLAG,  @REMARK,    @SYSTEMID 
	      WHILE (@@FETCH_STATUS = 0)
	      BEGIN
				IF (SELECT COUNT(*) 
				      FROM SYSMENULIST WITH (NOLOCK)
					 WHERE WORKERID  = @WORKERID
					   AND PROGRAMID = @PROGRAMID) = 0
				BEGIN
					IF (SELECT COUNT(*) 
				      FROM SYSMENULIST WITH (NOLOCK)
					 WHERE WORKERID  = @WORKERID
					   AND MENUID    = @MENUID) <> 0
					BEGIN
						DECLARE @LS_MENUID VARCHAR(10)
						SET @LS_MENUID = CONVERT(VARCHAR,CONVERT(INT,SUBSTRING(CONVERT(VARCHAR,@MENUID),1,1)+1)) + '00'

						SELECT @MENUID = MAX(MENUID) + 1
						  FROM SYSMENULIST WITH (NOLOCK)
						 WHERE WORKERID  = @WORKERID
					       AND MENUID    < CONVERT(INT,@LS_MENUID)
					END
					     
						
						 
					INSERT INTO SYSMENULIST ( MENUID    
											 ,WORKERID  
											 ,MENUNAME  
											 ,PARMENUID 
											 ,SORT      
											 ,PROGRAMID 
											 ,MENUTYPE  
											 ,USEFLAG   
											 ,REMARK    
											 ,SYSTEMID  
											 ,MAKER
											 ,MAKEDATE
											 ,URL)
								    VALUES ( @MENUID    
								    		,@WORKERID  
								    		,@MENUNAME  
								    		,@PARMENUID 
								    		,@SORT      
								    		,@PROGRAMID 
								    		,@MENUTYPE  
								    		,@USEFLAG   
								    		,@REMARK    
								    		,@SYSTEMID  
								    		,'SYSTEM'
								    		,GETDATE()  
								    		,@URL)
				END
				FETCH NEXT FROM UPDATE_MENULIST INTO @MENUID,    @MENUNAME, @PARMENUID, @SORT,    @PROGRAMID
					  							    ,@MENUTYPE,  @USEFLAG,  @REMARK,    @SYSTEMID 
	      END
	CLOSE UPDATE_MENULIST
	DEALLOCATE UPDATE_MENULIST
	END

	       
  
		SELECT @RS_CODE = 'S'
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
