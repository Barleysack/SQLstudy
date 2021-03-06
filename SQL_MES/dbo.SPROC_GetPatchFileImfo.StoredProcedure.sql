USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_GetPatchFileImfo]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
   패치 파일 읽어 오기
 *---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[SPROC_GetPatchFileImfo]
(
      @SystemID         VARCHAR(50)
    , @VER              VARCHAR(20)
    , @ClientID         VARCHAR(10)
    , @Lang             VARCHAR(10)='KO'
    , @RS_CODE          VARCHAR(1)    OUTPUT
    , @RS_MSG           VARCHAR(200)  OUTPUT 
)
AS
BEGIN
	BEGIN TRY
	    SELECT A.SystemID  AS SystemID
              ,A.FileID      AS FileID
              ,A.FILEVER     AS VER
              ,A.JobID       AS JobID
              ,A.SPath       AS SPath
              ,A.CPath       AS CPath
              ,A.PRocGB      AS ProcGB
              ,A.FileSize    AS FileSize
              ,A.FileImage   AS FileImage
          FROM SysPatchFile A 
         WHERE A.SystemID =  @SystemID
           AND  EXISTS ( SELECT FILEID 
                         FROM ( SELECT A.SystemID     AS SystemID
                                      ,A.FileID       AS FileID
                                      ,A.CPath        AS CPath
                                 	  ,max(A.FILEVER ) AS VER
                                 FROM SysPatchFile A 
                                WHERE A.SystemID =  @SystemID
                                group by  A.SystemID,A.FileID, A.CPath ) X
                        WHERE A.SystemID = X.SystemID
                          and A.FileID   = X.FileID
                          and A.CPath    = X.CPath
                          and A.FILEVER      = X.VER)
         ORDER BY A.VER, A.JobID;
		 
        SELECT @RS_CODE = 'S'

	END TRY
	BEGIN CATCH                       
        SELECT  @RS_MSG = ERROR_MESSAGE()                               
        SELECT  @RS_CODE = 'E'                                           
        PRINT   @RS_MSG    
	END CATCH
END



GO
