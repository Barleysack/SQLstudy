USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_SY_ProgramVersion_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_SY_ProgramVersion_S1]    
/*******************************************************************************
파일버전 조회
********************************************************************************/                                 
 ( 
     @SYSTEMID						VARCHAR(10)
    ,@LANG							VARCHAR(10)='KO'
	,@RS_CODE						VARCHAR(1)    OUTPUT
    ,@RS_MSG						VARCHAR(200)  OUTPUT
               
 )                                                                 
AS                                                                 
BEGIN                                                              
    BEGIN TRY                                                                  
 	SELECT A.SYSTEMID
              ,A.REGUSERID
              ,A.DESCRIPT
              ,ISNULL(B.RELCODE2, 'Y') AS FILETYPE
              ,A.MAKER
              ,A.MAKEDATE
              ,A.EDITOR
              ,A.EDITDATE
          FROM SysSYstemList A WITH(NOLOCK)
          LEFT OUTER JOIN TB_Standard  B WITH(NOLOCK) 
					   ON A.SYSTEMID  = B.MINORCODE 
					  AND B.MAJORCODE = 'SYSTEMID'
         WHERE SYSTEMID LIKE @SYSTEMID + '%'
         ORDER BY A.SYSTEMID ASC;
                                                                                         
    SELECT @RS_CODE = 'S'                                                                
 END TRY                                                                                  
                                                                                         
BEGIN CATCH                                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                            
         SELECT @RS_CODE = 'E'           
 END CATCH    
END
GO
