USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY1500_POP]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY1500_POP]    
(    
	  @PROGRAMID          VARCHAR(10)        -- 프로그램ID
     ,@LANG               VARCHAR(10)       -- 언어
     ,@RS_CODE         VARCHAR(1) OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT    
)    
AS    

BEGIN TRY
SELECT A.PROGRAMID, ISNULL(B.UIDNAME, A.PROGRAMNAME) AS UIDNAME
  FROM TSY0100 A LEFT OUTER JOIN (SELECT UIDSYS, UIDNAME FROM TSY1200 WHERE LANG = @LANG) B
                              ON A.PROGRAMID = B.UIDSYS
 WHERE A.WORKERID  = 'SYSTEM'
   AND A.PROGRAMID LIKE @PROGRAMID + '%'
        SELECT @RS_CODE = 'S'
		SELECT @RS_MSG 	= '정상적으로 삭제되었습니다.'	
		RETURN
	END TRY
                                
	BEGIN CATCH
	    SELECT @RS_CODE = 'E'
		SELECT @RS_MSG 	= ERROR_MESSAGE()
	END CATCH
GO
