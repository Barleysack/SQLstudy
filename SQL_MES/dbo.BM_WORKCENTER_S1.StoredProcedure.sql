USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_WORKCENTER_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : BM_WORKCENTER_S1
  PROCEDURE NAME : 작업장 마스터 등록
  ALTER DATE     : 2020.08
  MADE BY        : DSH
  DESCRIPTION    : 작업장 마스터 등록
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[BM_WORKCENTER_S1]
(
      @PLANTCODE            VARCHAR(10)    -- 공장
     ,@WORKCENTERCODE       VARCHAR(10)    -- 작업장
     ,@WORKCENTERNAME       VARCHAR(80)    -- 작업장명
     ,@BANCODE              VARCHAR(10)    -- 작업반
     ,@USEFLAG              VARCHAR(1)     -- 사용여부
     ,@LANG                 VARCHAR(10)='KO'
     ,@RS_CODE          VARCHAR(1) OUTPUT
     ,@RS_MSG            VARCHAR(200) OUTPUT
)
AS
BEGIN
    BEGIN TRY

      BEGIN
        SELECT
              PLANTCODE               AS PLANTCODE
             ,WORKCENTERCODE          AS WORKCENTERCODE
             ,WORKCENTERNAME          AS WORKCENTERNAME
			 ,WORKCENTERGUBUN         AS WORKCENTERGUBUN
             ,ATSTFLAG                AS ATSTFLAG
             ,STDMANCNT               AS STDMANCNT
             ,DOWNTIMECOST            AS DOWNTIMECOST
             ,MOLDUSE                 AS MOLDUSE
             ,USEFLAG                 AS USEFLAG
			 ,BANCODE				  AS BANCODE
			 ,CASE WHEN ISNULL(ERRORFLAG,'N') = 'N' THEN '정상' ELSE '고장' END				  AS ERRORFLAG
             ,DBO.FN_WORKERNAME(MAKER)                   AS MAKER
			 ,MAKEDATE                AS MAKEDATE
			 ,DBO.FN_WORKERNAME(EDITOR)                  AS EDITOR
             ,EDITDATE                 AS EDITDATE

         FROM TB_WORKCENTERMASTER WITH(NOLOCK)
        WHERE 1=1
          AND PLANTCODE                  LIKE  ISNULL(@PLANTCODE,'')+'%'
          AND WORKCENTERCODE             LIKE  ISNULL(@WORKCENTERCODE,'') +'%'
          AND WORKCENTERNAME             LIKE  ISNULL(@WORKCENTERNAME,'') +'%'
          AND ISNULL(BANCODE,'')         LIKE  @BANCODE +'%'
          AND USEFLAG                    LIKE  ISNULL(@USEFLAG,'')+'%'
       ORDER BY PLANTCODE, WORKCENTERCODE
     END
           
      
    SELECT @RS_CODE = 'S'

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
