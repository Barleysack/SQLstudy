--제약조건.
--데이터베이스의 무결성을 지키기 위해 제한된 조건. 
--어떠한 조건을 만족했을때만 입력되도록 제한하는것.
--Constraints. 
--제약조건 6가지.
--PRIMARY KEY,FOREIGN KEY,UNIQUE,CHECK,DEFAULT,NULL
--PRIMARY : 테이블의 각 행들을 구분할 수 있는 식별자. 중복될 수 없고(UNIQUE), 
--NULL(NOT NULL)값이 입력될 수 없다.
--기본 키로 설정하면 자동으로 클러스터 형 인덱스가 생성됨
--기본키는 하나의 열 또는 여러개의 열을 합쳐서 설정할 수 있으나, 한개만 설정할 수 있다. 
--UNIQUE 제약조건 : 중복되지 않는 유일한 값을 입력해야 함
--PK와 거의 비슷하며 차이점은 NULL을 허용한다는 것.
--회원 테이블의 예를 든다면 주로 email 주소를 unique로 설정하는 경우가 많다.

/*
ALTER TABLE userTBL
	ADD email VARCHAR(50) Not null unique;
	--유니크 제약조건 추가한 것 .*/
--CHECK
ALTER TABLE usertbl
	ADD CONSTRAINT CK_birthyear
	CHECK (birthyear>=1900 and birthyear <= year(getdate()));