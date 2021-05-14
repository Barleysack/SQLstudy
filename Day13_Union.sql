select stdname, region from stdtbl
--union 집합(테이블 합치기
select clubname, clubroom from clubtbl

select id, stdid from reginfotbl

--데이터타입 일-치해야
select cast(id as varchar), stdid from reginfotbl --형변환해야 가-능

union
select clubname, clubroom from clubtbl