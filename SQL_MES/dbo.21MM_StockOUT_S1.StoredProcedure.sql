USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[21MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		최민준
-- Create date: 2021-06-09
-- Description:	자재 생산 출고 관리
-- =============================================
CREATE PROCEDURE [dbo].[21MM_StockOUT_S1]
	@PLANTCODE           VARCHAR(10) -- 광장
   ,@ITEMCODE            VARCHAR(30) -- 작업장
   ,@STARTDATE	         VARCHAR(20) -- 입고일자 시작일
   ,@ENDDATE	         VARCHAR(20) -- 입고일자 종료일
   ,@MATLOTNO 			 VARCHAR(20) 

   ,@LANG       VARCHAR(5) = 'KO'          -- 언어
   ,@RS_CODE    VARCHAR(1) OUTPUT          -- 성공 여부
   ,@RS_MSG     VARCHAR(200) OUTPUT        -- 성공 관련 메세지  아래 3개는 꼭 포함되어야 하는 구문

AS
BEGIN
   SELECT  0                                 AS CHK
          ,A.PLANTCODE                       AS PLANTCODE                 -- 공장
		  ,CONVERT(varchar, A.MAKEDATE,23)   AS MAKEDATE                 -- 계획번호
		  ,A.ITEMCODE                        AS ITEMCODE                  -- 품목코드
		  ,B.ITEMNAME                        AS ITEMNAME                   -- 계획수량
		  ,A.MATLOTNO                        AS MATLOTNO              -- 단위
		  ,A.STOCKQTY                        AS STOCKQTY
	      ,A.UNITCODE                        AS UNITCODE
	      ,A.WHCODE                          AS WHCODE
	      ,DBO.FN_WORKERNAME(A.MAKER)	     AS MAKER



     FROM TB_StockMM A WITH(NOLOCK) 
	 JOIN TB_ItemMaster B 
	    ON A.PLANTCODE= B.PLANTCODE
	   AND A.ITEMCODE = B.ITEMCODE

	WHERE A.PLANTCODE            LIKE '%' + @PLANTCODE +'%'
	  AND A.ITEMCODE             LIKE '%' + @ITEMCODE  +'%'
	  AND A.MATLOTNO             LIKE '%' + @MATLOTNO  +'%'
	  AND CONVERT(VARCHAR, A.MAKEDATE,23) BETWEEN @STARTDATE AND @ENDDATE
	  AND ISNULL(STOCKQTY,0) <> 0

	

END
GO
