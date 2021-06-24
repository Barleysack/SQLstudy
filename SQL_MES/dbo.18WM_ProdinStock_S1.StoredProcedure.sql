USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18WM_ProdinStock_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-16
-- Description:	제품 창고 입고 대상 조회
-- =============================================
CREATE PROCEDURE [dbo].[18WM_ProdinStock_S1]
	@PLANTCODE VARCHAR(10)
   ,@STARTDATE VARCHAR(10)
   ,@ENDDATE   VARCHAR(10)
   ,@ITEMCODE  VARCHAR(30)

   ,@LANG      VARCHAR(10) = 'KO'
   ,@RS_CODE   VARCHAR(1)   OUTPUT
   ,@RS_MSG    VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT 0                                           AS CHK
		  ,A.PLANTCODE                                 AS PLANTCODE
		  ,A.LOTNO									   AS LOTNO
		  ,A.ITEMCODE								   AS ITEMCODE
		  ,B.ITEMNAME								   AS ITEMNAME
		  ,DBO.FN_CODENAME('ITEMTYPE',B.ITEMTYPE,'KO') AS ITEMTYPE
		  ,DBO.FN_CODENAME('WHCODE', A.WHCODE, 'KO')  AS WHCODE
		  ,A.STOCKQTY                                  AS STOCKQTY
		  ,B.BASEUNIT								   AS UNITCODE
		  ,CASE WHEN B.INSPFLAG = 'I' THEN '[I] 검사'
					ELSE '[U] 무검사' END AS INSPFLAG							
		  ,A.INSPRESULT								   AS INSPRESULT
		  ,A.MAKEDATE								   AS MAKEDATE
		  ,DBO.FN_WORKERNAME(A.MAKER)                  AS WORKER
	  FROM TB_StockPP A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B
	                                        ON A.PLANTCODE = B.PLANTCODE
										   AND A.ITEMCODE  = B.ITEMCODE
	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
	   AND A.MAKEDATE  BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'
	   AND B.ITEMTYPE = 'FERT'
END
GO
