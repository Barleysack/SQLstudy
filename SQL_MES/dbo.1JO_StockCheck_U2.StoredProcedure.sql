USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[1JO_StockCheck_U2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김수연
-- Create date: 2021-06-17
-- Description:	수입검사 종합판정
-- =============================================
CREATE PROCEDURE [dbo].[1JO_StockCheck_U2]
	@PLANTCODE	 VARCHAR(10)
   ,@LOTNO	     VARCHAR(20)
   ,@WHCODE      VARCHAR(10)
   ,@ITEMCODE    VARCHAR(10)
   ,@TESTER	     VARCHAR(30)
   ,@CHECKSEQ    VARCHAR(30)

   ,@LANG      VARCHAR(10) = 'KO'
   ,@RS_CODE   VARCHAR(1)   OUTPUT
   ,@RS_MSG    VARCHAR(200) OUTPUT
AS
BEGIN
	-- 현재 시간 정의
	DECLARE @LD_NOWDATE  DATETIME
		SET @LD_NOWDATE = GETDATE()  
	
	IF(SELECT COUNT(*)
	     FROM TB_STOCKCHECK
	    WHERE PLANTCODE = @PLANTCODE
	      AND LOTNO = @LOTNO
		  AND CHECKSEQ = @CHECKSEQ
		  AND EACHCHECK = 'NG')<>0
		BEGIN
			--TB_STOCKCHECK의 종합판정 부분 UPDATE
			UPDATE TB_STOCKCHECK
			   SET TOTALCHECK = 'NG'
			 WHERE PLANTCODE = @PLANTCODE
			   AND LOTNO     = @LOTNO
			   AND CHECKSEQ  = @CHECKSEQ

			SET @RS_CODE = 'S'
			SET @RS_MSG = 'NG 판정. 재검사가 필요합니다.'
		END
	ELSE
		BEGIN
			--TB_STOCKMM의 CHECKFLAG를 Y로 변환
			UPDATE TB_STOCKMM
			   SET CHECKFLAG = 'Y'
			      ,EDITOR    = @TESTER
				  ,EDITDATE  = @LD_NOWDATE
			 WHERE PLANTCODE = @PLANTCODE
			   AND MATLOTNO  = @LOTNO
			   AND WHCODE    = @WHCODE
			
			--TB_STOCKCHECK의 종합판정 부분 UPDATE
			UPDATE TB_STOCKCHECK
			   SET TOTALCHECK = 'OK'
			 WHERE PLANTCODE = @PLANTCODE
			   AND LOTNO     = @LOTNO
			   AND CHECKSEQ  = @CHECKSEQ

			SET @RS_CODE = 'S'
			SET @RS_MSG = '판정이 완료 되었습니다.'

		END
END
GO
