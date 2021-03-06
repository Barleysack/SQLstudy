USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0200_S3N_W]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0200_S3N_W]
(
    
     @PAGEINDEX       INT
    ,@SORTCOLUMNNAME  VARCHAR(50)
    ,@SORTORDERBY     VARCHAR(4)
    ,@NUMBEROFROWS    INT 
    ,@TOTALRECODRDS   INT          OUTPUT
    ,@WORKERID        VARCHAR(30)
	,@WORKERNAME	  VARCHAR(30)
	,@USEFLAG 		  VARCHAR(1)
	,@LANG            VARCHAR(10)
	,@RS_CODE         VARCHAR(1)    OUTPUT
    ,@RS_MSG          VARCHAR(200)  OUTPUT  
)
AS
BEGIN
  BEGIN TRY
  
      DECLARE @STARTROW INT
      DECLARE @ENDROW INT
      SET     @STARTROW = ((@PAGEINDEX-1) * @NUMBEROFROWS);
      SET     @ENDROW = @STARTROW + @NUMBEROFROWS -1
      
/* MS_SQL 2012 이상 버전에서 동작
         SELECT WORKERID  
            ,WORKERNAME
	        ,PWD
	        ,GRPID
	        ,LANG
	        ,USEFLAG
	        ,DBO.FN_WORKERNAME(MAKER) AS MAKER
	        ,MAKEDATE
	        ,DBO.FN_WORKERNAME(EDITOR) AS EDITOR
	        ,EDITDATE
        FROM TSY0300
       WHERE WORKERID LIKE @WORKERID + '%'
         AND WORKERNAME LIKE @WORKERNAME + '%'
         AND USEFLAG  LIKE @USEFLAG + '%'
         AND WORKERID <> 'SYSTEM'
    ORDER BY WORKERNAME
          OFFSET @STARTROW ROWS
          FETCH NEXT @NUMBEROFROWS ROWS ONLY
************************************************/   

/*************************2012 버전 이하 *****************/
      SELECT WORKERID      AS  WORKERID
            ,WORKERNAME    AS  WORKERNAME
	        ,PWD           AS  PWD
	        ,GRPID         AS   GRPID
	        ,LANG          AS LANG
	        ,USEFLAG       AS  USEFLAG
	        ,DBO.FN_WORKERNAME(MAKER)  AS MAKER
	        ,MAKEDATE                  AS MAKEDATE
	        ,DBO.FN_WORKERNAME(EDITOR) AS EDITOR
	        ,EDITDATE                  AS EDITDATE
      FROM
    ( SELECT ROW_NUMBER() OVER(ORDER BY WORKERNAME) AS  ROWNO
            ,WORKERID      AS  WORKERID
            ,WORKERNAME    AS  WORKERNAME
	        ,PWD           AS  PWD
	        ,GRPID         AS   GRPID
	        ,LANG          AS LANG
	        ,USEFLAG       AS  USEFLAG
	        ,DBO.FN_WORKERNAME(MAKER)  AS MAKER
	        ,MAKEDATE                  AS MAKEDATE
	        ,DBO.FN_WORKERNAME(EDITOR) AS EDITOR
	        ,EDITDATE                  AS EDITDATE
        FROM TSY0300
       WHERE WORKERID   LIKE @WORKERID + '%'
         AND WORKERNAME LIKE @WORKERNAME + '%'
         AND USEFLAG    LIKE @USEFLAG + '%'
         AND WORKERID <> 'SYSTEM'
  --  ORDER BY WORKERNAME
          ) T
          WHERE T.ROWNO BETWEEN  @STARTROW AND  @ENDROW

/**********************************************************/   
        SELECT @TOTALRECODRDS = COUNT(*)
          FROM TSY0300
       WHERE WORKERID   LIKE @WORKERID + '%'
         AND WORKERNAME LIKE @WORKERNAME + '%'
         AND USEFLAG    LIKE @USEFLAG + '%'
         AND WORKERID    <> 'SYSTEM' 
      
  SELECT @RS_CODE = 'S'
 
  END TRY
                                
  BEGIN CATCH
      SELECT @RS_CODE = 'E'
    SELECT @RS_MSG  = ERROR_MESSAGE()
  END CATCH  
END
GO
