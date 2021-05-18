CREATE or Alter PROC USP_ZODIAC
	@username nvarchar(10)

as
	declare @byear int
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
print concat(@username,'�� ��� ', @zodiac ,'�Դϴ�')
go
exec USP_ZODIAC '���ð�'

--�������ν����� ������ ����Ű�� ������ �� �Ⱦ���.
--���� ���α׷����� �����ϴ�
--������ ��ȭ�� �� �ִ�.
--��Ʈ��ũ ���۷��� ����.. ������ ����������
