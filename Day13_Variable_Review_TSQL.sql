use sqlDB;
go

declare @myvar1 int;
declare @myvar2 decimal(5,2);
declare @myvar3 Nchar(20);
declare @inchunit decimal(4,3);

set @myvar1 = 4000;
set @myvar2 = 3.14;
set @myvar3 = '�����̸� :';
set @inchunit = 0.393;

--select @myvar1 as '�ǹ̾��� ����',@myvar2 as '�̻��� �κ�';
--select name from usertbl where height > 180;
--select @myvar3 as 'string', name from usertbl where height >180;
select name, height*@inchunit as 'Ű(��ġ)' from usertbl ;