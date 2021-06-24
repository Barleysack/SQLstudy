USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[05PP_STockHALB_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김수연
-- Create date: 2021-06-14
-- Description:	생산 실적 등록
-- =============================================
CREATE PROCEDURE [dbo].[05PP_STockHALB_S1]
	@PLANTCODE      VARCHAR(10)
   ,@ITEMTYPE	    VARCHAR(10)
   ,@LOTNO	        VARCHAR(20)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE	    VARCHAR(1)    OUTPUT
   ,@RS_MSG			VARCHAR(200)  OUTPUT
	
AS
BEGIN
	SELECT A.PLANTCODE   			AS PLANTCODE   		
		  ,A.ITEMCODE    			AS ITEMCODE    		
		  ,C.ITEMNAME    			AS ITEMNAME    		
		  ,C.ITEMTYPE    			AS ITEMTYPE    		
		  ,A.LOTNO    				AS LOTNO    		
		  ,A.WORKCENTERCODE			AS WORKCENTERCODE	
		  ,B.WORKCENTERNAME			AS WORKCENTERNAME	
		  ,A.STOCKQTY    			AS STOCKQTY    		
		  ,A.UNITCODE    			AS UNITCODE    		

	FROM TB_StockHALB A WITH(NOLOCK)
		LEFT JOIN TB_WorkCenterMaster B WITH(NOLOCK)
			ON A.WORKCENTERCODE = B.WORKCENTERCODE
		   AND A.PLANTCODE	    = B.PLANTCODE
	    LEFT JOIN TB_ItemMaster C WITH (NOLOCK)
			ON A.PLANTCODE = C.PLANTCODE
		   AND A.ITEMCODE  = C.ITEMCODE

	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND C.ITEMTYPE				   LIKE '%' + @ITEMTYPE		  + '%'
	   AND A.LOTNO					   LIKE '%' + @LOTNO		  + '%'
END
	SELECT * FROM TB_StockHALB
	SELECT * FROM TB_ItemMaster
	SELECT * FROM TB_WorkCenterMaster
GO
