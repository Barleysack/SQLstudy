USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[05PP_WCTRunStopList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김수연
-- Create date: 2021-06-11
-- Description:	작업장 기간별 가동/비가동 현황 등록
-- =============================================
CREATE PROCEDURE [dbo].[05PP_WCTRunStopList_U1]
      @PLANTCODE       VARCHAR(10)    -- 공장
     ,@WORKCENTERCODE  VARCHAR(10)    -- 작업장
     ,@ORDERNO         VARCHAR(20)    -- 작업지시
     ,@RSSEQ	       VARCHAR(30)    -- 생산 품목
     ,@REMARK	       VARCHAR(10)    -- 생산 단위
     ,@EDITOR	       VARCHAR(20)    -- 생산 단위
     
	 ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT

AS
BEGIN
	-- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
		   ,@LS_WORKER  VARCHAR(20)
		SET @LD_NOWDATE = GETDATE()  
		SET @LS_WORKER = @EDITOR

	-- 가동 정보 사유 업데이트
    UPDATE TP_WorkcenterStatusRec
	   SET REMARK		  = @REMARK
	      ,EDITDATE       = @LD_NOWDATE
		  ,EDITOR         = @LS_WORKER
	 WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO		  = @ORDERNO
	   AND RSSEQ		  = @RSSEQ

	SET @RS_CODE = 'S'
	SET @RS_MSG  = '사유처리가 완료되었습니다.'
END
GO
