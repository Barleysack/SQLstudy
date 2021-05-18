--문자열 함수
SELECT ASCII('A');
--문자열 연결
SELECT CONCAT('SQL', 'server', 2019) as [name];--사용빈도상

SELECT 'SQL' + 'SERVER' +CAST(2019 AS VARCHAR);

--단어 시작위치
SELECT CHARINDEX('WORLD','HELLO WORLD!');--데이터베이스는 1부터 시작.
--언어에서의 배열은 0부터 시작. 
--DB는 1부터 시작. 
--LEFT, RIGHT, SUBSTRING, LEN, LOWER, UPPER, LTRIM, RTRIM 사용빈도 상^3
declare @ss varchar(20);
set @ss = 'SQL Server 2019'
SELECT LEFT(@ss,2), right(@ss,3);
select substring('대한민국만세',5,2);
select len('hello world');
select lower('HELLO WORLD');
SELECT LTRIM('       EOIWTYEOI');
SELECT RTRIM('       EOIWTYEOI             ');
SELECT TRIM('   DIDN DDDD  '); --상
--replace, 사용빈도 최상상 
select replace ('sql server 2019','2019', '2020');
select replicate(@ss,5);

--FORMAT 사용빈도 상상
SELECT GETDATE();
SELECT FORMAT(GETDATE(),'yyyy/MM/dd');--한국식


