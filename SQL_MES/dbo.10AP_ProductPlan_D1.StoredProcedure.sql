USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10AP_ProductPlan_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<마상우>
-- Create date: <2021-06-09>
-- Description:	<생산계획 및 작업지시 편성내역 삭제>
-- =============================================
CREATE PROCEDURE [dbo].[10AP_ProductPlan_D1]

	 @PLANTCODE			 VARCHAR(10) -- 공장    
	,@PLANNO             VARCHAR(10) -- 계획번호

	
	,@LANG				 VARCHAR(5)    = 'KO'
	,@RS_CODE			 VARCHAR(1)   OUTPUT
	,@RS_MSG			 VARCHAR(200) OUTPUT
AS
BEGIN
	IF(SELECT ISNULL(ORDERFLAG,'N')
		FROM TB_ProductPlan WITH(NOLOCK)
	   WHERE PLANTCODE = @PLANTCODE
	     AND PLANNO =    @PLANNO) = 'Y'
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG  = '이미 작업지시가 확정된 계획입니다.'
		RETURN
	END

	ELSE
		BEGIN
			DELETE TB_ProductPlan
			  WHERE PLANTCODE = @PLANTCODE
				AND PLANNO =    @PLANNO
		END
SET @RS_CODE = 'S'
END
GO
