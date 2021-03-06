USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_4_Inspection_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		4조
-- Create date: 2021-06-22
-- Description:	검사항목 마스터 추가
-- =============================================
CREATE PROCEDURE [dbo].[BM_4_Inspection_I1] 
	 @INSPCODE		VARCHAR(10)				-- 검사코드
	,@INSPDETAIL	VARCHAR(200)			-- 검사내용
	,@MAKER			VARCHAR(30)				-- MAKER

	,@LANG			VARCHAR(10)	=	'KO'
	,@RS_CODE		VARCHAR(1)		OUTPUT
	,@RS_MSG		VARCHAR(200)	OUTPUT
AS
BEGIN
	-- 시간
	DECLARE @LS_NOWDATE VARCHAR(10)
	SET @LS_NOWDATE  = CONVERT(VARCHAR,GETDATE(),23)

	-- 중복되는 코드
	IF(SELECT COUNT(*) FROM TB_4_INSPMaster WHERE INSPCODE = @INSPCODE)<>0
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG =  '중복 검사코드가 있습니다.'
	END

	INSERT INTO TB_4_INSPMaster ( INSPCODE,		INSPDETAIL,		MAKER,	MAKEDATE)
						 VALUES ( @INSPCODE,	@INSPDETAIL,	@MAKER, @LS_NOWDATE)

	SET @RS_CODE = 'S'
	 
END
GO
