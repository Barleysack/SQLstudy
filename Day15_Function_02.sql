create or alter function ufn_Getinch(@height int)
returns int
as
begin
	declare @val int
	set @val =@height*0.393
	return (@val)
	end
	go

--보통 함수는 파라미터 한개 받아씀