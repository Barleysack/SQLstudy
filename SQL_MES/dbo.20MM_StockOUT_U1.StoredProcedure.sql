USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[20MM_StockOUT_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		정유경
-- Create date: 2021-06-10
-- Description:	자재 생산 출고 내역 등록
-- =============================================
CREATE PROCEDURE [dbo].[20MM_StockOUT_U1]
	 @PLANTCODE       VARCHAR(10)          
	,@LOTNO           VARCHAR(30)          
	,@ITEMCODE        VARCHAR(30)
	,@QTY             FLOAT               
	,@UNITCODE        VARCHAR(5)
	,@WHCODE          VARCHAR(5)
	,@STORAGELOCCODE  VARCHAR(10)
	,@WORKERID        VARCHAR(10)
	,@EDITOR          VARCHAR(10)

	,@LANG            VARCHAR(10)  = 'KO'   -- 언어
	,@RS_CODE         VARCHAR(10)  OUTPUT   -- 성공 여부
	,@RS_MSG          VARCHAR(200) OUTPUT   -- 성공 관련 메세지
AS
BEGIN
	DECLARE @RECDATE VARCHAR(10) -- 현재 일자
		   ,@NOWDATE DATETIME   -- 현재 일시
	SET @RECDATE  = CONVERT(VARCHAR,GETDATE(),23)
	SET @NOWDATE = GETDATE()

	-- 1. 출고 이력 순번 채번
	DECLARE @INOUTSEQ INT
	SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
	FROM TB_StockMMrec WITH(NOLOCK)
	WHERE PLANTCODE = @PLANTCODE
	  AND INOUTDATE = @RECDATE

	-- 2. 출고 정보 업데이트
	UPDATE TB_StockMMrec
	   SET INOUTCODE        = '20'
		 , INOUTQTY         = @QTY
		 , INOUTDATE        = @RECDATE
		 , INOUTWORKER      = @WORKERID
		 , INOUTSEQ         = @INOUTSEQ
		 , WHCODE           = @WHCODE
		 , STORAGELOCCODE   = @STORAGELOCCODE
		 , INOUTFLAG        = 'OUT'
		 , MAKER            = @WORKERID
		 , MAKEDATE         = @NOWDATE
	 WHERE PLANTCODE        = @PLANTCODE
	   AND MATLOTNO         = @LOTNO

	-- 3. 공정 재고 생성
	INSERT INTO TB_STOCKPP(PLANTCODE, ITEMCODE, LOTNO,   WHCODE,  STORAGELOCCODE, STOCKQTY, UNITCODE,  MAKEDATE,   MAKER)   
					SELECT PLANTCODE, ITEMCODE, @LOTNO,  @WHCODE, @STORAGELOCCODE ,@QTY,  @UNITCODE,   @NOWDATE, @EDITOR 
					  FROM TB_StockMM WITH(NOLOCK)
					 WHERE PLANTCODE = @PLANTCODE
					   AND MATLOTNO  = @LOTNO

	-- 4. 공정 창고 입고 이력 추가
	-- 일자 별 입고 이력 SEQ 채번
	DECLARE @INOUTSEQ_PP INT
	 SELECT @INOUTSEQ_PP = ISNULL(MAX(INOUTSEQ),0) + 1
	   FROM TB_StockPPrec WITH(NOLOCK)
	  WHERE PLANTCODE = @PLANTCODE
	    AND RECDATE = @RECDATE

	 INSERT INTO TB_StockPPrec
			(PLANTCODE,  INOUTSEQ,     RECDATE,  LOTNO,   ITEMCODE,  WHCODE,   STORAGELOCCODE, INOUTFLAG, INOUTQTY,UNITCODE, INOUTCODE, MAKEDATE, MAKER)
	 VALUES (@PLANTCODE, @INOUTSEQ_PP, @RECDATE, @LOTNO,  @ITEMCODE, @WHCODE, @STORAGELOCCODE, 'N' ,      @QTY,    @UNITCODE, '20' ,    @NOWDATE, @EDITOR)

	    SET @RS_CODE = 'S'
END
GO
