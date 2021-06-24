USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[1JO_StockCheck_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김수연
-- Create date: 2021-06-17
-- Description:	수입검사 이력생성
-- =============================================
CREATE PROCEDURE [dbo].[1JO_StockCheck_U1]
	@PLANTCODE	 VARCHAR(10)
   ,@LOTNO	     VARCHAR(20)
   ,@ITEMCODE    VARCHAR(10)
   ,@CHECKCODE   VARCHAR(30)
   ,@EACHCHECK   VARCHAR(2)
   ,@TESTER	     VARCHAR(30)
   ,@CHECKSEQ    VARCHAR(30)

   ,@LANG      VARCHAR(10) = 'KO'
   ,@RS_CODE   VARCHAR(1)   OUTPUT
   ,@RS_MSG    VARCHAR(200) OUTPUT
AS
BEGIN
	-- 현재 시간 정의
	DECLARE @LD_NOWDATE  DATETIME
           ,@LS_NOWDATE  VARCHAR(10)
		   ,@LS_CHECKSEQ VARCHAR(30)
		   ,@LI_CHECKNO   INT
		SET @LD_NOWDATE = GETDATE()  
        SET @LS_NOWDATE = CONVERT(VARCHAR,@LD_NOWDATE,23)
	
	--CHECKSEQ채번
	-- 가장 첫 행일 경우 거래명세 번호 채번
	IF ISNULL(@CHECKSEQ,'') = ''
		BEGIN
			SET @LS_CHECKSEQ = 'CK' + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),' ','')
		END
	ELSE 
		BEGIN
			SET @LS_CHECKSEQ = @CHECKSEQ
		END

	--검사 실적 이력 번호 채번
	SELECT @LI_CHECKNO = ISNULL(COUNT(*),0) +1
	  FROM TB_STOCKCHECK WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND LOTNO     = @LOTNO
	   AND CHECKSEQ  = @CHECKSEQ

    --업데이트로 TB_STOCKCHECK에 이력 INSERT
    INSERT INTO TB_STOCKCHECK (    CHECKNO, PLANTCODE, LOTNO, ITEMCODE,    CHECKSEQ,    CHECKCODE,    EACHCHECK  
				     			,TESTER,TESTDATE)
						VALUES(@LI_CHECKNO,@PLANTCODE,@LOTNO,@ITEMCODE,@LS_CHECKSEQ,   @CHECKCODE,   @EACHCHECK
								,@TESTER,@LD_NOWDATE)   
	SET @RS_CODE = 'S'
	SET @RS_MSG = @LS_CHECKSEQ
END
GO
