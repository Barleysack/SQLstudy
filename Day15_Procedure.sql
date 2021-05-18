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

exec usp_users1 '성시경'

CREATE or alter PROC USP_USERS2
@USERBIRTHYEAR INT,
@USERHEIGHT INT
AS
	SELECT userID,NAME,BIRTHYEAR,HEIGHT,mDate FROM USERTBL
	 WHERE birthYear >= @USERBIRTHYEAR
	   AND HEIGHT >= @USERHEIGHT;

GO

EXEC USP_USERS2 1970,178--굳이 순서를 바꿔가며 할 필요는 없다
--프로시저나 함수 코딩때는
--create or alter proc(func) 생성과 수정을 동시에 .

CREATE or alter PROC USP_USERS3 --alter가 수정
	@lastname nvarchar(2),
	@outcount int output--return의 개념으로 생각한다. 프로시저에서는 이런 식으로 쓰입니다
as
	select @outcount= count(*) from usertbl where name like @lastname + '%';
go

declare @myvalue int;
exec usp_users3 '김', @myvalue output;
print concat ('김씨 성을 가진 사용자 수는 ' ,@myvalue)

--제일 흔한건 Create or alter. 

