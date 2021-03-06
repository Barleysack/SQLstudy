USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_4_Inspection_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		4조
-- Create date: 2021-06-22
-- Description:	검사항목 마스터 수정
-- =============================================
CREATE PROCEDURE [dbo].[BM_4_Inspection_U1] 
	 @INSPCODE		VARCHAR(10)				-- 검사코드
	,@INSPDETAIL	VARCHAR(200)			-- 검사내용
	,@EDITOR		VARCHAR(30)				-- EDITOR

	,@LANG			VARCHAR(10)	=	'KO'
	,@RS_CODE		VARCHAR(1)		OUTPUT
	,@RS_MSG		VARCHAR(200)	OUTPUT
AS
BEGIN
	-- 시간
	DECLARE @LS_NOWDATE VARCHAR(10)
	SET @LS_NOWDATE  = CONVERT(VARCHAR,GETDATE(),23)


	-- 업데이트
	UPDATE TB_4_INSPMaster
	   SET INSPCODE		= @INSPCODE
	     , INSPDETAIL	= @INSPDETAIL
		 , EDITOR		= @EDITOR
		 , EDITDATE		= @LS_NOWDATE
	 WHERE INSPCODE		= @INSPCODE
	 
	 SET @RS_CODE = 'S'
END
GO
