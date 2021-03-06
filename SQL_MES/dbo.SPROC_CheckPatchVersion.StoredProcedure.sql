USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_CheckPatchVersion]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
   패치 정보 확인.
 *---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[SPROC_CheckPatchVersion]
(
    @SYSTEMID  VARCHAR(20)
   ,@CLIENTID  VARCHAR(20)
   ,@DESCRIPT  VARCHAR(20)
   ,@MAKER     VARCHAR(20)
   ,@EDITOR    VARCHAR(20)
   ,@LANG         VARCHAR(5)
   ,@RS_CODE      VARCHAR(1) OUTPUT
   ,@RS_MSG       VARCHAR(200) OUTPUT 
)
AS
BEGIN
    DECLARE @CNT INT;
    SET @CNT = 0;
    
    BEGIN
      SELECT @CNT = ISNULL(MAX(SEQNO), 0) + 1 
        FROM SysPatchLog
       WHERE SYSTEMID = @SYSTEMID
         AND UPDATEDT = CONVERT(VARCHAR(10), GETDATE(), 120)
         AND CLIENTID = @CLIENTID;
    END;
    
	BEGIN TRY
	INSERT INTO SysPatchLog
          (SYSTEMID,  UPDATEDT,  CLIENTID, SEQNO, DESCRIPT,  MAKER,  MAKEDATE,  EDITOR,  EDITDATE)
    VALUES
         ( @SYSTEMID
          ,CONVERT(VARCHAR(10), GETDATE(), 120)
          ,@CLIENTID
          ,@CNT
          ,@DESCRIPT
          ,@MAKER
          ,GETDATE()
          ,@EDITOR
          ,GETDATE()
          );
	  
			SELECT @RS_CODE = 'S'
			
			RETURN
		END TRY
	                                
		BEGIN CATCH
			SELECT @RS_CODE = 'E'
			SELECT @RS_MSG 	= ERROR_MESSAGE()
		END CATCH
END

GO
