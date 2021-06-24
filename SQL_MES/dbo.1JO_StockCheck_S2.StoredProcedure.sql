USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[1JO_StockCheck_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		원지윤,김수연
-- Create date: 2021.06.18
-- Description:	입고 품목 검사 항목 조회
-- =============================================
CREATE PROCEDURE [dbo].[1JO_StockCheck_S2]
	@LANG		VARCHAR(5)    = 'KO'
	,@RS_CODE	VARCHAR(1)   OUTPUT
	,@RS_MSG	VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT CHECKCODE	AS CHECKCODE
		  ,CHECKNAME	AS CHECKNAME
		  ,CHECKSPEC	AS CHECKSPEC
		  ,''		 	AS EACHCHECK
      FROM TB_CheckMaster
	  ORDER BY CHECKCODE

	SET @RS_CODE = 'S'
END
GO
