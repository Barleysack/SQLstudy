USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19PP_ActureOutput_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-11
-- Description:	생산을 위한 자재 LOT 투입 등록
-- =============================================
CREATE PROCEDURE [dbo].[19PP_ActureOutput_I1]
     @PLANTCODE      VARCHAR(10),            --공장 코드
     @ITEMCODE       VARCHAR(30),            --품목 코드
     @LOTNO          VARCHAR(30),            --LOT 번호
     @WORKCENTERCODE VARCHAR(10),            --작업장 코드
     @ORDERNO        VARCHAR(20),            --작업 지시 번호
     @UNITCODE       VARCHAR(10),            --단위
     @INFLAG         VARCHAR(3),             --버튼 이름 IN/OUT
     @MAKER          VARCHAR(20),            --생산책임자

     @LANG	         VARCHAR(10)  ='KO',     --언어
     @RS_CODE        VARCHAR(10)  OUTPUT,    --성공 여부
     @RS_MSG         VARCHAR(200) OUTPUT     --성공 관련 메세지

AS
BEGIN 
			-- 현재 시간 정의
			DECLARE @LD_NOWDATE DATETIME
			      , @LS_NOWDATE VARCHAR(10)
				SET @LD_NOWDATE = GETDATE()
				SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

			DECLARE @LS_ITEMCODE VARCHAR(30)     --작업지시 품목
			      , @LF_STOCKQTY FLOAT		     --작업 수량
				  , @LS_UNITCODE VARCHAR(10)     --단위
				  , @INOUTSEQ    INT		     --이력 시퀸스
				  , @LS_WORKER   VARCHAR(20)     --? 

			-- 공정 투입 등록
			IF(@INFLAG='IN')
			BEGIN
			-- VALIDATION CHECK
			-- 작업자 등록 여부 확인
			IF(ISNULL(@MAKER,'')='')
			BEGIN
				SET @RS_CODE = 'E'
				SET @RS_MSG  = '작업자를 등록하지 않았습니다.'
				RETURN
			END
			-- LOT 존재 여부 확인
			SELECT @LS_ITEMCODE= ITEMCODE   -- 공정창고에서 가져온 값
			     , @LF_STOCKQTY= STOCKQTY	-- 공정창고에서 가져온 값
				 , @LS_UNITCODE= UNITCODE	-- 공정창고에서 가져온 값
		      FROM TB_StockPP WITH (NOLOCK)
			 WHERE PLANTCODE = @PLANTCODE
			   AND LOTNO     = @LOTNO

			-- 공정 창고에 해당 품목 대상이 있는지 확인
			IF(ISNULL(@LS_ITEMCODE,'')='')
			BEGIN
				SET @RS_CODE = 'E'
				SET @RS_MSG  = '투입 대상 LOT 가 존재하지 않습니다.'
				RETURN;
			END

			-- 상위 제품과 하위 제품이 원자재, 필요한 부품이 맞는지 확인해주는 코드
			IF(SELECT COUNT(*)
			     FROM TB_BomMaster WITH (NOLOCK)
				WHERE PLANTCODE=@PLANTCODE
				  AND ITEMCODE =@ITEMCODE
				  AND COMPONENT=@LS_ITEMCODE) = 0
			BEGIN
				SET @RS_CODE = 'E'
				SET @RS_MSG  = '선택 작업지시에 투입될 대상 품목이 아닙니다.'
				RETURN;
			END

			-- 작업장 상태 테이블에 현재 투입 LOT의 정보 등록
			UPDATE TP_WorkcenterStatus
			   SET INLOTNO        = @LOTNO           --투입한 LOT 번호
			     , COMPONENT      = @LS_ITEMCODE	 --품목명
				 , COMPONENTQTY   = @LF_STOCKQTY	 --수량
				 , CUNITCODE      = @LS_UNITCODE	 --단위
				 , EDITDATE       = @LD_NOWDATE		 --수정일시
				 , EDITOR         = @MAKER			 --수정자
			 WHERE PLANTCODE      = @PLANTCODE
			   AND WORKCENTERCODE = @WORKCENTERCODE
			   AND ORDERNO        = @ORDERNO

			-- 공정 재고 삭제
			DELETE TB_StockPP
			 WHERE PLANTCODE = @PLANTCODE
			   AND LOTNO     = @LOTNO
			
			--공정 재고 입출고 이력 등록
			SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0)+1
			  FROM TB_StockPPrec WITH (NOLOCK)
			 WHERE PLANTCODE = @PLANTCODE
			   AND RECDATE   = @LS_NOWDATE

			INSERT INTO TB_StockPPrec 
			( PLANTCODE, INOUTSEQ, RECDATE, LOTNO, ITEMCODE, WHCODE, INOUTCODE
			, INOUTFLAG, INOUTQTY, UNITCODE, MAKEDATE, MAKER)
            VALUES
			( @PLANTCODE,@INOUTSEQ, @LS_NOWDATE, @LOTNO, @LS_ITEMCODE,'WH004','30' 
			, 'OUT', @LF_STOCKQTY, @UNITCODE, @LD_NOWDATE, @LS_WORKER)
			-- 창고 ->> WH004, 30->>재공 재고 창고에서 출고 

			-- 재공 재고 등록
			 INSERT INTO TB_StockHALB 
			 ( PLANTCODE, LOTNO, ITEMCODE, WORKCENTERCODE, STOCKQTY
			 , UNITCODE, MAKEDATE, MAKER)
			 VALUES
			 ( @PLANTCODE, @LOTNO, @LS_ITEMCODE,@WORKCENTERCODE, @LF_STOCKQTY
			 , @UNITCODE, @LD_NOWDATE, @LS_WORKER)

			-- 재공 재고 투입 이력 등록
			-- 일자 별 입고 이력 SEQ 채번
			SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
			  FROM TB_StockHALBrec WITH(NOLOCK)
			 WHERE PLANTCODE = @PlantCode
			   AND RECDATE   = @LS_NOWDATE

			INSERT INTO TB_StockHALBrec 
			( PLANTCODE, INOUTSEQ, RECDATE, LOTNO, ITEMCODE, WORKCENTERCODE, INOUTCODE
			, INOUTFLAG, INOUTQTY, UNITCODE, MAKEDATE, MAKER)
			VALUES
			( @PLANTCODE, @INOUTSEQ, @LS_NOWDATE, @LOTNO, @LS_ITEMCODE, @WORKCENTERCODE, '30'
			, 'IN', @LF_STOCKQTY, @UNITCODE, @LD_NOWDATE, @LS_WORKER)
			
            SELECT @RS_CODE = 'S'
			SET @RS_MSG = 'LOT 투입 성공.'

		END
		
			--재공재고 입고 취소
			IF(@INFLAG = 'OUT')
			BEGIN

			-- LOT 존재 여부 확인
			SELECT @LS_ITEMCODE = ITEMCODE    --재공 재고에서 가져옴
		         , @LF_STOCKQTY = STOCKQTY	  --재공 재고에서 가져옴
		         , @LS_UNITCODE = UNITCODE	  --재공 재고에서 가져옴
		      FROM TB_StockHALB WITH (NOLOCK)
		     WHERE PLANTCODE = @PLANTCODE
		       AND LOTNO     = @LOTNO

		    -- 재공 창고에 해당 품목 대상이 있는지 확인
		    IF(ISNULL(@LS_ITEMCODE,'')='')
		    BEGIN
		    	SET @RS_CODE = 'E'
		    	SET @RS_MSG  = '취소 대상 LOT 가 존재하지 않습니다.'
		    	RETURN;
			END

		    -- 작업장 상태 테이블에 현재 투입 LOT 의 정보 삭제
		    UPDATE TP_WorkcenterStatus
		       SET INLOTNO      = NULL
		         , COMPONENT    = NULL
		         , COMPONENTQTY = NULL
		         , CUNITCODE    = NULL
		         , EDITDATE     = @LD_NOWDATE
		         , MAKER        = @LS_WORKER
		     WHERE PLANTCODE      = @PLANTCODE
		       AND WORKCENTERCODE = @WORKCENTERCODE
		       AND ORDERNO        = @ORDERNO 
			 
		    -- 재공 재고 삭제
		    DELETE TB_StockHALB 
		     WHERE PLANTCODE = @PLANTCODE 
		       AND LOTNO     = @LOTNO
		   	
		    -- 재공 재고 취소 이력 등록
		    -- 일자 별 출고 이력 SEQ 채번
		    SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
		      FROM TB_StockHALBrec WITH(NOLOCK)
		     WHERE PLANTCODE = @PlantCode
		       AND RECDATE   = @LS_NOWDATE
		   	
		    INSERT INTO TB_StockHALBrec (PLANTCODE, INOUTSEQ,  RECDATE,     LOTNO, ITEMCODE,     WORKCENTERCODE,  INOUTCODE, INOUTFLAG,  INOUTQTY,     UNITCODE,    MAKEDATE,    MAKER)
		                          VALUES(@PLANTCODE,@INOUTSEQ, @LS_NOWDATE, @LOTNO,@LS_ITEMCODE, @WORKCENTERCODE,'35',       'OUT',      @LF_STOCKQTY, @UNITCODE,   @LD_NOWDATE, @LS_WORKER)
		   	
		   	
		    -- 공정 재고 등록
		    INSERT INTO TB_StockPP  (PLANTCODE,  LOTNO,  ITEMCODE,     WHCODE,          STOCKQTY,      UNITCODE,  MAKEDATE,    MAKER)
		                       VALUES(@PLANTCODE, @LOTNO, @LS_ITEMCODE,@WORKCENTERCODE, @LF_STOCKQTY,  @UNITCODE, @LD_NOWDATE, @LS_WORKER)




            -- 공정 재고 입고 이력 등록
            -- 일자 별 입고 이력 SEQ 채번
            
            SELECT @INOUTSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
              FROM TB_StockPPrec WITH(NOLOCK)
             WHERE PLANTCODE = @PlantCode
               AND RECDATE   = @LS_NOWDATE
	        
            INSERT INTO TB_StockPPrec (PLANTCODE, INOUTSEQ,    RECDATE,     LOTNO, ITEMCODE,     WHCODE,  INOUTFLAG,   INOUTCODE, INOUTQTY,     UNITCODE,    MAKEDATE,    MAKER)
                                VALUES(@PLANTCODE,@INOUTSEQ,   @LS_NOWDATE, @LOTNO,@LS_ITEMCODE, 'WH003', 'IN',        '35',      @LF_STOCKQTY, @UNITCODE,   @LD_NOWDATE, @LS_WORKER)
	        

            SELECT @RS_CODE = 'S'
            SET @RS_MSG = '투입 취소를 완료 하였습니다.'
		END 
END


GO
