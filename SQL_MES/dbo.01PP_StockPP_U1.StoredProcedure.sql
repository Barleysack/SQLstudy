USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[01PP_StockPP_U1]    Script Date: 2021-06-22 오후 5:42:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강유정
-- Create date: 2021.6.9
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[01PP_StockPP_U1]

			 @PlantCode			VARCHAR(10)
			,@LotNo				VARCHAR(30)
			,@ItemCode			VARCHAR(30)
			,@QTY				FLOAT
			,@UnitCode			VARCHAR(5)
			,@WorkID			VARCHAR(10)

			,@LANG      VARCHAR(10)  = 'KO' -- 언어
			,@RS_CODE   VARCHAR(1)   OUTPUT
			,@RS_MSG	VARCHAR(200) OUTPUT
AS
BEGIN

   -- 1. 공정 재고 삭제 & 공장이름, 위치 받아오기
   DECLARE @INOUTSEQ_PP INT
   DECLARE @WHCODE VARCHAR(10)
   DECLARE @StorageLocCode VARCHAR(30)

   SELECT @StorageLocCode = STORAGELOCCODE
        ,@WHCODE = WHCODE
    FROM TB_StockPP WITN(NOLOCK)
    WHERE PLANTCODE = @PLANTCODE
      AND LOTNO    = @LotNo
      AND ITEMCODE  = @ItemCode


   DELETE TB_StockPP
    WHERE PLANTCODE = @PLANTCODE
      AND LOTNO    = @LotNo
      AND ITEMCODE  = @ItemCode

   -- 2. 공정 재고 출고 이력 생성
   
   SELECT @INOUTSEQ_PP = ISNULL(MAX(INOUTSEQ), 0) +1
     FROM TB_StockPPrec WITH(NOLOCK)
    WHERE PLANTCODE = @PLANTCODE
      AND RECDATE   = CONVERT(VARCHAR,GETDATE(),23)
    
    INSERT INTO TB_StockPPrec (PLANTCODE, INOUTSEQ, RECDATE, LOTNO, ITEMCODE, WHCODE, STORAGELOCCODE, INOUTFLAG, INOUTQTY, UNITCODE, INOUTCODE, MAKEDATE, MAKER)
                       VALUES (@PLANTCODE, @INOUTSEQ_PP, CONVERT(VARCHAR,GETDATE(),23), @LotNo, @ItemCode, @WHCODE, @StorageLocCode, 'OUT', @Qty, @UnitCode, '25', GETDATE(), @WorkID) 

    -- 3. 자재 창고 재고 등록
   INSERT INTO TB_StockMM (PLANTCODE, MATLOTNO, WHCODE, ITEMCODE, STOCKQTY, UNITCODE, MAKER, MAKEDATE)
                   VALUES (@PLANTCODE, @LotNo, 'WH001', @ItemCode, @Qty, @UnitCode, @WorkID, GETDATE())
   
   --4. 자재 창고 입고이력 등록
   -- 출고 이력 순번 채번
   DECLARE @INOUTSEQ INT
   SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ), 0) +1
               FROM TB_StockMMrec WITH(NOLOCK)
            WHERE PLANTCODE = @PLANTCODE
            AND INOUTDATE = CONVERT(VARCHAR,GETDATE(),23)

   -- 자재 입고 이력 등록
   INSERT TB_StockMMrec (PLANTCODE, MATLOTNO, INOUTCODE, INOUTQTY, INOUTDATE, INOUTWORKER, INOUTSEQ, WHCODE, INOUTFLAG, MAKER, MAKEDATE)
              VALUES (@PLANTCODE, @LotNo, '25', @Qty, CONVERT(VARCHAR,GETDATE(),23), @WorkID, @INOUTSEQ, 'WH001', 'IN', @WorkID, GETDATE())

     SET @RS_CODE = 'S'
END
GO
