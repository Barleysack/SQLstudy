USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[15PP_StockPP_M_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		이승수	
-- Create date: 2021-06-10
-- Description:	공장 창고 재고 조회
-- =============================================
CREATE PROCEDURE [dbo].[15PP_StockPP_M_S1] 
(
      @PLANTCODE                VARCHAR(10)         
	 ,@ITEMTYPE					VARCHAR(20)         
	 ,@LOTNO					VARCHAR(30)         
	   
	, @LANG                     VARCHAR(10)='KO'
	, @RS_CODE                  VARCHAR(1)   OUTPUT
    , @RS_MSG                   VARCHAR(200) OUTPUT 
)
AS
BEGIN
BEGIN TRY

	--생산출고등록 조회
	BEGIN
      	 SELECT 0 AS CHK
		       ,A.PLANTCODE 
        	   ,A.ITEMCODE
			   ,B.ITEMNAME
			   ,A.LOTNO    AS MATLOTNO
        	   ,B.ITEMTYPE
			   ,A.STOCKQTY
        	   ,A.UNITCODE
        	   ,A.WHCODE
			   
		   FROM TB_StockPP A LEFT JOIN TB_ItemMaster B ON A.PLANTCODE = B.PLANTCODE AND A.ITEMCODE = B.ITEMCODE
          WHERE A.PLANTCODE LIKE '%' + @PLANTCODE+ '%'
		    AND B.ITEMTYPE  LIKE '%' + @ITEMTYPE + '%'
			AND A.LOTNO     LIKE '%' + @LOTNO    + '%'
			AND ISNULL(A.STOCKQTY,0)  <> 0 --재고인 경우만 조회
	END
	 

SELECT @RS_CODE = 'S'
     
END TRY                                
BEGIN CATCH
   SELECT @RS_CODE = 'E'
   SELECT @RS_MSG 	= ERROR_MESSAGE()
END CATCH   
		   
END

GO
