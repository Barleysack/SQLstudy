USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[21MM_StockMM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		최민준
-- Create date: 2021-06-07
-- Description:	작업자 마스터 조회
-- =============================================
CREATE PROCEDURE [dbo].[21MM_StockMM_S1]
	@PLANTCODE   VARCHAR(10),           -- 공장 코드
	@ITEMCODE   VARCHAR(20),            -- 제품 코드
	@ITEMNAME   VARCHAR(20),            --  제품 명
	

	@LANG       VARCHAR(10) = 'KO',         -- 언어
	@RS_CODE    VARCHAR(10) OUTPUT,      -- 성공 여부
	@RS_MSG     VARCHAR(200) OUTPUT       -- 성공 관련 메세지  아래 3개는 꼭 포함되어야 하는 구문


AS
BEGIN
	SELECT A.PLANTCODE,    -- 공장
		   A.ITEMCODE,     -- 품목
		   B.ITEMNAME,     -- 품목 명
		   A.MATLOTNO,     -- LOTNO
		   A.WHCODE,       -- 창고 
		   A.STOCKQTY,     -- 재고수량
		   A.UNITCODE,     -- 단위
		   A.CUSTCODE,     -- 거래처
		   C.CUSTNAME,     -- 거래처 명
		   A.MAKER,        -- 생성자
		   A.MAKEDATE      -- 생성일시
      FROM TB_StockMM A  WITH(NOLOCK)  -- 프롬셀렉트할때 꼭 써줘야함
	  JOIN TB_ItemMaster B
	    ON A.ITEMCODE    = B.ITEMCODE
	  JOIN TB_CustMaster C
	    ON A.CUSTCODE    = C.CUSTCODE
WHERE     A.PLANTCODE     LIKE '%' + @PLANTCODE + '%' 
	   AND A.ITEMCODE     LIKE '%' + @ITEMCODE + '%' 
	   AND B.ITEMNAME     LIKE '%' + @ITEMNAME + '%' 
	   AND B.ITEMTYPE = 'ROH'
END
GO
