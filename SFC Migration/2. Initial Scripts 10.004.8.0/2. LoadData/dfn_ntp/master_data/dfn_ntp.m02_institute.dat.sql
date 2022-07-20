
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
   (	"M02_ID" NUMBER(3,0) , 
	"M02_ADDRESS" VARCHAR2(255), 
	"M02_CODE" VARCHAR2(255), 
	"M02_EMAIL" VARCHAR2(255), 
	"M02_FAX" VARCHAR2(255), 
	"M02_NAME" VARCHAR2(255), 
	"M02_NAME_LANG" VARCHAR2(255), 
	"M02_TELEPHONE" VARCHAR2(255), 
	"M02_OFF_MRKT_ORDERS_ALLOWED" NUMBER(1,0) , 
	"M02_ADD_RCVBL_FOR_BP" NUMBER(1,0), 
	"M02_USE_EXG_COM_DISCOUNT" NUMBER(1,0), 
	"M02_PRIMARY_CONTACT" VARCHAR2(100), 
	"M02_BRANCH_STATUS" NUMBER(2,0), 
	"M02_CREATED_BY_ID_U17" NUMBER(10,0), 
	"M02_CREATED_DATE" DATE, 
	"M02_APPROVED_BY_ID_U17" NUMBER(10,0), 
	"M02_APPROVED_DATE" DATE, 
	"M02_ACCOUNT_ACTIVATION_PERIOD" NUMBER(5,0), 
	"M02_ACCOUNT_SUSPENSION_PERIOD" NUMBER(5,0), 
	"M02_ACCOUNT_DELETION_PERIOD" NUMBER(5,0), 
	"M02_MAKER_CHECKER_STATUS" NUMBER(1,0), 
	"M02_IS_LOCAL" NUMBER(1,0), 
	"M02_PRICE_BLOCK_TYPE_ID_M55" NUMBER(1,0), 
	"M02_PRICE_BLOCK_PERC" NUMBER(5,3), 
	"M02_PASSWORD_HISTORY_COUNT" NUMBER(3,0) , 
	"M02_MINIMUM_PASSWORD_LENGTH" NUMBER(2,0) , 
	"M02_PWD_COMPLEXITY_LVL_ID_M96" NUMBER(10,0) , 
	"M02_PASSWORD_EXPIRY_PERIOD" NUMBER(3,0) , 
	"M02_OVERDRAW" NUMBER(1,0), 
	"M02_PRINT_PRICE_LOGIN_IN_PIN" NUMBER(1,0) , 
	"M02_PWD_EXPIRY_WARNING_DAYS" NUMBER(2,0) , 
	"M02_EXCHANGE_BOOK_KEEPERS_ENAB" NUMBER(1,0) , 
	"M02_BROKER_CODE" VARCHAR2(50), 
	"M02_PWD_LOWERCASE_REQUIRED" NUMBER(1,0) , 
	"M02_PWD_UPPERCASE_REQUIRED" NUMBER(1,0) , 
	"M02_PWD_NUMBERS_REQUIRED" NUMBER(1,0) , 
	"M02_PWD_SPECIALCHARS_REQUIRED" NUMBER(1,0) , 
	"M02_GEN_USE_PWD_COMP_LVL_USERS" NUMBER(1,0) , 
	"M02_GEN_USE_PWD_COMP_LVL_CUST" NUMBER(1,0) , 
	"M02_CUS_PWD_COMPLEX_LVL_ID_M96" NUMBER(10,0) , 
	"M02_CUS_MINIMUM_PWD_LENGTH" NUMBER(2,0) , 
	"M02_CUS_PWD_LOWERCASE_REQUIRED" NUMBER(1,0) , 
	"M02_CUS_PWD_UPPERCASE_REQUIRED" NUMBER(1,0) , 
	"M02_CUS_PWD_NUMBERS_REQUIRED" NUMBER(1,0) , 
	"M02_CUS_PWD_SPECIALS_REQUIRED" NUMBER(1,0) , 
	"M02_CUS_PWD_EXPIRY_PERIOD" NUMBER(3,0) , 
	"M02_CUS_PWD_EXPIRY_WARNINGDAYS" NUMBER(2,0) , 
	"M02_CUS_ACCT_ACTIVATION_PERIOD" NUMBER(5,0) , 
	"M02_CUS_ACCT_SUSPENSION_PERIOD" NUMBER(5,0) , 
	"M02_CUS_ACCT_DELETION_PERIOD" NUMBER(5,0) , 
	"M02_CUS_PWD_HISTORY_COUNT" NUMBER(3,0) , 
	"M02_IS_ROOT_INSTITUTION" NUMBER(1,0) , 
	"M02_WEBSITE_URL" VARCHAR2(200), 
	"M02_PRODUCT_NAME" VARCHAR2(200), 
	"M02_PRODUCT_NAME_ARB" VARCHAR2(200), 
	"M02_ADDRESS_LANG" VARCHAR2(2000), 
	"M02_DEFINE_COM_GRP_FOR_SUB_AC" NUMBER(1,0) , 
	"M02_DISPLAY_CURRENCY_CODE_M03" CHAR(3), 
	"M02_BYPASS_BUYING_POWER" NUMBER(1,0), 
	"M02_MAX_MARGIN" NUMBER(18,5), 
	"M02_MARGIN_BLOCKED" NUMBER(18,5), 
	"M02_MARGIN_UTILIZED" NUMBER(18,5), 
	"M02_MAX_DAY_LIMIT" NUMBER(18,5), 
	"M02_DAY_LIMIT_BLOCKED" NUMBER(18,5), 
	"M02_DAY_LIMIT_UTILIZED" NUMBER(18,5), 
	"M02_CURRENCY_CODE_M03" VARCHAR2(3), 
	"M02_CHANGE_PWD_ON_FIR_LOG" NUMBER(1,0), 
	"M02_MUBASHER_EXEC_ID" NUMBER(1,0), 
	"M02_SWIFT_ENABLED" NUMBER(1,0), 
	"M02_ALLOW_SMALL_ORDERS" NUMBER(1,0), 
	"M02_DEPOSIT_SMS_ALLOW" NUMBER(1,0), 
	"M02_LOGIN_URL" VARCHAR2(255), 
	"M02_ALLOW_MULTIPLE_ID_TYPES" NUMBER(1,0), 
	"M02_OVERDRAWN_INTEREST_RATE" NUMBER(4,2), 
	"M02_BP_BUYPASS_MANUAL_ORDER" NUMBER(1,0), 
	"M02_VALIDATE_PRICE_SUB_CHANNEL" NUMBER(1,0), 
	"M02_ENABLE_CUST_REBATE_CALC" NUMBER(1,0), 
	"M02_MAX_BACKSEARCH_MONTHS" NUMBER(4,0), 
	"M02_TRADE_SETTLE_CURR_RESTRIC" NUMBER(1,0), 
	"M02_CASH_TRANSATION_DISABLE" NUMBER(1,0), 
	"M02_ENABLE_SHARIA_COMPLIANT" NUMBER(1,0), 
	"M02_VALIDATE_EXP_DATE_MIN_DIFF" NUMBER(1,0), 
	"M02_ISSUE_EXP_MIN_DAYS_DIFF" NUMBER(4,0), 
	"M02_SEND_CMA_DETA_UPDAT_REMIND" NUMBER(1,0), 
	"M02_CMA_DETAILS_REMIND_DAYS" NUMBER(4,0), 
	"M02_SEND_PRIMRY_ID_EXP_REMIND" NUMBER(1,0), 
	"M02_PRIMRY_ID_EXP_REMIND_DAYS" NUMBER(4,0), 
	"M02_MODIFIED_BY_ID_U17" NUMBER(10,0), 
	"M02_MODIFIED_DATE" DATE, 
	"M02_HOTLINE" NVARCHAR2(100), 
	"M02_AGREEMENT_CHECK_DATE" DATE, 
	"M02_IS_CHECK_AGREEMENT" NUMBER(1,0), 
	"M02_TRANS_APPROVE_DISABLE" NUMBER(1,0), 
	"M02_MIN_REQ_COVERAGE_RATIO" NUMBER(6,2), 
	"M02_GROUP_BP_ENABLE" NUMBER(1,0), 
	"M02_DAILY_WITHDRAWAL_LIMIT" NUMBER(18,5), 
	"M02_DAILY_WITHD_LMT_CUR_CD_M03" NVARCHAR2(3), 
	"M02_STATUS_ID_V01" NUMBER(20,0), 
	"M02_STATUS_CHANGED_BY_ID_U17" NUMBER(20,0), 
	"M02_STATUS_CHANGED_DATE" DATE, 
	"M02_PWD_MAX_SAME_ADJ_CHARS" NUMBER(1,0), 
	"M02_CUST_PWD_MAX_SAME_ADJ_CHRS" NUMBER(1,0), 
	"M02_PWD_NOT_CONTAIN_LOGIN_NAME" NUMBER(1,0), 
	"M02_CUST_PWD_NOT_CONTAIN_LGN_N" NUMBER(1,0), 
	"M02_CUST_LOGIN_TRADING_PWD_DIF" NUMBER(1,0), 
	"M02_PWD_MAX_REPEATED_CHARS" NUMBER(1,0), 
	"M02_CUST_PWD_MAX_REPEATED_CHAR" NUMBER(1,0), 
	"M02_PWD_START_SHOULD_CHAR" NUMBER(1,0), 
	"M02_CUST_PWD_START_SHOULD_CHAR" NUMBER(1,0), 
	"M02_MAXIMUM_PASSWORD_LENGTH" NUMBER(2,0), 
	"M02_CUST_MAXIMUM_PWD_LENGTH" NUMBER(2,0), 
	"M02_STMT_PURGE_PERIOD" NUMBER(3,0), 
	"M02_PRIMARY_SECURITY_ACC" VARCHAR2(20), 
	"M02_SECONDARY_SECURITY_ACC" VARCHAR2(20), 
	"M02_DISPLAY_MINUS_BUYING_POWER" NUMBER(1,0), 
	"M02_SEC_COMM_GRP_ALLOWED" NUMBER(1,0) , 
	"M02_ENABLE_CASH_DUE_CLEARED" NUMBER(1,0), 
	"M02_DUE_SETTLE_ENABLED" NUMBER(1,0), 
	"M02_ENABLE_HOLD_DUE_CLEARED" NUMBER(1,0), 
	"M02_ENABLE_PEND_STL_UTILIZE" NUMBER(1,0), 
	"M02_DISPLAY_UNIQUE_ORDER" NUMBER(1,0), 
	"M02_DISABLE_PORTF_SELF_TRADE" NUMBER(1,0), 
	"M02_DISCLAIMER" VARCHAR2(300), 
	"M02_DISCLAIMER_AR" VARCHAR2(300), 
	"M02_CUST_DETAIL_IN_TMPTBL_DAYS" NUMBER(20,0), 
	"M02_MAX_INTL_BACKSEARCH_MONTHS" NUMBER(1,0), 
	"M02_TOLL_FREE_NUMBER" VARCHAR2(20), 
	"M02_APPLY_MIN_DISCOUNT" NUMBER(1,0), 
	"M02_DAILY_WITHD_LMT_CUR_ID_M03" NUMBER(5,0), 
	"M02_DISPLAY_CURRENCY_ID_M03" NUMBER(5,0), 
	"M02_UNDERAGE_TO_MINOR_YEARS" NUMBER(2,0), 
	"M02_MINOR_TO_MAJOR_YEARS" NUMBER(2,0), 
	"M02_REPORT_LOGO_PATH" VARCHAR2(2000), 
	"M02_ADD_PLEDGE_FOR_BP" NUMBER(1,0), 
	"M02_KYC_RENEWAL_INDIVIDUAL" NUMBER(2,0), 
	"M02_KYC_RENEWAL_CORPORATE" NUMBER(2,0), 
	"M02_ADD_BUY_PENDING_FOR_MARGIN" NUMBER(1,0), 
	"M02_ADD_SYM_MARGIN_FOR_MARGIN" NUMBER(1,0), 
	"M02_PRICE_TYPE_FOR_MARGIN" NUMBER(1,0), 
	"M02_VAT_NO" VARCHAR2(20), 
	"M02_CUSTOM_TYPE" VARCHAR2(50), 
	"M02_HOLDING_TRANSATION_DISABLE" NUMBER(1,0), 
	"M02_BROKER_ID_M150" NUMBER(3,0), 
	"M02_DEFAULT_PRODUCT_ID_M152" NUMBER(5,0), 
	"M02_PRIMARY_INSTITUTE_ID_M02" NUMBER(5,0), 
	"M02_DEBIT_MAINTAIN_MARGIN" NUMBER(1,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_DATAPUMP
      DEFAULT DIRECTORY "DUMPDIR"
      ACCESS PARAMETERS
      ( version '11.2'    )
      LOCATION
       ( 'dfn_ntp.m02_institute.dat'
       )
    )
/


begin
  insert into dfn_ntp.m02_institute select * from e_tmp;

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

