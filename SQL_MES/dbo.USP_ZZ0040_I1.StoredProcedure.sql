USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ0040_I1]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
   FUNCTION ID    : USP_ZZ0022_01
   FUNCTION NAME  : 라이브업데이트 정보 읽어오기(MES)
   CREATE DATE    : 2015.08.18
   MADE BY        : 
   DESCRIPTION    : 
 *---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_ZZ0040_I1]
(
    @AS_SYSTEMID  VARCHAR(20)
   ,@AS_CLIENTID  VARCHAR(20)
   ,@AS_DESCRIPT  VARCHAR(20)
   ,@AS_MAKER     VARCHAR(20)
   ,@AS_EDITOR    VARCHAR(20)
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
        FROM TSY2300
       WHERE SYSTEMID = @AS_SYSTEMID
         AND UPDATEDT = CONVERT(VARCHAR(10), GETDATE(), 120)
         AND CLIENTID = @AS_CLIENTID;
    END;
    
	BEGIN TRY
	INSERT INTO TSY2300
          (SYSTEMID,  UPDATEDT,  CLIENTID, SEQNO, DESCRIPT,  MAKER,  MAKEDATE,  EDITOR,  EDITDATE)
    VALUES
         ( @AS_SYSTEMID
          ,CONVERT(VARCHAR(10), GETDATE(), 120)
          ,@AS_CLIENTID
          ,@CNT
          ,@AS_DESCRIPT
          ,@AS_MAKER
          ,GETDATE()
          ,@AS_EDITOR
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
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]라인브업데이트' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZZ0040_I1'
GO
