USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[05PP_StockPP_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김수연
-- Create date: 2021-06-07
-- Description:	생산출고 취소
-- =============================================
CREATE PROCEDURE [dbo].[05PP_StockPP_U1]
	 @PLANTCODE			VARCHAR(10)          -- 공장 코드
	,@LOTNO				VARCHAR(30)		     -- LOTNO
	,@ITEMCODE			VARCHAR(30)			 -- 품목
	,@QTY				FLOAT				 -- 수량
	,@UNITCODE			VARCHAR(5)			 -- 단위
	,@WORKERID			VARCHAR(10)          -- 등록자

	,@LANG			    VARCHAR(10)  = 'KO'   -- 언어
	,@RS_CODE		    VARCHAR(10)  OUTPUT   -- 성공 여부
	,@RS_MSG			VARCHAR(200) OUTPUT   -- 성공 관련 메세지
AS
BEGIN TRY
	--현재시간 정의
    DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
	    SET @LD_NOWTIME = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)

	--공정재고 삭제
	DELETE TB_StockPP
	WHERE PLANTCODE = @PLANTCODE AND LOTNO = @LOTNO

	--공정 재고 출고 이력 순번 채번
    DECLARE @INOUTSEQ_PP INT
	
    SELECT @INOUTSEQ_PP = ISNULL(MAX(INOUTSEQ),0) + 1
	  FROM TB_StockPPrec WITH(NOLOCK)
	 WHERE PLANTCODE  = @PLANTCODE
	   AND RECDATE  = @LS_NOWDATE

	--
	INSERT INTO TB_StockPPrec
			(PLANTCODE,     INOUTSEQ,     RECDATE,  LOTNO,  ITEMCODE,  WHCODE,  STORAGELOCCODE, INOUTFLAG,INOUTQTY,  UNITCODE
			,INOUTCODE,    MAKEDATE,     MAKER)
	VALUES (@PLANTCODE, @INOUTSEQ_PP, @LS_NOWDATE, @LOTNO, @ITEMCODE, 'WH003',		NULL,     'OUT',    @QTY, @UNITCODE,
				  '25', @LD_NOWTIME, @WORKERID)

	

    --자재 재고 등록
	INSERT TB_StockMM ( PLANTCODE, MATLOTNO,  WHCODE,  ITEMCODE, STOCKQTY,  UNITCODE,	  MAKER,    MAKEDATE)
			   VALUES (@PLANTCODE,   @LOTNO, 'WH001', @ITEMCODE,	 @QTY, @UNITCODE, @WORKERID, @LD_NOWTIME)

    -- 3. 자재 창고 입고 이력 등록
	--변수 재사용 가능!
    DECLARE @INOUTSEQ INT	
    SELECT  @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
	  FROM TB_StockMMrec WITH(NOLOCK)
	WHERE PLANTCODE  = @PLANTCODE
	  AND INOUTDATE  = @LS_NOWDATE

	-- 4. 입고 이력 생성
	INSERT TB_StockMMrec( PLANTCODE, MATLOTNO, INOUTCODE,INOUTQTY,	INOUTDATE, INOUTWORKER,  INOUTSEQ,  WHCODE,  STORAGELOCCODE,
						  INOUTFLAG,	 MAKER,  MAKEDATE)
				  VALUES(@PLANTCODE,   @LOTNO,      '25',    @QTY,  @LS_NOWDATE,   @WORKERID, @INOUTSEQ, 'WH001',		 NULL,
							  'IN', @WORKERID, @LD_NOWTIME)
    
   
	SET @RS_CODE = 'S'

END TRY                           

BEGIN CATCH

     SELECT  @RS_MSG = ERROR_MESSAGE()
     SELECT @RS_CODE = 'E'                 
END CATCH
GO
