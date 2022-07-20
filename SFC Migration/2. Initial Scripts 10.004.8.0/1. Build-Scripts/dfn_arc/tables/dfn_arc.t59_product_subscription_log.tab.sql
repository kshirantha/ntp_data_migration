DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.t59_product_subscription_log
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
    t59_reject_reason                VARCHAR2 (100),
    t59_datetime                     DATE DEFAULT SYSDATE,
    t59_prod_subscription_id_t56     NUMBER (18, 0),
    t59_institute_id_m02             NUMBER (3, 0)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (t59_datetime)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION t59_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_t59_to_date ON dfn_arc.t59_product_subscription_log (t59_datetime DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.t59_product_subscription_log TO dfn_ntp
/

GRANT INSERT ON dfn_arc.t59_product_subscription_log TO dfn_ntp
/

CREATE INDEX idx_arc_t59_customer_id_u01
    ON dfn_arc.t59_product_subscription_log (t59_customer_id_u01)
/

CREATE INDEX idx_arc_t59_customer_login_u09
    ON dfn_arc.t59_product_subscription_log (t59_customer_login_u09)
/

