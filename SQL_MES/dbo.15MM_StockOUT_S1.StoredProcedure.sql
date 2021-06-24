USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[15MM_StockOUT_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		이승수	
-- Create date: 2021-06-09
-- Description:	자재 창고 조회
-- =============================================
CREATE PROCEDURE [dbo].[15MM_StockOUT_S1] 
(
      @PLANTCODE                VARCHAR(10)         
	 ,@STARTDATE				VARCHAR(10)         
	, @ENDDATE					VARCHAR(10)         
    , @ITEMCODE					VARCHAR(30)         
	, @LOTNO					VARCHAR(30)         
	   
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
		       ,A.MATLOTNO
        	   ,CONVERT(VARCHAR, A.MAKEDATE, 23)											            AS MAKEDATE
        	   ,A.ITEMCODE
			   ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,@LANG)											AS ITEMNAME
        	   ,A.STOCKQTY
        	   ,A.UNITCODE
        	   ,A.WHCODE
			   ,(SELECT CODENAME FROM TB_Standard WHERE MAJORCODE = 'WHCODE' AND MINORCODE = A.WHCODE)  AS    WHNAME
        	   ,DBO.FN_WORKERNAME(A.MAKER) AS MAKER
			   
		   FROM TB_StockMM A 
          WHERE A.PLANTCODE LIKE @PLANTCODE+ '%'
		    AND A.ITEMCODE  LIKE @ITEMCODE + '%'
			AND A.MATLOTNO  LIKE @LOTNO    + '%'
			AND ISNULL(A.STOCKQTY,0)  <> 0 --재고인 경우만 조회
			AND CONVERT(VARCHAR, A.MAKEDATE, 23) BETWEEN @STARTDATE AND @ENDDATE
			AND A.CHECKFLAG = 'Y'
	END
	 

SELECT @RS_CODE = 'S'
     
END TRY                                
BEGIN CATCH
   SELECT @RS_CODE = 'E'
   SELECT @RS_MSG 	= ERROR_MESSAGE()
END CATCH   
		   
END

GO
