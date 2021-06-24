USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[1JO_MM_StockCheckRec_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이승수, 한정은
-- Create date: 2021-06-18
-- Description:	검사이력조회
-- =============================================
CREATE PROCEDURE [dbo].[1JO_MM_StockCheckRec_S1]
	@PLANTCODE		VARCHAR(10)
   ,@STARTDATE		VARCHAR(10)
   ,@ENDDATE		VARCHAR(10)
   ,@LOTNO			VARCHAR(20)

   ,@LANG			VARCHAR(10) = 'KO'
   ,@RS_CODE		VARCHAR(1) OUTPUT  
   ,@RS_MSG			VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT  A.PLANTCODE						AS PLANTCODE	
		   ,A.LOTNO   						AS LOTNO   	
		   ,A.ITEMCODE						AS ITEMCODE	
		   ,C.ITEMNAME						AS ITEMNAME	
		   ,A.CHECKSEQ						AS CHECKSEQ	
		   ,B.INQTY							AS INQTY		
		   ,B.UNITCODE						AS UNITCODE	
		   ,B.CUSTCODE						AS CUSTCODE	
		   ,A.CHECKCODE						AS CHECKCODE	
		   ,D.CHECKNAME						AS CHECKNAME	
		   ,A.EACHCHECK						AS EACHCHECK	
		   ,A.TOTALCHECK					AS TOTALCHECK
		   ,A.REMARK  						AS REMARK  	
		   ,A.EDITOR  						AS EDITOR  	
		   ,CONVERT(VARCHAR,A.EDITDATE,120) AS EDITDATE
		   ,A.TESTDATE						AS TESTDATE	
	  FROM TB_STOCKCHECK A WITH(NOLOCK) LEFT JOIN TB_POMake B WITH(NOLOCK)
											   ON A.PLANTCODE = B.PLANTCODE
											  AND A.LOTNO	  = B.LOTNO
										LEFT JOIN TB_ItemMaster C WITH(NOLOCK)
											   ON A.PLANTCODE = C.PLANTCODE
											  AND B.ITEMCODE = C.ITEMCODE 
										LEFT JOIN TB_CheckMaster D WITH(NOLOCK)
											   ON A.CHECKCODE = D.CHECKCODE
	 WHERE A.PLANTCODE	LIKE '%' + @PLANTCODE + '%'
	   AND A.TESTDATE	BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:50:59'
	   AND A.LOTNO		LIKE '%' + @LOTNO  + '%'
	 ORDER BY A.LOTNO,A.CHECKSEQ ASC


END
GO
