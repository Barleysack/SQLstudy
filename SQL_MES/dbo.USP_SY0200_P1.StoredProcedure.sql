USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0200_P1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0200_P1]
(
	   @FROMWORKERID         VARCHAR(30)
	  ,@TOWORKERID           VARCHAR(30)
   	  ,@SYSTEMID           VARCHAR(30)='SmartMES'
      ,@LANG         VARCHAR(10) ='KO' 
 	  ,@RS_CODE         VARCHAR(1) OUTPUT
      ,@RS_MSG          VARCHAR(200) OUTPUT  )
AS
BEGIN
    BEGIN TRY
     -- 사용자별 프로그램 정보 삭제
     DELETE FROM TSY0100
      WHERE WORKERID = @TOWORKERID
      AND SYSTEMID=@SYSTEMID;
     -- 사용자별 메뉴정보 삭제
     DELETE FROM TSY0200
      WHERE WORKERID = @TOWORKERID
      AND SYSTEMID=@SYSTEMID;
     
     -- 사용자별 프로그램 정보 복사
     INSERT INTO TSY0100
           (PROGRAMID, WORKERID, PROGRAMNAME, PROGTYPE
				, INQFLAG, NEWFLAG, DELFLAG, SAVEFLAG, EXCELFLAG, PRNFLAG
				, FILEID, NAMESPACE,SYSTEMID,USEFLAG
				, MAKEDATE, MAKER, EDITDATE, EDITOR)
				
	SELECT A.PROGRAMID
           ,@TOWORKERID
           ,A.PROGRAMNAME
           ,A.PROGTYPE
           ,A.INQFLAG
           ,A.NEWFLAG
           ,A.DELFLAG
           ,A.SAVEFLAG
           ,A.EXCELFLAG
           ,A.PRNFLAG
           ,A.FILEID
           ,A.NAMESPACE
           ,A.SYSTEMID
           ,A.USEFLAG
           ,GETDATE()
           ,A.MAKER
           ,GETDATE()
           ,A.EDITOR
       FROM TSY0100 A
      WHERE A.WORKERID = @FROMWORKERID
        AND A.SYSTEMID = @SYSTEMID
        AND A.PROGRAMID IN ( SELECT PROGRAMID FROM TSY0200 WHERE WORKERID = @FROMWORKERID )
        AND A.USEFLAG = 'Y';
      
      -- 사용자별 메뉴 정보 복사
      INSERT INTO TSY0200
            (MENUID, WORKERID, MENUNAME, PARMENUID, SORT
            , PROGRAMID, MENUTYPE, USEFLAG,SYSTEMID
            , MAKEDATE, MAKER, EDITOR, EDITDATE)
    SELECT B.MENUID
            ,@TOWORKERID
            ,B.MENUNAME
            ,B.PARMENUID
            ,B.SORT
            ,B.PROGRAMID
            ,B.MENUTYPE
            ,B.USEFLAG
            ,B.SYSTEMID
            ,B.MAKEDATE
            ,B.MAKER
            ,B.EDITOR
            ,B.EDITDATE
       FROM TSY0200 B 
       WHERE B.WORKERID = @FROMWORKERID
         AND B.SYSTEMID = @SYSTEMID
         AND B.USEFLAG = 'Y';
         
    	SET  @RS_CODE = 'S'  
    	
   	END TRY
	BEGIN CATCH                                                              
         SET  @RS_MSG = ERROR_MESSAGE()                               
         SET  @RS_CODE = 'E'  
         SELECT @RS_MSG                                        
	END CATCH
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]사용자관리_복사' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0200_P1'
GO
