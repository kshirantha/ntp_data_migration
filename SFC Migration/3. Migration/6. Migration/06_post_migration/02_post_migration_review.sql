-- Not Migrated and Manually Created [Considering TDWL Exchange Only]

DECLARE
    l_broker_id                NUMBER;
    l_primary_institute_id     NUMBER;
    l_default_exg_id           NUMBER;
    l_default_main_market_id   NUMBER;
    l_default_u_market_id      NUMBER;
    l_default_broker_id        NUMBER;
    l_count                    NUMBER := 0;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT m01.m01_id
      INTO l_default_exg_id
      FROM dfn_ntp.m01_exchanges m01
     WHERE     m01.m01_institute_id_m02 = l_primary_institute_id
           AND m01.m01_exchange_code = 'TDWL';

    SELECT m29.m29_id
      INTO l_default_main_market_id
      FROM dfn_ntp.m29_markets m29
     WHERE     m29.m29_primary_institution_id_m02 = l_primary_institute_id
           AND m29.m29_exchange_code_m01 = 'TDWL'
           AND m29.m29_market_code = 'SAEQ';

    SELECT m29.m29_id
      INTO l_default_u_market_id
      FROM dfn_ntp.m29_markets m29
     WHERE     m29.m29_primary_institution_id_m02 = l_primary_institute_id
           AND m29.m29_exchange_code_m01 = 'TDWL'
           AND m29.m29_market_code = 'SAEQ_U';

    SELECT m43.m43_executing_broker_id_m26
      INTO l_default_broker_id
      FROM dfn_ntp.m43_institute_exchanges m43
     WHERE     m43.m43_exchange_code_m01 = 'TDWL'
           AND m43.m43_institute_id_m02 = l_primary_institute_id;

    l_count := 0;

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m19_routing_data m19
     WHERE     m19.m19_primary_institute_id_m02 = l_primary_institute_id
           AND m19.m19_default_exchange_id_m01 = l_default_exg_id
           AND m19.m19_connection_alias = 'TDWL';

    IF l_count = 0
    THEN
        INSERT INTO dfn_ntp.m19_routing_data
             VALUES (1,
                     1,
                     '023',
                     'XSAU',
                     '0230004',
                     'TDWL',
                     NULL,
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     '1',
                     l_primary_institute_id,
                     'TDWL',
                     l_default_exg_id,
                     3,
                     1);
    END IF;

    l_count := 0;

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m19_routing_data m19
     WHERE     m19.m19_primary_institute_id_m02 = l_primary_institute_id
           AND m19.m19_default_exchange_id_m01 = l_default_exg_id
           AND m19.m19_connection_alias = 'TDWL2';

    IF l_count = 0
    THEN
        INSERT INTO dfn_ntp.m19_routing_data
             VALUES (2,
                     1,
                     '023',
                     '998',
                     'M023',
                     'TDWL2',
                     NULL,
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     '1',
                     l_primary_institute_id,
                     'TDWL',
                     l_default_exg_id,
                     3,
                     1);
    END IF;

    l_count := 0;

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m31_exec_broker_routing m31
     WHERE     m31.m31_institute_id = l_primary_institute_id
           AND m31.m31_routing_data_id_m19 = 1
           AND m31.m31_exchange_id_m01 = l_default_exg_id
           AND m31.m31_exec_broker_id_m26 = l_default_broker_id
           AND m31.m31_type = 1
           AND m31.m31_market_id_m29 = l_default_main_market_id;

    IF l_count = 0
    THEN
        INSERT INTO dfn_ntp.m31_exec_broker_routing
             VALUES ('TDWL',
                     1,
                     1,
                     NULL, -- '0230004 DFN Environment Value
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     '005', --'023' DFN Environment Value
                     'XSAU',
                     l_default_exg_id,
                     l_default_broker_id,
                     'SAEQ',
                     1,
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     NULL,
                     l_primary_institute_id,
                     1,
                     '1',
                     l_default_main_market_id,
                     'SAEQ',
                     0);
    END IF;

    l_count := 0;

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m31_exec_broker_routing m31
     WHERE     m31.m31_institute_id = l_primary_institute_id
           AND m31.m31_routing_data_id_m19 = 2
           AND m31.m31_exchange_id_m01 = l_default_exg_id
           AND m31.m31_exec_broker_id_m26 = l_default_broker_id
           AND m31.m31_type = 2
           AND m31.m31_market_id_m29 = l_default_u_market_id;

    IF l_count = 0
    THEN
        INSERT INTO dfn_ntp.m31_exec_broker_routing
             VALUES ('TDWL',
                     2,
                     2,
                     NULL, -- M023 DFN Environment Value
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     '005', -- '023' DFN Environment Value
                     '998',
                     l_default_exg_id,
                     l_default_broker_id,
                     'SAEQ_U',
                     1,
                     0,
                     SYSDATE,
                     NULL,
                     NULL,
                     2,
                     0,
                     SYSDATE,
                     NULL,
                     l_primary_institute_id,
                     2,
                     '1',
                     l_default_u_market_id,
                     'SAEQ_U',
                     0);
    END IF;
END;
/

COMMIT;

-- Exchange Requirement

UPDATE dfn_ntp.m29_markets
   SET m29_preopen_allowed = 1
 WHERE m29_market_code = 'SAEQ';

COMMIT;

-- Check and Update Correct Default Master Data

BEGIN
    FOR i
        IN (SELECT m07.m07_id, m02_map.new_institute_id
              FROM dfn_ntp.m07_location m07, m02_institute_mappings m02_map
             WHERE     m07.m07_institute_id_m02 = m02_map.new_institute_id
                   AND UPPER (m07.m07_name) LIKE '%RIYADH%')
    LOOP
        UPDATE dfn_ntp.v20_default_master_data v20
           SET v20.v20_value = i.m07_id
         WHERE     v20.v20_tag = 'location'
               AND v20.v20_institute_id_m02 = i.new_institute_id;
    END LOOP;

    FOR i
        IN (SELECT m12.m12_id, m02_map.new_institute_id
              FROM dfn_ntp.m12_employee_department m12,
                   m02_institute_mappings m02_map
             WHERE     m12.m12_institute_id_m02 = m02_map.new_institute_id
                   AND UPPER (m12.m12_name) LIKE '%BACK OFFICE%')
    LOOP
        UPDATE dfn_ntp.v20_default_master_data v20
           SET v20.v20_value = i.m12_id
         WHERE     v20.v20_tag = 'employeeDepartment'
               AND v20.v20_institute_id_m02 = i.new_institute_id;
    END LOOP;

    FOR i
        IN (SELECT m35.m35_id, m02_map.new_institute_id
              FROM dfn_ntp.m35_customer_settl_group m35,
                   m02_institute_mappings m02_map
             WHERE m35.m35_institute_id_m02 = m02_map.new_institute_id -- One Customer Settle Group for Each Institution
                                                                      )
    LOOP
        UPDATE dfn_ntp.v20_default_master_data v20
           SET v20.v20_value = i.m35_id
         WHERE     v20.v20_tag = 'settleCategory'
               AND v20.v20_institute_id_m02 = i.new_institute_id;
    END LOOP;

    FOR i IN (SELECT m02_map.new_institute_id
                FROM m02_institute_mappings m02_map)
    LOOP
        UPDATE dfn_ntp.v20_default_master_data v20
           SET v20.v20_value = 0 -- 0 : None
         WHERE     v20.v20_tag = 'custodianType'
               AND v20.v20_institute_id_m02 = i.new_institute_id;
    END LOOP;

    FOR i IN (SELECT m01.m01_id, m01.m01_institute_id_m02
                FROM dfn_ntp.m01_exchanges m01
               WHERE m01.m01_exchange_code = 'TDWL')
    LOOP
        UPDATE dfn_ntp.v20_default_master_data v20
           SET v20.v20_value = i.m01_id
         WHERE     v20.v20_primary_institute_id_m02 = i.m01_institute_id_m02
               AND v20.v20_tag = 'exchange';
    END LOOP;

    FOR i
        IN (SELECT m105.m105_id, m02_map.new_institute_id
              FROM dfn_ntp.m105_other_brokerages m105,
                   m02_institute_mappings m02_map,
                   dfn_ntp.m01_exchanges m01
             WHERE     m105.m105_institute_id_m02 = m02_map.new_institute_id
                   AND m105.m105_exchange_id_m01 = m01.m01_id
                   AND m01.m01_exchange_code = 'TDWL'
                   AND m105.m105_broker_name = 'SFC')
    LOOP
        UPDATE dfn_ntp.v20_default_master_data v20
           SET v20.v20_value = i.m105_id
         WHERE     v20.v20_tag = 'exchangeBrokers'
               AND v20.v20_institute_id_m02 = i.new_institute_id;
    END LOOP;

    FOR i
        IN (SELECT m73.m73_id, m02_map.new_institute_id
              FROM dfn_ntp.m73_margin_products m73,
                   m02_institute_mappings m02_map
             WHERE     m73.m73_institution_m02_id = m02_map.new_institute_id
                   AND m73.m73_margin_category_id_v01 = 1002 -- SFC Margin
                   AND m73.m73_margin_product_eq_id_v36 = 1002 -- Equation 1
                   AND UPPER (m73_name) LIKE '%CONVENTIONAL MARGIN%')
    LOOP
        UPDATE dfn_ntp.v20_default_master_data v20
           SET v20.v20_value = i.m73_id
         WHERE     v20.v20_tag = 'marginProduct'
               AND v20.v20_institute_id_m02 = i.new_institute_id;
    END LOOP;

    FOR i
        IN (SELECT m43.m43_custodian_id_m26, m02_map.new_institute_id
              FROM dfn_ntp.m43_institute_exchanges m43,
                   m02_institute_mappings m02_map
             WHERE     m43.m43_institute_id_m02 = m02_map.new_institute_id
                   AND m43.m43_exchange_code_m01 = 'TDWL')
    LOOP
        UPDATE dfn_ntp.v20_default_master_data v20
           SET v20.v20_value = i.m43_custodian_id_m26
         WHERE     v20.v20_tag = 'defaultCustodian'
               AND v20.v20_institute_id_m02 = i.new_institute_id;
    END LOOP;
END;
/

COMMIT;

BEGIN
    -- Adding 100 Years for Password Expiry Date for All Users [Discussed Solution]

    UPDATE dfn_ntp.u17_employee u17
       SET u17.u17_pw_expire_date =
               NVL (u17.u17_pw_expire_date, SYSDATE) + 365 * 100;

    -- Adding 100 Days for Password Expiry Date for Customers [Onsite]

    UPDATE dfn_ntp.u09_customer_login u09
       SET u09.u09_password_expiry_date = SYSDATE + 100;
END;
/

COMMIT;

-- Institue Default Values

DECLARE
    l_institute_default_id   NUMBER;
    l_count                  NUMBER := 0;
BEGIN
    SELECT NVL (MAX (m180_id), 0)
      INTO l_institute_default_id
      FROM dfn_ntp.m180_institute_default_values;

    FOR i IN (SELECT m02_map.new_institute_id
                FROM m02_institute_mappings m02_map)
    LOOP
        SELECT COUNT (*)
          INTO l_count
          FROM dfn_ntp.m180_institute_default_values m180
         WHERE m180.m180_institution_id_m02 = i.new_institute_id;

        IF l_count = 0
        THEN
            l_institute_default_id := l_institute_default_id + 1;

            INSERT
              INTO dfn_ntp.m180_institute_default_values (
                       m180_id,
                       m180_institution_id_m02,
                       m180_initial_margin,
                       m180_mrg_call_notify_lvl,
                       m180_mrg_call_remind_lvl,
                       m180_mrg_call_liquid_lvl,
                       m180_symbol_marginable_pct,
                       m180_last_updated_date,
                       m180_last_updated_by_id_u17,
                       m180_custom_type)
            VALUES (l_institute_default_id, -- m180_id
                    i.new_institute_id, -- m180_institution_id_m02
                    200, -- m180_initial_margin
                    0, -- m180_mrg_call_notify_lvl
                    0, -- m180_mrg_call_remind_lvl
                    0, -- m180_mrg_call_liquid_lvl
                    0, -- m180_symbol_marginable_pct
                    SYSDATE, -- m180_last_updated_date
                    0, -- m180_last_updated_by_id_u17
                    '1' -- m180_custom_type
                       );
        END IF;
    END LOOP;

    COMMIT;

    MERGE INTO dfn_ntp.m180_institute_default_values m180
         USING (SELECT new_institute_id,
                       m05_mt_portfolio_margin_factor, -- Initial Margin
                       m05_mt_margin_call_notify_leve, -- Notify Level
                       m05_mt_margin_call_remind_leve, -- Remind Level
                       m05_mt_margin_call_liquid_leve, -- Liquid Level,
                       m05_sm_marginable -- marginable Percentage
                  FROM mubasher_oms.m05_branches@mubasher_db_link m05,
                       m02_institute_mappings m02_map
                 WHERE     m05_branch_code = 'SFC'
                       AND m05.m05_branch_id = m02_map.old_institute_id) m05
            ON (m180.m180_institution_id_m02 = m05.new_institute_id)
    WHEN MATCHED
    THEN
        UPDATE SET
            m180.m180_initial_margin = m05.m05_mt_portfolio_margin_factor,
            m180.m180_mrg_call_notify_lvl = m05.m05_mt_margin_call_notify_leve,
            m180.m180_mrg_call_remind_lvl = m05.m05_mt_margin_call_remind_leve,
            m180.m180_mrg_call_liquid_lvl = m05.m05_mt_margin_call_liquid_leve,
            m180.m180_symbol_marginable_pct = m05.m05_sm_marginable;

    COMMIT;
END;
/

COMMIT;

-- Adding Default RM Incentive Group Since No Data for SFC Production or UAT

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
    l_count                  NUMBER := 0;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    SELECT COUNT (*)
      INTO l_count
      FROM dfn_ntp.m162_incentive_group m162
     WHERE m162.m162_institute_id_m02 = l_primary_institute_id;

    IF l_count = 0
    THEN
        INSERT
          INTO dfn_ntp.m162_incentive_group (m162_id,
                                             m162_description,
                                             m162_institute_id_m02,
                                             m162_is_default,
                                             m162_created_by_id_u17,
                                             m162_created_date,
                                             m162_modified_by_id_u17,
                                             m162_modified_date,
                                             m162_status_id_v01,
                                             m162_status_changed_by_id_u17,
                                             m162_status_changed_date,
                                             m162_custom_type,
                                             m162_additional_details,
                                             m162_group_type_id_v01,
                                             m162_frequency_id_v01,
                                             m162_commission_type_id_v01)
        VALUES (1,
                'DEFAULT RM Incentive Group',
                l_primary_institute_id,
                1,
                0,
                SYSDATE,
                NULL,
                NULL,
                2,
                0,
                SYSDATE,
                '1',
                'DEFAULT RM Incentive Group',
                1, -- 1 : RM
                2, -- 2 : Daily
                1 -- 1 : TCtal Commission
                 );
    END IF;
END;
/

COMMIT;

-- This is Used for Integration with SFC. [Safras/Janaka]

UPDATE dfn_ntp.m08_trading_group
   SET m08_external_ref = 999
 WHERE m08_name = 'Normal - INTL';
 
UPDATE dfn_ntp.m08_trading_group
   SET m08_external_ref = 998
 WHERE m08_name = 'Normal';

COMMIT;