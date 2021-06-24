USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03BM_PoMake_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보민
-- Create date: 2021-06-07
-- Description:	발주 내역 삭제
-- =============================================-
CREATE PROCEDURE [dbo].[03BM_PoMake_D1]
	-- Add the parameters for the stored procedure here
	@PLANTCODE VARCHAR(10),				    -- 공장코드
	@PONO	   VARCHAR(30),					-- 발주번호

	@LANG	   VARCHAR(10) = 'KO',			-- 언어
	@RS_CODE   VARCHAR(1)	OUTPUT,			-- 성공여부
	@RS_MSG	   VARCHAR(200) OUTPUT			-- 성공관련 메세지
AS
BEGIN
	IF(SELECT ISNULL(INFLAG, 'N')
		 FROM TB_POMake WITH(NOLOCK) 
		WHERE PLANTCODE = @PLANTCODE
		  AND PONO      = @PONO) = 'Y'
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '이미 입고된 발주 입니다.'
		RETURN;
	END
END
GO
