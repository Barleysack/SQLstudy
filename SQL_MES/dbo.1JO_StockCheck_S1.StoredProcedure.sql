USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[1JO_StockCheck_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		원지윤,김수연
-- Create date: 2021.06.18
-- Description:	검사 실적 등록 조회
-- =============================================
CREATE PROCEDURE [dbo].[1JO_StockCheck_S1]
	 @PLANTCODE	VARCHAR(10) -- 공장      
	,@ITEMCODE  VARCHAR(10) -- 품목
	,@LOTNO 	VARCHAR(20) -- LOTNO
	,@CUSTCODE 	VARCHAR(10) -- 거래처
	,@DATESTART	VARCHAR(20) -- 입고일자 시작일
	,@DATEEND	VARCHAR(20) -- 입고일자 종료일
	
	,@LANG		VARCHAR(5)    = 'KO'
	,@RS_CODE	VARCHAR(1)   OUTPUT
	,@RS_MSG	VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT 0												AS CHK  
	  ,A.WHCODE												AS WHCODE
	  ,A.PLANTCODE											AS PLANTCODE
	  ,A.MATLOTNO											AS LOTNO    
	  ,A.ITEMCODE											AS ITEMCODE
	  ,B.ITEMNAME											AS ITEMNAME 
	  ,A.STOCKQTY											AS STOCKQTY 
	  ,A.UNITCODE											AS UNITCODE 
	  ,A.CUSTCODE											AS CUSTCODE 
	  ,ISNULL(A.CHECKFLAG,'N')								AS CHECKFLAG
	  ,SUBSTRING(CONVERT(VARCHAR,A.MAKEDATE,120),1,10)		AS INDATE   
	  ,DBO.FN_WORKERNAME(A.MAKER)							AS MAKEDATE 
      ,CONVERT(VARCHAR, A.MAKEDATE, 23)						AS MAKER    
        FROM TB_StockMM A JOIN TB_ItemMaster B 
		                    ON A.PLANTCODE = B.PLANTCODE
					       AND A.ITEMCODE  = B.ITEMCODE
    WHERE A.PLANTCODE            LIKE '%' + @PLANTCODE + '%'
      AND A.ITEMCODE             LIKE '%' + @ITEMCODE  + '%'
      AND A.MATLOTNO             LIKE '%' + @LOTNO     + '%'
      AND ISNULL(A.CUSTCODE,'')  LIKE '%' + @CUSTCODE  + '%'
      AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN CONVERT(VARCHAR,@DATESTART,23) AND CONVERT(VARCHAR,@DATEEND,23)
      --AND ISNULL(A.STOCKQTY,0) <> 0
	  AND B.INSPFLAG = 'I'
	  AND ISNULL(A.CHECKFLAG,'N') = 'N'

	SET @RS_CODE = 'S'
END


SELECT * FROM TB_StockMM
GO
