USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[04WM_StockOut_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		동상현
-- Create date: 2021-06-17
-- Description:	제품 출고 대상 상차 공통 내역 별 상세 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[04WM_StockOut_S2]
		@PLANTCODE VARCHAR(10) -- 공장
	   ,@SHIPNO    VARCHAR(30) -- 상차번호

	   ,@LANG      VARCHAR(10)  = 'KO'
	   ,@RS_CODE   VARCHAR(1)   OUTPUT
	   ,@RS_MSG    VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT  A.PLANTCODE
	       ,A.SHIPNO
		   ,A.SHIPSEQ
		   ,A.LOTNO
		   ,A.ITEMCODE
		   ,B.ITEMNAME
		   ,A.SHIPQTY
		   ,B.BASEUNIT
	FROM TB_ShipWM_B A WITH(NOLOCK)LEFT JOIN TB_ItemMaster B WITH(NOLOCK) 
										  ON A.PLANTCODE = B.PLANTCODE
										 AND A.ITEMCODE  = B.ITEMCODE
										 
    WHERE A.PLANTCODE = @PLANTCODE
	  AND SHIPNO    = @SHIPNO

	  
END
GO
