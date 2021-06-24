USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[WM_4_INSPCODE]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[WM_4_INSPCODE]
	 @INSPCODE VARCHAR(10) 
	,@INSPDETAIL VARCHAR(10) 
AS
	
BEGIN
	select INSPCODE   AS CODE_ID
     , INSPDETAIL AS CODE_NAME
from TB_4_INSPMaster
WHERE INSPCODE LIKE '%' + @INSPCODE + '%'
  AND INSPDETAIL LIKE '%' + @INSPDETAIL + '%'

END
GO
