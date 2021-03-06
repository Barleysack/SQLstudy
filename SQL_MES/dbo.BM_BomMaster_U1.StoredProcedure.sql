USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_BomMaster_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BM_BomMaster_U1]                                      
(                                  
        @PLANTCODE              VARCHAR(10)     -- 공장코드
      , @ITEMCODE               VARCHAR(30)     -- 품목코드(모품번)
      , @COMPONENT              VARCHAR(30)     -- 하위구성부품(자품번)
      , @BASEQTY                FLOAT            -- 기준 수량
      , @UNITCODE               VARCHAR(10)     -- 단위
      , @COMPONENTQTY           FLOAT           -- 하위구성부품 수량
      , @COMPONENTUNIT          VARCHAR(10)     -- 하위구성부품 단위
      , @LGORT_IN               VARCHAR(10)      -- 입고위치
      , @LGORT_OUT              VARCHAR(10)      -- 출고위치
      , @USEFLAG                VARCHAR(1)       -- 사용여부
      , @MAKER                  VARCHAR(10)          

      ,@LANG                    VARCHAR(10)   ='KO'
      ,@RS_CODE                 VARCHAR(1)    OUTPUT
      ,@RS_MSG                  VARCHAR(200)  OUTPUT 
)                                  
AS                                 
BEGIN   
BEGIN TRY                           
    UPDATE TB_BomMaster    
    SET
        PLANTCODE     = @PLANTCODE         
      , ITEMCODE      = @ITEMCODE            
      , COMPONENT     = @COMPONENT        
      , BASEQTY       = @BASEQTY              
      , UNITCODE      = @UNITCODE            
      , COMPONENTQTY  = @COMPONENTQTY 
      , COMPONENTUNIT = @COMPONENTUNIT 
      , LGORT_IN      = @LGORT_IN             
      , LGORT_OUT     = @LGORT_OUT         
      , USEFLAG       = @USEFLAG              
      , EDITDATE      = GETDATE()
      , EDITOR        = @MAKER        
     WHERE  1=1
       AND  PLANTCODE     = @PLANTCODE         
       AND  ITEMCODE      = @ITEMCODE            
       AND  COMPONENT     = @COMPONENT   
       
    SELECT @RS_CODE = 'S'
    SELECT @RS_MSG     = '정상적으로 수정되었습니다.'    
    RETURN    
END TRY
                                
BEGIN CATCH
    SELECT @RS_CODE = 'E'
    SELECT @RS_MSG     = ERROR_MESSAGE()
END CATCH                                       
END                    

GO
