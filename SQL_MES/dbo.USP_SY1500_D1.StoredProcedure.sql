USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY1500_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
   FUNCTION ID    : USP_SY0800_D1
   FUNCTION NAME  : GRID 정보 삭제
   CREATE DATE    : 2012.09.12
   MADE BY        : SAMMI INFORMATION SYSTEM CO.,LTD
   DESCRIPTION    : GRID 속성 정보 삭제
 *---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_SY1500_D1]
(
     @PROGRAMID      VARCHAR(20)
	,@SYSTEMID        VARCHAR(20)
	,@COLUMNID       VARCHAR(20)
	,@CONTROLID        VARCHAR(20)
	,@RS_CODE        VARCHAR(1) OUTPUT
    ,@RS_MSG         VARCHAR(200) OUTPUT 
)
AS
BEGIN
BEGIN TRY   
    DELETE FROM TSY0800
     WHERE PROGRAMID = @PROGRAMID
       AND SYSTEMID  = @SYSTEMID
       AND COLUMNID  = @COLUMNID
       AND CONTROLID = @CONTROLID
       	 SELECT @RS_CODE = 'S'
         SELECT @RS_MSG = '정상적으로 등록되었습니다.'
   RETURN
END TRY                           
BEGIN CATCH
     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT @RS_CODE = 'E'                 
END CATCH    
END
GO
