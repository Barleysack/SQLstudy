USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10PP_ACTUREOUTPUT_I2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		마상우
-- Create date: 2021-06-11
-- Description:	생산 작업자 조회
-- =============================================
CREATE PROCEDURE [dbo].[10PP_ACTUREOUTPUT_I2]
	@PLANTCODE       VARCHAR(10)
   ,@WORKER          VARCHAR(10)
   ,@ORDERNO         VARCHAR(20)
   ,@WORKCENTDERCODE VARCHAR(20)

   ,@LANG	        VARCHAR(10)='KO'
   ,@RS_CODE        VARCHAR(1)    OUTPUT
   ,@RS_MSG         VARCHAR(200)  OUTPUT



AS
BEGIN

	BEGIN TRY

	   DECLARE @LD_NOWDATE DATETIME
	          ,@LS_NOWDATE VARCHAR(10)
       	SET @LD_NOWDATE = GETDATE()
	   	SET @LS_NOWDATE = CONVERT(VARCHAR, @LD_NOWDATE,23)
	   
	   DECLARE @LS_ITEMCODE VARCHAR(30)  -- 작업지시 품목
	          ,@LS_STOCKQTY FLOAT        -- 작업 수량
	   	   ,@LS_UNITCODE VARCHAR(10)  -- 단위
	   	   ,@INOUTSEQ    INT          -- 이력 시퀀스
	   
	   -- 작업자 유무 확인
	   IF(SELECT COUNT(*)
	        FROM TB_WorkerList WITH(NOLOCK)
	   	WHERE WORKERID = @WORKER) <> 1
	   
           BEGIN
           	SET @RS_CODE = 'E'
           	SET @RS_MSG  = '존재하지 않는 작업자입니다.'
           
	   	 END
	   
	   --	IF(SELECT COUNT(*)
	   --     FROM TB_WorkerList WITH(NOLOCK)
	   --	WHERE PLANTCODE = @PLANTCODE
	   --	  AND WORKCENTDERCODE = @WORKCENTDERCODE) = 0
	   --	  
	   --	  BEGIN
	   --	  --INSERT
	   --	  END
	   UPDATE TP_WorkcenterStatus
	      SET WORKER = @WORKER
	    WHERE PLANTCODE = @PLANTCODE
	      AND ORDERNO = @ORDERNO
	      AND WORKCENTERCODE = @WORKCENTDERCODE
	   IF(@@ROWCOUNT = 0)
	   BEGIN
	   	INSERT INTO TP_WorkcenterStatus(PLANTCODE,   WORKCENTERCODE,   ORDERNO,   WORKER  , MAKEDATE,   MAKER)
	   	                          VALUES(@PLANTCODE, @WORKCENTDERCODE, @ORDERNO, @WORKER, @LD_NOWDATE, @WORKER)
	   	
	   END
	   SET @RS_CODE = 'S'
       SET @RS_MSG  = '작업자가 등록되었습니다.'
	END TRY
	BEGIN CATCH
		SET @RS_CODE = 'E'
        SET @RS_MSG  = ERROR_MESSAGE();
	END CATCH
END
GO
