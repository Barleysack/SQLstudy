USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18MM_StockOUT_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-10
-- Description:	자재 생성 출고 저장
-- =============================================
CREATE PROCEDURE [dbo].[18MM_StockOUT_U1]
     @PLANTCODE              VARCHAR(10) -- 공장
	,@LOTNO                  VARCHAR(20) 
	,@ITEMCODE               VARCHAR(30)  
	,@STOCKQTY                    FLOAT(10)  
	,@UNITCODE               VARCHAR(5)
	,@WHCODE                 VARCHAR(5)
	,@STRORAGELOCCODE        VARCHAR(10)
	,@WORKERID               VARCHAR(10)

	,@LANG                   VARCHAR(10)='KO'
	,@RS_CODE                VARCHAR(1)   OUTPUT
	,@RS_MSG                 VARCHAR(200) OUTPUT
AS
BEGIN
	DECLARE @LS_PODATE  VARCHAR(10)
		   ,@LD_NOWDATE DATETIME
	SET @LS_PODATE = CONVERT(VARCHAR,GETDATE(),23)
	SET @LD_NOWDATE = GETDATE()

	--1. LOTNO 채번
	DECLARE @LS_LOTNO  VARCHAR(10)
		SET @LS_LOTNO = 'LOT-' + RIGHT(@LOTNO,4)

	--2. 발주 정보 업데이트
	UPDATE TB_StockMM
	   SET  MATLOTNO = @LOTNO
		   ,MAKEDATE = @LS_PODATE
		   ,MAKER    = @WORKERID 
		   ,EDITDATE = @LD_NOWDATE
  	 WHERE PLANTCODE = @PLANTCODE
	   AND MATLOTNO  = @LOTNO 

	--3. 자재 재고 생성
	INSERT INTO TB_StockMM(PLANTCODE, ITEMCODE, MATLOTNO, WHCODE, UNITCODE, MAKEDATE)
                 	SELECT PLANTCODE, ITEMCODE, @LS_LOTNO, 'WH001', UNITCODE, @LD_NOWDATE
                 	  FROM TB_POMake WITH(NOLOCK)
                 	 WHERE PLANTCODE = @PLANTCODE
                 	   AND LOTNO     = @LOTNO

    --4. 입고 이력 생성
	DECLARE @INOUTSEQ INT
	 SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0)+1
	   FROM TB_StockMMrec WITH(NOLOCK)
	  WHERE PLANTCODE = @PLANTCODE
		AND INOUTDATE = @LS_PODATE

	 INSERT INTO TB_StockMMrec
	 (PLANTCODE,	MATLOTNO,	INOUTCODE,	INOUTQTY,	INOUTDATE,	INOUTWORKER,		WHCODE,	INOUTFLAG,	 MAKER,	MAKEDATE)
	 VALUES
	 (@PLANTCODE,  @LS_LOTNO,	     '20',	  @STOCKQTY,   @LS_PODATE,     @WORKERID ,  'WH001',   'OUT', @WORKERID, @LD_NOWDATE) 

	SET @RS_CODE = 'S'
END
GO
