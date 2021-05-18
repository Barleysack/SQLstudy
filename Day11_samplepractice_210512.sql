/****** SSMS의 SelectTopNRows 명령 스크립트 ******/
SELECT TOP (1000) [memberID]
      ,[memberName]
      ,[memberAddress]
  FROM [ShopDB].[dbo].[memberTBL]