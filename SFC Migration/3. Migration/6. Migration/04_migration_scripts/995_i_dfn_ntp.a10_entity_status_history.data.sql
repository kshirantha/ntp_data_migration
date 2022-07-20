DECLARE
    l_entity_status_history_id   NUMBER;
    l_sqlerrm                    VARCHAR2 (4000);

    l_rec_cnt                    NUMBER := 0;
BEGIN
    SELECT NVL (MAX (a10_id), 0)
      INTO l_entity_status_history_id
      FROM dfn_ntp.a10_entity_status_history;

    DELETE FROM error_log
          WHERE mig_table = 'Default - A10_ENTITY_STATUS_HISTORY';

    FOR i
        IN (SELECT audits.*, a10_map.new_ent_status_hist_id
              FROM (SELECT m66.m66_id,
                           map03.map03_ntp_id,
                           map03.map03_mapping_table,
                           CASE
                               WHEN m66.m66_entity_pk = '0'
                               THEN
                                   0
                               ELSE
                                   fn_get_new_entity (
                                       p_mapping_table   => map03.map03_mapping_table,
                                       p_old_column      => map03.map03_old_column,
                                       p_new_column      => map03.map03_new_column,
                                       p_old_entity      => REGEXP_REPLACE (
                                                               m66.m66_entity_pk,
                                                               'TDWL',
                                                               ''))
                           END
                               AS entity_pk,
                           map01.map01_ntp_id,
                           NVL (u17_map.new_employee_id, 0)
                               AS status_changed_by_new_id,
                           NVL (m66.m66_status_changed_date, SYSDATE)
                               AS status_changed_date
                      FROM mubasher_oms.m66_entity_status_history@mubasher_db_link m66,
                           map03_approval_entity_id map03,
                           map01_approval_status_v01 map01,
                           u17_employee_mappings u17_map
                     WHERE     m66.m66_approval_entity_id =
                                   map03.map03_oms_id
                           AND m66.m66_approval_status_id =
                                   map01.map01_oms_id
                           AND m66.m66_status_changed_by =
                                   u17_map.old_employee_id(+)
                           AND map03.map03_type = 0) audits,
                   a10_entity_status_his_mappings a10_map
             WHERE     audits.m66_id = a10_map.old_ent_status_hist_id(+)
                   AND audits.map03_mapping_table = a10_map.mapping_table(+)
                   AND audits.entity_pk = a10_map.entity_key(+))
    LOOP
        BEGIN
            IF i.entity_pk IS NULL
            THEN
                raise_application_error (-20001,
                                         'Entity Not Available',
                                         TRUE);
            END IF;

            IF i.new_ent_status_hist_id IS NULL
            THEN
                l_entity_status_history_id := l_entity_status_history_id + 1;

                INSERT
                  INTO dfn_ntp.a10_entity_status_history (
                           a10_id,
                           a10_approval_entity_id,
                           a10_entity_pk,
                           a10_approval_status_id_v01,
                           a10_status_changed_by_id_u17,
                           a10_status_changed_date)
                VALUES (l_entity_status_history_id, -- a10_id
                        i.map03_ntp_id, -- a10_approval_entity_id
                        i.entity_pk, -- a10_entity_pk
                        i.map01_ntp_id, -- a10_approval_status_id_v01
                        i.status_changed_by_new_id, -- a10_status_changed_by_id_u17
                        i.status_changed_date -- a10_status_changed_date
                                             );

                INSERT
                  INTO a10_entity_status_his_mappings (old_ent_status_hist_id,
                                                       mapping_table,
                                                       entity_key,
                                                       new_ent_status_hist_id)
                VALUES (i.m66_id,
                        i.map03_mapping_table,
                        i.entity_pk,
                        l_entity_status_history_id);
            ELSE
                UPDATE dfn_ntp.a10_entity_status_history
                   SET a10_approval_status_id_v01 = i.map01_ntp_id, -- a10_approval_status_id_v01
                       a10_status_changed_by_id_u17 =
                           i.status_changed_by_new_id -- a10_status_changed_by_id_u17
                 WHERE a10_id = i.new_ent_status_hist_id;
            END IF;

            l_rec_cnt := l_rec_cnt + 1;

            IF MOD (l_rec_cnt, 25000) = 0
            THEN
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                l_sqlerrm := SUBSTR (SQLERRM, 1, 512);

                INSERT INTO error_log
                     VALUES (
                                'Default - A10_ENTITY_STATUS_HISTORY',
                                i.m66_id,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        l_entity_status_history_id
                                    ELSE
                                        i.new_ent_status_hist_id
                                END,
                                l_sqlerrm,
                                CASE
                                    WHEN i.new_ent_status_hist_id IS NULL
                                    THEN
                                        'INSERT'
                                    ELSE
                                        'UPDATE'
                                END,
                                SYSDATE);
        END;
    END LOOP;
END;
/
/* Discarded Approval Entites

2, -- U05_SECURITY_ACCOUNTS [Trading Account Audits Mapped]
4, -- M18_SYSTEM_GROUPS_TASKS [Migration Keeps Concatenated Key]
10, -- M80_AGENT_COMMISSION_GROUPS [Not Available]
11, -- M81_AGENT_COMMISSION_STRUCTS [Not Available]
12, -- M83_CUSTOMER_REBATE_GROUPS [Not Available]
13, -- M82_CUSTOMER_REBATE_STRUCTS [Not Available]
17, -- T04_SYM_DAY_TRD_ENABLE, [Not Available]
18, -- U05_MARGIN_TRADING_ENABLE [Not Available]
19, -- U05_MARGIN_TRADING_AMOUNT [Not Available]
20, -- M101_BOOK_KEEPERS_COM_GROUPS [Not Available]
21, -- M102_BOOK_KEEPERS_COM_STRUCTS [Not Available]
23, -- M110_COMMISSION_GROUPS [Not Available]
24, -- M111_COMMISSION_STRUCTURES [Not Available]
25, -- M111_COMMISSION_SLAB [Not Available]
26, -- M123_COMMISSION_VALUES [Not Available]
27, -- M30_COUNTRY [Master Data]
30, -- M02_CURRENCY [Master Data]
34, -- M41_CHARGES [Master Data]
35, -- M87_COST_CENTERS [Not Available]
38, -- M75_INSTRUMENT_TYPES [Master Data]
39, -- M120_ASSET_MANAGEMENT_COMPANIE [Not Available]
40, -- M37_TRADING_MARKETS [Approval Histroy Not Migrated. Data Added via Post Migration]
42, -- M98_COMMODITIES [Not Available]
43, -- M112_COMMISSION_CATEGORY [Not Available]
44, -- M113_COMMISSION_TYPES [Not Available]
47, -- M71_EMPLOYEE_SUBTYPE [Not Available]
50, -- M132_POWER_OF_ATTERNY [Incorrect Audit Type]
51, -- M129_JOINT_ACCOUNTS [Not Available]
52, -- M130_TITLES [Master Data]
53, -- M133_NATIONALITY_CATEGORY [Not Used]
54, -- M135_TRANSACTION_CHANNELS [System Data]
56, -- M136_TRADING_CHANNELS [Not Required]
57, -- M138_CUSTOMER_SIGNATORY [Not Available]
59, -- A01_PRESS_RELEASES [Not Available]
60, -- M149_MARITAL_STATUS [Master Data]
69, -- M158_CITIES [Master Data]
70, -- M174_ORDER_ROUTE [Not Available]
75, -- M176_CHEQUE_COLL_LOCATIONS [Not Available]
76, -- EX04_EXEC_BROKER_USERS [Not Available]
78, -- EX05_EXE_INST_BANK_ACCOUNTS [Not Available]
81, -- T65_IB_CASH_ACCOUNT [Not Available]
84, -- M245_PHONE_IDENTIFICATION [Not Available]
87, -- M242_IDENTITY_TYPES [Master Data]
88, -- M277_PORTFOLIO_GROUP [Not Available]
91, -- T78_HOLDINGS_BLOCK [Not Available]
92, -- T77_FUND_RELEASE [Not Available]
93, -- T78_HOLDINGS_RELEASE [Not Available]
95, -- M272_CORPORATE_ACTION_CUSTOMERS [Incorrect Audit Type]
96, -- M276_NON_MARGIN_INTEREST [Not Migrated - SFC Specific]
99, -- M247_RISK_CLASSIFICATION [Not Available]
100, -- M164_CUST_CHARGE_DISCOUNTS [Needs to Implement Once New Changes are Ready]
101, -- M10_EXCHANGE_COMMISSION [Approval Histroy Not Migrated. Data Added via Post Migration]
102, -- U16_PRICE_SUSPENDED_SYMBOLS [Not Available]
104, -- T85_SUBSCRIPTION_DOWN_REQUESTS [Not Available]
105, -- M200_EGYPT_COMM_STRUCTS [Not Available]
106, -- M288_DISCOUNT_SEGMENTS [Not Available]]
108, -- M300_IVR_PRIORITY_SEGMENTS [Not Available]
113, -- M370_ASLGROUPS [Not Migrated - SFC Specific]
114, -- C13_REPORT_TEMPLATES [Not Available]
115, -- U16_INST_SHARIA_SYMBOLS [Not Available]
135 -- M313_OMS_SERVERS_FOR_CUSTOMER [Not Available]
*/