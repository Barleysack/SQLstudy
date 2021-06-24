USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[12ER_ERRORREC_S2]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[12ER_ERRORREC_S2]
          @PLANTCODE      VARCHAR(10)    -- 공장
         ,@WORKCENTERCODE VARCHAR(10)
         ,@STARTDATE      VARCHAR(10)
         ,@ENDDATE        VARCHAR(10)
         

         ,@LANG      VARCHAR(10) = 'KO'
         ,@RS_CODE   VARCHAR(1)   OUTPUT
         ,@RS_MSG    VARCHAR(200) OUTPUT
   
AS
BEGIN
SELECT MAKER                              AS MAKER   
      ,MAKEDATE                           AS MAKEDATE
      ,REPAIRMAN                          AS REPAIRMAN
      ,REMARK                             AS REMARK
      ,REPAIRDATE                         AS REPAIRDATE
      ,DATEDIFF(mi,MAKEDATE,REPAIRDATE)   AS REPAIRTIME

         FROM TB_ERRORREC WITH(NOLOCK)
         WHERE PLANTCODE               = @PLANTCODE
           AND WORKCENTERCODE          = @WORKCENTERCODE
           AND MAKEDATE BETWEEN @STARTDATE AND @ENDDATE


END
GO
