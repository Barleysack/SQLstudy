USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[02QM_BadsStock_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		이해창
-- Create date: 2021-06-17
-- Description:	제품 출고 대상 상차 공통 내역 조회
-- =============================================
CREATE PROCEDURE [dbo].[02QM_BadsStock_S1]
		@PLANTCODE             VARCHAR(10) -- 공장
	   ,@ITEMCODE              VARCHAR(20) -- 품목
	   ,@STARTDATE             VARCHAR(10) -- 조회 시작일자
	   ,@ENDDATE               VARCHAR(10) -- 조회 종료 일자 
	   ,@BADTYPE               VARCHAR(10) -- 불량 사유

	   ,@LANG                  VARCHAR(10)  = 'KO'
	   ,@RS_CODE               VARCHAR(1)   OUTPUT
	   ,@RS_MSG                VARCHAR(200) OUTPUT
AS
BEGIN 
		 SELECT	PLANTCODE					            AS PLANTCODE
		       ,BADSEQ                                  AS BADSEQ 
			   ,ORDERNO					                AS ORDERNO
			   ,ITEMCODE				                AS ITEMCODE
			   ,ITEMNAME			                    AS ITEMNAME                        
			   ,BADQTY_TOTAL					        AS BADQTY_TOTAL
			   ,BADQTY					                AS BADQTY
			   ,BADTYPE							        AS BADTYPE
			   ,CHECKNUM						        AS CHECKNUM
			   ,INLOTNO			                        AS INLOTNO
			   ,WORKSTATUS			                    AS WORKSTATUS
			   ,WORKER			                        AS WORKER
			   ,WORKCENTERNAME		                    AS WORKCENTERNAME
			   ,MAKER		                            AS MAKER
			   ,CONVERT(VARCHAR,MAKEDATE,120)		    AS MAKEDATE
			   ,EDITOR		                            AS EDITOR
			   ,CONVERT(VARCHAR,EDITDATE,120)		    AS EDITDATE
			   ,0					                    AS COMFLAG


			
		   FROM TB_BadStock A WITH(NOLOCK)                 
		  WHERE PLANTCODE LIKE '%' + @PLANTCODE		 + '%'
			AND	ISNULL(ITEMCODE,'')  LIKE '%' + @ITEMCODE 		 + '%'
			AND	ISNULL(BADTYPE ,'')  LIKE '%' + @BADTYPE  		 + '%'
			AND ISNULL(COMFLAG,'0') = '0' 
			--AND	MAKEDATE  BETWEEN '1900-01-01' + ' 00:00:00' AND '2021-06-21' + ' 23:59:59'

			AND	MAKEDATE  BETWEEN @STARTDATE + ' 00:00:00' AND @ENDDATE + ' 23:59:59'
END

GO
