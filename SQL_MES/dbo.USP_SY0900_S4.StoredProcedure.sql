USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0900_S4]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
   FUNCTION ID    : USP_SY0900_S4
   FUNCTION NAME  : 다국어 정보
   CREATE DATE    : 2012.09.12
   MADE BY        : SAMMI INFORMATION SYSTEM CO.,LTD
   DESCRIPTION    : UID에 해당되는 언어 정보
 *---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_SY0900_S4]
(
    @UIDSYS      VARCHAR(100)
   ,@LANG          VARCHAR(5)
   ,@RS_CODE    VARCHAR(1) OUTPUT
   ,@RS_MSG     VARCHAR(200) OUTPUT 
)
AS
BEGIN TRY
    DECLARE @LANG_     VARCHAR(5)
    DECLARE @SYSTEMID_ VARCHAR(20)
    DECLARE @UID_      VARCHAR(50)
    DECLARE @UIDTYPE_  VARCHAR(5)
    DECLARE @MAKER_    VARCHAR(20)
    DECLARE @EDITOR_   VARCHAR(20)
    SELECT @LANG_      = LANG
         , @SYSTEMID_  = SYSTEMID
         , @UID_          = UIDSYS
         , @UIDTYPE_   = UIDTYPE
         , @MAKER_     = MAKER
         , @EDITOR_    = EDITOR
      FROM TSY1200 WITH(NOLOCK)
     WHERE UIDSYS = @UIDSYS
                                    
     SELECT A.MINORCODE AS LANG
           ,B.UIDNAME
           ,ISNULL(B.SYSTEMID, @SYSTEMID_) AS SYSTEMID
           ,ISNULL(B.UIDSYS,      @UID_)      AS UIDSYS
           ,ISNULL(B.UIDTYPE,  @UIDTYPE_)  AS UIDTYPE
           ,ISNULL(B.MAKER,    @MAKER_)    AS MAKER
           ,ISNULL(B.EDITOR,   @EDITOR_)   AS EDITOR
       FROM TBM0000 A WITH(NOLOCK) LEFT OUTER JOIN (SELECT DISTINCT LANG, UIDNAME, SYSTEMID, UIDSYS, UIDTYPE, MAKER, EDITOR
                                         FROM TSY1200 WITH(NOLOCK)
                                        WHERE UIDSYS = @UIDSYS) B
                                   ON A.MINORCODE = B.LANG
      WHERE MAJORCODE =  'LANG'
        AND MINORCODE <> '$'
   ORDER BY DISPLAYNO
   
        SELECT @RS_CODE = 'S'
		SELECT @RS_MSG 	= '정상적으로 삭제되었습니다.'	
		RETURN
	END TRY
                                
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
GO
