CREATE TABLE dfn_ntp.m1001_sukuk_coupon_payment
(
    m1001_id                         NUMBER (18, 0),
    m1001_cash_acc_id_u06            NUMBER (18, 0),
    m1001_principal                  NUMBER (21, 5),
    m1001_rate                       NUMBER (21, 8),
    m1001_days_per_year              NUMBER (5, 0),
    m1001_period_days                NUMBER (5, 0),
    m1001_is_manual                  NUMBER (1, 0),
    m1001_total_coupon               NUMBER (18, 5),
    m1001_created_by_id_u17          NUMBER (10, 0),
    m1001_created_date               DATE,
    m1001_modified_by_id_u17         NUMBER (10, 0),
    m1001_modified_date              DATE,
    m1001_status_id_v01              NUMBER (1, 0),
    m1001_status_changed_by_id_u17   NUMBER (10, 0),
    m1001_status_changed_date        DATE
)
/

ALTER TABLE dfn_ntp.m1001_sukuk_coupon_payment
ADD CONSTRAINT pk_m1001 PRIMARY KEY (m1001_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.m1001_sukuk_coupon_payment.m1001_is_manual IS
    '0 - No | 1 - Yes'
/

ALTER TABLE dfn_ntp.m1001_sukuk_coupon_payment
 MODIFY (
  m1001_status_id_v01 NUMBER (5, 0)
 )
/

DECLARE
l_count NUMBER := 0; l_ddl VARCHAR2(1000) := 'ALTER TABLE dfn_ntp.m1001_sukuk_coupon_payment    ADD (        m1001_custom_type VARCHAR2 (50 BYTE) DEFAULT 1    )';
BEGIN
SELECT COUNT(*)
INTO l_count
FROM all_tab_columns
WHERE owner = UPPER('dfn_ntp')
  AND table_name = UPPER('m1001_sukuk_coupon_payment')
  AND column_name = UPPER('m1001_custom_type');
IF l_count = 0 THEN EXECUTE IMMEDIATE l_ddl; END IF;
END;
/