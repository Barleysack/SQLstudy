USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[03ER_ERRORREC_S33_1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		최민준
-- Create date: 2021-06-17
-- Description:	제품 출고 대상 상차 공통 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[03ER_ERRORREC_S33_1]
	    @PLANTCODE	     VARCHAR(10)            -- 공장
	   ,@WORKCENTERCODE  VARCHAR(10)            -- 작업자 코드
       ,@STARTDATE		 VARCHAR(10)			-- 조회 시작 일자
	   ,@ENDDATE		 VARCHAR(10)		    -- 조회 종료 일자


	   ,@LANG      VARCHAR(10) = 'KO'
       ,@RS_CODE   VARCHAR(1)   OUTPUT
       ,@RS_MSG    VARCHAR(200) OUTPUT
AS
BEGIN
	SELECT  A.PLANTCODE           AS PLANTCODE
	       ,A.WORKCENTERCODE      AS WORKCENTERCODE
		   ,COUNT(*)              AS REPAIRCNT
	 FROM( SELECT B.PLANTCODE                   
		        , B.WORKCENTERCODE
	         FROM TB_ErrorRec B WITH(NOLOCK)

	        WHERE B.PLANTCODE			LIKE '%' + @PLANTCODE	    + '%'
	          AND B.WORKCENTERCODE	    LIKE '%' + @WORKCENTERCODE  + '%'
	          AND B.MAKEDATE			BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59') A 
            GROUP BY A.PLANTCODE,A.WORKCENTERCODE
      
END
GO
