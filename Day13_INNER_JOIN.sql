select * from stdTbl;
select * from clubtbl;

select s.stdid, s.stdname, r.clubname, r.regdate ,c.clubroom
from stdtbl as s
inner join reginfotbl as r
on s.stdid = r.stdid
inner join clubtbl as c
on c.clubname = r.clubname
where s.stdid = 'kbs';

