USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[07PP_WCTRunStopList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김은희
-- Create date: 2021-06-10
-- Description:	작업장 비가동 현황 및 사유 관리 조회
-- =============================================
CREATE PROCEDURE [dbo].[07PP_WCTRunStopList_S1]
(
      @PLANTCODE       VARCHAR(10)    -- 공장
	 ,@WORKCENTERCODE  VARCHAR(10)    -- 작업장
	 ,@RSSTARTDATE	   VARCHAR(10)    -- 가동시작일자
	 ,@RSENDDATE	   VARCHAR(10)    -- 가동종료일자

     ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT
)
AS
BEGIN
    BEGIN TRY
		SELECT A.PLANTCODE		                                        AS PLANTCODE		-- 공장           
		      ,A.RSSEQ													AS RSSEQ			-- 작업장지시별 순번
		      ,A.WORKCENTERCODE	                                        AS WORKCENTERCODE	-- 작업장         
			  ,DBO.FN_WORKCENTERNAME(A.WORKCENTERCODE,A.PLANTCODE,'KO') AS WORKCENTERNAME	-- 작업장명       
			  ,A.ORDERNO			                                    AS ORDERNO			-- 작업지시번호  
			  ,DBO.FN_WORKERNAME(A.WORKER)			                    AS WORKER			-- 품목코드       
			  ,A.ITEMCODE			                                    AS ITEMCODE			-- 품명       
			  ,DBO.FN_ITEMNAME(A.ITEMCODE,A.PLANTCODE,'KO')             AS ITEMNAME			-- 작업자         
			  ,A.STATUS			                                        AS STATUS			-- 가동/비가동   
			  ,CASE WHEN A.STATUS = 'R' THEN '가동' ELSE '비가동' END   AS STATUSNAME	   -- 가동/비가동    
			  ,CONVERT(VARCHAR,A.RSSTARTDATE,120)						AS RSSTARTDATE		-- 시작일시    
			  ,CONVERT(VARCHAR,A.RSENDDATE,120)						    AS RSENDDATE		-- 종료일시     
			  ,DATEDIFF(MI,RSSTARTDATE,RSENDDATE)						AS TIMEDIFF			-- 소요시간(분)   
			  ,A.PRODQTY										        AS PRODQTY			-- 양품수량     
			  ,A.BADQTY												    AS BADQTY			-- 불량수량      
			  ,A.REMARK												    AS REMARK			-- 사유        
			  ,CONVERT(VARCHAR,A.MAKEDATE,120)						    AS MAKEDATE			-- 등록자         
			  ,DBO.FN_WORKERNAME(A.MAKER)								AS MAKER			-- 등록일시      
			  ,CONVERT(VARCHAR,A.EDITDATE,120)						    AS EDITDATE			-- 수정자         
			  ,DBO.FN_WORKERNAME(A.EDITOR)							    AS EDITOR			-- 수정일시      
		  FROM TP_WorkcenterStatusRec A WITH(NOLOCK) 
		 WHERE A.PLANTCODE      LIKE '%' + @PLANTCODE + '%'
		   AND A.WORKCENTERCODE LIKE '%' + @WORKCENTERCODE + '%'
		   AND A.RSSTARTDATE BETWEEN @RSSTARTDATE + ' 00:00:00' AND @RSENDDATE + ' 23:59:59'
      ORDER BY PLANTCODE,ORDERNO,WORKCENTERCODE, RSSTARTDATE  

    END TRY

    BEGIN CATCH
        INSERT INTO ERRORMESSAGE ( NAME, ERROR, ELINE, MESSAGE, DATE )
			SELECT ERROR_PROCEDURE() AS ERRORPROCEDURE
				 , ERROR_NUMBER()    AS ERRORNUMBER
				 , ERROR_LINE()      AS ERRORLINE
				 , ERROR_MESSAGE()   AS ERRORMESSAGE
				 , GETDATE()
		
		SELECT @RS_CODE = 'E'
		SELECT @RS_MSG = ERROR_MESSAGE()
    END CATCH
END





GO
