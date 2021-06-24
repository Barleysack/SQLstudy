USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[04AP_ProductPlan_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보성
-- Create date: 210609
-- Description:	생산 계획 편성 취소 
-- =============================================
CREATE PROCEDURE [dbo].[04AP_ProductPlan_D1]
	-- Add the parameters for the stored procedure here
	@PLANTCODE   VARCHAR(10)
	,@PLANNO	VARCHAR(20)
	,@LANG		VARCHAR(10)   ='KO'
	,@RS_CODE	VARCHAR(1)    OUTPUT
	,@RS_MSG	VARCHAR(200)  OUTPUT --결과를 보내기 위한 변수를 정해둔 것이라.


AS
BEGIN
	IF (SELECT ISNULL(ORDERFLAG,'N')
			FROM TB_ProductPlan WITH(NOLOCK)
			WHERE PLANTCODE = @PLANTCODE
			AND PLANNO = @PLANNO) ='Y'
		BEGIN 
		SET @RS_CODE = 'E'
		SET @RS_MSG = '이미 작업지시가 확정된 계획입니다.'
		RETURN; 
		END
		ELSE
		BEGIN
			DELETE TB_ProductPlan
			WHERE	PLANTCODE = @PLANTCODE
			AND	PLANNO = @PLANNO
		END
		SET @RS_CODE='S'
END
GO
