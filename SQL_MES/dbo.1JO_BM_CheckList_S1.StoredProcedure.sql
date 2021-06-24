USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[1JO_BM_CheckList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이승수, 한정은, 이근기
-- Create date: 2021-06-18
-- Description:	검사 항목 마스터 조회
-- =============================================
CREATE PROCEDURE [dbo].[1JO_BM_CheckList_S1]
    @PLANTCODE  VARCHAR(10)
   ,@CHECKCODE  VARCHAR(30)
   ,@LANG		VARCHAR(10) = 'KO'
   ,@RS_CODE	VARCHAR(1) OUTPUT  
   ,@RS_MSG		VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT  PLANTCODE
			,CHECKCODE   
			,CHECKNAME   
			,CHECKSPEC   
			,MEASURETYPE 
			,MAKER       
			,MAKEDATE    
			,EDITOR      
			,EDITDATE
	  FROM TB_CheckMaster WITH(NOLOCK)
	 WHERE CHECKCODE	LIKE '%' + @CHECKCODE + '%'
	 AND   PLANTCODE	LIKE '%' + @PLANTCODE + '%'

END
GO
