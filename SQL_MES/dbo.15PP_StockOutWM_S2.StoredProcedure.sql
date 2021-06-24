USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[15PP_StockOutWM_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이승수
-- Create date: 2021-06-17
-- Description:	출고 대상 상차 공통내역 별 상세 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[15PP_StockOutWM_S2]
	@PLANTCODE	VARCHAR(10) --공장
   ,@SHIPNO		VARCHAR(30) 

    ,@LANG			VARCHAR(10) = 'KO'
    ,@RS_CODE		VARCHAR(1)   OUTPUT
    ,@RS_MSG		VARCHAR(200) OUTPUT

AS
BEGIN
	SELECT A.PLANTCODE    AS PLANTCODE
		  ,A.SHIPNO		  AS SHIPNO
		  ,A.SHIPSEQ	  AS SHIPSEQ
		  ,A.LOTNO		  AS LOTNO
		  ,A.ITEMCODE	  AS ITEMCODE
		  ,A.SHIPQTY	  AS SHIPQTY
		  ,B.BASEUNIT	  AS UNITCODE
	  FROM TB_ShipWM_B A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											 ON A.PLANTCODE	= B.PLANTCODE
											AND A.ITEMCODE	= B.ITEMCODE
	 WHERE A.PLANTCODE = @PLANTCODE
	   AND A.SHIPNO	 = @SHIPNO
END
GO
