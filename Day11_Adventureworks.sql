
/*use AdventureWorksLT2019;
go
select * from SalesLT.Customer
Tablesample(10 percent);*/

select * from SalesLT.Customer
Order by FirstName
OFFSET 5 ROW
FETCH NEXT 3 ROWS ONLY;
--프로시저,함수