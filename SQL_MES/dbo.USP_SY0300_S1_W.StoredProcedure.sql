USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0300_S1_W]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0300_S1_W]
(
    
     @PAGEINDEX         INT
    ,@SORTCOLUMNNAME    VARCHAR(50)
    ,@SORTORDERBY       VARCHAR(4)
    ,@NUMBEROFROWS      INT 
    ,@TOTALRECODRDS     INT     OUTPUT
    ,@SDATE             DATETIME
	,@SDATE1            DATETIME
	,@WORKERID          VARCHAR(20)
    ,@LANG              VARCHAR(10)='KO'
    ,@RS_CODE           VARCHAR(1) OUTPUT
    ,@RS_MSG            VARCHAR(200) OUTPUT 
)
AS
BEGIN
  BEGIN TRY
  
      DECLARE @STARTROW INT
      DECLARE @ENDROW   INT
      SET     @STARTROW = ((@PAGEINDEX-1) * @NUMBEROFROWS);
      SET     @ENDROW = @STARTROW + @NUMBEROFROWS -1
      
/* MS_SQL 2012 이상 버전에서 동작
           SELECT WORKERID    AS WORKERID   -- 사용자
           ,WORKERNAME  AS WORKERNAME -- 사용자명
           ,SDATE       AS SDATE      -- 시작일
           ,STIME       AS STIME      -- 시작시간
           ,CONVERT(VARCHAR, SSTAMP, 120) AS SSTAMP      -- 시작일자
           ,EDATE       AS EDATE      -- 종료일
           ,ETIME       AS ETIME      -- 종료시간
           ,CONVERT(VARCHAR, ESTAMP, 120) AS ESTAMP      -- 종료일자
           ,STATE       AS STATE      -- 상태
           ,PROGID      AS PROGID     -- 화면 ID
           ,RUNTIME     AS RUNTIME    -- 사용시간
           ,RUNSTR      AS RUNSTR     -- 사용내역
           ,IPADDRESS   AS IPADDRESS  -- IP주소
           ,COMNAME     AS COMNAME    -- COMPUTER명 
           ,REMARK      AS REMARK     -- 비고
       FROM TSY0500 WITH(NOLOCK)
      WHERE SDATE   >=   @SDATE
        AND SDATE   <=   @SDATE1
		AND WORKERID LIKE @WORKERID + '%'
   ORDER BY SDATE
          OFFSET @STARTROW ROWS
          FETCH NEXT @NUMBEROFROWS ROWS ONLY
************************************************/   

/*************************2012 버전 이하 *****************/
    SELECT  WORKERID    AS WORKERID   -- 사용자
           ,WORKERNAME  AS WORKERNAME -- 사용자명
           ,SDATE       AS SDATE      -- 시작일
           ,STIME       AS STIME      -- 시작시간
           ,CONVERT(VARCHAR, SSTAMP, 120) AS SSTAMP      -- 시작일자
           ,EDATE       AS EDATE      -- 종료일
           ,ETIME       AS ETIME      -- 종료시간
           ,CONVERT(VARCHAR, ESTAMP, 120) AS ESTAMP      -- 종료일자
           ,STATE       AS STATE      -- 상태
           ,PROGID      AS PROGID     -- 화면 ID
           ,RUNTIME     AS RUNTIME    -- 사용시간
           ,RUNSTR      AS RUNSTR     -- 사용내역
           ,IPADDRESS   AS IPADDRESS  -- IP주소
           ,COMNAME     AS COMNAME    -- COMPUTER명 
           ,REMARK      AS REMARK     -- 비고
      FROM
      (SELECT ROW_NUMBER() OVER(ORDER BY SDATE) AS  ROWNO
           ,WORKERID    AS WORKERID   -- 사용자
           ,WORKERNAME  AS WORKERNAME -- 사용자명
           ,SDATE       AS SDATE      -- 시작일
           ,STIME       AS STIME      -- 시작시간
           ,CONVERT(VARCHAR, SSTAMP, 120) AS SSTAMP      -- 시작일자
           ,EDATE       AS EDATE      -- 종료일
           ,ETIME       AS ETIME      -- 종료시간
           ,CONVERT(VARCHAR, ESTAMP, 120) AS ESTAMP      -- 종료일자
           ,STATE       AS STATE      -- 상태
           ,PROGID      AS PROGID     -- 화면 ID
           ,RUNTIME     AS RUNTIME    -- 사용시간
           ,RUNSTR      AS RUNSTR     -- 사용내역
           ,IPADDRESS   AS IPADDRESS  -- IP주소
           ,COMNAME     AS COMNAME    -- COMPUTER명 
           ,REMARK      AS REMARK     -- 비고
       FROM TSY0500 WITH(NOLOCK)
      WHERE SDATE   >=   @SDATE
        AND SDATE   <=   @SDATE1
		AND WORKERID LIKE @WORKERID + '%'
   --ORDER BY SDATE
          ) T
          WHERE T.ROWNO BETWEEN  @STARTROW AND  @ENDROW

/**********************************************************/   
        SELECT @TOTALRECODRDS = COUNT(*)
            FROM TSY0500 WITH(NOLOCK)
      WHERE SDATE   >=   @SDATE
        AND SDATE   <=   @SDATE1
		AND WORKERID LIKE @WORKERID + '%'
      
  SELECT @RS_CODE = 'S'
 
  END TRY
                                
  BEGIN CATCH
      SELECT @RS_CODE = 'E'
    SELECT @RS_MSG  = ERROR_MESSAGE()
  END CATCH  
END
GO
