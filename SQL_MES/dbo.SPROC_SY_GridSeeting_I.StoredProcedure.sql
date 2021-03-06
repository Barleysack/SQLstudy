USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_SY_GridSeeting_I]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
  사용자 별 GRID 상태 저장 SPROC_SY_GridSeeting_I
**/
CREATE PROCEDURE [dbo].[SPROC_SY_GridSeeting_I]
(
     @USERID        VARCHAR(20)
    ,@MDICHILDID        VARCHAR(20)
    ,@GRIDID             VARCHAR(20)
    ,@STATUS             VARCHAR(2000)
    ,@LANG             VARCHAR(10)
    ,@RS_CODE          VARCHAR(1)='S'    OUTPUT
    ,@RS_MSG           VARCHAR(200)=''  OUTPUT 
)
AS
BEGIN
    BEGIN TRY
    IF @USERID != 'SYSTEM'
    BEGIN
        
        --IF (
        --    SELECT COUNT(*)
        --    FROM TZZ9000  WITH(NOLOCK) 
        --    WHERE USERID = @USERID 
        --    AND MDICHILDID = @MDICHILDID
        --    AND GRIDID = @GRIDID ) = 0
        --BEGIN
        --INSERT INTO TZZ9000 (USERID,MDICHILDID,GRIDID,CSTATUS)
        --VALUES (@USERID,@MDICHILDID,@GRIDID,@STATUS)
        --END
        --ELSE
        --BEGIN
        --    UPDATE TZZ9000  
        --    SET  CSTATUS=@STATUS
        --    WHERE USERID = @USERID 
        --    AND MDICHILDID = @MDICHILDID
        --    AND GRIDID = @GRIDID
        --END
	SELECT @RS_CODE = 'S'
    END;
      
    
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
        -- PRINT   @RS_MSG    
	END CATCH
END
GO
