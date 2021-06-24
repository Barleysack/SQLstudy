USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18WM_StockWM_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-16
-- Description:	상차 등록
-- =============================================
CREATE PROCEDURE [dbo].[18WM_StockWM_U1]
	@PLANTCODE       VARCHAR(10)
   ,@CARNO           VARCHAR(30)
   ,@SHIPDATE        VARCHAR(10)
   ,@WORKER          VARCHAR(10)
   ,@MAKEDATE        VARCHAR(10)
   ,@WORKERID        VARCHAR(10)
   ,@MAKER           VARCHAR(20)
   ,@CUSTNAME        VARCHAR(10)
   ,@SHIPFLAG        VARCHAR(10)
   ,@LOTNO           VARCHAR(20)

   ,@LANG            VARCHAR(10)    ='KO'
   ,@RS_CODE         VARCHAR(1)     OUTPUT
   ,@RS_MSG		     VARCHAR(200)   OUTPUT


AS
BEGIN
    -- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
           ,@LS_NOWDATE VARCHAR(10)
		SET @LD_NOWDATE = GETDATE()  
        SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

	-- 등록된 작업자 확인
	IF(ISNULL(@MAKER,'')='')
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '작업자를 등록하지 않았습니다.'
		RETURN
	END
	--SELECT * FROM TB_CustMaster


	-- 거래처 존재여부 확인
   DECLARE @LS_CUSTCODE VARCHAR(30)    
	SELECT @LS_CUSTCODE = CUSTCODE
	  FROM TB_CustMaster WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND CUSTCODE  = @LS_CUSTCODE
     IF (ISNULL(@LS_CUSTCODE,'') = '')
	 BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '거래처가 존재하지 않습니다.'
		RETURN;
	 END

	 -- 이미 상차된 내역인지 확인
	 SELECT @SHIPFLAG = SHIPFLAG
	   FROM TB_StockWM WITH(NOLOCK)
	  WHERE PLANTCODE = @PLANTCODE
	    AND LOTNO     = @LOTNO
     IF (ISNULL(@SHIPFLAG,'') = 'Y')
	 BEGIN
	 	SET @RS_CODE = 'E'
	 	SET @RS_MSG  = '이미 상차된 내역입니다.'
	 	RETURN
	 END	

	--SELECT * FROM TB_StockWM
	-- 상차 내역 UPDATE
	UPDATE TB_StockWM
	   SET SHIPFLAG  = @SHIPFLAG       
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO     = @LOTNO

	-- 상차 번호 채번
	DECLARE @LS_SHIPNO VARCHAR(30)  
		SET @LS_SHIPNO = 'SHIP' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),'','')
	
	-- 상차 번호 등록(공통)
	 INSERT INTO TB_SHIPWM (PLANTCODE,   SHIPNO,    CARNO,       SHIPDATE,   
	                        CUSTCODE,    WORKER,    MAKEDATE,    MAKER)
	                VALUES (@PLANTCODE,  @LS_SHIPNO,     @CARNO,    @SHIPDATE,  
					        @LS_CUSTCODE,   @WORKER,     @MAKEDATE,    @WorkerId)
END
--SELECT * FROM TB_SHIPWM
GO
