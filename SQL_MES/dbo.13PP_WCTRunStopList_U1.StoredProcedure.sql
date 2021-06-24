USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[13PP_WCTRunStopList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		원지윤
-- Create date: 2021-06-11
-- Description:	사유 업데이트
-- =============================================

CREATE PROCEDURE [dbo].[13PP_WCTRunStopList_U1]
      @PLANTCODE       VARCHAR(10)    
     ,@WORKCENTERCODE  VARCHAR(10)    
     ,@ORDERNO         VARCHAR(20)    
     ,@RSSEQ	       VARCHAR(30)    
     ,@REMARK	       VARCHAR(10)    
     ,@EDITOR	       VARCHAR(20)    
     
	 ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT

AS
BEGIN
	--현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
           ,@LS_NOWDATE VARCHAR(10)
		   ,@LS_WORKER  VARCHAR(20)
		SET @LD_NOWDATE = GETDATE()  
        SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

	--사유 업데이트
    UPDATE TP_WorkcenterStatusRec
	   SET REMARK		  = @REMARK
	      ,EDITDATE       = @LD_NOWDATE
		  ,EDITOR         = @LS_WORKER
	 WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO		  = @ORDERNO
	   AND RSSEQ		  = @RSSEQ

	SET @RS_CODE = 'S'
	SET @RS_MSG  = '사유가 입력되었습니다.'
END
GO
