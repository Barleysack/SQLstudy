USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_ItemMaster_U1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : BM_ItemMaster_U1
  PROCEDURE NAME : 품목 마스터 수정
  ALTER DATE     : 2020.08
  MADE BY        : DSH
  DESCRIPTION    : 품목 마스터 수정
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[BM_ItemMaster_U1]
(  
    @PLANTCODE      VARCHAR(10)  --  공장
   ,@ITEMTYPE       VARCHAR(10)  --  품목구분
   ,@ITEMCODE       VARCHAR(30)  --  품목
   ,@ITEMNAME       VARCHAR(50)  --  품목명
   ,@BASEUNIT       VARCHAR(10)  --  기본단위
   ,@UNITWGT        FLOAT        --  단위중량
   ,@UNITCOST       FLOAT        --  단가
   ,@ITEMSPEC       VARCHAR(30)  --  규격
   ,@INSPFLAG       VARCHAR(10)  --  수입검사여부
   ,@UPH            FLOAT        --  UPH
   ,@CYCLETIME      FLOAT        --  사이클 타임
   ,@MAXSTOCK       FLOAT        --  적정재고
   ,@SAFESTOCK      FLOAT        --  안전재고
   ,@ASGNCODE       VARCHAR(10)  --  구매처
   ,@REMARK         VARCHAR(250) --  비고
   ,@USEFLAG        VARCHAR(1)   --  사용여부
   ,@EDITOR			VARCHAR(10)  --  수정자
   ,@LANG           VARCHAR(10)   ='KO'
   ,@RS_CODE        VARCHAR(1)    OUTPUT
   ,@RS_MSG         VARCHAR(200)  OUTPUT
)                                       
AS                                
BEGIN    
BEGIN TRY
    UPDATE TB_ItemMaster SET  ITEMTYPE	 = @ITEMTYPE
							 ,ITEMNAME	 = @ITEMNAME
							 ,BASEUNIT	 = @BASEUNIT
							 ,UNITWGT	 = @UNITWGT
							 ,UNITCOST	 = @UNITCOST
							 ,ITEMSPEC	 = @ITEMSPEC
							 ,INSPFLAG	 = @INSPFLAG
							 ,UPH		 = @UPH
							 ,CYCLETIME	 = @CYCLETIME
							 ,MAXSTOCK	 = @MAXSTOCK
							 ,SAFESTOCK	 = @SAFESTOCK
							 ,ASGNCODE	 = @ASGNCODE
							 ,REMARK	 = @REMARK
							 ,USEFLAG	 = @USEFLAG
							 ,EDITOR	 = @EDITOR
							 ,EDITDATE	 = GETDATE()
	 WHERE PLANTCODE  = @PLANTCODE
	   AND ITEMCODE	  = @ITEMCODE

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
