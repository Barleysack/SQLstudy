USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[17WM_StockOutWM_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 2021-06-17
-- Description:	상차 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[17WM_StockOutWM_S1]
		 @PLANTCODE	       VARCHAR(10)			 -- 공장
		,@CUSTCODE	       VARCHAR(10)			 -- 거래처 코드
		,@SHIPNO 	       VARCHAR(30)			 -- 상차 번호
		,@CARNO  	       VARCHAR(20)			 -- 차량 번호
		,@STARTDATE	       VARCHAR(10)			 -- 상차 일자 시작 범위
		,@ENDDATE	       VARCHAR(10)			 -- 상차 일자 끝 범위

		,@LANG             VARCHAR(10) = 'KO'     
		,@RS_CODE          VARCHAR(1)	 OUTPUT									  
		,@RS_MSG           VARCHAR(200)	 OUTPUT									  

AS
BEGIN
		SELECT   0     								     AS CHK      
			    ,PLANTCODE								     AS PLANTCODE
				,SHIPNO   									 AS SHIPNO   
				,SHIPDATE 									 AS SHIPDATE 
				,CARNO   								     AS CARNO   
				,CUSTCODE 									 AS CUSTCODE 
				,DBO.FN_CUSTNAME(PLANTCODE,CUSTCODE)         AS CUSTNAME 
				,WORKER  									 AS WORKER  
				,TRADINGNO									 AS TRADINGNO
				,TRADINGDATE								 AS TRADINGDATE
				,MAKEDATE 									 AS MAKEDATE 
				,MAKER   									 AS MAKER   
				,EDITDATE 								     AS	EDITDATE 
				,EDITOR  									 AS	EDITOR  
		  FROM TB_ShipWM WITH (NOLOCK) 
		 WHERE PLANTCODE   LIKE '%' +  @PLANTCODE		+ '%'
		   AND SHIPNO      LIKE '%' +  @SHIPNO		+ '%'
		   AND CARNO		 LIKE '%' +  @CARNO			+ '%'
		   AND CUSTCODE    LIKE '%' +  @CUSTCODE		+ '%'
		   AND SHIPDATE    BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'
		   AND TRADINGNO     IS NULL

	 SET @RS_CODE = 'S'
	 
		                                          
END
GO
