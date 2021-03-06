USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0320_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------
    프로시져 명 : USP_SY0320_I1
    개      요  : SCM(외주 시스템) 사용자 관리 - 등록
    작성자 명   : 최길용
    작성 일자   : 2015/12/07
    수정자 명   : 
    수정 일자   : 
    수정 사유   : 
    수정 내용   : 
----------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_SY0320_I1]
(
     @AS_PLANTCODE          VARCHAR(10)
    ,@AS_CUSTCODE           VARCHAR(20)
    ,@AS_ID                 VARCHAR(40)
    ,@AS_CUSTNAME           VARCHAR(40)
    ,@AS_PWD                VARCHAR(40)
    ,@AS_USEFLAG            VARCHAR(5)
    ,@AS_MAKER              VARCHAR(40)
    ,@LANG                  VARCHAR(10)   =  'KO'
    ,@RS_CODE               VARCHAR(1)    OUTPUT                            
    ,@RS_MSG                VARCHAR(200)  OUTPUT 
)
AS
    SET NOCOUNT ON
    
    DECLARE @LD_TIME        DATETIME
    DECLARE @LI_CNT         INT;

BEGIN TRY

    BEGIN
        SET @LI_CNT     = 0;
        SET @LD_TIME    = GETDATE();
        SET @AS_PWD = ISNULL(@AS_PWD, '');
        SET @AS_USEFLAG = ISNULL(@AS_USEFLAG, 'Y');
    END;

    BEGIN
        SELECT @LI_CNT = COUNT(1)
        FROM TSY0320 WITH(NOLOCK)
        WHERE WORKERID  = @AS_ID
    END;
    
    IF @LI_CNT > 0
    BEGIN
        SET @RS_CODE = 'E';
        SET @RS_MSG  = '이미 등록 된 ID입니다.';
        RETURN;
    END;

    IF @AS_PWD IS NULL
    BEGIN
        SET @RS_CODE = 'E';
        SET @RS_MSG  = '비밀번호를 입력해야 합니다.';
        RETURN;
    END;

    BEGIN
        INSERT INTO TSY0320 (
            PLANTCODE,    CUSTCODE,     WORKERID, WORKERNAME,   PWD,
            USEFLAG,      MAKER,        MAKEDATE) 
        VALUES (
           @AS_PLANTCODE, @AS_CUSTCODE, @AS_ID,   @AS_CUSTNAME, @AS_PWD,
           @AS_USEFLAG,   @AS_MAKER,    @LD_TIME)
    END;

    SET @RS_CODE   = 'S';
    SET @RS_MSG = '정상적으로 등록되었습니다.';
END TRY

BEGIN CATCH
    SET @RS_MSG  = ERROR_MESSAGE()
    SET @RS_CODE = 'E'
    PRINT @RS_MSG
END CATCH
GO
