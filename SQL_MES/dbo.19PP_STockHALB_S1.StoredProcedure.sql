USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19PP_STockHALB_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-15
-- Description:	재공 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[19PP_STockHALB_S1]
     @PLANTCODE       VARCHAR(10),     --공장 코드
	 @ITEMTYPE        VARCHAR(30),     --품목 타입
	 @LOTNO           VARCHAR(30),     --LOT번호

     @LANG	  VARCHAR(10) ='KO',      --언어
     @RS_CODE VARCHAR(10) OUTPUT,     --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT     --성공 관련 메세지

AS
BEGIN

	SELECT A.PLANTCODE          AS PLANTCODE        --공장 코드
		 , B.ITEMTYPE       	AS ITEMTYPE      	--품목 코드
		 , B.ITEMNAME       	AS ITEMNAME      	--품목명
		 , B.ITEMCODE       	AS ITEMCODE      	--품목코드
		 , A.LOTNO       		AS LOTNO      	    --LOT 번호
		 , A.WORKCENTERCODE 	AS WORKCENTERCODE  	--작업장 코드
		 , WORKCENTERNAME 		AS WORKCENTERNAME  	--작업장 이름
		 , A.STOCKQTY       	AS STOCKQTY      	--재공 재고
		 , A.UNITCODE       	AS UNITCODE      	--단위
	  FROM TB_StockHALB A WITH (NOLOCK)

	  JOIN TB_ItemMaster B WITH (NOLOCK)
	    ON A.PLANTCODE = B.PLANTCODE
       AND A.ITEMCODE  = B.ITEMCODE

	  JOIN TB_WorkCenterMaster C WITH (NOLOCK)
	    ON A.PLANTCODE       = C.PLANTCODE
	   AND A.WORKCENTERCODE  = C.WORKCENTERCODE

     WHERE A.PLANTCODE  LIKE '%' + @PLANTCODE + '%'
       AND B.ITEMTYPE   LIKE '%' + @ITEMTYPE + '%'
       AND A.LOTNO      LIKE '%' + @LOTNO + '%'
	   

END


GO
