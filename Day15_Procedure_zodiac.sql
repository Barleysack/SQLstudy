CREATE or Alter PROC USP_ZODIAC
	@username nvarchar(10)

as
	declare @byear int
	declare @zodiac nvarchar(3)
	select @byear = birthyear from usertbl
	where name = @username


	set @zodiac =
	case 
		when (@byear%12=0) then '원숭이'
		when (@byear%12=1) then '닭'
		when (@byear%12=2) then '개'
		when (@byear%12=3) then '돼지'
		when (@byear%12=4) then '쥐'
		when (@byear%12=5) then '소'
		when (@byear%12=6) then '호랑이'
		when (@byear%12=7) then '토끼'
		when (@byear%12=8) then '용'
		when (@byear%12=9) then '뱀'
		when (@byear%12=10) then '말'
		else '양'
	end;
print concat(@username,'의 띠는 ', @zodiac ,'입니다')
go
exec USP_ZODIAC '성시경'

--저장프로시저는 성능을 향상시키나 이제는 잘 안쓴다.
--모듈식 프로그래밍이 가능하다
--보안을 강화할 수 있다.
--네트워크 전송량을 감소.. 하지만 잊혀지는중
