--�ܺ�����--
--Outer Join--
Select u.userID, U.NAME, U.ADDR, concat(U.MOBILE1,u.mobile2) as mobile
, b.PRODNAME 
from usertbl as u
right OUTER JOIN buytbl as b
on u.userID=b.userid
WHERE B.PRODNAME IS NULL
order by u.userID



--�л�/���Ƹ�/�������� ���̺�
--outer join
select s.stdid,s.StdName,s.region 
,r.clubname,c.clubroom,r.regdate from stdtbl as s
--3��¥���� outer join�� ���� �ʴ�. ���䰡 �ʿ��� �κ��̴�. 
left outer join ReginfoTbl as r
on s.StdID=r.stdid
left outer join clubtbl as C
ON c.clubname=r.clubname ;


select s.stdid,s.StdName,s.region 
,r.clubname,r.regdate from stdtbl as s
--3��¥���� outer join�� ���� �ʴ�. ���䰡 �ʿ��� �κ��̴�. 
--ù��° �ƿ��������� �������, �ι�° �ƿ��������� �����Ѵ�. ��� ��! ��!

left outer join ReginfoTbl as r
on s.StdID=r.stdid
left outer join clubtbl as C
ON c.clubname=r.clubname ;


select c.ClubName,c.clubROOM ,r.id,r.regdate
from clubtbl as c--������ ������ ���������� �� - clubtbl, �θ����̺� �� from ��...!
--club�� �ƹ��� �������� ���� �׸��� ��Ÿ��.
--way to reveal null values ...!
--���� �ʿ�! �׷��� �� �����ߴ�!! ~���� �������� �ʴ� �׸��� Ȯ�� �� �� �ִ�!


left outer join reginfotbl as r

on c.ClubName = r.clubname


