USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[01PP_STockHALB_S1]    Script Date: 2021-06-22 오후 5:42:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강유정
-- Create date: 2021-06-15
-- Description:	재공 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[01PP_STockHALB_S1]
	 @PLANTCODE  VARCHAR(10)  --공장
	,@ITEMTYPE   VARCHAR(10)  --품목
    ,@LOTNO   VARCHAR(10)  --lot

	,@LANG     VARCHAR(5) = 'KO'
    ,@RS_CODE  VARCHAR(1)   OUTPUT
    ,@RS_MSG   VARCHAR(200) OUTPUT
AS
BEGIN 
	SELECT A.PLANTCODE
	      ,A.ITEMCODE
		  ,C.ITEMNAME
		  ,C.ITEMTYPE
		  ,A.LOTNO
		  ,A.WORKCENTERCODE
		  ,B.WORKCENTERNAME
		  ,A.STOCKQTY
		  ,A.UNITCODE

	  FROM TB_StockHALB A LEFT JOIN TB_WorkCenterMaster B
						  ON  A.PLANTCODE = B.PLANTCODE
						  AND A.WORKCENTERCODE = B.WORKCENTERCODE
									  
									  LEFT JOIN TB_ItemMaster C
									  ON A.PLANTCODE = C.PLANTCODE
									  AND A.ITEMCODE = C.ITEMCODE
									  

	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE   + '%'
	   AND C.ITEMTYPE LIKE '%'  + @ITEMTYPE   + '%'
	   AND A.LOTNO LIKE '%'     + @LOTNO   + '%'
END
GO
