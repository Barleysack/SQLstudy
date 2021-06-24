USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[18PP_STockHALB_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*---------------------------------------------------------------------
    프로시져명: USP_PP_StockPP_S1
    개     요 : 공정 창고 재고 등록 / 취소 대상 조회
    작성자 명 : 동상현
    작성 일자 : 2020-08-31
    수정자 명 :
    수정 일자 :
    수정 사유 :  
    수정 내용 : 
----------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[18PP_STockHALB_S1]
(
      @PLANTCODE                VARCHAR(10)                          
    , @ITEMTYPE					VARCHAR(30)         
	, @LOTNO					VARCHAR(30)         
	   
	, @LANG                     VARCHAR(10)='KO'
	, @RS_CODE                  VARCHAR(1)   OUTPUT
    , @RS_MSG                   VARCHAR(200) OUTPUT 
)
AS
BEGIN
BEGIN TRY

	--생산출고등록 조회
	BEGIN
      	 SELECT A.PLANTCODE
        	   ,A.ITEMCODE
			   ,B.ITEMNAME			             AS ITEMNAME
			   ,B.ITEMTYPE
        	   ,A.LOTNO
        	   ,A.WORKCENTERCODE
        	   ,C.WORKCENTERNAME
        	   ,A.STOCKQTY
			   ,A.UNITCODE
			   
		   FROM TB_StockHALB A WITH(NOLOCK)
           JOIN TB_ItemMaster AS B WITH(NOLOCK) 
	         ON A.PLANTCODE = B.PLANTCODE
			and a.ITEMCODE = b.ITEMCODE
		   JOIN TB_WorkCenterMaster C WITH(NOLOCK) 
		     ON A.PLANTCODE = C.PLANTCODE
			AND A.WORKCENTERCODE = C.WORKCENTERCODE

          WHERE A.PLANTCODE LIKE @PLANTCODE + '%'
		    AND B.ITEMTYPE  LIKE @ITEMTYPE  
			AND A.LOTNO     LIKE @LOTNO     + '%'
			AND ISNULL(A.STOCKQTY,0)  <> 0 --재고인 경우만 조회
	END
	 

SELECT @RS_CODE = 'S'
     
END TRY                                
BEGIN CATCH
   SELECT @RS_CODE = 'E'
   SELECT @RS_MSG 	= ERROR_MESSAGE()
END CATCH   
		   
END






SELECT * FROM TB_ITEMMASTER
SELECT * FROM TB_STOCKHALB



GO
