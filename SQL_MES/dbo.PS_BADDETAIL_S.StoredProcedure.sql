USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[PS_BADDETAIL_S]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		2조
-- Create date: 2021-06-10
-- Description:	불량 상세 조회
-- =============================================


CREATE PROCEDURE [dbo].[PS_BADDETAIL_S]

	@PLANTCODE       VARCHAR(10)
   ,@ITEMCODE		 VARCHAR(10)
   ,@BADTYPE		 VARCHAR(10)
   ,@STARTDATE		 VARCHAR(10)
   ,@ENDDATE		 VARCHAR(10)
   ,@TEMPSTRING      VARCHAR(10)

   ,@LANG            VARCHAR(10) = 'KO'
   ,@RS_CODE	     VARCHAR(1)    OUTPUT
   ,@RS_MSG		 	 VARCHAR(200)  OUTPUT
	
AS
BEGIN
	SET @RS_MSG = @TEMPSTRING

	IF(@RS_MSG = 'First')
	BEGIN
	SELECT 
		   A.PLANTCODE          AS 		PLANTCODE   				  -- 공장     
		  ,A.INLOTNO            AS 		INLOTNO        				  -- INLOTNO  
		  ,A.BADQTY_TOTAL       AS 		BADQTYTOTAL         		  -- 최초불량수량
		  ,A.BADQTY   			AS 		NOWBADQTY   				  -- 현재불량수량
	      
		  ,CASE 
		     WHEN A.BADQTY = 0 THEN '0 '
			 ELSE  CONVERT(varchar, ROUND(A.BADQTY_TOTAL - A.BADQTY,0)) END AS PRODQTY    -- 재검양품수량
 		  
		  ,CASE 
             WHEN PRODQTY = 0 THEN '0 %'
             ELSE  CONVERT(varchar, ROUND((A.BADQTY_TOTAL-A.BADQTY) * 100 / A.BADQTY_TOTAL, 0))+ '%' END AS PRODRATIO -- 해결율   
		  
		  ,A.CHECKNUM           AS 		CHECKNUM       				  -- 재검사횟수
		  ,A.ITEMCODE    		AS 		ITEMCODE    				  -- 품목     
		  ,A.ITEMNAME    		AS 		ITEMNAME    				  -- 품명     
		  ,A.BADTYPE     		AS 		BADTYPE     				  -- 불량사유 
		  ,A.WORKCENTERNAME	 	AS 		WORKCENTERNAME			      -- 작업장   
		  ,B.BADRESULT   		AS 		BADRESULT   				  -- 판정결과 
		  ,A.WORKER      		AS 		WORKER      				  -- 작업자   
		  ,A.MAKEDATE    		AS 		MAKEDATE    				  -- 생산일시 
		  ,A.EDITOR      		AS 		EDITOR      				  -- 수정자   
		  ,A.EDITDATE    		AS 		EDITDATE    				  -- 수정일시 
		  ,A.COMFLAG     		AS 		COMFLAG     				  -- 판정완료 

	  FROM  TB_BadStock A WITH(NOLOCK) LEFT JOIN TB_BadStockRec B WITH(NOLOCK) 
												ON A.INLOTNO = B.INLOTNO
											   AND A.ITEMCODE = B.ITEMCODE
											   AND A.ITEMNAME = B.ITEMNAME
											   AND A.ORDERNO != NULL

	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND A.ITEMCODE                   LIKE '%' + @ITEMCODE      + '%'
	   AND A.BADTYPE                    LIKE '%' + @BADTYPE + '%'
	   AND A.MAKEDATE				   BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'

	 ORDER BY ITEMCODE
			SET @RS_MSG = 'Second'
			return;
			
	 END

	 IF(@RS_MSG = 'Second')
	 	BEGIN
	SELECT 
		   A.PLANTCODE          AS 		PLANTCODE   				  -- 공장     
		  ,A.INLOTNO            AS 		INLOTNO        				  -- INLOTNO  
		  ,A.BADQTY_TOTAL       AS 		BADQTYTOTAL         		  -- 최초불량수량
		  ,A.BADQTY   			AS 		NOWBADQTY   				  -- 현재불량수량
	      
		  ,CASE 
		     WHEN A.BADQTY = 0 THEN '0 '
			 ELSE  CONVERT(varchar, ROUND(A.BADQTY_TOTAL - A.BADQTY,0)) END AS PRODQTY    -- 재검양품수량
 		  
		  ,CASE 
             WHEN PRODQTY = 0 THEN '0 %'
             ELSE  CONVERT(varchar, ROUND((A.BADQTY_TOTAL-A.BADQTY) * 100 / A.BADQTY_TOTAL, 0))+ '%' END AS PRODRATIO -- 해결율   
		  
		  ,A.CHECKNUM           AS 		CHECKNUM       				  -- 재검사횟수
		  ,A.ITEMCODE    		AS 		ITEMCODE    				  -- 품목     
		  ,A.ITEMNAME    		AS 		ITEMNAME    				  -- 품명     
		  ,A.BADTYPE     		AS 		BADTYPE     				  -- 불량사유 
		  ,A.WORKCENTERNAME	 	AS 		WORKCENTERNAME			      -- 작업장   
		  ,B.BADRESULT   		AS 		BADRESULT   				  -- 판정결과 
		  ,A.WORKER      		AS 		WORKER      				  -- 작업자   
		  ,A.MAKEDATE    		AS 		MAKEDATE    				  -- 생산일시 
		  ,A.EDITOR      		AS 		EDITOR      				  -- 수정자   
		  ,A.EDITDATE    		AS 		EDITDATE    				  -- 수정일시 
		  ,A.COMFLAG     		AS 		COMFLAG     				  -- 판정완료 

	  FROM  TB_BadStock A WITH(NOLOCK) LEFT JOIN TB_BadStockRec B WITH(NOLOCK) 
												ON A.INLOTNO = B.INLOTNO
											   AND A.ITEMCODE = B.ITEMCODE
											   AND A.ITEMNAME = B.ITEMNAME
											   AND A.ORDERNO != NULL

	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND A.ITEMCODE                   LIKE '%' + @ITEMCODE      + '%'
	   AND A.BADTYPE                    LIKE '%' + @BADTYPE + '%'
	   AND A.MAKEDATE				   BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'

	 ORDER BY BADTYPE
			SET @RS_MSG = '최종 완료'
			SET @RS_CODE = 'default'
	 END
END
GO
