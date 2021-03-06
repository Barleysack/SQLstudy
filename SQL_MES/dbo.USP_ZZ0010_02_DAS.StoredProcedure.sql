USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ0010_02_DAS]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ZZ0010_02_DAS] 
(
     @SYSTEMID         VARCHAR
    ,@PROGRAMID        VARCHAR
    ,@CONTROLID        VARCHAR
    ,@COLUMNID         VARCHAR
    ,@CONTROLSEQ       VARCHAR
    ,@CONTROLTYPE      VARCHAR
    ,@COLUMNSEQ        INTEGER
    ,@FORMAT           VARCHAR
    ,@EDITMASK         VARCHAR
    ,@CONTROLWIDTH     INTEGER
    ,@HORALIGNTYPE     VARCHAR
    ,@VERALIGNTYPE     VARCHAR
    ,@SORTTYPE         VARCHAR
    ,@UID              VARCHAR
    ,@LANG             VARCHAR
    ,@UIDNAME          VARCHAR
    ,@HIDDEN           INTEGER
    ,@MAKER            VARCHAR
    ,@EDITOR           VARCHAR
    ,@RS_CODE          VARCHAR     OUTPUT   -- RETURN CODE
    ,@RS_MSG           VARCHAR     OUTPUT   -- RETURN MESSAGE
)
AS
 --   ERROR_EXCEPTION                EXCEPTION;      -- USER-DEFINED EXCEPTION(사용자 예외처리)
   DECLARE @LS_CNT        INTEGER
   DECLARE @LS_CNT_1      INTEGER
   DECLARE @LS_OLDUIDNAME VARCHAR(200)
   DECLARE @LS_OLDUID     VARCHAR(20)
BEGIN 
BEGIN TRY
    IF SUBSTRING(@CONTROLID, LEN(@CONTROLID) - 1, 2) = '_X' 
    BEGIN
        SELECT @RS_CODE = 'S';
        SELECT @RS_MSG  = 'NO EDIT CONTROL';
        RETURN
    END; --IF;
   
   
    SELECT  @LS_CNT = COUNT(*) 
      FROM TSY0800
     WHERE SYSTEMID  = @SYSTEMID
       AND PROGRAMID = @PROGRAMID
       AND CONTROLID = @CONTROLID
       AND COLUMNID  = @COLUMNID
       AND UIDSYS    = 'DID%'

    IF @LS_CNT > 0
    BEGIN
       SELECT @LS_CNT  =COUNT(UIDSYS)
         FROM TSY0800
        WHERE SYSTEMID    = @SYSTEMID
          AND UIDSYS      = 'DID%'

       DELETE FROM TSY0800
             WHERE SYSTEMID  = @SYSTEMID
               AND PROGRAMID = @PROGRAMID
               AND CONTROLID = @CONTROLID
               AND COLUMNID  = @COLUMNID
    END --IF

    SELECT @LS_CNT = COUNT(*)
      FROM TBM0000
     WHERE MAJORCODE = 'CAPTION'
       AND CODENAME  = @CONTROLTYPE
       AND MINORCODE <> '$'

    IF @LS_CNT > 0
    BEGIN
        SELECT @LS_CNT_1 = COUNT(*)
          FROM TSY1200
         WHERE UIDNAME     = @UIDNAME
           AND LANG        = @LANG
           AND UIDTYPE     = 'D_UID'

        IF @LS_CNT_1 = 0
        BEGIN
          SELECT @LS_OLDUID = 'DID' + SUBSTRING(STR(ISNULL(SUBSTRING(MAX(UIDSYS), 4, 17), 0) + 100000000000000001), 2, 17)
           --  INTO @LS_OLDUID
             FROM TSY1200
            WHERE UIDSYS LIKE 'DID%'

           INSERT INTO TSY1200
                 (
                 SYSTEMID,  
                 UIDSYS, 
                 LANG,  
                 UIDNAME, 
                 UIDTYPE, 
                 MAKEDATE,  
                 MAKER,    
                 EDITDATE,  
                 EDITOR
                 )
                 
           VALUES(
           @SYSTEMID,
           @LS_OLDUID,
           @LANG, 
           @UIDNAME, 
           'D_UID', 
           GETDATE(), 
           'SYSTEM', 
           GETDATE(), 
           'SYSTEM'
           );
          END
        ELSE IF @LS_CNT_1 > 0
        BEGIN
           -- SELECT UIDNAME, UIDSYS =  @LS_OLDUIDNAME, @LS_OLDUID  --INTO @LS_OLDUIDNAME, @LS_OLDUID
            SELECT TOP 1 @LS_OLDUIDNAME = UIDNAME, @LS_OLDUID = UIDSYS  --INTO @LS_OLDUIDNAME, @LS_OLDUID
              FROM TSY1200
             WHERE UIDNAME = @UIDNAME
               AND LANG    = @LANG
               AND UIDTYPE = 'D_UID'
               --AND ROW_NUMBER()  = 1
        END; --IF;
    END
    ELSE
    BEGIN
        SELECT @LS_OLDUID = '*';

    END --IF

    INSERT INTO TSY0800
          (
          SYSTEMID,    
          PROGRAMID,    
          CONTROLID,    
          COLUMNID,    
          CONTROLSEQ,    
          CONTROLTYPE,    
          UIDSYS,     
          COLUMNSEQ,  
          SORTTYPE,  
          FORMAT,  
          EDITMASK,  
          CONTROLWIDTH,  
          VERALIGNTYPE,  
          HORALIGNTYPE,  
 HIDDEN,  
          MAKER,  
          MAKEDATE,  
          EDITOR,  
          EDITDATE
          )
    VALUES(
    @SYSTEMID, 
    @PROGRAMID, 
    @CONTROLID, 
    @COLUMNID, 
    @CONTROLSEQ, 
    @CONTROLTYPE, 
    @LS_OLDUID, 
    @COLUMNSEQ, 
    @SORTTYPE, 
    @FORMAT, 
    @EDITMASK, 
    @CONTROLWIDTH, 
    @VERALIGNTYPE, 
    @HORALIGNTYPE, 
    @HIDDEN, 
    @MAKER, 
    GETDATE(), 
    @EDITOR, 
    GETDATE()
    )

   -- END 
    -- @RS_CODE := 'S'
    SELECT @RS_CODE = 'S'                                                
    END TRY
	BEGIN CATCH                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                               
         SELECT  @RS_CODE = 'E'                                           
         PRINT   @RS_MSG     
	END CATCH
    RETURN
END
GO
