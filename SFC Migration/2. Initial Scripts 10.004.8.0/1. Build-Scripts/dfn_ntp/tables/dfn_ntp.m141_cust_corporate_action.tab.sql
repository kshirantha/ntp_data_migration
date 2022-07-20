-- Table DFN_NTP.M141_CUST_CORPORATE_ACTION

CREATE TABLE dfn_ntp.m141_cust_corporate_action
(
    m141_id                         NUMBER (10, 0),
    m141_template_id_m140           NUMBER (5, 0),
    m141_description                VARCHAR2 (100),
    m141_exchange_id_m01            NUMBER (5, 0),
    m141_exchange_code_m01          VARCHAR2 (10),
    m141_symbol_id_m20              NUMBER (10, 0),
    m141_symbol_code_m20            VARCHAR2 (10),
    m141_custodian_id_m26           NUMBER (10, 0),
    m141_custodian_acc_id_m72       NUMBER (10, 0),
    m141_coupon_date                DATE,
    m141_announcement_date          DATE,
    m141_ex_date                    DATE,
    m141_record_date                DATE,
    m141_pay_date                   DATE,
    m141_narration                  VARCHAR2 (500),
    m141_notify_on_announce_date    NUMBER (1, 0),
    m141_notify_on_ex_date          NUMBER (1, 0),
    m141_notify_on_record_date      NUMBER (1, 0),
    m141_notify_on_pay_date         NUMBER (1, 0),
    m141_no_of_payments             NUMBER (2, 0),
    m141_created_by_id_u17          NUMBER (10, 0),
    m141_created_date               DATE,
    m141_modified_by_id_u17         NUMBER (10, 0),
    m141_modified_date              DATE,
    m141_status_id_v01              NUMBER (5, 0),
    m141_status_changed_by_id_u17   NUMBER (10, 0),
    m141_status_changed_date        DATE,
    m141_external_ref               VARCHAR2 (50),
    m141_institute_id_m02           NUMBER (5, 0)
)
/



-- Comments for  DFN_NTP.M141_CUST_CORPORATE_ACTION

COMMENT ON COLUMN dfn_ntp.m141_cust_corporate_action.m141_notify_on_announce_date IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m141_cust_corporate_action.m141_notify_on_ex_date IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m141_cust_corporate_action.m141_notify_on_record_date IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m141_cust_corporate_action.m141_notify_on_pay_date IS
    '0 - No | 1 - Yes'
/
-- End of DDL Script for Table DFN_NTP.M141_CUST_CORPORATE_ACTION

alter table dfn_ntp.M141_CUST_CORPORATE_ACTION
	add M141_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m141_cust_corporate_action
    MODIFY (m141_symbol_code_m20 VARCHAR2 (25 BYTE))
/

CREATE INDEX dfn_ntp.idx_m141_pay_date
    ON dfn_ntp.m141_cust_corporate_action (m141_pay_date)
/
