USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[01WM_ProdinStock_S1]    Script Date: 2021-06-22 오후 5:42:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강유정
-- Create date: 2021-06-16
-- Description:	제품 창고 입고 대상 조회
-- =============================================
CREATE PROCEDURE [dbo].[01WM_ProdinStock_S1] 
	 @PLANTCODE  VARCHAR(10)   --공장
	,@STARTDATE  VARCHAR(10)   --시작일시
	,@ENDDATE    VARCHAR(10)   --종료일시
	,@ITEMCODE   VARCHAR(30)   --품목코;드
	,@MAKER		 VARCHAR(30)
	,@LOTNO 	 VARCHAR(30)

	,@LANG       VARCHAR(10)  = 'KO'    --언어
	,@RS_CODE    VARCHAR(1)  OUTPUT     --성공 여부
	,@RS_MSG     VARCHAR(200) OUTPUT    --성공관련메세지
AS
BEGIN
    SELECT 0											AS CHK
			,CASE WHEN A.SHIPFLAG ='Y' THEN '[Y]예'     
						ELSE '[N]아니오' END AS SHIPFLAG			

			,A.PLANTCODE								AS PLANTCODE
			,A.ITEMCODE									AS ITEMCODE
			,B.ITEMNAME									AS ITEMNAME
			,A.LOTNO									AS LOTNO
			,A.WHCODE									AS WHCODE
			,A.STOCKQTY									AS STOCKQTY
			,B.BASEUNIT									AS BASEUNIT
			,A.MAKEDATE									AS MAKEDATE
			,A.MAKER									AS MAKER
				 FROM TB_StockWM AS A LEFT JOIN TB_ItemMaster AS B ON A.ITEMCODE=B.ITEMCODE

	 WHERE A.PLANTCODE LIKE '%'  + @PLANTCODE + '%'
	   AND A.ITEMCODE  LIKE '%'  + @ITEMCODE  + '%'
	   AND A.MAKEDATE  BETWEEN     @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'
	   AND A.SHIPFLAG  LIKE 'Y'

END


GO
