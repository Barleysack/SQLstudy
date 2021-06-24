USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[04MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보민
-- Create date: 2021-06-09
-- Description:	자재 생산 출고 관리 조회
-- =============================================
CREATE PROCEDURE [dbo].[04MM_StockOUT_S1]
	 @PLANTCODE			 VARCHAR(10) -- 공장      
	,@ITEMCODE       	 VARCHAR(10) -- 품목
	,@MATLOTNO 			 VARCHAR(20) -- LOTNO
	,@STARTDATE         VARCHAR(20)  -- 입고일자 시작일
	,@ENDDATE	         VARCHAR(20)  -- 입고일자 종료일
	
	,@LANG				 VARCHAR(5)    = 'KO'
	,@RS_CODE			 VARCHAR(1)   OUTPUT
	,@RS_MSG			 VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT 0 AS CHK 
	  ,A.PLANTCODE
      ,CONVERT(VARCHAR, A.MAKEDATE, 23) AS MAKEDATE
	  ,A.ITEMCODE
	  ,B.ITEMNAME
	  ,A.MATLOTNO
	  ,A.STOCKQTY
	  ,A.UNITCODE
	  ,A.WHCODE
	  ,DBO.FN_WORKERNAME(A.MAKER)	AS MAKER
  FROM TB_StockMM A , TB_ItemMaster B
 WHERE A.PLANTCODE = B.PLANTCODE
   AND A.ITEMCODE  = B.ITEMCODE
   AND A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
   AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
   AND A.MATLOTNO  LIKE '%' + @MATLOTNO + '%'
   AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN CONVERT(VARCHAR, @STARTDATE, 23) AND CONVERT(VARCHAR, @ENDDATE, 23)
   AND ISNULL(STOCKQTY,0) <> 0



	SET @RS_CODE = 'S'
END

GO
