USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0300_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0300_S1]
(
	@SDATE       DATETIME
   ,@SDATE1      DATETIME
   ,@WORKERID    VARCHAR(20)
   ,@LANG      	 VARCHAR(10)='KO'
   ,@RS_CODE     VARCHAR(1) OUTPUT
   ,@RS_MSG      VARCHAR(200) OUTPUT  
)
AS
BEGIN
	BEGIN TRY
    	SELECT WORKERID    AS WORKERID   -- 사용자
	           ,WORKERNAME  AS WORKERNAME -- 사용자명
	           ,SDATE       AS SDATE      -- 시작일
	           ,STIME       AS STIME      -- 시작시간
	           ,CONVERT(VARCHAR, SSTAMP, 120) AS SSTAMP      -- 시작일자
	           ,EDATE       AS EDATE      -- 종료일
	           ,ETIME       AS ETIME      -- 종료시간
	           ,CONVERT(VARCHAR, ESTAMP, 120) AS ESTAMP      -- 종료일자
	           ,DBO.FN_TRANSLATE(@LANG, CASE STATE   WHEN 'QUERY' 	THEN '조회' 
							                 		 WHEN 'ADD' 	THEN '추가'
							                 		 WHEN 'SAVE' 	THEN '저장'
							                 		 WHEN 'DELETE' 	THEN '삭제'
							                 		 WHEN 'EXCEL' 	THEN '엑셀'
							                 		 WHEN 'LOGIN' 	THEN '로그인'
							                 		 WHEN 'OPEN' 	THEN '열기'
							                 		 ELSE STATE 	END , '') AS STATE       -- 상태
	           ,PROGID      AS PROGID     -- 화면 ID
	           ,RUNTIME     AS RUNTIME    -- 사용시간
	           ,RUNSTR      AS RUNSTR     -- 사용내역
	           ,IPADDRESS   AS IPADDRESS  -- IP주소
	           ,COMNAME     AS COMNAME    -- COMPUTER명 
	           ,REMARK      AS REMARK     -- 비고
	       FROM TSY0500 WITH(NOLOCK)
	      WHERE SDATE   >=   @SDATE
	        AND SDATE   <=   @SDATE1
	        --AND WORKERID <> 'SYSTEM'
			AND WORKERID LIKE @WORKERID + '%'
	   ORDER BY SDATE
        
        SELECT @RS_CODE = 'S'
	END TRY
                                
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]사용자접속현황' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0300_S1'
GO
