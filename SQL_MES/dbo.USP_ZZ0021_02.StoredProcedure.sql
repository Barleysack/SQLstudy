USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_ZZ0021_02]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ZZ0021_02]    
/*******************************************************************************
1. 작성자         : 정해상
2. 최초 작성 날짜 : 2015년 09월 09일
3. 수정자         :
4. 최종 수정 날짜 :
5. 기능           : 파일버전 조회
6. 연관 테이블    : 
7. 연관 폼        : PDZ0000
********************************************************************************/                                 
 ( 
     @AS_SYSTEMID				VARCHAR(20)
    ,@AS_FILEID					VARCHAR(30)
    ,@LANG							VARCHAR(10)='KO'
   	,@RS_CODE						VARCHAR(1)    OUTPUT
    ,@RS_MSG						VARCHAR(200)  OUTPUT
               
 )                                                                 
AS                                                                 
BEGIN                                                              
    BEGIN TRY                                                                  
      	SELECT T1.SYSTEMID,
               T1.JOBID,
               T1.FILEID,
               T1.FILEVER,
               T1.SPATH,
               T1.CPATH,
               T1.PROCGB,
               T1.FILESIZE,
               T1.FILEIMAGE
          FROM TSY2200 T1 WITH(NOLOCK)
         WHERE T1.SYSTEMID = @AS_SYSTEMID
           AND T1.FILEID   = @AS_FILEID
         ORDER BY T1.JOBID;
                                                                                         
    SELECT @RS_CODE = 'S'                                                                
 END TRY                                                                                  
                                                                                         
BEGIN CATCH                                                                              
         SELECT  @RS_MSG = ERROR_MESSAGE()                            
         SELECT @RS_CODE = 'E'           
 END CATCH    
END

GO
