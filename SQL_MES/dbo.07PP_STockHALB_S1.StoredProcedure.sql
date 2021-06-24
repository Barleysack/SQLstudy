USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[07PP_STockHALB_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김은희
-- Create date: 2021-06-15
-- Description:	자재 재고 현황
-- =============================================
CREATE PROCEDURE [dbo].[07PP_STockHALB_S1]
(
      @PLANTCODE       VARCHAR(10)			-- 공장
     ,@ITEMTYPE        VARCHAR(30)			-- 품목구분
     ,@LOTNO           VARCHAR(30)			-- LOTNO
     
	 ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;  
    BEGIN TRY

      BEGIN													
        SELECT A.PLANTCODE   			AS PLANTCODE   		-- 공장  
		      ,A.ITEMCODE    			AS ITEMCODE    		-- 품목  
			  ,B.ITEMNAME    			AS ITEMNAME    		-- 품목명
			  ,B.ITEMTYPE    			AS ITEMTYPE    		-- 품목구분
			  ,A.LOTNO    				AS LOTNO    		-- LOTNO 
			  ,A.WORKCENTERCODE			AS WORKCENTERCODE	-- 작업장
			  ,C.WORKCENTERNAME			AS WORKCENTERNAME	-- 작업장명
			  ,A.STOCKQTY    			AS STOCKQTY    		-- 재고수량
			  ,A.UNITCODE    			AS UNITCODE    		-- 단위 
			 
		  FROM TB_STockHALB A WITH (NOLOCK) LEFT JOIN TB_ItemMaster B WITH (NOLOCK) 
												   ON A.PLANTCODE = B.PLANTCODE
												  AND A.ITEMCODE  = B.ITEMCODE
										    LEFT JOIN TB_WorkCenterMaster C WITH(NOLOCK)
												   ON A.WORKCENTERCODE = C.WORKCENTERCODE
	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND B.ITEMTYPE				   LIKE '%' + @ITEMTYPE		  + '%'
	   AND A.LOTNO					   LIKE '%' + @LOTNO		  + '%'
		   
    END
                 
    SELECT @RS_CODE = 'S'

    END TRY

    BEGIN CATCH
        INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER()    AS ERRORNUMBER
				 , ERROR_LINE()      AS ERRORLINE
				 , ERROR_MESSAGE()   AS ERRORMESSAGE
				 , GETDATE()
		
		SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
    END CATCH
END
GO
