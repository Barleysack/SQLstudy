USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[04PP_StockPP_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보성

-- Description:	STOCKPP 조회
-- =============================================
CREATE PROCEDURE [dbo].[04PP_StockPP_S1]
@PLANTCODE VARCHAR(20)
,@ITEMTYPE VARCHAR(20)
,@LOTNO	VARCHAR(20)


	,@LANG				 VARCHAR(5)    = 'KO'
	,@RS_CODE			 VARCHAR(1)   OUTPUT
	,@RS_MSG			 VARCHAR(200) OUTPUT


AS
BEGIN

SELECT 0 AS CHK
	  ,A.PLANTCODE 
	  ,A.ITEMCODE
	  ,B.ITEMNAME
	  ,A.LOTNO
	  ,B.ITEMTYPE
	  ,A.STOCKQTY
	  ,A.UNITCODE
	  ,A.WHCODE
 FROM TB_StockPP A , TB_ItemMaster B WITH(NOLOCK)
 WHERE A.PLANTCODE = B.PLANTCODE
   AND A.ITEMCODE  = B.ITEMCODE
   AND A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
   AND B.ITEMTYPE  LIKE '%' + @ITEMTYPE  + '%'
   AND A.LOTNO		LIKE '%' + @LOTNO  + '%'
   AND ISNULL(A.STOCKQTY,0) <> 0

   
	SET @RS_CODE = 'S'



END
GO
