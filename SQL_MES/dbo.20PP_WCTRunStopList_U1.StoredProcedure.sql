USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[20PP_WCTRunStopList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		정유경
-- Create date: 2021-06-15
-- Description:	사유 수정 및 저장
-- =============================================
CREATE PROCEDURE [dbo].[20PP_WCTRunStopList_U1]
	 @PLANTCODE        VARCHAR(10)           -- 공장 코드
	,@WORKCENTERCODE   VARCHAR(10)
	,@ORDERNO          VARCHAR(30)
	,@RSSEQ            VARCHAR(5)
	,@REMARK	       VARCHAR(100)		     -- 사유

	,@LANG             VARCHAR(10)  = 'KO'   -- 언어
	,@RS_CODE          VARCHAR(10)  OUTPUT   -- 성공 여부
	,@RS_MSG           VARCHAR(200) OUTPUT   -- 성공 관련 메세지
AS
BEGIN
	--현재시간 정의
	DECLARE @LD_NOWTIME DATETIME
	    ,@LS_NOWDATE VARCHAR(10)
	SET @LD_NOWTIME = GETDATE()
	SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)

	UPDATE TP_WorkcenterStatusRec
	   SET REMARK         = @REMARK
	 WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO        = @ORDERNO
	   AND RSSEQ          = @RSSEQ
	   

    SET @RS_CODE = 'S'
END
GO
