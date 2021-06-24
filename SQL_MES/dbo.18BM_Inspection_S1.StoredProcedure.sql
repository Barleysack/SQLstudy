USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18BM_Inspection_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-18
-- Description:	수입 검사 항목 조회
-- =============================================
CREATE PROCEDURE [dbo].[18BM_Inspection_S1]
	
   @LANG       VARCHAR(10) = 'KO'
   ,@RS_CODE    VARCHAR(1)   OUTPUT
   ,@RS_MSG     VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT INSPCODE
		 , INSPDETAIL
		 , EDITOR
		 , EDITDATE
		 , MAKER
		 , MAKEDATE
	  from TB_4_INSPMaster
	 ORDER BY INSPCODE
END
GO
