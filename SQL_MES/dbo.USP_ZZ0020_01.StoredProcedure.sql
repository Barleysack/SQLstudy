USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ0020_01]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
   PROEDURE ID    : USP_ZZ0020_01
   PROCEDURE NAME : 라이브업데이트정보 읽어 오기
   CREATE DATE    : 2012.08.08
   MADE BY        : SAMMI INFORMATION SYSTEM CO.,LTD
   DESCRIPTION    : 
 *---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[USP_ZZ0020_01]
(
      @SystemID         VARCHAR(20)
    , @VER              VARCHAR(20)
    , @ClientID         VARCHAR(10)
    , @Lang             VARCHAR(10)='KO'
    , @RS_CODE          VARCHAR(1)    OUTPUT
    , @RS_MSG           VARCHAR(200)  OUTPUT 
)
AS
BEGIN
	BEGIN TRY
	    SELECT A.SystemID    AS SystemID
            ,A.FileID      AS FileID
            ,A.FILEVER         AS VER
            ,A.JobID       AS JobID
            ,A.SPath       AS SPath
            ,A.CPath       AS CPath
            ,A.PRocGB      AS ProcGB
            ,A.FileSize    AS FileSize
            ,A.FileImage   AS FileImage
        FROM TSY2200 A 
       WHERE A.SystemID =  @SystemID
        -- AND A.FILEVER      >  @Ver
         --AND(ClientID = '*' OR ClientID = @ClientID)
		     AND  EXISTS ( SELECT FileID 
                         FROM ( SELECT A.SystemID     AS SystemID
                                      ,A.FileID       AS FileID
                                  		,A.CPath        AS CPath
                                 		 ,MAX(A.FILEVER ) AS VER
                                 FROM TSY2200 A 
                                WHERE A.SystemID =  @SystemID
                                  --AND A.FILEVER      >  @Ver
                                 --AND(ClientID = '*' OR ClientID = @ClientID)
                                GROUP BY  A.SystemID,A.FileID, A.CPath ) X
                        WHERE A.SystemID = X.SystemID
                          AND A.FileID   = X.FileID
                          AND A.CPath    = X.CPath
                          AND A.FILEVER      = X.VER)
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
