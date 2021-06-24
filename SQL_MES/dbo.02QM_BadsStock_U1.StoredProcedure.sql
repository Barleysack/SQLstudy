USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02QM_BadsStock_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		2조
-- Create date: 2021-06-18
-- Description:	불량 재고 처리
-- =============================================
CREATE PROCEDURE [dbo].[02QM_BadsStock_U1]
	 @PLANTCODE        VARCHAR(30)
	,@INLOTNO            VARCHAR(30)
	,@BADSEQ           VARCHAR(10)
	,@ITEMCODE         VARCHAR(30)
	,@ITEMNAME         VARCHAR(30)
	,@PRODQTY          float
	,@BADQTY           FLOAT
	,@BADTYPE          VARCHAR(30)
	,@COMFLAG         VARCHAR(30)
	,@WORKER           VARCHAR(30)
	,@WORKCENTERNAME   VARCHAR(30)
	,@EDITDATE         VARCHAR(30)
	,@EDITOR           VARCHAR(30)
	,@ORDERNO		   VARCHAR(30)

	,@LANG     VARCHAR(5) = 'KO'
    ,@RS_CODE  VARCHAR(1)   OUTPUT
    ,@RS_MSG   VARCHAR(200) OUTPUT
AS
BEGIN

	-- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME     --현재일시 (시.분.초)
		   ,@LS_NOWDATE VARCHAR(10)  --현재일자 (MM-dd)
	    SET @LD_NOWDATE = GETDATE()
	    SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)


	-- OUTLOT 채번
	

	DECLARE @LS_BADRECSEQ VARCHAR(30)
	 SELECT @LS_BADRECSEQ = @BADSEQ + '-' + RIGHT ('00' + CONVERT(VARCHAR,(ISNULL(MAX(RIGHT(CONVERT(VARCHAR,BADRECSEQ),2)),0)+1)),2)
	   FROM TB_BadStockRec WITH (NOLOCK)
	  WHERE PLANTCODE         = @PLANTCODE
	    AND LEFT(BADRECSEQ,4) = @BADSEQ

	 DECLARE @OUTLOTNO VARCHAR(50)
		 SET @OUTLOTNO = @INLOTNO  + @LS_BADRECSEQ --  '-B' + RIGHT(@LS_BADRECSEQ,2)  --이진이 맘대로 고침
	   

	-- 이력 생성
	INSERT INTO TB_BadStockRec (PLANTCODE, INLOTNO, OUTLOTNO,  ITEMCODE,  ITEMNAME,  PRODQTY ,   BADQTY,   BADTYPE, BADRESULT,   WORKER, WORKCENTERNAME,    EDITDATE, EDITOR, BADRECSEQ)
						 VALUES(@PLANTCODE,@INLOTNO ,@OUTLOTNO,@ITEMCODE, @ITEMNAME,  @PRODQTY , @BADQTY, @BADTYPE,  'ING'       ,@WORKER,@WORKCENTERNAME, @LS_NOWDATE, @EDITOR ,@LS_BADRECSEQ)

	-- 불량 갯수 갱신, 재검사 횟수 채번
	UPDATE TB_BadStock
	   SET BADQTY = BADQTY - @PRODQTY 
		 , CHECKNUM = CHECKNUM + 1
	 WHERE PLANTCODE   = @PLANTCODE
	   AND BADSEQ      = @BADSEQ
	 


	

	-- 3. 공정 재고 생성
	INSERT INTO TB_STOCKPP (PLANTCODE,   LOTNO,     ITEMCODE,   WHCODE,  STORAGELOCCODE, STOCKQTY,  UNITCODE ,  MAKEDATE,   MAKER ) 
			        SELECT @PLANTCODE,   @OUTLOTNO, @ITEMCODE, 'WH003',   NULL,         @PRODQTY, UNITCODE, @LD_NOWDATE, @EDITOR 
					  FROM TB_ProductPlan WITH (NOLOCK)            
					 WHERE PLANTCODE = @PLANTCODE
					   AND ORDERNO = @ORDERNO



	-- 4. 공정 창고 입고이력 추가 
	-- 일자 별 입고 이력 SEQ 채번 
	DECLARE @INOUTSEQ_PP INT 
	 SELECT @INOUTSEQ_PP = ISNULL(MAX(INOUTSEQ),0) + 1 
	   FROM TB_StockPPrec WITH(NOLOCK) 
	  WHERE PLANTCODE = @PlantCode 
	    AND RECDATE = @LS_NOWDATE
	
	INSERT INTO TB_StockPPrec (PLANTCODE , INOUTSEQ ,    RECDATE  ,   LOTNO    ,    ITEMCODE,  WHCODE , STORAGELOCCODE , INOUTFLAG , INOUTQTY, UNITCODE , INOUTCODE , MAKEDATE , MAKER ) 
	                SELECT    @PlantCode, @INOUTSEQ_PP,  @LS_NOWDATE, @OUTLOTNO, @ItemCode, 'WH003', NULL,            'IN'      , @PRODQTY, UNITCODE , '46'      ,@LD_NOWDATE, @EDITOR
					 FROM TB_ProductPlan WITH (NOLOCK)            
					 WHERE PLANTCODE = @PLANTCODE
					   AND ORDERNO = @ORDERNO


	SET @RS_CODE = 'S'

END
GO
