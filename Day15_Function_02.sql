create or alter function ufn_Getinch(@height int)
returns int
as
begin
	declare @val int
	set @val =@height*0.393
	return (@val)
	end
	go

--���� �Լ��� �Ķ���� �Ѱ� �޾ƾ�