USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[16PP_StockPP_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이진
-- Create date: 2021-06-10
-- Description:	자재 생산 출고 관리 조회
-- =============================================
CREATE PROCEDURE [dbo].[16PP_StockPP_S1]
	@PLANTCODE       VARCHAR(10)   --공장
   ,@ITEMCODE        VARCHAR(10)   --품목
   ,@LOTNO        VARCHAR(10)   --LOTNO
  
   ,@LANG     VARCHAR(5) = 'KO'
   ,@RS_CODE  VARCHAR(1)   OUTPUT
   ,@RS_MSG   VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT  0 AS CHK										-- 선택 
          , A.PLANTCODE										-- 공장 
          , CONVERT(VARCHAR, A.MAKEDATE, 23) AS MAKEDATE	-- 입고일자 
          , A.ITEMCODE										-- 품목 
          , B.ITEMNAME										-- 품목명 
          , A.LOTNO	     as LOTNO									-- LOTNO 
          , B.ITEMTYPE										-- 수량 
          , A.STOCKQTY										-- 단위 
          , A.UNITCODE									    -- 창고 
          , A.WHCODE				-- 입고자 

	  FROM TB_StockPP A WITH(NOLOCK) 
	  JOIN TB_ItemMaster B WITH(NOLOCK)
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.ITEMCODE  = B.ITEMCODE
	 
	 WHERE A.PLANTCODE           LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE            LIKE '%' + @ITEMCODE  + '%'
	   AND A.LOTNO            LIKE '%' + @LOTNO  + '%'
	 AND ISNULL(A.STOCKQTY,0)  <> 0 --재고인 경우만 조회
			
	   
END
GO
