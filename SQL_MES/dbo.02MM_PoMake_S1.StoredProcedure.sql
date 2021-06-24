USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02MM_PoMake_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		강현업
-- Create date: <Create Date,,>
-- Description:	발주 및 입고 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[02MM_PoMake_S1]
	@PLANTCODE VARCHAR(10),			-- 공장 코드
	@CUSTCODE  VARCHAR(20),			-- 회사 코드
	@PONO	   VARCHAR(30),		    -- 발주번호
	@STARTDATE VARCHAR(10),			-- 발주 시작 일
	@ENDDATE   VARCHAR(10),			-- 발주 마감 일

	@LANG VARCHAR(10) = 'KO',		-- 언어
	@RS_CODE VARCHAR(10) OUTPUT,	-- 성공 여부
	@RS_MSG VARCHAR(200) OUTPUT		-- 성공 관련 메세지
AS
BEGIN
	SELECT PLANTCODE
		  ,PONO
		  ,ITEMCODE
		  ,PODATE
		  ,POQTY
		  ,UNITCODE
		  ,CUSTCODE
		  ,CASE WHEN ISNULL(INFLAG,'N') = 'Y' THEN 1  --입고 내역(INFALG)이 있다면은 1, 없다면 0
				ELSE 0 END				  AS CHK		--선택 체크 박스
		  ,LOTNO						--LOTNO
		  ,INQTY						--입고수량
		  ,INDATE						--입고일자
		  ,DBO.FN_WORKERNAME(INWORKER)    AS INWORKER   --입고자
		  ,DBO.FN_WORKERNAME(MAKER)       AS MAKER		--등록자
		  ,CONVERT(VARCHAR,MAKEDATE, 120) AS MAKEDATE	--등록일시
		  ,DBO.FN_WORKERNAME(EDITOR)      AS EDITOR		--수정자
		  ,CONVERT(VARCHAR,EDITDATE,120)  AS EDITDATE	--수정일시
	FROM TB_POMake WITH (NOLOCK)
	WHERE PLANTCODE LIKE '%' + @PLANTCODE + '%'
	  AND CUSTCODE  LIKE '%' + @CUSTCODE + '%'
	  AND PONO      LIKE '%' + @PONO + '%'
	  AND PODATE    BETWEEN @STARTDATE AND @ENDDATE
END
GO
