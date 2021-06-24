USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[08MM_StockOUT_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김종우
-- Create date: 2021-06-10
-- Description:	자재 출고 관리 저장
-- =============================================
CREATE PROCEDURE [dbo].[08MM_StockOUT_U1]
	@PLANTCODE       VARCHAR(10)  -- 공장
   ,@LOTNO			 VARCHAR(30)  -- 
   ,@ITEMCODE   	 VARCHAR(30)  -- 
   ,@QTY   	         FLOAT        -- 
   ,@UNITCODE   	 VARCHAR(5)   -- 
   ,@WHCODE      	 VARCHAR(5)   -- 
   ,@STORAGELOCCODE	 VARCHAR(10)  -- 
   ,@WORKERID   	 VARCHAR(10)  -- 

   ,@LANG			 VARCHAR(10)  = 'KO'
   ,@RS_CODE		 VARCHAR(1)   OUTPUT
   ,@RS_MSG			 VARCHAR(200) OUTPUT
AS

BEGIN
	DECLARE	 @LS_NOWDATE   VARCHAR(10)
	        ,@LD_NOWTIME DATETIME
	    SET @LD_NOWTIME = GETDATE()
	    SET  @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)


   -- 1. 자재 출고 이력 생성 
   -- 출고 이력 순번 채번 
     DECLARE @INOUTSEQ INT 
      SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) +1 
        FROM TB_StockMMrec WITH(NOLOCK) 
       WHERE PlantCode = @PlantCode 
         AND INOUTDATE = @LS_NOWDATE

   -- 생산 출고 이력 등록 
      INSERT INTO TB_StockMMrec 
             (PLANTCODE,   MATLOTNO,  INOUTCODE,        INOUTQTY,    INOUTDATE,                     INOUTWORKER, 
              INOUTSEQ,    WHCODE,    STORAGELOCCODE,   INOUTFLAG,   MAKER,        MAKEDATE)
	  VALUES (@PLANTCODE,  @LOTNO,    '20',               @QTY,      CONVERT(VARCHAR,GETDATE(),23), @WORKERID,
			  @INOUTSEQ,   @WHCODE,   @STORAGELOCCODE,  'OUT' ,      @WORKERID,    GETDATE())
	

	-- 2. 자재 재고 삭제 
      DELETE TB_StockMM 
       WHERE PLANTCODE = @PLANTCODE 
         AND MATLOTNO  = @LOTNO 


	-- 3. 공정 재고 생성 
      INSERT INTO TB_STOCKPP 
              (PLANTCODE, LOTNO,     ITEMCODE , WHCODE,  STORAGELOCCODE     ,STOCKQTY , 
			   UNITCODE , MAKEDATE,                      MAKER )
	  VALUES (@PLANTCODE, @LOTNO,    @ITEMCODE, @WHCODE, @STORAGELOCCODE,  @QTY,
		      @UNITCODE,  CONVERT(VARCHAR,GETDATE(),23), @WORKERID)


	-- 4. 공정 창고 입고이력 추가 
    -- 일자 별 입고 이력 SEQ 채번 
     DECLARE @INOUTSEQ_PP INT 
      SELECT @INOUTSEQ_PP= ISNULL(MAX(INOUTSEQ),0) + 1 
        FROM TB_StockPPrec WITH(NOLOCK) 
       WHERE PLANTCODE = @PlantCode 
         AND RECDATE = GETDATE()
      INSERT INTO TB_StockPPrec 
              (PLANTCODE, INOUTSEQ,     RECDATE,     LOTNO,     ITEMCODE,  WHCODE,  STORAGELOCCODE, 
			   INOUTFLAG, INOUTQTY,     UNITCODE,    INOUTCODE, MAKEDATE , MAKER) 
	  VALUES (@PLANTCODE, @INOUTSEQ_PP, CONVERT(VARCHAR,GETDATE(),23),   @LOTNO,    @ITEMCODE, @WHCODE, @STORAGELOCCODE,
		      'IN',       @QTY ,      @UNITCODE,     '20',        GETDATE(), @WORKERID)
			 SET @RS_CODE = 'S'
END
GO
