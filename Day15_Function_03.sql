create or alter function ufn_getzodiac(@year int)
returns nvarchar
as
begin
declare @byear int
declare @username nvarchar(3)
	declare @zodiac nvarchar(3)
	select @byear = birthyear from usertbl
	where name = @username 


	set @zodiac =
	case 
		when (@byear%12=0) then '������'
		when (@byear%12=1) then '��'
		when (@byear%12=2) then '��'
		when (@byear%12=3) then '����'
		when (@byear%12=4) then '��'
		when (@byear%12=5) then '��'
		when (@byear%12=6) then 'ȣ����'
		when (@byear%12=7) then '�䳢'
		when (@byear%12=8) then '��'
		when (@byear%12=9) then '��'
		when (@byear%12=10) then '��'
		else '��'
	end;
	return @zodiac
end
go
