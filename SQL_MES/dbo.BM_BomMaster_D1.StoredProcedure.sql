USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_BomMaster_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BM_BomMaster_D1]
(
    @PLANTCODE       VARCHAR(10) --공장코드 SAP 명 - WERKS       
   ,@ITEMCODE        VARCHAR(30) --품목코드 SAP 명 - MATNR      
  , @COMPONENT       VARCHAR(30) --구성부품       

    ,@LANG			VARCHAR(10)='KO'
	,@RS_CODE       VARCHAR(1)    OUTPUT
    ,@RS_MSG        VARCHAR(200)  OUTPUT            
	)
AS
BEGIN
   BEGIN TRY    
	DELETE FROM TB_BomMaster
     WHERE ITEMCODE       = @ITEMCODE
	   AND PLANTCODE      = @PLANTCODE 
	   AND COMPONENT      = @COMPONENT
	   
        SELECT @RS_CODE = 'S'
 
	END TRY
	
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
END
GO
