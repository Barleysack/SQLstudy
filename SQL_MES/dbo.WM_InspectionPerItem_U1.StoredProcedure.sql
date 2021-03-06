USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[WM_InspectionPerItem_U1]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		
-- Create date: 2021-06-20
-- Description:	항목별 검사 항목 수정 및 추가
-- =============================================
CREATE PROCEDURE [dbo].[WM_InspectionPerItem_U1] 
	@INSPCODE    VARCHAR(10)
	,@INSPDETAIL VARCHAR(30)
	,@ITEMCODE   VARCHAR(10)
	,@PLANTCODE  VARCHAR(10)

   ,@LANG        VARCHAR(10) = 'KO'
   ,@RS_CODE     VARCHAR(1)   OUTPUT
   ,@RS_MSG      VARCHAR(200) OUTPUT
AS
BEGIN
TRY

 
IF (ISNULL(@INSPCODE,'') <> '')  
		BEGIN
			IF (SELECT COUNT(*) 
				  FROM TB_4_INSPItem WITH(NOLOCK)
				 WHERE ITEMCODE      = @ITEMCODE
				   AND INSPCODE      = @INSPCODE) <> 0
			BEGIN 
				SET @RS_CODE = 'E'
				SET @RS_MSG = '저장에 성공했습니다'
				
			END
			ELSE 
			BEGIN
			SET @RS_CODE = 'S'
			SET @RS_MSG = '저장에 성공했습니다'
			END
		END


UPDATE TB_4_INSPItem
   SET  INSPDETAIL    = @INSPDETAIL
	  WHERE ITEMCODE  = @ITEMCODE		
	    AND PLANTCODE = @PLANTCODE
		AND INSPCODE  = @INSPCODE 
	IF (@@ROWCOUNT = 0) 
	BEGIN
	INSERT INTO TB_4_INSPItem (PLANTCODE,  ITEMCODE, INSPCODE,  INSPDETAIL)
							VALUES (@PLANTCODE, @ITEMCODE, @INSPCODE, @INSPDETAIL)
	END
	SET @RS_CODE = 'S'
	END TRY
BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
GO
