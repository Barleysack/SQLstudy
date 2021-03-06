USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_WorkerMaster_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BM_WorkerMaster_D1]
/************************************************************************************
1. 작성자     : 동상현
2. 작성일자   : 2020-08
3. 수정자     :
4. 수정일자   :
5. 기능       : 작업자 삭제
6. 연관테이블 : 
7. 연관 폼    :
**************************************************************************************/
(
       @PLANTCODE    VARCHAR(10) 
	  ,@WORKERID	 VARCHAR(10)
 	  ,@LANG         VARCHAR(10)   = 'KO'
 	  ,@RS_CODE      VARCHAR(1)    OUTPUT                            
      ,@RS_MSG       VARCHAR(200)  OUTPUT  
)
AS
BEGIN
  BEGIN TRY  

	DELETE TB_WorkerList
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKERID  = @WORKERID

	   SELECT @RS_CODE  = 'S'
	END TRY                                
	
	BEGIN CATCH
	    	 INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER()    AS ERRORNUMBER
				 , ERROR_LINE()      AS ERRORLINE
				 , ERROR_MESSAGE()   AS ERRORMESSAGE
				 , GETDATE()
		
		SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
	END CATCH   	
END
GO
