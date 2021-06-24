USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19PP_StockPP_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-16
-- Description:	완제품 바코드 발행 데이터 조회
-- =============================================
CREATE PROCEDURE [dbo].[19PP_StockPP_S2]
     @PLANTCODE   VARCHAR(10),     --공장 코드
	 @LOTNO		  VARCHAR(30),	   --완제품 LOT 번호

     @LANG	  VARCHAR(10) ='KO',   --언어
     @RS_CODE VARCHAR(10) OUTPUT,  --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT  --성공 관련 메세지

AS
BEGIN
	SELECT B.ITEMTYPE								      AS ITEMTYPE  -- 품목 타입
		 , A.LOTNO									      AS LOTNO	   -- 완제품 LOT 번호
		 , A.ITEMCODE								      AS ITEMCODE  -- 품목 코드
	     , B.ITEMNAME								      AS ITEMNAME  -- 품목 명
		 , B.ITEMSPEC 								      AS ITEMSPEC  -- 품목 규격
		 , CONVERT(varchar, a.makedate,120)			      AS PRODDATE  -- 생산 일시
		 , CONVERT(varchar, a.STOCKQTY) + '' + B.BASEUNIT AS LOTQTY	   -- 제품 수량 + 단위
		
	  FROM TB_StockPP A WITH(NOLOCK) 
	  LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.ITEMCODE  = B.ITEMCODE
	 WHERE A.PLANTCODE = @PLANTCODE
	   AND A.LOTNO     = @LOTNO

END

GO
