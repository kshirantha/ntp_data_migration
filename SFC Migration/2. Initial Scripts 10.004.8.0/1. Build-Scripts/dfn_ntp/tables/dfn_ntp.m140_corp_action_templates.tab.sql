-- Table DFN_NTP.M140_CORP_ACTION_TEMPLATES

CREATE TABLE dfn_ntp.m140_corp_action_templates
(
    m140_id                         NUMBER (5, 0),
    m140_description                VARCHAR2 (75),
    m140_description_lang           VARCHAR2 (75),
    m140_institute_id_m02           NUMBER (5, 0),
    m140_created_by_id_u17          NUMBER (10, 0),
    m140_created_date               DATE,
    m140_modified_by_id_u17         NUMBER (10, 0),
    m140_modified_date              DATE,
    m140_status_id_v01              NUMBER (5, 0),
    m140_status_changed_by_id_u17   NUMBER (10, 0),
    m140_status_changed_date        DATE,
    m140_nostro_account_req         NUMBER (1, 0),
    m140_coupon_date_req            NUMBER (1, 0),
    m140_notification_pref_req      NUMBER (1, 0),
    m140_charge_req                 NUMBER (1, 0),
    m140_charge_amount              NUMBER (18, 5),
    m140_tax_percentage             NUMBER (8, 5),
    m140_charge_currency_code_m03   CHAR (3),
    m140_charge_currency_id_m03     NUMBER (5, 0),
    m140_hold_adjustment_req        NUMBER (1, 0),
    m140_hold_adj_ratio_req         NUMBER (1, 0),
    m140_hold_adj_par_val_req       NUMBER (1, 0),
    m140_hold_payment_req           NUMBER (1, 0),
    m140_hold_pay_no_of_payments    NUMBER (2, 0),
    m140_cash_adjustment_req        NUMBER (1, 0),
    m140_cash_adj_type              NUMBER (1, 0),
    m140_hold_adj_type              NUMBER (1, 0),
    m140_reinvest_t41               NUMBER (1, 0)
)
/



-- Comments for  DFN_NTP.M140_CORP_ACTION_TEMPLATES

COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_nostro_account_req IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_coupon_date_req IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_notification_pref_req IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_charge_req IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_hold_adjustment_req IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_hold_adj_ratio_req IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_hold_adj_par_val_req IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_hold_payment_req IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_cash_adjustment_req IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_cash_adj_type IS
    '1 - Pay | 2 - Deduct'
/
COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_hold_adj_type IS
    '1 - Pay | 2 - Deduct'
/
COMMENT ON COLUMN dfn_ntp.m140_corp_action_templates.m140_reinvest_t41 IS
    '0 - No | 1 - Yes'
/
-- End of DDL Script for Table DFN_NTP.M140_CORP_ACTION_TEMPLATES

alter table dfn_ntp.M140_CORP_ACTION_TEMPLATES
	add M140_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.m140_corp_action_templates ADD CONSTRAINT pk_m140_id
  PRIMARY KEY (
  m140_id
)
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.M140_CORP_ACTION_TEMPLATES  ADD (  M140_AMOUNT_TYPE NUMBER (1, 0) DEFAULT 1 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('M140_CORP_ACTION_TEMPLATES')
           AND column_name = UPPER ('M140_AMOUNT_TYPE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.M140_CORP_ACTION_TEMPLATES.M140_AMOUNT_TYPE IS '1 - Amount | 2 - Pecentage'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.M140_CORP_ACTION_TEMPLATES  ADD (  M140_PRE_DEFINED NUMBER (1, 0) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('M140_CORP_ACTION_TEMPLATES')
           AND column_name = UPPER ('M140_PRE_DEFINED');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.M140_CORP_ACTION_TEMPLATES.M140_PRE_DEFINED IS '0 - No | 1 - Yes'
/

