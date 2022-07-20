
whenever sqlerror exit
set echo off
set define off
set sqlblanklines on
set sqlt off

declare
        e_exception_name exception;
        pragma exception_init(e_exception_name,-20120);
        l_user all_users.username%type;
        l_user_dba_status  NUMBER;

begin
        select user into l_user from dual;
end;
/

declare
  l_count number;
begin
  select count(*) into l_count from user_objects where object_name = 'E_TMP' ;

  if l_count = 1
  then
     execute immediate 'drop table e_tmp';
  end if;
end;
/

  CREATE TABLE "E_TMP" 
   (	"U17_ID" NUMBER(10,0) , 
	"U17_INSTITUTION_ID_M02" NUMBER(3,0) , 
	"U17_FULL_NAME" VARCHAR2(200) , 
	"U17_LOGIN_NAME" VARCHAR2(20) , 
	"U17_PASSWORD" VARCHAR2(100) , 
	"U17_FAILED_ATTEMPTS" NUMBER(2,0) , 
	"U17_IS_FIRST_TIME" NUMBER(1,0) , 
	"U17_CREATED_BY_ID_U17" NUMBER(10,0) , 
	"U17_CREATED_DATE" TIMESTAMP (6) , 
	"U17_STATUS_ID_V01" NUMBER(5,0) , 
	"U17_LOGIN_STATUS" NUMBER(1,0) , 
	"U17_TYPE_ID_M11" NUMBER(5,0) , 
	"U17_PRICE_LOGIN_NAME" VARCHAR2(20), 
	"U17_PRICE_PASSWORD" VARCHAR2(100), 
	"U17_PW_EXPIRE_DATE" DATE, 
	"U17_LAST_LOGIN_DATE" DATE, 
	"U17_TELEPHONE" VARCHAR2(20), 
	"U17_TELEPHONE_EXT" VARCHAR2(20), 
	"U17_MOBILE" VARCHAR2(20), 
	"U17_EMAIL" VARCHAR2(100), 
	"U17_DEPARTMENT_ID_M12" NUMBER(5,0), 
	"U17_EMPLOYEE_NO" VARCHAR2(20), 
	"U17_MODIFIED_BY_ID_U17" NUMBER(10,0), 
	"U17_MODIFIED_DATE" TIMESTAMP (6), 
	"U17_STATUS_CHANGED_BY_U17" NUMBER(10,0), 
	"U17_STATUS_CHANGED_DATE" TIMESTAMP (6), 
	"U17_HISTORY_PASSWORDS" VARCHAR2(4000), 
	"U17_CLIENT_VERSION" VARCHAR2(30), 
	"U17_TRADING_ENABLED" NUMBER(1,0), 
	"U17_FULL_NAME_SAUDI" VARCHAR2(50), 
	"U17_LOCATION_ID_M07" NUMBER(5,0), 
	"U17_CUSTOM_TYPE" VARCHAR2(50), 
	"U17_DEALER_CMSN_GRP_ID_M162" NUMBER(18,0), 
	"U17_AUTHENTICATION_TYPE" NUMBER(5,0), 
	"U17_EXTERNAL_REF" VARCHAR2(25), 
	"U17_USER_CATEGORY" NUMBER(1,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.u17_employee.dat'
       )
    )
/


begin
  insert into dfn_ntp.u17_employee select * from e_tmp;

  commit;
end;
/

declare
  l_count number;
begin
  select count(*) into l_count from user_objects where object_name = 'E_TMP' ;

  if l_count = 1
  then
     execute immediate 'drop table e_tmp';
  end if;
end;
/

set sqlt on

