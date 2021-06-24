USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[08PP_WorkerPerProd_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		김종우
-- Create date: 2021-06-15
-- Description:	작업자 일별 생산실적
-- =============================================
CREATE PROCEDURE [dbo].[08PP_WorkerPerProd_S1]
	        @PLANTCODE VARCHAR(10),         
	        @STARTDATE VARCHAR(10),	       
	        @ENDDATE   VARCHAR(10),
			@WORKER	   VARCHAR(15),
	        
	        @LANG    VARCHAR(10)    = 'KO',    -- 언어
	        @RS_CODE VARCHAR(10) OUTPUT,	   -- 성공 여부
	        @RS_MSG  VARCHAR(200) OUTPUT		   -- 성공 관련 메세지


AS
BEGIN

	SELECT B.PLANTCODE                                              AS PLANTCODE      -- 공장 
		  ,DBO.FN_WORKERNAME(B.MAKER)                               AS WORKER		  -- 작업자
		  ,B.PRODDATE												AS PRODDATE		  -- 생산일자
		  ,B.WORKCENTERCODE	                                        AS WORKCENTERCODE -- 작업장
		  ,A.WORKCENTERNAME                                         AS WORKCENTERNAME -- 작업장 명
		  ,B.ITEMCODE												AS ITEMCODE		  -- 품목
		  ,C.ITEMNAME												AS ITEMNAME		  -- 품목 명
		  ,B.PRODQTY                                                AS PRODQTY		  -- 양품수량
		  ,B.BADQTY                                                 AS BADQTY         -- 불량수량
		  ,B.TOTALQTY												AS TOTALQTY		  -- 총 생산량
		  , CASE 
		      WHEN B.TOTALQTY = 0    THEN '0%'
              WHEN B.TOTALQTY =NULL  THEN '0%'
              ELSE CONCAT( ROUND(B.BADQTY*100/B.TOTALQTY,1), '%' )
			END														AS BADRATE		  -- 불량률
		  ,CONVERT(VARCHAR, B.MAKEDATE, 23)							AS MAKEDATE		  -- 생산일시


	  
	  FROM  TB_WorkCenterMaster A WITH(NOLOCK) LEFT JOIN TP_WorkcenterPerProd B WITH(NOLOCK)
	                                                     ON A.WORKCENTERCODE    = B.WORKCENTERCODE
												  LEFT JOIN TB_ItemMaster C WITH(NOLOCK)
												         ON B.ITEMCODE			= C.ITEMCODE
												 
	
	WHERE   A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND  B.MAKER						LIKE '%' + @WORKER      + '%'
	   AND  B.MAKEDATE				    BETWEEN    @STARTDATE AND @ENDDATE

	    ORDER BY B.MAKER, B.PRODDATE, B.WORKCENTERCODE, B.MAKEDATE
END
GO
