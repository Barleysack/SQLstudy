USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[07PP_WCTRunStopList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김은희
-- Create date: 2021-06-15
-- Description:	작업장 비가동 현황 및 사유 관리 등록
-- =============================================
Create PROCEDURE [dbo].[07PP_WCTRunStopList_U1]
      @PLANTCODE       VARCHAR(10)    -- 공장
     ,@WORKCENTERCODE  VARCHAR(10)    -- 작업장
     ,@ORDERNO         VARCHAR(20)    -- 작업지시 번호
     ,@RSSEQ	       VARCHAR(30)    -- 작업장지시별 순번
     ,@REMARK	       VARCHAR(10)    -- 비가동 사유
     ,@EDITOR	       VARCHAR(20)    -- 수정자
     
	 ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT

AS
BEGIN
	DECLARE @LD_NOWDATE DATETIME
		   ,@LS_WORKER  VARCHAR(20)
		SET @LD_NOWDATE = GETDATE()  
		SET @LS_WORKER = @EDITOR

    UPDATE TP_WorkcenterStatusRec
	   SET REMARK		  = @REMARK
	      ,EDITDATE       = GETDATE()
		  ,EDITOR         = @LS_WORKER
	 WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO		  = @ORDERNO
	   AND RSSEQ		  = @RSSEQ

	SET @RS_CODE = 'S'
	SET @RS_MSG  = '사유처리가 완료되었습니다.'
END
GO
