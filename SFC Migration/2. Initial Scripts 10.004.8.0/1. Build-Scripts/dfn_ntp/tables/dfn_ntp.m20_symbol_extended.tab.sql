CREATE TABLE dfn_ntp.m20_symbol_extended
(
    m20_id                           NUMBER (22, 0),
    m20_maturity_day                 VARCHAR2 (2 BYTE),
    m20_maturity_myear               VARCHAR2 (6 BYTE),
    m20_fund_type_v01                NUMBER (22, 0),
    m20_cutofftime                   DATE,
    m20_amc                          NUMBER (22, 0),
    m20_short_name                   VARCHAR2 (50 BYTE),
    m20_issuer_name                  VARCHAR2 (50 BYTE),
    m20_issue_size                   NUMBER (22, 0),
    m20_security_domicile_id_m05     NUMBER (5, 0),
    m20_security_currency_code_m03   CHAR (3 BYTE),
    m20_price_update_code_v23        NUMBER (22, 0),
    m20_industry_v24                 NUMBER (22, 0),
    m20_issue_date                   DATE,
    m20_maturity_date                DATE,
    m20_divident_date                DATE,
    m20_int_payment_date             DATE,
    m20_accrual_start_date           DATE,
    m20_no_of_payment_v25            NUMBER (2, 0),
    m20_bond_trade_type              NUMBER (5, 0),
    m20_margin_control               NUMBER (22, 0),
    m20_safe_custody_code            NUMBER (22, 0),
    m20_interest_rate                NUMBER (22, 18),
    m20_interest_day_basis_id_v26    NUMBER (22, 2),
    m20_def_depository_code_m01      VARCHAR2 (10 BYTE),
    m20_share_register               VARCHAR2 (50 BYTE),
    m20_euro_clear_no                VARCHAR2 (50 BYTE),
    m20_cedel_no                     VARCHAR2 (50 BYTE),
    m20_sedol_no                     VARCHAR2 (50 BYTE),
    m20_quoted_listed_no             VARCHAR2 (50 BYTE),
    m20_risk_currency_code_m03       CHAR (3 BYTE),
    m20_risk_country_id_m05          NUMBER (5, 0),
    m20_rating_v27                   NUMBER (22, 2),
    m20_municipal_gvt_code_m01       VARCHAR2 (10 BYTE),
    m20_security_currency_id_m03     NUMBER (5, 0),
    m20_municipal_gvt_id_m01         NUMBER (5, 0),
    m20_default_depository_id_m01    NUMBER (5, 0),
    m20_session_1_start_date         DATE,
    m20_session_1_end_date           DATE,
    m20_session_2_start_date         DATE,
    m20_session_2_end_date           DATE,
    m20_session_1_hijri_strt_date    VARCHAR2 (50 BYTE),
    m20_session_1_hijri_end_date     VARCHAR2 (50 BYTE),
    m20_session_2_hijri_strt_date    VARCHAR2 (50 BYTE),
    m20_session_2_hijri_end_date     VARCHAR2 (50 BYTE),
    m20_risk_currency_id_m03         NUMBER (5, 0),
    m20_stock_exchange_code_m01      VARCHAR2 (10 BYTE),
    m20_stock_exchange_id_m01        NUMBER (5, 0),
    m20_sub_asset_type_id_v08        NUMBER (5, 0),
    m20_charge_type                  NUMBER (5, 0),
    m20_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1
)
/


COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_amc IS
    'Asset Management Company (AMC) Applicable for Mutual Funds'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_bond_trade_type IS
    '0 - None | 1 - Exchange | 2 - OTC'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_charge_type IS
    '0 - None , 1- Block Customer , 2 - Debit Customer'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_def_depository_code_m01 IS
    'M20_DEFAULT_DEPOSITORY_CODE_M01'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_fund_type_v01 IS
    'Applicable for Mutual Funds (V01_TYPE = 8)'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_safe_custody_code IS
    '0 - No | 1 - Yes'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_session_1_end_date IS
    'first_subs_expdate'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_session_1_hijri_end_date IS
    'first_subs_exp_hijri'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_session_1_hijri_strt_date IS
    'first_subs_start_hijri'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_session_1_start_date IS
    'first_subs_startdate'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_session_2_end_date IS
    'sec_subs_expdate'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_session_2_hijri_end_date IS
    'sec_subs_exp_hijri'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_session_2_hijri_strt_date IS
    'sec_subs_start_hijri'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_session_2_start_date IS
    'sec_subs_startdate'
/
COMMENT ON COLUMN dfn_ntp.m20_symbol_extended.m20_sub_asset_type_id_v08 IS
    'fk from v08'
/

ALTER TABLE dfn_ntp.m20_symbol_extended ADD CONSTRAINT pk_m20_id_extd
  PRIMARY KEY (
  m20_id
)
/

CREATE INDEX dfn_ntp.idx_m20_maturity_date
    ON dfn_ntp.m20_symbol_extended (m20_maturity_date)
/

DECLARE
    l_count       NUMBER := 0;

    l_ddl_temp    VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol_extended ADD (m20_cutofftime_t VARCHAR(5))';

    l_dml         VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol_extended SET m20_cutofftime_t = TO_CHAR (m20_cutofftime, ''HH24:MI'')';

    l_dml_1       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol_extended SET m20_cutofftime = NULL';

    l_ddl_alter   VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol_extended MODIFY (m20_cutofftime VARCHAR(5))';

    l_dml_2       VARCHAR2 (1000)
        := 'UPDATE dfn_ntp.m20_symbol_extended SET m20_cutofftime = m20_cutofftime_t';

    l_ddl_del     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.m20_symbol_extended DROP COLUMN m20_cutofftime_t';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('m20_symbol_extended')
           AND column_name = UPPER ('m20_cutofftime')
           AND data_type = 'DATE';

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl_temp;

        EXECUTE IMMEDIATE l_dml;

        EXECUTE IMMEDIATE l_dml_1;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_alter;

        EXECUTE IMMEDIATE l_dml_2;

        COMMIT;

        EXECUTE IMMEDIATE l_ddl_del;
    END IF;
END;
/

