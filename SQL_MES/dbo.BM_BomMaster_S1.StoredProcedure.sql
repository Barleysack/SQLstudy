USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_BomMaster_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BM_BomMaster_S1]
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : BM_BomMaster_S1
  PROCEDURE NAME : BOM 조회
  ALTER DATE     : 2020.08
  MADE BY        : DSH
  DESCRIPTION    : 
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
(
     @PLANTCODE          VARCHAR(10)     -- 공장코드
    ,@ITEMCODE           VARCHAR(30)     -- 품목코드(모품번)
    ,@ITEMNAME           VARCHAR(30)     -- 품목코드(모품번)
    ,@USEFLAG            VARCHAR(1)      -- 사용여부
	,@TABIDX             VARCHAR(10)
    ,@LANG               VARCHAR(10)='KO'
    ,@RS_CODE            VARCHAR(1)   OUTPUT
    ,@RS_MSG             VARCHAR(200) OUT
)
AS

BEGIN
    BEGIN TRY

    IF @TABIDX = 'TAB1'  
	  BEGIN
        SELECT A.PLANTCODE                                  AS PLANTCODE    -- 공장코드
             , A.ITEMCODE                                   AS ITEMCODE     -- 품목코드
			 , B.ITEMNAME                                   AS ITEMNAME     -- 품목명
             , A.COMPONENT                                  AS COMPONENT    -- 하위구성부품(자품번)
			 , C.ITEMNAME                                   AS COMPONENTNAME
			 , A.BASEQTY                                    AS BASEQTY      -- 기준량
			 , A.UNITCODE                                   AS UNITCODE     -- 단위
             , A.LGORT_IN                                   AS LGORT_IN     -- 입고위치
             , A.LGORT_OUT                                  AS LGORT_OUT    -- 출고위치
             , A.COMPONENTQTY                               AS COMPONENTQTY -- COMPONENT 수량
             , A.COMPONENTUNIT                              AS COMPONENTUNIT -- 하위구성부품 단위
             , A.USEFLAG                                    AS USEFLAG      -- 사용유무
             , DBO.FN_WORKERNAME(A.MAKER)					AS MAKER        -- 등록자
             , CONVERT(VARCHAR,A.MAKEDATE,120)              AS MAKEDATE     -- 등록 일자
             , DBO.FN_WORKERNAME(A.EDITOR)					AS EDITOR       -- 수정자
             , CONVERT(VARCHAR,A.EDITDATE,120)              AS EDITDATE     -- 수정일자
         FROM TB_BomMaster A
    LEFT JOIN TB_ItemMaster B ON A.PLANTCODE = B.PLANTCODE AND A.ITEMCODE = B.ITEMCODE
    LEFT JOIN TB_ItemMaster C ON A.PLANTCODE = C.PLANTCODE AND A.COMPONENT = C.ITEMCODE
        WHERE 1=1
	      AND A.PLANTCODE               LIKE @PLANTCODE + '%'
          AND A.ITEMCODE                LIKE @ITEMCODE  + '%'
	       OR A.COMPONENT               LIKE @ITEMCODE  + '%'
          AND A.USEFLAG                 LIKE @USEFLAG   + '%'
	 ORDER BY A.ITEMCODE;
      END
	ELSE IF @TABIDX = 'TAB2'
	BEGIN
	  
	   DECLARE @LI_CNT INT;
	   
	   SET @LI_CNT = 0;
	   
	   SELECT @LI_CNT = COUNT(1)
	     FROM TB_ItemMaster
	    WHERE PLANTCODE = @PLANTCODE
	      AND ITEMCODE	= @ITEMCODE;
	      
	      
	   IF @LI_CNT = 0
	   BEGIN
	       SET @RS_CODE = 'E';
	       SET @RS_MSG  = '존재하지 않는 품번입니다. 정확한 품번을 입력하세요.';
	       RETURN;
	   END;
	   
       WITH BOMTABLE AS
            (
		      SELECT 1 AS LVL
					, ROW_NUMBER() OVER(ORDER BY  ITEMCODE) AS RN
			        , PARENT.PLANTCODE
			        , PARENT.ITEMCODE
					, PARENT.BASEQTY
					, PARENT.UNITCODE
					, PARENT.COMPONENT AS ITEMCD
					, ISNULL(PARENT.COMPONENTQTY, 1) AS QTY
					, PARENT.COMPONENTUNIT AS UNIT
					, PARENT.LGORT_IN
					, PARENT.LGORT_OUT
					, CONVERT(VARCHAR,ISNULL(PARENT.EDITDATE,PARENT.MAKEDATE),120) AS LASTEDITDATE
					, (SELECT DISPLAYNO 
					    FROM TB_Standard WITH (NOLOCK)
					   WHERE MAJORCODE = 'OPHEADER' 
					     AND MINORCODE = RIGHT(PARENT.COMPONENT, 1)) AS DISPLAYNO
			    FROM TB_BomMaster PARENT WITH ( NOLOCK )
			   WHERE PARENT.PLANTCODE = @PLANTCODE
			     AND PARENT.ITEMCODE  = @ITEMCODE
			     --AND PARENT.ITEMCODE  LIKE (CASE WHEN LEN(@ITEMCODE) = 0 THEN '%' ELSE @ITEMCODE + '%' END)			     
			   UNION ALL
			  SELECT  A.LVL+1  AS LVL
					, A.RN 	   AS RN
			        , CHILD.PLANTCODE
			        , CHILD.ITEMCODE
					, CHILD.BASEQTY
					, CHILD.UNITCODE
					, CHILD.COMPONENT 			    AS ITEMCD
					, ISNULL(CHILD.COMPONENTQTY, 1) AS QTY
					, CHILD.COMPONENTUNIT           AS UNIT
					, CHILD.LGORT_IN
					, CHILD.LGORT_OUT
					, CONVERT(VARCHAR,ISNULL(CHILD.EDITDATE,CHILD.MAKEDATE),120) AS LASTEDITDATE
					, (SELECT DISPLAYNO 
					    FROM TB_Standard WITH (NOLOCK)
					   WHERE MAJORCODE = 'OPHEADER' 
					     AND MINORCODE = RIGHT(CHILD.COMPONENT, 1)) AS DISPLAYNO
			   FROM TB_BomMaster CHILD WITH ( NOLOCK )
			   JOIN BOMTABLE A 
				 ON CHILD.ITEMCODE = A.ITEMCD
				AND CHILD.PLANTCODE = A.PLANTCODE
			)
			
			SELECT DISTINCT
					T1.DISPLAYNO       AS RN
			       ,REPLICATE('.',T1.LVL) + CONVERT(VARCHAR,T1.LVL)             AS LVL
				   ,T1.ITEMCODE        AS ITEMCODE
				   ,DBO.FN_ITEMNAME(T1.ITEMCODE, @PLANTCODE, 'KO') AS ITEMNAME
				   ,T1.BASEQTY         AS BASEQTY      -- 기준량
				   ,T1.UNITCODE        AS UNITCODE
				   ,T1.ITEMCD          AS COMPONENT
				   ,DBO.FN_ITEMNAME(T1.ITEMCD, @PLANTCODE, 'KO') AS COMPONENTNAME
				   ,T1.QTY             AS COMPONENTQTY -- COMPONENT 수량
                   ,T1.UNIT            AS COMPONENTUNIT -- 하위구성부품 단위
				   ,T1.LGORT_IN        AS LGORT_IN     -- 입고위치
                   ,T1.LGORT_OUT       AS LGORT_OUT    -- 출고위치
                   ,T1.LASTEDITDATE    AS LASTEDITDATE
			  FROM BOMTABLE T1
		  ORDER BY LVL DESC, ITEMCODE, DISPLAYNO  
		    OPTION (MAXRECURSION 0);

      END

      SET @RS_CODE = 'S'
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
