--sql programming
declare @var1 int;
set @var1 = 179

if (@var1<170)
begin
print'���ذ��� �۽��ϴ�'
end
ELSE IF @VAR1>190
BEGIN
PRINT('��� �̳� ũ��')
END
else
begin
select * from userTbl WHERE HEIGHT > @VAR1;
END