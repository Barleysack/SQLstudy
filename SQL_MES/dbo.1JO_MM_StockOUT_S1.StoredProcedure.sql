USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[1JO_MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김수연
-- Create date: 2021-06-09
-- Description:	자재 생산 출고 관리
-- =============================================
CREATE PROCEDURE [dbo].[1JO_MM_StockOUT_S1]
	@PLANTCODE      VARCHAR(10)  -- 공장
   ,@ITEMCODE		VARCHAR(10)  -- 품목명
   ,@MATLOTNO       VARCHAR(20)  -- LOTNO
   ,@STARTDATE		VARCHAR(10)	 -- 시작일자 
   ,@ENDDATE		VARCHAR(10)  -- 종료일자
   
   ,@LANG           VARCHAR(5)   = 'KO'
   ,@RS_CODE        VARCHAR(1)   OUTPUT
   ,@RS_MSG	        VARCHAR(200) OUTPUT
AS
BEGIN
BEGIN TRY
	SELECT  0																						AS CHK 
			,A.PLANTCODE																			AS PLANTCODE     
			,CONVERT(VARCHAR, A.MAKEDATE, 23)														AS MAKEDATE       
			,A.ITEMCODE																			    AS ITEMCODE      
			,B.ITEMNAME																				AS ITEMNAME
			,A.MATLOTNO																				AS MATLOTNO
			,A.STOCKQTY																				AS STOCKQTY
			,A.UNITCODE																				AS UNITCODE		   
			,A.WHCODE																				AS WHCODE  
			,(SELECT CODENAME FROM TB_Standard WHERE MAJORCODE = 'WHCODE' AND MINORCODE = A.WHCODE) AS WHNAME
			,DBO.FN_WORKERNAME(A.MAKER)																AS MAKER    
	  
	  FROM TB_StockMM AS A WITH (NOLOCK) LEFT JOIN TB_ItemMaster AS B WITH(NOLOCK)
		ON A.PLANTCODE = B.PLANTCODE AND A.ITEMCODE = B.ITEMCODE

	 WHERE A.PLANTCODE  LIKE '%' + @PLANTCODE + '%'
	   AND A.ITEMCODE   LIKE '%' + @ITEMCODE + '%'
	   AND A.MATLOTNO   LIKE '%' + @MATLOTNO + '%'
	   AND CONVERT(VARCHAR,A.MAKEDATE,23) BETWEEN @STARTDATE AND @ENDDATE
	   AND ISNULL(A.STOCKQTY,0) <> 0
	   AND A.CHECKFLAG = 'Y'

END TRY                                
BEGIN CATCH
   SELECT @RS_CODE = 'E'
   SELECT @RS_MSG 	= ERROR_MESSAGE()
END CATCH   
	
END
GO
