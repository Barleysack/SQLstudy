USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[1JO_BM_CheckList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	    
-- Create date: 2021-06-18
-- Description:	검사 항목 마스터 업데이트
-- =============================================
CREATE PROCEDURE [dbo].[1JO_BM_CheckList_U1]
   @PLANTCODE   VARCHAR(10)
  ,@CHECKCODE   VARCHAR(30)
  ,@CHECKNAME  	VARCHAR(100)
  ,@CHECKSPEC  	VARCHAR(50)
  ,@MEASURETYPE	VARCHAR(10)
  ,@EDITOR     	VARCHAR(10)
  ,@EDITDATE   	VARCHAR(10)

  ,@LANG        VARCHAR(10) = 'KO'
  ,@RS_CODE     VARCHAR(1) OUTPUT
  ,@RS_MSG      VARCHAR(200) OUTPUT
AS
BEGIN


UPDATE TB_CHECKMASTER
   SET PLANTCODE	= @PLANTCODE
      ,CHECKCODE    = @CHECKCODE
      ,CHECKNAME	= @CHECKNAME
      ,CHECKSPEC	= @CHECKSPEC
      ,MEASURETYPE	= @MEASURETYPE
      ,EDITOR		= @EDITOR
      ,EDITDATE		= GETDATE()
 WHERE PLANTCODE    = @PLANTCODE
   AND CHECKCODE    = @CHECKCODE
   
  SET @RS_CODE ='S'

END
GO
