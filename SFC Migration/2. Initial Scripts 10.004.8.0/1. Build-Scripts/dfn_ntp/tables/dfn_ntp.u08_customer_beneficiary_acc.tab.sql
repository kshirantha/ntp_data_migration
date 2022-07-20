CREATE TABLE dfn_ntp.u08_customer_beneficiary_acc
(
    u08_id                         NUMBER (10, 0) NOT NULL,
    u08_institute_id_m02           NUMBER (3, 0) NOT NULL,
    u08_customer_id_u01            NUMBER (10, 0) NOT NULL,
    u08_bank_id_m16                NUMBER (5, 0),
    u08_account_no                 VARCHAR2 (20 BYTE) NOT NULL,
    u08_account_type_v01_id        NUMBER (5, 0) NOT NULL,
    u08_currency_code_m03          CHAR (3 BYTE) NOT NULL,
    u08_account_name               VARCHAR2 (100 BYTE) NOT NULL,
    u08_is_default                 NUMBER (1, 0) NOT NULL,
    u08_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    u08_created_date               TIMESTAMP (6) NOT NULL,
    u08_status_id_v01              NUMBER (5, 0) NOT NULL,
    u08_bank_branch_name           VARCHAR2 (100 BYTE),
    u08_iban_no                    VARCHAR2 (100 BYTE),
    u08_modified_by_id_u17         NUMBER (10, 0),
    u08_modified_date              TIMESTAMP (6),
    u08_status_changed_by_id_u17   NUMBER (10, 0),
    u08_status_changed_date        TIMESTAMP (6),
    u08_currency_id_m03            NUMBER (5, 0),
    u08_cash_account_id_u06        NUMBER (5, 0),
    u08_account_id                 NUMBER (10, 0),
    u08_bank_account_type_v01      NUMBER (5, 0),
    u08_is_foreign_bank_acc        NUMBER (1, 0) DEFAULT 0,
    u08_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    PRIMARY KEY (u08_id)
)
ORGANIZATION INDEX
PCTTHRESHOLD 50
/

CREATE INDEX dfn_ntp.u08_acc_u08_u01_id
    ON dfn_ntp.u08_customer_beneficiary_acc (u08_customer_id_u01 ASC)
/

CREATE INDEX dfn_ntp.u08_acc_u08_account_no
    ON dfn_ntp.u08_customer_beneficiary_acc (u08_account_no ASC)
/



COMMENT ON COLUMN dfn_ntp.u08_customer_beneficiary_acc.u08_account_id IS
    'Specialy for cash Accounts'
/
COMMENT ON COLUMN dfn_ntp.u08_customer_beneficiary_acc.u08_account_type_v01_id IS
    '1-Cash Accounts   (TYPE 35)'
/
COMMENT ON COLUMN dfn_ntp.u08_customer_beneficiary_acc.u08_bank_account_type_v01 IS
    'TYPE 55'
/
COMMENT ON COLUMN dfn_ntp.u08_customer_beneficiary_acc.u08_is_foreign_bank_acc IS
    '0 - No , 1 - Yes'
/

ALTER TABLE dfn_ntp.u08_customer_beneficiary_acc
 MODIFY (
  u08_cash_account_id_u06 NUMBER (10, 0)

 )
/

ALTER TABLE dfn_ntp.u08_customer_beneficiary_acc
 MODIFY (
  u08_account_no VARCHAR2 (30 BYTE)

 )
/

ALTER TABLE dfn_ntp.u08_customer_beneficiary_acc
 MODIFY (
  u08_account_no VARCHAR2 (50 BYTE),
  u08_iban_no VARCHAR2 (150 BYTE)

 )
/

ALTER TABLE dfn_ntp.u08_customer_beneficiary_acc
 ADD (
  u08_sequence_no_b VARCHAR2 (20)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.U08_CUSTOMER_BENEFICIARY_ACC 
 ADD (
  U08_ID_TYPE_M15 NUMBER (5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U08_CUSTOMER_BENEFICIARY_ACC')
           AND column_name = UPPER ('U08_ID_TYPE_M15');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.U08_CUSTOMER_BENEFICIARY_ACC 
 ADD (
  U08_ID_NO VARCHAR2 (50)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U08_CUSTOMER_BENEFICIARY_ACC')
           AND column_name = UPPER ('U08_ID_NO');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.U08_CUSTOMER_BENEFICIARY_ACC 
 ADD (
  U08_REMARKS VARCHAR2 (200)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('U08_CUSTOMER_BENEFICIARY_ACC')
           AND column_name = UPPER ('U08_REMARKS');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/


