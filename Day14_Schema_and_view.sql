--select * from sampleDB.dbo.buyTBL
--select * from sqldb.dbo.buytbl --이런식으로 접근하는 것이다. 
--스키마를 만드실 일은 크게 없을겁니다
--뷰의 개념. select 문으로 구성된 데이터베이스 개체.
--가상의 테이블 
-- 뷰 생성 , 사용 예제
use sampleDB;
GO
CREATE VIEW v_usertbl
as
	select userID,name,Addr from usertbl;--테이블마냥 작업은 가능하다 이말이야.
	
go
/*
--view 개체...! 원래부터의 테이블이라기보다는 뷰 
개체는 가상의 테이블로서 생각하는 것이 옳다 이말이야*/
--보안 유지를 위하여 제작하는 것

create View v_userbuyInfo
as
select u.userID, u.name, b.prodname, b.price
from usertbl as u
inner join buytbl as b
on u.userid = b.userID;
GO

SELECT * FROM v_userbuyInfo --할때마다 쿼리문 쓸 필요 없이 
--단순화하여 사용할 수 있다.
ORDER BY PRICE DESC



