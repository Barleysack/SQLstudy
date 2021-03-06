USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ9000_I1]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**
  GRID 상태 저장
**/
CREATE PROCEDURE [dbo].[USP_ZZ9000_I1]
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
        
        IF (
            SELECT COUNT(*)
            FROM TZZ9000  WITH(NOLOCK) 
            WHERE USERID = @USERID 
            AND MDICHILDID = @MDICHILDID
            AND GRIDID = @GRIDID ) = 0
        BEGIN
        INSERT INTO TZZ9000 (USERID,MDICHILDID,GRIDID,CSTATUS)
        VALUES (@USERID,@MDICHILDID,@GRIDID,@STATUS)
        END
        ELSE
        BEGIN
            UPDATE TZZ9000  
            SET  CSTATUS=@STATUS
            WHERE USERID = @USERID 
            AND MDICHILDID = @MDICHILDID
            AND GRIDID = @GRIDID
        END
    END;
      
    SELECT @RS_CODE = 'S'
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
        -- PRINT   @RS_MSG    
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]그리드컬럼보기' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZZ9000_I1'
GO
