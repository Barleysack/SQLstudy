USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ0000_S10_A]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------
    프로시져 명 : MBSP_ZZ0000_S10
    개      요 : 로그인 사용자 PLANTCODE, PLANTNAME, DEPTCODE, DEPTNAME
             가져오기
    작성자 명  : 박 석준
    작성 일자  : 2014/03/26
    수정자 명  :
    수정 일자  : 
    수정 사유  : 
    수정 내용  : 
    수정 사유  :    
EXEC MBSP_ZZ0000_S10 'MB0000', ' ', ' '
----------------------------------------------------------------------*/  

CREATE PROCEDURE [dbo].[USP_ZZ0000_S10_A]
(
      @WORKERID             VARCHAR(20)
     ,@RS_CODE              VARCHAR(1) OUTPUT
     ,@RS_MSG               VARCHAR(200) OUTPUT 
)                                  
AS

DECLARE @CPLANTCODE      VARCHAR(30)
DECLARE @CDEPTCODE      VARCHAR(30)

BEGIN
   SET @CPLANTCODE = (SELECT PLANTCODE FROM TBM0200 WHERE WORKERID = @WORKERID)
   SET @CDEPTCODE = (SELECT DEPTCODE FROM TBM0200 WHERE WORKERID = @WORKERID)
   
   --IF @WORKERID <> 'MB0000'
   BEGIN
      SELECT MINORCODE, CODENAME 
      FROM TBM0000
      WHERE MAJORCODE = 'PLANTCODE' AND MINORCODE = @CPLANTCODE      
   END

   --ELSE
   --BEGIN
   --   SELECT MINORCODE, CODENAME 
   --   FROM TBM0000
   --   WHERE MAJORCODE = 'PLANTCODE' AND MINORCODE <> '$'
   --END

   SELECT MINORCODE, CODENAME
   FROM TBM0000
   WHERE MAJORCODE = 'DEPTCODE' 
        AND MINORCODE = @CDEPTCODE AND RELCODE1 = @CPLANTCODE

   SELECT @RS_MSG = '정상적으로 로드되었습니다.'
   SELECT @RS_CODE = 'S'

BEGIN TRY

   RETURN
END TRY                           

BEGIN CATCH

     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT @RS_CODE = 'E'                 
END CATCH

END
GO
