USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19WM_ProdinStock_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-16
-- Description:	제품 창고 
-- =============================================
CREATE PROCEDURE [dbo].[19WM_ProdinStock_U1]
  @PLANTCODE    VARCHAR(10),     -- 공장번호
  @LOTNO        VARCHAR(30), 	 -- LOT 번호
  @ITEMCODE 	VARCHAR(30), 	 -- 품목코드
  @INOUTQTY     FLOAT,           -- 수량
  @UNITCODE     VARCHAR(5), 	 -- 단위
  @MAKER        VARCHAR(10), 	 -- 담당자
 
  @LANG      VARCHAR(10) ='KO',
  @RS_CODE   VARCHAR(1) OUTPUT,
  @RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN
	-- 현재시간 정의
    DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
	    SET @LD_NOWTIME = GETDATE() -- 
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)
	
	-- VALIDATION CHECK
	-- 현재 재고가 존재하는지
	IF (SELECT COUNT(*)
	  FROM TB_StockPP WITH (NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO     = @LOTNO) =0
	   BEGIN
			SET @RS_CODE = 'E'
			SET @RS_MSG = '공정창고에 재고가 없습니다. :'+ @LOTNO
			RETURN;
	   END

	-- 공정창고에서 출고 이력 내역 등록
	DECLARE @LI_SEQ INT
	 SELECT @LI_SEQ = ISNULL(MAX(INOUTSEQ),0)+1
	   FROM TB_StockPPrec WITH(NOLOCK)
	  WHERE PLANTCODE = @PLANTCODE
	    AND RECDATE   = @LS_NOWDATE

	INSERT INTO TB_StockPPrec
	(PLANTCODE, INOUTSEQ, RECDATE, LOTNO, ITEMCODE, WHCODE, INOUTFLAG
	, INOUTCODE, INOUTQTY, UNITCODE,MAKEDATE, MAKER)
	VALUES
	(@PLANTCODE, @LI_SEQ, @LS_NOWDATE, @LOTNO, @ITEMCODE, 'WH008', 'OUT'
	, '50', @INOUTQTY, @UNITCODE,@LS_NOWDATE, @MAKER)

	-- 공정창고에서 재고 삭제
	DELETE TB_StockPP 
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO     = @LOTNO

	-- 제품창고로 재고 등록
	INSERT INTO TB_StockWM 
	(PLANTCODE, LOTNO, ITEMCODE, WHCODE,  STOCKQTY,	MAKEDATE, MAKER)
	VALUES
	(@PLANTCODE, @LOTNO, @ITEMCODE, 'WH008', @INOUTQTY,@LS_NOWDATE, @MAKER)

	-- 제품창고 입고 이력 내역 등록
	SELECT @LI_SEQ = ISNULL(MAX(INOUTSEQ),0)+1
      FROM TB_StockWMrec WITH(NOLOCK)
     WHERE PLANTCODE = @PLANTCODE
       AND RECDATE   = @LS_NOWDATE

	INSERT INTO TB_StockWMrec
	(PLANTCODE, INOUTSEQ, RECDATE, LOTNO, ITEMCODE, WHCODE, INOUTFLAG
	, INOUTCODE, INOUTQTY, UNITCODE,MAKEDATE, MAKER)
	VALUES
	(@PLANTCODE, @LI_SEQ, @LS_NOWDATE, @LOTNO, @ITEMCODE, 'WH008', 'IN'
	, '50', @INOUTQTY, @UNITCODE,@LS_NOWDATE, @MAKER)

	SET @RS_CODE = 'S'

END
SELECT * FROM TB_StockWM
SELECT * FROM TB_StockWMrec
GO
