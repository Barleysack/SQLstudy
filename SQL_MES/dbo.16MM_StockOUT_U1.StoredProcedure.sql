USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[16MM_StockOUT_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이진
-- Create date: 2021-06-10
-- Description:	자재 생산 출고 관리 출고 저장
-- =============================================
CREATE PROCEDURE [dbo].[16MM_StockOUT_U1]
	 @PlantCode      VARCHAR(10)   --창고
    ,@LotNo          VARCHAR(30)   --LOTNO
    ,@ItemCode       VARCHAR(30)   --품목
    ,@Qty            FLOAT         --
 	,@UnitCode       VARCHAR(5)    --
	,@WhCode         VARCHAR(5)    --출고창고
	,@StorageLocCode VARCHAR(10)   --출고저장위치
	,@WorkerId       VARCHAR(10)   --사용자 아이디

	,@LANG       VARCHAR(10)  = 'KO'    --언어
	,@RS_CODE    VARCHAR(1)  OUTPUT     --성공 여부
	,@RS_MSG     VARCHAR(200) OUTPUT    --성공관련메세지
AS
BEGIN
    DECLARE @LS_PODATE VARCHAR(10)  --현재일자
    	   ,@LD_NOWDATE DATETIME    --현재일시
    	SET @LS_PODATE  = CONVERT(VARCHAR,GETDATE(),23)
    	SET @LD_NOWDATE = GETDATE()

		 
 -- 1. 출고 이력 순번 채번 
	DECLARE @INOUTSEQ INT 
     SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) +1 
       FROM TB_StockMMrec WITH(NOLOCK) 
      WHERE PlantCode = @PlantCode 
        AND INOUTDATE = @LS_PODATE


 -- 1. 생산 출고 이력 등록
  INSERT TB_StockMMrec (PLANTCODE, MATLOTNO, INOUTCODE, INOUTQTY, INOUTDATE,   INOUTWORKER, INOUTSEQ,  WHCODE, STORAGELOCCODE,  INOUTFLAG, MAKER, MAKEDATE) 
				SELECT  PLANTCODE, @LotNo,   '20',      STOCKQTY ,@LD_NOWDATE, @WorkerId,   @INOUTSEQ, WHCODE, STORAGELOCCODE, 'OUT',      MAKER, MAKEDATE
				     FROM TB_StockMM WITH(NOLOCK)
				    WHERE PLANTCODE = @PLANTCODE
					  AND MATLOTNO  = @LotNo


     
 -- 2. 자재 재고 삭제
 DELETE TB_StockMM 
  WHERE PLANTCODE = @PLANTCODE 
    AND MATLOTNO = @LotNo

 -- 3. 공정 재고 생성
 INSERT TB_STOCKPP (PLANTCODE,   LOTNO,  ITEMCODE, WHCODE, STORAGELOCCODE, STOCKQTY, UNITCODE , MAKEDATE,   MAKER ) 
            SELECT  PLANTCODE,   @LotNo, ITEMCODE, WHCODE, STORAGELOCCODE, STOCKQTY, UNITCODE, @LD_NOWDATE, MAKER 
			  FROM TB_StockMM WITH(NOLOCK)
		     WHERE PLANTCODE = @PLANTCODE
			   AND MATLOTNO  = @LotNo
 --그리드에서 받아온 파라매터로 등록 

 -- 4. 공정 창고 입고이력 추가 
 -- 일자 별 입고 이력 SEQ 채번 
	DECLARE @INOUTSEQ_PP INT 
	 SELECT @INOUTSEQ_PP = ISNULL(MAX(INOUTSEQ),0) + 1 
	   FROM TB_StockPPrec WITH(NOLOCK) 
	  WHERE PLANTCODE = @PlantCode 
	    AND RECDATE = @LS_PODATE
	
	INSERT INTO TB_StockPPrec (PLANTCODE , INOUTSEQ ,    RECDATE  , LOTNO ,  ITEMCODE,  WHCODE , STORAGELOCCODE , INOUTFLAG , INOUTQTY , UNITCODE , INOUTCODE , MAKEDATE , MAKER ) 
	                   VALUES (@PlantCode, @INOUTSEQ_PP,@LS_PODATE, @LotNo, @ItemCode, @WhCode, @StorageLocCode,  'IN'      , @Qty     ,@UnitCode , '20'      ,@LD_NOWDATE, @WorkerId)

	SET @RS_CODE = 'S'
END
GO
