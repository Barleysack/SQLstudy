USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0320_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------
    프로시져 명 : USP_SY0320_I1
    개      요  : SCM(외주 시스템) 사용자 관리 - 삭제
    작성자 명   : 최길용
    작성 일자   : 2015/12/07
    수정자 명   : 
    수정 일자   : 
    수정 사유   : 
    수정 내용   : 
----------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_SY0320_D1]
(
     @AS_PLANTCODE          VARCHAR(10)
    ,@AS_CUSTCODE           VARCHAR(20)
    ,@AS_ID                 VARCHAR(40)
    ,@LANG                  VARCHAR(10)   =  'KO'
    ,@RS_CODE               VARCHAR(1)    OUTPUT                            
    ,@RS_MSG                VARCHAR(200)  OUTPUT 
)
AS
    SET NOCOUNT ON

BEGIN TRY

    BEGIN
        DELETE TSY0320
        WHERE PLANTCODE = @AS_PLANTCODE
          AND CUSTCODE  = @AS_CUSTCODE
          AND WORKERID  = @AS_ID
    END;

    SET @RS_CODE   = 'S';
    SET @RS_MSG = '정상적으로 삭제되었습니다.';
END TRY

BEGIN CATCH
    SET @RS_MSG  = ERROR_MESSAGE()
    SET @RS_CODE = 'E'
    PRINT @RS_MSG
END CATCH
GO
