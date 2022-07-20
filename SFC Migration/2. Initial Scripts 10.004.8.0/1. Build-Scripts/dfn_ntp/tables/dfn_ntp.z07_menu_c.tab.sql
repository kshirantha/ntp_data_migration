CREATE TABLE dfn_ntp.z07_menu_c
(
    Z07_ID                VARCHAR2(20) not null,
    Z07_NAME              VARCHAR2(50),
    Z07_TAG               VARCHAR2(50),
    Z07_SEC_ID            NUMBER(5),
    Z07_FKEY              NUMBER(10),
    Z07_HIDE              NUMBER(1),
    Z07_ICON              VARCHAR2(50),
    Z07_ROUTE             VARCHAR2(500),
    Z07_QUERY_PARAMS      VARCHAR2(500),
    Z07_PKEY              NUMBER(20),
    Z07_CUSTOM_TYPE       VARCHAR2(50) default 1,
    Z07_IS_CUSTOMIZED     NUMBER(1)    default 0,
    Z07_DELETED_FROM_CORE NUMBER(1)    default 0,
    Z07_BROKER_CODE       VARCHAR2(50),
    Z07_CHANGE_STATUS     NUMBER(1)
)
/

ALTER TABLE DFN_NTP.Z07_MENU_C
 ADD (
  Z07_FEATURE_ID_V14 NUMBER (3,0)
 )
/

ALTER TABLE dfn_ntp.z07_menu_c
 ADD (
  z07_form_title VARCHAR2 (200)
 )
/
