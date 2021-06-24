USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10WM_ProdInStock_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<마상우>
-- Create date: <2021-06-16>
-- Description:	제품창고 입고 등록
-- =============================================
CREATE PROCEDURE [dbo].[10WM_ProdInStock_U1]
	@PLANTCODE      VARCHAR(10)
   ,@LOTNO          VARCHAR(30) --LTFERT0001X0004
   ,@ITEMCODE       VARCHAR(30)
   ,@INOUQTY        FLOAT
   ,@UNITCODE       VARCHAR(10)      
   ,@MAKER   		VARCHAR(30)



   ,@LANG           VARCHAR(10)  = 'KO'
   ,@RS_CODE        VARCHAR(1)   OUTPUT
   ,@RS_MSG         VARCHAR(200) OUTPUT
AS
BEGIN
	-- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
           ,@LS_NOWDATE VARCHAR(10)
		SET @LD_NOWDATE = GETDATE()  
        SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

	IF( SELECT COUNT(*)
	   FROM TB_StockPP WITH(NOLOCK) 
	  WHERE PLANTCODE = @PLANTCODE
	    AND LOTNO     = @LOTNO ) = 0

		BEGIN
			SET @RS_CODE = 'E'
			SET @RS_MSG = ' 공정창고에 재고가 없습니다. : '+@LOTNO
			RETURN;
		END

	--공정 재고 삭제 이력 생성
	DECLARE @LI_SEQ INT
	 SELECT @LI_SEQ = ISNULL(MAX(INOUTSEQ),0) + 1
	   FROM TB_StockPPrec WITH(NOLOCK)
	  WHERE PLANTCODE = @PLANTCODE
	    AND RECDATE   = @LS_NOWDATE

	INSERT INTO TB_StockPPrec(PLANTCODE,  INOUTSEQ,   RECDATE,    LOTNO,    ITEMCODE,   WHCODE, INOUTFLAG,    INOUTCODE,    INOUTQTY,  UNITCODE,    MAKEDATE,    MAKER)
				       VALUES(@PLANTCODE, @LI_SEQ,   @LS_NOWDATE, @LOTNO,  @ITEMCODE,  'WH008',  'OUT',      '50',         @INOUQTY,   @UNITCODE,   @LD_NOWDATE, @MAKER)

	--공정재고 삭제
	DELETE TB_StockPP
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO     = @LOTNO

	--제품 창고 등록
	INSERT INTO TB_StockWM(PLANTCODE,  LOTNO,  ITEMCODE,  WHCODE,  STOCKQTY,  MAKEDATE,  MAKER)
	                VALUES(@PLANTCODE, @LOTNO, @ITEMCODE, 'WH008', @INOUQTY, @LD_NOWDATE, @MAKER)

	--제품창고 등록 이력
	 SELECT @LI_SEQ = ISNULL(MAX(INOUTSEQ),0) + 1
	   FROM TB_StockPPrec WITH(NOLOCK)
	  WHERE PLANTCODE = @PLANTCODE
	    AND RECDATE   = @LS_NOWDATE

	INSERT INTO TB_StockWMrec(PLANTCODE,  INOUTSEQ,  RECDATE,     LOTNO,  ITEMCODE,  WHCODE,  INOUTFLAG,  INOUTCODE,  INOUTQTY,  UNITCODE,  MAKEDATE,  MAKER)
	                   VALUES(@PLANTCODE, @LI_SEQ,  @LS_NOWDATE, @LOTNO, @ITEMCODE, 'WH008',   'IN',      '50',      @INOUQTY,  @UNITCODE, @LS_NOWDATE, @MAKER)

SET @RS_CODE = 'S'
END
GO
