DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.t60_exchange_subscription_log
(
    t60_id                           NUMBER (18, 0) NOT NULL,
    t60_customer_id_u01              NUMBER (18, 0),
    t60_customer_login_u09           NUMBER (18, 0),
    t60_cash_acc_id_u06              NUMBER (10, 0),
    t60_exchange_product_id_m153     NUMBER (10, 0),
    t60_subfee_waiveof_grp_id_m154   NUMBER (10, 0),
    t60_from_date                    DATE,
    t60_to_date                      DATE,
    t60_status                       NUMBER (2, 0),
    t60_no_of_months                 NUMBER (2, 0) DEFAULT 0,
    t60_exchange_fee                 NUMBER (18, 5) DEFAULT 0,
    t60_vat_exchange_fee             NUMBER (18, 5) DEFAULT 0,
    t60_reject_reason                VARCHAR2 (100),
    t60_datetime                     DATE DEFAULT SYSDATE,
    t60_exg_subscription_id_t57      NUMBER (18, 0),
    t60_institute_id_m02             NUMBER (3, 0)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (t60_datetime)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION t60_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_t60_to_date ON dfn_arc.t60_exchange_subscription_log (t60_datetime DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.t60_exchange_subscription_log TO dfn_ntp
/

GRANT INSERT ON dfn_arc.t60_exchange_subscription_log TO dfn_ntp
/

CREATE INDEX idx_arc_t60_customer_id_u01
    ON dfn_arc.t60_exchange_subscription_log (t60_customer_id_u01)
/

CREATE INDEX idx_arc_t60_customer_login_u09
    ON dfn_arc.t60_exchange_subscription_log (t60_customer_login_u09)
/

