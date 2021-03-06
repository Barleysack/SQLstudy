USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_CustMaster_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : BM_CustMaster_D1
  PROCEDURE NAME : 업체 마스터 삭제
  ALTER DATE     : 2020.08
  MADE BY        : DSH
  DESCRIPTION    : 업체 마스터 삭제
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[BM_CustMaster_D1]
(	 @PLANTCODE		VARCHAR(10)
	,@CUSTTYPE      VARCHAR(10)
	,@CUSTCODE      VARCHAR(10)
    ,@LANG          VARCHAR(10)='KO'
    ,@RS_CODE       VARCHAR(1) OUTPUT
	,@RS_MSG        VARCHAR(200) OUTPUT  
)
AS
BEGIN TRY
	/* FOREIGN KEY 체크 필요 */
	DELETE TB_CustMaster
	 WHERE PLANTCODE    = @PLANTCODE
	   AND CUSTTYPE		= @CUSTTYPE
	   AND CUSTCODE		= @CUSTCODE
	   
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

GO
