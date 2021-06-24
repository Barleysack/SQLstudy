USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10PP_WCTRunStopList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		마상우
-- Create date: 2021-06-15
-- Description:	작업장 비가동 현황 및 사유 관리 조회
-- ============================================
CREATE PROCEDURE [dbo].[10PP_WCTRunStopList_U1]
   	@PLANTCODE      VARCHAR(10)
   ,@WORKCENTERCODE VARCHAR(10)
   ,@ORDERNO        VARCHAR(30)
   ,@RSSEQ			INT
   ,@REMARK         VARCHAR(30)


   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE        VARCHAR(1)    OUTPUT
   ,@RS_MSG         VARCHAR(200)  OUTPUT



AS
BEGIN
		
		DECLARE @LD_NOWDATE DATETIME
			   ,@LS_NOWDATE VARCHAR(10)
			   ,@LS_WORKER  VARCHAR(20)
			   

		    SET @LD_NOWDATE = GETDATE() -- GETDATE로 동일한 시점으로 변수로 지정
			SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

	IF(SELECT A.STATUS
	     FROM TP_WorkcenterStatusRec A WITH(NOLOCK)
		WHERE PLANTCODE      = @PLANTCODE
	      AND WORKCENTERCODE = @WORKCENTERCODE
	      AND ORDERNO        = @ORDERNO
	      AND RSSEQ	         = @RSSEQ) = 'R'
	BEGIN
		SET @RS_CODE = 'E'
		SET @RS_MSG = '가동 상태는 사유를 입력할 수 없습니다.'
		RETURN;
	END

	ELSE	
		BEGIN
			UPDATE TP_WorkcenterStatusRec
			   SET REMARK = @REMARK
			 WHERE PLANTCODE      = @PLANTCODE
			   AND WORKCENTERCODE = @WORKCENTERCODE
			   AND ORDERNO        = @ORDERNO
			   AND RSSEQ	      = @RSSEQ
	
	 SET  @RS_CODE = 'S'
	 SET  @RS_MSG  = '정상적으로 등록 되었습니다.'
	 END
END
GO
