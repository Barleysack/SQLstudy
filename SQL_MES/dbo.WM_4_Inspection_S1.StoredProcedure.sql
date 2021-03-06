USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[WM_4_Inspection_S1]    Script Date: 2021-06-22 오후 5:42:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : PP_StockPP_S1
  PROCEDURE NAME : 공정 재고 조회
  ALTER DATE     : 2021.05
  MADE BY        : DSH
  DESCRIPTION    : 
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[WM_4_Inspection_S1]
(
      @LOTNO           VARCHAR(30)    -- LOTNO
     ,@LANG            VARCHAR(10)  ='KO'
     ,@RS_CODE         VARCHAR(1)   OUTPUT
     ,@RS_MSG          VARCHAR(200) OUTPUT
)
AS
BEGIN
    BEGIN TRY
	--SELECT * FROM TB_ItemMaster
      BEGIN
        SELECT A.PLANTCODE  AS PLANTCODE -- 공장
		      ,A.ITEMCODE   AS ITEMCODE  -- 품목 코드
			  ,A.WHCODE     AS WHCODE    -- 창고 
			  ,B.ITEMNAME   AS ITEMNAME  -- 품목 명
			  ,B.ITEMTYPE   AS ITEMTYPE  -- 품목 구분
			  ,A.LOTNO      AS LOTNO     -- LOTNO
			  ,A.STOCKQTY   AS STOCKQTY  -- 수량
			  ,B.BASEUNIT   AS UNITCODE  -- 단위
			  ,'[' + B.INSPFLAG + '] 검사'  AS INSPFLAG  -- 수입검사여부(I/U)
			  ,A.INSPRESULT AS INSPRESULT -- 검사결과
		  FROM TB_StockPP A WITH (NOLOCK) LEFT JOIN TB_ItemMaster B WITH (NOLOCK) 
												 ON A.PLANTCODE = B.PLANTCODE
												AND A.ITEMCODE  = B.ITEMCODE

		 WHERE A.LOTNO    LIKE '%' + @LOTNO + '%'
		   AND B.ITEMTYPE LIKE '%' + 'FERT' + '%'
		   AND A.STOCKQTY <> '0'
		   AND B.INSPFLAG LIKE '%' + 'I' +'%'
     END
           
      
    SELECT @RS_CODE = 'S'

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
