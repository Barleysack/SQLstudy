USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_4_Inspection_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		4조
-- Create date: 2021-06-22
-- Description:	검사항목 마스터 삭제
-- =============================================
CREATE PROCEDURE [dbo].[BM_4_Inspection_D1] 
	 @INSPCODE		VARCHAR(20)				-- 검사코드
	,@INSPDETAIL	VARCHAR(200)			-- 검사내용

	,@LANG			VARCHAR(10)	=	'KO'
	,@RS_CODE		VARCHAR(1)		OUTPUT
	,@RS_MSG		VARCHAR(200)	OUTPUT
AS
BEGIN
	DELETE TB_4_INSPMaster
	 WHERE INSPCODE		= @INSPCODE
	   AND INSPDETAIL	= @INSPDETAIL

	SET @RS_CODE = 'S'
END
GO
