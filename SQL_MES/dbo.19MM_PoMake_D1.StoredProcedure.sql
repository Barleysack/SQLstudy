USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19MM_PoMake_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-08
-- Description:	발주 내역 삭제
-- =============================================
CREATE PROCEDURE [dbo].[19MM_PoMake_D1]
    @PLANTCODE VARCHAR(10),
    @PONO      VARCHAR(30),

    @LANG      VARCHAR(10) ='KO',
    @RS_CODE   VARCHAR(1) OUTPUT,
    @RS_MSG    VARCHAR(200) OUTPUT
AS

BEGIN
	IF (SELECT ISNULL(INFLAG,'N')
	     FROM TB_POMAKE WITH(NOLOCK)
		WHERE PLANTCODE = @PLANTCODE
		  AND PONO      = @PONO) ='Y'  --소스에서도 체크하고 DB에서도 체크해야한다.

	BEGIN
		SET @RS_CODE = 'Y'
		SET @RS_MSG = '이미 입고된 발주 입니다.'
		RETURN;
		

		DELETE TB_POMAKE
		WHERE PLANTCODE = @PLANTCODE
		  AND PONO      = @PONO
	END

END
GO
