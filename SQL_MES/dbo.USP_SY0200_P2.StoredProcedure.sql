USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0200_P2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0200_P2]
(
	   @FROMWORKERID         VARCHAR(30)
	  ,@TOWORKERID           VARCHAR(30)
      ,@LANG         VARCHAR(10) ='KO' 
 	  ,@RS_CODE         VARCHAR(1) OUTPUT
      ,@RS_MSG          VARCHAR(200) OUTPUT  )
AS
BEGIN
    BEGIN TRY
  
    
     DELETE FROM TSY0301
      WHERE WORKERID = @TOWORKERID;
   
      
     -- 사용자별 사업장 권한 프로그램 정보 복사
     INSERT INTO TSY0301
           (WORKERID, PLANTCODE)
     SELECT @TOWORKERID, PLANTCODE
       FROM TSY0301
      WHERE WORKERID = @FROMWORKERID;
      
          SET  @RS_CODE = 'S'  
   END TRY
	BEGIN CATCH                                                              
         SET  @RS_MSG = ERROR_MESSAGE()                               
         SET  @RS_CODE = 'E'  
         SELECT ''                                        
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]사용자관리_복사' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0200_P2'
GO
