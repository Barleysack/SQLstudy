USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[16MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이진
-- Create date: 2021-06-09
-- Description:	자재 생산 출고 관리 조회
-- =============================================
CREATE PROCEDURE [dbo].[16MM_StockOUT_S1]
	@PLANTCODE       VARCHAR(10)   --공장
   ,@ITEMCODE        VARCHAR(10)   --품목
   ,@MATLOTNO        VARCHAR(10)   --LOTNO
   ,@WHCODE          VARCHAR(10)   --창고
   ,@STORAGELOCCODE  VARCHAR(10)   --창고저장위치
   ,@STARTDATE       VARCHAR(10)   --시작
   ,@ENDDATE         VARCHAR(10)   --종료

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
          , A.MATLOTNO										-- LOTNO 
          , A.STOCKQTY										-- 수량 
          , A.UNITCODE										-- 단위 
          , A.WHCODE									    -- 창고 
          , DBO.FN_WORKERNAME(A.MAKER) AS MAKER				-- 입고자 

	  FROM TB_StockMM A WITH(NOLOCK)
	  JOIN TB_ItemMaster B WITH(NOLOCK)
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.ITEMCODE  = B.ITEMCODE
	 
	 WHERE A.PLANTCODE           LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE            LIKE '%' + @ITEMCODE  + '%'
	   AND A.MATLOTNO            LIKE '%' + @MATLOTNO  + '%'
	   AND ISNULL(A.STOCKQTY,0)  <> 0 --재고인 경우만 조회
	   AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN @STARTDATE AND @ENDDATE
	   
END
GO
