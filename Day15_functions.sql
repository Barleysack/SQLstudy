/*사용자 정의 함수
개념: 저장 프로시저와 조금 비슷해보이지만 일반적인 프로그래밍 언어에서 
사용되는 함수와 같이 복잡한 프로그래밍 가능.
함수는 반환가능.
저장 프로시져는 exec가 아닌 주로 select에 포함되어 실행됨.
*/
create or alter function ufn_Getage
(@byear int)
returns int
as
begin
	declare @age int
	set @age = (year(getdate()) - @byear)+1 --한국나이
	return(@age)
end
go

select userid, name, birthyear, dbo.ufn_getage(birthyear) as '나이' ,
addr,height,dbo.ufn_getinch(height) as '인치' from usertbl;

