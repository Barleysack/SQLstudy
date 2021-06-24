USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[06PP_STockHALB_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김얼
-- Create date: 2021-06-15
-- Description:	재공 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[06PP_STockHALB_S1]
	@PLANTCODE VARCHAR(10)
   ,@ITEMTYPE  VARCHAR(20)
   ,@LOTNO     VARCHAR(30)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE        VARCHAR(1)    OUTPUT
   ,@RS_MSG         VARCHAR(200)  OUTPUT
AS
BEGIN
	SELECT A.PLANTCODE         AS PLANTCODE
		  ,A.ITEMCODE		   AS ITEMCODE
		  ,B.ITEMNAME		   AS ITEMNAME
		  ,B.ITEMTYPE		   AS ITEMTYPE
		  ,A.LOTNO			   AS LOTNO
		  ,A.WORKCENTERCODE	   AS WORKCENTERCODE
		  ,C.WORKCENTERNAME	   AS WORKCENTERNAME
		  ,A.STOCKQTY		   AS STOCKQTY
		  ,A.UNITCODE		   AS UNITCODE
	  FROM TB_StockHALB A WITH (NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											   ON A.PLANTCODE = B.PLANTCODE
											  AND A.ITEMCODE = B.ITEMCODE
										LEFT JOIN TB_WorkCenterMaster C WITH(NOLOCK)
											   ON A.PLANTCODE	   = C.PLANTCODE
											  AND A.WORKCENTERCODE = C.WORKCENTERCODE
	  WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	    AND B.ITEMTYPE  LIKE '%' + @ITEMTYPE  + '%'
		AND A.LOTNO     LIKE '%' + @LOTNO     + '%'

	   SET @RS_CODE = 'S'
	   SET @RS_MSG = '조회가 완료 되었습니다.'
END
GO
