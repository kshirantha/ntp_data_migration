DECLARE
    l_count   NUMBER := 0;
    l_table   VARCHAR2 (50) := 'mapping_verification';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 1)
    THEN
        EXECUTE IMMEDIATE 'DROP TABLE ' || l_table;
    END IF;

    EXECUTE IMMEDIATE
           'CREATE TABLE '
        || l_table
        || ' (
    maping_table   VARCHAR2 (100 BYTE),
    source_count   NUMBER (10, 0),
    mapped_count    NUMBER (10, 0),
    unmapped_count    NUMBER (10, 0),
    wrongly_mapped_count  NUMBER (10, 0)
    )';
END;
/

-------------- MAP01_APPROVAL_STATUS_V01 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M64_APPROVAL_STATUS';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m64_approval_status@mubasher_db_link source,
           map01_approval_status_v01 mapped
     WHERE     source.m64_id = mapped.map01_oms_id
           AND UPPER (mapped.map01_description) =
                   UPPER (source.m64_approval_status);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m64_approval_status@mubasher_db_link source,
           map01_approval_status_v01 mapped
     WHERE     source.m64_id = mapped.map01_oms_id(+)
           AND mapped.map01_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM mubasher_oms.m64_approval_status@mubasher_db_link source,
           map01_approval_status_v01 mapped
     WHERE     source.m64_id = mapped.map01_oms_id
           AND UPPER (mapped.map01_description) <>
                   UPPER (source.m64_approval_status);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP01_APPROVAL_STATUS_V01',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

-------------- MAP02_AUDIT_ACTIVITY_M82 -------------------

DECLARE
    l_source_count        NUMBER;
    l_mapped_count        NUMBER;
    l_unmapped_count      NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M57_AUD_ACTIVITY';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m57_aud_activity@mubasher_db_link source,
           map02_audit_activity_m82 mapped
     WHERE     source.m57_id = mapped.map02_oms_id
           AND UPPER (mapped.map02_description) =
                   UPPER (source.m57_activity_name);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m57_aud_activity@mubasher_db_link source,
           map02_audit_activity_m82 mapped
     WHERE source.m57_id = mapped.map02_oms_id(+) AND mapped.map02_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM map02_audit_activity_m82 mapped,
           mubasher_oms.m57_aud_activity@mubasher_db_link source
     WHERE     mapped.map02_oms_id = source.m57_id
           AND UPPER (mapped.map02_description) <>
                   UPPER (source.m57_activity_name);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP02_AUDIT_ACTIVITY_M82',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

-------------- MAP03_APPROVAL_ENTITY_ID -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO l_source_count
      FROM mubasher_oms.m65_approval_entity@mubasher_db_link source
     WHERE source.m65_id NOT IN
               (2, -- U05_SECURITY_ACCOUNTS [Trading Account Audits Mapped]
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
                106, -- M288_DISCOUNT_SEGMENTS [Not Available]
                108, -- M300_IVR_PRIORITY_SEGMENTS [Not Available]
                113, -- M370_ASLGROUPS [Not Migrated - SFC Specific]
                114, -- C13_REPORT_TEMPLATES [Not Available]
                115, -- U16_INST_SHARIA_SYMBOLS [Not Available]
                135 -- M313_OMS_SERVERS_FOR_CUSTOMER [Not Available]
                   );

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM (SELECT m65_id
              FROM mubasher_oms.m65_approval_entity@mubasher_db_link source
             WHERE source.m65_id NOT IN
                       (2, -- U05_SECURITY_ACCOUNTS [Trading Account Audits Mapped]
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
                        106, -- M288_DISCOUNT_SEGMENTS [Not Available]
                        108, -- M300_IVR_PRIORITY_SEGMENTS [Not Available]
                        113, -- M370_ASLGROUPS [Not Migrated - SFC Specific]
                        114, -- C13_REPORT_TEMPLATES [Not Available]
                        115, -- U16_INST_SHARIA_SYMBOLS [Not Available]
                        135 -- M313_OMS_SERVERS_FOR_CUSTOMER [Not Available]
                           )) m65_old,
           (SELECT DISTINCT map03_oms_id FROM map03_approval_entity_id) map03
     WHERE m65_old.m65_id = map03.map03_oms_id;

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM (SELECT m65_id
              FROM mubasher_oms.m65_approval_entity@mubasher_db_link source
             WHERE source.m65_id NOT IN
                       (2, -- U05_SECURITY_ACCOUNTS [Trading Account Audits Mapped]
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
                        106, -- M288_DISCOUNT_SEGMENTS [Not Available]
                        108, -- M300_IVR_PRIORITY_SEGMENTS [Not Available]
                        113, -- M370_ASLGROUPS [Not Migrated - SFC Specific]
                        114, -- C13_REPORT_TEMPLATES [Not Available]
                        115, -- U16_INST_SHARIA_SYMBOLS [Not Available]
                        135 -- M313_OMS_SERVERS_FOR_CUSTOMER [Not Available]
                           )) m65_old,
           (SELECT DISTINCT map03_oms_id FROM map03_approval_entity_id) map03
     WHERE     m65_old.m65_id = map03.map03_oms_id(+)
           AND map03.map03_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM (SELECT DISTINCT map03_oms_id FROM map03_approval_entity_id) map03,
           (SELECT m65_id
              FROM mubasher_oms.m65_approval_entity@mubasher_db_link source
             WHERE source.m65_id NOT IN
                       (2, -- U05_SECURITY_ACCOUNTS [Trading Account Audits Mapped]
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
                        106, -- M288_DISCOUNT_SEGMENTS [Not Available]
                        108, -- M300_IVR_PRIORITY_SEGMENTS [Not Available]
                        113, -- M370_ASLGROUPS [Not Migrated - SFC Specific]
                        114, -- C13_REPORT_TEMPLATES [Not Available]
                        115, -- U16_INST_SHARIA_SYMBOLS [Not Available]
                        135 -- M313_OMS_SERVERS_FOR_CUSTOMER [Not Available]
                           )) m65_old
     WHERE map03.map03_oms_id = m65_old.m65_id(+) AND m65_old.m65_id IS NULL;

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP03_APPROVAL_ENTITY_ID',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

/*
-------------- MAP04_ENTITLEMENTS_V04 -------------------

DECLARE
    l_source_count        NUMBER;
    l_mapped_count        NUMBER;
    l_unmapped_count      NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M17_SYSTEM_TASKS';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m17_system_tasks@mubasher_db_link source,
           map04_entitlements_v04 mapped
     WHERE     source.m17_id = mapped.map04_oms_id
           AND UPPER (mapped.map04_description) = UPPER (source.m17_task_name);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m17_system_tasks@mubasher_db_link source,
           map04_entitlements_v04 mapped
     WHERE source.m17_id = mapped.map04_oms_id(+) AND mapped.map04_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM mubasher_oms.m17_system_tasks@mubasher_db_link source,
           map04_entitlements_v04 mapped
     WHERE     source.m17_id = mapped.map04_oms_id
           AND UPPER (mapped.map04_description) <> UPPER (source.m17_task_name);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_maped_cnt)
         VALUES ('MAP04_ENTITLEMENTS_V04',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/
*/

-------------- MAP05_EMPLOYEE_TYPE_M11 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M71_EMPLOYEE_SUBTYPE';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m71_employee_subtype@mubasher_db_link source,
           map05_employee_type_m11 mapped
     WHERE     source.m71_id = mapped.map05_oms_id
           AND UPPER (mapped.map05_name) = UPPER (source.m71_description);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m71_employee_subtype@mubasher_db_link source,
           map05_employee_type_m11 mapped
     WHERE     source.m71_id = mapped.map05_oms_id(+)
           AND mapped.map05_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM mubasher_oms.m71_employee_subtype@mubasher_db_link source,
           map05_employee_type_m11 mapped
     WHERE     source.m71_id = mapped.map05_oms_id
           AND UPPER (mapped.map05_name) <> UPPER (source.m71_description);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP05_EMPLOYEE_TYPE_M11',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

-------------- MAP06_COUNTRY_M05 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M30_COUNTRY';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m30_country@mubasher_db_link source,
           map06_country_m05 mapped
     WHERE     source.m30_country_id = mapped.map06_oms_id
           AND UPPER (mapped.map06_name) = UPPER (source.m30_country_name);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m30_country@mubasher_db_link source,
           map06_country_m05 mapped
     WHERE     source.m30_country_id = mapped.map06_oms_id(+)
           AND mapped.map06_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM mubasher_oms.m30_country@mubasher_db_link source,
           map06_country_m05 mapped
     WHERE     source.m30_country_id = mapped.map06_oms_id
           AND UPPER (mapped.map06_name) <> UPPER (source.m30_country_name);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP06_COUNTRY_M05',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

-------------- MAP07_CITY_M06 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M158_CITIES';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m158_cities@mubasher_db_link source,
           map07_city_m06 mapped
     WHERE     source.m158_id = mapped.map07_oms_id
           AND UPPER (mapped.map07_name) = UPPER (source.m158_description);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m158_cities@mubasher_db_link source,
           map07_city_m06 mapped
     WHERE     source.m158_id = mapped.map07_oms_id(+)
           AND mapped.map07_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM mubasher_oms.m158_cities@mubasher_db_link source,
           map07_city_m06 mapped
     WHERE     source.m158_id = mapped.map07_oms_id
           AND UPPER (mapped.map07_name) <> UPPER (source.m158_description);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP07_CITY_M06',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

-------------- MAP08_IDENTITY_TYPE_M15 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M242_IDENTITY_TYPES';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m242_identity_types@mubasher_db_link source,
           map08_identity_type_m15 mapped
     WHERE     source.m242_id = mapped.map08_oms_id
           AND UPPER (mapped.map08_name) = UPPER (source.m242_description);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m242_identity_types@mubasher_db_link source,
           map08_identity_type_m15 mapped
     WHERE     source.m242_id = mapped.map08_oms_id(+)
           AND mapped.map08_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM mubasher_oms.m242_identity_types@mubasher_db_link source,
           map08_identity_type_m15 mapped
     WHERE     source.m242_id = mapped.map08_oms_id
           AND UPPER (mapped.map08_name) <> UPPER (source.m242_description);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP08_IDENTITY_TYPE_M15',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

-------------- MAP09_UPLOADABLE_DOCUMENTS_M61 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'G04_UPLOADABLE_DOCUMENTS';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.g04_uploadable_documents@mubasher_db_link source,
           map09_uploadable_documents_m61 mapped
     WHERE     source.g04_id = mapped.map09_oms_id
           AND UPPER (mapped.map09_name) = UPPER (source.g04_name);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.g04_uploadable_documents@mubasher_db_link source,
           map09_uploadable_documents_m61 mapped
     WHERE     source.g04_id = mapped.map09_oms_id(+)
           AND mapped.map09_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM mubasher_oms.g04_uploadable_documents@mubasher_db_link source,
           map09_uploadable_documents_m61 mapped
     WHERE     source.g04_id = mapped.map09_oms_id
           AND UPPER (mapped.map09_name) <> UPPER (source.g04_name);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP09_UPLOADABLE_DOCUMENTS_M61',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

-------------- MAP10_MARITAL_STATUS_M128 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M149_MARITAL_STATUS';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m149_marital_status@mubasher_db_link source,
           map10_marital_status_m128 mapped
     WHERE     source.m149_id = mapped.map10_oms_id
           AND UPPER (mapped.map10_name) = UPPER (source.m149_description);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m149_marital_status@mubasher_db_link source,
           map10_marital_status_m128 mapped
     WHERE     source.m149_id = mapped.map10_oms_id(+)
           AND mapped.map10_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM mubasher_oms.m149_marital_status@mubasher_db_link source,
           map10_marital_status_m128 mapped
     WHERE     source.m149_id = mapped.map10_oms_id
           AND UPPER (mapped.map10_name) <> UPPER (source.m149_description);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP10_MARITAL_STATUS_M128',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

-------------- MAP11_TITLES_M130 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M130_TITLES';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m130_titles@mubasher_db_link source,
           map11_titles_m130 mapped
     WHERE     source.m130_id = mapped.map11_oms_id
           AND UPPER (mapped.map11_name) = UPPER (source.m130_description);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m130_titles@mubasher_db_link source,
           map11_titles_m130 mapped
     WHERE     source.m130_id = mapped.map11_oms_id(+)
           AND mapped.map11_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM mubasher_oms.m130_titles@mubasher_db_link source,
           map11_titles_m130 mapped
     WHERE     source.m130_id = mapped.map11_oms_id
           AND UPPER (mapped.map11_name) <> UPPER (source.m130_description);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP11_TITLES_M130',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

-------------- MAP12_NOTIFICATION_ITEMS_M99 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M139_NOTIFICATION_ITEMS';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m139_notification_items@mubasher_db_link source,
           map12_notification_items_m99 mapped
     WHERE     source.m139_id = mapped.map12_oms_id
           AND UPPER (mapped.map12_description) =
                   UPPER (source.m139_description);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m139_notification_items@mubasher_db_link source,
           map12_notification_items_m99 mapped
     WHERE     source.m139_id = mapped.map12_oms_id(+)
           AND mapped.map12_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM mubasher_oms.m139_notification_items@mubasher_db_link source,
           map12_notification_items_m99 mapped
     WHERE     source.m139_id = mapped.map12_oms_id
           AND UPPER (mapped.map12_description) <>
                   UPPER (source.m139_description);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP12_NOTIFICATION_ITEMS_M99',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

-------------- MAP13_NOTIFY_SUB_ITEMS_M100 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M143_NOTIFICATION_SUB_ITEMS';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m143_notification_sub_items@mubasher_db_link source,
           map13_notify_sub_items_m100 mapped
     WHERE     source.m143_id = mapped.map13_oms_id
           AND UPPER (mapped.map13_description) =
                   UPPER (source.m143_description);

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m143_notification_sub_items@mubasher_db_link source,
           map13_notify_sub_items_m100 mapped
     WHERE     source.m143_id = mapped.map13_oms_id(+)
           AND mapped.map13_oms_id IS NULL;

    SELECT COUNT (*)
      INTO l_wrongly_mapped_count
      FROM mubasher_oms.m143_notification_sub_items@mubasher_db_link source,
           map13_notify_sub_items_m100 mapped
     WHERE     source.m143_id = mapped.map13_oms_id
           AND UPPER (mapped.map13_description) <>
                   UPPER (source.m143_description);

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP13_NOTIFY_SUB_ITEMS_M100',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 l_wrongly_mapped_count);
END;
/

-------------- MAP14_NOTIFY_SUBITEM_SCHD_M103 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE     owner = 'MUBASHER_OMS'
           AND table_name = 'M145_NOTIFICATION_ITEM_CHANNEL';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m145_notification_item_channel@mubasher_db_link source,
           map14_notify_subitem_schd_m103 mapped
     WHERE source.m145_id = mapped.map14_oms_id;

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m145_notification_item_channel@mubasher_db_link source,
           map14_notify_subitem_schd_m103 mapped
     WHERE     source.m145_id = mapped.map14_oms_id(+)
           AND mapped.map14_oms_id IS NULL;

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP14_NOTIFY_SUBITEM_SCHD_M103',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 0);
END;
/

-------------- MAP15_TRANSACTION_CODES_M97 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M41_CHARGES';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m41_charges@mubasher_db_link source,
           map15_transaction_codes_m97 mapped
     WHERE source.m41_code = mapped.map15_oms_code;

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m41_charges@mubasher_db_link source,
           map15_transaction_codes_m97 mapped
     WHERE     source.m41_code = mapped.map15_oms_code(+)
           AND mapped.map15_oms_code IS NULL;

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP15_TRANSACTION_CODES_M97',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 0);
END;
/

-------------- MAP17_CUSTOMER_CATEGORY_V01_86 -------------------

DECLARE
    l_source_count           NUMBER;
    l_mapped_count           NUMBER;
    l_unmapped_count         NUMBER;
    l_wrongly_mapped_count   NUMBER;
BEGIN
    SELECT num_rows
      INTO l_source_count
      FROM all_tables@mubasher_db_link
     WHERE owner = 'MUBASHER_OMS' AND table_name = 'M51_COMMISSION_TYPE';

    SELECT COUNT (*)
      INTO l_mapped_count
      FROM mubasher_oms.m51_commission_type@mubasher_db_link source,
           map17_customer_category_v01_86 mapped
     WHERE source.m51_id = mapped.map17_oms_id;

    SELECT COUNT (*)
      INTO l_unmapped_count
      FROM mubasher_oms.m51_commission_type@mubasher_db_link source,
           map17_customer_category_v01_86 mapped
     WHERE     source.m51_id = mapped.map17_oms_id(+)
           AND mapped.map17_oms_id IS NULL;

    INSERT INTO mapping_verification (maping_table,
                                      source_count,
                                      mapped_count,
                                      unmapped_count,
                                      wrongly_mapped_count)
         VALUES ('MAP17_CUSTOMER_CATEGORY_V01_86',
                 l_source_count,
                 l_mapped_count,
                 l_unmapped_count,
                 0);
END;
/