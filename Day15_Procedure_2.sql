create or alter proc usp_isyoung
	@username nvarchar(10)
as
	declare @byear int
	select @byear = birthyear from usertbl
	where name = @username;

	if (@byear >=1980)
	begin
		print '���� �����ϴ�';
	end
	else
		
	begin
	print '��';
	end

go
--�Լ�ó�� �����ϸ� �ɵ�

exec usp_isyoung '�̽±�'

