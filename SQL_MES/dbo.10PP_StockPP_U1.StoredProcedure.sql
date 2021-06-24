USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10PP_StockPP_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		마상우
-- Create date: 2021-06-10
-- Description:	생산 계획 편성 
-- =============================================
CREATE PROCEDURE [dbo].[10PP_StockPP_U1] 
	 @PLANTCODE			 VARCHAR(10) -- 공장   
	,@LOTNO				 VARCHAR(30) -- LOTNO
	,@ITEMCODE			 VARCHAR(30) -- 품목
	,@QTY				 FLOAT		 -- 수량
	,@UNITCODE			 VARCHAR(5)  -- 단위
	,@WORKERID			 VARCHAR(10) -- MAKER
	
	,@LANG				 VARCHAR(5)    = 'KO'
	,@RS_CODE			 VARCHAR(1)   OUTPUT
	,@RS_MSG			 VARCHAR(200) OUTPUT
AS
BEGIN
    DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
	    SET @LD_NOWTIME = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)

	-- 1. 자체 출고 이력생성
	-- 출고 이력 순번 채번
	DECLARE @INOUTSEQ_PP INT
		
	SELECT @INOUTSEQ_PP = ISNULL(MAX(@INOUTSEQ_PP),0) + 1 
	  FROM TB_StockPPrec WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND RECDATE = @LS_NOWDATE

	-- 생산 출고 이력 등록
	INSERT TB_StockPPrec(PLANTCODE, INOUTSEQ ,     RECDATE,     LOTNO,     ITEMCODE,  WHCODE,  STORAGELOCCODE, INOUTFLAG,   INOUTQTY,  UNITCODE,  INOUTCODE,   MAKEDATE, MAKER)
				  VALUES(@PLANTCODE, @INOUTSEQ_PP, @LS_NOWDATE, @LOTNO,  @ITEMCODE, 'WH003' ,      ''        ,   'OUT'    ,	@QTY ,     @UNITCODE ,'25'       , GETDATE(),   @WORKERID)

	-- 2. 자재 재고 삭제
	DELETE TB_StockPP
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO  = @LOTNO

	-- 3. 공정 재고 생성
	INSERT INTO TB_StockMM(PLANTCODE, MATLOTNO,   ITEMCODE, WHCODE, STOCKQTY, UNITCODE, MAKEDATE, MAKER)
			        VALUES(@PLANTCODE, @LOTNO, @ITEMCODE, 'WH001',   @QTY,   @UNITCODE, GETDATE(), @WORKERID)


	-- 4. 공정 창고 입고이력 추가
	-- 일자 별 입고 이력 SEQ 채번
	DECLARE @INOUTSEQ INT
	 SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
	   FROM TB_StockMMrec WITH(NOLOCK)
	  WHERE PLANTCODE = @PLANTCODE
	    AND INOUTDATE = GETDATE()
	
	--
	INSERT INTO TB_StockMMrec (PLANTCODE, MATLOTNO, INOUTCODE, INOUTQTY, INOUTDATE,  INOUTWORKER,  INOUTSEQ,   WHCODE,  INOUTFLAG, MAKEDATE, MAKER)
					   VALUES (@PLANTCODE, @LOTNO, '20',       @QTY,     GETDATE( ), @WORKERID,   @INOUTSEQ,  'WH001',  'IN',      GETDATE(), @WORKERID) 


	SET @RS_CODE = 'S'
END
GO
