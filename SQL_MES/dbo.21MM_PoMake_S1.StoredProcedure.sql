USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[21MM_PoMake_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		최민준
-- Create date: 2021-06-08
-- Description:	발주 입고 및 조회
-- =============================================
CREATE PROCEDURE [dbo].[21MM_PoMake_S1]
	@PLANTCODE   VARCHAR(10),   -- 공장 코드
	@CUSTCODE    VARCHAR(20),    -- 작업자 ID
	@PONO        VARCHAR(30),  -- 작업자 명
	@STARTDATE   VARCHAR(10),     -- 작업반
	@ENDDATE     VARCHAR(10),     -- 사용여부

	-- 기본적으로 설정해줘야하는 3가지
	@LANG VARCHAR(10)  = 'KO',-- 언어
	@RS_CODE VARCHAR(10) OUTPUT,     -- 성공 여부
	@RS_MSG VARCHAR(200) OUTPUT     -- 성공 관련 메세지 
	AS
	BEGIN
		SELECT PLANTCODE
			  ,PONO
			  ,ITEMCODE
			  ,PODATE
			  ,POQTY
			  ,UNITCODE
			  ,CUSTCODE
			  ,CASE WHEN ISNULL(INFLAG, 'N') = 'Y' THEN 1
					ELSE 0 END AS CHK  --선택체크박스
			  ,LOTNO						 AS LOTNO   -- LOTNO
			  ,INQTY						 AS INQTY   -- 입고수량
			  ,INDATE						 AS INDATE  -- 입고 일자
			  ,DBO.FN_WORKERNAME(INWORKER)   AS INWORKER -- 입고자
			  ,DBO.FN_WORKERNAME(MAKER)      AS MAKER    -- 등록자
			  ,CONVERT(VARCHAR,MAKEDATE,120) AS MAKEDATE  -- 등록일시
			  ,DBO.FN_WORKERNAME(EDITOR)     AS EDITOR   -- 수정자
			  ,CONVERT(VARCHAR,EDITOR,120)   AS EDITDATE  -- 수정일시
		FROM TB_POMake WITH (NOLOCK)
	   WHERE PLANTCODE LIKE '%' + @PLANTCODE + '%'
	     AND CUSTCODE LIKE '%' + @CUSTCODE + '%'
		 AND PONO LIKE '%' + @PONO + '%'
		 AND PODATE BETWEEN @STARTDATE AND @ENDDATE
END
GO
