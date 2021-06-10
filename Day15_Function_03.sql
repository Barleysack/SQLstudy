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
		when (@byear%12=0) then '¿ø¼şÀÌ'
		when (@byear%12=1) then '´ß'
		when (@byear%12=2) then '°³'
		when (@byear%12=3) then 'µÅÁö'
		when (@byear%12=4) then 'Áã'
		when (@byear%12=5) then '¼Ò'
		when (@byear%12=6) then 'È£¶ûÀÌ'
		when (@byear%12=7) then 'Åä³¢'
		when (@byear%12=8) then '¿ë'
		when (@byear%12=9) then '¹ì'
		when (@byear%12=10) then '¸»'
		else '¾ç'
	end;
	return @zodiac
end
go
