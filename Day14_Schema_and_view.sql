--select * from sampleDB.dbo.buyTBL
--select * from sqldb.dbo.buytbl --�̷������� �����ϴ� ���̴�. 
--��Ű���� ����� ���� ũ�� �����̴ϴ�
--���� ����. select ������ ������ �����ͺ��̽� ��ü.
--������ ���̺� 
-- �� ���� , ��� ����
use sampleDB;
GO
CREATE VIEW v_usertbl
as
	select userID,name,Addr from usertbl;--���̺��� �۾��� �����ϴ� �̸��̾�.
	
go
/*
--view ��ü...! ���������� ���̺��̶�⺸�ٴ� �� 
��ü�� ������ ���̺�μ� �����ϴ� ���� �Ǵ� �̸��̾�*/
--���� ������ ���Ͽ� �����ϴ� ��

create View v_userbuyInfo
as
select u.userID, u.name, b.prodname, b.price
from usertbl as u
inner join buytbl as b
on u.userid = b.userID;
GO

SELECT * FROM v_userbuyInfo --�Ҷ����� ������ �� �ʿ� ���� 
--�ܼ�ȭ�Ͽ� ����� �� �ִ�.
ORDER BY PRICE DESC



