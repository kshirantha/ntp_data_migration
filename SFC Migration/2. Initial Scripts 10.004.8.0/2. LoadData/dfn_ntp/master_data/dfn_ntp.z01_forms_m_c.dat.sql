
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
   (	"Z01_ID" NUMBER(5,0) , 
	"Z01_TAG" VARCHAR2(200) , 
	"Z01_VERSION_NO" NUMBER(5,0) , 
	"Z01_VIEW_NAME" VARCHAR2(200) , 
	"Z01_TITLE" NVARCHAR2(200) , 
	"Z01_FORM_TYPE" NUMBER(1,0) , 
	"Z01_SORT_COLUMN" VARCHAR2(200), 
	"Z01_DATE_FIELD" VARCHAR2(100), 
	"Z01_TRUNCATE_DATE" NUMBER(1,0), 
	"Z01_LOAD_ALL_DATA" NUMBER(1,0), 
	"Z01_TIME_STAMP" DATE, 
	"Z01_HAS_SENSITIVE_DATA" NUMBER(1,0) , 
	"Z01_EXCEL_EXPORT_SEC_ID" NUMBER(5,0), 
	"Z01_TEXTFILE_EXPORT_SEC_ID" NUMBER(5,0), 
	"Z01_AUTO_REFRESH" NUMBER(1,0), 
	"Z01_SOURCE_TYPE" NUMBER(1,0) , 
	"Z01_IGNORE_SORT" NUMBER(1,0), 
	"Z01_LOAD_DATA_ON_OPENING" NUMBER(1,0), 
	"Z01_FULLY_LOADED" NUMBER(1,0), 
	"Z01_UPDATED_DATETIME" DATE, 
	"Z01_COLUMNS_UPDATED_DATETIME" DATE, 
	"Z01_MENUS_UPDATED_DATETIME" DATE, 
	"Z01_COLORS_UPDATED_DATETIME" DATE, 
	"Z01_CUSTOM_TYPE" VARCHAR2(50), 
	"Z01_IS_CUSTOMIZED" NUMBER(1,0), 
	"Z01_BROKER_CODE" VARCHAR2(50), 
	"Z01_FEATURE_ID_V14" NUMBER(3,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.z01_forms_m_c.dat'
       )
    )
/


begin
  insert into dfn_ntp.z01_forms_m_c select * from e_tmp;

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

