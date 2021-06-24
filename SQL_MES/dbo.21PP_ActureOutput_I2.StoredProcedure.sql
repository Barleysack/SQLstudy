USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[21PP_ActureOutput_I2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		최민준
-- Create date: 2021-06-11
-- Description:	생산실적 작업자 등록
-- =============================================
CREATE PROCEDURE [dbo].[21PP_ActureOutput_I2]
	@PLANTCODE      VARCHAR(10)           -- 공장
   ,@WORKER         VARCHAR(10)           -- 작업자
   ,@ORDERNO        VARCHAR(20)           -- 작업자 지시 번호
   ,@WORKCENTERCODE VARCHAR(10)           -- 작업장

   ,@LANG           VARCHAR(10) = 'KO'    -- 언어
   ,@RS_CODE        VARCHAR(1)  OUTPUT    -- 성공 여부
   ,@RS_MSG         VARCHAR(200) OUTPUT	  -- 성공 관련 메세지


AS
BEGIN
	BEGIN TRY
		-- 현재 시간 정의
		DECLARE @LD_NOWDATE DATETIME
		       ,@LS_NOWDATE VARCHAR(10)
		   SET  @LD_NOWDATE = GETDATE()
		   SET  @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

		DECLARE @LS_ITEMCODE  VARCHAR(30)     -- 생산 품목
		       ,@LS_STOCKQTY  FLOAT           -- 작업 수량
			   ,@LS_UNITCODE  VARCHAR(10)     -- 단위
			   ,@INOUTSEQ     INT             -- 이력 시퀀스

		-- 작업자 유무 확인
		IF(SELECT COUNT(*)
			FROM TB_WorkerList WITH(NOLOCK)
		   WHERE WORKERID = @WORKER) <> 1     -- 작업자가 있으면 1, 없으면 0, 부등호이기 때문에 0이 들어가야 함
		BEGIN
			 SET @RS_CODE = 'E'
			 SET @RS_MSG  = '존재하지 않는 작업자입니다.'
			 RETURN;
		END

		--IF(SELECT COUNT(*)
		--	 FROM TP_WorkcenterStatus WITH(NOLOCK)
		--	WHERE PLANTCODE = @PLANTCODE
		--	  AND WORKCENTERCODE = @WORKCENTERCODE) = 0
		--BEGIN
		--   -- INSERT
		--END
		--ELSE
		--BEGIN
		-- UPDATE

		UPDATE TP_WorkcenterStatus
		   SET WORKER         = @WORKER
		WHERE PLANTCODE      = @PLANTCODE
		   AND ORDERNO        = @ORDERNO
		   AND WORKCENTERCODE = @WORKCENTERCODE
		IF (@@ROWCOUNT = 0)
		BEGIN
			INSERT INTO TP_WorkcenterStatus(PLANTCODE,  WORKCENTERCODE,  ORDERNO,  WORKER,  MAKEDATE,  MAKER)
			                         VALUES(@PLANTCODE, @WORKCENTERCODE, @ORDERNO, @WORKER, @LD_NOWDATE, @WORKER)
		END

		    SET @RS_CODE = 'S'
			SET @RS_MSG  = '작업자가 등록되었습니다.'
	END TRY
	BEGIN CATCH
		SET @RS_CODE = 'E'
		SET @RS_MSG = ERROR_MESSAGE();
	END CATCH
	
END
GO
