USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19PP_ActureOutput_I2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-11
-- Description:	생산실적 작업자 등록 
-- =============================================
CREATE PROCEDURE [dbo].[19PP_ActureOutput_I2]
     @PLANTCODE      VARCHAR(10),     --공장 코드
     @WORKER         VARCHAR(10),     --작업자
     @ORDERNO        VARCHAR(20),     --작업 지시 번호
     @WORKCENTERCODE VARCHAR(10),     --작업장 코드

     @LANG	  VARCHAR(10)  ='KO',     --언어
     @RS_CODE VARCHAR(10)  OUTPUT,    --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT     --성공 관련 메세지

AS
BEGIN 
	BEGIN TRY
		-- 현재 시간 정의
		DECLARE @LD_NOWDATE DATETIME
		      , @LS_NOWDATE VARCHAR(10)
			SET @LD_NOWDATE = GETDATE()
			SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

		DECLARE @LS_ITEMCODE VARCHAR(30)   --작업지시 품목
		      , @LS_STOCKQTY FLOAT		   --작업 수량
			  , @LS_UNITCODE VARCHAR(10)   --단위
			  , @INOUTSEQ    INT		   --이력 시퀸스

		--VALIDATION CHECK
		--해당 작업자 존재 확인
		--작업자가 있으면 1 없으면 0
		IF(SELECT COUNT(*)
		     FROM TB_WorkerList WITH(NOLOCK)
			WHERE WORKERID = @WORKER) <> 1

		BEGIN
			SET @RS_CODE = 'E'
			SET @RS_MSG  = '존재하지 않는 작업자 입니다.'
			RETURN;
		END

		--업데이트를 먼저하고 만약 기존의 데이터가 없다면,
		--@@ROWCOUNT를 통해 신규로 등록한다.
		UPDATE TP_WorkcenterStatus
		   SET WORKER= @WORKER
		 WHERE PLANTCODE=@PLANTCODE
		   AND ORDERNO=@ORDERNO
		   AND WORKCENTERCODE=@WORKCENTERCODE
			
		IF (@@ROWCOUNT = 0)
		BEGIN
			INSERT INTO TP_WorkcenterStatus
			( PLANTCODE,  WORKER,  ORDERNO,  WORKCENTERCODE,  MAKEDATE,    MAKER)
			VALUES
			( @PLANTCODE, @WORKER, @ORDERNO, @WORKCENTERCODE, @LD_NOWDATE, @WORKER)
		END

		SET @RS_CODE = 'S'
		SET @RS_MSG  = '작업자가 등록 되었습니다.'
	END TRY
	
	BEGIN CATCH
			SET @RS_CODE = 'E'
			SET @RS_MSG  = ERROR_MESSAGE();
	END CATCH
END 

SELECT * FROM TP_WorkcenterStatus
GO
