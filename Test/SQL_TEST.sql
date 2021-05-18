select email,mobile,Names,addr from membertbl 
order by names desc;--01번

select names,author,ReleaseDate,price from bookstbl --02번

select idx,
concat('제목 : ',names) as Names,
concat('저자 > ',author) as Author,
format(releasedate,'yyyy년 MM월 dd일') as '출판일',
ISBN,format(price,'#,0원') as 가격 
from bookstbl order by idx desc --03번


SELECT m.names,m.levels,m.addr,r.rentaldate from membertbl as m
left outer join rentaltbl as r
on m.idx=r.memberidx
where r.memberidx is null
order by m.idx asc -- 04번


select d.names,(format(sum(b.price),'#,0원')) as '총합계금액' from divtbl as d
inner join bookstbl as b
on b.division=d.division
group by rollup(d.names) --05번




