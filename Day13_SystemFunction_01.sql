/*--�ý����Լ�(SQL���� �⺻ ���� �Լ�)
SELECT cast(avg(cast(amount as float)) as decimal(5,4)) FROM buytbl;
select avg(convert(float,amount)) from buyTbl;

SELECT HEIGHT FROM USERTBL;
SELECT NAME, HEIGHT FROM USERTBL	
 WHERE HEIGHT IS NULL;

SELECT NAME, CAST(HEIGHT AS VARCHAR) +'cm' from usertbl--varchar�� ������ ���� ����! �ξ� ���� ����. 
 where height is not null;*/

 --GETDATE�� �繵 ���� ���� ��

 /*SELECT GETDATE();
 --����� �ΰ�¥�� ����-> �ý��ۺ�����
SELECT @@SERVERNAME
--SELECT ��¥ �� �ð� �Լ�,
SELECT YEAR(GETDATE()) AS '����⵵';
SELECT MONTH(GETDATE()) AS '�����';
SELECT DAY(GETDATE()) AS '����';
-- ��ġ�Լ�
SELECT ABS(-100);
SELECT ROUND(3.141592,2);*/
--���Լ�
select iif(100>200,'��','����');

