-- Table DFN_NTP.Z01_FORMS_M

CREATE TABLE dfn_ntp.z01_forms_m_c
(
    Z01_ID                       NUMBER(5)              not null,
    Z01_TAG                      VARCHAR2(200)          not null,
    Z01_VERSION_NO               NUMBER(5)              not null,
    Z01_VIEW_NAME                VARCHAR2(200)          not null,
    Z01_TITLE                    NVARCHAR2(200)         not null,
    Z01_FORM_TYPE                NUMBER(1)              not null,
    Z01_SORT_COLUMN              VARCHAR2(200),
    Z01_DATE_FIELD               VARCHAR2(100),
    Z01_TRUNCATE_DATE            NUMBER(1),
    Z01_LOAD_ALL_DATA            NUMBER(1),
    Z01_TIME_STAMP               DATE,
    Z01_HAS_SENSITIVE_DATA       NUMBER(1)    default 1 not null,
    Z01_EXCEL_EXPORT_SEC_ID      NUMBER(5),
    Z01_TEXTFILE_EXPORT_SEC_ID   NUMBER(5),
    Z01_AUTO_REFRESH             NUMBER(1)    default 0,
    Z01_SOURCE_TYPE              NUMBER(1)    default 1 not null,
    Z01_IGNORE_SORT              NUMBER(1)    default 0,
    Z01_LOAD_DATA_ON_OPENING     NUMBER(1)    default 1,
    Z01_FULLY_LOADED             NUMBER(1)    default 0,
    Z01_UPDATED_DATETIME         DATE,
    Z01_COLUMNS_UPDATED_DATETIME DATE,
    Z01_MENUS_UPDATED_DATETIME   DATE,
    Z01_COLORS_UPDATED_DATETIME  DATE,
    Z01_CUSTOM_TYPE              VARCHAR2(50) default 1,
    Z01_IS_CUSTOMIZED            NUMBER(1)    default 0,
    Z01_BROKER_CODE              VARCHAR2(50)
)
/

ALTER TABLE DFN_NTP.Z01_FORMS_M_C
 ADD (
  Z01_FEATURE_ID_V14 NUMBER (3,0)
 )
/