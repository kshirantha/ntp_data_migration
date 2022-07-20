CREATE TABLE dfn_ntp.t56_product_subscription_data
(
    t56_id                           NUMBER (18, 0) NOT NULL,
    t56_customer_id_u01              NUMBER (18, 0),
    t56_customer_login_u09           NUMBER (18, 0),
    t56_product_id_m152              NUMBER (5, 0),
    t56_subfee_waiveof_grp_id_m154   NUMBER (10, 0),
    t56_from_date                    DATE,
    t56_to_date                      DATE,
    t56_status                       NUMBER (2, 0),
    t56_no_of_months                 NUMBER (2, 0) DEFAULT 0,
    t56_service_fee                  NUMBER (18, 5) DEFAULT 0,
    t56_broker_fee                   NUMBER (18, 5) DEFAULT 0,
    t56_vat_service_fee              NUMBER (18, 5) DEFAULT 0,
    t56_vat_broker_fee               NUMBER (18, 5) DEFAULT 0,
    t56_reject_reason                VARCHAR2 (100 BYTE),
    t56_datetime                     DATE DEFAULT SYSDATE
)
/



ALTER TABLE dfn_ntp.t56_product_subscription_data
    ADD CONSTRAINT t56_pk PRIMARY KEY (t56_id) USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t56_product_subscription_data.t56_status IS
    '0 - Suspend | 1 - Approved | 2 - Downgraded | 3 - rejected'
/

ALTER TABLE dfn_ntp.t56_product_subscription_data
 ADD (
  t56_institute_id_m02 NUMBER (3, 0)
 )
/

CREATE INDEX dfn_ntp.idx_t56_date
    ON dfn_ntp.t56_product_subscription_data (t56_to_date ASC)
/

ALTER TABLE dfn_ntp.t56_product_subscription_data
 ADD (
  t56_service_fee_waiveof_amnt NUMBER (18, 5),
  t56_broker_fee_waiveof_amnt NUMBER (18, 5)
 )
/

CREATE INDEX DFN_NTP.N_UK_ID_U01 ON DFN_NTP.T56_PRODUCT_SUBSCRIPTION_DATA
   (  T56_CUSTOMER_ID_U01 ASC  ) 
/

CREATE INDEX DFN_NTP.N_UK_ID_U09 ON DFN_NTP.T56_PRODUCT_SUBSCRIPTION_DATA
   (  T56_CUSTOMER_LOGIN_U09 ASC  ) 
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T56_PRODUCT_SUBSCRIPTION_DATA 
 ADD (
  T56_EXCHANGE_FEE NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T56_PRODUCT_SUBSCRIPTION_DATA')
           AND column_name = UPPER ('T56_EXCHANGE_FEE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T56_PRODUCT_SUBSCRIPTION_DATA 
 ADD (
  T56_VAT_EXCHANGE_FEE NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T56_PRODUCT_SUBSCRIPTION_DATA')
           AND column_name = UPPER ('T56_VAT_EXCHANGE_FEE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T56_PRODUCT_SUBSCRIPTION_DATA 
 ADD (
  T56_OTHER_FEE NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T56_PRODUCT_SUBSCRIPTION_DATA')
           AND column_name = UPPER ('T56_OTHER_FEE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T56_PRODUCT_SUBSCRIPTION_DATA 
 ADD (
  T56_VAT_OTHER_FEE NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T56_PRODUCT_SUBSCRIPTION_DATA')
           AND column_name = UPPER ('T56_VAT_OTHER_FEE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T56_PRODUCT_SUBSCRIPTION_DATA 
 ADD (
  T56_EXCHANGE_FEE_WAIVEOF_AMNT NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T56_PRODUCT_SUBSCRIPTION_DATA')
           AND column_name = UPPER ('T56_EXCHANGE_FEE_WAIVEOF_AMNT');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T56_PRODUCT_SUBSCRIPTION_DATA 
 ADD (
  T56_OTHER_FEE_WAIVEOF_AMNT NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T56_PRODUCT_SUBSCRIPTION_DATA')
           AND column_name = UPPER ('T56_OTHER_FEE_WAIVEOF_AMNT');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.T56_PRODUCT_SUBSCRIPTION_DATA 
 ADD (
  T56_IS_AUTO_SUBCRIPTION NUMBER (1) DEFAULT 0
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T56_PRODUCT_SUBSCRIPTION_DATA')
           AND column_name = UPPER ('T56_IS_AUTO_SUBCRIPTION');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.T56_PRODUCT_SUBSCRIPTION_DATA.T56_IS_AUTO_SUBCRIPTION IS '0=No,1=Yes'
/

ALTER TABLE dfn_ntp.T56_PRODUCT_SUBSCRIPTION_DATA
 ADD (
  t56_auto_renew_fail_count NUMBER (5),
  t56_next_auto_renew_date DATE,
  t56_cash_acc_id_u06 NUMBER (18)
 )
/


DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.T56_PRODUCT_SUBSCRIPTION_DATA
 ADD (
  T56_IS_SUBSCRIBED NUMBER (1) DEFAULT 0
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('T56_PRODUCT_SUBSCRIPTION_DATA')
           AND column_name = UPPER ('T56_IS_SUBSCRIBED');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.t56_product_subscription_data.t56_is_subscribed IS
    '1=Subscribed ,0=Unsubscribed'
/
