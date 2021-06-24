USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03ER_ERRORREC_S33_2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		최민준
-- Create date: 2021-06-17
-- Description: 출고 대상 상차 공통내역 별 상세 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[03ER_ERRORREC_S33_2]
             @PLANTCODE      VARCHAR(10)    -- 공장
			,@WORKCENTERCODE VARCHAR(10)	-- 작업장

			,@LANG      VARCHAR(10) = 'KO'
            ,@RS_CODE   VARCHAR(1)   OUTPUT
            ,@RS_MSG    VARCHAR(200) OUTPUT
	
AS
BEGIN
	SELECT  WORKCENTERCODE                                        AS WORKCENTERCODE   -- 작업장
	      , MAKER                                                 AS MAKER			  -- 작업자 (고장 등록자)
	      , CONVERT(VARCHAR, MAKEDATE,120)                        AS MAKEDATE		  -- 고장등록 일자	
		  , ISNULL(REPAIRMAN,'수리중')	                          AS REPAIRMAN		  -- 수리자 (수리 완료 등록자)
		  , ISNULL(REMARK,'수리중')	                              AS REMARK			  -- 수리내역	
		  , ISNULL(CONVERT(VARCHAR,REPAIRDATE,120)				  
		  ,CONVERT(VARCHAR,GETDATE(),120))                        AS REPAIRDATE       -- 수리완료 일자
		  , CONVERT(INT,DATEDIFF(mi,CONVERT(VARCHAR,MAKEDATE,120) 
		  ,ISNULL(REPAIRDATE,CONVERT(VARCHAR,GETDATE(),120) )))   AS REPAIRTIME		  -- 수리소요 시간

	   FROM TB_ERRORREC 
	  WHERE PLANTCODE			   = @PLANTCODE
	    AND WORKCENTERCODE	       = @WORKCENTERCODE
END

GO
