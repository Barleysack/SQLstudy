USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_CustMaster_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : BM_CustMaster_U1
  PROCEDURE NAME : 업체 마스터 수정
  ALTER DATE     : 2020.08
  MADE BY        : DSH
  DESCRIPTION    : 업체 마스터 수정
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[BM_CustMaster_U1]
(   @PLANTCODE		VARCHAR(10)				
  , @CUSTTYPE		VARCHAR(10)		
  , @CUSTCODE		VARCHAR(10)
  , @CUSTNAME		VARCHAR(100)
  , @BIZREQNO		VARCHAR(20)
  , @BIZPOSTNO		VARCHAR(8)
  , @PHONE			VARCHAR(100)
  , @ADDRESS		VARCHAR(100)
  , @ASGNNAME		VARCHAR(20)
  , @USEFLAG		VARCHAR(1)
  , @MAKER			VARCHAR(10)
  , @LANG           VARCHAR(10)='KO'
  , @RS_CODE		AS VARCHAR(1)	OUTPUT -- 처리결과 코드
  , @RS_MSG			AS VARCHAR(100)	OUTPUT -- 처리결과 메세지
)
AS
BEGIN TRY
      IF (@LANG=DBO.FN_DEFAULTLANG())
      BEGIN
		  EXEC USP_ZZ9100_I1 @LANG,@CUSTNAME,'BM0300'
		  EXEC USP_ZZ9100_I1 @LANG,@ADDRESS,'BM0300'
		  EXEC USP_ZZ9100_I1 @LANG,@ASGNNAME,'BM0300'
		 -- EXEC USP_ZZ9100_I1 @LANG,@BIZCLASS,'BM0300'
		 -- EXEC USP_ZZ9100_I1 @LANG,@BIZTYPE,'BM0300'
      END
	UPDATE TB_CustMaster
	   SET CUSTNAME		= CASE WHEN @LANG=DBO.FN_DEFAULTLANG() THEN  @CUSTNAME ELSE  CUSTNAME END 
		  ,BIZREQNO	    = @BIZREQNO
		  ,BIZPOSTNO	= @BIZPOSTNO
		  ,PHONE		= @PHONE
		  ,ADDRESS		= CASE WHEN @LANG=DBO.FN_DEFAULTLANG() THEN  @ADDRESS ELSE   ADDRESS END 
		  ,ASGNNAME		= @ASGNNAME
		  ,USEFLAG		= @USEFLAG
		  ,EDITDATE		= GETDATE()
		  ,EDITOR		= @MAKER
	 WHERE PLANTCODE    = @PLANTCODE
	   AND CUSTTYPE		= @CUSTTYPE
	   AND CUSTCODE		= @CUSTCODE

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
