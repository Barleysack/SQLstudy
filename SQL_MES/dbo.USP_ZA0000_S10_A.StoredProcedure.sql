USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZA0000_S10_A]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------
    프로시져 명 : MBSP_ZA0000_S10
    개      요 : 모바일 페이지 메뉴 로드
    작성자 명  : 박 석준
    작성 일자  : 2014/03/26
    수정자 명  :
    수정 일자  : 
    수정 사유  : 
    수정 내용  : 
    수정 사유  :    
EXEC MBSP_ZA0000_S10 'MB0000', '0', ' ', ' '
----------------------------------------------------------------------*/  
CREATE PROCEDURE [dbo].[USP_ZA0000_S10_A]
(
      @WORKERID             VARCHAR(20)
     ,@PARMENUID            INTEGER 
     ,@RS_CODE              VARCHAR(1) OUTPUT
     ,@RS_MSG               VARCHAR(200) OUTPUT 
)                                  
AS

    DECLARE @CNT           INTEGER 
    DECLARE @GRPID         VARCHAR(20)

   DECLARE @SMENUID        INTEGER
   DECLARE @SMENUNAME      VARCHAR(255)
   DECLARE @SPARMENUID     INTEGER
   DECLARE @SSORT          INTEGER
   DECLARE @SPROGRAMID     VARCHAR(50)
   DECLARE @SMENUTYPE      VARCHAR(5)
   DECLARE @SURL           VARCHAR(255)

   CREATE TABLE #TEMP (
      TEMP_MENU           INTEGER,
      TEMP_MENUNAME       VARCHAR(255),
      TEMP_PARMENUID      INTEGER,
      TEMP_SORT           INTEGER,
      TEMP_PROGRAMID      VARCHAR(50),
      TEMP_MENUTYPE       VARCHAR(5),
      TEMP_URL            VARCHAR(255)
   )
BEGIN
BEGIN TRY
        SELECT @CNT = COUNT(*)
          FROM TBM0200
         WHERE WORKERID = @WORKERID;
        
        IF @CNT > 0
        BEGIN
            SELECT @GRPID = GRPID
              FROM TBM0200
             WHERE WORKERID = @WORKERID;
        END
      ELSE
      BEGIN
         SELECT @RS_CODE = 'ERRDATA'
         SELECT @RS_MSG = '메뉴 권한이 없습니다'
         RETURN
      END

         IF @WORKERID = 'SYSTEM'
        BEGIN
         SELECT @WORKERID = 'SYSTEM';
         SELECT @GRPID    = 'SYSTEM';
        END;
        
      --커서를 선언, CURSORA에 데이터 담기
      DECLARE CURSORA   CURSOR FAST_FORWARD FOR

         SELECT MENU.MENUID
              ,LANGTB.UIDNAME AS MENUNAME
              ,MENU.PARMENUID
              ,MENU.SORT
              ,MENU.PROGRAMID
              ,MENU.MENUTYPE
              ,MENU.URL
           FROM TSY0200 MENU
LEFT OUTER JOIN TSY0100 PROGRAM  ON MENU.PROGRAMID   = PROGRAM.PROGRAMID
                                AND PROGRAM.WORKERID = @WORKERID
LEFT OUTER JOIN TSY1200 LANGTB   ON MENU.PROGRAMID   = LANGTB.UIDSYS
                                AND LANG             = 'KO'
          WHERE MENU.WORKERID  = @GRPID 
            AND MENU.USEFLAG   = 'Y'
            AND MENU.PARMENUID = @PARMENUID
            AND MENU.REMARK = 'MOBILE'
      --   ORDER BY MENU.SORT ASC;
           ORDER BY MENU.PARMENUID ASC;

         --CURSORA를 OPEN
         OPEN CURSORA

         FETCH NEXT FROM CURSORA
         INTO
            @SMENUID,
            @SMENUNAME,
            @SPARMENUID,
            @SSORT,
            @SPROGRAMID,
            @SMENUTYPE,
            @SURL

         WHILE @@FETCH_STATUS = 0
         BEGIN
            
            --상위 메뉴 목록을 임시 테이블에 담기
            INSERT INTO #TEMP
            (
               TEMP_MENU,
               TEMP_MENUNAME,
               TEMP_PARMENUID,
               TEMP_SORT,
               TEMP_PROGRAMID,
               TEMP_MENUTYPE,
               TEMP_URL
            )
            VALUES
            (
               @SMENUID,
               @SMENUNAME,
               @SPARMENUID,
               @SSORT,
               @SPROGRAMID,
               @SMENUTYPE,
               @SURL
            )

            --상위 메뉴에 따른 하위 메뉴 목록을 임시 테이블에 담기
            INSERT INTO #TEMP
            (
               TEMP_MENU,
               TEMP_MENUNAME,
               TEMP_PARMENUID,
               TEMP_SORT,
               TEMP_PROGRAMID,
               TEMP_MENUTYPE,
              TEMP_URL
            )
            SELECT MENU.MENUID
                  ,LANGTB.UIDNAME AS MENUNAME
                  ,MENU.PARMENUID
          ,MENU.SORT
                  ,MENU.PROGRAMID
                  ,MENU.MENUTYPE
                  ,MENU.URL
               FROM TSY0200 MENU 
    LEFT OUTER JOIN TSY0100 PROGRAM  ON
                    MENU.PROGRAMID   = PROGRAM.PROGRAMID
                AND PROGRAM.WORKERID = @WORKERID
    LEFT OUTER JOIN TSY1200 LANGTB   ON 
                    MENU.PROGRAMID   = LANGTB.UIDSYS
                AND LANG             = 'KO'
               WHERE MENU.WORKERID  = @GRPID 
                 AND MENU.USEFLAG   = 'Y'
                 AND MENU.PARMENUID = @SMENUID
                 AND MENU.REMARK = 'MOBILE'
          --  ORDER BY MENU.SORT ASC; 
          ORDER BY MENU.PROGRAMID ASC; 

         FETCH NEXT FROM CURSORA
         INTO
            @SMENUID,
            @SMENUNAME,
            @SPARMENUID,
            @SSORT,
            @SPROGRAMID,
            @SMENUTYPE,
            @SURL

         END
   
      SELECT * FROM #TEMP;
      SELECT @RS_CODE = 'S'
      SELECT @RS_MSG = '정상적으로 로드되었습니다.'

	  RETURN

END TRY                           

BEGIN CATCH

     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT @RS_CODE = 'ERR'                 
END CATCH

   CLOSE      CURSORA
   DEALLOCATE   CURSORA

END
GO
