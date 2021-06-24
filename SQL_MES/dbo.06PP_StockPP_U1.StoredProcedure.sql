USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[06PP_StockPP_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김얼
-- Create date: 2021-06-10
-- Description:	공정 창고 재고 관리
-- =============================================
CREATE PROCEDURE [dbo].[06PP_StockPP_U1]
	   @PlantCode      VARCHAR(10)
	  ,@LotNo          VARCHAR(30)
	  ,@ItemCode       VARCHAR(30)
	  ,@Qty            FLOAT
	  ,@UnitCode       VARCHAR(5)
	  ,@WorkerId       VARCHAR(10)

	  ,@Lang	       VARCHAR(10)='KO'
	  ,@RS_CODE        VARCHAR(1)    OUTPUT
	  ,@RS_MSG         VARCHAR(200)  OUTPUT



AS
BEGIN TRY   
	--현재시간 정의
    DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
	    SET @LD_NOWTIME = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)

BEGIN
	-- 1. 공정 창고 삭제
		DELETE TB_StockPP
		 WHERE PLANTCODE = @PLANTCODE	
	       AND LOTNO     = @LOTNO

	-- 2. 공정 재고 출고 이력 생성
	DECLARE @INOUTSEQ INT 
	 SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) +1 
	   FROM TB_StockPPrec WITH(NOLOCK)
	  WHERE	PLANTCODE = @PlantCode
	    AND RECDATE = @LS_NOWDATE

		INSERT INTO TB_StockPPrec (PLANTCODE, INOUTSEQ,      RECDATE,      LOTNO, ITEMCODE,   WHCODE, STORAGELOCCODE, INOUTFLAG, INOUTQTY, UNITCODE, INOUTCODE, MAKEDATE, MAKER)
		     VALUES               (@PlantCode, @INOUTSEQ, @LS_NOWDATE, @LotNo, @ItemCode,    ''  ,        '' ,       ' OUT',   @Qty,    @UnitCode, '25' , @LD_NOWTIME, @WorkerId)
			 

	-- 3. 자재 창고 재고 등록
	INSERT TB_StockMM (PLANTCODE, MATLOTNO,WHCODE,ITEMCODE,STOCKQTY,UNITCODE,MAKER,MAKEDATE)
	 VALUES           (@PlantCode, @LotNo, 'WH001', @ItemCode, @Qty,@UnitCode,@WorkerId,@LD_NOWTIME)

	-- 4. 자재 창고 입고이력 등록
		--4.1 출고 이력 순번 채번
	SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) +1 
      FROM TB_StockMMrec WITH(NOLOCK)
     WHERE PlantCode = @PlantCode
	   AND INOUTDATE = @LS_NOWDATE

	    --4.2 자재 입고 이력 등록
		INSERT INTO TB_StockMMrec (PLANTCODE,   MATLOTNO,    INOUTCODE,       INOUTQTY,   INOUTDATE,      INOUTWORKER, 
		                           INOUTSEQ,    WHCODE,      INOUTFLAG,  MAKER,          MAKEDATE)
		                   VALUES (@PLANTCODE,  @LotNo,      '20',            @Qty,       @LS_NOWDATE,    @WorkerId,     
						           @INOUTSEQ,   'WH001',     'IN',      @WorkerId,      @LD_NOWTIME)
END
	SELECT @RS_CODE = 'S'
END TRY       
BEGIN CATCH

     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT  @RS_CODE = 'E'                 
END CATCH    
GO
