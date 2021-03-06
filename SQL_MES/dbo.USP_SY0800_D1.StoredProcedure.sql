USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0800_D1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0800_D1]
(
    @GRPID              VARCHAR(20)
   ,@LANG             	VARCHAR(5) = 'KO'
	 ,@RS_CODE            VARCHAR(1)   OUTPUT
   ,@RS_MSG             VARCHAR(200) OUTPUT  
)
AS
BEGIN
    DELETE FROM TSY0310
     WHERE GRPID = @GRPID
    
    UPDATE TSY0300
       SET GRPID = NULL
     WHERE GRPID = @GRPID
     
    DELETE TSY0100 
     WHERE WORKERID = @GRPID
    
    DELETE TSY0200 
     WHERE WORKERID = @GRPID
 RETURN
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]그룹관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0800_D1'
GO
