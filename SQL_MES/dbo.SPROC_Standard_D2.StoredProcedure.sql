USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_Standard_D2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_Standard_D2]
(
	   @MAJORCODE        VARCHAR(30)
	  ,@MINORCODE        VARCHAR(30)
 	  ,@LANG             VARCHAR(10)='KO'
 	  ,@RS_CODE          VARCHAR(1)    OUTPUT                            
      ,@RS_MSG           VARCHAR(200)  OUTPUT     	
)
AS
	SELECT @MAJORCODE = LTRIM(RTRIM(ISNULL(@MAJORCODE, '')))
		, @MINORCODE = LTRIM(RTRIM(ISNULL(@MINORCODE, '')))

/**********************************************************************************************
기준정보 상세 삭제
**********************************************************************************************/
BEGIN TRY
		DELETE TB_Standard
		 WHERE MAJORCODE = @MAJORCODE
		   AND MINORCODE = @MINORCODE
     SELECT @RS_CODE = 'S'                                                
END TRY                                                                                                                                           
BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
END CATCH

GO
