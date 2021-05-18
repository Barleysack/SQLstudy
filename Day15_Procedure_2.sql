create or alter proc usp_isyoung
	@username nvarchar(10)
as
	declare @byear int
	select @byear = birthyear from usertbl
	where name = @username;

	if (@byear >=1980)
	begin
		print '아직 젊습니다';
	end
	else
		
	begin
	print '늙';
	end

go
--함수처럼 생각하면 될듯

exec usp_isyoung '이승기'

