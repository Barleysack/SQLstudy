USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0900_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
   FUNCTION ID    : USP_SY0900_S1
   FUNCTION NAME  : 다국어 관리 TITLE정보
   CREATE DATE    : 2012.09.12
   MADE BY        : SAMMI INFORMATION SYSTEM CO.,LTD
   DESCRIPTION    : 메뉴, 프로그램, POPUP, 기준코드, 메시지
 *---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_SY0900_S1]
AS
BEGIN
    SELECT A.UIDTYPE
          ,CASE WHEN A.UIDTYPE = 'PID_M' THEN 'MENU'
                WHEN A.UIDTYPE = 'PID'   THEN 'PROGRAM'
                WHEN A.UIDTYPE = 'PID_P' THEN 'POPUP'
                WHEN A.UIDTYPE = 'CID'   THEN 'CODE'
                WHEN A.UIDTYPE = 'MID'   THEN 'MESSAGE'
            END AS UIDTYPENM
      FROM (SELECT DISTINCT(UIDTYPE) FROM TSY1200 WITH(NOLOCK) WHERE UIDTYPE <> 'UID') A
END
GO
