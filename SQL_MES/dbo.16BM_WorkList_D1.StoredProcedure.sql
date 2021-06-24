USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[16BM_WorkList_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이진
-- Create date: 2021-06-07
-- Description:	작업자 마스터 삭제
-- =============================================
CREATE PROCEDURE [dbo].[16BM_WorkList_D1]
	@PLANTCODE VARCHAR(10),  --공장코드
	@WORKERID  VARCHAR(20),   --작업자 코드

	@LANG       VARCHAR(10)  = 'KO',    --언어
	@RS_CODE    VARCHAR(1)  OUTPUT,   --성공 여부
	@RS_MSG     VARCHAR(200) OUTPUT    --성공관련메세지
AS
BEGIN
	DELETE TB_WorkerList
	 WHERE PLANTCODE= @PLANTCODE
	   AND WORKERID = @WORKERID

	  SET @RS_CODE = 'S'
	  SET @RS_MSG  = '정상적으로 삭제 하였습니다.'
END
GO
