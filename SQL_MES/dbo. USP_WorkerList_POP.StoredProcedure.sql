USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[ USP_WorkerList_POP]    Script Date: 2021-06-22 오후 5:42:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ USP_WorkerList_POP]    
(    
      @PlantCode          VARCHAR(10)      -- 공장(사업부)
     ,@OPCode             VARCHAR(10)      -- 공정코드
     ,@LineCode           VARCHAR(10)      -- 라인코드
     ,@WorkCenterCode     VARCHAR(10)      -- 작업장코드
     ,@WorkerID           VARCHAR(10)      -- 작업자 ID
     ,@WorkerName         VARCHAR(30)      -- 작업자명
     ,@UseFlag            VARCHAR(10)      -- 사용여부
     ,@Lang      VARCHAR(10)='KO'
     ,@RS_CODE    VARCHAR(10) OUTPUT
	 ,@RS_MSG     VARCHAR(30) OUTPUT 
)    
AS    
BEGIN TRY
     SELECT  PlantCode                                AS PlantCode      		-- 공장코드  
            ,dbo.FN_CodeName('PlantCode',PlantCode ,@Lang)  AS PlantCodeNm        -- 공장명
            ,''                    AS OPCode         		-- 공정코드
            ,'' AS LineCode -- dbo.FN_LineName(LineCode,@Lang)                AS LineCode       		-- 라인     
            ,''    AS WorkCenterCode     -- 작업장코드
            ,WorkerID                                 AS WorkerID           -- 작업자 ID
            ,WorkerName                               AS WorkerName         -- 작업자명
     FROM TB_WorkerList   
    WHERE  ISNULL(PlantCode,'')        LIKE @PlantCode        + '%'              -- 공장(사업부)
      AND  ISNULL(OPCode,'')           LIKE @OPCode           + '%'              -- 공정코드
      --AND  ISNULL(LineCode,'')         LIKE @LineCode         + '%'              -- 라인코드
      AND  ISNULL(WorkCenterCode,'')   LIKE @WorkCenterCode   + '%'              -- 작업장코드
      AND  ISNULL(UseFlag,'')          LIKE @UseFlag          + '%' 
      AND ISNULL(WORKERID, '') LIKE '%' + @WorkerID + '%'
      AND ISNULL(WORKERNAME, '') LIKE '%' + @WorkerName + '%'  
    ORDER BY PlantCode, OPcode, LineCode, WorkCenterCode, WorkerID    

     
SELECT @RS_CODE = 'S' 
 
END TRY

BEGIN CATCH
     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT @RS_CODE = 'E'
END CATCH


GO
