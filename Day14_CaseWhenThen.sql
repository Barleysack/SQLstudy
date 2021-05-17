-- CASE -- IF문보다 짧고 간결하기에 잘 쓰이는 편이다
-- BEGIN END 도 쓸 필요 없다
--SWITCH CASE 랑은 또 다른 느낌--CASE/WHEN/THEN
DECLARE @point int, @credit char(1)
set @point = 100;
set @credit = 
case
	when (@point>=90) then 'A'
	When (@point>=80) then 'B'
	When (@point>=70) then 'C'
	When (@point>=60) then 'D'
	When (@point>=50) then 'E'
	ELSE 'F'
END --이것이 case when then

print concat(' 취득점수는 ' , @point)	
print concat(' 학점은 ' , @credit)	

