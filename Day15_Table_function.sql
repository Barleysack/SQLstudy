create or alter function ufn_getusers(@height int)
	returns table
as

	return( select * from usertbl 
			where height > @height)
			--table��ȯ�� begin end �ʿ����

go

select * from dbo.ufn_getusers(170);--table �κп� �Լ��� ȣ���ؼ� ����� �³�?


