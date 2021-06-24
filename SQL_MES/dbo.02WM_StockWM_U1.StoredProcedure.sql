USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02WM_StockWM_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-16
-- Description:	상차 등록
-- =============================================
CREATE PROCEDURE [dbo].[02WM_StockWM_U1]
	 @PLANTCODE		 VARCHAR(10)
	,@ITEMCODE		 VARCHAR(30)
	,@LOTNO			 VARCHAR(30)
	,@CARNO			 VARCHAR(30)
	,@CUSTCODE		 VARCHAR(30)
	,@WORKERID		 VARCHAR(30)  --작업자
	,@EDITOR		 VARCHAR(30)  --등록자
    ,@STOCKQTY		 VARCHAR(30)
	,@RUTINFLAGE     VARCHAR(30)

    ,@LANG           VARCHAR(10)  = 'KO'
    ,@RS_CODE        VARCHAR(1)   OUTPUT
    ,@RS_MSG         VARCHAR(200) OUTPUT
	
AS
BEGIN
		--현재 시간 정의
		DECLARE @LD_MOWDATE DATETIME
		       ,@LS_NOWDATE VARCHAR(10)
		   SET @LD_MOWDATE = GETDATE()
		   SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_MOWDATE,23)

	-- 등록된 작업자 인지 확인
	IF (SELECT COUNT(*)
	  FROM TB_WorkerList WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKERID  = @WORKERID) <> 1
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
---------------------------------------------------------------------------------------------	   
	    --상차 내역 update
	    UPDATE TB_StockWM
	       SET SHIPFLAG = 'Y'
	  	WHERE PLANTCODE = @PLANTCODE
	  	  AND ITEMCODE  = @ITEMCODE
	  	  AND LOTNO     = @LOTNO

		--상차 번호 채번		
		DECLARE @LS_SHIPNO VARCHAR(30)
		    SET @LS_SHIPNO = 'SHIP' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),' ','') 

		--상차 내역 등록(공통) 
	    IF @RUTINFLAGE = 'F'
	    BEGIN
			INSERT INTO TB_SHIPWM (PLANTCODE,  SHIPNO,	   CARNO ,	SHIPDATE    ,    CUSTCODE   ,  WORKER,    MAKEDATE,    MAKER) 
			               VALUES (@PLANTCODE, @LS_SHIPNO, @CARNO,  @LS_NOWDATE ,   @CUSTCODE  , @WORKERID, @LD_MOWDATE, @WORKERID)
			SET @RUTINFLAGE = 'T'

	    END 
		IF @RUTINFLAGE <> 'F'
		BEGIN
		--상차 내역 등록(상세)
		   DECLARE @LI_SHIPSEQ INT
			SELECT @LI_SHIPSEQ = ISNULL(MAX(SHIPSEQ),0) + 1
			  FROM TB_SHIPWM_B WITH(NOLOCK) 
			 WHERE PLANTCODE = @PLANTCODE 
			   AND SHIPNO    = @LS_SHIPNO 
			INSERT INTO TB_SHIPWM_B (PLANTCODE, SHIPNO,        SHIPSEQ,		LOTNO,  ITEMCODE,    SHIPQTY,     MAKEDATE,      MAKER) 
			                 VALUES (@PLANTCODE, @LS_SHIPNO,   @LI_SHIPSEQ, @LOTNO, @ITEMCODE,   @STOCKQTY   ,@LD_MOWDATE  , @EDITOR)
		END
	SET @RS_MSG = @LS_SHIPNO
	SET @RS_CODE = 'S'
END
GO
