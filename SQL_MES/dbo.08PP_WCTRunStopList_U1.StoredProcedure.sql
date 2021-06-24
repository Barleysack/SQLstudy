USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[08PP_WCTRunStopList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김종우
-- Create date: 2021-06-15
-- Description:	작업장 비가동 현황 및 사유관리
-- =============================================
CREATE PROCEDURE [dbo].[08PP_WCTRunStopList_U1] 
      @PLANTCODE       VARCHAR(10)    -- 공장
     ,@WORKCENTERCODE  VARCHAR(10)    -- 작업장
     ,@ORDERNO         VARCHAR(20)    -- 작업지시
     ,@REMARK          VARCHAR(200)   -- 상태
	 ,@RSSEQ		   INT

     
	 ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT
AS
BEGIN
	-- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
           ,@LS_NOWDATE VARCHAR(10)
		   ,@LS_WORKER  VARCHAR(20)
		SET @LD_NOWDATE = GETDATE()  
        SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)
		
	

	-- 사유 업데이트 테이블 TP_WorkcenterStatusRec
	UPDATE TP_WorkcenterStatusRec
	   SET REMARK         = @REMARK,
	       EDITDATE       = @LD_NOWDATE,
		   EDITOR         = @LS_WORKER
	 WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO		  = @ORDERNO
	   AND RSSEQ		  = @RSSEQ

	   	SET @RS_CODE = 'S'


END
GO
