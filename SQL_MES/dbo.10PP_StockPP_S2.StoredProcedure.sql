USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10PP_StockPP_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<마상우>
-- Create date: <2021-06-16>
-- Description:	완제품 바코드 발행 데이터 조회
-- =============================================
CREATE PROCEDURE [dbo].[10PP_StockPP_S2]
	-- Add the parameters for the stored procedure here
	 @PLANTCODE			 VARCHAR(10) -- 공장      
	,@LOTNO 			 VARCHAR(20) -- LOTNO
	
	,@LANG				 VARCHAR(5)    = 'KO'
	,@RS_CODE			 VARCHAR(1)   OUTPUT
	,@RS_MSG			 VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT A.LOTNO                                        AS LOTNO
		  ,A.ITEMCODE                                     AS ITMECODE
		  ,B.ITEMNAME                                     AS ITEMNAME
		  ,B.ITEMSPEC                                     AS ITEMSPEC
		  ,CONVERT(VARCHAR, A.MAKEDATE, 120)              AS PRODDATE
		  ,CONVERT(VARCHAR, A.STOCKQTY) + ' ' +B.BASEUNIT AS LOTQTY
  FROM TB_StockPP A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											ON A.PLANTCODE = B.PLANTCODE
										   AND A.ITEMCODE  = B.ITEMCODE
    WHERE A.PLANTCODE = @PLANTCODE
      AND A.LOTNO     = @LOTNO



END
GO
