USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[13MM_StockPP_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		원지윤
-- Create date: 2021.06.10
-- Description:	 자재 출고 이력
-- =============================================
CREATE PROCEDURE [dbo].[13MM_StockPP_U1] 
	 @PLANTCODE		 VARCHAR(10) -- 공장   
	,@LotNo			 VARCHAR(30) -- LOTNO
	,@ItemCode		 VARCHAR(30) -- 품목
	,@Qty			 FLOAT		 -- 수량
	,@UnitCode		 VARCHAR(5)  -- 단위
	,@WorkerId		 VARCHAR(10) -- MAKER
	
	,@LANG			 VARCHAR(5)    = 'KO'
	,@RS_CODE		 VARCHAR(1)   OUTPUT
	,@RS_MSG		 VARCHAR(200) OUTPUT
AS
BEGIN
    --1.공정 재고 삭제
	DECLARE @INOUTSEQ_PP INT
	DECLARE @WHCODE VARCHAR(10)
	DECLARE @StorageLocCode VARCHAR(30)

	SELECT @StorageLocCode = STORAGELOCCODE
		  ,@WHCODE = WHCODE
	 FROM TB_StockPP WITN(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO	 = @LotNo
	   AND ITEMCODE  = @ItemCode

	DELETE TB_StockPP
		WHERE PLANTCODE = @PLANTCODE
	      AND LOTNO     = @LotNo
    
	--현재시간 정의
    DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
	    SET @LD_NOWTIME = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)

	--2.공정 재고 출력 이력 생성
			
	SELECT @INOUTSEQ_PP = ISNULL(MAX(INOUTSEQ),0) + 1 
	  FROM TB_StockPPrec WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND RECDATE = @LS_NOWDATE

    --생산 출고 이력 등록
	INSERT INTO TB_StockPPrec (PLANTCODE, INOUTSEQ, RECDATE, LOTNO, ITEMCODE, WHCODE, STORAGELOCCODE, INOUTFLAG, INOUTQTY, UNITCODE, INOUTCODE, MAKEDATE, MAKER)
	                    VALUES (@PLANTCODE, @INOUTSEQ_PP, @LS_NOWDATE, @LotNo, @ItemCode, @WHCODE, @StorageLocCode, 'OUT', @Qty, @UnitCode, '25', GETDATE(), @WorkerId) 
    
    -- 3.자재 창고 재고 등록
	INSERT INTO TB_StockMM (PLANTCODE, MATLOTNO, WHCODE, ITEMCODE, STOCKQTY, UNITCODE, MAKER, MAKEDATE)
	                VALUES (@PLANTCODE, @LotNo, 'WH001', @ItemCode, @Qty, @UnitCode, @WorkerId, GETDATE())
	
	--4.자재 창고 입고이력 등록
	-- 출고 이력 순번 채번
	DECLARE @INOUTSEQ INT
	SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ), 0) +1
	            FROM TB_StockMMrec WITH(NOLOCK)
				WHERE PLANTCODE = @PLANTCODE
				AND INOUTDATE = @LS_NOWDATE

	-- 자재 입고 이력 등록
	INSERT TB_StockMMrec (PLANTCODE, MATLOTNO, INOUTCODE, INOUTQTY, INOUTDATE, INOUTWORKER, INOUTSEQ, WHCODE, INOUTFLAG, MAKER, MAKEDATE)
				  VALUES (@PLANTCODE, @LotNo, '25', @Qty, @LS_NOWDATE, @WorkerId, @INOUTSEQ, 'WH001', 'IN', @WorkerId, GETDATE())

	  SET @RS_CODE = 'S'
END
GO
