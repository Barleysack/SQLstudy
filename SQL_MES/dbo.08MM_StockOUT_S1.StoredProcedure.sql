USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[08MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김종우
-- Create date: 2021-06-09
-- Description:	자재 출고 관리 조회
-- =============================================
CREATE PROCEDURE [dbo].[08MM_StockOUT_S1] 
	@PLANTCODE VARCHAR(10),         
	@ITEMCODE  VARCHAR(20),	       
	@MATLOTNO  VARCHAR(30),        
	@STARTDATE VARCHAR(10),	       
	@ENDDATE   VARCHAR(10),	        

	@LANG    VARCHAR(10) = 'KO',    -- 언어
	@RS_CODE VARCHAR(10) OUTPUT,	-- 성공 여부
	@RS_MSG VARCHAR(200) OUTPUT		-- 성공 관련 메세지

AS
BEGIN
	SELECT 
		   0 AS CHK 
		  ,A.PLANTCODE
		  ,CONVERT(VARCHAR,A.MAKEDATE,120) AS MAKEDATE   -- 입고일자
		  ,A.ITEMCODE
		  ,B.ITEMNAME
		  ,A.MATLOTNO
		  ,A.STOCKQTY
		  ,A.UNITCODE
		  ,A.WHCODE
		  ,DBO.FN_WORKERNAME(A.MAKER)      AS MAKER      -- 입고자

	  FROM TB_StockMM A WITH(NOLOCK)
	  LEFT JOIN TB_ItemMaster B
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.ITEMCODE  = B.ITEMCODE

	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
	   AND A.MATLOTNO  LIKE '%' + @MATLOTNO  + '%'
	   AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN @STARTDATE AND @ENDDATE
	   AND ISNULL(A.STOCKQTY,0) <> 0

	   	  SET @RS_CODE = 'S'
END
GO
