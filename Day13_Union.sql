select stdname, region from stdtbl
--union ����(���̺� ��ġ��
select clubname, clubroom from clubtbl

select id, stdid from reginfotbl

--������Ÿ�� ��-ġ�ؾ�
select cast(id as varchar), stdid from reginfotbl --����ȯ�ؾ� ��-��

union
select clubname, clubroom from clubtbl