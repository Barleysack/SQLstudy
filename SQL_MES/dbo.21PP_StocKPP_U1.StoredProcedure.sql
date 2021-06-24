USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[21PP_StocKPP_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*---------------------------------------------------------------------
    프로시져명: PP_StockOut_I1
    개     요 : 자재 생산 출고 관리
    작성자 명 : 최민준
	작성 일자 : 2021-03-04
    수정자 명 :
    수정 일자 :
    수정 사유 :  
    수정 내용 : 
----------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[21PP_StocKPP_U1]                         
(                               
   @PlantCode      VARCHAR(10)  
  ,@LotNo          VARCHAR(30)
  ,@ItemCode       VARCHAR(30)
  ,@Qty            FLOAT
  ,@UnitCode       VARCHAR(5)
  ,@WorkerId       VARCHAR(10) 
  
  ,@Lang	       VARCHAR(10)='KO'
  ,@RS_CODE        VARCHAR(1)    OUTPUT
  ,@RS_MSG         VARCHAR(200)  OUTPUT

)                                  
AS
BEGIN
BEGIN TRY    


	--현재시간 정의
    DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
	    SET @LD_NOWTIME = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)
   

   -- 공정 재고 삭제

   DELETE 
		   FROM TB_StockPP
		  WHERE PLANTCODE = @PlantCode
		    AND LOTNO     = @LotNo
		    AND ItemCode  = @ItemCode

   --공정 재고 출고 이력 생성  
   DECLARE @INOUTSEQ_PP INT
    SELECT @INOUTSEQ_PP = ISNULL(MAX(INOUTSEQ),0) +1 
      FROM TB_StockPPrec WITH(NOLOCK)
	 WHERE PlantCode = @PlantCode
	   AND RECDATE = @LS_NOWDATE

	--공정 재고 출고 등록
     INSERT INTO TB_StockPPREC  (PLANTCODE,         INOUTSEQ,       RECDATE,         LOTNO,          ITEMCODE,         WHCODE, 
		                         STORAGELOCCODE,    INOUTFLAG,      INOUTQTY,        UNITCODE,       INOUTCODE,        MAKEDATE,     MAKER)
		                 VALUES (@PLANTCODE,        @INOUTSEQ_PP,   @LS_NOWDATE,     @LotNo,         @ITEMCODE,        'WH003',     
						           NULL,            'OUT',          @QTY,            @UNITCODE,      '25',             @LD_NOWTIME,  @WORKERID)
 


	--자재 창고 재고 등록
		INSERT INTO TB_STOCKMM (PLANTCODE		, MATLOTNO	    , WHCODE  	    , ITEMCODE		, STOCKQTY
							   ,UNITCODE		, MAKER		    , MAKEDATE)
						VALUES (@PlantCode      , @LotNo        , 'WH001'       , @ItemCode	    , @Qty
							   ,@UnitCode	    , @WorkerId     , @LD_NOWTIME)	     

	--자재 창고 입고 이력 추가 
		-- 일자 별 입고 이력 SEQ 채번 
		DECLARE @INOUTSEQ INT
		SELECT  @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
		  FROM TB_StockMMrec WITH(NOLOCK)
		 WHERE PLANTCODE = @PlantCode
		   AND INOUTDATE = @LS_NOWDATE

	--자재 창고 입고 이력 등록
		INSERT INTO TB_StockMMrec
		(
			  PLANTCODE		  , MATLOTNO       , INOUTCODE   , INOUTQTY  	, INOUTDATE  	, INOUTWORKER
			, INOUTSEQ        , WHCODE	       , INOUTFLAG   , MAKER        , MAKEDATE 
		)
		VALUES
		(
			 @PLANTCODE       , @LotNo         , '25'         ,@QTY          ,@LD_NOWTIME 	, @WorkerId    
		    ,@INOUTSEQ        ,'WH001'         , 'IN'	          ,@WorkerId     ,@LD_NOWTIME  
		  
		)
		
SELECT @RS_CODE = 'S'

END TRY                           

BEGIN CATCH

     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT @RS_CODE = 'E'                 
END CATCH 
END















GO
