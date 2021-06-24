USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[17MM_PoMaker_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 21-06-08
-- Description:	발주 내역 등록
-- =============================================
CREATE PROCEDURE [dbo].[17MM_PoMaker_U1]
	-- Add the parameters for the stored procedure here
	 @PLANTCODE VARCHAR(10)       -- 공장 코드
	,@PONO		VARCHAR(30)       -- 발주 번호
	,@INQTY    FLOAT			  -- 입고 수량
	,@EDITOR    VARCHAR(20) 	  -- 발주 등록자
	
	,@LANG      VARCHAR(10) = 'KO' -- 언어 값 넣어주지 않으면 기본값 KO
	,@RS_CODE   VARCHAR(20)  OUTPUT --성공 여부
	,@RS_MSG    VARCHAR(200)OUTPUT  -- 성공 관련 메세지
AS
BEGIN
	 DECLARE @LS_PODATE  VARCHAR(10)    -- 현재 일자
			,@LD_NOWDATE DATETIME       -- 현재 일시

		 SET @LS_PODATE = CONVERT(VARCHAR, GETDATE(), 23) 
		 -- CONVERT( , ,숫자) 숫자가 23이면 - 가 들어간 연월일
		 -- CONVERT( , ,숫자) 숫자가 112면  - 없이 연월일 이어서
		 -- CONVERT( , ,숫자) 숫자가 120이면  시분초까지
		 SET @LD_NOWDATE = GETDATE()
		 -- SQL문이 몇 백줄될 때 실행하는 동안 시간이 간다. 따라서 변수에 지금 GETDATE를 할당
		 -- 하고 사용하겠다는 것!

		 -- 1. LOTNO 채번
		 DECLARE @LS_LOTNO    VARCHAR(30)
		     SET @LS_LOTNO  = 'LOT-' + REPLACE(CONVERT(VARCHAR,GETDATE(),114),':','')
			 
	     -- 2. 발주 정보 업데이트
		  UPDATE TB_POMake
		     SET INFLAG   = 'Y'
			    ,LOTNO    = @LS_LOTNO
				,INDATE   = @LS_PODATE
				,INQTY    = @INQTY
				,INWORKER = @EDITOR
				,EDITDATE = @LD_NOWDATE
				,EDITOR   = @EDITOR
		   WHERE PLANTCODE= @PLANTCODE
		     AND PONO     = @PONO

		 -- 3. 자재 재고 생성
		  INSERT INTO TB_StockMM(PLANTCODE,	ITEMCODE,	MATLOTNO,	WHCODE,
								 STOCKQTY,	UNITCODE,	CUSTCODE,	MAKEDATE,	MAKER)
					   SELECT    PLANTCODE, ITEMCODE,	@LS_LOTNO,	'WH001'
								,@INQTY,	UNITCODE,	CUSTCODE,	@LD_NOWDATE,@EDITOR
					     FROM TB_POMake WITH(NOLOCK)
					    WHERE PLANTCODE = @PLANTCODE
						  AND PONO      = @PONO

	     -- 4. 입고 이력 생성
		 DECLARE @LI_INSEQ INT
		  SELECT @LI_INSEQ = ISNULL(MAX(INOUTSEQ),0) + 1
		    FROM TB_StockMMrec WITH(NOLOCK)
		   WHERE PLANTCODE = @PLANTCODE
		     AND INOUTDATE = @LS_PODATE

		  INSERT INTO TB_StockMMrec
		         (PLANTCODE,	MATLOTNO,	INOUTCODE,	INOUTQTY,	INOUTDATE,
				 INOUTWORKER,	PONO,		INOUTSEQ,	WHCODE,		INOUTFLAG,
				 MAKER,			MAKEDATE)
				 VALUES
				 (@PLANTCODE,	@LS_LOTNO,	'10',		@INQTY,		@LS_PODATE,
				  @EDITOR,		@PONO,		@LI_INSEQ,	'WH001',	'IN',
				  @EDITOR,		@LD_NOWDATE)

			
			 SET @RS_CODE = 'S'
END
GO
