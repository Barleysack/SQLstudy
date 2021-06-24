USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[17MM_StockMM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 2021-06-09
-- Description:	자재 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[17MM_StockMM_S1] 
	-- Add the parameters for the stored procedure here
	 @PLANTCODE VARCHAR(10)
	,@ITEMCODE  VARCHAR(10)
	,@ITEMNAME  VARCHAR(20)

	,@LANG        VARCHAR(10) = 'KO'     -- 언어
	,@RS_CODE     VARCHAR(10)  OUTPUT    -- 성공 여부
	,@RS_MSG      VARCHAR(200) OUTPUT     -- 성공 관련 메세지
	

AS	 
BEGIN
	SELECT A.PLANTCODE  AS PLANTCODE
		  ,A.ITEMCODE	AS ITEMCODE
		  ,B.ITEMNAME	AS ITEMNAME
		  ,A.MATLOTNO	AS MATLOTNO
		  ,A.WHCODE		AS WHCODE
		  ,A.STOCKQTY	AS STOCKQTY
		  ,A.UNITCODE	AS UNITCODE
		  ,A.CUSTCODE	AS CUSTCODE
		  ,C.CUSTNAME	AS CUSTNAME
		  ,A.MAKER		AS MAKER
		  ,A.MAKEDATE	AS MAKEDATE

	  FROM TB_StockMM A
	  LEFT JOIN TB_ItemMaster B
	    ON A.ITEMCODE = B.ITEMCODE
	  LEFT JOIN TB_CustMaster C
	    ON A.CUSTCODE = C.CUSTCODE
	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
	   AND B.ITEMNAME  LIKE '%' + @ITEMNAME  + '%'
	   AND B.ITEMTYPE = 'ROH'
END
GO
