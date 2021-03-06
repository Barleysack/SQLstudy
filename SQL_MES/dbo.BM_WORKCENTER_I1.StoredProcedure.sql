USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_WORKCENTER_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : BM_WORKCENTER_I1
  PROCEDURE NAME : 작업장 마스터 등록
  ALTER DATE     : 2020.08
  MADE BY        : DSH
  DESCRIPTION    : 
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[BM_WORKCENTER_I1]
(
     @PLANTCODE          VARCHAR(10)
    ,@WORKCENTERCODE     VARCHAR(10)
    ,@WORKCENTERNAME     VARCHAR(50)
    ,@BANCODE            VARCHAR(10)
    ,@ATSTFLAG           VARCHAR(1)
    ,@STDMANCNT          INT
    ,@DOWNTIMECOST       FLOAT
    ,@MOLDUSE            VARCHAR(10)
	,@WORKCENTERGUBUN    VARCHAR(2) -- 작업장 사용처 구분 QM : 품질 PP : 생산 PQ : 양쪽
    ,@USEFLAG            VARCHAR(1)
    ,@MAKER              VARCHAR(10) 
    ,@LANG               VARCHAR(10)='KO'
    ,@RS_CODE            VARCHAR(1)   OUTPUT
    ,@RS_MSG             VARCHAR(200) OUT

)
AS
BEGIN
    BEGIN TRY

        INSERT INTO TB_WORKCENTERMASTER 
        (   PLANTCODE
          , WORKCENTERCODE
          , WORKCENTERNAME
          , OPCode
		  , LINECODE
          , BANCODE
		  , WORKCENTERGUBUN
          , ATSTFLAG
          , STDMANCNT
          , DOWNTIMECOST
          , ZBID
          , ZBFLAG
          , MOLDUSE
          , USEFLAG
          , MAKEDATE
          , MAKER
        )
       VALUES 
        (   @PLANTCODE
          , @WORKCENTERCODE
          , @WORKCENTERNAME
          , null
		  , null
          , @BANCODE
		  , @WORKCENTERGUBUN
          , @ATSTFLAG
          , @STDMANCNT
          , @DOWNTIMECOST
          , null
          , null
          , @MOLDUSE
          , @USEFLAG
          , GETDATE()
          , @MAKER
         )
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
