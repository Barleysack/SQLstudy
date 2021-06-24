USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19WM_StockOUTWM_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-17
-- Description:	제품 출고 대상 상차 상세 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[19WM_StockOUTWM_S2]
     @PLANTCODE      VARCHAR(10),     --공장 코드
	 @SHIPNO         VARCHAR(30),	  --상차 번호
	
     @LANG	  VARCHAR(10) ='KO',   --언어
     @RS_CODE VARCHAR(10) OUTPUT,  --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT  --성공 관련 메세지

AS
BEGIN
	SELECT A.PLANTCODE                                  AS PLANTCODE	--공장코드
		 , ISNULL(A.SHIPNO,'')                          AS SHIPNO	    --상차번호
		 , A.SHIPSEQ  	                                AS SHIPSEQ	    --상차채번 번호
		 , A.LOTNO                                      AS LOTNO	    --LOTNO
		 , A.ITEMCODE                                   AS ITEMCODE	    --품목코드
		 , DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,'KO') AS ITEMNAME	    --품목명   
		 , A.SHIPQTY                                    AS SHIPQTY	    --품목별 수량   
		 , B.BASEUNIT                                   AS UNITCODE     --단위
		
	  FROM TB_ShipWM_B A WITH(NOLOCK) 
	  LEFT JOIN TB_ItemMaster B WITH (NOLOCK)
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.ITEMCODE  = B.ITEMCODE
	 WHERE A.PLANTCODE = @PLANTCODE
	   AND A.SHIPNO    = @SHIPNO


END
GO
