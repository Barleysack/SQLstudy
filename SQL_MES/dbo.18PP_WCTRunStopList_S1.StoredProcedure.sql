USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18PP_WCTRunStopList_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		임종훈
-- Create date: 2021-06-15
-- Description:	작업장 비가동 현황 및 사유관리
-- =============================================
CREATE PROCEDURE [dbo].[18PP_WCTRunStopList_S1]
	@PLANTCODE      VARCHAR(10)
   ,@WORKCENTERCODE VARCHAR(10)  
   ,@STARTDATE      VARCHAR(10)
   ,@ENDDATE        VARCHAR(10)

   ,@LANG           VARCHAR(10) = 'KO'
   ,@RS_CODE	    VARCHAR(1)    OUTPUT
   ,@RS_MSG			VARCHAR(200)  OUTPUT
AS
BEGIN
	SELECT A.PLANTCODE                                              AS PLANTCODE
		  ,A.RSSEQ                                                  AS RSSEQ
	      ,A.WORKCENTERCODE   		                                AS WORKCENTERCODE		  
	      ,B.WORKCENTERNAME  		                                AS WORKCENTERNAME		  
		  ,A.ORDERNO		                                        AS ORDERNO	      	  
		  ,A.ITEMCODE                                               AS ITEMCODE        
		  ,C.ITEMNAME		                                        AS ITEMNAME	
		  ,DBO.FN_WORKERNAME(A.MAKER)      		                    AS WORKER
		  ,CASE WHEN A.STATUS = 'R' THEN '가동' ELSE '비가동'  END   AS WORKSTATUS     -- 가동/비가동 상태
		  ,A.RSSTARTDATE                                            AS STARTDATE      -- 최초 가동 시작 시간
		  ,A.RSENDDATE                                              AS ENDDATE        -- 작업지시  종료 시간
		  ,DATEDIFF(MI,A.RSSTARTDATE,A.RSENDDATE)                   AS SOYO 
		  ,A.PRODQTY                                                AS PRODQTY		  -- 양품수량
		  ,A.BADQTY                                                 AS BADQTY         -- 불량수량
		  ,A.REMARK													AS REMARK
		  ,DBO.FN_WORKERNAME(A.MAKER)							    AS MAKER          -- 등록자
		  ,CONVERT(VARCHAR,A.MAKEDATE,120)							AS MAKEDATE       -- 등록일시
          ,DBO.FN_WORKERNAME(A.EDITOR)							    AS EDITOR         -- 수정자 
          ,CONVERT(VARCHAR,A.EDITDATE,120)							AS EDITDATE       -- 수정일시 

     --FROM  TP_WorkcenterPerProd A WITH(NOLOCK) LEFT JOIN TP_WorkcenterStatusRec B WITH(NOLOCK)
	    --                                         ON A.PLANTCODE      = B.PLANTCODE
					--							AND A.ORDERNO        = B.ORDERNO
					--							AND A.WORKCENTERCODE = B.WORKCENTERCODE
					--						   LEFT JOIN TB_WorkCenterMaster C WITH(NOLOCK)
					--						     ON A.PLANTCODE      = C.PLANTCODE
					--							AND A.WORKCENTERCODE = C.WORKCENTERCODE
					--						   LEFT JOIN TB_ItemMaster D WITH(NOLOCK)
					--						     ON A.PLANTCODE      = D.PLANTCODE
					--							AND A.ITEMCODE       = D.ITEMCODE
					--							LEFT JOIN TP_WorkcenterStatus E WITH(NOLOCK)
	    --                                         ON A.PLANTCODE      = E.PLANTCODE
					--							AND A.ORDERNO        = E.ORDERNO
					--							AND A.WORKCENTERCODE = E.WORKCENTERCODE

	FROM  TP_WorkcenterStatusRec A WITH(NOLOCK) LEFT JOIN TB_WorkCenterMaster B WITH(NOLOCK)
											      ON A.PLANTCODE      = B.PLANTCODE
												 AND A.WORKCENTERCODE = B.WORKCENTERCODE
											    LEFT JOIN TB_ItemMaster C WITH(NOLOCK)
											      ON A.PLANTCODE      = C.PLANTCODE
												 AND A.ITEMCODE       = C.ITEMCODE
	 WHERE A.PLANTCODE                 LIKE '%' + @PLANTCODE      + '%'
	   AND B.WORKCENTERCODE            LIKE '%' + @WORKCENTERCODE + '%'
	   AND A.RSSTARTDATE	         BETWEEN @STARTDATE AND @ENDDATE
END

SELECT * FROM TP_WorkcenterStatusRec
GO
