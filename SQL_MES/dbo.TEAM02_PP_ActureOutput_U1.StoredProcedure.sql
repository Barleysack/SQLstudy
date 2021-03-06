USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[TEAM02_PP_ActureOutput_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TEAM02_PP_ActureOutput_U1]
	@PLANTCODE		VARCHAR(10)
   ,@INLOTNO		VARCHAR(30)
   ,@BADSEQ			VARCHAR(10)
   ,@STATUS			VARCHAR(10)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE        VARCHAR(1)   OUTPUT
   ,@RS_MSG         VARCHAR(200) OUTPUT
AS
BEGIN
	DECLARE @LD_NOWDATE DATETIME
		   ,@LS_NOWDATE VARCHAR(10)
		   ,@BADFLAG	VARCHAR(1)

	SET @LD_NOWDATE = GETDATE() -- GETDATE로 동일한 시점으로 변수로 지정
	SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)
	SET @BADFLAG   = 'B'

	UPDATE TB_BadStock
	   SET WORKSTATUS = ISNULL(@STATUS,'Wait')
	      
	      --,TEMP2      = ISNULL(TEMP2+@BADFLAG,@BADFLAG)
	 WHERE PLANTCODE = @PLANTCODE
	   AND INLOTNO   = @INLOTNO
	   AND BADSEQ     = @BADSEQ
	   

	SET @RS_CODE = 'S'
	SET @RS_MSG  = '정상 등록 되었습니다.'
	   
END
GO
