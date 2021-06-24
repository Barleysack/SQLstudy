USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02QM_BadsStock_U2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 2021-06-18
-- Description:	불량 사유 입력
-- =============================================
CREATE PROCEDURE [dbo].[02QM_BadsStock_U2]
		@PLANTCODE            VARCHAR(10) -- 공장
	   ,@BADSEQ              VARCHAR(10) -- 번호
	   ,@BADTYPE             VARCHAR(30) -- 생성 일자
	   ,@COMFLAG             VARCHAR(5) -- 수정자
	   ,@MAKER               VARCHAR(10)  -- 상태

	   ,@LANG                  VARCHAR(10)  = 'KO'
	   ,@RS_CODE               VARCHAR(1)   OUTPUT
	   ,@RS_MSG                VARCHAR(200) OUTPUT
AS
BEGIN
    -- 현재 시간 정의
	DECLARE @LD_NOWDATE DATETIME
           ,@LS_NOWDATE VARCHAR(10)
		SET @LD_NOWDATE = GETDATE()  
        SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)

    -- 불량 
	IF (@COMFLAG = '1')
	BEGIN

		UPDATE TB_BadStock
		   SET BADTYPE     = @BADTYPE
		      ,COMFLAG     = @COMFLAG
			  ,EDITOR      = @MAKER
			  ,EDITDATE    = @LD_NOWDATE
		 WHERE PLANTCODE   = @PLANTCODE
		   AND BADSEQ      = @BADSEQ

		INSERT INTO TB_BadStockRec     ( PLANTCODE,			INLOTNO,		OUTLOTNO,		ITEMCODE,		ITEMNAME,
										 PRODQTY,			BADQTY,		    BADTYPE,        BADRESULT,		WORKER,
										 WORKCENTERNAME,	EDITDATE,		EDITOR,         BADRECSEQ)
						       SELECT   PLANTCODE,			INLOTNO,		'',				ITEMCODE,		ITEMNAME,
										BADQTY_TOTAL-BADQTY,BADQTY,			BADTYPE,		'END',			WORKER,
										WORKCENTERNAME,		@LD_NOWDATE,	@MAKER,         @BADSEQ + '-END'  
							     FROM   TB_BadStock
								WHERE  PLANTCODE = @PLANTCODE
								  AND  BADSEQ	 = @BADSEQ
	END   

	IF (@COMFLAG = '0')
	BEGIN
	UPDATE TB_BadStock
		   SET BADTYPE     = @BADTYPE
			  ,EDITOR      = @MAKER
			  ,EDITDATE    = @LD_NOWDATE
		 WHERE PLANTCODE   = @PLANTCODE
		   AND BADSEQ      = @BADSEQ
	END
		  
   SET @RS_CODE = 'S'
END

GO
