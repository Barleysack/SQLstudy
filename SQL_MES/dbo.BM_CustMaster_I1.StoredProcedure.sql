USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_CustMaster_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : BM_CustMaster_I1
  PROCEDURE NAME : 업체 마스터 등록
  ALTER DATE     : 2020.08
  MADE BY        : DSH
  DESCRIPTION    : 업체 마스터 등록
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[BM_CustMaster_I1]
(	
	@PLANTCODE		VARCHAR(10) 
  ,	@CUSTTYPE		VARCHAR(10)
  , @CUSTCODE		VARCHAR(10)
  , @CUSTNAME		VARCHAR(100)
  , @BIZREQNO		VARCHAR(20)
  , @BIZPOSTNO		VARCHAR(8)
  , @PHONE			VARCHAR(100)
  , @ADDRESS		VARCHAR(100)
  , @ASGNNAME		VARCHAR(20)
  , @USEFLAG		VARCHAR(1)
  , @MAKER			VARCHAR(10)
  
  , @LANG           VARCHAR(10)  ='KO'
  , @RS_CODE        VARCHAR(1)   OUTPUT
  , @RS_MSG         VARCHAR(200) OUTPUT  
)
AS
BEGIN
	DECLARE @CNT INT;
	SET @CNT = 0;
	
	--중복체크
	BEGIN
	  SELECT @CNT = COUNT(1)
	    FROM TB_CustMaster
	   WHERE PLANTCODE = @PLANTCODE
	     AND CUSTTYPE  = @CUSTTYPE
	     AND CUSTCODE  = @CUSTCODE;
	END;
	
	IF @CNT > 0
	BEGIN
	  SET @RS_CODE = 'E';
	  SET @RS_MSG  = '이미 등록된 업체입니다. 확인하세요.';
	  RETURN;
	END;
	
	
    BEGIN TRY
     
      --업체코드 등록 
      INSERT INTO TB_CustMaster (PLANTCODE,	CUSTTYPE,	CUSTCODE,	CUSTNAME,	BIZREQNO,
                           BIZPOSTNO,	PHONE,		ADDRESS,	ASGNNAME,	USEFLAG,	 
 						   MAKER,		MAKEDATE)
 		           VALUES (@PLANTCODE,	@CUSTTYPE,	@CUSTCODE,	@CUSTNAME,	@BIZREQNO,
				 		   @BIZPOSTNO,	@PHONE,		@ADDRESS,	@ASGNNAME,	@USEFLAG, 
				 		   @MAKER,		GETDATE());
						 
	 SET @RS_CODE  = 'S';
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
