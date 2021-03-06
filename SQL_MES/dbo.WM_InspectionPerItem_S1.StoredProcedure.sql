USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[WM_InspectionPerItem_S1]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-18
-- Description:	수입 검사 항목 조회
-- =============================================
CREATE PROCEDURE [dbo].[WM_InspectionPerItem_S1]
	@PLANTCODE VARCHAR(10)
	,@ITEMCODE VARCHAR(30)
	,@ITEMTYPE VARCHAR(10)

   ,@LANG       VARCHAR(10) = 'KO'
   ,@RS_CODE    VARCHAR(1)   OUTPUT
   ,@RS_MSG     VARCHAR(200) OUTPUT
AS
BEGIN
SELECT  A.PLANTCODE AS PLANTCODE
		,A.ITEMCODE AS ITEMCODE
		,A.ITEMNAME AS ITEMNAME
		,CASE WHEN INSPFLAG = 'I' THEN '[I] 검사'
					ELSE '[U] 무검사' END AS INSPFLAG
		FROM TB_ItemMaster A 
	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND  A.ITEMCODE LIKE '%' + @ITEMCODE + '%'
	   AND A.ITEMTYPE LIKE '%' +  @ITEMTYPE + '%'
	   AND A.INSPFLAG = 'I'
END

SELECT * FROM TB_4_INSPItem
GO
