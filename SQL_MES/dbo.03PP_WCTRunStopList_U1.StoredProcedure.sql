USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03PP_WCTRunStopList_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보민
-- Create date: 2021-06-09
-- Description:	가동 비가동 사유등록 
-- =============================================
CREATE PROCEDURE [dbo].[03PP_WCTRunStopList_U1] 
	@PLANTCODE			 VARCHAR(10) -- 공장   
	,@RSSEQ				 VARCHAR(30) -- 키번호
	,@WORKCENTERCODE	 VARCHAR(30) -- 작업장
	,@ORDERNO			 VARCHAR(30) -- 작업지시번호
	,@REMARK			 VARCHAR(10) -- 사유
	,@EDITOR			 VARCHAR(10) -- 편집자
	
	,@LANG				 VARCHAR(5)    = 'KO'
	,@RS_CODE			 VARCHAR(1)   OUTPUT
	,@RS_MSG			 VARCHAR(200) OUTPUT

AS
BEGIN

-- 최초 가동 시작 일 경우 가동 시간 등록
	UPDATE TP_WorkcenterStatusRec -- 작업장 작업지시 별 상태 테이블
	   SET REMARK       = @REMARK,
		   EDITDATE	    = GETDATE(),
		   EDITOR	    = @EDITOR
     WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ORDERNO	      = @ORDERNO
	   AND RSSEQ		  = @RSSEQ

SET @RS_CODE = 'S'
END
GO
