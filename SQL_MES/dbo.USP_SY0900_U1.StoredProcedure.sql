USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0900_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
   FUNCTION ID    : USP_SY0900_U1
   FUNCTION NAME  : 다국어 정보
   CREATE DATE    : 2012.09.12
   MADE BY        : SAMMI INFORMATION SYSTEM CO.,LTD
   DESCRIPTION    : UID에 해당되는 언어 정보
 *---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_SY0900_U1]
(
    @SYSTEMID    VARCHAR(20)
   ,@UIDSYS        VARCHAR(50)
   ,@LANG          VARCHAR(5)
   ,@UIDNAME    VARCHAR(200)
   ,@UIDTYPE     VARCHAR(5)
   ,@MAKER        VARCHAR(20)
   ,@EDITOR        VARCHAR(20)
   ,@RS_CODE    VARCHAR(1) OUTPUT
   ,@RS_MSG     VARCHAR(200) OUTPUT 
)
AS
BEGIN TRY
    UPDATE TSY1200
       SET UIDNAME  = @UIDNAME
          ,EDITOR   = @EDITOR
          ,EDITDATE = GETDATE()
     WHERE UIDSYS      = @UIDSYS
       AND LANG     = @LANG
       AND UIDTYPE  = @UIDTYPE

    IF(@@ROWCOUNT = 0)
    BEGIN
        INSERT TSY1200
               (SYSTEMID,  UIDSYS,  LANG,  UIDNAME,  UIDTYPE,  MAKER,  MAKEDATE)
        VALUES(@SYSTEMID, @UIDSYS, @LANG, @UIDNAME, @UIDTYPE, @MAKER, GETDATE())
    END
    
        SELECT @RS_CODE = 'S'
		SELECT @RS_MSG 	= '정상적으로 삭제되었습니다.'	
		RETURN
	END TRY
                                
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
GO
