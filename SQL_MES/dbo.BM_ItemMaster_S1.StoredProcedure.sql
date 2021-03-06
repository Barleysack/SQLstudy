USE [KFQS_MES_2021]
GO
/****** Object:  StoredProcedure [dbo].[BM_ItemMaster_S1]    Script Date: 2021-06-22 오후 5:42:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*---------------------------------------------------------------------------------------------*
  PROEDURE ID    : BM_ItemMaster_S1
  PROCEDURE NAME : 품목 마스터 조회
  ALTER DATE     : 2020.08
  MADE BY        : DSH
  DESCRIPTION    : 품목 마스터 조회
  REMARK         : 
*---------------------------------------------------------------------------------------------*
  ALTER DATE     :
  UPDATE BY      :
  REMARK         :
*---------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[BM_ItemMaster_S1]
(  
    @PLANTCODE      VARCHAR(10)                                              
   ,@ITEMCODE       VARCHAR(30) 
   ,@ITEMNAME       VARCHAR(100)
   ,@ITEMTYPE       VARCHAR(10)
   ,@USEFLAG        VARCHAR(10)
   ,@LANG           VARCHAR(10)   ='KO'
   ,@RS_CODE        VARCHAR(1)    OUTPUT
   ,@RS_MSG         VARCHAR(200)  OUTPUT
)                                       
AS                                
BEGIN    
BEGIN TRY
    SELECT  A.PLANTCODE                 AS  PLANTCODE  
	      , A.ITEMTYPE                  AS  ITEMTYPE            
          , A.ITEMCODE                  AS  ITEMCODE           
          , A.ITEMNAME                  AS  ITEMNAME           
          , A.MAXSTOCK                  AS  MAXSTOCK          
          , A.SAFESTOCK                 AS  SAFESTOCK         
          , A.BASEUNIT                  AS  BASEUNIT            
		  , A.UPH					    AS  UPH	
		  , A.CYCLETIME					AS  CYCLETIME
          , A.UNITCOST                  AS  UNITCOST           
          , A.UNITWGT                   AS  UNITWGT             
          , A.INSPFLAG                  AS  INSPFLAG   
          , A.ITEMSPEC			        AS  ITEMSPEC
          , A.ASGNCODE                  AS  ASGNCODE          
          , A.USEFLAG                   AS  USEFLAG             
          , A.REMARK                    AS  REMARK              
		  , DBO.FN_WORKERNAME(A.MAKER)  AS  MAKER                 
          , A.MAKEDATE					AS  MAKEDATE           
          , DBO.FN_WORKERNAME(A.EDITOR) AS  EDITOR                
          , A.EDITDATE					AS  EDITDATE            
     FROM TB_ItemMaster A WITH(NOLOCK)      
LEFT JOIN TB_CustMaster  B ON A.PLANTCODE = B.PLANTCODE AND A.ASGNCODE = B.CUSTCODE
    WHERE 1=1
      AND A.PLANTCODE                      LIKE ISNULL(@PLANTCODE,'') + '%'      
      AND A.ITEMCODE                       LIKE ISNULL(@ITEMCODE,'')  + '%'
      AND ISNULL(A.ITEMNAME,'')            LIKE ISNULL(@ITEMNAME,'')  + '%'
      AND ISNULL(A.ITEMTYPE,'')            LIKE ISNULL(@ITEMTYPE,'')  + '%'
      AND ISNULL(A.USEFLAG,'')             LIKE ISNULL(@USEFLAG,'')   + '%'        
    ORDER BY A.PLANTCODE , A.ITEMCODE
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
