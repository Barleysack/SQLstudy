USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[15MM_PoMake_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이승수
-- Create date: 2021-06-07
-- Description:	발주 내역 등록
-- =============================================
CREATE PROCEDURE [dbo].[15MM_PoMake_D1]
	@PLANTCODE VARCHAR(10),    --공장 코드
	@PONO VARCHAR(20),			--발주번호
	
	@LANG	VARCHAR(10) = 'KO',   --값을 넣어주지 않으면 기본값을 KO로 넣는다는 의미
	@RS_CODE VARCHAR(1) OUTPUT,
	@RS_MSG VARCHAR(200) OUTPUT
AS
BEGIN
	IF(SELECT ISNULL(INFLAG,'N')
		 FROM TB_POMake WITH(NOLOCK)
		WHERE PLANTCODE = @PLANTCODE
		  AND PONO      = @PONO) = 'Y'
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '이미 입고된 발주 입니다.'
		RETURN;
	END
	
	DELETE TB_POMake
	 WHERE PLANTCODE = @PLANTCODE
	   AND PONO = @PONO
END
GO
