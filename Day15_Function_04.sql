--입력한 출생연도 이후의 사용자 중 구매등급을 반환
create or alter function ufn_usergrade(@byear int)
	returns @retable TABLE
	(userid char(8), name nchar(10), grade nvarchar(5)
	)
as
begin
	Declare @rowcount int;
	select @rowcount = count(*) from usertbl where birthyear>=@byear;
	if @rowcount <=0
	begin
		insert into @retable values ('없음','없음','없음')
		return;
	end
	else
	begin
	insert into @retable
	select u.userid,u.name,case 
	when sum(b.price*b.amount)>=1500 then 'great'
	when sum(b.price*b.amount)>=1000 then 'good'
	when sum(b.price*b.amount)>=10 then 'nice'
	else 'fine'
	end
	
	from usertbl as u
	left outer join buytbl as b
	on u.userid = b.userID
	where u.birthyear >= @byear
	group by u.userid, u.name
	return;
	end
	return;
end

go