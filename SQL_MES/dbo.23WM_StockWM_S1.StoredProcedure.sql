USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[23WM_StockWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		한정은
-- Create date: 2021-06-16
-- Description:	제품 상차 등록 조회
-- =============================================
CREATE PROCEDURE [dbo].[23WM_StockWM_S1] 
	 @PLANTCODE  VARCHAR(10)
	,@LOTNO     VARCHAR(30) -- A에서 받아와야함
	,@SHIPFLAG     VARCHAR(1)
	,@ITEMCODE  VARCHAR(30) -- B에서 받아와야함
	,@STARTDATE VARCHAR(10) -- MAKEDATE로 받아와야하나?
    ,@ENDDATE   VARCHAR(10)  

	,@LANG     VARCHAR(10) = 'KO'
	,@RS_CODE  VARCHAR(1)   OUTPUT
	,@RS_MSG   VARCHAR(200) OUTPUT

AS
BEGIN
-- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
			,@LS_NOWDATE VARCHAR(10)
		SET @LD_NOWDATE = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE, 23)

	SELECT CASE WHEN ISNULL(A.SHIPFLAG,'N') = 'N' THEN 0 
	            ELSE 1 END    AS CHK -- 상차등록
				 
			,A.PLANTCODE AS PLANTCODE -- 공장
			,A.ITEMCODE	 AS ITEMCODE -- 품목코드
			,B.ITEMNAME	 AS ITEMNAME -- 품명
			,A.SHIPFLAG	 AS SHIPFLAG-- 상차 여부 
			,A.LOTNO	 AS LOTNO -- LOTNO
			,A.WHCODE	 AS WHCODE -- 창고 번호
			,A.STOCKQTY	 AS STOCKQTY -- 재고 수량
			,B.BASEUNIT	 AS UNITCODE -- 단위
			,CONVERT(VARCHAR,A.MAKEDATE,23) AS INDATE	  -- 입고일자
			,A.MAKEDATE	 AS MAKEDATE -- 등록일시
			,A.MAKER	 AS MAKER -- 등록자
		FROM TB_StockWM A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
												ON  A.PLANTCODE = B.PLANTCODE
												AND A.ITEMCODE = B.ITEMCODE

	WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
	AND   A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
	AND   A.MAKEDATE  BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'
	AND   ISNULL(A.SHIPFLAG,'')  LIKE '%' + @SHIPFLAG + '%'
	AND   A.LOTNO     LIKE '%' + @LOTNO + '%'

END
GO
