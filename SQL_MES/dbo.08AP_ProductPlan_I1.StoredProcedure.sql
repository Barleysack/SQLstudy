USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[08AP_ProductPlan_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김종우
-- Create date: 2021-06-09
-- Description:	생산 계회 편성
-- =============================================
CREATE PROCEDURE [dbo].[08AP_ProductPlan_I1]
	@PLANTCODE       VARCHAR(10)  -- 공장
   ,@ITEMCODE        VARCHAR(30)  -- 품목코드
   ,@PLANQTY         FLOAT        -- 계획수량
   ,@UNITCODE        VARCHAR(10)  -- 단위
   ,@WORKCENTERCODE  VARCHAR(10)  -- 단위
   ,@MAKER           VARCHAR(20)  -- 계획생성자
   	     
   ,@LANG			 VARCHAR(10)  = 'KO'
   ,@RS_CODE		 VARCHAR(1)   OUTPUT
   ,@RS_MSG			 VARCHAR(200) OUTPUT
AS

BEGIN
	-- 생산 계획 고유번호 찾기 (생산계획 번호채번)
	DECLARE @LI_SEQ INT 
		   ,@LS_PLANNO VARCHAR(20)

	 SELECT @LI_SEQ = MAX(RIGHT(PLANNO,4)) +1  -- 유니크한계획번호만들기, 9999까지 만들수있음
	   FROM TB_ProductPlan WITH (NOLOCK)

	    SET @LI_SEQ    = ISNULL(@LI_SEQ,1)
		-- 앞에 PL을 붙이고 12번째면 PL0012로 만들겠다 
		SET @LS_PLANNO = 'PL' + RIGHT('00000' + CONVERT(VARCHAR, @LI_SEQ), 4) 

	-- 생산 계획 등록
	INSERT INTO TB_ProductPlan (PLANTCODE,  PLANNO,       ITEMCODE,  PLANQTY,  UNITCODE, WORKCENTERCODE,
								MAKER,      MAKEDATE)
						VALUES (@PLANTCODE, @LS_PLANNO,  @ITEMCODE, @PLANQTY, @UNITCODE, @WORKCENTERCODE,
								@MAKER,	    GETDATE())
	  SET @RS_CODE = 'S'
END
GO
