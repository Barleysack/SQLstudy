USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02MM_StockOut_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-09
-- Description:	자재 생산 출고 저장
-- =============================================
CREATE PROCEDURE [dbo].[02MM_StockOut_U1]
     @PLANTCODE						 VARCHAR(10)   --공장 코드
	,@LOTNO								 VARCHAR(30)	  --LOT번호
    ,@ITEMCODE						 VARCHAR(20)    -- 품목코드
	,@QTY									 FLOAT					--수량
	,@UNITCODE							 VARCHAR(5)
	,@WHCODE							 VARCHAR(5)
	,@STORAGELOCCODE			 VARCHAR(10)
	,@WORKERID					     VARCHAR(10)

	,@LANG    VARCHAR(10) = 'KO'			-- 언어
	,@RS_CODE VARCHAR(10)  OUTPUT		-- 성공 여부
	,@RS_MSG  VARCHAR(200) OUTPUT	-- 성공 관련 메세지
AS
BEGIN
    DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
	    SET @LD_NOWTIME = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)

	--1. 자재 출고 이력 생성
		--출고 이력 순번 채번
	DECLARE @INOUTSEQ INT
	   SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ), 0) + 1
	    FROM TB_StockMMrec WITH(NOLOCK)
	   WHERE PLANTCODE = @PLANTCODE
	       AND INOUTDATE = @LS_NOWDATE

		--생산 출고 이력 등록
		INSERT INTO TB_StockMMrec (PLANTCODE,   MATLOTNO,    INOUTCODE,       INOUTQTY,   INOUTDATE,      INOUTWORKER, 
		                           INOUTSEQ,    WHCODE,      STORAGELOCCODE,  INOUTFLAG,  MAKER,          MAKEDATE)
		                   VALUES (@PLANTCODE,  @LotNo,      '20',            @Qty,       @LS_NOWDATE,    @WorkerId,     
						           @INOUTSEQ,   @WhCode,     @StorageLocCode, 'OUT',      @WorkerId,      @LD_NOWTIME)

	--INSERT TB_StockMMrec (PLANTCODE,      MATLOTNO, INOUTCODE, INOUTQTY, INOUTDATE,    INOUTWORKER, INOUTSEQ,       WHCODE,       STORAGELOCCODE,     INOUTFLAG,   MAKER,           MAKEDATE)
		--		 VALUES (@PLANTCODE,     @LOTNO,    '20',		@QTY,	 @LS_INOUTDATE, @WORKERID,   @INOUTSEQ,      @WHCODE,   @STORAGELOCCODE,     'OUT',            @WORKERID,  GETDATE())

	--2. 자재 재고 삭제
		 DELETE 
		   FROM TB_StockMM
		  WHERE PLANTCODE = @PlantCode
		    AND MatLotNo  = @LotNo
		    AND ItemCode  = @ItemCode
--	DELETE TB_StockMM
--	WHERE PLANTCODE = @PLANTCODE
--	    AND MATLOTNO  = @LOTNO

	--3. 공정 재고 생성
	--	INSERT INTO TB_STOCKPP (PLANTCODE		, LOTNO			, ITEMCODE  	, WHCODE		, STORAGELOCCODE
			--				   ,STOCKQTY		, NOWQTY		, UNITCODE      , MAKEDATE		, MAKER )
			--			VALUES (@PlantCode      , @LotNo        , @ItemCode     , @WhCode	    , @StorageLocCode
				--				,@Qty			, @Qty          , @UnitCode     , @LD_NOWTIME   , @WorkerId )	  
								
	INSERT INTO TB_STOCKPP (PLANTCODE, LOTNO, ITEMCODE, WHCODE, STORAGELOCCODE, STOCKQTY, UNITCODE, MAKEDATE, MAKER)
			   VALUES (@PLANTCODE, @LotNo, @ItemCode, @WhCode, @StorageLocCode, @Qty, @UnitCode, GETDATE(), @WorkerId)
	--INSERT TB_StockPP (PLANTCODE,      LOTNO,     ITEMCODE,		   WHCODE,    STORAGELOCCODE,	  STOCKQTY,		UNITCODE,	MAKEDATE,	    MAKER)
	 --                VALUES (@PLANTCODE, @LOTNO,	@ITEMCODE,	@WHCODE,	@STORAGELOCCODE,	@QTY,			  @UNITCODE,	GETDATE(),	 @WORKERID)

	--4. 공정 창고 입고이력 추가
		--일자 별 입고 이력 SEQ 채번
		SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
		  FROM TB_StockPPrec WITH(NOLOCK)
		 WHERE PLANTCODE = @PlantCode
		   AND RECDATE   = @LS_NOWDATE

		INSERT INTO TB_StockPPrec
		(
			  PLANTCODE		  , INOUTSEQ      , RECDATE   , LOTNO  	    , ITEMCODE	, WHCODE
			, STORAGELOCCODE  , INOUTFLAG	  , INOUTQTY  , UNITCODE    , INOUTCODE 
			, MAKEDATE        , MAKER
		)
		VALUES
		(
			@PlantCode        , @INOUTSEQ     , @LS_NOWDATE   , @LotNo    , @ItemCode   , @WhCode	    
		  , @StorageLocCode , 'IN'          , @Qty	      , @UnitCode , '20' 
		  , @LD_NOWTIME	  , @WorkerId
		)	

--	DECLARE @INOUTSEQ_PP INT
--	 SELECT @INOUTSEQ_PP = ISNULL(MAX(INOUTSEQ), 0) +1
--	   FROM TB_StockPPrec WITH(NOLOCK)
--	  WHERE PLANTCODE = @PLANTCODE
--	    AND RECDATE	  = GETDATE()
--	 INSERT INTO TB_StockPPrec  ( PLANTCODE,	   INOUTSEQ,		    RECDATE,		   LOTNO,	    ITEMCODE,	  WHCODE,	   STORAGELOCCODE,   INOUTFLAG,	   INOUTQTY,	  UNITCODE,	 INOUTCODE, MAKEDATE,	MAKER)
--						    VALUES(@PLANTCODE,	  @INOUTSEQ_PP,	        GETDATE(),	      @LOTNO,	   @ITEMCODE,    @WHCODE,	  @STORAGELOCCODE,	'IN',		  @QTY,          @UNITCODE,	 '20',		GETDATE(), @WORKERID)
    SET @RS_CODE = 'S'
END
GO
