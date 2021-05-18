select rank() over(order by height desc) as '키순위'--순위를 매기되 공동이면 그냥 넘어간다
      ,name, height, addr
from usertbl
where height is not null;

select dense_rank() over(order by height desc) as '키순위'--순위를 매기되 숫자는 연속적으로.
      ,name, height, addr
from usertbl
where height is not null;

select ROW_NUMBER() over(partition by addr order by height desc) as '키순위'
,name,height,addr
	from userTbl
	where height is not null;

select userid, sum(price*amount) as '사용자별 구매금액'
from buytbl
group by userID
ORDER BY sum(price*amount) DESC

select RANK() OVER(ORDER BY sum(price*amount) DESC) as '구매순위'
,USERID, SUM(PRICE*AMOUNT) AS '사용자별 구매금액' from buytbl
group by userID
ORDER BY sum(price*amount) DESC
FOR JSON AUTO;