select rank() over(order by height desc) as 'Ű����'--������ �ű�� �����̸� �׳� �Ѿ��
      ,name, height, addr
from usertbl
where height is not null;

select dense_rank() over(order by height desc) as 'Ű����'--������ �ű�� ���ڴ� ����������.
      ,name, height, addr
from usertbl
where height is not null;

select ROW_NUMBER() over(partition by addr order by height desc) as 'Ű����'
,name,height,addr
	from userTbl
	where height is not null;

select userid, sum(price*amount) as '����ں� ���űݾ�'
from buytbl
group by userID
ORDER BY sum(price*amount) DESC

select RANK() OVER(ORDER BY sum(price*amount) DESC) as '���ż���'
,USERID, SUM(PRICE*AMOUNT) AS '����ں� ���űݾ�' from buytbl
group by userID
ORDER BY sum(price*amount) DESC
FOR JSON AUTO;