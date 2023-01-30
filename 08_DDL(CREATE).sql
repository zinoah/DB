/* - 데이터 딕셔너리 
 * 
 * 자원을 효율적으로 관리하기 위한 다양한 정보를 저장하는 시스템 테이블
 * 데이터 딕셔너리는 사용자가 테이블을 생성하거나 사용자를 변경하는 등의
 * 작업을 할 떄 데이터베이스 서버에 의해 자동으로 갱신되는 테이블
 * 
 * */


------------------------------------------------------------------------

-- DQL(Data Query Language) : 데이터 질의(조회) 언어.

-- DML(Data Manipulation Language) : 데이터 조작 언어. 테이블에 데이터를 삽입, 수정, 삭제하는 언어

-- TCL(Transaction Control Language) : 트랜잭션 제어 언어. DML 수행 내용을 COMMIT, ROLLBACK 하는 언어

-- DDL(Data Definition Language) : 데이터 정의 언어. 
-- 객체(OBJECT)를 만들고(CREATE), 수정하고(ALTER), 삭제(DROP) 등
-- 데이터의 전체 구조를 정의하는 언어로 주로 DB관리자, 설계자가 사용함.

-- 오라클에서의 객체 : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 
-- 					   인덱스(INDEX), 패키지(PACKAGE), 트리거(TRIGGER)
--					   프로시저(PROCEDURE), 함수(FUNCTION),
-- 					   동의어(SYNOMYM), 사용자(USER)


------------------------------------------------------------------------


-- CREATE

-- 테이블이나 인덱스, 뷰 등 다양한 데이터베이스 객체를 생성하는 구문
-- 테이블로 생성된 객체는 DROP 구문을 통해 제거할 수 있음


-- 1. 테이블 생성하기

-- 테이블이란?
-- 행과 열로 구성되는 가장 기본적인 데이터베이스 객체
-- 데이터베이스 내에서 모든 데이터는 테이블을 통해서 저장된다.

-- [표현식]

/*
 * CREATE TABLE 테이블명 (
 * 		컬럼명 자료형(크기),
 * 		컬럼명 자료형(크기),
 * 		...
 * );
 * 
 * */

/*
 * 자료형
 * 
 * NUMBER : 숫자형(정수, 실수)
 * 
 * CHAR(크기) : 고정길이 문자형(2000BYTE)
 * 	--> EX) CHAR(10) 컬럼에 'ABC' 3 BYTE 문자열만 저장해도 10 BYTE 저장공간을 모두 사용.
 * 
 * VARCHAR2(크기) : 가변길이 문자형(4000BYTE)
 * 	--> EX) VARCHAR2(10) 컬럼에 'ABC' 3 BYTE 문자열만 저장하면 나머지 7 BYTE를 반환함.
 * 
 * DATE : 날짜 타입
 * 
 * BLOB : 대용량 이진 데이터(4GB)
 * CLOB : 대용량 문자 데이터(4GB)
 * 
 * 1 BYTE * 1024 = 1KB
 * 1 KB * 1024 = 1MB
 * 1 MB * 1024 = 1GB
 * 
 * */

-- MEMBER 테이블 생성
CREATE TABLE MEMBER(
	MEMBER_ID VARCHAR2(20),
	MEMBER_PWD VARCHAR2(20),
	MEMBER_NAME VARCHAR2(30),
	MEMBER_SSN CHAR(14), -- 991122-1234567
	ENROLL_DATE DATE DEFAULT SYSDATE
);


-- SQL 작성법 : 대문자 작성 권장, 연결된 단어 사이에는 "_" (언더바) 사용
-- 문자 인코딩 UTF-8 : 영어, 숫자 1 BYTE, 한글 / 특수문자 등은 3 BYTE 취급

-- 만든 테이블 확인
SELECT * FROM "MEMBER";


-- 2. 컬럼에 주석 달기
-- [표현식]
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';

COMMENT ON COLUMN "MEMBER".MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.MEMBER_SSN IS '회원 주민 등록 번호';
COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '회원 가입일';


-- USER_TABLES : 사용자가 작성한 테이블을 확인 하는 뷰
-- 데이터 딕셔너리에 정의되어 있음
SELECT * FROM USER_TABLES;


-- MEMBER 테이블에 샘플 데이터 삽입
-- INSERT INTO 테이블명 VALUES(값1, 값2 ...)
INSERT INTO MEMBER VALUES('MEM01', '12345ABC', '홍길동', '991234-1234567', DEFAULT);
--																		   SYSDATE

-- INSERT / UPDATE 시 컬럼값으로 DEFAULT를 작성하면
-- 테이블 생성 시 해당 컬럼에 지정된 DEFAULT 값으로 삽입이 된다.

SELECT * FROM "MEMBER";

-- 추가 샘플 데이터 삽입
INSERT INTO MEMBER VALUES('MEM02', 'QWERTY11', '김아무개', '333333-9876547', SYSDATE);
INSERT INTO MEMBER VALUES('MEM03', 'ASDF123', '고길동', '222222-1234567', DEFAULT);

COMMIT;

-- INSERT시 미작성하는 경우(가입일) DEFAULT 값이 반영됨
INSERT INTO MEMBER(MEMBER_ID, MEMBER_PWD, MEMBER_NAME) 
VALUES('MEM04', 'PASSWORD123', '이지연');

SELECT * FROM "MEMBER"; 

-- ** JDBC에서 날짜를 입력 받았을 때 삽입하는 방법 **
-- '2023-01-13 10:33:27'
INSERT INTO MEMBER VALUES('MEM05', 'PASS05', '김동깨', '121212-1234567', 
						TO_DATE('2023-01-13 10:33:27', 'YYYY-MM-DD HH24:MI:SS')
);

SELECT * FROM MEMBER;
COMMIT;

------------------------------------------------------------------------

-- ** NUMBER 타입 문제점 **
-- MEMBER2 테이블(아이디, 비밀번호, 이름, 전화번호)

CREATE TABLE MEMBER2(
	MEMBER_ID VARCHAR2(20),
	MEMBER_PWD VARCHAR2(20),
	MEMBER_NAME VARCHAR2(30),
	MEMBER_TEL NUMBER
);


SELECT * FROM MEMBER2;

INSERT INTO MEMBER2 VALUES('MEM01', 'PASS01', '홍길동', 7712341234);
INSERT INTO MEMBER2 VALUES('MEM02', 'PASS01', '고길동', 01012341234);
--> NUMBER 타입 컬럼에 데이터 삽입시
-- 제일 앞에 0이 있으면 자동으로 제거함
	--> 전화번호, 주민등록번호처럼 숫자로만 되어있는 데이터지만
	-- 0으로 시작할 가능성이 있으면 CHAR, VARCHAR2 같은 문자형 사용

------------------------------------------------------------------------

-- 제약 조건 (CONSTRAINTS)

/*
 * 사용자가 원하는 조건의 데이터만 유지하기 위해서 특정 컬럼에 설정하는 제약.
 * 데이터 무결성 보장을 목적으로 함.
 * -> 중복데이터 X
 * 
 * + 입력 데이터에 문제가 없는지 자동으로 검사하는 목적
 * + 데이터의 수정/삭제 가능 여부 검사 등을 목적으로 함
 * --> 제약 조건을 위배하는 DML 구문은 수행할 수 없음!
 * 
 * 제약조건의 종류
 * PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY
 * 
 * */

-- USER_CONSTRAINTS : 사용자가 작성한 제약조건을 확인하는 딕셔너리 뷰
SELECT * FROM USER_CONSTRAINTS;

-- 1. NOT NULL
-- 해당 컬럼에 반드시 값이 기록되어야하는 경우 사용
-- 삽입/수정 시 NULL값을 허용하지 않도록 컬럼 레벨에서 제한

-- * 컬럼레벨? : 테이블 생성 시 컬럼에 정의하는 부분에 작성하는 것

CREATE TABLE USER_USED_NN(
	USER_NO NUMBER NOT NULL, --> 사용자 번호(모든 사용자는 사용자 번호가 있어야 한다)
							 --> 컬럼 레벨 제약 조건 설정
	USER_ID VARCHAR2(20),
	USER_PWD VARCHAR2(30),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50)
);

INSERT INTO USER_USED_NN
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-1234', 'hong123@kh.or.kr');

SELECT * FROM USER_USED_NN;

INSERT INTO USER_USED_NN
VALUES(NULL, NULL, NULL, NULL, '남', '010-1234-1234', 'hong123@kh.or.kr');
-- ORA-01400: NULL을 ("KH"."USER_USED_NN"."USER_NO") 안에 삽입할 수 없습니다
--> NOT NULL 제약조건에 위배되어 오류 발생

------------------------------------------------------------------------

-- 2. UNIQUE 제약조건
-- 컬럼에 입력값에 대해서 중복을 제한하는 제약조건
-- 컬럼레벨에서 설정 가능, 테이블 레벨에서 설정 가능
-- 단, UNIQUE 제약조건이 설정된 컬럼에 NULL 값은 중복 삽입 가능

-- * 테이블 레벨 : 테이블 생성시 컬럼 정의가 끝난 후 마지막에 작성

-- * 제약조건 지정방법
-- 1) 컬럼 레벨 : [CONSTRAINT 제약조건명] 제약조건
-- 2) 테이블 레벨 : [CONSTRAINT 제약조건명] 제약조건(컬럼명)

CREATE TABLE USER_USED_UK(
	USER_NO NUMBER,
	USER_ID VARCHAR2(20) UNIQUE, -- 컬럼 레벨
	-- USER_ID VARCHAR2(20),
	USER_PWD VARCHAR2(30),
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50)
	/* 테이블 레벨 */
	--CONSTRAINTS USER_ID_U UNIQUE(USER_ID) -- 테이블 레벨에서 제약조건 지정
);

-- ORA-02261: 고유 키 또는 기본 키가 이미 존재하고 있습니다

SELECT * FROM USER_USED_UK;

-- 컬럼 레벨, 테이블 레벨 생성용 테이블 삭제 구문
DROP TABLE USER_USED_UK;

INSERT INTO USER_USED_UK
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-1234', 'hong123@kh.or.kr');
-- ORA-00001: 무결성 제약 조건(KH.SYS_C008426)에 위배됩니다

-- USER_ID만 변경해도 정상적으로 추가 됨
INSERT INTO USER_USED_UK
VALUES(1, 'USER02', 'PASS01', '홍길동', '남', '010-1234-1234', 'hong123@kh.or.kr');

-- UNIQUE 값에 NULL은 들어갈 수 있음
-- NULL 값은 중복 삽입 가능!
INSERT INTO USER_USED_UK
VALUES(1, NULL, 'PASS01', '홍길동', '남', '010-1234-1234', 'hong123@kh.or.kr');

------------------------------------------------------------------------

-- UNIQUE 복합키
-- 두개 이상의 컬럼을 묵어서 하나의 UNIQUE 제약 조건을 설정함

-- * 복합키 지정은 테이블 레벨에서만 가능하다!
-- * 복합키는 지정된 모든 컬럼의 값이 같을 때 위배된다!

CREATE TABLE USER_USED_UK2(
	USER_NO NUMBER,
	USER_ID VARCHAR2(20),
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	-- 테이블 레벨 UNIQUE 복합키 지정
	CONSTRAINT USER_ID_NAME_U UNIQUE(USER_ID, USER_NAME)
);

SELECT * FROM USER_USED_UK2;

INSERT INTO USER_USED_UK2
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-1234', 'hong123@kh.or.kr');

INSERT INTO USER_USED_UK2
VALUES(2, 'USER02', 'PASS01', '홍길동', '남', '010-1234-1234', 'hong123@kh.or.kr');

INSERT INTO USER_USED_UK2
VALUES(3, 'USER01', 'PASS01', '고길동', '남', '010-1234-1234', 'hong123@kh.or.kr');

-- 동일한 USER_ID / USER_NAME 입력 시 무결성 제약 조건 위배
INSERT INTO USER_USED_UK2
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-1234', 'hong123@kh.or.kr');
-- ORA-00001: 무결성 제약 조건(KH.USER_ID_NAME_U)에 위배됩니다

SELECT * FROM USER_USED_UK2;


------------------------------------------------------------------------

-- 3. PRIMARY KEY(기본키) 제약조건

-- 테이블에서 한 행의 정보를 찾기위해 사용할 컬럼을 의미함
-- 테이블에 대한 식별자(학번, 회원번호 등) 역할을 함.

-- NOT NULL + UNIQUE 제약조건의 의미 --> 중복되지 않는 값이 필수로 존재해야 함

-- 한 테이블당 한개만 설정 할 수 있음
-- 컬럼레벨, 테이블레벨 둘 다 설정 가능

CREATE TABLE USER_USED_PK(
	USER_NO NUMBER CONSTRAINT USER_NO_PK PRIMARY KEY, -- 컬럼 레벨
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50)
	-- 테이블 레벨
	-- CONSTRAINT USER_NO_PK PRIMARY KEY(USER_NO)
);

SELECT * FROM USER_USED_PK; 

INSERT INTO USER_USED_PK
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-1234', 'hong123@kh.or.kr');

-- USER_ID 외의 값을 전부 바꿔서 추가하는 경우
INSERT INTO USER_USED_PK
VALUES(1, 'USER02', 'PASS02', '고길동', '여', '010-4567-6789', 'go456@kh.or.kr');
-- ORA-00001: 무결성 제약 조건(KH.USER_NO_PK)에 위배됩니다

-- USER_ID를 중복되지 않게 변경
INSERT INTO USER_USED_PK
VALUES(2, 'USER02', 'PASS02', '고길동', '여', '010-4567-6789', 'go456@kh.or.kr');

INSERT INTO USER_USED_PK
VALUES(NULL, 'USER03', 'PASS03', '유관순', '여', '010-4511-6719', 'you411156@kh.or.kr');
--> 기본키가 NULL 이므로 오류
-- ORA-01400: NULL을 ("KH"."USER_USED_PK"."USER_NO") 안에 삽입할 수 없습니다

------------------------------------------------------------------------

-- 4. FOREIGN KEY(외부키/외래키) 제약조건

-- 참조된 다른 테이블의 컬럼이 제공하는 값만 사용할 수 있음
-- FOREIGN KEY 제약조건에 의해서 테이블간에 관계가 형성됨.
-- 제공되는 값 외에는 NULL을 사용할 수 있음

-- 컬럼 레벨일 경우
-- 컬럼명 자료형(크기) [CONSTRAINT 이름] REFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]

-- 테이블 레벨일 경우 
-- [CONSTRAINT 이름] FOREIGN KEY (적용할 컬럼명) REFERENCES 참조할테이블명 [(참조할 컬럼)] [삭제룰]


CREATE TABLE USER_GRADE(
	GRADE_CODE NUMBER PRIMARY KEY,
	GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE VALUES(10, '일반회원');
INSERT INTO USER_GRADE VALUES(20, '우수회원');
INSERT INTO USER_GRADE VALUES(30, '특별회원');

SELECT * FROM USER_GRADE;

CREATE TABLE USER_USED_FK (
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK REFERENCES USER_GRADE /*(GRADE_CODE)*/
	-- 컬럼명 미작성시 USER_GRADE 테이블의 PK를 자동 참조
);

SELECT * FROM USER_USED_FK;

COMMIT;

INSERT INTO USER_USED_FK 
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-1234', 'hong123@test.com', 10);

INSERT INTO USER_USED_FK 
VALUES(2, 'USER02', 'PASS02', '홍길송', '여', '010-2222-1234', 'hong222@test.com', 20);

INSERT INTO USER_USED_FK 
VALUES(3, 'USER03', 'PASS03', '홍길롱', '남', '010-3333-1234', 'hong333@test.com', 30);

INSERT INTO USER_USED_FK 
VALUES(4, 'USER04', 'PASS04', '홍길공', '여', '010-4444-1234', 'hong444@test.com', NULL);

SELECT * FROM USER_USED_FK;

INSERT INTO USER_USED_FK 
VALUES(5, 'USER05', 'PASS05', '홍길농', '여', '010-5555-1234', 'hong444@test.com', 50);
-- ORA-02291: 무결성 제약조건(KH.GRADE_CODE_FK)이 위배되었습니다- 부모 키가 없습니다
-- 50이라는 값은 USER_GRADE 테이블의 GRADE_CODE 컬럼에서 제공하는 값이 아니므로
-- 외래키 제약 조건에 위배되어 오류 발생

COMMIT;

------------------------------------------------------------------------

-- FOREIGN KEY 삭제 옵션
-- 부모 테이블의 데이터 삭제 시 자식 테이블의 데이터를
-- 어떤식으로 처리할지에 대한 내용을 설정할 수 있다.

SELECT * FROM USER_GRADE;
SELECT * FROM USER_USED_FK;

-- 1) ON DELETE RESTPICTED(삭제 제한)로 기본 지정되어 있음
-- FOREIGN KEY로 지정된 컬럼에서 사용되고 있는 값일 경우
-- 제공하는 컬럼의 값은 삭제하지 못함
DELETE FROM USER_GRADE WHERE GRADE_CODE = 30;
-- ORA-02292: 무결성 제약조건(KH.GRADE_CODE_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다

/*
UPDATE USER_USED_FK SET GRADE_CODE = 30
WHERE GRADE_CODE = 20;
*/

-- GRADE_CODE 중 20은 외래키로 참조되고 있지 않으므로 삭제 가능
DELETE FROM USER_GRADE WHERE GRADE_CODE = 20;
SELECT * FROM USER_GRADE;

ROLLBACK;


-- 2) ON DELETE SET NULL : 부모키 삭제 시 자식키를 NULL로 변경하는 옵션
CREATE TABLE USER_GRADE2(
	GRADE_CODE NUMBER PRIMARY KEY,
	GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE2 VALUES(10, '일반회원');
INSERT INTO USER_GRADE2 VALUES(20, '우수회원');
INSERT INTO USER_GRADE2 VALUES(30, '특별회원');

SELECT * FROM USER_GRADE2;

CREATE TABLE USER_USED_FK2 (
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK2 REFERENCES USER_GRADE2 ON DELETE SET NULL
);

SELECT * FROM USER_USED_FK2;

INSERT INTO USER_USED_FK2
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-1234', 'hong123@test.com', 10);

INSERT INTO USER_USED_FK2 
VALUES(2, 'USER02', 'PASS02', '홍길송', '여', '010-2222-1234', 'hong222@test.com', 10);

INSERT INTO USER_USED_FK2 
VALUES(3, 'USER03', 'PASS03', '홍길롱', '남', '010-3333-1234', 'hong333@test.com', 30);

INSERT INTO USER_USED_FK2 
VALUES(4, 'USER04', 'PASS04', '홍길공', '여', '010-4444-1234', 'hong444@test.com', NULL);

COMMIT;

SELECT * FROM USER_USED_FK2;

-- 부모테이블인 USER_GRADE2에서 GRADE_CODE = 10 삭제
DELETE FROM USER_GRADE2
WHERE GRADE_CODE = 10;

SELECT * FROM USER_USED_FK2;

------------------------------------------------------------------------

-- 3) ON DELETE CASCADE : 부모키 삭제시 자식키도 함께 삭제됨
-- 부모키 삭제시 값을 사용하는 자식 테이블의 컬럼에 해당하는 행이 삭제가 됨


CREATE TABLE USER_GRADE3(
	GRADE_CODE NUMBER PRIMARY KEY,
	GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO USER_GRADE3 VALUES(10, '일반회원');
INSERT INTO USER_GRADE3 VALUES(20, '우수회원');
INSERT INTO USER_GRADE3 VALUES(30, '특별회원');

SELECT * FROM USER_GRADE3;

-- ON DELETE CASCADE 삭제 옵션이 적용된 테이블 생성
CREATE TABLE USER_USED_FK3 (
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50),
	GRADE_CODE NUMBER, 
	CONSTRAINT GRADE_CODE_FK3 FOREIGN KEY(GRADE_CODE)
	REFERENCES USER_GRADE3(GRADE_CODE) ON DELETE CASCADE
);

SELECT * FROM USER_USED_FK3;

INSERT INTO USER_USED_FK3
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-1234', 'hong123@test.com', 10);

INSERT INTO USER_USED_FK3
VALUES(2, 'USER02', 'PASS02', '홍길송', '여', '010-2222-1234', 'hong222@test.com', 10);

INSERT INTO USER_USED_FK3
VALUES(3, 'USER03', 'PASS03', '홍길롱', '남', '010-3333-1234', 'hong333@test.com', 30);

INSERT INTO USER_USED_FK3
VALUES(4, 'USER04', 'PASS04', '홍길공', '여', '010-4444-1234', 'hong444@test.com', NULL);

COMMIT;

SELECT * FROM USER_GRADE;
SELECT * FROM USER_USED_FK3;

-- 부모테이블인 USER_GRADE3 에서 GRADE_CODE = 10 삭제

DELETE FROM USER_GRADE3
WHERE GRADE_CODE = 10;

SELECT * FROM USER_USED_FK3;


-- 5. CHECK 제약 조건: 컬럼에기록되는 값에 조건을 설정 할 수 있음
-- CHECK


CREATE TABLE USER_USED_CHECK (
	USER_NO NUMBER PRIMARY KEY,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PWD VARCHAR2(30) NOT NULL,
	USER_NAME VARCHAR2(30),
	GENDER VARCHAR2(10) CONSTRAINT GENDER_CHECK CHECK(GENDER IN ('남', '여')),
	PHONE VARCHAR2(30),
	EMAIL VARCHAR2(50)
);

INSERT INTO USER_USED_CHECK
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-4444-3333', 'HONG@TEST.COM');

INSERT INTO USER_USED_CHECK
VALUES(2, 'USER01', 'PASS01', '홍길동', '남자', '010-4444-3333', 'HONG@TEST.COM');

-- ORA-02290: check constraint (KH.GENDER_CHECK) violated
-- CHECK 제약조건으로 GENDER컬럼을 성정했기 때문에, 남 또는 여 만기록 가능한데
-- 남자라는 조건 이외의 값이 들어와 에러 발생 

------------------------------------------------------------------

--[연습문제]

CREATE TABLE USER_TEST(
USER_NO NUMBER PRIMARY KEY,
USER_ID VARCHAR2(20) UNIQUE,
USER_PWD VARCHAR2(30) NOT NULL,
PNO CHAR(20) NOT NULL,
GENDER VARCHAR2(10)CONSTRAINT GE_CHECK CHECK(GENDER IN ('남', '여')),
PHONE VARCHAR2(30),
ADDRESS VARCHAR2(100),
STATUS CHAR(1) CONSTRAINT STATUS_CHECK CHECK(STATUS IN ('Y', 'N')),
CONSTRAINT UK_PNO UNIQUE(PNO)
);

COMMENT ON COLUMN USER_TEST.USER_NO IS '회원번호';
COMMENT ON COLUMN USER_TEST.USER_NO IS '회원아이디';
COMMENT ON COLUMN USER_TEST.USER_NO IS '비밀번호';
COMMENT ON COLUMN USER_TEST.USER_NO IS '주민등록번호';
COMMENT ON COLUMN USER_TEST.USER_NO IS '성별';
COMMENT ON COLUMN USER_TEST.USER_NO IS '연락처';
COMMENT ON COLUMN USER_TEST.USER_NO IS '추소';
COMMENT ON COLUMN USER_TEST.USER_NO IS '탈퇴여부';

------------------------------------------------------------
--6.SUBQUERY 이용한 테이블 생성법,
-- 컬럼명, 데이터 타입, 값이 복사되고, 제약조건은 NOT NULL만 적용됨

-- 1) 테이블 전체 복사 
CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE;
-- > 서브쿼리의 조회결과의 모양대로 테이블이 생성됨

--2)JOIN 후 원하는 컬럼만 테이블로 복사
CREATE TABLE EMPLOYEE_COPY2
AS
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);

--> 서브쿼리로 테이블 생성 시
-- 테이블의 형태 (컬럼명, 데이터 타입) + NOT NULL 제약조건만 복사!
-- 제약조건, 코멘트는 복사되지 않기 때문에 별도 추가 작업이 필요하다!


-- 7. 제약조건 추가
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] PRIMARY KEY(컬럼명)
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] 
--  FOREIGN KEY(컬럼명) REFERENCES 참조 테이블명(참조컬럼명)
     --> 참조 테이블의 PK를 기본키를 FK로 사용하는 경우 참조컬럼명 생략 가능
                                                                                                                                                      
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] UNIQUE(컬럼명)
-- ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] CHECK(컬럼명 비교연산자 비교값)
-- ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;


-- 테이블 제약 조건 확인

SELECT *
FROM USER_CONSTRAINTS  C1
JOIN USER_CONS_COLUMNS C2 USING(CONSTRAINT_NAME)
WHERE C1.TABLE_NAME = 'EMPLOYEE_COPY';


-- NOT NULL 제약 조건만 복사된 EMPLOYEE_COPY 테이블에
-- EMP_ID 컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE EMPLOYEE_COPY ADD CONSTRAINT PK_EMP_COPY PRIMARY KEY(EMP_ID);

-- EMPLOYEE테이블의 DEPT_CODE에 외래키 제약조건 추가
-- 참조 테이블은 DEPARTMENT, 참조 컬럼은 DEPARTMENT의 기본키

ALTER TABLE EMPLOYEE ADD CONSTRAINT FK_EMP_DEPT_CODE
FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT ON DELETE SET NULL;

-- EMPLOYEE테이블의 JOB_CODE 외래키 제약조건 추가
-- 참조 테이블은 JOB, 참조 컬럼은 JOB의 기본키
ALTER TABLE EMPLOYEE ADD CONSTRAINT FK_EMP_JOB_CODE 
FOREIGN KEY(JOB_CODE) REFERENCES JOB ON DELETE SET NULL;

-- EMPLOYEE테이블의 SAL_LEVEL 외래키 제약조건 추가
-- 참조 테이블은 SAL_GRADE, 참조 컬럼은 SAL_GRADE의 기본키
ALTER TABLE EMPLOYEE ADD CONSTRAINT EMP_SAL_LEVEL 
FOREIGN KEY(SAL_LEVEL) REFERENCES SAL_GRADE ON DELETE SET NULL;


-- DEPARTMENT테이블의 LOCATION_ID에 외래키 제약조건 추가
-- 참조 테이블은 LOCATION, 참조 컬럼은 LOCATION의 기본키

ALTER TABLE DEPARTMENT ADD CONSTRAINT DEPT_LOCATION_ID 
FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION ON DELETE SET NULL;


-- LOCATION테이블의 NATIONAL_CODE에 외래키 제약조건 추가
-- 참조 테이블은 NATIONAL, 참조 컬럼은 NATIONAL의 기본키
ALTER TABLE LOCATION ADD CONSTRAINT LOC_NATIONAL_CODE
FOREIGN KEY(NATIONAL_CODE) REFERENCES NATIONAL ON DELETE SET NULL;














