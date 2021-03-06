USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_SY0200_POP]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SY0200_POP]
(
	   @PLANTCODE 		VARCHAR(10)
	  ,@OPCODE  		VARCHAR(30)
	  ,@LINECODE 		VARCHAR(30)
	  ,@WORKCENTERCODE 	VARCHAR(30)
	  ,@WORKERID        VARCHAR(30)
	  ,@WORKERNAME		VARCHAR(30)
	  ,@USEFLAG 		VARCHAR(10)
      ,@LANG         	VARCHAR(10) ='KO' 
 	  ,@RS_CODE         VARCHAR(1)='S' OUTPUT
      ,@RS_MSG          VARCHAR(200) OUTPUT 
)
AS

BEGIN

	BEGIN TRY
		IF (@PLANTCODE='ALL')
		BEGIN
			SET @PLANTCODE=''
		END
		IF (@USEFLAG='ALL')
		BEGIN
			SET @USEFLAG=''
		END
	
	  	SELECT WORKERID ,WORKERNAME
	      FROM TSY0300
	     WHERE WORKERID LIKE @WORKERID + '%'
	       AND WORKERNAME LIKE @WORKERNAME + '%'
	       AND USEFLAG  LIKE @USEFLAG + '%'
	       AND WORKERID <> 'SYSTEM'
	   ORDER BY WORKERNAME
	END TRY

	BEGIN CATCH
	     SELECT  @RS_MSG = ERROR_MESSAGE()
	     SELECT  @RS_CODE = 'E'
	  
	    		INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE)
				SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
					 , ERROR_NUMBER() AS ERRORNUMBER
					 , ERROR_LINE() AS ERRORLINE
					 , ERROR_MESSAGE() AS ERRORMESSAGE
	 END CATCH       
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DESCRIPTION', @value=N'[시스템]사용자관리_복사' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'USP_SY0200_POP'
GO
