USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0200_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0200_S1]
(
	   @WorkerID        VARCHAR(30)
	  ,@WorkerName		VARCHAR(30)
	  ,@UseFlag 		VARCHAR(1)
	  ,@Lang            VARCHAR(10)
	  ,@RS_CODE         VARCHAR(1)      OUTPUT
      ,@RS_MSG          VARCHAR(200)    OUTPUT  
)
AS
BEGIN
	BEGIN TRY
	      SELECT WorkerID  
	            ,WorkerName
		        ,'smartmes' AS Pwd		-- 사
		        ,GRPID		-- 그룹 권한
		        ,PLANTCODE
		        ,Lang
		        ,UseFlag
		        ,DBO.FN_WORKERNAME(Maker) AS Maker
		        ,CONVERT(VARCHAR, MakeDate, 120) MakeDate
		        ,DBO.FN_WORKERNAME(Editor) AS Editor
		        ,CONVERT(VARCHAR, EditDate, 120) EditDate
	        FROM TSY0300
	       WHERE WorkerID 	LIKE @WorkerID + '%'
	         AND WorkerName LIKE '%' + @WorkerName + '%'
	         AND UseFlag  	LIKE @UseFlag + '%'
	         AND WORKERID 	<> 'SYSTEM'
	    ORDER BY WorkerName
	    
	    SELECT @RS_CODE = 'S'
	END TRY
	
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
	END CATCH
END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]사용자관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0200_S1'
GO
