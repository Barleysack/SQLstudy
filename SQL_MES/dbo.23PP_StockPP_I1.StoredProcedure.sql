USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[23PP_StockPP_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		한정은
-- Create date: 2021-06-10
-- Description:	자재 생산 출고 관리 '조회'
-- =============================================
CREATE PROCEDURE [dbo].[23PP_StockPP_I1]                         
(                               
   @PlantCode VARCHAR(10)  
  ,@LotNo     VARCHAR(30)
  ,@ItemType  VARCHAR(30)
  
  ,@Lang	  VARCHAR(10)  ='KO'
  ,@RS_CODE   VARCHAR(1)   OUTPUT
  ,@RS_MSG    VARCHAR(200) OUTPUT
)                                 
AS                                 
BEGIN 

	SELECT 0 AS CHK     -- 선택
		   ,A.PLANTCODE --공장
		   ,A.ITEMCODE  -- 품목
		   ,B.ITEMNAME  -- 품목명
		   ,A.LOTNO     -- LOTNO
		   ,B.ITEMTYPE  -- 품목구분
		   ,A.STOCKQTY	-- 수량
		   ,A.UNITCODE	-- 단위
		   ,A.WHCODE	-- 입고창고
		FROM TB_StockPP A LEFT JOIN TB_ItemMaster B
		                         ON A.PLANTCODE = A.PLANTCODE
								AND A.ITEMCODE  = B.ITEMCODE
		WHERE A.PLANTCODE LIKE '%' + @PlantCode + '%'
	      AND B.ITEMTYPE  LIKE '%' + @ItemType  + '%'
	      AND A.LOTNO     LIKE '%' +  @LotNo    + '%'
		  AND ISNULL(A.STOCKQTY, 0) <> 0

END 
GO
