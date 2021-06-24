USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[07WM_StockWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김은희
-- Create date: 2021-06-16
-- Description:	제품 재고 관리 및 상차 조회
-- =============================================
CREATE PROCEDURE [dbo].[07WM_StockWM_S1]
	  @PLANTCODE VARCHAR(10)			 -- 공장 코드
	 ,@ITEMCODE  VARCHAR(30)			 -- 품목 코드
	 ,@LOTNO	 VARCHAR(30)			 -- LOT 번호
	 ,@SHIPFLAG  VARCHAR(1)				 -- 상차여부	 
	 ,@STARTDATE VARCHAR(10)			 -- 시작일자
	 ,@ENDDATE   VARCHAR(10)			 -- 종료일자

     ,@LANG      VARCHAR(10)  = 'KO'	 -- 언어
     ,@RS_CODE   VARCHAR(1)   OUTPUT	 -- 성공 여부
     ,@RS_MSG    VARCHAR(200) OUTPUT	 -- 성공 관련 메세지

AS
BEGIN
	 SELECT CASE WHEN A.SHIPFLAG = 'Y' THEN 1
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
		   ,CONVERT(VARCHAR,A.MAKEDATE,23)				AS INDATE	 -- 입고일시
		   ,A.MAKEDATE									AS MAKEDATE  -- 생성일시
		   ,DBO.FN_WORKERNAME(A.MAKER)                  AS MAKER     -- 생성자
	 FROM TB_StockWM A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B
											 ON A.PLANTCODE = B.PLANTCODE
											AND A.ITEMCODE  = B.ITEMCODE

	 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	   AND A.LOTNO     LIKE '%' + @LOTNO     + '%'
	   AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
	  
	   AND ISNULL(A.SHIPFLAG,'') LIKE '%' + @SHIPFLAG  + '%'
	   AND A.MAKEDATE  BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'

	   SET @RS_CODE = 'S'
END
GO
