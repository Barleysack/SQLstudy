USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0900_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
   FUNCTION ID    : USP_SY0900_S1
   FUNCTION NAME  : 다국어 관리 UIDTYPE LIST 정보
   CREATE DATE    : 2012.09.12
   MADE BY        : SAMMI INFORMATION SYSTEM CO.,LTD
   DESCRIPTION    : UIDTYPE 정보
 *---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_SY0900_S2]
(
    @UIDTYPE  VARCHAR(5)
   ,@LANG     VARCHAR(5)
   ,@RS_CODE    VARCHAR(1) OUTPUT
   ,@RS_MSG     VARCHAR(200) OUTPUT 
)
AS
BEGIN TRY
    SELECT SYSTEMID, UIDSYS, LANG, UIDNAME, UIDTYPE
      FROM TSY1200 WITH(NOLOCK) 
     WHERE UIDTYPE = @UIDTYPE
       AND LANG    = 'KO'
  ORDER BY UIDSYS
  
        SELECT @RS_CODE = 'S'
		SELECT @RS_MSG 	= '정상적으로 삭제되었습니다.'	
		RETURN
	END TRY
                                
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
GO
