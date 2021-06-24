USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[22BM_WorkList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		한윤태
-- Create date: 2021-06-07
-- Description:	작업자 마스터 조회
-- =============================================
CREATE PROCEDURE [dbo].[22BM_WorkList_S1]
	@PLANTCODE VARCHAR(10),
	@WORKERID VARCHAR(20),
	@WORKERNAME VARCHAR(20),
	@BANCODE VARCHAR(10),
	@USEFLAG VARCHAR(10),

	@LANG VARCHAR(10) = 'KO',
	@RS_CODE VARCHAR(10) OUTPUT,   -- 성공여부
	@RS_MSG VARCHAR(200) OUTPUT    -- 성공여부 관련 메세지
AS
BEGIN
	SELECT A.PLANTCODE, 
		   A.WORKERID, 
		   A.WORKERNAME, 
		   A.BANCODE, 
		   A.GRPID, 
		   A.DEPTCODE, 
		   A.PHONENO, 
		   A.INDATE, 
		   A.OUTDATE, 
		   A.USEFLAG, 
		   DBO.FN_WORKERNAME(A.MAKER) AS MAKER, 
		   A.MAKEDATE, 
		   DBO.FN_WORKERNAME(A.EDITOR) AS EDITOR, 
		   A.EDITDATE
	FROM TB_WorkerList A WITH(NOLOCK)
	WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	AND A.WORKERID LIKE '%' + @WORKERID + '%'
	AND A.WORKERNAME LIKE '%' + @WORKERNAME + '%'
	AND ISNULL(A.BANCODE, '') LIKE '%' + @BANCODE + '%'
	AND A.USEFLAG LIKE '%' + @USEFLAG + '%'
END
GO
