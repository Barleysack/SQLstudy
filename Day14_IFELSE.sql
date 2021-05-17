--sql programming
declare @var1 int;
set @var1 = 179

if (@var1<170)
begin
print'기준값이 작습니다'
end
ELSE IF @VAR1>190
BEGIN
PRINT('어우 겁내 크네')
END
else
begin
select * from userTbl WHERE HEIGHT > @VAR1;
END