USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0101_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0101_D1]
(
	   @AS_WORKERID         VARCHAR(30)
	  ,@AS_MENUID           VARCHAR(50)
      ,@LANG             VARCHAR(5)
	  ,@RS_CODE             VARCHAR(1)   OUTPUT
      ,@RS_MSG              VARCHAR(200) OUTPUT    
)
AS
	DECLARE @PROGRAMID	VARCHAR(30)
BEGIN TRY
	IF EXISTS ( SELECT 1 
				  FROM TSY0200
				 WHERE WORKERID = @AS_WORKERID
				   AND MENUID   = @AS_MENUID
				   AND MENUTYPE = 'M' )
	BEGIN
		-- 메뉴를 통째로 지울경우 하단에 있는 메뉴들도 모두 삭제 처리
		IF EXISTS ( SELECT 1 FROM TSY0200
		                       WHERE WORKERID  = @AS_WORKERID
		                         AND PARMENUID = @AS_MENUID
		                         AND MENUTYPE = 'P' )
		BEGIN
			DELETE TSY0100
			 WHERE WORKERID = @AS_WORKERID
			   AND PROGRAMID IN ( SELECT PROGRAMID FROM TSY0200
			                       WHERE WORKERID  = @AS_WORKERID
			                         AND PARMENUID = @AS_MENUID
			                         AND MENUTYPE = 'P' )
		END
		
		                         
		DELETE TSY0200
         WHERE WORKERID  = @AS_WORKERID
           AND MENUID    = @AS_MENUID
	END
	ELSE
	BEGIN
		
		SELECT @PROGRAMID = PROGRAMID
		  FROM TSY0200
		 WHERE WORKERID = @AS_WORKERID
		   AND MENUID   = @AS_MENUID
		   
	     DELETE FROM TSY0200
		  WHERE WORKERID = @AS_WORKERID
		    AND MENUID   = @AS_MENUID
		    
		IF ISNULL(@PROGRAMID, '') <> ''
		BEGIN
			DELETE TSY0100
			 WHERE PROGRAMID = @PROGRAMID
			   AND WORKERID  = @AS_WORKERID 
		END
	END
	    SELECT @RS_CODE = 'S'
	END TRY
                                
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]메뉴관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0101_D1'
GO
