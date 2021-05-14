/*--시스템함수(SQL서버 기본 제공 함수)
SELECT cast(avg(cast(amount as float)) as decimal(5,4)) FROM buytbl;
select avg(convert(float,amount)) from buyTbl;

SELECT HEIGHT FROM USERTBL;
SELECT NAME, HEIGHT FROM USERTBL	
 WHERE HEIGHT IS NULL;

SELECT NAME, CAST(HEIGHT AS VARCHAR) +'cm' from usertbl--varchar는 사이즈 조정 자유! 훨씬 많이 쓴다. 
 where height is not null;*/

 --GETDATE는 사뭇 많이 쓰는 편

 /*SELECT GETDATE();
 --골뱅이 두개짜리 변수-> 시스템변수들
SELECT @@SERVERNAME
--SELECT 날짜 및 시간 함수,
SELECT YEAR(GETDATE()) AS '현재년도';
SELECT MONTH(GETDATE()) AS '현재월';
SELECT DAY(GETDATE()) AS '오늘';
-- 수치함수
SELECT ABS(-100);
SELECT ROUND(3.141592,2);*/
--논리함수
select iif(100>200,'참','거짓');

