USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[13PP_StockPP_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		원지윤
-- Create date: 2021.06.09
-- Description:	자재 생산 출고 관리
-- =============================================
CREATE PROCEDURE [dbo].[13PP_StockPP_S1]
	 @PLANTCODE			 VARCHAR(10) -- 공장      
	,@ITEMTYPE       	 VARCHAR(10) -- 품목
	,@LOTNO 			 VARCHAR(20) -- LOTNO
	
	,@LANG		VARCHAR(5)    = 'KO'
	,@RS_CODE	VARCHAR(1)   OUTPUT
	,@RS_MSG	VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT 0                            AS CHK 
	  ,A.PLANTCODE                      AS PLANTCODE
	  ,A.ITEMCODE                       AS ITEMCODE
	  ,B.ITEMNAME                       AS ITEMNAME
	  ,B.ITEMTYPE                       AS ITEMTYPE
	  ,A.MATLOTNO                       AS LOTNO
	  ,A.WHCODE                         AS WHCODE
	  ,A.STOCKQTY                       AS STOCKQTY
	  ,A.UNITCODE                       AS UNITCODE

        FROM TB_StockMM A JOIN TB_ItemMaster B 
		                    ON A.PLANTCODE = B.PLANTCODE
					       AND A.ITEMCODE  = B.ITEMCODE
    WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
      AND B.ITEMTYPE  LIKE '%' + ITEMTYPE  + '%'
      AND A.MATLOTNO  LIKE '%' + @LOTNO  + '%'
      AND ISNULL(A.STOCKQTY,0) <> 0

	SET @RS_CODE = 'S'
END
GO
