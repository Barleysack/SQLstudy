USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_WORKCENTER_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : BM_WORKCENTER_D1
  PROCEDURE NAME : 작업장 마스터 삭제
  ALTER DATE     : 2020.08
  MADE BY        : DSH
  DESCRIPTION    : 
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[BM_WORKCENTER_D1]
(
     @PLANTCODE          VARCHAR(10)
   , @WORKCENTERCODE     VARCHAR(10)
    ,@LANG               VARCHAR(10)='KO'
    ,@RS_CODE            VARCHAR(1)   OUTPUT                                                
    ,@RS_MSG             VARCHAR(200) OUTPUT 
)
AS
	SELECT @PLANTCODE      = LTRIM(RTRIM(ISNULL(@PLANTCODE, '')))
		 , @WORKCENTERCODE = LTRIM(RTRIM(ISNULL(@WORKCENTERCODE, '')))
BEGIN
	BEGIN TRY
		DELETE TB_WORKCENTERMASTER 
	   	 WHERE PLANTCODE      = @PLANTCODE
		   AND WORKCENTERCODE = @WORKCENTERCODE

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
