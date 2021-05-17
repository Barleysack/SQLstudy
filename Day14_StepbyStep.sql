-- 구매한 금액 다라서 최우수/ 우수/ 일반 고객으로 분류하는 쿼리 작성.
--select * from 부터 시작하는 것이다. 

with cte_custlevel([사용자아이디],[회원명],[총구매금액],[고객등급])--가상의 테이블로 변환:)
as
(

select u.userid as '사용자 아이디', u.name as '회원명' ,
iif(sum(b.price*b.amount) is null, 0, sum(b.price*b.amount)) as '총 구매금액',
case 
when (sum(b.price*b.amount) >= 1500) then '최우수고객'
when (sum(b.price*b.amount) >= 1000) then '우수고객'
when (sum(b.price*b.amount) >= 1) then '일반고객'
else '유령고객'
end as '고객등급'
from userTbl as u --집계함수 이외 항목들은 모두 그룹바이가..
left outer JOIN buyTbl as b
on u.userid =b.userid
GROUP BY u.userID, u.name


)
select [사용자아이디],[회원명],format([총구매금액],'#,#') as '구매 금액' -- '#,#' 'c4'

,[고객등급] from cte_custlevel
order by [총구매금액] desc;
