USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[21PP_StockPP_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		최민준
-- Create date: 2021-06-09
-- Description:	자재 생산 출고 관리
-- =============================================
CREATE PROCEDURE [dbo].[21PP_StockPP_S1]
	@PLANTCODE           VARCHAR(10) -- 공장
   ,@ITEMTYPE            VARCHAR(30) -- 물품명
   ,@LOTNO 			 VARCHAR(20) 

   ,@LANG       VARCHAR(5) = 'KO'          -- 언어
   ,@RS_CODE    VARCHAR(1) OUTPUT          -- 성공 여부
   ,@RS_MSG     VARCHAR(200) OUTPUT        -- 성공 관련 메세지  아래 3개는 꼭 포함되어야 하는 구문

AS
BEGIN
   SELECT  0                                 AS CHK
          ,A.PLANTCODE                       AS PLANTCODE               
		  ,A.ITEMCODE                        AS ITEMCODE                 
		  ,B.ITEMNAME                        AS ITEMNAME   
		  ,B.ITEMTYPE                        AS ITEMTYPE
		  ,A.LOTNO                           AS MATLOTNO       
		  ,A.WHCODE                          AS WHCODE
		  ,A.STOCKQTY                        AS STOCKQTY
	      ,A.UNITCODE                        AS UNITCODE



     FROM TB_StockPP A WITH(NOLOCK) 
	 JOIN TB_ItemMaster B 
	    ON A.PLANTCODE= B.PLANTCODE
	   AND A.ITEMCODE = B.ITEMCODE

	WHERE A.PLANTCODE            LIKE '%' + @PLANTCODE +'%'
	  AND B.ITEMTYPE             LIKE '%' + @ITEMTYPE  +'%'
	  AND A.LOTNO                LIKE '%' + @LOTNO  +'%'
	  AND ISNULL(STOCKQTY,0) <> 0

	

END
GO
