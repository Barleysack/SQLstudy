USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0900_S3]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
   FUNCTION ID    : USP_SY0900_S1
   FUNCTION NAME  : 다국어 관리 프로그램 CONTROL 정보
   CREATE DATE    : 2012.09.12
   MADE BY        : SAMMI INFORMATION SYSTEM CO.,LTD
   DESCRIPTION    : FORM에서 사용되는 CONTROL 정보
 *---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_SY0900_S3]
(
    @PROGRAMID  VARCHAR(20)
   ,@LANG          VARCHAR(5)
   ,@RS_CODE    VARCHAR(1) OUTPUT
   ,@RS_MSG     VARCHAR(200) OUTPUT 
)
AS
BEGIN TRY
    SELECT A.PROGRAMID, A.CONTROLID, A.COLUMNID, A.UIDSYS, A.UIDNAME
      FROM (
            SELECT @PROGRAMID AS PROGRAMID, 'FORM' AS CONTROLID, '' AS COLUMNID, @PROGRAMID AS UIDSYS, UIDNAME
              FROM TSY1200 WITH(NOLOCK)
             WHERE UIDSYS = @PROGRAMID
               AND LANG = 'KO'
            UNION ALL
            SELECT A.PROGRAMID, A.CONTROLID, A.COLUMNID, A.UIDSYS, B.UIDNAME
              FROM TSY0800 A WITH(NOLOCK) LEFT OUTER JOIN TSY1200 B WITH(NOLOCK)
                                          ON A.UIDSYS = B.UIDSYS
             WHERE A.PROGRAMID = @PROGRAMID
               AND B.LANG = 'KO' ) A
     --WHERE A.COLUMNID <> '*'
  ORDER BY A.CONTROLID
  
        SELECT @RS_CODE = 'S'
		SELECT @RS_MSG 	= '정상적으로 삭제되었습니다.'	
		RETURN
	END TRY
                                
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
GO
