USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0101_POP]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0101_POP]  
(  
     @AS_GRPID        VARCHAR(30)  
    ,@AS_LANG         VARCHAR(10)
    ,@LANG             VARCHAR(5)
    ,@RS_CODE         VARCHAR(1)   OUTPUT
    ,@RS_MSG          VARCHAR(200) OUTPUT  
)  
AS  
BEGIN TRY
        SELECT A.PROGRAMID, A.MENUNAME, A.MENUTYPE, B.PROGTYPE--, C.UIDNAME, A.MENUTYPE, B.PROGTYPE
             , B.INQFLAG 
             , B.NEWFLAG 
             , B.SAVEFLAG
             , B.DELFLAG
             , B.EXCELFLAG
             , B.PRNFLAG
             , B.NAMESPACE, B.FILEID--, C.UIDTYPE, C.LANG
             , A.MENUID
             , A.PARMENUID
             , A.SORT
             , B.USEFLAG
          FROM (
                SELECT PROGRAMID, MENUNAME, MENUTYPE, MENUID, PARMENUID, SORT
                  FROM TSY0200 
                 WHERE WORKERID = 'SYSTEM'
                   AND PROGRAMID NOT IN (SELECT PROGRAMID 
                                           FROM TSY0200
                                          WHERE WORKERID = @AS_GRPID
                                            AND PROGRAMID IS NOT NULL) ) A LEFT OUTER JOIN (SELECT * FROM TSY0100 WHERE WORKERID = 'SYSTEM') B
                                                                                 ON A.PROGRAMID = B.PROGRAMID
                                                                   -- LEFT OUTER JOIN TSY1200 C
                                                                   --              ON A.PROGRAMID = C.UID
                                                                   --             AND C.LANG      = V_LANG
       --  WHERE A.PROGRAMID = AS_PROGRAMID
      ORDER BY A.PROGRAMID;
     
    SELECT @RS_CODE = 'S'

END TRY
                                
BEGIN CATCH
    SELECT @RS_CODE = 'E'
    SELECT @RS_MSG 	= ERROR_MESSAGE()
END CATCH
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]그룹관리 팝업' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0101_POP'
GO
