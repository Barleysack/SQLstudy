USE SAMPLEDB;
GO
/*drop table ddltbl; --���� �ʿ�� ������ �ȵǳ׿�.
create table ddlTBL
(
id int not null primary key identity(1,1),
name NVARCHAR(20) NOT NULL,
REGDATE DATETIME 
);
GO


--DDL�� ���̺� ����


drop table ddltbl; --���� �ʿ�� ������ �ȵǳ׿�.

create table ddlTBL
(
id int not null primary key identity(1,1),--identity�� �ڵ����� �����Ǵ� ���� ���� ���θ� ���Ѵ�. 
name NVARCHAR(20) NOT NULL,
REGDATE DATETIME 
);
GO

CREATE TABLE prodTBL
(

  prodcode nchar(3) not null,
  prodID NCHAR(4) NOT NULL,
  PRODDATE DATETIME NOT NULL,
  PRODCUR NCHAR(10) NULL,
  CONSTRAINT PK_prodTbl_prodcode_prodID
  PRIMARY KEY (prodcode, prodID)
  --1�� �̻� �÷��� PK �����ϴ� ����� ���̴�.
  --�����ؾ��ϴ� ��� �θ����̺� ��Ȯ�� �����Ұ�.
  );
  GO*/


