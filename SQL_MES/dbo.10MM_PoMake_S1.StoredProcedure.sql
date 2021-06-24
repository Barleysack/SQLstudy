USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[10MM_PoMake_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<마상우>
-- Create date: <Create Date,,>
-- Description:	작업자 마스터 조회
-- =============================================
CREATE PROCEDURE [dbo].[10MM_PoMake_S1]
	-- Add the parameters for the stored procedure here
	@PLANTCODE    VARCHAR(10),        --공장
	@PONO 		  VARCHAR(30),
	@CUSTCODE	  VARCHAR(20),
	@STARTDATE	  VARCHAR(10),
	@ENDDATE 	  VARCHAR(10),

	@LANG       VARCHAR(10) = 'KO',   -- 언어
	@RS_CODE    VARCHAR(10) output,          -- 성공여부
	@RS_MSG     VARCHAR(200) output          -- 성공관련 메세지

AS
BEGIN
	SELECT  PLANTCODE  
		   ,PONO 		
		   ,ITEMCODE	
		   ,PODATE	
		   ,POQTY
		   ,UNITCODE
		   ,CUSTCODE
		   ,CASE WHEN ISNULL(INFLAG,'N') = 'Y' THEN 1
				 ELSE 0 END                    AS CHK        --선택체크박스
			,LOTNO                             AS LOTNO		 --LOTNO
			,INQTY                             AS INQTY		 --입고 수량
			,INDATE                            AS INDATE	 --입고 일자
			,DBO.FN_WORKERNAME(INWORKER)       AS INWORKER	 --입고자
			,DBO.FN_WORKERNAME(MAKER)          AS MAKER		 --등록자
			,CONVERT(VARCHAR, MAKEDATE, 120)   AS MAKEDATE	 --등록일자
			,DBO.FN_WORKERNAME(EDITOR)         AS EDITOR	 --수정자
		    ,CONVERT(VARCHAR, EDITDATE, 120)   AS EDITDATE	 --수정일자


	
	FROM TB_POMake WITH(NOLOCK)
	WHERE PLANTCODE LIKE '%' + @PLANTCODE + '%'
	  AND CUSTCODE LIKE  '%' + @CUSTCODE  + '%'
	  AND PONO LIKE      '%' + @PONO      + '%'
	  AND PODATE BETWEEN @STARTDATE AND @ENDDATE
	 



END
GO
