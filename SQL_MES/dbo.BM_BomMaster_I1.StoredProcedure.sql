USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_BomMaster_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BM_BomMaster_I1]                         
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
BEGIN TRY     
    DECLARE @CHK INT = 0;
	 
	SELECT @CHK = COUNT(ITEMCODE) FROM TB_BomMaster WITH(NOLOCK)
	 WHERE 1=1
	   AND ITEMCODE = @COMPONENT
	   AND COMPONENT = @ITEMCODE  
		       
    IF(@CHK > 0)
	BEGIN
	 SELECT @RS_MSG  = '생산품번으로 등록된 품번이 하위품번과 같은 품번의 하위품번으로 등록될 수 없습니다.'
     SELECT @RS_CODE = 'E'  
	 RETURN;
	 END

    INSERT INTO TB_BomMaster            
      ( 
           PLANTCODE
         , ITEMCODE
         , COMPONENT
         , BASEQTY
         , UNITCODE
         , COMPONENTQTY
         , COMPONENTUNIT
         , LGORT_IN
         , LGORT_OUT
         , USEFLAG
         , MAKEDATE
         , MAKER       
      )                            
       VALUES                          
        (                          
            @PLANTCODE
          , @ITEMCODE  
          , @COMPONENT  
          , @BASEQTY  
          , @UNITCODE
          , @COMPONENTQTY  
          , @COMPONENTUNIT  
          , @LGORT_IN  
          , @LGORT_OUT 
	      , @USEFLAG
          , GETDATE()    
          , @MAKER                         
        );    
		
		                                                     
    SELECT @RS_CODE = 'S'
END TRY                           

BEGIN CATCH
     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT @RS_CODE = 'E'                 
END CATCH
GO
