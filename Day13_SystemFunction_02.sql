--���ڿ� �Լ�
SELECT ASCII('A');
--���ڿ� ����
SELECT CONCAT('SQL', 'server', 2019) as [name];--���󵵻�

SELECT 'SQL' + 'SERVER' +CAST(2019 AS VARCHAR);

--�ܾ� ������ġ
SELECT CHARINDEX('WORLD','HELLO WORLD!');--�����ͺ��̽��� 1���� ����.
--������ �迭�� 0���� ����. 
--DB�� 1���� ����. 
--LEFT, RIGHT, SUBSTRING, LEN, LOWER, UPPER, LTRIM, RTRIM ���� ��^3
declare @ss varchar(20);
set @ss = 'SQL Server 2019'
SELECT LEFT(@ss,2), right(@ss,3);
select substring('���ѹα�����',5,2);
select len('hello world');
select lower('HELLO WORLD');
SELECT LTRIM('       EOIWTYEOI');
SELECT RTRIM('       EOIWTYEOI             ');
SELECT TRIM('   DIDN DDDD  '); --��
--replace, ���� �ֻ�� 
select replace ('sql server 2019','2019', '2020');
select replicate(@ss,5);

--FORMAT ���� ���
SELECT GETDATE();
SELECT FORMAT(GETDATE(),'yyyy/MM/dd');--�ѱ���


