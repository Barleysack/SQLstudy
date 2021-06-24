USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[16WM_StockWM_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이진
-- Create date: 2021-06-16
-- Description:	제품 재고 관리 및 상차 등록 조회 상차등록
-- =============================================
CREATE PROCEDURE [dbo].[16WM_StockWM_U1]
	 @PLANTCODE VARCHAR(10)
	,@ITEMCODE  VARCHAR(30)
	,@CARNO     VARCHAR(10)
	,@CUSTCODE  VARCHAR(10)
	,@WORKER    VARCHAR(30)
	,@LOTNO     VARCHAR(30)
	,@STOCKQTY  VARCHAR(10)


	,@LANG     VARCHAR(10) ='KO'   --언어
    ,@RS_CODE VARCHAR(10) OUTPUT  --성공 여부
    ,@RS_MSG  VARCHAR(200) OUTPUT  --성공 관련 메세지

AS
BEGIN
	-- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
           ,@LS_NOWDATE VARCHAR(10)
		SET @LD_NOWDATE = GETDATE() -- GETDATE로 동일한 시점으로 변수로 지정
        SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

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


	-- 1. 상차 내역 UPDATE
	UPDATE TB_StockWM 
       SET SHIPFLAG = 'Y'      WHERE PLANTCODE = @PLANTCODE	   AND ITEMCODE  = @ITEMCODE	   AND LOTNO     = @LOTNO	-- 2. 상차 내역 채번	DECLARE @LS_SHIPNO VARCHAR(30)	SET @LS_SHIPNO = 'SHIP' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),' ','') 	-- 3. 상차 내역 등록 (공통) 	IF (SELECT COUNT(*)
          FROM TB_SHIPWM WITH(NOLOCK)
         WHERE PLANTCODE = @PLANTCODE
           AND SHIPNO = @LS_SHIPNO
          AND CARNO = @CARNO) = 0
	BEGIN
	INSERT INTO TB_ShipWM (PLANTCODE, SHIPNO, CARNO, SHIPDATE, CUSTCODE, WORKER, MAKEDATE, MAKER)
	VALUES (@PLANTCODE, @LS_SHIPNO,@CARNO, @LS_NOWDATE, @CUSTCODE, @WORKER, @LD_NOWDATE, @WORKER )
	END
	--3. 상차 내역 등록 (상세)	DECLARE @LI_SHIPSEQ INT	 SELECT @LI_SHIPSEQ = ISNULL(MAX(SHIPSEQ),0)+1
       FROM TB_ShipWM_B WITH (NOLOCK)
      WHERE PLANTCODE = @PLANTCODE
        AND SHIPNO = @LS_SHIPNO

	INSERT INTO TB_SHIPWM_B (PLANTCODE,      SHIPNO,     SHIPSEQ, LOTNO, ITEMCODE, SHIPQTY, MAKEDATE, MAKER)					VALUES  (@PLANTCODE, @LS_SHIPNO, @LI_SHIPSEQ, @LOTNO ,@ITEMCODE, @STOCKQTY  ,@LD_NOWDATE, @WORKER) 
	SET @RS_CODE = 'S'
END
GO
