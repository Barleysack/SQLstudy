USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0320_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------
    프로시져 명 : USP_SY0320_S1
    개      요  : SCM(외주 시스템) 사용자 관리 - 조회
    작성자 명   : 최길용
    작성 일자   : 2015/12/07
    수정자 명   : 
    수정 일자   : 
    수정 사유   : 
    수정 내용   : 
----------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_SY0320_S1]
(
     @AS_PLANTCODE          VARCHAR(10)
    ,@AS_CUSTCODE           VARCHAR(20)
    ,@AS_ID                 VARCHAR(40)
    ,@AS_USEFLAG            VARCHAR(5)
    ,@LANG                  VARCHAR(10)   =  'KO'
    ,@RS_CODE               VARCHAR(1)    OUTPUT                            
    ,@RS_MSG                VARCHAR(200)  OUTPUT 
)
AS
    SET NOCOUNT ON

BEGIN TRY

    BEGIN
        SELECT 
            PLANTCODE,                                          --공장
            WORKERID                        AS ID,              --사용자ID
            CUSTCODE,                                           --업체
            WORKERNAME                      AS CUSTNAME,        --업체명
            PWD,                                                --비밀번호
            USEFLAG,                                            --사용유무
            DBO.FN_WORKERNAME(MAKER)        AS MAKER,
            CONVERT(VARCHAR, MAKEDATE, 120) AS MAKEDATE,
            DBO.FN_WORKERNAME(EDITOR)       AS EDITOR,
            CONVERT(VARCHAR, EDITDATE, 120) AS EDITDATE
        FROM TSY0320 WITH(NOLOCK)
        WHERE PLANTCODE  LIKE @AS_PLANTCODE  + '%'
          AND CUSTCODE   LIKE @AS_CUSTCODE   + '%'
          AND WORKERID   LIKE @AS_ID         + '%'
          AND USEFLAG    LIKE @AS_USEFLAG    + '%'
    END;

    SET @RS_CODE   = 'S'
    SET @RS_MSG = '정상적으로 조회되었습니다.'  
END TRY

BEGIN CATCH
    SET @RS_MSG  = ERROR_MESSAGE()
    SET @RS_CODE = 'E'
    PRINT @RS_MSG
END CATCH
GO
