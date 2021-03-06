USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[WM__4_InspectionPerItem_S2]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-18
-- Description:	수입 검사 항목 조회
-- =============================================
CREATE PROCEDURE [dbo].[WM__4_InspectionPerItem_S2]
	@PLANTCODE  VARCHAR(10)
   ,@ITEMCODE   VARCHAR(20)

   ,@LANG       VARCHAR(10) = 'KO'
   ,@RS_CODE    VARCHAR(1)   OUTPUT
   ,@RS_MSG     VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT INSPCODE 
		  ,INSPDETAIL
		  ,PLANTCODE
		  ,ITEMCODE
	  FROM TB_4_INSPItem
	  WHERE PLANTCODE = @PLANTCODE
	   AND ITEMCODE  = @ITEMCODE
END
GO
