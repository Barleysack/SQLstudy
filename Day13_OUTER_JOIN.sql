--외부조인--
--Outer Join--
Select u.userID, U.NAME, U.ADDR, concat(U.MOBILE1,u.mobile2) as mobile
, b.PRODNAME 
from usertbl as u
right OUTER JOIN buytbl as b
on u.userID=b.userid
WHERE B.PRODNAME IS NULL
order by u.userID



--학생/동아리/가입정보 테이블
--outer join
select s.stdid,s.StdName,s.region 
,r.clubname,c.clubroom,r.regdate from stdtbl as s
--3개짜리의 outer join은 쉽지 않다. 리뷰가 필요한 부분이다. 
left outer join ReginfoTbl as r
on s.StdID=r.stdid
left outer join clubtbl as C
ON c.clubname=r.clubname ;


select s.stdid,s.StdName,s.region 
,r.clubname,r.regdate from stdtbl as s
--3개짜리의 outer join은 쉽지 않다. 리뷰가 필요한 부분이다. 
--첫번째 아우터조인의 결과값과, 두번째 아우터조인을 시작한다. 라는 뜻! 굳!

left outer join ReginfoTbl as r
on s.StdID=r.stdid
left outer join clubtbl as C
ON c.clubname=r.clubname ;


select c.ClubName,c.clubROOM ,r.id,r.regdate
from clubtbl as c--왼쪽의 기준은 먼저나오는 쪽 - clubtbl, 부모테이블 측 from 측...!
--club이 아무도 가입하지 않은 항목이 나타남.
--way to reveal null values ...!
--리뷰 필요! 그래도 넌 이해했다!! ~쪽의 만족하지 않는 항목을 확인 할 수 있다!


left outer join reginfotbl as r

on c.ClubName = r.clubname


