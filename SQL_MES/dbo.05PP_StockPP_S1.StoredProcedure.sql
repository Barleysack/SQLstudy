USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[05PP_StockPP_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김수연
-- Create date: 2021-06-09
-- Description:	공정 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[05PP_StockPP_S1]
	@PLANTCODE      VARCHAR(10)  -- 공장
   ,@ITEMTYPE		VARCHAR(10)  -- 품목명
   ,@MATLOTNO       VARCHAR(20)  -- LOTNO
   
   ,@LANG           VARCHAR(5)   = 'KO'
   ,@RS_CODE        VARCHAR(1)   OUTPUT
   ,@RS_MSG	        VARCHAR(200) OUTPUT
AS
BEGIN
--TRY문 추가 -> 3번
BEGIN TRY
	SELECT  0																						AS CHK 
			,A.PLANTCODE																			AS PLANTCODE     
			,A.ITEMCODE																			    AS ITEMCODE      
			,B.ITEMNAME																				AS ITEMNAME
			,B.ITEMTYPE																				AS ITEMTYPE
			,A.LOTNO																				AS LOTNO
			,A.WHCODE																				AS WHCODE  
			,A.STOCKQTY																				AS STOCKQTY
			,B.BASEUNIT																				AS UNITCODE		   
	  
	  FROM TB_StockPP AS A WITH (NOLOCK) LEFT JOIN TB_ItemMaster AS B WITH(NOLOCK)
		ON A.PLANTCODE = B.PLANTCODE AND A.ITEMCODE = B.ITEMCODE

	 WHERE A.PLANTCODE  LIKE '%' + @PLANTCODE + '%'
	   AND B.ITEMTYPE   LIKE '%' + @ITEMTYPE + '%'
	   AND A.LOTNO		LIKE '%' + @MATLOTNO + '%'

	 SELECT @RS_CODE = 'S'  

END TRY                                
BEGIN CATCH
   SELECT @RS_CODE = 'E'
   SELECT @RS_MSG 	= ERROR_MESSAGE()
END CATCH
--BEGIN CATCH
--    INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
--		SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
--			 , ERROR_NUMBER()    AS ERRORNUMBER
--			 , ERROR_LINE()      AS ERRORLINE
--			 , ERROR_MESSAGE()   AS ERRORMESSAGE
--			 , GETDATE()
--	
--	SELECT @RS_CODE = 'E'
--	SELECT @RS_MSG = ERROR_MESSAGE()
--END CATCH
	
END
GO
