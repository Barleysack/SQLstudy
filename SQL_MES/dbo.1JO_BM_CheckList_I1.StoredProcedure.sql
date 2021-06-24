USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[1JO_BM_CheckList_I1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		한정은
-- Create date: 2021-06-18
-- Description:	검사 항목 마스터 삽입
-- =============================================
CREATE PROCEDURE [dbo].[1JO_BM_CheckList_I1]
	@PLANTCODE   VARCHAR(10)
	,@CHECKCODE   VARCHAR(30)  -- 검사항목 코드
	,@CHECKNAME   VARCHAR(100) -- 검사항목 명
	,@CHECKSPEC   VARCHAR(50)  -- 검사 스펙
	,@MEASURETYPE VARCHAR(10)  -- 검사 방법
	,@MAKER       VARCHAR(10)  -- 등록자
	,@MAKEDATE    DATETIME     -- 등록일시

	,@LANG        VARCHAR(10) = 'KO' 
	,@RS_CODE     VARCHAR(1)   OUTPUT
	,@RS_MSG      VARCHAR(200) OUTPUT
	
AS
BEGIN
   DECLARE @LS_CHECKCOUNT INT -- 검사 항목 코드 등록 중복 여부 확인용
   SET  @LS_CHECKCOUNT = 0;

   BEGIN
        SELECT @LS_CHECKCOUNT = COUNT(*)
	      FROM  TB_CheckMaster WITH(NOLOCK)
		  WHERE CHECKCODE = @CHECKCODE

		IF (@LS_CHECKCOUNT > 0)
		BEGIN 
			SET @RS_CODE = 'E'
			SET @RS_MSG  = '이미 등록된 항목 입니다.'
			RETURN;
		END
   END

   	DECLARE @LI_SEQ INT
	 SELECT @LI_SEQ = ISNULL(COUNT(*),0) +1
	   FROM TB_CheckMaster WITH(NOLOCK)
	  WHERE PLANTCODE		= @PLANTCODE

	    

   --생산된 제품의 LOT 채번
	DECLARE @CHKCODE VARCHAR(30)
		SET @CHKCODE = 'Han2106'  + RIGHT('0'+ CONVERT(VARCHAR,@LI_SEQ),2)

   INSERT INTO TB_CheckMaster
   (PLANTCODE,  CHECKCODE,  CHECKNAME,  CHECKSPEC,  MEASURETYPE,  MAKER, MAKEDATE)
   VALUES
   ('1000',    @CHKCODE, @CHECKNAME, @CHECKSPEC, @MEASURETYPE, @MAKER, GETDATE())

   SET @RS_CODE = 'S'
END


select * from TB_CheckMaster
GO
