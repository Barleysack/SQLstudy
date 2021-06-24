USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[20MM_StockOUT_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		정유경
-- Create date: 2021-06-10
-- Description:	자재 출고 이력 생성
-- =============================================
CREATE PROCEDURE [dbo].[20MM_StockOUT_I1]
	  @PLANTCODE       VARCHAR(10)   
     ,@LOTNO           VARCHAR(30)    
	 ,@ITEMCODE        VARCHAR(30)
	 ,@QTY             FLOAT          
	 ,@UNITCODE        VARCHAR(5)    
	 ,@WHCODE          VARCHAR(5)    
	 ,@STORAGELOCCODE  VARCHAR(10)
	 ,@WORKERID        VARCHAR(10)    

     ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT
AS
BEGIN TRY

	DECLARE @LS_NOWDATE VARCHAR(10) -- 현재 일자
		   ,@LD_NOWTIME DATETIME   -- 현재 일시
	SET @LS_NOWDATE  = CONVERT(VARCHAR,GETDATE(),23)
	SET @LD_NOWTIME = GETDATE()


	-- 자재 출고 이력 생성 (출고 이력 순번 채번)
	-- 1.생산 출고 이력 순번 채번
	DECLARE @INOUTSEQ INT
	SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
	FROM TB_StockMMrec WITH(NOLOCK)
	WHERE PLANTCODE = @PLANTCODE
	  AND INOUTDATE = @LS_NOWDATE
	
	-- 생산 출고 등록시
	BEGIN

	-- 자재 출고 이력 생성
	INSERT INTO TB_StockMMrec
	(PLANTCODE, MATLOTNO, INOUTCODE, INOUTQTY, INOUTDATE, INOUTWORKER, INOUTSEQ, WHCODE, STORAGELOCCODE, INOUTFLAG, MAKER, MAKEDATE)
	VALUES
	(@PLANTCODE, @LOTNO,    '20',      @QTY,   @LS_NOWDATE, @WORKERID, @INOUTSEQ, @WHCODE, @STORAGELOCCODE, 'OUT',  @WORKERID, @LD_NOWTIME)

	-- 자재 재고 삭제
	DELETE
	  FROM TB_StockMM
	 WHERE PLANTCODE = @PLANTCODE
	   AND MATLOTNO  = @LOTNO
	   AND ITEMCODE  = @ITEMCODE

	--공정 재고 생성
	INSERT INTO TB_STOCKPP (PLANTCODE	, LOTNO	 , ITEMCODE  , WHCODE	, STORAGELOCCODE  ,STOCKQTY	, NOWQTY	, UNITCODE   , MAKEDATE		, MAKER )
					VALUES (@PlantCode  , @LotNo , @ItemCode , @WhCode	, @StorageLocCode, @Qty		, @Qty      , @UnitCode , @LD_NOWTIME   , @WorkerId )	     

	--공정창고 입고이력 추가 
	-- 일자 별 입고 이력 SEQ 채번 
	SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
	  FROM TB_StockPPrec WITH(NOLOCK)
	 WHERE PLANTCODE = @PlantCode
	   AND RECDATE   = @LS_NOWDATE

	INSERT INTO TB_StockPPrec
		(PLANTCODE , INOUTSEQ   , RECDATE      ,LOTNO , ITEMCODE  , WHCODE,  STORAGELOCCODE  , INOUTFLAG, INOUTQTY  ,UNITCODE    , INOUTCODE , MAKEDATE  , MAKER)
	VALUES
		(@PlantCode, @INOUTSEQ  , @LS_NOWDATE  ,@LotNo, @ItemCode , @WhCode, @StorageLocCode , 'IN'     , @Qty	     ,@UnitCode , '20' ,       @LD_NOWTIME, @WorkerId)	
		
	END
	 
	SELECT @RS_CODE = 'S'
END TRY                           

BEGIN CATCH

     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT  @RS_CODE = 'E'                 
END CATCH 
GO
