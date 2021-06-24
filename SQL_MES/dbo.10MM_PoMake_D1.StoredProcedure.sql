USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10MM_PoMake_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<마상우>
-- Create date: <2021-06-08>
-- Description:	발주 내역 삭제
-- =============================================
CREATE PROCEDURE [dbo].[10MM_PoMake_D1]
	-- Add the parameters for the stored procedure here
	@PLANTCODE    VARCHAR(10),        --공장
	@PONO 		  VARCHAR(30),
	

	@LANG       VARCHAR(10) = 'KO',   -- 언어
	@RS_CODE    VARCHAR(10) output,          -- 성공여부
	@RS_MSG     VARCHAR(200) output          -- 성공관련 메세지

AS
BEGIN
	IF (SELECT ISNULL(INFLAG, 'N')
		  FROM TB_POMake WITH(NOLOCK)
		 WHERE PLANTCODE = @PLANTCODE
		   AND PONO      = @PONO)='Y'
		   BEGIN 
			 SET @RS_CODE='E'
			 SET @RS_MSG = '이미 입고된 발주입니다.'
			 RETURN;
		   END

		   DELETE TB_POMake
		    WHERE PLANTCODE = @PLANTCODE
			  AND PONO      = @PONO
END
GO
