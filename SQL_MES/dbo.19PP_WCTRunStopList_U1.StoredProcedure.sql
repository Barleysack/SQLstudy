USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19PP_WCTRunStopList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-15
-- Description:	비가동 사유 입력 업데이트
-- =============================================
CREATE PROCEDURE [dbo].[19PP_WCTRunStopList_U1]
  @PLANTCODE       VARCHAR(10),      -- 공장번호
  @REMARK          VARCHAR(50), 	 -- 비가동 사유
  @WORKCENTERCODE  VARCHAR(20),   	 -- 작업장 코드
  @ORDERNO         VARCHAR(20),		 -- 작업지시번호
  @RSSEQ           VARCHAR(100),	 -- 작업 SEQ
  @MAKER           VARCHAR(100),

  @LANG      VARCHAR(10) ='KO',
  @RS_CODE   VARCHAR(1) OUTPUT,
  @RS_MSG    VARCHAR(200) OUTPUT

AS
BEGIN     

	--현재시간 정의
	DECLARE @LD_NOWTIME DATETIME
	    ,@LS_NOWDATE VARCHAR(10)
	SET @LD_NOWTIME = GETDATE()
	SET @LS_NOWDATE = CONVERT(VARCHAR,GETDATE(),23)
	
	UPDATE TP_WorkcenterStatusRec
	   SET REMARK = @REMARK
	     , EDITDATE  = @LS_NOWDATE
		 , EDITOR    = DBO.FN_WORKERNAME(@MAKER)
	 WHERE PLANTCODE = @PLANTCODE
	   AND ORDERNO   = @ORDERNO
	   AND RSSEQ = @RSSEQ
	   AND WORKCENTERCODE = @WORKCENTERCODE

    SET @RS_CODE = 'S'

END                         

GO
