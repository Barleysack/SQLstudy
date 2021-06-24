USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[17BM_WorkList_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 21-06-07
-- Description:	작업자 마스터 삭제
-- =============================================
CREATE PROCEDURE [dbo].[17BM_WorkList_D1]
	-- Add the parameters for the stored procedure here
	@PLANTCODE VARCHAR(10),        -- 공장 코드
	@WORKERID  VARCHAR(20),        -- 작업자 코드

	@LANG      VARCHAR(10) = 'KO', -- 언어 값 넣어주지 않으면 기본값 KO
	@RS_CODE   VARCHAR(1)  OUTPUT,
	@RS_MSG    VARCHAR(200)OUTPUT
AS
BEGIN
	DELETE TB_WorkerList
	 WHERE PLANTCODE = @PLANTCODE
	   AND WORKERID  = @WORKERID
	   
	SET @RS_CODE = 'S'
	SET @RS_MSG  = '정상적으로 삭제하였습니다.'
END
GO
