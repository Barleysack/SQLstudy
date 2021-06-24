USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[17WM_StockWM_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 2021-06-16
-- Description:	제품 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[17WM_StockWM_I1]
		 @PLANTCODE		   VARCHAR(10)			 -- 공장
		,@LOTNO   	       VARCHAR(50)			 -- LOT 번호
		,@ITEMCODE	       VARCHAR(30)			 -- 품목 코드
		,@WHCODE	       VARCHAR(10)			 -- 창고
		,@STOCKQTY		   VARCHAR(10)			 -- 재고 수량
		--,@BASEUNIT	       VARCHAR(10)			 -- 단위
		,@CARNO            VARCHAR(10)			 -- 차량 번호
		,@CUSTCODE		   VARCHAR(10)			 -- 거래처
		,@WORKERID		   VARCHAR(10)			 -- 작업자
		,@MAKER            VARCHAR(10)			 -- 등록자




		,@LANG             VARCHAR(10) = 'KO'     
		,@RS_CODE          VARCHAR(1)	 OUTPUT									  
		,@RS_MSG           VARCHAR(200)	 OUTPUT	

AS
BEGIN
		-- 현재 시간 정의
		DECLARE @LD_NOWDATE DATETIME
		       ,@LS_NOWDATE VARCHAR(10)
			SET @LD_NOWDATE = GETDATE()
			SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

		-- 작업자 확인
		IF (SELECT COUNT(*)
		      FROM TB_WorkerList WITH(NOLOCK)
			 WHERE WORKERID = @WORKERID) <> 1
		BEGIN
				SET @RS_CODE = 'E'
				SET @RS_MSG  = '없는 작업자입니다.'
				RETURN;

		END
	    -- 거래처 존재 여부 확인
		IF (SELECT COUNT(*)
		      FROM TB_CustMaster WITH(NOLOCK)
			 WHERE PLANTCODE = @PLANTCODE
			   AND CUSTCODE  = @CUSTCODE) <> 1
		BEGIN
				SET @RS_CODE = 'E'
				SET @RS_MSG  = '거래처가 없습니다.'
				RETURN;
		END

		-- 이미 상차된 내역인지 확인
		IF (SELECT ISNULL(SHIPFLAG,'N')
		      FROM TB_StockWM WITH(NOLOCK)
			 WHERE PLANTCODE  = @PLANTCODE
			   AND LOTNO   = @LOTNO)  != 'N'
		BEGIN
				SET @RS_CODE = 'E'
				SET @RS_MSG  = '이미 상차된 내역입니다.'
				RETURN;
		END
		
		DECLARE @LS_SHIPNO VARCHAR(30)
		
		IF (SELECT COUNT(*)
		      FROM TB_ShipWM A WITH (NOLOCK)  LEFT JOIN TB_ShipWM_B B WITH (NOLOCK)
												     ON A.SHIPNO = B.SHIPNO
			 WHERE A.PLANTCODE = @PLANTCODE
			   AND A.SHIPNO    = B.SHIPNO
			   AND B.LOTNO     = @LOTNO
			  ) = 0 
		BEGIN 
		    SET @LS_SHIPNO = 'SHIP' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,
			                          GETDATE(),120),'-',''),':',''),' ','')
			INSERT INTO TB_ShipWM ( PLANTCODE, SHIPNO, CARNO, SHIPDATE, CUSTCODE, 
		                        WORKER, MAKEDATE, MAKER)
						VALUES( @PLANTCODE, @LS_SHIPNO, @CARNO, @LS_NOWDATE, @CUSTCODE
						       ,@WORKERID, @LD_NOWDATE, @MAKER) 				
		END

		--DECLARE @LS_SHIPNO VARCHAR(30)
		SELECT @LS_SHIPNO = A.SHIPNO
		--SELECT A.SHIPNO
		  FROM TB_ShipWM A WITH (NOLOCK)  LEFT JOIN TB_ShipWM_B B WITH (NOLOCK)
												     ON A.SHIPNO = B.SHIPNO
		 WHERE A.PLANTCODE     = @PLANTCODE
		   AND A.SHIPNO    = B.SHIPNO
		   AND B.LOTNO     = @LOTNO

		DECLARE @LI_SHIPSEQ INT
		
		SELECT @LI_SHIPSEQ = ISNULL(MAX(SHIPSEQ),0) + 1 
          FROM TB_SHIPWM_B WITH(NOLOCK) 
         WHERE PLANTCODE = @PLANTCODE 
           AND SHIPNO = @LS_SHIPNO 

		INSERT INTO TB_ShipWM_B (PLANTCODE, SHIPNO, SHIPSEQ, LOTNO, ITEMCODE, 
								 SHIPQTY, MAKEDATE, MAKER)
						  VALUES(@PLANTCODE, @LS_SHIPNO, @LI_SHIPSEQ, @LOTNO, @ITEMCODE,
						         @STOCKQTY, @LD_NOWDATE, @MAKER)

		UPDATE TB_StockWM
		   SET SHIPFLAG = 'Y'
		 WHERE PLANTCODE = @PLANTCODE
		   AND LOTNO     = @LOTNO

	SET @RS_CODE = 'S'
END
GO
