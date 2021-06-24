USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[23AP_ProductPlan_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		한정은
-- Create date: 2021-06-09
-- Description:	생산 계획 편성 취소
-- =============================================
CREATE PROCEDURE [dbo].[23AP_ProductPlan_D1]
	@PLANTCODE VARCHAR(10) --공장
	,@PLANNO   VARCHAR(20) --계획번호

	,@LANG     VARCHAR(10) = 'OK'
	,@RS_CODE  VARCHAR(1)   OUTPUT -- OUTPUT : 프로시저 내부에서 처리된 변수를 C#에 보내기 위해 사용
	,@RS_MSG   VARCHAR(200) OUTPUT 

AS
BEGIN
	-- 작업지시가 확정 되어 있는지 확인.
	if (SELECT ISNULL(ORDERFLAG, 'N') 
			FROM TB_ProductPlan WITH (NOLOCK)
		WHERE PLANTCODE = @PLANTCODE
		AND PLANNO = @PLANNO) = 'Y'

	BEGIN 
		SET @RS_CODE = 'N'
		SET @RS_MSG = '이미 작업지시가 확정된 계획입니다.'
		return;
	END
	ELSE
	BEGIN
		DELETE TB_ProductPlan
	       	WHERE PLANTCODE = @PLANTCODE
				AND PLANNO  = @PLANNO
	END

	SET @RS_CODE = 'S'
END
GO
