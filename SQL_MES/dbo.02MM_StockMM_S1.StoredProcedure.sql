USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02MM_StockMM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-08
-- Description:	자재 재고 현황
-- =============================================
CREATE PROCEDURE [dbo].[02MM_StockMM_S1]
     @PLANTCODE VARCHAR(10)   --공장 코드
    ,@ITEMCODE VARCHAR(20)    -- 품목코드
    ,@ITEMNAME VARCHAR(20)    -- 품목명

	,@LANG VARCHAR(10) = 'KO'		-- 언어
	,@RS_CODE VARCHAR(10) OUTPUT	-- 성공 여부
	,@RS_MSG VARCHAR(200) OUTPUT	-- 성공 관련 메세지
AS
BEGIN
	SELECT A.PLANTCODE
          ,A.ITEMCODE
		  ,B.ITEMNAME
		  ,A.MATLOTNO
		  ,A.WHCODE
		  ,A.STOCKQTY
		  ,A.UNITCODE
		  ,A.CUSTCODE
		  ,C.CUSTNAME
		  ,DBO.FN_WORKERNAME(A.MAKER) AS MAKER
		  ,A.MAKEDATE
     FROM TB_StockMM AS A WITH(NOLOCK)
     LEFT OUTER JOIN TB_ItemMaster AS B
             ON A.ITEMCODE = B.ITEMCODE
     LEFT OUTER JOIN TB_CustMaster AS C
             ON A.CUSTCODE = C.CUSTCODE
	 WHERE B.ITEMTYPE   LIKE '%' + 'ROH'  + '%'
	   AND A.PLANTCODE	LIKE '%' + @PLANTCODE  + '%'
	   AND A.ITEMCODE	LIKE '%' + @ITEMCODE	  + '%'
	   AND B.ITEMNAME	LIKE '%' + @ITEMNAME + '%'
END
GO
