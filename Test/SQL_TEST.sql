select email,mobile,Names,addr from membertbl 
order by names desc;--01��

select names,author,ReleaseDate,price from bookstbl --02��

select idx,
concat('���� : ',names) as Names,
concat('���� > ',author) as Author,
format(releasedate,'yyyy�� MM�� dd��') as '������',
ISBN,format(price,'#,0��') as ���� 
from bookstbl order by idx desc --03��


SELECT m.names,m.levels,m.addr,r.rentaldate from membertbl as m
left outer join rentaltbl as r
on m.idx=r.memberidx
where r.memberidx is null
order by m.idx asc -- 04��


select d.names,(format(sum(b.price),'#,0��')) as '���հ�ݾ�' from divtbl as d
inner join bookstbl as b
on b.division=d.division
group by rollup(d.names) --05��




