USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[17PP_StockPP_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 2021-06-16
-- Description:	완제품 바코드 발행 데이터 조회
-- =============================================
CREATE PROCEDURE [dbo].[17PP_StockPP_S1]
		 @PLANTCODE				VARCHAR(10)				-- 공장
		,@LOTNO					VARCHAR(30)				-- 완제품 LOTNO
								
		,@LANG					VARCHAR(10) = 'KO' 
		,@RS_CODE				VARCHAR(1)    OUTPUT 
		,@RS_MSG   				VARCHAR(200)  OUTPUT
AS
BEGIN
	 -- 현재시간 정의
	DECLARE @LD_NOWDATE DATETIME
	       ,@LS_NOWDATE VARCHAR(10)
		   ,@LS_WORKER  VARCHAR(20)
	
		SET @LD_NOWDATE = GETDATE()
		SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

	 SELECT A.LOTNO											AS LOTNO
	       ,A.ITEMCODE										AS ITEMCODE
		   ,B.ITEMNAME										AS ITEMNAME
		   ,B.ITEMSPEC										AS ITEMSPEC
		   ,CONVERT(VARCHAR,A.MAKEDATE,120)					AS PRODDATE
		   ,CONVERT(VARCHAR,A.STOCKQTY) + ' ' + B.BASEUNIT  AS LOTQTY
	   FROM TB_StockPP AS A WITH(NOLOCK) LEFT JOIN TB_ItemMaster B WITH(NOLOCK)
											    ON A.PLANTCODE         = B.PLANTCODE
											   AND A.ITEMCODE		   = B.ITEMCODE
	  WHERE A.PLANTCODE        = @PLANTCODE
	    AND A.LOTNO            = @LOTNO
	   

END
GO
