USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_CUSTMASTER_POP]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_CUSTMASTER_POP]    
(    
	  @CUSTCODE    VARCHAR(10)        -- 거래처코드
    , @CUSTNAME    VARCHAR(100)       -- 거래처명
    , @CUSTTYPE    VARCHAR(10)        -- 거래처구분( CUSTOMER, VENDER)
    , @USEFLAG     VARCHAR(1)
    , @LANG        VARCHAR(10)='KO'
    , @RS_CODE     VARCHAR(1)   OUTPUT
    , @RS_MSG      VARCHAR(200) OUTPUT   
)    
AS    
BEGIN TRY
   SELECT  CUSTTYPE                             AS CUSTTYPE               -- 거래처구분( CUSTOMER, VENDER)
          ,DBO.FN_CODENAME('CUSTTYPE',CUSTTYPE, @LANG) AS CUSTTYPENM             -- 구분명
          ,CUSTCODE                             AS CUSTCODE               -- 거래처코드          
          ,CUSTNAME  AS CUSTNAME               -- 거래처명
          ,CUSTENAME                            AS CUSTENAME              -- 업체명(영문) 
     FROM TB_CustMaster
    WHERE ISNULL(CUSTTYPE, '^')  LIKE @CUSTTYPE  + '%' 
      AND ISNULL(CUSTCODE, '^')  LIKE @CUSTCODE  + '%'
      AND ISNULL(CUSTNAME, '^')  LIKE @CUSTNAME  + '%'
      AND ISNULL(USEFLAG, '^')   LIKE @USEFLAG   + '%'   
    ORDER BY CUSTTYPE, CUSTCODE    

    SET @RS_CODE = 'S'
END TRY                           
BEGIN CATCH
    SET @RS_MSG  = ERROR_MESSAGE();
    SET @RS_CODE = 'E';    
END CATCH
GO
