USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[08PP_ActureOutput_I2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김종우
-- Create date: 2021-06-11
-- Description:	생산실적 작업자 등록
-- =============================================
CREATE PROCEDURE [dbo].[08PP_ActureOutput_I2] 
	@PLANTCODE  VARCHAR(10),
	@WORKER     VARCHAR(10),
	@ORDERNO    VARCHAR(20),
	@WORKCENTERCODE VARCHAR(10),

	@LANG		VARCHAR(10) = 'KO',
	@RS_CODE    VARCHAR(1)   OUTPUT,
	@RS_MSG     VARCHAR(200) OUTPUT

AS
BEGIN
	BEGIN TRY
		-- 현재시간 정의
		DECLARE @LD_NOWDATE   DATETIME
			   ,@LS_NOWDATE   VARCHAR(10)
			SET @LD_NOWDATE = GETDATE()
			SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE, 23)
			
		DECLARE @LS_ITEMCODE VARCHAR(30)    -- 작업지시 품목
			   ,@LF_STOCKQTY FLOAT		    -- 작업수량
			   ,@LS_UNITCODE VARCHAR(10)    -- 단위
			   ,@INOUTSEQ    INT		    -- 이력 시퀀스

		-- 작업자 유무 확인
		IF (SELECT COUNT(*)
		      FROM TB_WorkerList WITH(NOLOCK)
			 WHERE WORKERID = @WORKER) <> 1
		
		BEGIN
			  SET @RS_CODE = 'E'
			  SET @RS_MSG  = '존재하지 않는 작업자 입니다.'
			  return;
		END

		-- IF (SELECT *
		-- 	  FROM TP_WorkcenterStatus WITH(NOLOCK)
		-- 	 WHERE PLANTCODE = @PLANTCODE
		-- 	   AND WORKCENTERCODE = @WORKCENTERCODE) = 0
		-- BEGIN
		-- --INSERT
		-- END
		-- 
		-- ELSE
		-- BEGIN
		-- --UPDATE
		-- END

		-- 주석이랑 비교해서 배운사람이 될수 있는 코드
		UPDATE TP_WorkcenterStatus
		   SET WORKER         = @WORKER
		 WHERE PLANTCODE      = @PLANTCODE
		   AND ORDERNO        = @ORDERNO
		   AND WORKCENTERCODE = @WORKCENTERCODE
		IF (@@ROWCOUNT =0)
		BEGIN
			INSERT INTO TP_WorkcenterStatus(PLANTCODE,   WORKCENTERCODE,  ORDERNO,  WORKER,  MAKEDATE,    MAKER)
			     VALUES		               (@PLANTCODE, @WORKCENTERCODE, @ORDERNO, @WORKER, @LD_NOWDATE, @WORKER)
		END

		SET @RS_CODE = 'S'
		SET @RS_MSG  = '작업자가 등록되었습니다.'
	END TRY
	BEGIN CATCH
		SET @RS_CODE = 'E'
		SET @RS_MSG  =  ERROR_MESSAGE();
	END CATCH
END
GO
