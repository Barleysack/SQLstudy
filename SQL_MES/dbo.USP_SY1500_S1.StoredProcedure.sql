USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY1500_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
   FUNCTION ID    : USP_SY0800_S1
   FUNCTION NAME  : GRID 상세내용 정보
   CREATE DATE    : 2012.09.12
   MADE BY        : SAMMI INFORMATION SYSTEM CO.,LTD
   DESCRIPTION    : GRID 속성 정보 조회
 *---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_SY1500_S1]
(
    @PROGRAMID VARCHAR(10)
    ,@RS_CODE         VARCHAR(1) OUTPUT
    ,@RS_MSG          VARCHAR(200) OUTPUT    
)
AS
BEGIN TRY
    SELECT SYSTEMID
          ,PROGRAMID
          ,CONTROLID
          ,COLUMNID
          ,CONTROLSEQ
          ,DOMAINID
          ,UIDSYS
          ,CONTROLTYPE
          ,FORMAT
          ,EDITMASK
          ,USEFLAG
          ,CONTROLWIDTH
          ,COLUMNSEQ
          ,VERALIGNTYPE
          ,HORALIGNTYPE
          ,SORTSEQ
          ,SORTTYPE
          ,HIDDEN
          ,MAKER
          ,MAKEDATE
          ,EDITOR
          ,EDITDATE
      FROM TSY0800 WITH(NOLOCK)
     WHERE PROGRAMID LIKE @PROGRAMID + '%'
       AND CONTROLTYPE IN (SELECT CODENAME FROM TBM0000 WHERE MAJORCODE = 'CAPTION' AND RELCODE1 = 'GRID')
  ORDER BY PROGRAMID, CONTROLID, COLUMNSEQ
        SELECT @RS_CODE = 'S'
		SELECT @RS_MSG 	= '정상적으로 삭제되었습니다.'	
		RETURN
	END TRY
                                
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
GO
