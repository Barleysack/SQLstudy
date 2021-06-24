USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10WM_StockWM_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		마상우
-- Create date: 2021-06-16
-- Description:	상차 등록
-- =============================================
CREATE PROCEDURE [dbo].[10WM_StockWM_U1]
	@PLANTCODE  VARCHAR(10) 
   ,@WORKER		VARCHAR(30)
   ,@LOTNO	    VARCHAR(30)
   ,@ITEMCODE   VARCHAR(30)
   ,@MAKER		VARCHAR(30)
   ,@CARNO		VARCHAR(30)
   ,@CUSTCODE	VARCHAR(30)
   ,@SHIPQTY	 FLOAT


   ,@LANG            VARCHAR(10)    ='KO'
   ,@RS_CODE         VARCHAR(1)     OUTPUT
   ,@RS_MSG		     VARCHAR(200)   OUTPUT
AS
BEGIN

	--현재 시간 정의
		DECLARE @LD_NOWDATE DATETIME
		       ,@LS_NOWDATE VARCHAR(10)
			   ,@LS_SHIPNO  VARCHAR(30)
			   ,@LI_SHIPSEQ INT
		   SET @LD_NOWDATE = GETDATE()
		   SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

--이미 상차된거
	IF(SELECT ISNULL(SHIPFLAG,'N')
		  FROM TB_StockWM
		  WHERE PLANTCODE = @PLANTCODE
			AND LOTNO	  = @LOTNO) = 'Y'
		  BEGIN
			SET @RS_CODE = 'E'
			SET @RS_MSG  = '이미 상차처리된 차량입니다.'
			RETURN;
		  END

--상차 내역
 UPDATE TB_StockWM 
    SET SHIPFLAG ='Y'
  WHERE PLANTCODE = @PLANTCODE
    AND LOTNO     = @LOTNO

--상차 번호 채번

SET @LS_SHIPNO = 'SHIP' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),' ','') 


   -- 상차 내역 등록(공통)
	   IF (SELECT COUNT(*)
	       FROM TB_SHIPWM WITH(NOLOCK)
		   WHERE PLANTCODE = '1000'
		     AND SHIPNO = @LS_SHIPNO
			 AND CARNO = @CARNO) = 0
	        BEGIN
	            INSERT INTO TB_ShipWM (  PLANTCODE,     SHIPNO,  CARNO,    SHIPDATE,  CUSTCODE,  WORKER,    MAKEDATE,   MAKER)
	         			      VALUES ( @PLANTCODE, @LS_SHIPNO, @CARNO, @LS_NOWDATE, @CUSTCODE, @WORKER, @LD_NOWDATE, @WORKER)
	        END
	   -- 상차 내역 등록(상세)
	   SELECT @LI_SHIPSEQ = ISNULL(MAX(SHIPSEQ),0) + 1
	   FROM TB_SHIPWM_B WITH(NOLOCK)
	   WHERE PLANTCODE = @PLANTCODE
	     AND SHIPNO = @LS_SHIPNO

	   INSERT INTO TB_SHIPWM_B (  PLANTCODE,     SHIPNO,	 SHIPSEQ,  LOTNO,  ITEMCODE,  SHIPQTY,    MAKEDATE,   MAKER)
					    VALUES ( @PLANTCODE, @LS_SHIPNO, @LI_SHIPSEQ, @LOTNO, @ITEMCODE, @SHIPQTY, @LD_NOWDATE, @WORKER)
	SET @RS_CODE = 'S'
END
GO
