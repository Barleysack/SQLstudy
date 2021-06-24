USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[05WM_StockWM_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김수연
-- Create date: 2021-06-16
-- Description:	제품 재고 상차 등록
-- =============================================
CREATE PROCEDURE [dbo].[05WM_StockWM_U1]
	  @PLANTCODE VARCHAR(10)
	 ,@LOTNO     VARCHAR(30)
	 ,@ITEMCODE  VARCHAR(30)
	 ,@CUSTCODE  VARCHAR(10)
	 ,@CARNO	 VARCHAR(20)
	 ,@SHIPQTY	 FLOAT
	 ,@SHIPNO	 VARCHAR(30)
	 ,@WORKER    VARCHAR(20)

     ,@LANG      VARCHAR(10)  = 'KO'
     ,@RS_CODE   VARCHAR(1)   OUTPUT
     ,@RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN
		--현재 시간 정의
		DECLARE @LD_NOWDATE DATETIME
		       ,@LS_NOWDATE VARCHAR(10)
			   ,@LS_SHIPNO  VARCHAR(30)
			   ,@LI_SHIPSEQ INT
		   SET @LD_NOWDATE = GETDATE()
		   SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)
        
		-- 등록된 작업자 인지 확인
	    IF (SELECT COUNT(*)
	          FROM TB_WorkerList WITH(NOLOCK)
	         WHERE PLANTCODE = @PLANTCODE
	           AND WORKERID  = @WORKER) <> 1
	    BEGIN
	    	SET @RS_CODE = 'E'
	    	SET @RS_MSG  = '등록 된 작업자 정보가 아닙니다.'
	    	RETURN;
	    END
	    
	    -- 거래처 존재 여부 확인
	    --IF (SELECT COUNT(*)
	    --      FROM TB_CustMaster
	    
	    
	    -- 재고 상태에 있는지 확인
	    IF (SELECT COUNT(*)
	          FROM TB_StockWM WITH(NOLOCK)
	    	 WHERE PLANTCODE             = @PLANTCODE
	    	   AND LOTNO	             = @LOTNO) <> 1
	    BEGIN
	    	 SET @RS_CODE = 'E'
	    	 SET @RS_MSG  = '제품 창고에 존재하지 않는 LOT 입니다. : '  + @LOTNO
	    	 RETURN;
	    END	 	   
	   
	   --이미 상차된 내역인지 확인
	   IF (SELECT SHIPFLAG
		   FROM TB_StockWM WITH(NOLOCK)
		   WHERE PLANTCODE = @PLANTCODE
		     AND LOTNO = @LOTNO) = 'Y'
	   BEGIN
		  SET @RS_CODE = 'E'
		  SET @RS_MSG  = '이미 상차된 내역입니다.'
		  RETURN
	   END

	   --강사님 코드
       ---- 이미 상차된 내역인지 확인.
	   --IF (SELECT COUNT(*)
	   --      FROM TB_StockWM WITH(NOLOCK)
	   --	    WHERE PLANTCODE = @PLANTCODE
	   --	      AND LOTNO	    = @LOTNO
	   --	      AND ISNULL(SHIPFLAG,'N')  = 'Y') = 1
	   --BEGIN
	   --	  SET @RS_CODE = 'E'
	   --	  SET @RS_MSG  = '이미 상차 처리된 LOT 입니다. : '  + @LOTNO
	   --	  RETURN;
	   --END	 

	   -- 상차내역 UPDATE
	   UPDATE TB_StockWM
	   SET SHIPFLAG = 'Y'
	   WHERE PLANTCODE = @PLANTCODE 
	     AND LOTNO = @LOTNO

	   -- 상차 번호 채번
	   IF (ISNULL(@SHIPNO,'') = '')
		 BEGIN
		   SET @LS_SHIPNO = 'SHIP' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),' ','')
		   -- 상차 내역 등록(공통)
		   INSERT INTO TB_ShipWM (  PLANTCODE,      SHIPNO,  CARNO,    SHIPDATE,  CUSTCODE,  WORKER,    MAKEDATE,   MAKER)
		   			      VALUES ( @PLANTCODE,  @LS_SHIPNO, @CARNO, @LS_NOWDATE, @CUSTCODE, @WORKER, @LD_NOWDATE, @WORKER)
	     END

	   ELSE
	     BEGIN
		   SET @LS_SHIPNO = @SHIPNO
		 END

	   -- 상차 실적 상세 등록
	   SELECT @LI_SHIPSEQ = ISNULL(MAX(SHIPSEQ),0) + 1
	   FROM TB_SHIPWM_B WITH(NOLOCK)
	   WHERE PLANTCODE = @PLANTCODE
	     AND SHIPNO = @LS_SHIPNO

	   INSERT INTO TB_SHIPWM_B (  PLANTCODE,     SHIPNO,	 SHIPSEQ,  LOTNO,  ITEMCODE,  SHIPQTY,    MAKEDATE,   MAKER)
					    VALUES ( @PLANTCODE, @LS_SHIPNO, @LI_SHIPSEQ, @LOTNO, @ITEMCODE, @SHIPQTY, @LD_NOWDATE, @WORKER)
	SET @RS_CODE = 'S'
	SET @RS_MSG = @LS_SHIPNO
END
GO
