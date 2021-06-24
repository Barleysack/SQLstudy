USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18WM_Inspection_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		4조
-- Create date: 2021-06-18
-- Description:	완제품 수입검사 이력 등록
-- =============================================
CREATE PROCEDURE [dbo].[18WM_Inspection_I1] 
	 @PLANTCODE			VARCHAR(10)				-- 공장
	,@ITEMCODE			VARCHAR(20)				-- 품목
	,@WHCODE			VARCHAR(10)				-- 창고
	,@LOTNO				VARCHAR(20)				-- LOTNO
	,@MAKER				VARCHAR(20)				-- 검사자
	,@INSPNO			VARCHAR(20)				-- INSPNO
	,@INSP				VARCHAR(200)			-- 검사항목
	,@INSPRESULT_B		VARCHAR(1)				-- 검사 결과
	,@STOCKQTY			FLOAT					-- 제품 수량

	,@LANG				VARCHAR(10)	='KO'
	,@RS_CODE			VARCHAR(1)		OUTPUT
	,@RS_MSG			VARCHAR(200)	OUTPUT
AS
BEGIN
	-- 현재 시간 정의
	DECLARE @LD_NOWDATE		DATETIME
	       ,@LS_NOWDATE		VARCHAR(10)
		   ,@LS_WORKER		VARCHAR(20)		
		   ,@INSPRESULT		VARCHAR(1)	= 'N'		-- 검사 결과

	   SET @LD_NOWDATE = GETDATE()
	   SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

	-- 검사번호 채번
	DECLARE @LS_INSPNO	VARCHAR(30)
		SET @LS_INSPNO = 'SHIP' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),' ','')
	
	-- 검사 이력 (상세) 등록	(TB_5_INSPrec_B)	
	DECLARE @LI_INSPSEQ	VARCHAR(20)
	SELECT @LI_INSPSEQ = ISNULL(MAX(INSPSEQ),0) + 1
	  FROM TB_4_FERTINSPrec_B WITH(NOLOCK) 
	 WHERE PLANTCODE = @PLANTCODE 
	   AND INSPNO = @LS_INSPNO 
	INSERT INTO TB_4_FERTINSPrec_B (INSPNO,		INSPSEQ,		PLANTCODE,	ITEMCODE,	LOTNO,	WHCODE,		INSP,	INSPRESULT_B,	MAKER,	MAKEDATE) 
							VALUES (@LS_INSPNO,	@LI_INSPSEQ,	@PLANTCODE,	@ITEMCODE,	@LOTNO,	@WHCODE,	@INSP,	@INSPRESULT_B,	@MAKER,	@LS_NOWDATE)	


	-- 검사 최종 결과
		IF ( SELECT COUNT(*)
			   FROM TB_4_FERTINSPrec_B WITH(NOLOCK)
			  WHERE INSPNO = @LS_INSPNO
			    AND INSPRESULT_B = 'N' ) = 0
		BEGIN
			SET @INSPRESULT = 'Y'
		END
	-- 검사 이력 (공통) 등록	(TB_5_INSPrec)
		INSERT INTO TB_4_FERTINSPrec(INSPNO,		PLANTCODE,		ITEMCODE,	LOTNO,		WHCODE,		INSPRESULT,		MAKER,	MAKEDATE)
							 VALUES (@LS_INSPNO,	@PLANTCODE,		@ITEMCODE,	@LOTNO,		@WHCODE,	@INSPRESULT,	@MAKER,	@LS_NOWDATE)
	
		-- 검사 이력 업데이트	(TB_STOCKPP)
	UPDATE TB_StockPP
	   SET INSPRESULT = @INSPRESULT
	 WHERE PLANTCODE	= @PLANTCODE
	   AND ITEMCODE		= @ITEMCODE
	   AND LOTNO		= @LOTNO
	-- 합격품 제품창고 입고		(TB_STOCKWM)
	INSERT INTO TB_StockWM ( PLANTCODE,	LOTNO,	ITEMCODE,	WHCODE,		STOCKQTY,	MAKEDATE,		MAKER)
					VALUES ( @PLANTCODE,@LOTNO,	@ITEMCODE,	@WHCODE,	@STOCKQTY,	@LS_NOWDATE,	 @MAKER)
		SET @RS_CODE = 'S'
END
GO
