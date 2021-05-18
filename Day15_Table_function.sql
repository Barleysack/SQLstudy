create or alter function ufn_getusers(@height int)
	returns table
as

	return( select * from usertbl 
			where height > @height)
			--table반환시 begin end 필요읎다

go

select * from dbo.ufn_getusers(170);--table 부분에 함수를 호출해서 결과를 냈네?


