USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02PP_WCTRunStopList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: 2021-06-15
-- Description:	작업장 비가동 현황 및 사유 등록
-- =============================================
CREATE PROCEDURE [dbo].[02PP_WCTRunStopList_U1]
	@PLANTCODE      VARCHAR(10)	--공장
   ,@WORKCENTERCODE VARCHAR(30) --작업장
   ,@ORDERNO		VARCHAR(20) --작업시지 번호
   ,@RSSEQ			INT         --이력 번호
   ,@REMARK			VARCHAR(30) --비고
   ,@EDITOR          VARCHAR(10) --수정자

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE	    VARCHAR(1)    OUTPUT
   ,@RS_MSG			VARCHAR(200)  OUTPUT



AS
BEGIN
	-- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
           ,@LS_NOWDATE VARCHAR(10)
		SET @LD_NOWDATE = GETDATE()  
        SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

	UPDATE TP_WorkcenterStatusRec
	   SET REMARK         = @REMARK
		  ,EDITOR         = @EDITOR
	      ,EDITDATE       = @LD_NOWDATE
     WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO		  = @ORDERNO
	   AND RSSEQ		  = @RSSEQ

	SET @RS_CODE = 'S'
	SET @RS_MSG  = '사유 등록을 완료 하였습니다.'
END
GO
