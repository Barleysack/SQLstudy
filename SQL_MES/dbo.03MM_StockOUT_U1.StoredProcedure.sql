USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03MM_StockOUT_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보민
-- Create date: 2021-06-09
-- Description:	생산 계획 편성 
-- =============================================
CREATE PROCEDURE [dbo].[03MM_StockOUT_U1] 
	@PLANTCODE			 VARCHAR(10) -- 공장   
	,@LotNo				 VARCHAR(30) -- LOTNO
	,@ItemCode			 VARCHAR(30) -- 품목
	,@Qty				 FLOAT       -- 수량
	,@UnitCode			 VARCHAR(5)  -- 단위
	,@WhCode			 VARCHAR(5)  -- 창고
	,@StorageLocCode	 VARCHAR(10) --저장코드
	,@WorkerId			 VARCHAR(10) -- 작업자
	
	,@LANG				 VARCHAR(5)    = 'KO'
	,@RS_CODE			 VARCHAR(1)   OUTPUT
	,@RS_MSG			 VARCHAR(200) OUTPUT
AS
BEGIN
	-- 1. 자체 출고 이력생성
	-- 출고 이력 순번 채번
	DECLARE @INOUTSEQ INT
		
	SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1 
	  FROM TB_StockMMrec WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND INOUTDATE = CONVERT(VARCHAR,GETDATE(),23)

	--생산 출고 이력 등록
	INSERT TB_StockMMrec (PLANTCODE, MATLOTNO, INOUTCODE, INOUTQTY, INOUTDATE, INOUTWORKER, INOUTSEQ, WHCODE, STORAGELOCCODE, INOUTFLAG, MAKER, MAKEDATE)
				  VALUES (@PLANTCODE, @LotNo,   '20'    , @Qty    , CONVERT(VARCHAR,GETDATE(),23), @WorkerId,	@INOUTSEQ, @WhCode ,@StorageLocCode, 'OUT', @WorkerId, GETDATE())

	--2. 자재 재고 삭제
	DELETE TB_StockMM
	 WHERE PLANTCODE = @PLANTCODE
	   AND MATLOTNO  = @LotNo
	   AND ITEMCODE  = @ItemCode 

	--3. 공정 재고 생성
	INSERT INTO TB_STOCKPP (PLANTCODE, LOTNO, ITEMCODE, WHCODE, STORAGELOCCODE, STOCKQTY, UNITCODE, MAKEDATE, MAKER)
			   VALUES (@PLANTCODE, @LotNo, @ItemCode, @WhCode, @StorageLocCode, @Qty, @UnitCode, GETDATE(), @WorkerId)


	--4. 공정 창고 입고이력 추가
	--일자 별 입고 이력 SEQ 채번
	DECLARE @INOUTSEQ_PP INT
	SELECT @INOUTSEQ_PP = ISNULL(MAX(INOUTSEQ),0) + 1
	  FROM TB_StockPPrec WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND RECDATE = CONVERT(VARCHAR,GETDATE(),23)
	
	--
	INSERT INTO TB_StockPPrec (PLANTCODE, INOUTSEQ, RECDATE, LOTNO, ITEMCODE, WHCODE, STORAGELOCCODE, INOUTFLAG, INOUTQTY, UNITCODE, INOUTCODE, MAKEDATE, MAKER)
					   VALUES (@PLANTCODE, @INOUTSEQ_PP, CONVERT(VARCHAR,GETDATE(),23), @LotNo, @ItemCode, @WhCode, @StorageLocCode, 'IN', @Qty, @UnitCode, '20', GETDATE(), @WorkerId) 


	  SET @RS_CODE = 'S'
END
GO
