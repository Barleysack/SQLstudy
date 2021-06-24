USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02PP_InspecRec_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-18
-- Description:	수입검사 공통 이력 조회
-- =============================================
CREATE PROCEDURE [dbo].[02PP_InspecRec_S1]
	 @PLANTCODE   VARCHAR(10)   --공장
	,@ITEMCODE	  VARCHAR(30)	--품목
	,@STARTDATE   VARCHAR(30)	--검사 시작 일자
	,@ENDDATE     VARCHAR(30)	--검사 종료 일자
	,@INSPRESULT  VARCHAR(1)	--합/불

	,@LANG        VARCHAR(10) = 'KO'
	,@RS_CODE	  VARCHAR(1)    OUTPUT
	,@RS_MSG	  VARCHAR(200)  OUTPUT

AS
BEGIN
	SELECT A.INSPNO												 AS INSPNO      -- 수입검사 항목 코드
		  ,A.PLANTCODE											 AS PLANTCODE   --공장
	      ,A.ITEMCODE											 AS ITEMCODE    --품목
	      ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,'KO')		     AS ITEMNAME    --품명
		  ,A.LOTNO												 AS LOTNO	    --LOTNO
		  ,B.STOCKQTY											 AS STOCKQTY    --수량
		  ,A.WHCODE												 AS WHCODE      --창고
		  ,A.INSPRESULT											 AS INSPRESULT  --최종 검사 결과		  
		  ,A.MAKER												 AS MAKER       --생성자
		  ,A.MAKEDATE											 AS MAKEDATE    --생성일시
	  FROM TB_4_FERTINSPrec A WITH(NOLOCK) LEFT JOIN TB_StockPP B WITH(NOLOCK)
											      ON A.ITEMCODE = B.ITEMCODE
											     AND A.LOTNO = B.LOTNO
	 WHERE A.PLANTCODE   LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE    LIKE '%' +  @ITEMCODE + '%'
	   AND A.INSPRESULT  LIKE '%' + @INSPRESULT + '%'
	   AND A.MAKEDATE    BETWEEN @STARTDATE AND @ENDDATE
	  
END
GO
