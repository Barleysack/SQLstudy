USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[SPROC_ProgramList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPROC_ProgramList_S1]
(
       @PROGRAMID	       VARCHAR(10)
	  ,@PROGRAMNAME        VARCHAR(50)
	  ,@USEFLAG            VARCHAR(1)
	  ,@SYSTEMID           VARCHAR(20)
	  ,@WORKERID		   VARCHAR(10)
      ,@LANG         	   VARCHAR(10)='KO'
      ,@RS_CODE            VARCHAR(1)      OUTPUT
      ,@RS_MSG             VARCHAR(200)    OUTPUT 
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT @PROGRAMNAME = ISNULL(@PROGRAMNAME, '')
    BEGIN TRY 
    	SELECT A.PROGRAMID  AS PROGRAMID
             ,DBO.FN_TRANSLATE(@LANG, A.PROGRAMNAME ,'SY_ProgramList') AS PROGRAMNAME
             ,A.PROGTYPE    AS PROGTYPE
             ,B.CODENAME    AS CODENAME
             ,A.INQFLAG     AS INQFLAG
             ,A.NEWFLAG     AS NEWFLAG
             ,A.DELFLAG     AS DELFLAG
             ,A.SAVEFLAG	AS SAVEFLAG
             ,A.PRNFLAG	    AS PRNFLAG
             ,A.EXCELFLAG   AS EXCELFLAG
             ,A.FILEID	    AS FILEID
             ,A.NAMESPACE   AS NAMESPACE
             ,A.DEVELOPER   AS DEVELOPER
             ,A.CONTACT	    AS CONTACT
             ,A.AUTHDATE	AS AUTHDATE
             ,A.PARAM	    AS PARAM
             ,A.USEFLAG	    AS USEFLAG
             ,A.REMARK	    AS REMARK
             ,CONVERT(VARCHAR, A.MAKEDATE, 120)	AS MAKEDATE
             ,DBO.FN_WORKERNAME(A.MAKER)	    AS MAKER
             ,CONVERT(VARCHAR, A.EDITDATE, 120)	AS EDITDATE
             ,DBO.FN_WORKERNAME(A.EDITOR)	    AS EDITOR
             ,A.SYSTEMID    AS SYSTEMID
             ,@LANG         AS LANG
             ,DBO.FN_TRANSLATE(@LANG,A.PROGRAMNAME,'MN') AS UIDNAME
             ,A.TOPICID
         FROM sysProgramList A WITH(NOLOCK) LEFT OUTER JOIN TB_Standard B WITH(NOLOCK)
                                                         ON A.PROGTYPE  = B.MINORCODE
                                                        AND B.MAJORCODE = 'MENUTYPE'
        WHERE A.WORKERID            =    @WORKERID
          AND (@PROGRAMID = '' OR (@PROGRAMID != '' AND A.PROGRAMID LIKE @PROGRAMID + '%'))
          AND (ISNULL(DBO.FN_TRANSLATE(@LANG,A.PROGRAMNAME,''), A.PROGRAMNAME) LIKE '%' + @PROGRAMNAME + '%' OR A.PROGRAMNAME LIKE @PROGRAMNAME + '%')
          AND A.USEFLAG             LIKE @USEFLAG     + '%'
          AND A.SYSTEMID  = @SYSTEMID
     ORDER BY A.PROGRAMID
     
	    SELECT @RS_CODE = 'S'
	END TRY
	
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
	
	SET NOCOUNT OFF;
END

GO
