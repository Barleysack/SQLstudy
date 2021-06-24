USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18MM_StockOut_M_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*---------------------------------------------------------------------
    프로시져명:  PP_StockPP_U1
    개     요 : 공정 창고 재고 등록 / 취소
    작성자 명 : 동상현 
    작성 일자 : 2021-03-04
    수정자 명 :
    수정 일자 :
    수정 사유 :  
    수정 내용 : 
----------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[18MM_StockOut_M_U1]                         
(                               
   @PlantCode      VARCHAR(10)  
  ,@LotNo          VARCHAR(30)
  ,@ItemCode       VARCHAR(30)
  ,@Qty            FLOAT
  ,@UnitCode       VARCHAR(5)
  ,@WhCode         VARCHAR(5)
  ,@StorageLocCode VARCHAR(10)
  ,@WorkerId       VARCHAR(10) 
  
  ,@Lang	       VARCHAR(10)='KO'
  ,@RS_CODE        VARCHAR(1)    OUTPUT
  ,@RS_MSG         VARCHAR(200)  OUTPUT

)                                  
AS                                 
BEGIN TRY 
	--공정재고 삭제
	DELETE 
	FROM TB_StockPP
	WHERE PLANTCODE = @PlantCode
	AND LotNo  = @LotNo

	--현재시간 정의
    DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
	    SET @LD_NOWTIME = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)
   
   DECLARE @INOUTSEQ_PP INT 

   -- 공정재고 순번 채번  
    SELECT @INOUTSEQ_PP = ISNULL(MAX(INOUTSEQ),0) +1 
      FROM TB_StockPPrec WITH(NOLOCK)
     WHERE PlantCode = @PlantCode
	   AND RECDATE = @LS_NOWDATE

	--생산출고 등록시
	BEGIN

		--공정 창고 재고 이력 생성
		INSERT INTO TB_StockPPrec (PLANTCODE,   INOUTSEQ,    RECDATE,       LOTNO,   ITEMCODE,      WHCODE, 
		                           STORAGELOCCODE,    INOUTFLAG,      INOUTQTY,  MAKEDATE,  MAKER)
		                   VALUES (@PLANTCODE,  @INOUTSEQ_PP, @LS_NOWDATE,  @LotNo,  @ItemCode,    @WhCode,     
						           @StorageLocCode,   'OUT',      @Qty,    @LD_NOWTIME,      @WorkerId)
 



		--공정 창고 재고 등록
		INSERT INTO TB_STOCKMM (PLANTCODE		, MATLOTNO	    , WHCODE  	    , ITEMCODE
							   ,STOCKQTY		, UNITCODE      , MAKER		    , MAKEDATE )
						VALUES (@PlantCode      , @LotNo        , @WhCode       , @ItemCode   
								,@Qty			, @UnitCode     , @WorkerId     , @LD_NOWTIME)	     

		--공정창고 입고이력 추가 
		-- 일자 별 입고 이력 SEQ 채번 
		DECLARE @INOUTSEQ INT 

		SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
		  FROM TB_StockMMrec WITH(NOLOCK)
		 WHERE PLANTCODE = @PlantCode
		   AND INOUTCODE   = @LS_NOWDATE

		INSERT INTO TB_StockMMrec
		(
			  PLANTCODE		  , MATLOTNO      , INOUTCODE   , INOUTQTY    , INOUTDATE   ,INOUTWORKER,
			  INOUTSEQ     	  , WHCODE        , INOUTFLAG   , MAKER       , MAKEDATE    
		)
		VALUES
		(
			@PlantCode        ,@LotNo         , '25'        , @QTY     , @LS_NOWDATE   ,@WorkerId    
			, @INOUTSEQ      , @WhCode	      , 'IN'        , @WorkerId, @LD_NOWTIME	
		)	
		
	END
	 
	SELECT @RS_CODE = 'S'
END TRY                           

BEGIN CATCH

     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT  @RS_CODE = 'E'                 
END CATCH    





















GO
