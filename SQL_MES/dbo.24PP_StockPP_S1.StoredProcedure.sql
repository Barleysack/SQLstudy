USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[24PP_StockPP_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		홍건의
-- Create date: 2021-06-10
-- Description:	조회
-- =============================================
CREATE PROCEDURE [dbo].[24PP_StockPP_S1]
/*	@PLANTCODE  VARCHAR(10) 
	,@MATLOTNO     VARCHAR(30) 
	,@ITEMTYPE  VARCHAR(10)
	
	,@LANG      VARCHAR(5) = 'OK'
	,@RS_CODE   VARCHAR(1)   OUTPUT
	,@RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN
	SELECT   0                                AS CHK 
			,A.PLANTCODE                      AS PLANTCODE
			,CONVERT(VARCHAR, A.MAKEDATE, 23) AS MAKEDATE
			,A.ITEMCODE                       AS ITEMCODE
			,B.ITEMNAME                       AS ITEMNAME
			,A.MATLOTNO                       AS MATLOTNO
			,B.ITEMTYPE                       AS ITEMTYPE
			,A.STOCKQTY                       AS STOCKQTY
			,A.UNITCODE                       AS UNITCODE
			,A.WHCODE                         AS WHCODE
		FROM TB_StockMM A WITH (NOLOCK) 
		LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
	    ON A.PLANTCODE = B.PLANTCODE
		AND A.ITEMCODE  = B.ITEMCODE
	    WHERE A.PLANTCODE LIKE '%' + @PLANTCODE  + '%'
	    AND   B.ITEMTYPE  LIKE '%' + @ITEMTYPE   + '%'
	    AND     MATLOTNO     LIKE '%' + @MATLOTNO   + '%'
	    AND ISNULL(STOCKQTY, 0) <> 0

END*/
(
      @PLANTCODE       VARCHAR(10)    -- 공장
     ,@ITEMTYPE        VARCHAR(10)    -- 품목
     ,@MATLOTNO           VARCHAR(30)    -- LOTNO
     ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT
)
AS
BEGIN
    BEGIN TRY

      BEGIN
        SELECT 0		   AS CHK       -- 원자재 출고 대상
		      ,A.PLANTCODE AS PLANTCODE -- 공장
		      ,A.ITEMCODE  AS ITEMCODE  -- 품목 코드
			  ,B.ITEMNAME  AS ITEMNAME  -- 품목 명
			  ,B.ITEMTYPE  AS ITEMTYPE  -- 품목 구분
			  ,A.LOTNO     AS MATLOTNO     -- LOTNO
			  ,A.WHCODE    AS WHCODE    -- 창고 
			  ,A.STOCKQTY  AS STOCKQTY  -- 수량
			  ,B.BASEUNIT  AS UNITCODE  -- 단위
		  FROM TB_StockPP A WITH (NOLOCK) LEFT JOIN TB_ItemMaster B WITH (NOLOCK) 
												 ON A.PLANTCODE = B.PLANTCODE
												AND A.ITEMCODE  = B.ITEMCODE
		 WHERE A.PLANTCODE LIKE '%' + @PLANTCODE + '%'
		   AND B.ITEMTYPE  LIKE '%' + @ITEMTYPE  + '%'
		   AND A.LOTNO     LIKE '%' + @MATLOTNO     + '%'


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
