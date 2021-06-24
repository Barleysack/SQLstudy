USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[15MM_StockMM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이승수	
-- Create date: 2021-06-07
-- Description:	발주 및 입고 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[15MM_StockMM_S1] 
	@PLANTCODE VARCHAR(10),             --공장 코드
	@ITEMCODE  VARCHAR(20),				--품목
	@MATLOTNO  VARCHAR(30),			    --품목 명

	--밑에 3줄은 반드시 포함되어야 하는 부분이기 때문에 반드시 작성한다
	@LANG     VARCHAR(10) = 'KO',	    --언어
	@RS_CODE  VARCHAR(10)  OUTPUT,		--성공 여부
	@RS_MSG   VARCHAR(200)  OUTPUT		--성공 관련 메세지

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
	  ,A.MAKER
	  ,A.MAKEDATE
FROM TB_StockMM A JOIN TB_ItemMaster B ON A.ITEMCODE = B.ITEMCODE
JOIN TB_CustMaster C ON A.CUSTCODE = C.CUSTCODE
	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE  LIKE '%' + @ITEMCODE + '%'
	   AND A.MATLOTNO      LIKE '%' + @MATLOTNO + '%'
	   AND B.ITEMTYPE = 'ROH'

	  	
 END	
GO
