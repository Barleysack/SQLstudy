USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18PP_WCTRunStopList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-10
-- Description:	생산 계획 별 작업지시 확정 및 취소
-- =============================================
CREATE PROCEDURE [dbo].[18PP_WCTRunStopList_U1]
	  @REMARK               VARCHAR(30)
	 ,@PLANTCODE            VARCHAR(10) -- 공장  
	 ,@MAKER                VARCHAR(10)
	 ,@WORKCENTERCODE       VARCHAR(20)
	 ,@ORDERNO              VARCHAR(20)
	 ,@RSSEQ                VARCHAR(100)

     ,@LANG                 VARCHAR(10)='KO'
     ,@RS_CODE              VARCHAR(1)   OUTPUT
     ,@RS_MSG               VARCHAR(200) OUTPUT
AS
BEGIN
	--현재시간 정의
	DECLARE @LD_NOWTIME DATETIME
	    ,@LS_NOWDATE VARCHAR(10)
	SET @LD_NOWTIME = GETDATE()
	SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)

			UPDATE TP_WorkcenterStatusRec
			   SET REMARK      = @REMARK
			     , EDITOR       = @MAKER
				 , EDITDATE    = @LD_NOWTIME
			WHERE PLANTCODE    = @PLANTCODE
	          AND WORKCENTERCODE = @WORKCENTERCODE
	          AND ORDERNO		 = @ORDERNO
			  AND RSSEQ          = @RSSEQ
		  
SET @RS_CODE = 'S'
END

GO
