USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[19PP_WorkerPerProd_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		장준기
-- Create date: 2021-06-15
-- Description:	작업자 일별 생산 실적
-- =============================================
CREATE PROCEDURE [dbo].[19PP_WorkerPerProd_S1]
     @PLANTCODE      VARCHAR(10),     --공장 코드
     @STARTDATE      VARCHAR(10),     --시작 일자
     @ENDDATE        VARCHAR(10),     --끝 일자
	 @WORKER         VARCHAR(10),     --작업자

     @LANG	  VARCHAR(10) ='KO',      --언어
     @RS_CODE VARCHAR(10) OUTPUT,     --성공 여부
     @RS_MSG  VARCHAR(200) OUTPUT     --성공 관련 메세지

AS
BEGIN

	SELECT A.PLANTCODE                  AS PLANTCODE
		 , A.MAKER                      AS WORKER        
		 , A.PRODDATE                   AS PRODDATE
		 , A.WORKCENTERCODE             AS WORKCENTERCODE
		 , B.WORKCENTERNAME             AS WORKCENTERNAME
		 , A.ITEMCODE                   AS ITEMCODE
		 , C.ITEMNAME                   AS ITEMNAME
		 , A.PRODQTY                    AS PRODQTY
		 , A.BADQTY                     AS BADQTY
 		 , A.TOTALQTY                   AS TOTALQTY
		 , CASE WHEN A.TOTALQTY = 0    THEN '0%'
		        WHEN A.TOTALQTY =NULL  THEN '0%'
				ELSE CONCAT( ROUND(A.BADQTY*100/A.TOTALQTY,1), '%' )
		   END                          AS BADPERCENT
		 , CONVERT(VARCHAR,A.MAKEDATE,120) AS PRODTIME

	  FROM TP_WorkcenterPerProd A WITH(NOLOCK)
	  LEFT JOIN TB_WorkCenterMaster B WITH(NOLOCK)
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.WORKCENTERCODE = B.WORKCENTERCODE
	  LEFT JOIN TB_ItemMaster C WITH(NOLOCK)
	    ON A.PLANTCODE = B.PLANTCODE
	   AND A.ITEMCODE = C.ITEMCODE

     WHERE A.PLANTCODE        LIKE '%' + @PLANTCODE + '%'
       AND A.MAKER            LIKE '%' + @WORKER + '%'
	   AND A.MAKEDATE    BETWEEN @STARTDATE AND @ENDDATE
	   ORDER BY A.MAKER,A.PRODDATE
END


GO
