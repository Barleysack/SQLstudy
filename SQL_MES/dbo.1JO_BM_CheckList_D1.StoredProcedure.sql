USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[1JO_BM_CheckList_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이승수
-- Create date: 2021-06-18
-- Description:	검사 항목 마스터 삭제
-- =============================================
CREATE PROCEDURE [dbo].[1JO_BM_CheckList_D1]
    @PLANTCODE VARCHAR(10),
	@CHECKCODE VARCHAR(10),         -- 공장코드

	@LANG      VARCHAR(10)  = 'KO', -- 언어
	@RS_CODE   VARCHAR(1)   OUTPUT,
	@RS_MSG	   VARCHAR(200) OUTPUT
AS
BEGIN
	DELETE TB_CheckMaster
	 WHERE CHECKCODE  = @CHECKCODE
	     AND PLANTCODE = @PLANTCODE
	 
	SET @RS_CODE = 'S';
	SET @RS_MSG  = '정상적으로 삭제 하였습니다.';
END
GO
