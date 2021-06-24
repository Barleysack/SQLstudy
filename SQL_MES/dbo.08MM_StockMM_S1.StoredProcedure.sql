USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[08MM_StockMM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김종우
-- Create date: 2021-06-09
-- Description:	자재조회 [설계서1]
-- =============================================
CREATE PROCEDURE [dbo].[08MM_StockMM_S1] 
	@PLANTCODE VARCHAR(10),         -- 공장코드
	@ITEMCODE  VARCHAR(20),	        -- 품목
	@ITEMNAME  VARCHAR(20),         -- 품목 명

	@LANG VARCHAR(10)    = 'KO',    -- 언어
	@RS_CODE VARCHAR(10) OUTPUT,	-- 성공 여부
	@RS_MSG VARCHAR(200) OUTPUT		-- 성공 관련 메세지

AS
BEGIN
	SELECT A.PLANTCODE       -- 공장
		 , A.ITEMCODE		 -- 품목
		 , B.ITEMNAME	     -- 품목명
		 , A.MATLOTNO		 -- LOT번호
		 , A.WHCODE		     -- 창고
		 , A.STOCKQTY		 -- 재고수량
		 , A.UNITCODE		 -- 단위
		 , A.CUSTCODE		     -- 거래처
		 , C.CUSTNAME		 -- 거래처명
		 , DBO.FN_WORKERNAME(A.MAKER) AS MAKER	   -- 생성자
		 , A.MAKEDATE		 -- 등록일시
	  
	       FROM TB_StockMM A WITH(NOLOCK)
	  LEFT JOIN TB_ItemMaster B
			 ON A.ITEMCODE = B.ITEMCODE
	  LEFT JOIN TB_CustMaster C
			 ON A.CUSTCODE = C.CUSTCODE
		
	 WHERE A.PLANTCODE    LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE     LIKE '%' + @ITEMCODE  + '%'
	   AND B.ITEMNAME     LIKE '%' + @ITEMNAME  + '%'

END

GO
