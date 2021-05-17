USE SAMPLEDB;
GO
/*drop table ddltbl; --질문 필요ㅡ 실행이 안되네요.
create table ddlTBL
(
id int not null primary key identity(1,1),
name NVARCHAR(20) NOT NULL,
REGDATE DATETIME 
);
GO


--DDL로 테이블 수정


drop table ddltbl; --질문 필요ㅡ 실행이 안되네요.

create table ddlTBL
(
id int not null primary key identity(1,1),--identity란 자동으로 증가되는 숫자 열의 여부를 말한다. 
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
  --1개 이상 컬럼에 PK 설정하는 방법인 것이다.
  --참조해야하는 경우 부모테이블 정확히 지정할것.
  );
  GO*/


