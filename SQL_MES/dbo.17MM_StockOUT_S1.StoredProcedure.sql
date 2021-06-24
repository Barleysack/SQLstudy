USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[17MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 2021-06-10
-- Description:	자재 생산 출고 조회
-- =============================================
CREATE PROCEDURE [dbo].[17MM_StockOUT_S1]
		 @PLANTCODE        VARCHAR(10)			 -- 공장
		,@ITEMCODE         VARCHAR(20)			 -- 공장
		,@LOTNO            VARCHAR(30)			 -- 공장
		--,@WHCODE           VARCHAR(30)			 -- 공장
		--,@STORAGELOCCODE   VARCHAR(20)			 -- 공장
		,@START            VARCHAR(30)			 -- 공장
		,@END              VARCHAR(30)			 -- 공장

		,@LANG             VARCHAR(10) = 'KO'     
		,@RS_CODE          VARCHAR(1)	 OUTPUT									  
		,@RS_MSG           VARCHAR(120)	 OUTPUT									  

AS
BEGIN
		SELECT 0 AS CHK
			  ,A.PLANTCODE
			  ,CONVERT(VARCHAR,A.MAKEDATE,23) AS MAKEDATE
			  ,A.ITEMCODE
			  ,B.ITEMNAME
			  ,A.MATLOTNO
			  ,A.STOCKQTY
			  ,A.UNITCODE
			  ,A.WHCODE
			  ,DBO.FN_WORKERNAME(A.MAKER) AS MAKER
		
		  FROM TB_StockMM A
	      LEFT JOIN TB_ItemMaster B
		    ON A.ITEMCODE  = B.ITEMCODE
		   AND A.PLANTCODE = B.PLANTCODE
		 WHERE A.PLANTCODE                LIKE '%' + @PLANTCODE      + '%'
		   AND B.ITEMCODE                 LIKE '%' + @ITEMCODE		  + '%'
		   AND MATLOTNO                   LIKE '%' + @LOTNO          + '%'
		   --AND A.WHCODE                   LIKE '%' + @WHCODE         + '%'
		   --AND ISNULL(STORAGELOCCODE,'')  LIKE '%' + @STORAGELOCCODE + '%'
		   AND A.MAKEDATE BETWEEN CONVERT(VARCHAR,@START,23) AND CONVERT(VARCHAR,@END,23)
		   AND ISNULL(STOCKQTY,0) <> 0

END
SELECT * FROM TB_StockMM
SELECT * FROM TB_ItemMaster
GO
