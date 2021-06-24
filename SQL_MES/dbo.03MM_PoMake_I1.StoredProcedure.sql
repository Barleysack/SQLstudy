USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03MM_PoMake_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보민
-- Create date: 2021-06-07
-- Description:	발주 내역 삭제
-- =============================================-
CREATE PROCEDURE [dbo].[03MM_PoMake_I1]
	-- Add the parameters for the stored procedure here
	 @PLANTCODE VARCHAR(10)
	,@ITEMCODE VARCHAR(30)
	,@POQTY    FLOAT
	,@UNITCODE VARCHAR(10)
	,@CUSTCODE VARCHAR(10)
	,@MAKER    VARCHAR(20)

	,@LANG	   VARCHAR(10) = 'KO'			-- 언어
	,@RS_CODE   VARCHAR(1)	OUTPUT			-- 성공여부
	,@RS_MSG	   VARCHAR(200) OUTPUT			-- 성공관련 메세지
AS
BEGIN
	DECLARE @LI_SEQ INT
		   ,@LS_PONO VARCHAR(20)
		   ,@LS_PODATE VARCHAR(10)
		   ,@LD_NOWDATE DATETIME
	SET @LS_PODATE  = CONVERT(VARCHAR, GETDATE(), 23)
	SET @LD_NOWDATE = GETDATE()

	--발주 번호 채번
	SELECT @LI_SEQ = COUNT(*) + 1
	  FROM TB_POMake WITH(NOLOCK)
	 WHERE PLANTCODE = @PLANTCODE
	   AND PODATE    = @LS_PODATE

	   SET @LI_SEQ = ISNULL(@LI_SEQ,1)
	SET @LS_PONO = 'PO' + REPLACE(CONVERT(VARCHAR,GETDATE(),114),':','')
				   + RIGHT('00000' + CONVERT(VARCHAR, @LI_SEQ), 4)


	INSERT INTO TB_POMake (PLANTCODE, PONO, ITEMCODE, POQTY, UNITCODE, PODATE, CUSTCODE, MAKER, MAKEDATE)
				   VALUES (@PLANTCODE, @LS_PONO, @ITEMCODE, @POQTY, @UNITCODE, @LS_PODATE, @CUSTCODE, @MAKER, @LD_NOWDATE)
	
	SET @RS_CODE = 'S'
END
GO
