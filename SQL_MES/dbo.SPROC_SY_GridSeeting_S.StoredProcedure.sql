USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_SY_GridSeeting_S]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
  GRID 상태 조회 
**/
CREATE PROCEDURE [dbo].[SPROC_SY_GridSeeting_S]
(
     @USERID            VARCHAR(20)
    ,@MDICHILDID        VARCHAR(20)
    ,@GRIDID            VARCHAR(20)
    ,@LANG              VARCHAR(10)
    ,@RS_CODE           VARCHAR(1)='S'    OUTPUT
    ,@RS_MSG            VARCHAR(200)='' OUTPUT 
)
AS
BEGIN
    BEGIN TRY
    
    
        SELECT CSTATUS
          FROM TZZ9000  WITH(NOLOCK) 
         WHERE USERID     = @USERID 
           AND MDICHILDID = @MDICHILDID
           AND GRIDID     = @GRIDID
      
    SELECT @RS_CODE = 'S'
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
        -- PRINT   @RS_MSG    
	END CATCH
END
GO
