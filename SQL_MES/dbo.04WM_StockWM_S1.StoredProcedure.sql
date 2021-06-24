USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[04WM_StockWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보성
-- Create date: 2021-06-16
-- Description:	제품 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[04WM_StockWM_S1]
	  @PLANTCODE VARCHAR(10)
	 ,@LOTNO     VARCHAR(30)
	 ,@ITEMCODE  VARCHAR(30)
	 ,@SHIPFLAG  VARCHAR(1)
	 ,@STARTDATE VARCHAR(10)
	 ,@ENDDATE   VARCHAR(10)

     ,@LANG      VARCHAR(10)  = 'KO'
     ,@RS_CODE   VARCHAR(1)   OUTPUT
     ,@RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN
	 SELECT CASE 
			  WHEN A.SHIPFLAG = 'Y' THEN 1
			  ELSE 0
			END											AS CHK       -- 선택
		   ,A.PLANTCODE									AS PLANTCODE -- 공장
		   ,A.ITEMCODE									AS ITEMCODE  -- 픔목
		   ,B.ITEMNAME									AS ITEMNAME  -- 품명
		   ,A.SHIPFLAG								    AS SHIPFLAG  -- 품목구분
		   ,A.LOTNO										AS LOTNO	 -- LOTNO
		   ,A.WHCODE							        AS WHCODE	 -- 창고
		   ,A.STOCKQTY									AS STOCKQTY  -- 수량
		   ,B.BASEUNIT									AS UNITCODE  -- 단위 
		   ,A.MAKEDATE									AS MAKEDATE  -- 생성일시
		   ,DBO.FN_WORKERNAME(A.MAKER)                  AS MAKER     -- 생성자
	 FROM TB_StockWM A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B
											 ON A.PLANTCODE = B.PLANTCODE
											AND A.ITEMCODE  = B.ITEMCODE

	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND A.LOTNO     LIKE '%' + @LOTNO     + '%'
	   AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
	   --SHIPFLAG가 NULL일때는 조건문에 ISNULL처리해주어야 한다.
	   AND ISNULL(A.SHIPFLAG,'') LIKE '%' + @SHIPFLAG  + '%'
	   AND A.MAKEDATE  BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'
	   SET @RS_MSG = 'S'
	   SET @RS_CODE = 'S'
END
GO
