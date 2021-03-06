USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_CustMaster_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : BM_CustMaster_S1
  PROCEDURE NAME : 업체 마스터 조회
  ALTER DATE     : 2020.08
  MADE BY        : DSH
  DESCRIPTION    : 업체 마스터 조회
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[BM_CustMaster_S1]
(
	   @PLANTCODE		VARCHAR(10)
	  ,@CUSTTYPE	    VARCHAR(10)
	  ,@CUSTCODE		VARCHAR(10)
	  ,@CUSTNAME		VARCHAR(100)
	  ,@USEFLAG         VARCHAR(1)
      ,@LANG            VARCHAR(10)='KO'
      ,@RS_CODE         VARCHAR(1) OUTPUT
      ,@RS_MSG          VARCHAR(200) OUTPUT  
)
AS
BEGIN TRY
	SELECT A.PLANTCODE
	     , A.CUSTTYPE
		 , A.CUSTCODE
		 , DBO.FN_TRANSLATE(@LANG,A.CUSTNAME,'BM0300') AS CUSTNAME
		 , A.BIZREQNO
		 , A.BIZPOSTNO
		 , A.PHONE
		 , DBO.FN_TRANSLATE(@LANG,A.ADDRESS,'BM0300') AS  ADDRESS  
		 , A.ASGNNAME
		 , A.USEFLAG
		 , ISNULL(DBO.FN_WORKERNAME(A.MAKER), A.MAKER) AS MAKER
		 , convert(varchar,A.MAKEDATE,120)             as MAKEDATE
		 , ISNULL(DBO.FN_WORKERNAME(A.EDITOR), A.EDITOR) AS EDITOR
		 , convert(varchar,A.EDITDATE,120)             as EDITDATE 
	  FROM TB_CustMaster A   WITH(NOLOCK)
	 WHERE A.PLANTCODE LIKE @PLANTCODE + '%'
	   AND A.CUSTTYPE  LIKE @CUSTTYPE + '%'
	   AND A.CUSTCODE  LIKE @CUSTCODE + '%'
	   AND DBO.FN_TRANSLATE(@LANG,A.CUSTNAME,'BM0300') LIKE @CUSTNAME + '%'
	   AND ISNULL(A.USEFLAG,'')  LIKE @USEFLAG + '%'
     ORDER BY A.PLANTCODE, A.CUSTTYPE, A.CUSTCODE, A.CUSTNAME
     
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
