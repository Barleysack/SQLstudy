USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[20MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		정유경
-- Create date: 2021-06-09
-- Description: 자재 생산 출고 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[20MM_StockOUT_S1]
(
      @PLANTCODE       VARCHAR(10)    -- 공장
     ,@ITEMCODE        VARCHAR(30)    -- 품목
     ,@LOTNO           VARCHAR(30)    -- LOTNO
	 ,@STARTDATE       VARCHAR(10)    -- 시작 일자
	 ,@ENDDATE         VARCHAR(10)    -- 종료 일자

     ,@LANG            VARCHAR(10)='KO'
     ,@RS_CODE         VARCHAR(1) OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;   -- 영향을 받지 않는 테이블의 처리 결과 표시 제거.
        SELECT 0                              AS CHK       -- 선택
			 , A.PLANTCODE                    AS PLANTCODE -- 공장
			 , CONVERT(VARCHAR,A.MAKEDATE,23) AS MAKEDATE  -- 입고일자
			 , A.ITEMCODE                     AS ITEMCODE  -- 품목
			 , B.ITEMNAME                     AS ITEMNAME  -- 품목 명
			 , A.MATLOTNO                     AS MATLOTNO  -- LOTNO
			 , A.STOCKQTY                     AS STOCKQTY  -- 수량
			 , A.UNITCODE                     AS UNITCODE  -- 단위
			 , A.WHCODE                       AS WHCODE    -- 창고
			 , DBO.FN_WORKERNAME(A.MAKER)     AS MAKER     -- 입고자
		 FROM TB_StockMM A WITH (NOLOCK) LEFT JOIN TB_ItemMaster B WITH (NOLOCK) 
												 ON A.PLANTCODE = B.PLANTCODE
												AND A.ITEMCODE  = B.ITEMCODE
		 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
		   AND A.ITEMCODE  LIKE '%' + @ITEMCODE  + '%'
		   AND A.MATLOTNO  LIKE '%' + @LOTNO  + '%'
		   AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN @STARTDATE AND @ENDDATE
		   AND ISNULL(STOCKQTY,0) <> 0
     END
GO
