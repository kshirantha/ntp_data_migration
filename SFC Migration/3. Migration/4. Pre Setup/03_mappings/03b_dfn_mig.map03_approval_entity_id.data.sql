DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*) INTO l_count FROM map03_approval_entity_id;

    IF l_count = 0
    THEN
        INSERT INTO map03_approval_entity_id
             VALUES (1,
                     1006,
                     'CUSTOMER_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT_MAPPINGS',
                     'OLD_CASH_ACCOUNT_ID',
                     'NEW_CASH_ACCOUNT_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (3,
                     1007,
                     'CUSTOMER_TRADING_ACCOUNT',
                     'CUSTOMER_TRADING_ACCOUNT',
                     NULL,
                     NULL,
                     2);

        INSERT INTO map03_approval_entity_id
             VALUES (5,
                     1017,
                     'EMPLOYEE',
                     'U17_EMPLOYEE_MAPPINGS',
                     'OLD_EMPLOYEE_ID',
                     'NEW_EMPLOYEE_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (6,
                     47,
                     'PERMISSION_GRP_USERS',
                     'M47_PERMISN_GRP_USERS_MAPPINGS',
                     'OLD_PERMISN_GRP_USERS_ID',
                     'NEW_PERMISN_GRP_USERS_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (7,
                     22,
                     'COMMISSION_GROUP',
                     'M22_COMM_GRP_MAPPINGS',
                     'OLD_COMM_GRP_ID',
                     'NEW_COMM_GRP_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (8,
                     23,
                     'COMMISSION_STRUCTURES',
                     'M23_COMM_SLABS_MAPPINGS',
                     'OLD_COMM_SLAB_ID',
                     'NEW_COMM_SLAB_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (9,
                     1001,
                     'CUSTOMER',
                     'U01_CUSTOMER_MAPPINGS',
                     'OLD_CUSTOMER_ID',
                     'NEW_CUSTOMER_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (14,
                     74,
                     'MARGIN_INTEREST_GROUP',
                     'M74_MARGIN_INT_GROUP_MAPPINGS',
                     'OLD_MARGIN_INT_GROUP_ID',
                     'NEW_MARGIN_INT_GROUP_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (15,
                     78,
                     'SYMBOL_MARGINABILITY',
                     'M78_SYM_MARGINABILITY_MAPPINGS',
                     'OLD_SYM_MARGINABILITY_ID',
                     'NEW_SYM_MARGINABILITY_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (16,
                     73,
                     'MARGIN_INTEREST_GROUP',
                     'M74_MARGIN_INT_GROUP_MAPPINGS',
                     'OLD_MARGIN_INT_GROUP_ID',
                     'NEW_MARGIN_INT_GROUP_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (28,
                     16,
                     'BANK',
                     'M16_BANK_MAPPINGS',
                     'OLD_BANK_ID',
                     'NEW_BANK_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (29,
                     7,
                     'LOCATION',
                     'M07_LOCATION_MAPPINGS',
                     'OLD_LOCATION_ID',
                     'NEW_LOCATION_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (31,
                     12,
                     'EMPLOYEE_DEPARTMENT',
                     'M12_EMP_DEP_MAPPINGS',
                     'OLD_EMP_DEP_ID',
                     'NEW_EMP_DEP_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (32,
                     8,
                     'TRADING_GROUPS',
                     '(SELECT * FROM M08_TRD_GROUP_MAPPINGS WHERE IS_LOCAL_EXCHANGE = 0)',
                     'OLD_TRD_GROUP_ID',
                     'NEW_TRD_GROUP_ID',
                     0);
					 
		INSERT INTO map03_approval_entity_id
             VALUES (32,
                     8,
                     'TRADING_GROUPS',
                     '(SELECT * FROM M08_TRD_GROUP_MAPPINGS WHERE IS_LOCAL_EXCHANGE = 1)',
                     'OLD_TRD_GROUP_ID',
                     'NEW_TRD_GROUP_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (33,
                     63,
                     'SECTOR',
                     'SECTOR',
                     NULL,
                     NULL,
                     2);

        INSERT INTO map03_approval_entity_id
             VALUES (36,
                     1,
                     'EXCHANGE',
                     'EXCHANGE',
                     NULL,
                     NULL,
                     2);

        INSERT INTO map03_approval_entity_id
             VALUES (37,
                     135,
                     'GL_ACOUNTS',
                     'M135_GL_ACCOUNTS_MAPPINGS',
                     'OLD_GL_ACCOUNTS_ID',
                     'NEW_GL_ACCOUNTS_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (41,
                     20,
                     'SYMBOL',
                     'M20_SYMBOL_MAPPINGS',
                     'OLD_SYMBOL_ID',
                     'NEW_SYMBOL_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (45,
                     28,
                     'CUSTOMER_GRADE_DATA',
                     'M28_CUST_GRADE_DATA_MAPPINGS',
                     'OLD_CUST_GRADE_DATA_ID',
                     'NEW_CUST_GRADE_DATA_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (46,
                     1008,
                     'CUSTOMER_BENEFICIARY_ACC',
                     'U08_CUST_BENEFCRY_ACC_MAPPINGS',
                     'OLD_CUST_BENEFCRY_ACC_ID',
                     'NEW_CUST_BENEFCRY_ACC_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (48,
                     93,
                     'BROKERAGE_BANK_ACCOUNT',
                     'M93_BANK_ACCOUNTS_MAPPINGS',
                     'OLD_BANK_ACCOUNTS_ID',
                     'NEW_BANK_ACCOUNTS_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (49,
                     105,
                     'OTHER_BROKERAGES',
                     'M105_OTHER_BROKERAGES_MAPPINGS',
                     'OLD_OTHER_BROKERAGES_ID',
                     'NEW_OTHER_BROKERAGES_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (55,
                     1047,
                     'CUSTOMER_POWER_OF_ATTORNEY',
                     'CUSTOMER_POWER_OF_ATTORNEY',
                     NULL,
                     NULL,
                     2);

        INSERT INTO map03_approval_entity_id
             VALUES (58,
                     14,
                     'ID_ISSUE_LOCATIONS',
                     'M14_ISSUE_LOCATION_MAPPINGS',
                     'OLD_ISSUE_LOCATION_ID',
                     'NEW_ISSUE_LOCATION_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (61,
                     1029,
                     'EMP_NOTIFICATION_GROUPS',
                     'U29_EMP_NOTIFI_GROUPS_MAPPINGS',
                     'OLD_EMP_NOTIFI_GROUPS_ID',
                     'NEW_EMP_NOTIFI_GROUPS_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (62,
                     52,
                     'NOTIFICATION_GROUP',
                     'M52_NOTIFICATION_GRP_MAPPINGS',
                     'OLD_NOTIFICATION_GRP_ID',
                     'NEW_NOTIFICATION_GRP_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (63,
                     45,
                     'USER_GROUPS',
                     'M45_PERMISSION_GROUPS_MAPPINGS',
                     'OLD_PERMISSION_GROUPS_ID',
                     'NEW_PERMISSION_GROUPS_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (65,
                     72,
                     'EXEC_BROKER_CASH_ACCOUNT',
                     'M72_EXEC_BRK_CASH_ACC_MAPPINGS',
                     'OLD_EXEC_BRK_CASH_ACC_ID',
                     'NEW_EXEC_BRK_CASH_ACC_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (66,
                     26,
                     'EXECUTING_BROKER',
                     'M26_EXECUTING_BROKER_MAPPINGS',
                     'OLD_EXECUTING_BROKER_ID',
                     'NEW_EXECUTING_BROKER_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (68,
                     9,
                     'COMPANIES',
                     'M09_COMPANIES_MAPPINGS',
                     'OLD_COMPANIES_ID',
                     'NEW_COMPANIES_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (77,
                     78,
                     'SYMBOL_MARGINABILITY',
                     'M78_SYM_MARGINABILITY_MAPPINGS',
                     'OLD_SYM_MARGINABILITY_ID',
                     'NEW_SYM_MARGINABILITY_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (80,
                     21,
                     'INTRODUCING_BROKER',
                     'M21_INTRODUCING_BRK_MAPPINGS',
                     'OLD_INTRODUCING_BRK_ID',
                     'NEW_INTRODUCING_BRK_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (82,
                     153,
                     'EXCHANGE_SUBSCRIPTION_PRODUCTS',
                     'M153_EXG_SUBS_PRD_MAPPINGS',
                     'OLD_EXG_SUBS_PRD_ID',
                     'NEW_EXG_SUBS_PRD_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (82,
                     152,
                     'SUBSCRIPTION_PRODUCTS',
                     'M152_PRODUCTS_MAPPINGS',
                     'OLD_PRODUCT_ID',
                     'NEW_PRODUCT_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (83,
                     155,
                     'PRODUCT_WAIVEOFF_DETAILS',
                     'M155_PRD_WAIVEOFF_DTL_MAPPINGS',
                     'OLD_PRD_WAIVEOFF_DTL_ID',
                     'NEW_PRD_WAIVEOFF_DTL_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (83,
                     156,
                     'EXCHANGE_WAIVEOFF_DETAILS',
                     'M156_EXG_WAIVEOFF_DTL_MAPPINGS',
                     'OLD_EXG_WAIVEOFF_DTL_ID',
                     'NEW_EXG_WAIVEOFF_DTL_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (85,
                     1044,
                     'UPLOADED_DOCUMENTS',
                     'U44_UPLOADED_DOC_MAPPINGS',
                     'OLD_UPLOADED_DOC_ID',
                     'NEW_UPLOADED_DOC_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (86,
                     10,
                     'RELATIONSHIP_MANAGER',
                     'M10_RM_MAPPINGS',
                     'OLD_RM_ID',
                     'NEW_RM_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (89,
                     3010,
                     'CASH_BLOCK_REQUEST',
                     'T10_CASH_BLOCK_REQ_MAPPINGS',
                     'OLD_CASH_BLOCK_REQ_ID',
                     'NEW_CASH_BLOCK_REQ_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (90,
                     3010,
                     'CASH_BLOCK_REQUEST',
                     'T10_CASH_BLOCK_REQ_MAPPINGS',
                     'OLD_CASH_BLOCK_REQ_ID',
                     'NEW_CASH_BLOCK_REQ_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (94,
                     141,
                     'CUST_CORPORATE_ACTION',
                     'CUST_CORPORATE_ACTION',
                     NULL,
                     NULL,
                     2);

        INSERT INTO map03_approval_entity_id
             VALUES (96,
                     24,
                     'COMMISSION_DISCOUNT_GROUP',
                     'M24_COMM_DISC_GRP_MAPPINGS',
                     'OLD_COMM_DISC_GRP_ID',
                     'NEW_COMM_DISC_GRP_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (97,
                     73,
                     'MARGIN_PRODUCTS',
                     'M73_MARGIN_PRODUCTS_MAPPINGS',
                     'OLD_MARGIN_PRODUCTS_ID',
                     'NEW_MARGIN_PRODUCTS_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (98,
                     117,
                     'CHARGE_GROUPS',
                     'M117_CHARGE_GROUPS_MAPPINGS',
                     'OLD_CHARGE_GROUPS_ID',
                     'NEW_CHARGE_GROUPS_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (100,
                     2,
                     'INSTITUTE',
                     'M02_INSTITUTE_MAPPINGS',
                     'OLD_INSTITUTE_ID',
                     'NEW_INSTITUTE_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (109,
                     166,
                     'CUSTODY_CHARGES_GROUPS',
                     'M166_CSTDY_CHRGS_GRP_MAPPINGS',
                     'OLD_CSTDY_CHRGS_GRP_ID',
                     'NEW_CSTDY_CHRGS_GRP_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (110,
                     24,
                     'COMMISSION_DISCOUNT_GROUPS',
                     'M24_COMM_DISC_GRP_MAPPINGS',
                     'OLD_COMM_DISC_GRP_ID',
                     'NEW_COMM_DISC_GRP_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (111,
                     167,
                     'CUSTODY_CHARGES_SLAB',
                     'M167_CSTDY_CHRGS_SLAB_MAPPINGS',
                     'OLD_CSTDY_CHRGS_SLAB_ID',
                     'NEW_CSTDY_CHRGS_SLAB_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (112,
                     131,
                     'MARKET_MAKER_GRPS',
                     'M131_MARKET_MAKER_GRP_MAPPINGS',
                     'OLD_MARKET_MAKER_GRP_ID',
                     'NEW_MARKET_MAKER_GRP_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (113,
                     77,
                     'SYMBOL_MARGINABILITY_GROUPS',
                     'M77_SYMBOL_MARGIN_GRP_MAPPINGS',
                     'OLD_SYMBOL_MARGIN_GRP_ID',
                     'NEW_SYMBOL_MARGIN_GRP_ID',
                     0);

        INSERT INTO map03_approval_entity_id
             VALUES (133,
                     30501,
                     'PAYMENT_DETAIL_C',
                     'T501_PAYMENT_DETAIL_C_MAPPINGS',
                     'OLD_PAYMENT_DETAIL_ID',
                     'NEW_PAYMENT_DETAIL_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (134,
                     30500,
                     'PAYMENT_SESSIONS_C',
                     'T500_PAYMNT_SESSION_C_MAPPINGS',
                     'OLD_PAYMNT_SESSION_ID',
                     'NEW_PAYMNT_SESSION_ID',
                     1);

        INSERT INTO map03_approval_entity_id (map03_oms_id,
                                              map03_ntp_id,
                                              map03_name,
                                              map03_mapping_table,
                                              map03_old_column,
                                              map03_new_column,
                                              map03_type)
             VALUES (22,
                     4,
                     'CURRENCY_RATE',
                     'M04_CURRENCY_RATE_MAPPINGS',
                     NULL,
                     NULL,
                     2);

        -- SFC Related

        DELETE FROM map03_approval_entity_id
              WHERE map03_oms_id = 96; -- Duplicate COMMISSION_DISCOUNT_GROUPS

        DELETE FROM map03_approval_entity_id
              WHERE map03_oms_id = 113; -- [Wrong] SYMBOL_MARGINABILITY_GROUPS

        INSERT INTO map03_approval_entity_id
             VALUES (107,
                     77,
                     'SYMBOL_MARGINABILITY_GROUPS',
                     'M77_SYMBOL_MARGIN_GRP_MAPPINGS',
                     'OLD_SYMBOL_MARGIN_GRP_ID',
                     'NEW_SYMBOL_MARGIN_GRP_ID',
                     0);

        DELETE FROM map03_approval_entity_id
              WHERE map03_oms_id = 97; -- [Wrong] MARGIN_PRODUCTS

        INSERT INTO map03_approval_entity_id
             VALUES (97,
                     176,
                     'TRANSACTION_LIMIT_GROUP',
                     'M176_ORDER_LIMIT_GRP_MAPPINGS',
                     'OLD_ORDER_LIMIT_GRP_ID',
                     'NEW_ORDER_LIMIT_GRP_ID',
                     1);

        INSERT INTO map03_approval_entity_id
             VALUES (97,
                     177,
                     'TRANSACTION_LIMIT_GROUP',
                     'M177_CSH_TRNS_LMT_GRP_MAPPINGS',
                     'OLD_CSH_TRNS_LMT_GRP_ID',
                     'NEW_CSH_TRNS_LMT_GRP_ID',
                     1);

        DELETE FROM map03_approval_entity_id
              WHERE map03_oms_id = 100; -- [Wrong] INSTITUTE
    END IF;
END;
/
