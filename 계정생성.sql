-- SQL 한 줄 주석

/* SQL 범위 주석 */

-- sys로 접속해야 다른 계정을 만들 수 있는 권한이 생김

-- 새로운 사용자 계정 생성 !!! sys계정(최고 관리자)으로 진행해야 함

-- 오라클 11G 이전 버전의 SQL 작성을 가능하게 해주는 구문
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- 계정 생성
-- 관리자 계정은 주로 권한 부여 관련된 것들을 수행함
CREATE USER kh IDENTIFIED BY kh1234; -- 구문은 통으로 암기

-- C## : 일반 사용자 (사용자 계정을 의미)
-- CREATE USER C##hs IDENTIFIED BY kh1234;

-- 사용자 계정 권한 부여 설정
GRANT RESOURCE, CONNECT TO kh;

-- 객체가 생성될 수 있는 공간 할당량 지정
ALTER USER kh DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM; -- 통으로 암기