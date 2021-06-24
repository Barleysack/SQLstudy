USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[06MM_PoMake_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김얼
-- Create date: 2021-06-08
-- Description:	발주 내역 삭제
-- =============================================
CREATE PROCEDURE [dbo].[06MM_PoMake_D1] 
		@PLANTCODE VARCHAR(10), 
		@PONO      VARCHAR(30), 

		@LANG      VARCHAR(10) = 'KO',
		@RS_CODE   VARCHAR(10) OUTPUT,
		@RS_MSG    VARCHAR(200) OUTPUT
AS
BEGIN
	IF(SELECT ISNULL(INFLAG,'N')
		 FROM TB_POMake WITH(NOLOCK)
		WHERE PLANTCODE = @PLANTCODE
		  AND PONO      = @PONO) = 'Y'
    BEGIN 
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '이미 입고된 발주 입니다.'
		RETURN ;
	END

	DELETE TB_POMake
	 WHERE PLANTCODE = @PLANTCODE
	   AND PONO      = @PONO;

	   SET @RS_CODE = 'S'
END
GO
