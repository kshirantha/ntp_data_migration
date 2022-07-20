-- Table DFN_NTP.T21_DAILY_INTEREST_FOR_CHARGES

CREATE TABLE dfn_ntp.t21_daily_interest_for_charges
(
    t21_id                        NUMBER (18, 0),
    t21_cash_account_id_u06       NUMBER (18, 0),
    t21_charges_id_m97            NUMBER (5, 0),
    t21_interest_charge_amt       NUMBER (18, 5),
    t21_created_date              DATE DEFAULT SYSDATE,
    t21_value_date                DATE DEFAULT SYSDATE,
    t21_status                    NUMBER (1, 0) DEFAULT 0,
    t21_remarks                   VARCHAR2 (2000) DEFAULT NULL,
    t21_cash_transaction_id_t06   NUMBER (18, 0),
    t21_ovedraw_amt               NUMBER (18, 5) DEFAULT 0,
    t21_interest_rate             NUMBER (4, 2),
    t21_posted_date               DATE,
    t21_frequency_id              NUMBER (1, 0) DEFAULT 1,
    t21_charges_code_m97          VARCHAR2 (10),
    t21_created_by_id_u17         NUMBER (18, 0),
    t21_trans_value_date          DATE,
    t21_approved_by_id_u17        NUMBER (18, 0),
    t21_approved_date             DATE
)
/

-- Constraints for  DFN_NTP.T21_DAILY_INTEREST_FOR_CHARGES


  ALTER TABLE dfn_ntp.t21_daily_interest_for_charges MODIFY (t21_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t21_daily_interest_for_charges MODIFY (t21_cash_account_id_u06 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t21_daily_interest_for_charges MODIFY (t21_charges_id_m97 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t21_daily_interest_for_charges MODIFY (t21_interest_charge_amt NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t21_daily_interest_for_charges MODIFY (t21_created_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t21_daily_interest_for_charges MODIFY (t21_value_date NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t21_daily_interest_for_charges MODIFY (t21_status NOT NULL ENABLE)
/

-- Indexes for  DFN_NTP.T21_DAILY_INTEREST_FOR_CHARGES


CREATE INDEX dfn_ntp.idx_t21_cash_account_id
    ON dfn_ntp.t21_daily_interest_for_charges (t21_cash_account_id_u06)
/

CREATE INDEX dfn_ntp.idx_t21_created_date
    ON dfn_ntp.t21_daily_interest_for_charges (t21_created_date)
/

CREATE INDEX dfn_ntp.idx_t21_charges_code
    ON dfn_ntp.t21_daily_interest_for_charges (t21_charges_code_m97)
/

-- Comments for  DFN_NTP.T21_DAILY_INTEREST_FOR_CHARGES

COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_cash_account_id_u06 IS
    ''
/
COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_charges_id_m97 IS
    ''
/
COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_value_date IS
    'Posting Date'
/
COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_status IS
    '0 = Pending | 1 = Posted | 2 = Cancel | 3 = Adjusted | 4 = Cap-Adjusted | 5 = Invalidate by Adjust | 6 - Pending Manual Adjustment'
/
COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_cash_transaction_id_t06 IS
    ''
/
COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_frequency_id IS
    '1= EOD | 2 = EOW | 3 = EOM'
/
COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_charges_code_m97 IS
    ''
/
COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_created_by_id_u17 IS
    ''
/
COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_trans_value_date IS
    'Transaction Effective Date Mainly Used in Manual Interest Adjustment'
/
-- End of DDL Script for Table DFN_NTP.T21_DAILY_INTEREST_FOR_CHARGES

alter table dfn_ntp.T21_DAILY_INTEREST_FOR_CHARGES
	add T21_Custom_Type varchar2(50) default 1
/

ALTER TABLE dfn_ntp.t21_daily_interest_for_charges
 ADD (
  t21_institute_id_m02 NUMBER (3, 0) DEFAULT 1
 )
/

ALTER TABLE dfn_ntp.t21_daily_interest_for_charges
 ADD (
  t21_custodian_id_m26 NUMBER (5, 0),
  t21_u24_symbol_code_m20 VARCHAR2 (25 BYTE),
  t21_net_holding NUMBER (18, 0),
  t21_u24_symbol_id_m20 NUMBER (5, 0),
  t21_u24_exchange_code_m01 VARCHAR2 (10 BYTE)
 )
/

ALTER TABLE dfn_ntp.t21_daily_interest_for_charges
 ADD (
  t21_flat_fee NUMBER (10, 5) DEFAULT 0
 )
/


ALTER TABLE dfn_ntp.t21_daily_interest_for_charges
 ADD (
  t21_orginal_rate NUMBER (4, 2) DEFAULT 0
 )
/
COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_orginal_rate IS
    'Initial Interest rate + tax rate, needed during re calculation'
/
ALTER TABLE dfn_ntp.t21_daily_interest_for_charges
 ADD (
  t21_margin_product_id_u23 NUMBER (10)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE DFN_NTP.T21_DAILY_INTEREST_FOR_CHARGES ADD (T21_INTEREST_INDICES_RATE_M65 NUMBER (18, 5))';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T21_DAILY_INTEREST_FOR_CHARGES')
           AND column_name = UPPER ('T21_INTEREST_INDICES_RATE_M65');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

-- Table DFN_NTP.T21_DAILY_INTEREST_FOR_CHARGES

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := ' ALTER TABLE dfn_ntp.t21_daily_interest_for_charges
 ADD (
  t21_add_or_sub_to_saibor_rt_b NUMBER (1, 0)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t21_daily_interest_for_charges')
           AND column_name = UPPER ('t21_add_or_sub_to_saibor_rt_b');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := ' ALTER TABLE dfn_ntp.t21_daily_interest_for_charges
 ADD (
  t21_add_or_sub_rate_b NUMBER (10, 5)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t21_daily_interest_for_charges')
           AND column_name = UPPER ('t21_add_or_sub_rate_b');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := ' ALTER TABLE dfn_ntp.t21_daily_interest_for_charges
 ADD (
  t21_spread_amount_b NUMBER(18,5)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t21_daily_interest_for_charges')
           AND column_name = UPPER ('t21_spread_amount_b');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_add_or_sub_to_saibor_rt_b IS
    '0 - Add | 1 - Sub'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := ' ALTER TABLE dfn_ntp.t21_daily_interest_for_charges
 ADD (
  t21_tax_rate_m65 NUMBER (10, 5)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t21_daily_interest_for_charges')
           AND column_name = UPPER ('t21_tax_rate_m65');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := ' ALTER TABLE dfn_ntp.t21_daily_interest_for_charges
 ADD (
  t21_tax_amount NUMBER (18, 5)
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t21_daily_interest_for_charges')
           AND column_name = UPPER ('t21_tax_amount');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
        := 'ALTER TABLE dfn_ntp.t21_daily_interest_for_charges RENAME COLUMN t21_tax_rate_m65 TO t21_tax_rate';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t21_daily_interest_for_charges')
           AND column_name = UPPER ('t21_tax_rate_m65');

    IF l_count = 1
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.t21_daily_interest_for_charges.t21_tax_rate IS
    'Tax rate from M65 or M118'
/
ALTER TABLE dfn_ntp.t21_daily_interest_for_charges MODIFY (t21_u24_symbol_id_m20 NUMBER (10))
/
