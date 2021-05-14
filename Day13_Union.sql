select stdname, region from stdtbl
--union 집합(테이블 합치기
select clubname, clubroom from clubtbl

select id, stdid from reginfotbl

--데이터타입 일-치해야
select cast(id as varchar), stdid from reginfotbl --형변환해야 가-능

union
select clubname, clubroom from clubtbl


--EXCEPT - 2번째 쿼리에 해당하는 것을 제외함 
select name, concat(mobile1,mobile2) as mb from userTBL
except
select name, concat(mobile1,mobile2) as mb from userTBL
WHERE mobile1 is not null;