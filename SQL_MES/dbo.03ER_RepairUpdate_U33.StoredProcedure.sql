USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03ER_RepairUpdate_U33]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		정유경, 마상우
-- Create date: 2021-06-18
-- Description:	수리 내역 등록
-- =============================================
CREATE PROCEDURE [dbo].[03ER_RepairUpdate_U33]
	 @PLANTCODE        VARCHAR(10)    -- 공장
	,@WORKCENTERCODE   VARCHAR(10)    -- 작업장
	,@MAKEDATE         VARCHAR(20)    -- 고장 등록일시
	,@MAKER            VARCHAR(20)    -- 고장 등록자
	,@REMARK           VARCHAR(20)    -- 수리 내역
	,@REPAIRDATE       VARCHAR(30)    -- 수리 일자
	,@REPAIRMAN        VARCHAR(10)    -- 수리자(외부업체)
	,@REPAIRMAKER      VARCHAR(10)    -- 수리등록자
	,@ERRORSEQ		   VARCHAR(30)	  -- 고장 순번

	,@LANG             VARCHAR(10)  ='KO'
	,@RS_CODE          VARCHAR(1)   OUTPUT
	,@RS_MSG           VARCHAR(200) OUTPUT
AS
BEGIN
	-- 현재 시간 정의
	DECLARE @LD_NOWDATE   DATETIME
	       ,@LS_NOWDATE   VARCHAR(10)
	    SET @LD_NOWDATE = GETDATE()
	    SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

	-- 수리 등록 내역 업데이트
	UPDATE TB_ErrorRec
	   SET REMARK         = @REMARK			 -- 수리 내역
	     , REPAIRDATE     = @LD_NOWDATE		 -- 수리 일자
		 , REPAIRMAN      = @REPAIRMAN		 -- 수리자
		 , REPAIRMAKER    = @REPAIRMAKER	 -- 수리등록자
	 WHERE PLANTCODE      = @PLANTCODE
	   AND WORKCENTERCODE = @WORKCENTERCODE
	   AND ERRORSEQ       = @ERRORSEQ

    -- 작업장마스터 고장처리 'N'으로 해주기
	   UPDATE TB_WorkCenterMaster
	      SET ERRORFLAG      = 'N'
		WHERE PLANTCODE      = @PLANTCODE
		  AND WORKCENTERCODE = @WORKCENTERCODE
    
	-- WORKCENTERSTATUS 설비고장 이력 비가동 종료
    -- 작업장 별 가동 현황 테이블 TP_WorkcenterStatusRec(선택된 작업장 처리)
      DECLARE @WC_ORDERNO       VARCHAR(30) -- 작업지시번호
	  DECLARE @LI_RSSEQ         INT			-- 같은 작업지시번호 내 순번

	   SELECT @LI_RSSEQ       = ISNULL(MAX(RSSEQ),0)
	        , @WC_ORDERNO     = ORDERNO  -- 같은 작업지시 번호를 가진 작업장 내 채번 중 제일 마지막으로 생성된 SEQ를 사용한다. 													 -- 왜? 가동 비가동은 여러번 반복될 수 있다.
         FROM TP_WorkcenterStatusRec WITH (NOLOCK)
        WHERE PLANTCODE       = @PLANTCODE
 	      AND WORKCENTERCODE  = @WORKCENTERCODE
	      AND RSENDDATE			IS NULL			-- 고장 시간 등록은 STARTDATE에 저장되어 있으므로, 수리 시간은 아직 등록 X
	      AND REMARK          = '설비 고장'	
		  GROUP BY ORDERNO						-- 고장 사유는 '설비 고장'으로 자동 입력됨.
   
    UPDATE TP_WorkcenterStatusRec
  	     SET RSENDDATE      = @LD_NOWDATE      -- 수리시각만 업데이트 된다는 것
  		   , EDITOR         = @MAKER           -- 작업자
  		   , EDITDATE       = @LD_NOWDATE      -- 등록 시간
  	   WHERE PLANTCODE      = @PLANTCODE
  	     AND WORKCENTERCODE = @WORKCENTERCODE
  		 AND ORDERNO        = @WC_ORDERNO     
  		 AND RSSEQ          = @LI_RSSEQ

	SET @RS_CODE = 'S'
	
END
GO
