USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[1JO_MM_StockCheckRec_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이승수, 한정은
-- Create date: 2021-06-18
-- Description:	검사이력 수정, 업데이트
-- =============================================
CREATE PROCEDURE [dbo].[1JO_MM_StockCheckRec_U1]
	@PLANTCODE	VARCHAR(10)  -- 공장 코드
   ,@CHECKCODE	VARCHAR(30)  -- 작업자 
   ,@EDITOR		VARCHAR(10) 
   ,@REMARK     VARCHAR(200) -- 불합격 비고
   ,@CHECKSEQ   VARCHAR(30)


   ,@LANG		VARCHAR(10)  = 'KO' -- 언어
   ,@RS_CODE	VARCHAR(1)   OUTPUT -- 성공 여부
   ,@RS_MSG		VARCHAR(200) OUTPUT	-- 성공 관련 메세지

AS
BEGIN
	--
	--SELECT @EACHCHECK		= EACHCHECK
	--  FROM TB_STOCKCHECK WTIH(NOLOCK)
	-- WHERE PLANTCODE		= @PLANTCODE
	--   AND CHECKCODE		= @CHECKCODE
	--   AND EACHCHECK		= @EACHCHECK
	--   AND LOTNO			= @LOTNO
		 


	--IF(@EACHCHECK = 'OK')
	--BEGIN
	--	SET @RS_CODE = 'E'
	--	SET @RS_MSG  = '합격이므로 수정할 수 없습니다.'
	--	RETURN
	--END
	--현재 시간 정의
	DECLARE @LD_NOWDATE	DATETIME
		   ,@LS_NOWDATE VARCHAR(10)
		SET @LD_NOWDATE = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)


	UPDATE TB_STOCKCHECK
	    SET REMARK   = @REMARK
		   ,EDITOR	 = @EDITOR
		   ,EDITDATE = @LD_NOWDATE
	 WHERE PLANTCODE = @PLANTCODE
	   AND CHECKCODE = @CHECKCODE
	   AND CHECKSEQ  = @CHECKSEQ

	SET @RS_CODE = 'S'
END
GO
