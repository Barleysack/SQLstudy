USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02MM_StockOut_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-09
-- Description:	자재 생산 출고 조회
-- =============================================
CREATE PROCEDURE [dbo].[02MM_StockOut_S1]
     @PLANTCODE VARCHAR(10)   --공장 코드
    ,@ITEMCODE  VARCHAR(20)    -- 품목코드
	,@LOTNO  VARCHAR(20)
	,@STARTDATE VARCHAR(20)
	,@ENDDATE	VARCHAR(20)

	,@LANG    VARCHAR(10) = 'KO'			-- 언어
	,@RS_CODE VARCHAR(10)  OUTPUT		-- 성공 여부
	,@RS_MSG  VARCHAR(200) OUTPUT	-- 성공 관련 메세지
AS
BEGIN
	--생산출고 등록 조회
	SELECT 0 AS CHK											--선택
		  ,A.PLANTCODE										--공장
		  ,A.MATLOTNO										--LOTNO
		  ,CONVERT(VARCHAR, A.MAKEDATE, 23)  AS MAKEDATE       		--입고일자
          ,A.ITEMCODE										--품목
		  ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,@LANG)		 AS ITEMNAME								--품목명
		  ,A.STOCKQTY										--수량
		  ,A.UNITCODE										--단위
		  ,A.WHCODE											--창고
		  ,(SELECT CODENAME FROM TB_Standard WHERE MAJORCODE = 'WHCODE' AND MINORCODE = A.WHCODE)  AS    WHNAME
          ,DBO.FN_WORKERNAME(A.MAKER) AS MAKER

     FROM TB_StockMM A, TB_ItemMaster B WITH(NOLOCK)
    WHERE  A.ITEMCODE = B.ITEMCODE
	    AND A.PLANTCODE = B.PLANTCODE
	    AND A.PLANTCODE	LIKE '%' + @PLANTCODE  + '%'
	    AND A.ITEMCODE	LIKE '%' + @ITEMCODE	  + '%'
	    AND A.MATLOTNO	LIKE '%' + @LOTNO + '%'
		AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN @STARTDATE AND @ENDDATE
	    AND ISNULL(STOCKQTY,0) <> 0 -- 재고인 경우만 조회
END
GO
