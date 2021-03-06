USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[00PP_StockPP_U1]    Script Date: 2021-06-22 오후 5:42:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*---------------------------------------------------------------------
    프로시져명: MM_PP_StockPP_U1
    개     요 : 생산출고 취소
    작성자 명 : 동상현 
    작성 일자 : 2021-03-04
    수정자 명 :
    수정 일자 :
    수정 사유 :  
    수정 내용 : 
----------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[00PP_StockPP_U1]                         
(                               
   @PLANTCODE      VARCHAR(10)  
  ,@LOTNO          VARCHAR(30)
  ,@ITEMCODE       VARCHAR(30)
  ,@QTY            FLOAT
  ,@UNITCODE       VARCHAR(5)
  ,@WORKERID       VARCHAR(10) 
  
  ,@LANG	       VARCHAR(10)='KO'
  ,@RS_CODE        VARCHAR(1)    OUTPUT
  ,@RS_MSG         VARCHAR(200)  OUTPUT

)                                  
AS                                 
BEGIN TRY    


	--현재시간 정의
    DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
	    SET @LD_NOWTIME = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)
   

   	--공정재고 삭제
	DELETE TB_STOCKPP 
	 WHERE PLANTCODE = @PLANTCODE	
	   AND LOTNO     = @LOTNO


	DECLARE @INOUTSEQ INT
	--공정창고 입고이력 추가 
	-- 일자 별 입고 이력 SEQ 채번 
	SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
	  FROM TB_StockPPrec WITH(NOLOCK)
	 WHERE PLANTCODE = @PlantCode
	   AND RECDATE   = @LS_NOWDATE

	INSERT INTO TB_StockPPrec
	(
		  PLANTCODE		  , INOUTSEQ      , RECDATE     , LOTNO  	    , ITEMCODE	, WHCODE
		, INOUTFLAG	      , INOUTQTY      , UNITCODE    , INOUTCODE 
		, MAKEDATE        , MAKER
	)
	VALUES
	(
		@PlantCode        , @INOUTSEQ     , @LS_NOWDATE   , @LotNo   ,  @ItemCode   , 'WH003'	    
	  , 'OUT'             , @Qty	      , @UnitCode,  '25' 
	  , @LD_NOWTIME	      , @WorkerId )


   --생산 입고 이력 순번 채번  
    SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) +1 
      FROM TB_StockMMrec WITH(NOLOCK)
     WHERE PlantCode = @PlantCode
	   AND INOUTDATE = @LS_NOWDATE

		-- 자재 입고 이력 생성
		INSERT INTO TB_StockMMrec (PLANTCODE,   MATLOTNO,    INOUTCODE,       INOUTQTY,   INOUTDATE,      INOUTWORKER, 
		                           INOUTSEQ,    WHCODE,      INOUTFLAG,  MAKER,          MAKEDATE)
		                   VALUES (@PLANTCODE,  @LotNo,      '25',            @Qty,       @LS_NOWDATE,    @WorkerId,     
						           @INOUTSEQ,   'WH001',     'IN',      @WorkerId,      @LD_NOWTIME)
 

	--자재재고 등록
	INSERT INTO TB_StockMM (PLANTCODE,   MATLOTNO,   WHCODE,    ITEMCODE,   STOCKQTY,   MAKER,      MAKEDATE)
                     VALUES(@PLANTCODE,  @LOTNO,     'WH001',   @ITEMCODE,  @QTY,       @WorkerId,  @LD_NOWTIME)

		
	SELECT @RS_CODE = 'S'
END TRY                           

BEGIN CATCH

     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT @RS_CODE = 'E'                 
END CATCH    





















GO
