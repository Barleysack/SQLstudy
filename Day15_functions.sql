/*����� ���� �Լ�
����: ���� ���ν����� ���� ����غ������� �Ϲ����� ���α׷��� ���� 
���Ǵ� �Լ��� ���� ������ ���α׷��� ����.
�Լ��� ��ȯ����.
���� ���ν����� exec�� �ƴ� �ַ� select�� ���ԵǾ� �����.
*/
create or alter function ufn_Getage
(@byear int)
returns int
as
begin
	declare @age int
	set @age = (year(getdate()) - @byear)+1 --�ѱ�����
	return(@age)
end
go

select userid, name, birthyear, dbo.ufn_getage(birthyear) as '����' ,
addr,height,dbo.ufn_getinch(height) as '��ġ' from usertbl;

