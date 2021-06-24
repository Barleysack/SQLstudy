USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03PP_STockHALB_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보민
-- Create date: 21-06-15
-- Description:	재공재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[03PP_STockHALB_S1]
	@PLANTCODE      VARCHAR(10)
   ,@ITEMTYPE		VARCHAR(10)
   ,@LOTNO			VARCHAR(10)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE	    VARCHAR(1)    OUTPUT
   ,@RS_MSG			VARCHAR(200)  OUTPUT
AS
BEGIN
	SELECT A.PLANTCODE                                              AS PLANTCODE      -- 공장   
		  ,A.ITEMCODE		                                        AS ITEMCODE	      -- 품목 코드
		  ,B.ITEMNAME		                                        AS ITEMCODE	      -- 품목명
		  ,B.ITEMTYPE		                                        AS ITEMCODE	      -- 품목구분
		  ,A.LOTNO													AS LOTNO	      -- LOTNO
		  ,A.WORKCENTERCODE	                                        AS WORKCENTERCODE -- 작업장
		  ,A.WORKCENTERCODE	                                        AS WORKCENTERNAME -- 작업장명
	      ,A.STOCKQTY   		                                    AS STOCKQTY		  -- 재고수량
		  ,A.UNITCODE		                                        AS UNITCODE	      -- 단위
	  FROM  TB_StockHALB A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
	                                             ON A.PLANTCODE      = B.PLANTCODE
												AND A.ITEMCODE        = B.ITEMCODE
	 WHERE  A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND  B.ITEMTYPE  LIKE '%' + @ITEMTYPE  + '%'
	   AND  A.LOTNO		LIKE '%' + @LOTNO     + '%'
END
GO
