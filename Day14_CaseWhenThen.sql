-- CASE -- IF������ ª�� �����ϱ⿡ �� ���̴� ���̴�
-- BEGIN END �� �� �ʿ� ����
--SWITCH CASE ���� �� �ٸ� ����--CASE/WHEN/THEN
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
END --�̰��� case when then

print concat(' ��������� ' , @point)	
print concat(' ������ ' , @credit)	

