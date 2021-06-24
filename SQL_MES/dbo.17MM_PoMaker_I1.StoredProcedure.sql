USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[17MM_PoMaker_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 21-06-08
-- Description:	발주 내역 등록
-- =============================================
CREATE PROCEDURE [dbo].[17MM_PoMaker_I1]
	-- Add the parameters for the stored procedure here
	 @PLANTCODE VARCHAR(10)       -- 공장 코드
	,@ITEMCODE  VARCHAR(30)       -- 발주 번호
	,@POQTY     FLOAT			  -- 발주 수량
	,@UNITCODE  VARCHAR(10)		  -- 단위
	,@CUSTCODE  VARCHAR(10)		  -- 거래처 코드
	,@MAKER     VARCHAR(20) 	      -- 발주 등록자
	
	,@LANG      VARCHAR(10) = 'KO' -- 언어 값 넣어주지 않으면 기본값 KO
	,@RS_CODE   VARCHAR(20)  OUTPUT
	,@RS_MSG    VARCHAR(200)OUTPUT
AS
BEGIN
	 DECLARE @LI_SEQ     INT
	        ,@LS_PONO    VARCHAR(20)
			,@LS_PODATE  VARCHAR(10)
			,@LD_NOWDATE DATETIME

		 SET @LS_PODATE = CONVERT(VARCHAR, GETDATE(), 23) 
		 -- CONVERT( , ,숫자) 숫자가 23이면 - 가 들어간 연월일
		 -- CONVERT( , ,숫자) 숫자가 112면  - 없이 연월일 이어서
		 -- CONVERT( , ,숫자) 숫자가 120이면  시분초까지
		 SET @LD_NOWDATE = GETDATE()
		 -- SQL문이 몇 백줄될 때 실행하는 동안 시간이 간다. 따라서 변수에 지금 GETDATE를 할당
		 -- 하고 사용하겠다는 것!

		 -- 아래는 발주 번호 채번
		 SELECT @LI_SEQ   = COUNT(*) + 2
		 --SELECT *
		   FROM TB_POMake WITH(NOLOCK)
		  WHERE PLANTCODE = @PLANTCODE
		    AND PODATE    = @LS_PODATE
			
			SET @LI_SEQ = ISNULL(@LI_SEQ, 1)

			SET @LS_PONO = 'PO' + REPLACE(CONVERT(VARCHAR,GETDATE(),114),':','')
								+ RIGHT('00000' + CONVERT(VARCHAR,@LI_SEQ),4)
			-- 발주 번호 붙이기 (채번) (일정 규칙 PO + 날짜 + 10000개 행까지 0001 이렇게)
		 INSERT INTO TB_POMake (PLANTCODE,	PONO,	ITEMCODE,	POQTY,	UNITCODE,	PODATE,
								CUSTCODE , MAKER,   MAKEDATE)
						VALUES (@PLANTCODE, @LS_PONO,@ITEMCODE, @POQTY, @UNITCODE, @LS_PODATE,
						        @CUSTCODE,  @MAKER  ,@LD_NOWDATE)

	   SET @RS_CODE = 'S'

END
GO
