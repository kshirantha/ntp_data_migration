-- Table DFN_NTP.M93_BANK_ACCOUNTS

CREATE TABLE dfn_ntp.m93_bank_accounts
(
    m93_id                         NUMBER (18, 0),
    m93_account_type_id_v01        NUMBER (2, 0) DEFAULT 0,
    m93_bank_id_m16                NUMBER (5, 0),
    m93_accountno                  VARCHAR2 (50),
    m93_acc_owner_name             VARCHAR2 (100),
    m93_acc_address_1              VARCHAR2 (100),
    m93_acc_address_2              VARCHAR2 (100),
    m93_currency_id_m03            NUMBER (3, 0),
    m93_branch_name                VARCHAR2 (100),
    m93_contact_name               VARCHAR2 (100),
    m93_contact_numbers            VARCHAR2 (100),
    m93_iban_no                    VARCHAR2 (255),
    m93_bban_no                    VARCHAR2 (255),
    m93_online_trans_type_id_v01   NUMBER (5, 0) DEFAULT 0,
    m93_allow_deposit              NUMBER (1, 0) DEFAULT 1,
    m93_allow_withdraw             NUMBER (1, 0) DEFAULT 1,
    m93_allow_charge               NUMBER (1, 0) DEFAULT 1,
    m93_allow_refund               NUMBER (1, 0) DEFAULT 1,
    m93_balance                    NUMBER (18, 5) DEFAULT 0,
    m93_blocked_amount             NUMBER (18, 5) DEFAULT 0,
    m93_od_limit                   NUMBER (18, 5) DEFAULT 0,
    m93_institution_id_m02         NUMBER (5, 0) DEFAULT NULL,
    m93_stp_account                NUMBER (5, 0) DEFAULT 0,
    m93_stp_acc_rank               NUMBER (5, 0) DEFAULT 1,
    m93_acc_country                VARCHAR2 (100),
    m93_is_default_omnibus         NUMBER (2, 0) DEFAULT 0,
    m93_is_visible                 NUMBER (1, 0) DEFAULT 1,
    m93_online_trans_fee           NUMBER (18, 5) DEFAULT 0,
    m93_status_id_v01              NUMBER (20, 0),
    m93_created_by_id_u17          NUMBER (5, 0),
    m93_created_date               DATE,
    m93_modified_by_id_u17         NUMBER (20, 0),
    m93_modified_date              DATE,
    m93_status_changed_by_id_u17   NUMBER (20, 0),
    m93_status_changed_date        DATE,
    m93_currency_code_m03          VARCHAR2 (3)
)
/

-- Constraints for  DFN_NTP.M93_BANK_ACCOUNTS


  ALTER TABLE dfn_ntp.m93_bank_accounts ADD CONSTRAINT m93_banks_pk PRIMARY KEY (m93_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m93_bank_accounts MODIFY (m93_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m93_bank_accounts MODIFY (m93_account_type_id_v01 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m93_bank_accounts MODIFY (m93_bank_id_m16 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m93_bank_accounts MODIFY (m93_accountno NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m93_bank_accounts MODIFY (m93_currency_id_m03 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m93_bank_accounts MODIFY (m93_balance NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m93_bank_accounts MODIFY (m93_blocked_amount NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m93_bank_accounts MODIFY (m93_od_limit NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m93_bank_accounts MODIFY (m93_institution_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m93_bank_accounts MODIFY (m93_currency_code_m03 NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M93_BANK_ACCOUNTS

COMMENT ON COLUMN dfn_ntp.m93_bank_accounts.m93_iban_no IS 'IBAN Number'
/
COMMENT ON COLUMN dfn_ntp.m93_bank_accounts.m93_bban_no IS 'BBAN Number'
/
COMMENT ON COLUMN dfn_ntp.m93_bank_accounts.m93_online_trans_type_id_v01 IS
    '0 - None | 1 - SWIFT'
/
-- End of DDL Script for Table DFN_NTP.M93_BANK_ACCOUNTS

alter table dfn_ntp.M93_BANK_ACCOUNTS
	add M93_CUSTOM_TYPE varchar2(50) default 1
/


ALTER TABLE dfn_ntp.m93_bank_accounts
 ADD (
  m93_eod_settle_ac_type NUMBER (3) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.m93_bank_accounts.m93_eod_settle_ac_type IS
    '1 - Derivatives Settlement IM , 2 - Derivatives Settlement MM , 3 - Derivatives Settlement MTM'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.M93_BANK_ACCOUNTS DROP COLUMN M93_EOD_SETTLE_AC_TYPE';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('M93_BANK_ACCOUNTS')
           AND column_name = UPPER ('M93_EOD_SETTLE_AC_TYPE');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

ALTER TABLE dfn_ntp.m93_bank_accounts
	ADD (m93_eod_settle_ac_type_id_v01 NUMBER (3) DEFAULT 0)
/

COMMENT ON COLUMN dfn_ntp.m93_bank_accounts.m93_eod_settle_ac_type_id_v01 IS
	'0 - none, 1 - derivatives settlement im , 2 - derivatives settlement mm , 3 - derivatives settlement mtm'
/