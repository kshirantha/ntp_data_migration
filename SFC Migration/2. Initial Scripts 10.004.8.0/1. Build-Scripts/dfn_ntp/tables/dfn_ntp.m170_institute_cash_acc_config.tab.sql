CREATE TABLE dfn_ntp.m170_institute_cash_acc_config
    (m170_id                        NUMBER(10,0) ,
    m170_institute_id_m02          NUMBER(10,0),
    m170_currency_id_m03           NUMBER(10,0),
    m170_currency_code_m03         VARCHAR2(50 BYTE),
    m170_cash_account_id_u06       NUMBER(10,0),
    m170_status_id_v01             NUMBER(15,0),
    m170_created_by_id_u17         NUMBER(20,0),
    m170_created_date              DATE,
    m170_modified_by_id_u17        NUMBER(20,0),
    m170_modified_date             DATE,
    m170_status_changed_by_id_u17  NUMBER(20,0),
    m170_status_changed_date       DATE)

/


ALTER TABLE dfn_ntp.m170_institute_cash_acc_config
ADD CONSTRAINT pk_m170 PRIMARY KEY (m170_id)
USING INDEX

/



