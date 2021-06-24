USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[22MM_PoMake_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		한윤태
-- Create date: 2021-06-07
-- Description:	발주 및 입고 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[22MM_PoMake_S1]
	@PLANTCODE VARCHAR(10),
	@CUSTCODE VARCHAR(20),
	@PONO VARCHAR(30),
	@STARTDATE VARCHAR(10),
	@ENDDATE VARCHAR(10),

	@LANG VARCHAR(10) = 'KO',
	@RS_CODE VARCHAR(10) OUTPUT,   -- 성공여부
	@RS_MSG VARCHAR(200) OUTPUT    -- 성공여부 관련 메세지
AS
BEGIN
	SELECT PLANTCODE,
	       PONO,
		   ITEMCODE,
		   PODATE,
		   POQTY,
		   UNITCODE,
		   CUSTCODE,
		   CASE WHEN ISNULL(INFLAG, 'N') = 'Y' THEN 1
		   ELSE 0 END AS CHK,
		   LOTNO,
		   INQTY,
		   INDATE,
		   DBO.FN_WORKERNAME(INWORKER) AS INWORKER,
		   DBO.FN_WORKERNAME(MAKER) AS MAKER,
		   CONVERT(VARCHAR, MAKEDATE, 120) AS MAKEDATE,
		   DBO.FN_WORKERNAME(EDITOR) AS EDITOR,
		   CONVERT(VARCHAR, EDITDATE, 120) AS EDITDATE
	FROM TB_POMake WITH(NOLOCK)
	WHERE PLANTCODE LIKE '%' + @PLANTCODE + '%' 
	AND CUSTCODE LIKE '%' + @CUSTCODE + '%'
	AND PONO LIKE '%' + @PONO + '%'
	AND PODATE BETWEEN @STARTDATE AND @ENDDATE
END
GO
