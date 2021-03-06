USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ0020_S1]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ZZ0020_S1]
(
      @SYSTEMID         VARCHAR(20)
    , @LANG      	    VARCHAR(10)='KO'
    , @RS_CODE          VARCHAR(1)    OUTPUT
    , @RS_MSG           VARCHAR(200)  OUTPUT 
)
AS
/*---------------------------------------------------------------------------------------------*
   PROEDURE ID    : USP_ZZ0020_S1
   PROCEDURE NAME : 라이브업데이트정보 읽어 오기
   ALTER DATE    : 2014.12.18
   MADE BY        : SAMMI INFORMATION SYSTEM CO.,LTD
   DESCRIPTION    : 
 *---------------------------------------------------------------------------------------------*/
BEGIN
	BEGIN TRY
	    SELECT A.SYSTEMID    AS SYSTEMID
              ,A.JOBID       AS JOBID
              ,A.FILEID      AS FILEID
              ,A.FILEVER     AS FILEVER
              ,A.SPATH       AS SPATH
              ,A.CPATH       AS CPATH
              ,A.PROCGB      AS PROCGB
              ,A.FILESIZE    AS FILESIZE
         FROM TSY2200 A 
        WHERE A.SYSTEMID =  @SYSTEMID
        ORDER BY A.JOBID;
		 
        SELECT @RS_CODE = 'S'

	END TRY
	BEGIN CATCH                       
        SELECT  @RS_MSG = ERROR_MESSAGE()                               
        SELECT  @RS_CODE = 'E'                                           
        PRINT   @RS_MSG    
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]라이브업데이트정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_ZZ0020_S1'
GO
