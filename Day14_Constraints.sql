--��������.
--�����ͺ��̽��� ���Ἲ�� ��Ű�� ���� ���ѵ� ����. 
--��� ������ ������������ �Էµǵ��� �����ϴ°�.
--Constraints. 
--�������� 6����.
--PRIMARY KEY,FOREIGN KEY,UNIQUE,CHECK,DEFAULT,NULL
--PRIMARY : ���̺��� �� ����� ������ �� �ִ� �ĺ���. �ߺ��� �� ����(UNIQUE), 
--NULL(NOT NULL)���� �Էµ� �� ����.
--�⺻ Ű�� �����ϸ� �ڵ����� Ŭ������ �� �ε����� ������
--�⺻Ű�� �ϳ��� �� �Ǵ� �������� ���� ���ļ� ������ �� ������, �Ѱ��� ������ �� �ִ�. 
--UNIQUE �������� : �ߺ����� �ʴ� ������ ���� �Է��ؾ� ��
--PK�� ���� ����ϸ� �������� NULL�� ����Ѵٴ� ��.
--ȸ�� ���̺��� ���� ��ٸ� �ַ� email �ּҸ� unique�� �����ϴ� ��찡 ����.

/*
ALTER TABLE userTBL
	ADD email VARCHAR(50) Not null unique;
	--����ũ �������� �߰��� �� .*/
--CHECK
ALTER TABLE usertbl
	ADD CONSTRAINT CK_birthyear
	CHECK (birthyear>=1900 and birthyear <= year(getdate()));