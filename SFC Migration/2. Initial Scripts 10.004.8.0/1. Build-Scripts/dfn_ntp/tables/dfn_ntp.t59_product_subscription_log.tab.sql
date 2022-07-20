CREATE TABLE dfn_ntp.t59_product_subscription_log
(
    t59_id                           NUMBER (18, 0) NOT NULL,
    t59_customer_id_u01              NUMBER (18, 0),
    t59_customer_login_u09           NUMBER (18, 0),
    t59_cash_acc_id_u06              NUMBER (10, 0),
    t59_product_id_m152              NUMBER (5, 0),
    t59_subfee_waiveof_grp_id_m154   NUMBER (10, 0),
    t59_from_date                    DATE,
    t59_to_date                      DATE,
    t59_status                       NUMBER (2, 0),
    t59_no_of_months                 NUMBER (2, 0) DEFAULT 0,
    t59_service_fee                  NUMBER (18, 5) DEFAULT 0,
    t59_broker_fee                   NUMBER (18, 5) DEFAULT 0,
    t59_vat_service_fee              NUMBER (18, 5) DEFAULT 0,
    t59_vat_broker_fee               NUMBER (18, 5) DEFAULT 0,
    t59_reject_reason                VARCHAR2 (100 BYTE),
    t59_datetime                     DATE DEFAULT SYSDATE
)
/



ALTER TABLE dfn_ntp.t59_product_subscription_log
    ADD CONSTRAINT t59_pk PRIMARY KEY (t59_id) USING INDEX
/

COMMENT ON COLUMN dfn_ntp.t59_product_subscription_log.t59_status IS
    '0 - Suspend | 1 - Approved | 2 - Downgraded | 3 - rejected'
/

ALTER TABLE dfn_ntp.t59_product_subscription_log 
 ADD (
  t59_institute_id_m02 NUMBER (3, 0)
 )
/

ALTER TABLE dfn_ntp.t59_product_subscription_log 
 ADD (
  t59_prod_subscription_id_t56 NUMBER (18, 0)
 )
/

CREATE INDEX dfn_ntp.idx_t59_to_date
    ON dfn_ntp.t59_product_subscription_log (t59_to_date DESC)
/

CREATE INDEX dfn_ntp.idx_t59_datetime
    ON dfn_ntp.t59_product_subscription_log (t59_datetime DESC)
/


ALTER TABLE dfn_ntp.t59_product_subscription_log
 ADD (
  t59_service_fee_waiveof_amnt NUMBER (18, 5),
  t59_broker_fee_waiveof_amnt NUMBER (18, 5)
 )
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T59_PRODUCT_SUBSCRIPTION_LOG 
 ADD (
  T59_EXCHANGE_FEE_WAIVEOF_AMNT NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T59_PRODUCT_SUBSCRIPTION_LOG')
           AND column_name = UPPER ('T59_EXCHANGE_FEE_WAIVEOF_AMNT');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T59_PRODUCT_SUBSCRIPTION_LOG 
 ADD (
  T59_OTHER_FEE_WAIVEOF_AMNT NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T59_PRODUCT_SUBSCRIPTION_LOG')
           AND column_name = UPPER ('T59_OTHER_FEE_WAIVEOF_AMNT');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T59_PRODUCT_SUBSCRIPTION_LOG 
 ADD (
  T59_EXCHANGE_FEE NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T59_PRODUCT_SUBSCRIPTION_LOG')
           AND column_name = UPPER ('T59_EXCHANGE_FEE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T59_PRODUCT_SUBSCRIPTION_LOG 
 ADD (
  T59_VAT_EXCHANGE_FEE NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T59_PRODUCT_SUBSCRIPTION_LOG')
           AND column_name = UPPER ('T59_VAT_EXCHANGE_FEE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T59_PRODUCT_SUBSCRIPTION_LOG 
 ADD (
  T59_OTHER_FEE NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T59_PRODUCT_SUBSCRIPTION_LOG')
           AND column_name = UPPER ('T59_OTHER_FEE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/
DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T59_PRODUCT_SUBSCRIPTION_LOG 
 ADD (
  T59_VAT_OTHER_FEE NUMBER (18, 5)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T59_PRODUCT_SUBSCRIPTION_LOG')
           AND column_name = UPPER ('T59_VAT_OTHER_FEE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.T59_PRODUCT_SUBSCRIPTION_LOG 
 ADD (
 T59_SUB_AGREEMENT_TYPE NUMBER (1)
)';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('T59_PRODUCT_SUBSCRIPTION_LOG')
           AND column_name = UPPER ('T59_SUB_AGREEMENT_TYPE');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.t59_product_subscription_log.t59_sub_agreement_type IS
    '0=Private,1=Business'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.t59_product_subscription_log
 ADD (
  t59_is_auto_subcription NUMBER (1) DEFAULT 0
 )';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('t59_product_subscription_log')
           AND column_name = UPPER ('t59_is_auto_subcription');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.t59_product_subscription_log.t59_is_auto_subcription IS
    '0=No,1=Yes'
/

