USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[08PP_StockPP_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김종우
-- Create date: 2021-06-09
-- Description:	자재 출고 관리 조회
-- =============================================
CREATE PROCEDURE [dbo].[08PP_StockPP_S1] 
	@PLANTCODE VARCHAR(10),         
	@ITEMTYPE  VARCHAR(20),	       
	@MATLOTNO  VARCHAR(30),        

	@LANG    VARCHAR(10) = 'KO',    -- 언어
	@RS_CODE VARCHAR(10) OUTPUT,	-- 성공 여부
	@RS_MSG VARCHAR(200) OUTPUT		-- 성공 관련 메세지

AS
BEGIN
	SELECT 
		   0 AS CHK 
		  ,A.PLANTCODE
		  ,A.ITEMCODE
		  ,B.ITEMNAME
		  ,B.ITEMTYPE
		  ,A.LOTNO
		  ,A.STOCKQTY
		  ,A.UNITCODE
		  ,A.WHCODE
		  ,DBO.FN_WORKERNAME(A.MAKER)      AS MAKER      -- 입고자

	  FROM TB_StockPP A WITH(NOLOCK)
	  LEFT JOIN TB_ItemMaster B
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.ITEMCODE  = B.ITEMCODE

	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND B.ITEMTYPE  LIKE '%' + @ITEMTYPE  + '%'
	   AND A.LOTNO     LIKE '%' + @MATLOTNO  + '%'
	   AND ISNULL(A.STOCKQTY,0) <> 0

	   	  SET @RS_CODE = 'S'
END
GO
