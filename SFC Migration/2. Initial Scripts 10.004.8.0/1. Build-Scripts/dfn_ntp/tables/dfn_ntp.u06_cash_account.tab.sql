CREATE TABLE dfn_ntp.u06_cash_account
(
    u06_id                           NUMBER (10, 0) NOT NULL,
    u06_institute_id_m02             NUMBER (3, 0) NOT NULL,
    u06_customer_id_u01              NUMBER (10, 0) NOT NULL,
    u06_customer_no_u01              VARCHAR2 (10 BYTE) NOT NULL,
    u06_display_name_u01             VARCHAR2 (1000 BYTE) NOT NULL,
    u06_default_id_no_u01            VARCHAR2 (20 BYTE) NOT NULL,
    u06_currency_code_m03            CHAR (3 BYTE) NOT NULL,
    u06_balance                      NUMBER (25, 10) NOT NULL,
    u06_blocked                      NUMBER (25, 10) NOT NULL,
    u06_open_buy_blocked             NUMBER (25, 10) NOT NULL,
    u06_payable_blocked              NUMBER (25, 10) NOT NULL,
    u06_manual_trade_blocked         NUMBER (25, 10) NOT NULL,
    u06_manual_full_blocked          NUMBER (25, 10) NOT NULL,
    u06_manual_transfer_blocked      NUMBER (25, 10) NOT NULL,
    u06_receivable_amount            NUMBER (25, 10) NOT NULL,
    u06_is_default                   NUMBER (1, 0) NOT NULL,
    u06_created_by_id_u17            NUMBER (10, 0) NOT NULL,
    u06_created_date                 TIMESTAMP (6) NOT NULL,
    u06_status_id_v01                NUMBER (5, 0) NOT NULL,
    u06_modified_by_id_u17           NUMBER (10, 0),
    u06_modified_date                TIMESTAMP (6),
    u06_status_changed_by_id_u17     NUMBER (10, 0),
    u06_status_changed_date          TIMESTAMP (6),
    u06_last_activity_date           DATE,
    u06_display_name                 VARCHAR2 (50 BYTE),
    u06_currency_id_m03              NUMBER (5, 0),
    u06_margin_enabled               NUMBER (5, 0) DEFAULT 0,
    u06_external_ref_no              VARCHAR2 (50 BYTE),
    u06_pending_deposit              NUMBER (25, 10) DEFAULT 0,
    u06_pending_withdraw             NUMBER (25, 10) DEFAULT 0,
    u06_primary_od_limit             NUMBER (25, 10),
    u06_primary_start                DATE,
    u06_primary_expiry               DATE,
    u06_secondary_od_limit           NUMBER (25, 10),
    u06_secondary_start              DATE,
    u06_secondary_expiry             DATE,
    u06_investment_account_no        VARCHAR2 (75 BYTE),
    u06_daily_withdraw_limit         NUMBER (18, 5) DEFAULT 0,
    u06_daily_cum_withdraw_amt       NUMBER (18, 5) DEFAULT 0,
    u06_dbseqid                      NUMBER (20, 0),
    u06_margin_due                   NUMBER (18, 5),
    u06_margin_block                 NUMBER (18, 5),
    u06_ordexecseq                   NUMBER (20, 0),
    u06_pending_restriction          NUMBER (1, 0) DEFAULT 0,
    u06_group_bp_enable              NUMBER (1, 0) DEFAULT 1,
    u06_inactive_dormant_date        DATE,
    u06_inactive_drmnt_status_v01    NUMBER (2, 0),
    u06_margin_product_id_u23        NUMBER (5, 0),
    u06_account_type_v01             NUMBER (2, 0),
    u06_iban_no                      VARCHAR2 (100 BYTE),
    u06_vat_waive_off                NUMBER (1, 0),
    u06_charges_group_m117           NUMBER (5, 0),
    u06_net_receivable               NUMBER (25, 10) DEFAULT 0 NOT NULL,
    u06_status_changed_reason        VARCHAR2 (255 BYTE),
    u06_withdr_overdrawn_amt         NUMBER (18, 5),
    u06_incident_overdrawn_amt       NUMBER (18, 5),
    u06_accrued_interest             NUMBER (18, 5) DEFAULT 0,
    u06_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1,
    u06_discunt_charges_group_m165   NUMBER (5, 0) DEFAULT 0,
    PRIMARY KEY (u06_id)
)
ORGANIZATION INDEX
NOCOMPRESS
OVERFLOW
/

CREATE INDEX dfn_ntp.u06_u06_u01_id
    ON dfn_ntp.u06_cash_account (u06_customer_id_u01 ASC)
/



COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_account_type_v01 IS
    'fk from v01 -13'
/
COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_charges_group_m117 IS
    'fk from m117'
/
COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_discunt_charges_group_m165 IS
    'fk from m165'
/
COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_group_bp_enable IS
    '1 - Enabled, 0 - Dissabled'
/
COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_iban_no IS
    'this is for external reference from bank. optional'
/
COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_manual_full_blocked IS
    'Manual block for withdrawal, updated by back office'
/
COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_manual_trade_blocked IS
    'Manual block for buy/sell, updated by back office'
/
COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_margin_enabled IS
    '0 - No, 1 - Yes, 2 - Expired'
/
COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_net_receivable IS
    'Diff b/w U06_PAYABLE_BLOCKED and U06_RECEIVABLE_AMOUNT. Should be mainatined daily via EOD job'
/
COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_pending_restriction IS
    '1- Available, 0- Not Available'
/
COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_vat_waive_off IS
    '0 - No | 1 - Yes'
/

ALTER TABLE dfn_ntp.U06_CASH_ACCOUNT 
 MODIFY (
  U06_DISCUNT_CHARGES_GROUP_M165 DEFAULT NULL

 )
/

ALTER TABLE dfn_ntp.U06_CASH_ACCOUNT 
 ADD (
  U06_MUTUAL_FUND_ACCOUNT NUMBER (1, 0) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.U06_CASH_ACCOUNT.U06_MUTUAL_FUND_ACCOUNT IS '0 - No | 1 - Yes'
/

ALTER TABLE dfn_ntp.u06_cash_account 
 ADD (
  u06_order_limit_grp_id_m176 NUMBER (3, 0),
  u06_transfer_limit_grp_id_m177 NUMBER (3, 0),
  u06_cum_sell_order_value NUMBER (18, 5) DEFAULT 0,
  u06_cum_buy_order_value NUMBER (18, 5) DEFAULT 0,
  u06_cum_transfer_value NUMBER (18, 5) DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.u06_cash_account
    DROP COLUMN u06_daily_withdraw_limit
/

ALTER TABLE dfn_ntp.u06_cash_account
    DROP COLUMN u06_daily_cum_withdraw_amt
/

ALTER TABLE dfn_ntp.u06_cash_account
 MODIFY (
  u06_default_id_no_u01 NULL

 )
/

ALTER TABLE dfn_ntp.u06_cash_account
 ADD (
  u06_maintain_margin_charged NUMBER (18, 0) DEFAULT 0,
  u06_maintain_margin_block NUMBER (18, 0) DEFAULT 0,
  u06_initial_margin NUMBER (18, 0) DEFAULT 0,
  u06_maintain_margin_utilized NUMBER (18, 0) DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.U06_CASH_ACCOUNT 
 ADD (
  U06_LOAN_AMOUNT NUMBER (18, 5) DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.U06_CASH_ACCOUNT 
 MODIFY (
  U06_WITHDR_OVERDRAWN_AMT DEFAULT 0,
  U06_INCIDENT_OVERDRAWN_AMT DEFAULT 0
 )
/


ALTER TABLE dfn_ntp.u06_cash_account
 MODIFY (
  u06_group_bp_enable DEFAULT 0

 )
/

ALTER TABLE dfn_ntp.u06_cash_account
 MODIFY (
  u06_customer_no_u01 VARCHAR2 (25 BYTE)

 )
/

CREATE INDEX dfn_ntp.idx_u06_display_name_u01
    ON dfn_ntp.u06_cash_account (u06_display_name_u01 ASC)
/

ALTER TABLE dfn_ntp.u06_cash_account
 MODIFY (
  u06_customer_no_u01 VARCHAR2 (50 BYTE)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.U06_CASH_ACCOUNT ADD ( U06_NET_RECEIVABLE_INCLUDE NUMBER (1, 0) DEFAULT 0 NOT NULL )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U06_CASH_ACCOUNT')
           AND column_name = UPPER ('U06_NET_RECEIVABLE_INCLUDE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN DFN_NTP.U06_CASH_ACCOUNT.U06_NET_RECEIVABLE_INCLUDE IS 'parameter to identify if net recivable consider for avaibale withdraw calculation'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.U06_CASH_ACCOUNT ADD ( U06_PENDING_FULL_BLOCKED NUMBER (25, 10) DEFAULT 0 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U06_CASH_ACCOUNT')
           AND column_name = UPPER ('U06_PENDING_FULL_BLOCKED');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
COMMENT ON COLUMN dfn_ntp.U06_CASH_ACCOUNT.U06_PENDING_FULL_BLOCKED IS 'Pending amount of the U06_MANUAL_FULL_BLOCKED'
/
CREATE INDEX dfn_ntp.idx_u06_cust_no
    ON dfn_ntp.u06_cash_account (u06_customer_no_u01)
/
CREATE INDEX dfn_ntp.idx_u06_inst_id
    ON dfn_ntp.u06_cash_account (u06_institute_id_m02)
/

DECLARE
    l_is_nullable   NUMBER := 0;
    l_script        VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.U06_CASH_ACCOUNT MODIFY (U06_DISPLAY_NAME_U01 NULL)';
BEGIN
    SELECT DECODE (nullable, 'Y', 1, 0)
      INTO l_is_nullable
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U06_CASH_ACCOUNT')
           AND column_name = UPPER ('U06_DISPLAY_NAME_U01');

    IF l_is_nullable = 0
    THEN
        EXECUTE IMMEDIATE l_script;
    END IF;
END;
/



ALTER TABLE DFN_NTP.U06_CASH_ACCOUNT 
 ADD (
  U06_BLOCK_STATUS_B NUMBER (1) DEFAULT 1
 )
/
COMMENT ON COLUMN DFN_NTP.U06_CASH_ACCOUNT.U06_BLOCK_STATUS_B IS '1 - Open | 2 - Debit Block | 3 - Close | 4 - Full Block | 5 - DB Freeze | Null Consider As Debit Block'
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'ALTER TABLE dfn_ntp.U06_CASH_ACCOUNT 
 ADD (
  u06_is_ipo_customer NUMBER (1) DEFAULT 0
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('U06_CASH_ACCOUNT')
           AND column_name = UPPER ('u06_is_ipo_customer');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_is_ipo_customer IS '1=IPO'
/


ALTER TABLE dfn_ntp.u06_cash_account
 MODIFY (
  u06_balance DEFAULT 0,
  u06_blocked DEFAULT 0,
  u06_open_buy_blocked DEFAULT 0,
  u06_payable_blocked DEFAULT 0 ,
  u06_manual_trade_blocked DEFAULT 0 ,
  u06_manual_full_blocked DEFAULT 0 ,
  u06_manual_transfer_blocked DEFAULT 0 ,
  u06_receivable_amount DEFAULT 0
 )
/

ALTER TABLE dfn_ntp.u06_cash_account
 ADD (
  u06_sub_waive_grp_id_m154_c NUMBER (5)
 )
/


ALTER TABLE dfn_ntp.U06_CASH_ACCOUNT 
 ADD (
  U06_CUM_ONLINE_SEL_ORDER_VALUE NUMBER (18, 5) DEFAULT 0,
  U06_CUM_ONLINE_BUY_ORDER_VALUE NUMBER (18, 5) DEFAULT 0
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.u06_cash_account
 ADD (
  u06_other_commsion_grp_id_m22 NUMBER (3, 0) DEFAULT 0
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u06_cash_account')
           AND column_name = UPPER ('u06_other_commsion_grp_id_m22');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_other_commsion_grp_id_m22 IS
    'Algo Commission group, other commission group'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.u06_cash_account ADD (  u06_is_unasgnd_account NUMBER (1) )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('u06_cash_account')
           AND column_name = UPPER ('u06_is_unasgnd_account');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


ALTER TABLE dfn_ntp.u06_cash_account
 MODIFY (
  u06_is_unasgnd_account DEFAULT 1
 )
/

COMMENT ON COLUMN dfn_ntp.u06_cash_account.u06_is_unasgnd_account IS
    '0 - No | 1 - Yes (Unassigned for User or Trading Account)'
/
