--with parameters


use sqldb;
go

create view v_users
as
	select userID, name, birthYear, addr from usertbl;
go

select * from v_users



use sqldb;
go
create proc usp_users
as
select userid,name,birthyear,addr from userTbl;
go

exec usp_users;


create or alter proc usp_users1
@username nvarchar(10)

as
 --logics
 select userID,NAME, BIRTHYEAR FROM USERTBL
 where name =@username;

go

exec usp_users1 '���ð�'

CREATE or alter PROC USP_USERS2
@USERBIRTHYEAR INT,
@USERHEIGHT INT
AS
	SELECT userID,NAME,BIRTHYEAR,HEIGHT,mDate FROM USERTBL
	 WHERE birthYear >= @USERBIRTHYEAR
	   AND HEIGHT >= @USERHEIGHT;

GO

EXEC USP_USERS2 1970,178--���� ������ �ٲ㰡�� �� �ʿ�� ����
--���ν����� �Լ� �ڵ�����
--create or alter proc(func) ������ ������ ���ÿ� .

CREATE or alter PROC USP_USERS3 --alter�� ����
	@lastname nvarchar(2),
	@outcount int output--return�� �������� �����Ѵ�. ���ν��������� �̷� ������ ���Դϴ�
as
	select @outcount= count(*) from usertbl where name like @lastname + '%';
go

declare @myvalue int;
exec usp_users3 '��', @myvalue output;
print concat ('�达 ���� ���� ����� ���� ' ,@myvalue)

--���� ���Ѱ� Create or alter. 

