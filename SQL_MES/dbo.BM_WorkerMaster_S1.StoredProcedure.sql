USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_WorkerMaster_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BM_WorkerMaster_S1]
/************************************************************************************
1. 작성자     : DSH
2. 작성일자   : 2020-08
3. 수정자     :
4. 수정일자   :
5. 기능       : 작업자 조회
6. 연관테이블 : 
7. 연관 폼    :
**************************************************************************************/
(
      @PLANTCODE       VARCHAR(10)
     ,@WORKERID        VARCHAR(10)
     ,@WORKERNAME      VARCHAR(30)
     ,@BANCODE         VARCHAR(10)
     ,@USEFLAG         VARCHAR(1)
     ,@LANG            VARCHAR(10)='KO'
     ,@RS_CODE         VARCHAR(1) OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT
)
AS
BEGIN TRY
    SELECT PLANTCODE
          ,WORKERID
          ,DBO.FN_WORKERNAME(WORKERID)    AS WORKERNAME
          ,BANCODE
          ,GRPID
          ,DEPTCODE
          ,PDALOGINFLAG
		  ,SPCFLAG
		  ,PHONENO
    	  ,INDATE
          ,OUTDATE
          ,USEFLAG
		  ,PATROLFLAG
    	  ,DBO.FN_WORKERNAME(MAKER)							AS MAKER
          ,CONVERT(VARCHAR,MAKEDATE,120)					AS MAKEDATE
    	  ,DBO.FN_WORKERNAME(EDITOR)						AS EDITOR
    	  ,CONVERT(VARCHAR,EDITDATE,120)					AS EDITDATE
     FROM TB_WorkerList
    WHERE PLANTCODE             LIKE @PLANTCODE   + '%'
      AND WORKERID              LIKE @WORKERID    + '%'
      AND ISNULL(BANCODE,'')    LIKE @BANCODE     + '%'
      AND WORKERNAME            LIKE @WORKERNAME  + '%'
      AND USEFLAG               LIKE @USEFLAG     + '%'
    ORDER BY PLANTCODE, WORKERID, WORKERNAME;

    SET @RS_CODE = 'S'

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


GO
