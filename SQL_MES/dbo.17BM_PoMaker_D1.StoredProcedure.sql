USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[17BM_PoMaker_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 21-06-08
-- Description:	발주 내역 삭제
-- =============================================
CREATE PROCEDURE [dbo].[17BM_PoMaker_D1]
	-- Add the parameters for the stored procedure here
	@PLANTCODE VARCHAR(10),        -- 공장 코드
	@PONO      VARCHAR(30),        -- 발주 번호
	

	@LANG      VARCHAR(10) = 'KO', -- 언어 값 넣어주지 않으면 기본값 KO
	@RS_CODE   VARCHAR(1)  OUTPUT,
	@RS_MSG    VARCHAR(200)OUTPUT
AS
BEGIN
	IF ( SELECT ISNULL(INFLAG,'N')
	       FROM TB_POMake WITH (NOLOCK)
		  WHERE PLANTCODE = @PLANTCODE
		    AND PONO      = @PONO)  = 'Y'
	BEGIN
	     SET @RS_CODE = 'E'
		 SET @RS_MSG  = '이미 입고된 발주입니다.'
		 RETURN
	  END -- 더블 배리데이션 체크 (C# + SSMS) 동시 TWO 컴이 조회하고 삭제할 때 체크
    
	DELETE TB_POMake
	 WHERE PLANTCODE = @PLANTCODE
	   AND PONO      = @PONO;

	   SET @RS_CODE = 'S'

END
GO
