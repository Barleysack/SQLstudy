-- ������ �ݾ� �ٶ� �ֿ��/ ���/ �Ϲ� ������ �з��ϴ� ���� �ۼ�.
--select * from ���� �����ϴ� ���̴�. 

with cte_custlevel([����ھ��̵�],[ȸ����],[�ѱ��űݾ�],[�����])--������ ���̺�� ��ȯ:)
as
(

select u.userid as '����� ���̵�', u.name as 'ȸ����' ,
iif(sum(b.price*b.amount) is null, 0, sum(b.price*b.amount)) as '�� ���űݾ�',
case 
when (sum(b.price*b.amount) >= 1500) then '�ֿ����'
when (sum(b.price*b.amount) >= 1000) then '�����'
when (sum(b.price*b.amount) >= 1) then '�Ϲݰ�'
else '���ɰ�'
end as '�����'
from userTbl as u --�����Լ� �̿� �׸���� ��� �׷���̰�..
left outer JOIN buyTbl as b
on u.userid =b.userid
GROUP BY u.userID, u.name


)
select [����ھ��̵�],[ȸ����],format([�ѱ��űݾ�],'#,#') as '���� �ݾ�' -- '#,#' 'c4'

,[�����] from cte_custlevel
order by [�ѱ��űݾ�] desc;
