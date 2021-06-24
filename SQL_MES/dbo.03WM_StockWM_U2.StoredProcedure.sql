USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03WM_StockWM_U2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김보민
-- Create date: 210616
-- Description:	상차등록(공통)
-- =============================================
CREATE PROCEDURE [dbo].[03WM_StockWM_U2]
	@PLANTCODE VARCHAR(10) -- 공장
   ,@SHIPNO	   VARCHAR(30)
   ,@CARNO     VARCHAR(30)
   ,@CUSTCODE  VARCHAR(10) -- 거래처코드
   ,@WORKER    VARCHAR(10) -- 작업자
   ,@MAKER     VARCHAR(10) -- 등록자

   ,@LANG            VARCHAR(10)    ='KO'
   ,@RS_CODE         VARCHAR(1)     OUTPUT
   ,@RS_MSG		     VARCHAR(200)   OUTPUT
AS
BEGIN
	--7. 상차내역등록 (공통)
	INSERT INTO TB_SHIPWM (PLANTCODE, SHIPNO, CARNO, SHIPDATE, CUSTCODE, WORKER, MAKEDATE, MAKER)
	               VALUES (@PLANTCODE, @SHIPNO, @CARNO, CONVERT(VARCHAR,GETDATE(),23), @CUSTCODE, @WORKER, GETDATE(), @MAKER)
	SET @RS_CODE = 'S'
	SET @RS_MSG = '성공적으로 등록되었습니다'
END
GO
