select stdname, region from stdtbl
--union ����(���̺� ��ġ��
select clubname, clubroom from clubtbl

select id, stdid from reginfotbl

--������Ÿ�� ��-ġ�ؾ�
select cast(id as varchar), stdid from reginfotbl --����ȯ�ؾ� ��-��

union
select clubname, clubroom from clubtbl


--EXCEPT - 2��° ������ �ش��ϴ� ���� ������ 
select name, concat(mobile1,mobile2) as mb from userTBL
except
select name, concat(mobile1,mobile2) as mb from userTBL
WHERE mobile1 is not null;