USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[17WM_StockWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 2021-06-16
-- Description:	제품 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[17WM_StockWM_S1]
		 @PLANTCODE		   VARCHAR(10)			 -- 공장
		,@ITEMCODE		   VARCHAR(30)			 -- 품목 코드
		,@LOTNO			   VARCHAR(30)			 -- LOT 번호
		,@SHIPFLAG		   VARCHAR(10)			 -- 상차 여부
		,@STARTDATE		   VARCHAR(10)			 -- 입고 일자 시작 범위
		,@ENDDATE		   VARCHAR(10)			 -- 입고 일자 끝 범위

		,@LANG             VARCHAR(10) = 'KO'     
		,@RS_CODE          VARCHAR(1)	 OUTPUT									  
		,@RS_MSG           VARCHAR(200)	 OUTPUT									  

AS
BEGIN
		SELECT 0			           AS CHK
			  ,A.PLANTCODE         	   AS PLANTCODE
			  ,A.ITEMCODE          	   AS ITEMCODE
			  ,B.ITEMNAME		   	   AS ITEMNAME
			  ,ISNULL(A.SHIPFLAG,'N')  AS SHIPFLAG
			  ,A.LOTNO                 AS LOTNO
			  ,A.WHCODE                AS WHCODE
			  ,A.STOCKQTY              AS STOCKQTY
			  ,A.UNITCODE              AS BASEUNIT
			  ,A.MAKEDATE              AS INDATE
			  ,A.MAKER                 AS MAKER
		  FROM TB_StockWM AS A WITH (NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
												    ON A.PLANTCODE = B.PLANTCODE
												   AND A.ITEMCODE  = B.ITEMCODE
		 WHERE A.PLANTCODE	LIKE '%' + @PLANTCODE + '%'
		   AND A.ITEMCODE	LIKE '%' + @ITEMCODE + '%'
		   AND A.LOTNO		LIKE '%' + @LOTNO + '%'
		   AND ISNULL(A.SHIPFLAG,'N')   LIKE '%' + @SHIPFLAG + '%'
		   AND A.MAKEDATE   -- BETWEEN '2021-06-01' + ' 00:00:00' AND '2021-06-16' + ' 23:59:59'
		   BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'

	 
	 SET @RS_CODE = 'S'
	 
		                                          
END
GO
