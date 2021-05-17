use sampledb;
go
/*
create table usertbl
(

	userID CHAR(8) NOT NULL PRIMARY KEY, 
	name NVARCHAR(10) NOT NULL,
	birthyear int not null, 
	height smallint 

)*/

--SAMPLE DDL QUERY--
/*create table buyTBL
(
	number int not null primary key , 
	userid char(8) not null
	  foreign key references usertbl(userID),--외래키, 부모-자식관계, 부모는 유저TBL-- 여기가 세상 중요하다.
	prodName NCHAR(6) NOT NULL,
	price int not null



)
go*/