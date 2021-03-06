USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[04PP_StockPP_U1]    Script Date: 2021-06-10 오후 2:11:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보성

-- Description:	STOCKPP 업데이트
-- =============================================
ALTER PROCEDURE [dbo].[04PP_StockPP_U1]
                     	@PLANTCODE       VARCHAR(10)
                        ,@LOTNO          VARCHAR(30)
                        ,@ITEMCODE       VARCHAR(30)
                        ,@QTY             FLOAT
                        ,@UNITCODE        VARCHAR(5)
                        ,@WORKERID        VARCHAR(10)
                        ,@STORAGELOCCODE VARCHAR(20) = ''
                        ,@WHCODE VARCHAR(10)



	,@LANG				 VARCHAR(5)    = 'KO'
	,@RS_CODE			 VARCHAR(1)   OUTPUT
	,@RS_MSG			 VARCHAR(200) OUTPUT


AS
BEGIN

--날짜 정의
DECLARE @LD_NOWTIME DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
	    SET @LD_NOWTIME = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23) 





--공정 재고 삭제
DELETE         TB_StockPP
WHERE          PLANTCODE = @PLANTCODE AND LOTNO = @LOTNO








--공정 재고 출고 이력 생성
DECLARE				   @INOUTSEQ_PP INT
SELECT				   @INOUTSEQ_PP=ISNULL(MAX(INOUTSEQ),0)+1
		FROM		   TB_StockPPrec WITH(NOLOCK)
		WHERE		   PLANTCODE = @PLANTCODE
  AND				   RECDATE = @LS_NOWDATE
INSERT INTO		       TB_StockPPrec
(
					   PLANTCODE, INOUTSEQ, RECDATE, LOTNO, ITEMCODE, WHCODE , STORAGELOCCODE, INOUTFLAG, 
			           INOUTQTY,UNITCODE,INOUTCODE, MAKEDATE, MAKER
)
VALUES		          (@PLANTCODE,@INOUTSEQ_PP,@LS_NOWDATE,@LOTNO,@ITEMCODE,'WH003',@STORAGELOCCODE,'OUT',
			           @QTY,@UNITCODE,'25', GETDATE(),@WORKERID)







--자재창고 재고 등록
INSERT INTO           TB_STOCKMM
                      (PLANTCODE, MATLOTNO, WHCODE, ITEMCODE, STOCKQTY, UNITCODE, MAKER, MAKEDATE)
VALUES                (@PLANTCODE, @LOTNO,'WH001',@ITEMCODE,@QTY,@UNITCODE,@WORKERID,GETDATE())





--자재 창고 입고 이력 등록
--채번
DECLARE               @INOUTSEQ INT
SELECT                @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0)+1
FROM                  TB_StockMMrec WITH(NOLOCK)
WHERE                 PLANTCODE = @PLANTCODE
AND                   INOUTDATE = @LS_NOWDATE











--자재 입고 이력 등록
INSERT				  TB_StockMMrec
                      (PLANTCODE, MATLOTNO,INOUTCODE, INOUTQTY, INOUTDATE, INOUTWORKER, 
                      INOUTSEQ, WHCODE, INOUTFLAG, MAKER, MAKEDATE)
VALUES(               @PLANTCODE, @LOTNO, '25', @QTY, @LS_NOWDATE, @WORKERID, @INOUTSEQ, 'WH001'
                      ,'IN', @WORKERID,GETDATE())



END
