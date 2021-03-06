USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_WorkerMaster_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BM_WorkerMaster_I1]
/************************************************************************************
1. 작성자     : DSH
2. 작성일자   : 2020-08
3. 수정자     :
4. 수정일자   :
5. 기능       : 작업자 코드 등록
6. 연관테이블 : 
7. 연관 폼    :
**************************************************************************************
1. 수정일자   : 
2. 수정자     : 
3. 수정내용   : 
**************************************************************************************/
(    
      @PLANTCODE       VARCHAR(10)
     ,@WORKERID        VARCHAR(10)
     ,@WORKERNAME      VARCHAR(30)
     ,@BANCODE         VARCHAR(10)
     ,@GRPID           VARCHAR(20)
     ,@DEPTCODE        VARCHAR(10)
     ,@PDALOGINFLAG    VARCHAR(1)
     ,@MAKER           VARCHAR(10)
	 ,@USEFLAG         VARCHAR(1)
	 ,@PHONENO         VARCHAR(50)
	 ,@INDATE          VARCHAR(10)
	 ,@OUTDATE         VARCHAR(10)
	 ,@SPCFLAG         VARCHAR(1)
	 ,@PATROLFLAG      VARCHAR(1)
  
     ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT  
)
AS
BEGIN
	DECLARE @CNT INT;
	SET @CNT = 0;
	
	BEGIN
	  SELECT @CNT = COUNT(1)
	    FROM TB_WorkerList
	   WHERE PLANTCODE = @PLANTCODE
	     AND WORKERID  = @WORKERID;
	END;
	
	IF @CNT > 0 
	BEGIN
	  SET @RS_CODE = 'E';
	  SET @RS_MSG  = '이미 등록된 사용자입니다.';
	  RETURN;
	END;
	
   BEGIN TRY

     INSERT INTO TB_WorkerList 
               ( PLANTCODE               , WORKERID               , WORKERNAME              , BANCODE               , GRPID
          	   , PHONENO	               , INDATE                 , OUTDATE               , EMPNO
               , MAKER                   , MAKEDATE               , USEFLAG                 , DEPTCODE              , PDALOGINFLAG, SPCFLAG     ,PATROLFLAG)
          VALUES  
               ( @PLANTCODE              , @WORKERID              , @WORKERNAME             , @BANCODE              , @GRPID
	             , @PHONENO                , @INDATE                , @OUTDATE              , @WORKERID
               , @MAKER                  , GETDATE()              , @USEFLAG                , @DEPTCODE             , @PDALOGINFLAG, @SPCFLAG  ,@PATROLFLAG);
                         
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
