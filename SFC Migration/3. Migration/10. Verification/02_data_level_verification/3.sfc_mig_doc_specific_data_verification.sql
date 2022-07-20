DECLARE
    l_count   NUMBER := 0;
    l_table   VARCHAR2 (50) := 'sfc_data_verification';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_tables
     WHERE table_name = UPPER (l_table);

    IF (l_count = 0)
    THEN
        EXECUTE IMMEDIATE
               'CREATE TABLE '
            || l_table
            || '
    (
        source_table             VARCHAR2 (100 BYTE),
        target_table             VARCHAR2 (100 BYTE),
        verification_condition   VARCHAR2 (1000 BYTE),
        verification_value       VARCHAR2 (100 BYTE),
        old_value                NUMBER (30, 10),
        new_value                NUMBER (30, 10),
        difference               NUMBER (30, 10)
    )';
    ELSE
        EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || l_table;
    END IF;
END;
/

-- [1.0] Check Row Differences Table for Row Count Verifications

-- [2.1] CUSTOMER - STATUS WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   map01_description
              FROM (  SELECT map01.map01_ntp_id,
                             MAX (map01.map01_description) AS map01_description,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.m01_customer@mubasher_db_link m01,
                             map01_approval_status_v01 map01
                       WHERE     m01.m01_owner_id > 0
                             AND m01.m01_status_id = map01.map01_oms_id(+)
                    GROUP BY map01.map01_ntp_id) m01,
                   (  SELECT u01.u01_status_id_v01, COUNT (*) AS new_value
                        FROM dfn_ntp.u01_customer u01
                    GROUP BY u01.u01_status_id_v01) u01
             WHERE m01.map01_ntp_id = u01.u01_status_id_v01(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M01_CUSTOMER',
                     'U01_CUSTOMER',
                     'STATUS WISE',
                     i.map01_description,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [2.2] CUSTOMER IDENTIFICATION - STATUS WISE

BEGIN
    FOR i
        IN (SELECT old_value, NVL (new_value, 0) AS new_value, map08_name
              FROM (  SELECT map08.map08_ntp_id,
                             MAX (map08.map08_name) AS map08_name,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.m243_customer_identifications@mubasher_db_link m243,
                             mubasher_oms.m01_customer@mubasher_db_link m01,
                             map08_identity_type_m15 map08
                       WHERE     m243.m243_customer = m01.m01_customer_id
                             AND m01.m01_owner_id > 0
                             AND m243.m243_identification_type =
                                     map08.map08_oms_id(+)
                    GROUP BY map08.map08_ntp_id) m243,
                   (  SELECT u05.u05_identity_type_id_m15,
                             COUNT (*) AS new_value
                        FROM dfn_ntp.u05_customer_identification u05
                    GROUP BY u05.u05_identity_type_id_m15) u05
             WHERE m243.map08_ntp_id = u05.u05_identity_type_id_m15(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M243_CUSTOMER_IDENTIFICATIONS',
                     'U05_CUSTOMER_IDENTIFICATION',
                     'ID TYPE WISE',
                     i.map08_name,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [2.3] CUSTOMER - NATIONALITY WISE

BEGIN
    FOR i
        IN (SELECT NVL (old_value, 0) AS old_value,
                   NVL (new_value, 0) AS new_value,
                   map06_name,
                   NVL (new_value, 0) - NVL (old_value, 0)
              FROM (  SELECT map06.map06_ntp_id,
                             MAX (map06.map06_name) AS map06_name,
                             COUNT (*) old_value
                        FROM mubasher_oms.m01_customer@mubasher_db_link m01,
                             map06_country_m05 map06
                       WHERE     m01.m01_owner_id > 0
                             AND m01.m01_c1_nationality_id =
                                     map06.map06_oms_id(+)
                    GROUP BY map06.map06_ntp_id) m01,
                   (  SELECT u01.u01_nationality_id_m05, COUNT (*) new_value
                        FROM dfn_ntp.u01_customer u01
                    GROUP BY u01.u01_nationality_id_m05) u01
             WHERE m01.map06_ntp_id = u01.u01_nationality_id_m05(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M01_CUSTOMER',
                     'U01_CUSTOMER',
                     'NATIONALITY WISE',
                     i.map06_name,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value)); -- M01_C1_NATIONALITY_ID IN [380 (GCC) & 401(Test Countyry)] diff <> 0
    END LOOP;
END;
/

-- [2.4] CUSTOMER - BLOCK STATUS WISE

BEGIN
    FOR i
        IN (SELECT CASE u01.u01_block_status_b
                       WHEN 1 THEN 'Open'
                       WHEN 2 THEN 'Debit Block'
                       WHEN 3 THEN 'Close'
                       WHEN 4 THEN 'Full Block'
                       WHEN 5 THEN 'DB Freeze'
                   END
                       AS block_status,
                   NVL (old_value, 0) AS old_value,
                   NVL (new_value, 0) AS new_value
              FROM (  SELECT m01.m01_block_status, SUM (old_count) AS old_value
                        FROM (  SELECT NVL (m01.m01_block_status, 2)
                                           m01_block_status,
                                       COUNT (*) old_count
                                  FROM mubasher_oms.m01_customer@mubasher_db_link m01
                                 WHERE m01.m01_owner_id > 0
                              GROUP BY m01_block_status) m01
                    GROUP BY m01_block_status) m01,
                   (  SELECT u01.u01_block_status_b, COUNT (*) AS new_value
                        FROM dfn_ntp.u01_customer u01
                    GROUP BY u01.u01_block_status_b) u01
             WHERE m01.m01_block_status = u01.u01_block_status_b)
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M01_CUSTOMER',
                     'U01_CUSTOMER',
                     'BLOCK STATUS WISE',
                     i.block_status,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [2.5] CUSTOMER - DISTINCT ID NUMBERS

DECLARE
    old_value   NUMBER;
    new_value   NUMBER;
BEGIN
    SELECT COUNT (*)
      INTO old_value
      FROM (SELECT DISTINCT m243_id_no
              FROM mubasher_oms.m01_customer@mubasher_db_link m01,
                   mubasher_oms.m243_customer_identifications@mubasher_db_link m243
             WHERE     m01.m01_customer_id = m243.m243_customer(+)
                   AND m01.m01_owner_id > 0);

    SELECT COUNT (*)
      INTO new_value
      FROM (SELECT DISTINCT u01_default_id_no
              FROM dfn_ntp.u01_customer u01);

    INSERT INTO sfc_data_verification (source_table,
                                       target_table,
                                       verification_condition,
                                       verification_value,
                                       old_value,
                                       new_value,
                                       difference)
         VALUES ('M01_CUSTOMER',
                 'U01_CUSTOMER',
                 'DISTINCT ID NUMBERS',
                 'DISTINCT ID NUMBERS',
                 old_value,
                 new_value,
                 (new_value - old_value));
END;
/

-- [2.6] CUSTOMER - CPTS UNDER EACH ID

BEGIN
    FOR i
        IN (SELECT SUM (old_value) AS old_value, SUM (new_value) AS new_value
              FROM (  SELECT m243_id_no,
                             COUNT (m01_external_ref_no) AS old_value
                        FROM mubasher_oms.m01_customer@mubasher_db_link m01,
                             mubasher_oms.m243_customer_identifications@mubasher_db_link m243
                       WHERE     m01.m01_customer_id = m243.m243_customer(+)
                             AND m01.m01_owner_id > 0
                    GROUP BY m243_id_no) m01,
                   (  SELECT u01_default_id_no,
                             COUNT (u01_customer_no) AS new_value
                        FROM dfn_ntp.u01_customer u01
                    GROUP BY u01_default_id_no) u01
             WHERE m01.m243_id_no = u01.u01_default_id_no)
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M01_CUSTOMER',
                     'U01_CUSTOMER',
                     'CPTS UNDER EACH ID',
                     'CPTS UNDER EACH ID',
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [2.7] CUSTOMER - CPTS UNDER EACH ID vs CPTS RECONCILIATION

BEGIN
    FOR i
        IN (SELECT u01_default_id_no, old_value, new_value
              FROM (  SELECT m243_id_no,
                             COUNT (m01_external_ref_no) AS old_value
                        FROM mubasher_oms.m01_customer@mubasher_db_link m01,
                             mubasher_oms.m243_customer_identifications@mubasher_db_link m243
                       WHERE     m01.m01_customer_id = m243.m243_customer(+)
                             AND m01.m01_owner_id > 0
                    GROUP BY m243_id_no) m01,
                   (  SELECT u01_default_id_no,
                             COUNT (u01_customer_no) AS new_value
                        FROM dfn_ntp.u01_customer u01
                    GROUP BY u01_default_id_no) u01
             WHERE m01.m243_id_no = u01.u01_default_id_no)
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M01_CUSTOMER',
                     'U01_CUSTOMER',
                     'CPTS UNDER EACH ID vs CPTS RECONCILIATION',
                     i.u01_default_id_no,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [2.8] CUSTOMER - BLOCK STATUS OF ALL CPTS

BEGIN
    FOR i
        IN (SELECT m01_external_ref_no, old_value, new_value
              FROM (SELECT m01_external_ref_no,
                           NVL (m01.m01_block_status, 2) AS old_value
                      FROM mubasher_oms.m01_customer@mubasher_db_link m01
                     WHERE m01.m01_owner_id > 0) m01,
                   (SELECT u01_customer_no, u01_block_status_b AS new_value
                      FROM dfn_ntp.u01_customer u01) u01
             WHERE m01.m01_external_ref_no = u01.u01_customer_no)
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M01_CUSTOMER',
                     'U01_CUSTOMER',
                     'BLOCK STATUS OF ALL CPTS',
                     i.m01_external_ref_no,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [2.9] CUSTOMER - COMMISSION GROUP (CATEGORY) WISE CPTS

BEGIN
    FOR i
        IN (SELECT map17_ntp_id, old_value, new_value
              FROM (  SELECT NVL (map17.map17_ntp_id, 0) AS map17_ntp_id,
                             COUNT (m01.m01_external_ref_no) AS old_value
                        FROM mubasher_oms.m01_customer@mubasher_db_link m01,
                             map17_customer_category_v01_86 map17
                       WHERE     m01.m01_owner_id > 0
                             AND m01.m01_commssion_group =
                                     map17.map17_oms_id(+)
                    GROUP BY NVL (map17.map17_ntp_id, 0)) m01,
                   (  SELECT u01.u01_category_v01,
                             COUNT (u01.u01_customer_no) AS new_value
                        FROM dfn_ntp.u01_customer u01
                    GROUP BY u01.u01_category_v01) u01
             WHERE m01.map17_ntp_id = u01.u01_category_v01)
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M01_CUSTOMER',
                     'U01_CUSTOMER',
                     'COMMISSION GROUP (CATEGORY) WISE CPTS',
                     i.map17_ntp_id,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/


-- [3.1] CASH ACCOUNT BALANCES - CURRENCY WISE

BEGIN
    FOR i
        IN (SELECT t03_currency,
                   t03_balance,
                   t03_payable_amount,
                   receivable_amount,
                   t03_blocked_amount,
                   t03_loan_amount,
                   t03_accrual_interest,
                   t03_other_block_amt,
                   u06_balance,
                   u06_payable_blocked,
                   u06_receivable_amount,
                   u06_blocked,
                   u06_loan_amount,
                   u06_accrued_interest,
                   u06_manual_full_blocked
              FROM (  SELECT t03.t03_currency,
                             SUM (NVL (t03.t03_balance, 0)) AS t03_balance,
                             SUM (NVL (t03.t03_payable_amount, 0))
                                 AS t03_payable_amount,
                             SUM (NVL (t03.t03_pending_settle, 0))
                                 AS receivable_amount,
                             SUM (
                                   ABS (NVL (t03.t03_blocked_amount, 0))
                                 + ABS (NVL (t03.t03_margin_block, 0)))
                                 AS t03_blocked_amount,
                             SUM (t03.t03_loan_amount) AS t03_loan_amount,
                             SUM (t03.t03_accrual_interest)
                                 AS t03_accrual_interest,
                             SUM (ABS (NVL (t03.t03_other_block_amt, 0)))
                                 AS t03_other_block_amt
                        FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
                       WHERE t03.t03_branch_id > 0
                    GROUP BY t03.t03_currency) t03,
                   (  SELECT u06.u06_currency_code_m03,
                             SUM (NVL (u06.u06_balance, 0)) AS u06_balance,
                             SUM (NVL (u06.u06_payable_blocked, 0))
                                 AS u06_payable_blocked,
                             SUM (NVL (u06.u06_receivable_amount, 0))
                                 AS u06_receivable_amount,
                             SUM (ABS (NVL (u06.u06_blocked, 0)))
                                 AS u06_blocked,
                             SUM (u06.u06_loan_amount) AS u06_loan_amount,
                             SUM (u06.u06_accrued_interest)
                                 AS u06_accrued_interest,
                             SUM (NVL (u06.u06_manual_full_blocked, 0))
                                 AS u06_manual_full_blocked
                        FROM dfn_ntp.u06_cash_account u06
                    GROUP BY u06.u06_currency_code_m03) u06
             WHERE t03.t03_currency = u06.u06_currency_code_m03(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'CURRENCY WISE - CASH BALANCE',
                     i.t03_currency,
                     i.t03_balance,
                     i.u06_balance,
                     (i.u06_balance - i.t03_balance));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'CURRENCY WISE - PAYABLE AMOUNT',
                     i.t03_currency,
                     i.t03_payable_amount,
                     i.u06_payable_blocked,
                     (i.u06_payable_blocked - i.t03_payable_amount));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'CURRENCY WISE - RECEIVABLE AMOUNT',
                     i.t03_currency,
                     i.receivable_amount,
                     i.u06_receivable_amount,
                     (i.u06_receivable_amount - i.receivable_amount));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'CURRENCY WISE - BLOCKED AMOUNT',
                     i.t03_currency,
                     i.t03_blocked_amount,
                     i.u06_blocked,
                     (i.u06_blocked - i.t03_blocked_amount));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'CURRENCY WISE - LOAN AMOUNT',
                     i.t03_currency,
                     i.t03_loan_amount,
                     i.u06_loan_amount,
                     (i.u06_loan_amount - i.t03_loan_amount));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'CURRENCY WISE - ACCRUED INTEREST',
                     i.t03_currency,
                     i.t03_accrual_interest,
                     i.u06_accrued_interest,
                     (i.u06_accrued_interest - i.t03_accrual_interest));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'CURRENCY WISE - OTHER BLOCK AMOUNT',
                     i.t03_currency,
                     i.t03_other_block_amt,
                     i.u06_manual_full_blocked,
                     (i.u06_manual_full_blocked - i.t03_other_block_amt));
    END LOOP;
END;
/

-- [3.2] CASH ACCOUNT - STATUS WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   map01_description
              FROM (  SELECT map01.map01_ntp_id,
                             MAX (map01.map01_description) AS map01_description,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.t03_cash_account@mubasher_db_link t03,
                             map01_approval_status_v01 map01
                       WHERE     t03.t03_branch_id > 0
                             AND NVL (t03.t03_status_id, 2) =
                                     map01.map01_oms_id(+)
                    GROUP BY map01.map01_ntp_id) t03,
                   (  SELECT u06.u06_status_id_v01, COUNT (*) AS new_value
                        FROM dfn_ntp.u06_cash_account u06
                    GROUP BY u06.u06_status_id_v01) u06
             WHERE t03.map01_ntp_id = u06.u06_status_id_v01(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'STATUS WISE',
                     i.map01_description,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [3.3] CASH ACCOUNT - CASH TRANSFER LIMIT GROUP WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   new_csh_trns_lmt_grp_id
              FROM (  SELECT m177_map.new_csh_trns_lmt_grp_id,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.t03_cash_account@mubasher_db_link t03,
                             m177_csh_trns_lmt_grp_mappings m177_map -- Joined to Skip Not Migrated Records
                       WHERE     t03.t03_branch_id > 0
                             AND t03.t03_cash_transfer_limit_group =
                                     m177_map.old_csh_trns_lmt_grp_id
                             AND t03.t03_branch_id = m177_map.new_institute_id
                    GROUP BY m177_map.new_csh_trns_lmt_grp_id) t03,
                   (  SELECT u06.u06_transfer_limit_grp_id_m177,
                             COUNT (*) AS new_value
                        FROM dfn_ntp.u06_cash_account u06
                    GROUP BY u06.u06_transfer_limit_grp_id_m177) u06
             WHERE t03.new_csh_trns_lmt_grp_id =
                       u06.u06_transfer_limit_grp_id_m177(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'CASH TRANSFER LIMIT GROUP WISE',
                     i.new_csh_trns_lmt_grp_id,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [3.4] CASH ACCOUNT - BLOCK STATUS WISE

BEGIN
    FOR i
        IN (SELECT CASE u06.u06_block_status_b
                       WHEN 1 THEN 'Open'
                       WHEN 2 THEN 'Debit Block'
                       WHEN 3 THEN 'Close'
                       WHEN 4 THEN 'Full Block'
                       WHEN 5 THEN 'DB Freeze'
                   END
                       AS block_status,
                   NVL (old_value, 0) AS old_value,
                   NVL (new_value, 0) AS new_value
              FROM (  SELECT t03_block_status, SUM (old_count) old_value
                        FROM (  SELECT NVL (t03.t03_block_status, 2)
                                           t03_block_status,
                                       COUNT (*) old_count
                                  FROM mubasher_oms.t03_cash_account@mubasher_db_link t03
                                 WHERE t03.t03_branch_id > 0
                              GROUP BY t03_block_status) t03
                    GROUP BY t03.t03_block_status) t03,
                   (  SELECT u06.u06_block_status_b, COUNT (*) new_value
                        FROM dfn_ntp.u06_cash_account u06
                    GROUP BY u06_block_status_b) u06
             WHERE t03.t03_block_status = u06.u06_block_status_b)
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'BLOCK STATUS WISE',
                     i.block_status,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [3.5] CASH ACCOUNT - CURRENCY, CUST. REFERENCE, CASH ACC. INVESTROR NO (EXTERNAL REF) WISE CPTS RECONCILIATION

BEGIN
    FOR i
        IN (SELECT old_value,
                   new_value,
                   t03_currency,
                   m01_external_ref_no,
                   t03_external_reference
              FROM (  SELECT COUNT (*) AS old_value,
                             NVL (m01_external_ref_no, '-')
                                 AS m01_external_ref_no,
                             NVL (t03_currency, '-') AS t03_currency,
                             NVL (t03_external_reference, '-')
                                 AS t03_external_reference
                        FROM mubasher_oms.t03_cash_account@mubasher_db_link,
                             mubasher_oms.m01_customer@mubasher_db_link
                       WHERE     t03_profile_id = m01_customer_id
                             AND m01_owner_id > 0
                             AND t03_branch_id > 0
                    GROUP BY NVL (m01_external_ref_no, '-'),
                             NVL (t03_currency, '-'),
                             NVL (t03_external_reference, '-')) t03,
                   (  SELECT COUNT (*) AS new_value,
                             NVL (u01_external_ref_no, '-')
                                 AS u01_external_ref_no,
                             NVL (u06_currency_code_m03, '-')
                                 AS u06_currency_code_m03,
                             NVL (u06_external_ref_no, '-')
                                 AS u06_external_ref_no
                        FROM dfn_ntp.u06_cash_account u06, dfn_ntp.u01_customer
                       WHERE u06_customer_id_u01 = u01_id
                    GROUP BY NVL (u01_external_ref_no, '-'),
                             NVL (u06_currency_code_m03, '-'),
                             NVL (u06_external_ref_no, '-')) u06
             WHERE     t03.m01_external_ref_no = u06.u01_external_ref_no(+)
                   AND t03.t03_currency = u06.u06_currency_code_m03(+)
                   AND t03.t03_external_reference =
                           u06.u06_external_ref_no(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES (
                        'T03_CASH_ACCOUNT',
                        'U06_CASH_ACCOUNT',
                        'CURRENCY, CUST. REFERENCE, CASH ACC. INVESTROR NO (EXTERNAL REF) WISE CPTS RECONCILIATION',
                           'CURRENCY : '
                        || i.t03_currency
                        || ' - CUST. REFERENCE : '
                        || i.m01_external_ref_no
                        || ' - CASH ACC. INVESTROR NO : '
                        || i.t03_external_reference,
                        i.old_value,
                        i.new_value,
                        (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [3.6] CASH ACCOUNT - DISTINCT CPTS

BEGIN
    FOR i
        IN (SELECT old_value, new_value, m01_external_ref_no
              FROM (  SELECT COUNT (m01_external_ref_no) AS old_value,
                             m01_external_ref_no
                        FROM mubasher_oms.t03_cash_account@mubasher_db_link t03,
                             mubasher_oms.m01_customer@mubasher_db_link m01
                       WHERE     t03.t03_profile_id = m01.m01_customer_id
                             AND m01.m01_owner_id > 0
                             AND t03_branch_id > 0
                    GROUP BY m01_external_ref_no) t03,
                   (  SELECT COUNT (u01_external_ref_no) AS new_value,
                             u01_external_ref_no
                        FROM dfn_ntp.u06_cash_account, dfn_ntp.u01_customer
                       WHERE u06_customer_id_u01 = u01_id
                    GROUP BY u01_external_ref_no) u06
             WHERE t03.m01_external_ref_no = u06.u01_external_ref_no(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'DISTINCT CPTS',
                     i.m01_external_ref_no,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [3.7] CASH ACCOUNT - DISTINCT IDS

BEGIN
    FOR i
        IN (SELECT old_value, new_value, m243_id_no
              FROM (  SELECT m243_id_no, COUNT (m243_id_no) AS old_value
                        FROM mubasher_oms.m01_customer@mubasher_db_link m01,
                             mubasher_oms.m243_customer_identifications@mubasher_db_link m243
                       WHERE     m01.m01_owner_id > 0
                             AND m01.m01_customer_id = m243.m243_customer(+)
                    GROUP BY m243_id_no) t03,
                   (  SELECT u06_default_id_no_u01,
                             COUNT (u06_default_id_no_u01) AS new_value
                        FROM dfn_ntp.u06_cash_account
                    GROUP BY u06_default_id_no_u01) u06
             WHERE t03.m243_id_no = u06.u06_default_id_no_u01)
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'DISTINCT IDS',
                     i.m243_id_no,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [3.8] CASH ACCOUNT BALANCES - ACCOUNT WISE

BEGIN
    FOR i
        IN (SELECT new_cash_account_id,
                   t03_balance,
                   t03_payable_amount,
                   receivable_amount,
                   t03_blocked_amount,
                   t03_loan_amount,
                   t03_accrual_interest,
                   t03_other_block_amt,
                   u06_balance,
                   u06_payable_blocked,
                   u06_receivable_amount,
                   u06_blocked,
                   u06_loan_amount,
                   u06_accrued_interest,
                   u06_manual_full_blocked
              FROM (SELECT u06_map.new_cash_account_id,
                           NVL (t03.t03_balance, 0) AS t03_balance,
                           NVL (t03.t03_payable_amount, 0)
                               AS t03_payable_amount,
                           NVL (t03.t03_pending_settle, 0)
                               AS receivable_amount,
                             ABS (NVL (t03.t03_blocked_amount, 0))
                           + ABS (NVL (t03.t03_margin_block, 0))
                               AS t03_blocked_amount,
                           t03.t03_loan_amount AS t03_loan_amount,
                           t03.t03_accrual_interest AS t03_accrual_interest,
                           ABS (NVL (t03.t03_other_block_amt, 0))
                               AS t03_other_block_amt
                      FROM mubasher_oms.t03_cash_account@mubasher_db_link t03,
                           u06_cash_account_mappings u06_map
                     WHERE t03.t03_account_id = u06_map.old_cash_account_id) t03,
                   (SELECT u06.u06_id,
                           NVL (u06.u06_balance, 0) AS u06_balance,
                           NVL (u06.u06_payable_blocked, 0)
                               AS u06_payable_blocked,
                           NVL (u06.u06_receivable_amount, 0)
                               AS u06_receivable_amount,
                           ABS (NVL (u06.u06_blocked, 0)) AS u06_blocked,
                           u06.u06_loan_amount AS u06_loan_amount,
                           u06.u06_accrued_interest AS u06_accrued_interest,
                           NVL (u06.u06_manual_full_blocked, 0)
                               AS u06_manual_full_blocked
                      FROM dfn_ntp.u06_cash_account u06) u06
             WHERE t03.new_cash_account_id = u06.u06_id(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'ACCOUNT WISE - CASH BALANCE',
                     i.new_cash_account_id,
                     i.t03_balance,
                     i.u06_balance,
                     (i.u06_balance - i.t03_balance));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'ACCOUNT WISE - PAYABLE AMOUNT',
                     i.new_cash_account_id,
                     i.t03_payable_amount,
                     i.u06_payable_blocked,
                     (i.u06_payable_blocked - i.t03_payable_amount));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'ACCOUNT WISE - RECEIVABLE AMOUNT',
                     i.new_cash_account_id,
                     i.receivable_amount,
                     i.u06_receivable_amount,
                     (i.u06_receivable_amount - i.receivable_amount));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'ACCOUNT WISE - BLOCKED AMOUNT',
                     i.new_cash_account_id,
                     i.t03_blocked_amount,
                     i.u06_blocked,
                     (i.u06_blocked - i.t03_blocked_amount));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'ACCOUNT WISE - LOAN AMOUNT',
                     i.new_cash_account_id,
                     i.t03_loan_amount,
                     i.u06_loan_amount,
                     (i.u06_loan_amount - i.t03_loan_amount));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'ACCOUNT WISE - ACCRUED INTEREST',
                     i.new_cash_account_id,
                     i.t03_accrual_interest,
                     i.u06_accrued_interest,
                     (i.u06_accrued_interest - i.t03_accrual_interest));

        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T03_CASH_ACCOUNT',
                     'U06_CASH_ACCOUNT',
                     'ACCOUNT WISE - OTHER BLOCK AMOUNT',
                     i.new_cash_account_id,
                     i.t03_other_block_amt,
                     i.u06_manual_full_blocked,
                     (i.u06_manual_full_blocked - i.t03_other_block_amt));
    END LOOP;
END;
/

-- [4.1] CUSTOMER MARGIN PRODUCTS - STATUS WISE

DECLARE
    l_default_currecny_code   VARCHAR2 (10);
BEGIN
    SELECT VALUE
      INTO l_default_currecny_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   map01_description
              FROM (  SELECT map01.map01_ntp_id,
                             MAX (map01.map01_description) AS map01_description,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.u22_customer_margin_products@mubasher_db_link u22,
                             mubasher_oms.m01_customer@mubasher_db_link m01,
                             mubasher_oms.m265_margin_products@mubasher_db_link m265,
                             m02_institute_mappings m02_map,
                             m73_margin_products_mappings m73_map,
                             dfn_ntp.m73_margin_products m73,
                             m77_symbol_margin_grp_mappings m77_map,
                             map01_approval_status_v01 map01
                       WHERE     u22.u22_status = map01.map01_oms_id(+)
                             AND u22.u22_margin_product = m265.m265_id
                             AND u22.u22_customer_id = m01.m01_customer_id
                             AND m01.m01_owner_id = m02_map.old_institute_id -- Joined to Skip Not Migrated Records
                             AND u22.u22_margin_product =
                                     m73_map.old_margin_products_id -- Joined to Skip Not Migrated Records
                             AND NVL (u22.u22_max_margin_limit_currency,
                                      l_default_currecny_code) =
                                     m73_map.currency_code -- Joined to Skip Not Migrated Records
                             AND m02_map.new_institute_id =
                                     m73_map.new_institute_id -- Joined to Skip Not Migrated Records
                             AND m73_map.new_margin_products_id = m73.m73_id
                             AND m73.m73_symbol_margblty_grp_id_m77 =
                                     m77_map.new_symbol_margin_grp_id -- Joined to Skip Not Migrated Records
                    GROUP BY map01.map01_ntp_id) u22,
                   (  SELECT u23.u23_status_id_v01, COUNT (*) AS new_value
                        FROM dfn_ntp.u23_customer_margin_product u23
                    GROUP BY u23.u23_status_id_v01) u23
             WHERE u22.map01_ntp_id = u23.u23_status_id_v01(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('U22_CUSTOMER_MARGIN_PRODUCTS',
                     'U23_CUSTOMER_MARGIN_PRODUCT',
                     'STATUS WISE',
                     i.map01_description,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [4.2] CUSTOMER MARGIN PRODUCTS - MARGIN PRODUCT WISE

DECLARE
    l_default_currecny_code   VARCHAR2 (10);
BEGIN
    SELECT VALUE
      INTO l_default_currecny_code
      FROM migration_params
     WHERE code = 'DEFAULT_CURRENCY_CODE';

    FOR i
        IN (SELECT old_value, NVL (new_value, 0) AS new_value, m73_name
              FROM (  SELECT m73_map.new_margin_products_id,
                             MAX (m73.m73_name) AS m73_name,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.u22_customer_margin_products@mubasher_db_link u22,
                             mubasher_oms.m01_customer@mubasher_db_link m01,
                             mubasher_oms.m265_margin_products@mubasher_db_link m265,
                             m02_institute_mappings m02_map,
                             m73_margin_products_mappings m73_map,
                             dfn_ntp.m73_margin_products m73,
                             m77_symbol_margin_grp_mappings m77_map
                       WHERE     u22.u22_margin_product = m265.m265_id
                             AND u22.u22_customer_id = m01.m01_customer_id
                             AND m01.m01_owner_id = m02_map.old_institute_id -- Joined to Skip Not Migrated Records
                             AND u22.u22_margin_product =
                                     m73_map.old_margin_products_id(+) -- Joined to Skip Not Migrated Records
                             AND NVL (u22.u22_max_margin_limit_currency,
                                      l_default_currecny_code) =
                                     m73_map.currency_code(+) -- Joined to Skip Not Migrated Records
                             AND m02_map.new_institute_id =
                                     m73_map.new_institute_id(+) -- Joined to Skip Not Migrated Records
                             AND m73_map.new_margin_products_id = m73.m73_id(+)
                             AND m73.m73_symbol_margblty_grp_id_m77 =
                                     m77_map.new_symbol_margin_grp_id -- Joined to Skip Not Migrated Records
                    GROUP BY m73_map.new_margin_products_id) u22,
                   (  SELECT u23.u23_margin_product_m73, COUNT (*) AS new_value
                        FROM dfn_ntp.u23_customer_margin_product u23
                    GROUP BY u23.u23_margin_product_m73) u23
             WHERE u22.new_margin_products_id = u23.u23_margin_product_m73(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('U22_CUSTOMER_MARGIN_PRODUCTS',
                     'U23_CUSTOMER_MARGIN_PRODUCT',
                     'MARGIN PRODUCT WISE',
                     i.m73_name,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [4.3] MARGIN PRODUCT WISE LOAN AMOUNT

BEGIN
    FOR i
        IN (SELECT u05.m73_name,
                   NVL (old_value, 0) AS old_value,
                   NVL (new_value, 0) AS new_value,
                   NVL (new_value, 0) - NVL (old_value, 0) AS diff
              FROM (  SELECT m73.m73_id,
                             MAX (m73.m73_name) AS m73_name,
                             SUM (old_value) AS old_value
                        FROM (  SELECT u05.u05_customer_margin_product,
                                       SUM (NVL (t03_loan_amount, 0))
                                           AS old_value
                                  FROM (  SELECT u05_customer_margin_product,
                                                 u05_cash_account_id
                                            FROM mubasher_oms.u05_security_accounts@mubasher_db_link
                                           WHERE u05_customer_margin_product
                                                     IS NOT NULL
                                        GROUP BY u05_cash_account_id,
                                                 u05_customer_margin_product -- Cash Account Linked to Several Security Accounts.
                                                                            ) u05,
                                       mubasher_oms.t03_cash_account@mubasher_db_link t03,
                                       m02_institute_mappings m02_map
                                 WHERE     u05.u05_cash_account_id =
                                               t03.t03_account_id
                                       AND t03.t03_branch_id =
                                               m02_map.old_institute_id -- Joined to Skip Not Migrated Records
                              GROUP BY u05.u05_customer_margin_product) u05,
                             u23_cust_margin_prod_mappings u23_map,
                             dfn_ntp.u23_customer_margin_product u23,
                             dfn_ntp.m73_margin_products m73
                       WHERE     u05.u05_customer_margin_product =
                                     u23_map.old_cust_margin_prod_id -- Joined to Skip Not Migrated Records
                             AND u23_map.new_cust_margin_prod_id = u23.u23_id
                             AND u23.u23_margin_product_m73 = m73.m73_id
                    GROUP BY m73.m73_id) u05,
                   (  SELECT m73.m73_id,
                             SUM (NVL (u06_loan_amount, 0)) AS new_value
                        FROM dfn_ntp.m73_margin_products m73,
                             dfn_ntp.u06_cash_account u06,
                             dfn_ntp.u23_customer_margin_product u23
                       WHERE     u06.u06_margin_product_id_u23 = u23.u23_id
                             AND u23.u23_margin_product_m73 = m73.m73_id
                    GROUP BY m73.m73_id) m73
             WHERE u05.m73_id = m73.m73_id(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('U22_CUSTOMER_MARGIN_PRODUCTS',
                     'M73_MARGIN_PRODUCTS',
                     'MARGIN PRODUCT WISE LOAN AMOUNT',
                     i.m73_name,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [5.1] TRADING ACCOUNT - STATUS WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   map01_description
              FROM (  SELECT map01.map01_ntp_id,
                             MAX (map01.map01_description) AS map01_description,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                             mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                             u01_customer_mappings u01_map,
                             u06_cash_account_mappings u06_map,
                             map01_approval_status_v01 map01
                       WHERE     u06.u06_security_ac_id = u05.u05_id
                             AND u05.u05_branch_id > 0
                             AND TO_NUMBER (u05.u05_customer_id) =
                                     u01_map.old_customer_id -- Joined to Skip Not Migrated Records
                             AND u05.u05_cash_account_id =
                                     u06_map.old_cash_account_id -- Joined to Skip Not Migrated Records
                             AND u06.u06_status_id = map01.map01_oms_id(+)
                    GROUP BY map01.map01_ntp_id) u06,
                   (  SELECT u07.u07_status_id_v01, COUNT (*) AS new_value
                        FROM dfn_ntp.u07_trading_account u07
                    GROUP BY u07.u07_status_id_v01) u07
             WHERE u06.map01_ntp_id = u07.u07_status_id_v01(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('U06_ROUTING_ACCOUNTS',
                     'U07_TRADING_ACCOUNT',
                     'STATUS WISE',
                     i.map01_description,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [5.2] TRADING ACCOUNT - EXCHANGE WISE

BEGIN
    FOR i
        IN (SELECT old_value, NVL (new_value, 0) AS new_value, exchange
              FROM (  SELECT NVL (map16.map16_ntp_code, u06.u06_exchange)
                                 AS exchange,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                             mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                             map16_optional_exchanges_m01 map16,
                             u01_customer_mappings u01_map,
                             u06_cash_account_mappings u06_map
                       WHERE     u06.u06_security_ac_id = u05.u05_id
                             AND u06.u06_exchange = map16.map16_oms_code(+)
                             AND u05.u05_branch_id > 0
                             AND TO_NUMBER (u05.u05_customer_id) =
                                     u01_map.old_customer_id -- Joined to Skip Not Migrated Records
                             AND u05.u05_cash_account_id =
                                     u06_map.old_cash_account_id -- Joined to Skip Not Migrated Records
                    GROUP BY NVL (map16.map16_ntp_code, u06.u06_exchange)) u06,
                   (  SELECT u07.u07_exchange_code_m01, COUNT (*) AS new_value
                        FROM dfn_ntp.u07_trading_account u07
                    GROUP BY u07.u07_exchange_code_m01) u07
             WHERE u06.exchange = u07.u07_exchange_code_m01(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('U06_ROUTING_ACCOUNTS',
                     'U07_TRADING_ACCOUNT',
                     'EXCHANGE WISE',
                     i.exchange,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [5.3] TRADING ACCOUNT - COMMISSION GROUP WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   m22_description
              FROM (  SELECT m22_map.new_comm_grp_id,
                             MAX (m22.m22_description) AS m22_description,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                             mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                             u01_customer_mappings u01_map,
                             u06_cash_account_mappings u06_map,
                             m22_comm_grp_mappings m22_map,
                             dfn_ntp.m22_commission_group m22
                       WHERE     u06.u06_security_ac_id = u05.u05_id
                             AND u05.u05_branch_id > 0
                             AND TO_NUMBER (u05.u05_customer_id) =
                                     u01_map.old_customer_id -- Joined to Skip Not Migrated Records
                             AND u05.u05_cash_account_id =
                                     u06_map.old_cash_account_id -- Joined to Skip Not Migrated Records
                             AND u06.u06_commision_group_id =
                                     m22_map.old_comm_grp_id(+) -- As We Introduce Default Commission Groups
                             AND m22_map.new_comm_grp_id = m22.m22_id(+)
                    GROUP BY m22_map.new_comm_grp_id) u06,
                   (  SELECT u07.u07_commission_group_id_m22,
                             COUNT (*) AS new_value
                        FROM dfn_ntp.u07_trading_account u07
                    GROUP BY u07.u07_commission_group_id_m22) u07
             WHERE u06.new_comm_grp_id = u07.u07_commission_group_id_m22(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('U06_ROUTING_ACCOUNTS',
                     'U07_TRADING_ACCOUNT',
                     'COMMISSION GROUP WISE',
                     i.m22_description,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [5.4] TRADING ACCOUNT - ACCOUNT CATEGORY WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   u06_account_category
              FROM (  SELECT u06.u06_account_category, COUNT (*) AS old_value
                        FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                             mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                             u01_customer_mappings u01_map,
                             u06_cash_account_mappings u06_map
                       WHERE     u06.u06_security_ac_id = u05.u05_id
                             AND u05.u05_branch_id > 0
                             AND TO_NUMBER (u05.u05_customer_id) =
                                     u01_map.old_customer_id -- Joined to Skip Not Migrated Records
                             AND u05.u05_cash_account_id =
                                     u06_map.old_cash_account_id -- Joined to Skip Not Migrated Records
                    GROUP BY u06.u06_account_category) u06,
                   (  SELECT u07.u07_account_category, COUNT (*) AS new_value
                        FROM dfn_ntp.u07_trading_account u07
                    GROUP BY u07.u07_account_category) u07
             WHERE u06.u06_account_category = u07.u07_account_category(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('U06_ROUTING_ACCOUNTS',
                     'U07_TRADING_ACCOUNT',
                     'ACCOUNT CATEGORY WISE',
                     i.u06_account_category,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [5.5] TRADING ACCOUNT - TRADING GROUP WISE CPTS

BEGIN
    FOR i
        IN (SELECT new_trd_group_id, old_value, new_value
              FROM (  SELECT new_trd_group_id,
                             COUNT (m01_external_ref_no) AS old_value
                        FROM (SELECT NVL (
                                         m08_map.new_trd_group_id,
                                         CASE
                                             WHEN NVL (map16.map16_ntp_code,
                                                       u06.u06_exchange) =
                                                      'TDWL'
                                             THEN
                                                 (SELECT m08_id
                                                    FROM dfn_ntp.m08_trading_group
                                                   WHERE     m08_is_default = 1
                                                         AND m08_institute_id_m02 =
                                                                 m02_map.new_institute_id)
                                             ELSE
                                                 (SELECT MIN (m08_id)
                                                    FROM dfn_ntp.m08_trading_group m08,
                                                         m08_trd_group_mappings m08_map
                                                   WHERE     m08.m08_id =
                                                                 m08_map.new_trd_group_id
                                                         AND m08_map.is_local_exchange =
                                                                 0
                                                         AND m08_institute_id_m02 =
                                                                 m02_map.new_institute_id)
                                         END)
                                         AS new_trd_group_id, -- Logic Used in Migration
                                     m01_external_ref_no
                                FROM mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                                     mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                                     mubasher_oms.m01_customer@mubasher_db_link m01,
                                     map16_optional_exchanges_m01 map16,
                                     m08_trd_group_mappings m08_map,
                                     u01_customer_mappings u01_map,
                                     u06_cash_account_mappings u06_map,
                                     m02_institute_mappings m02_map
                               WHERE     u06.u06_security_ac_id = u05.u05_id
                                     AND u05.u05_branch_id > 0
                                     AND u05.u05_branch_id =
                                             m02_map.old_institute_id
                                     AND u06.u06_exchange =
                                             map16.map16_oms_code(+)
                                     AND TO_NUMBER (u05.u05_customer_id) =
                                             u01_map.old_customer_id -- Joined to Skip Not Migrated Records
                                     AND u05.u05_cash_account_id =
                                             u06_map.old_cash_account_id -- Joined to Skip Not Migrated Records
                                     AND u01_map.old_customer_id =
                                             m01.m01_customer_id
                                     AND m01.m01_customer_group =
                                             m08_map.old_trd_group_id(+)
                                     AND CASE
                                             WHEN NVL (map16.map16_ntp_code,
                                                       u06.u06_exchange) =
                                                      'TDWL'
                                             THEN
                                                 1
                                             ELSE
                                                 0
                                         END = m08_map.is_local_exchange(+))
                    GROUP BY new_trd_group_id) m01,
                   (  SELECT u07.u07_trading_group_id_m08,
                             COUNT (u07.u07_customer_no_u01) AS new_value
                        FROM dfn_ntp.u07_trading_account u07
                    GROUP BY u07.u07_trading_group_id_m08) u01
             WHERE m01.new_trd_group_id = u01.u07_trading_group_id_m08)
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('U06_ROUTING_ACCOUNTS, U05_SECURITY_ACCOUNTS',
                     'U07_TRADING_ACCOUNT',
                     'TRADING GROUP WISE CPTS',
                     i.new_trd_group_id,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [6.1.1] TDWL HOLDINGS - SYMBOL WISE POSITION

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i
        IN (SELECT old_value, NVL (new_value, 0) AS new_value, t04_symbol
              FROM (  SELECT t04.t04_symbol,
                             SUM (t04.t04_net_holdings) AS old_value
                        FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_price_instrument_id_v34
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20
                       WHERE     t04.t04_exchange = 'TDWL'
                             AND t04.t04_security_ac_id =
                                     u07_map.old_trading_account_id -- Joined to Skip Not Migrated Records
                             AND t04.t04_exchange = u07_map.exchange_code -- Joined to Skip Not Migrated Records
                             AND t04.t04_symbol = m20.m20_symbol_code -- Joined to Skip Not Migrated Records
                             AND t04.t04_exchange = m20.m20_exchange_code_m01 -- Joined to Skip Not Migrated Records
                    GROUP BY t04.t04_symbol) t04,
                   (  SELECT u24.u24_symbol_code_m20,
                             SUM (u24.u24_net_holding) AS new_value
                        FROM dfn_ntp.u24_holdings u24
                    GROUP BY u24.u24_symbol_code_m20) u24
             WHERE t04.t04_symbol = u24.u24_symbol_code_m20(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T04_HOLDINGS_INTRADAY',
                     'U24_HOLDINGS',
                     'SYMBOL WISE POSITION',
                     i.t04_symbol,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [6.1.2] NONE TDWL HOLDINGS - SYMBOL WISE POSITION

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i
        IN (SELECT old_value, NVL (new_value, 0) AS new_value, t04_symbol
              FROM (  SELECT t04_dtl.t04_symbol,
                             SUM (t04_dtl.t04_net_holdings) AS old_value
                        FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_price_instrument_id_v34
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20,
                             m26_executing_broker_mappings m26_map
                       WHERE     t04_dtl.t04_exchange <> 'TDWL'
                             AND t04_dtl.t04_security_ac_id =
                                     u07_map.old_trading_account_id -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_exchange = u07_map.exchange_code -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_symbol = m20.m20_symbol_code -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_exchange =
                                     m20.m20_exchange_code_m01 -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_custodian =
                                     m26_map.old_executing_broker_id -- Joined to Skip Not Migrated Records
                    GROUP BY t04_dtl.t04_symbol) t04_dtl,
                   (  SELECT u24.u24_symbol_code_m20,
                             SUM (u24.u24_net_holding) AS new_value
                        FROM dfn_ntp.u24_holdings u24
                    GROUP BY u24.u24_symbol_code_m20) u24
             WHERE t04_dtl.t04_symbol = u24.u24_symbol_code_m20(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T04_HOLDINGS_INTRADAY_DTL',
                     'U24_HOLDINGS',
                     'SYMBOL WISE POSITION',
                     i.t04_symbol,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [6.2.1] TDWL HOLDINGS - CUSTODIAN WISE SYMBOL POSITION

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   t04_symbol,
                   m43_custodian_id_m26
              FROM (  SELECT t04.t04_symbol,
                             m43.m43_custodian_id_m26,
                             SUM (NVL (t04.t04_net_holdings, 0)) AS old_value
                        FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04,
                             mubasher_oms.u06_routing_accounts@mubasher_db_link u06,
                             mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                             m02_institute_mappings m02_map,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_price_instrument_id_v34,
                                     m20_institute_id_m02
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 = 1) m20,
                             (SELECT m43_custodian_id_m26, m43_institute_id_m02
                                FROM dfn_ntp.m43_institute_exchanges
                               WHERE m43_exchange_code_m01 = 'TDWL') m43
                       WHERE     t04.t04_exchange = 'TDWL'
                             AND t04.t04_exchange = u06.u06_exchange
                             AND t04.t04_security_ac_id =
                                     u06.u06_security_ac_id
                             AND u06.u06_security_ac_id = u05.u05_id
                             AND u05.u05_branch_id = m02_map.old_institute_id
                             AND t04.t04_security_ac_id =
                                     u07_map.old_trading_account_id -- Joined to Skip Not Migrated Records
                             AND t04.t04_exchange = u07_map.exchange_code -- Joined to Skip Not Migrated Records
                             AND t04.t04_symbol = m20.m20_symbol_code -- Joined to Skip Not Migrated Records
                             AND t04.t04_exchange = m20.m20_exchange_code_m01 -- Joined to Skip Not Migrated Records
                             AND m02_map.new_institute_id =
                                     m43.m43_institute_id_m02 -- Joined to Skip Not Migrated Records
                    GROUP BY t04.t04_symbol, m43.m43_custodian_id_m26) t04,
                   (  SELECT u24.u24_symbol_code_m20,
                             u24.u24_custodian_id_m26,
                             SUM (NVL (u24.u24_net_holding, 0)) AS new_value
                        FROM dfn_ntp.u24_holdings u24
                       WHERE u24_exchange_code_m01 = 'TDWL'
                    GROUP BY u24.u24_symbol_code_m20,
                             u24.u24_custodian_id_m26) u24
             WHERE     t04.t04_symbol = u24.u24_symbol_code_m20(+)
                   AND t04.m43_custodian_id_m26 = u24.u24_custodian_id_m26(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES (
                        'T04_HOLDINGS_INTRADAY',
                        'U24_HOLDINGS',
                        'CUSTODIAN WISE SYMBOL POSITION',
                           'SYMBOL: '
                        || i.t04_symbol
                        || ' - CUSTODIAN: '
                        || i.m43_custodian_id_m26,
                        i.old_value,
                        i.new_value,
                        (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [6.2.2] NONE TDWL HOLDINGS - CUSTODIAN WISE SYMBOL POSITION

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   t04_symbol,
                   new_executing_broker_id
              FROM (  SELECT t04_dtl.t04_symbol,
                             m26_map.new_executing_broker_id,
                             SUM (NVL (t04_dtl.t04_net_holdings, 0))
                                 AS old_value
                        FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_price_instrument_id_v34
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20,
                             m26_executing_broker_mappings m26_map
                       WHERE     t04_dtl.t04_exchange <> 'TDWL'
                             AND t04_dtl.t04_security_ac_id =
                                     u07_map.old_trading_account_id -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_exchange = u07_map.exchange_code -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_symbol = m20.m20_symbol_code -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_exchange =
                                     m20.m20_exchange_code_m01 -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_custodian =
                                     m26_map.old_executing_broker_id -- Joined to Skip Not Migrated Records
                    GROUP BY m26_map.new_executing_broker_id,
                             t04_dtl.t04_symbol) t04_dtl,
                   (  SELECT u24.u24_symbol_code_m20,
                             u24.u24_custodian_id_m26,
                             SUM (NVL (u24.u24_net_holding, 0)) AS new_value
                        FROM dfn_ntp.u24_holdings u24
                    GROUP BY u24.u24_symbol_code_m20,
                             u24.u24_custodian_id_m26) u24
             WHERE     t04_dtl.t04_symbol = u24.u24_symbol_code_m20(+)
                   AND t04_dtl.new_executing_broker_id =
                           u24.u24_custodian_id_m26(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES (
                        'T04_HOLDINGS_INTRADAY_DTL',
                        'U24_HOLDINGS',
                        'CUSTODIAN WISE SYMBOL POSITION',
                           'SYMBOL: '
                        || i.t04_symbol
                        || ' - CUSTODIAN: '
                        || i.new_executing_broker_id,
                        i.old_value,
                        i.new_value,
                        (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [6.3.1] TDWL HOLDINGS - TRADING ACCOUNT WISE SYMBOL POSITION

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   new_trading_account_id,
                   t04_symbol
              FROM (  SELECT u07_map.new_trading_account_id,
                             t04.t04_symbol,
                             SUM (NVL (t04.t04_net_holdings, 0)) AS old_value
                        FROM mubasher_oms.t04_holdings_intraday@mubasher_db_link t04,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_price_instrument_id_v34
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20
                       WHERE     t04.t04_exchange = 'TDWL'
                             AND t04.t04_exchange = u07_map.exchange_code -- Joined to Skip Not Migrated Records
                             AND t04.t04_security_ac_id =
                                     u07_map.old_trading_account_id -- Joined to Skip Not Migrated Records
                             AND t04.t04_symbol = m20.m20_symbol_code -- Joined to Skip Not Migrated Records
                             AND t04.t04_exchange = m20.m20_exchange_code_m01 -- Joined to Skip Not Migrated Records
                    GROUP BY u07_map.new_trading_account_id, t04.t04_symbol) t04,
                   (  SELECT u24.u24_trading_acnt_id_u07,
                             u24.u24_symbol_code_m20,
                             SUM (NVL (u24.u24_net_holding, 0)) AS new_value
                        FROM dfn_ntp.u24_holdings u24
                    GROUP BY u24_trading_acnt_id_u07, u24.u24_symbol_code_m20) u24
             WHERE     t04.new_trading_account_id =
                           u24.u24_trading_acnt_id_u07(+)
                   AND t04.t04_symbol = u24.u24_symbol_code_m20(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES (
                        'T04_HOLDINGS_INTRADAY',
                        'U24_HOLDINGS',
                        'TRADING ACCOUNT WISE SYMBOL POSITION',
                           'TRADING ACC: '
                        || i.new_trading_account_id
                        || ' - SYMBOL: '
                        || i.t04_symbol,
                        i.old_value,
                        i.new_value,
                        (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [6.3.2] NONE TDWL HOLDINGS - TRADING ACCOUNT WISE SYMBOL POSITION

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   new_trading_account_id,
                   t04_symbol
              FROM (  SELECT u07_map.new_trading_account_id,
                             t04_dtl.t04_symbol,
                             SUM (t04_dtl.t04_net_holdings) AS old_value
                        FROM mubasher_oms.t04_holdings_intraday_dtl@mubasher_db_link t04_dtl,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_price_instrument_id_v34
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 = 1) m20,
                             m26_executing_broker_mappings m26_map
                       WHERE     t04_dtl.t04_exchange <> 'TDWL'
                             AND t04_dtl.t04_exchange = u07_map.exchange_code -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_security_ac_id =
                                     u07_map.old_trading_account_id -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_symbol = m20.m20_symbol_code -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_exchange =
                                     m20.m20_exchange_code_m01 -- Joined to Skip Not Migrated Records
                             AND t04_dtl.t04_custodian =
                                     m26_map.old_executing_broker_id -- Joined to Skip Not Migrated Records
                    GROUP BY u07_map.new_trading_account_id,
                             t04_dtl.t04_symbol) t04_dtl,
                   (  SELECT u24.u24_trading_acnt_id_u07,
                             u24.u24_symbol_code_m20,
                             SUM (NVL (u24.u24_net_holding, 0)) AS new_value
                        FROM dfn_ntp.u24_holdings u24
                    GROUP BY u24_trading_acnt_id_u07, u24.u24_symbol_code_m20) u24
             WHERE     t04_dtl.new_trading_account_id =
                           u24.u24_trading_acnt_id_u07(+)
                   AND t04_dtl.t04_symbol = u24.u24_symbol_code_m20(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES (
                        'T04_HOLDINGS_INTRADAY_DTL',
                        'U24_HOLDINGS',
                        'TRADING ACCOUNT WISE SYMBOL POSITION',
                           'TRADING ACC: '
                        || i.new_trading_account_id
                        || ' - SYMBOL: '
                        || i.t04_symbol,
                        i.old_value,
                        i.new_value,
                        (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [7.1] BENEFICIARY ACCOUNT [M264] - STATUS WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   map01_description
              FROM (  SELECT map01_ntp_id,
                             MAX (map01_description) AS map01_description,
                             COUNT (*) AS old_value
                        FROM (  SELECT MAX (map01_ntp_id) AS map01_ntp_id,
                                       MAX (map01_description)
                                           AS map01_description
                                  FROM mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264,
                                       u06_cash_account_mappings u06_map,
                                       dfn_ntp.u06_cash_account u06,
                                       dfn_ntp.m03_currency m03,
                                       map01_approval_status_v01 map01,
                                       m16_bank_mappings m16_map,
                                       dfn_ntp.u06_cash_account u06_cash_type
                                 WHERE     m264.m264_cash_account =
                                               u06_map.old_cash_account_id(+)
                                       AND u06_map.new_cash_account_id =
                                               u06.u06_id(+)
                                       AND u06.u06_customer_id_u01 IS NOT NULL -- Validation Added to Skip Not Migrated Records
                                       AND m264.m264_currency = m03.m03_code(+)
                                       AND (   m03.m03_id IS NOT NULL
                                            OR u06.u06_currency_id_m03
                                                   IS NOT NULL) -- [Corrective Actions Discussed]
                                       --AND m264.m264_account_number IS NOT NULL -- [Corrective Action Discussed to Add ' ' for NULL Account Numbers]
                                       AND m264.m264_status =
                                               map01.map01_oms_id(+)
                                       AND m264.m264_bank = m16_map.old_bank_id
                                       AND m264.m264_account_number =
                                               u06_cash_type.u06_display_name(+)
                              GROUP BY u06.u06_customer_id_u01,
                                       new_bank_id,
                                       m264_account_number,
                                       CASE WHEN m264_type IN (2, 3) THEN 3 END,
                                       CASE
                                           WHEN m264_type = 0
                                           THEN
                                               u06_cash_type.u06_id
                                       END)
                    GROUP BY map01_ntp_id) m264,
                   (  SELECT u08.u08_status_id_v01, COUNT (*) AS new_value
                        FROM dfn_ntp.u08_customer_beneficiary_acc u08,
                             u08_cust_benefcry_acc_mappings u08_map
                       WHERE u08.u08_id = u08_map.new_cust_benefcry_acc_id
                    GROUP BY u08.u08_status_id_v01) u08
             WHERE m264.map01_ntp_id = u08.u08_status_id_v01(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M264_BENEFICIARY_ACCOUNTS',
                     'U08_CUSTOMER_BENEFICIARY_ACC',
                     'STATUS WISE',
                     i.map01_description,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [7.2] BENEFICIARY ACCOUNT [M264] - BANK WISE

BEGIN
    FOR i
        IN (SELECT old_value, NVL (new_value, 0) AS new_value, m16_name
              FROM (  SELECT new_bank_id,
                             MAX (m16_name) AS m16_name,
                             COUNT (*) AS old_value
                        FROM (  SELECT m16_map.new_bank_id,
                                       MAX (m16.m16_name) AS m16_name
                                  FROM mubasher_oms.m264_beneficiary_accounts@mubasher_db_link m264,
                                       u06_cash_account_mappings u06_map,
                                       dfn_ntp.u06_cash_account u06,
                                       dfn_ntp.m03_currency m03,
                                       m16_bank_mappings m16_map,
                                       dfn_ntp.m16_bank m16,
                                       dfn_ntp.u06_cash_account u06_cash_type
                                 WHERE     m264.m264_cash_account =
                                               u06_map.old_cash_account_id(+)
                                       AND u06_map.new_cash_account_id =
                                               u06.u06_id(+)
                                       AND u06.u06_customer_id_u01 IS NOT NULL -- Validation Added to Skip Not Migrated Records
                                       AND m264.m264_currency = m03.m03_code(+)
                                       AND (   m03.m03_id IS NOT NULL
                                            OR u06.u06_currency_id_m03
                                                   IS NOT NULL) -- [Corrective Actions Discussed]
                                       --AND m264.m264_account_number IS NOT NULL -- [Discussed to Add ' ' for NULL Account Numbers]
                                       AND m264.m264_bank =
                                               m16_map.old_bank_id(+)
                                       AND m16_map.new_bank_id = m16.m16_id(+)
                                       AND m264.m264_account_number =
                                               u06_cash_type.u06_display_name(+)
                              GROUP BY u06.u06_customer_id_u01,
                                       new_bank_id,
                                       m264_account_number,
                                       CASE WHEN m264_type IN (2, 3) THEN 3 END,
                                       CASE
                                           WHEN m264_type = 0
                                           THEN
                                               u06_cash_type.u06_id
                                       END)
                    GROUP BY new_bank_id) m264,
                   (  SELECT u08.u08_bank_id_m16, COUNT (*) AS new_value
                        FROM dfn_ntp.u08_customer_beneficiary_acc u08,
                             u08_cust_benefcry_acc_mappings u08_map
                       WHERE u08.u08_id = u08_map.new_cust_benefcry_acc_id
                    GROUP BY u08.u08_bank_id_m16) u08
             WHERE m264.new_bank_id = u08.u08_bank_id_m16(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M264_BENEFICIARY_ACCOUNTS',
                     'U08_CUSTOMER_BENEFICIARY_ACC',
                     'BANK WISE',
                     i.m16_name,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [8.1] ORDERS - EXCHANGE WISE

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i
        IN (SELECT old_value, NVL (new_value, 0) AS new_value, exchange
              FROM (  SELECT NVL (map16.map16_ntp_code, t01_old.exchange)
                                 AS exchange,
                             COUNT (*) AS old_value
                        FROM (SELECT t01_exchange AS exchange,
                                     t01_symbol AS symbol,
                                     t01_inst_id AS inst_id,
                                     t01_m01_customer_id AS customer_id,
                                     t01_security_ac_id AS trading_acc_id
                                FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
                              UNION ALL
                              SELECT t01_exchange AS exchange,
                                     t01_symbol AS symbol,
                                     t01_inst_id AS inst_id,
                                     t01_m01_customer_id AS customer_id,
                                     t01_security_ac_id AS trading_acc_id
                                FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link
                              UNION ALL
                              SELECT t24_exchange AS exchange,
                                     t24_symbol AS symbol,
                                     old_institute_id AS inst_id,
                                     new_customer_id AS customer_id,
                                     old_trading_account_id AS trading_acc_id
                                FROM mubasher_oms.t24_pending_stocks@mubasher_db_link,
                                     map16_optional_exchanges_m01 map16,
                                     u07_trading_account_mappings u07_map,
                                     dfn_ntp.u07_trading_account u07,
                                     u01_customer_mappings u01_map,
                                     m02_institute_mappings m02_map
                               WHERE     t24_txn_type IN (13, 15) -- 13 (Right Subscriptions) & 15 (Right Reversals)
                                     AND t24_inst_id <> 0
                                     AND t24_portfolio_id =
                                             u07_map.old_trading_account_id(+)
                                     AND t24_exchange = map16.map16_oms_code(+)
                                     AND NVL (map16.map16_ntp_code,
                                              t24_exchange) =
                                             u07_map.exchange_code(+)
                                     AND u07_map.new_trading_account_id =
                                             u07.u07_id(+)
                                     AND u07.u07_customer_id_u01 =
                                             u01_map.new_customer_id(+)
                                     AND u07.u07_institute_id_m02 =
                                             m02_map.new_institute_id(+)) t01_old,
                             u01_customer_mappings u01_map,
                             map16_optional_exchanges_m01 map16,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_price_instrument_id_v34
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20
                       WHERE     t01_old.inst_id > 0
                             AND t01_old.customer_id > 0
                             AND t01_old.customer_id = u01_map.old_customer_id -- Joined to Skip Not Migrated Records
                             AND t01_old.trading_acc_id =
                                     u07_map.old_trading_account_id -- Joined to Skip Not Migrated Records
                             AND t01_old.exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, t01_old.exchange) =
                                     u07_map.exchange_code -- Joined to Skip Not Migrated Records
                             AND t01_old.symbol = m20.m20_symbol_code -- Joined to Skip Not Migrated Records
                             AND NVL (map16.map16_ntp_code, t01_old.exchange) =
                                     m20.m20_exchange_code_m01 -- Joined to Skip Not Migrated Records
                    GROUP BY NVL (map16.map16_ntp_code, t01_old.exchange)) t01_old,
                   (  SELECT t01.t01_exchange_code_m01, COUNT (*) AS new_value
                        FROM dfn_ntp.t01_order t01
                    GROUP BY t01.t01_exchange_code_m01) t01
             WHERE t01_old.exchange = t01.t01_exchange_code_m01(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T01_ORDER_SUMMARY_INTRADAY',
                     'T01_ORDER',
                     'EXCHANGE WISE',
                     i.exchange,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [8.2] ORDERS - STATUS WISE

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   v30_description
              FROM (  SELECT CASE
                                 WHEN t01_old.order_status = '$' THEN 'c'
                                 ELSE t01_old.order_status
                             END
                                 AS order_status,
                             COUNT (*) AS old_value
                        FROM (SELECT t01_exchange AS exchange,
                                     t01_symbol AS symbol,
                                     t01_inst_id AS inst_id,
                                     t01_m01_customer_id AS customer_id,
                                     t01_security_ac_id AS trading_acc_id,
                                     t01_ordstatus AS order_status
                                FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
                              UNION ALL
                              SELECT t01_exchange AS exchange,
                                     t01_symbol AS symbol,
                                     t01_inst_id AS inst_id,
                                     t01_m01_customer_id AS customer_id,
                                     t01_security_ac_id AS trading_acc_id,
                                     t01_ordstatus AS order_status
                                FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link
                              UNION ALL
                              SELECT t24_exchange AS exchange,
                                     t24_symbol AS symbol,
                                     old_institute_id AS inst_id,
                                     new_customer_id AS customer_id,
                                     old_trading_account_id AS trading_acc_id,
                                     CASE
                                         WHEN t24_status IN (1, 2, 3) THEN 'O' -- OMS ACCEPTED
                                         WHEN t24_status IN (4, 7) THEN '2' -- FILLED
                                         WHEN t24_status IN (5) THEN '4' -- CANCELLED
                                         WHEN t24_status IN (0, 6) THEN '8' -- REJECTED
                                         WHEN t24_status IN (8) THEN 'M' -- SEND TO OMS NEW
                                         WHEN t24_status IN (9) THEN 'c' -- WAITING FOR APPROVAL
                                         WHEN t24_status IN (10) THEN 'h' -- REVERSED
                                         ELSE 'C'
                                     END
                                         AS order_status
                                FROM mubasher_oms.t24_pending_stocks@mubasher_db_link,
                                     map16_optional_exchanges_m01 map16,
                                     u07_trading_account_mappings u07_map,
                                     dfn_ntp.u07_trading_account u07,
                                     u01_customer_mappings u01_map,
                                     m02_institute_mappings m02_map
                               WHERE     t24_txn_type IN (13, 15) -- 13 (Right Subscriptions) & 15 (Right Reversals)
                                     AND t24_inst_id <> 0
                                     AND t24_portfolio_id =
                                             u07_map.old_trading_account_id(+)
                                     AND t24_exchange = map16.map16_oms_code(+)
                                     AND NVL (map16.map16_ntp_code,
                                              t24_exchange) =
                                             u07_map.exchange_code(+)
                                     AND u07_map.new_trading_account_id =
                                             u07.u07_id(+)
                                     AND u07.u07_customer_id_u01 =
                                             u01_map.new_customer_id(+)
                                     AND u07.u07_institute_id_m02 =
                                             m02_map.new_institute_id(+)) t01_old,
                             u01_customer_mappings u01_map,
                             map16_optional_exchanges_m01 map16,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_price_instrument_id_v34
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20
                       WHERE     t01_old.inst_id > 0
                             AND t01_old.customer_id > 0
                             AND t01_old.customer_id = u01_map.old_customer_id -- Joined to Skip Not Migrated Records
                             AND t01_old.trading_acc_id =
                                     u07_map.old_trading_account_id -- Joined to Skip Not Migrated Records
                             AND t01_old.exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, t01_old.exchange) =
                                     u07_map.exchange_code -- Joined to Skip Not Migrated Records
                             AND t01_old.symbol = m20.m20_symbol_code -- Joined to Skip Not Migrated Records
                             AND NVL (map16.map16_ntp_code, t01_old.exchange) =
                                     m20.m20_exchange_code_m01 -- Joined to Skip Not Migrated Records
                    GROUP BY CASE
                                 WHEN t01_old.order_status = '$' THEN 'c'
                                 ELSE t01_old.order_status
                             END) t01_old,
                   (  SELECT t01.t01_status_id_v30,
                             MAX (v30.v30_description) AS v30_description,
                             COUNT (*) AS new_value
                        FROM dfn_ntp.t01_order t01,
                             dfn_ntp.v30_order_status v30
                       WHERE t01.t01_status_id_v30 = v30.v30_status_id
                    GROUP BY t01.t01_status_id_v30) t01
             WHERE t01_old.order_status = t01.t01_status_id_v30(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T01_ORDER_SUMMARY_INTRADAY',
                     'T01_ORDER',
                     'ORDER STATUS WISE',
                     i.v30_description,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [8.3] ORDERS - SYMBOL WISE OPEN ORDERS

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i
        IN (SELECT old_value, NVL (new_value, 0) AS new_value, symbol
              FROM (  SELECT t01_old.symbol, COUNT (*) AS old_value
                        FROM (SELECT t01_exchange AS exchange,
                                     t01_symbol AS symbol,
                                     t01_inst_id AS inst_id,
                                     t01_m01_customer_id AS customer_id,
                                     t01_security_ac_id AS trading_acc_id,
                                     t01_ordstatus AS order_status
                                FROM mubasher_oms.t01_order_summary_intraday@mubasher_db_link
                              UNION ALL
                              SELECT t01_exchange AS exchange,
                                     t01_symbol AS symbol,
                                     t01_inst_id AS inst_id,
                                     t01_m01_customer_id AS customer_id,
                                     t01_security_ac_id AS trading_acc_id,
                                     t01_ordstatus AS order_status
                                FROM mubasher_oms.t01_order_summary_intraday_arc@mubasher_db_link
                              UNION ALL
                              SELECT t24_exchange AS exchange,
                                     t24_symbol AS symbol,
                                     old_institute_id AS inst_id,
                                     new_customer_id AS customer_id,
                                     old_trading_account_id AS trading_acc_id,
                                     CASE
                                         WHEN t24_status IN (1, 2, 3) THEN 'O' -- OMS ACCEPTED
                                         WHEN t24_status IN (4, 7) THEN '2' -- FILLED
                                         WHEN t24_status IN (5) THEN '4' -- CANCELLED
                                         WHEN t24_status IN (0, 6) THEN '8' -- REJECTED
                                         WHEN t24_status IN (8) THEN 'M' -- SEND TO OMS NEW
                                         WHEN t24_status IN (9) THEN 'c' -- WAITING FOR APPROVAL
                                         WHEN t24_status IN (10) THEN 'h' -- REVERSED
                                         ELSE 'C'
                                     END
                                         AS order_status
                                FROM mubasher_oms.t24_pending_stocks@mubasher_db_link,
                                     map16_optional_exchanges_m01 map16,
                                     u07_trading_account_mappings u07_map,
                                     dfn_ntp.u07_trading_account u07,
                                     u01_customer_mappings u01_map,
                                     m02_institute_mappings m02_map
                               WHERE     t24_txn_type IN (13, 15) -- 13 (Right Subscriptions) & 15 (Right Reversals)
                                     AND t24_inst_id <> 0
                                     AND t24_portfolio_id =
                                             u07_map.old_trading_account_id(+)
                                     AND t24_exchange = map16.map16_oms_code(+)
                                     AND NVL (map16.map16_ntp_code,
                                              t24_exchange) =
                                             u07_map.exchange_code(+)
                                     AND u07_map.new_trading_account_id =
                                             u07.u07_id(+)
                                     AND u07.u07_customer_id_u01 =
                                             u01_map.new_customer_id(+)
                                     AND u07.u07_institute_id_m02 =
                                             m02_map.new_institute_id(+)) t01_old,
                             u01_customer_mappings u01_map,
                             map16_optional_exchanges_m01 map16,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_code_m01,
                                     m20_price_instrument_id_v34
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20
                       WHERE     t01_old.inst_id > 0
                             AND t01_old.customer_id > 0
                             AND t01_old.customer_id = u01_map.old_customer_id -- Joined to Skip Not Migrated Records
                             AND t01_old.trading_acc_id =
                                     u07_map.old_trading_account_id -- Joined to Skip Not Migrated Records
                             AND t01_old.exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, t01_old.exchange) =
                                     u07_map.exchange_code -- Joined to Skip Not Migrated Records
                             AND t01_old.symbol = m20.m20_symbol_code -- Joined to Skip Not Migrated Records
                             AND NVL (map16.map16_ntp_code, t01_old.exchange) =
                                     m20.m20_exchange_code_m01 -- Joined to Skip Not Migrated Records
                             AND order_status IN
                                     ('0',
                                      '1',
                                      '5',
                                      '6',
                                      'A',
                                      'a',
                                      'c',
                                      '$', -- added as '$' status migrated ac 'c' status
                                      'E',
                                      'K',
                                      'M',
                                      'O',
                                      'P',
                                      'Q',
                                      'T',
                                      'Z',
                                      '%',
                                      '^',
                                      '*')
                    GROUP BY t01_old.symbol) t01_old,
                   (  SELECT t01.t01_symbol_code_m20, COUNT (*) AS new_value
                        FROM dfn_ntp.t01_order t01
                       WHERE t01_status_id_v30 IN
                                 ('0',
                                  '1',
                                  '5',
                                  '6',
                                  'A',
                                  'a',
                                  'c',
                                  'E',
                                  'K',
                                  'M',
                                  'O',
                                  'P',
                                  'Q',
                                  'T',
                                  'Z',
                                  '%',
                                  '^',
                                  '*')
                    GROUP BY t01.t01_symbol_code_m20) t01
             WHERE t01_old.symbol = t01.t01_symbol_code_m20(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T01_ORDER_SUMMARY_INTRADAY',
                     'T01_ORDER',
                     'SYMBOL WISE OPEN ORDERS',
                     i.symbol,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [9] CASH TRANSACTIONS - STATUS WISE

BEGIN
    FOR i
        IN (SELECT old_value, NVL (new_value, 0) AS new_value, status
              FROM (  SELECT old_correct_status_id,
                             MAX (status) AS status,
                             COUNT (*) AS old_value
                        FROM (SELECT t12_id,
                                     CASE
                                         WHEN t12_status = 0 THEN 1 -- PENDING
                                         WHEN t12_status = 1 THEN 101 -- L1 APPROVED
                                         WHEN t12_status = 2 THEN 2 -- APPROVED
                                         WHEN t12_status = 3 THEN 19 -- CANCELLED
                                         WHEN t12_status = 5 THEN 3 -- REJECTED
                                         WHEN t12_status = 6 THEN 7 -- SENT TO BANK
                                         ELSE -1
                                     END
                                         AS old_correct_status_id,
                                     CASE
                                         WHEN t12_status = 0
                                         THEN
                                             'PENDING'
                                         WHEN t12_status = 1
                                         THEN
                                             'APPROVED L1'
                                         WHEN t12_status = 2
                                         THEN
                                             'APPROVED'
                                         WHEN t12_status = 3
                                         THEN
                                             'CANCELLED'
                                         WHEN t12_status = 5
                                         THEN
                                             'REJECTED'
                                         WHEN t12_status = 6
                                         THEN
                                             'SENT TO BANK'
                                     END
                                         AS status,
                                     t12.t12_cash_account_id,
                                     t12.t12_code,
                                     t12.t12_transaction_currency,
                                     t12.t12_request_channel
                                FROM mubasher_oms.t12_pending_cash@mubasher_db_link t12
                               WHERE t12.t12_status NOT IN (4, 7, 8, 9, 10, 24) -- [Corrective Actions Discussed] (7, 8, 9 Not Captured in OMS Code)
                                                                               ) t12,
                             u06_cash_account_mappings u06_map,
                             map15_transaction_codes_m97 map15,
                             dfn_ntp.m03_currency m03,
                             dfn_ntp.m88_function_approval m88
                       WHERE     t12.t12_cash_account_id =
                                     u06_map.old_cash_account_id -- Joined to Skip Not Migrated Records
                             AND TRIM (t12.t12_code) = map15.map15_oms_code(+)
                             AND map15.map15_ntp_code IS NOT NULL
                             AND t12.t12_transaction_currency = m03.m03_code(+) -- If Null Cash Acc Currency Used
                             AND old_correct_status_id <> -1
                             AND TRIM (t12.t12_code) = map15.map15_oms_code(+)
                             AND map15.map15_ntp_code = m88.m88_txn_code(+) -- Validation By Passed to Migrate Transactions
                             AND NVL (t12.t12_request_channel, -1) =
                                     m88.m88_channel_id_v29(+) -- Joined to Skip Not Migrated Records
                    GROUP BY old_correct_status_id) t12,
                   (  SELECT t06.t06_status_id, COUNT (*) AS new_value
                        FROM dfn_ntp.t06_cash_transaction t06
                    GROUP BY t06.t06_status_id) t06
             WHERE t12.old_correct_status_id = t06.t06_status_id(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T12_PENDING_CASH',
                     'T06_CASH_TRANSACTION',
                     'STATUS WISE',
                     i.status,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [10] HOLDING TRANSACTIONS - STATUS WISE

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   map01_description
              FROM (  SELECT map01.map01_ntp_id AS map01_ntp_id,
                             MAX (map01.map01_description) AS map01_description,
                             COUNT (*) AS old_value
                        FROM (SELECT t24.t24_id,
                                     CASE
                                         WHEN t24_status = 1 THEN 1 -- PENDING
                                         WHEN t24_status = 3 THEN 6 -- L1 APPROVED
                                         WHEN t24_status = 4 THEN 7 -- L2 APPROVED
                                         WHEN t24_status = 5 THEN 19 -- CANCELLED
                                         WHEN t24_status = 6 THEN 3 -- REJECTED
                                         WHEN t24_status = 8 THEN 22 -- SEND TO EXCHANGE
                                         WHEN t24_status IN (0, 9, 10) THEN 3 -- [Corrective Actions Discussed] (0, 9 & 10 Migrating as REJECTED)
                                         ELSE -1
                                     END
                                         AS old_correct_status_id,
                                     t24.t24_portfolio_id,
                                     t24.t24_exchange,
                                     t24.t24_symbol
                                FROM mubasher_oms.t24_pending_stocks@mubasher_db_link t24
                               WHERE     t24.t24_inst_id <> 0 -- [Corrective Actions Discussed]
                                     AND t24.t24_txn_type NOT IN (13, 15) -- 13 (Right Subscriptions) WIll be Captured as Orders | 15 (Right Reversals) Will be Ignored While Capturing Subscriptions [Sandamal To Do]
                                     AND (   REGEXP_LIKE (t24_reference_no,
                                                          '^-?[0-9]+$')
                                          OR t24_reference_no IS NULL) -- Validation Added to Skip Not Migrated Records
                                                                      ) t24,
                             map16_optional_exchanges_m01 map16,
                             u07_trading_account_mappings u07_map,
                             (SELECT m20_id,
                                     m20_symbol_code,
                                     m20_exchange_id_m01,
                                     m20_exchange_code_m01
                                FROM dfn_ntp.m20_symbol
                               WHERE m20_institute_id_m02 =
                                         l_primary_institute_id) m20,
                             map01_approval_status_v01 map01
                       WHERE     t24.t24_portfolio_id =
                                     u07_map.old_trading_account_id -- Joined to Skip Not Migrated Records
                             AND t24.t24_exchange = map16.map16_oms_code(+)
                             AND NVL (map16.map16_ntp_code, t24.t24_exchange) =
                                     u07_map.exchange_code -- Joined to Skip Not Migrated Records
                             AND t24.t24_symbol = m20.m20_symbol_code -- Joined to Skip Not Migrated Records
                             AND NVL (map16.map16_ntp_code, t24.t24_exchange) =
                                     m20.m20_exchange_code_m01 -- Joined to Skip Not Migrated Records
                             AND old_correct_status_id = map01.map01_oms_id(+)
                    GROUP BY map01.map01_ntp_id) t12,
                   (  SELECT t12.t12_status_id_v01, COUNT (*) AS new_value
                        FROM dfn_ntp.t12_share_transaction t12
                    GROUP BY t12.t12_status_id_v01) t12
             WHERE t12.map01_ntp_id = t12.t12_status_id_v01(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T24_PENDING_STOCKS',
                     'T12_SHARE_TRANSACTION',
                     'STATUS WISE',
                     i.map01_description,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [11] PLEDGE TRANSACTIONS - STATUS WISE

DECLARE
    l_broker_id              NUMBER;
    l_primary_institute_id   NUMBER;
BEGIN
    SELECT VALUE
      INTO l_broker_id
      FROM migration_params
     WHERE code = 'BROKERAGE_ID';

    SELECT m150.m150_primary_institute_id_m02
      INTO l_primary_institute_id
      FROM dfn_ntp.m150_broker m150
     WHERE m150.m150_id = l_broker_id;

    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   map01_description
              FROM (  SELECT map01.map01_ntp_id AS map01_ntp_id,
                             MAX (map01.map01_description) AS map01_description,
                             COUNT (*) AS old_value
                        FROM (SELECT t17.t17_id,
                                     CASE
                                         WHEN t17_status = 0 THEN 1 -- PENDING
                                         WHEN t17_status = 1 THEN 6 -- L1 APPROVED
                                         WHEN t17_status = 2 THEN 7 -- L2 APPROVED
                                         WHEN t17_status = 3 THEN 3 -- REJECTED
                                         WHEN t17_status = 4 THEN 22 -- SEND TO EXCHANGE
                                         ELSE -1
                                     END
                                         AS old_correct_status_id
                                FROM mubasher_oms.t17_pending_pledge@mubasher_db_link t17,
                                     mubasher_oms.u05_security_accounts@mubasher_db_link u05,
                                     map16_optional_exchanges_m01 map16,
                                     u07_trading_account_mappings u07_map,
                                     (SELECT m20_id,
                                             m20_symbol_code,
                                             m20_exchange_code_m01
                                        FROM dfn_ntp.m20_symbol
                                       WHERE m20_institute_id_m02 =
                                                 l_primary_institute_id) m20
                               WHERE     t17.t17_security_ac_id = u05.u05_id
                                     AND u05.u05_branch_id > 0
                                     AND t17.t17_pledge_type NOT IN
                                             ('C', '1', '0') -- [Corrective Actions Discussed]
                                     AND t17_pledge_type IN ('I', 'O') -- Validation Added to Skip Not Migrated Records
                                     AND t17.t17_security_ac_id =
                                             u07_map.old_trading_account_id -- Joined to Skip Not Migrated Records
                                     AND t17.t17_exchange =
                                             map16.map16_oms_code(+)
                                     AND NVL (map16.map16_ntp_code,
                                              t17.t17_exchange) =
                                             u07_map.exchange_code -- Joined to Skip Not Migrated Records
                                     AND NVL (map16.map16_ntp_code,
                                              t17.t17_exchange) =
                                             m20.m20_exchange_code_m01 -- Joined to Skip Not Migrated Records
                                     AND t17.t17_symbol = m20.m20_symbol_code -- Joined to Skip Not Migrated Records
                                                                             ) t17,
                             map01_approval_status_v01 map01
                       WHERE t17.old_correct_status_id = map01.map01_oms_id(+)
                    GROUP BY map01.map01_ntp_id) t17,
                   (  SELECT t20.t20_status_id_v01, COUNT (*) AS new_value
                        FROM dfn_ntp.t20_pending_pledge t20
                    GROUP BY t20.t20_status_id_v01) t20
             WHERE t17.map01_ntp_id = t20.t20_status_id_v01(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T17_PENDING_PLEDGE',
                     'T20_PENDING_PLEDGE',
                     'STATUS WISE',
                     i.map01_description,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

/*Janaka: Will be Handled from ETI Migration
-- [12.1] PRICE/PRODUCT SUBSCRIPTION - PRODUCT WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   m152_product_name
              FROM (  SELECT m152_map.new_product_id,
                             MAX (m152.m152_product_name) AS m152_product_name,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.t73_cust_subscribe_prd@mubasher_db_link t73,
                             mubasher_oms.m236_price_subscription_fees@mubasher_db_link m236,
                             m152_prd_subs_many_to_one_map m152_many_to_one,
                             m152_products_mappings m152_map,
                             dfn_ntp.m152_products m152
                       WHERE     t73.t73_fee_id =
                                     m152_many_to_one.from_subs_prd_id(+)
                             AND m152_many_to_one.to_subs_prd_id =
                                     m236.m236_id(+)
                             AND m236.m236_id = m152_map.old_product_id -- Joined to Skip Not Migrated Records
                             AND m152_map.new_product_id = m152.m152_id -- Joined to Skip Not Migrated Records
                    GROUP BY m152_map.new_product_id) t73,
                   (  SELECT t56.t56_product_id_m152, COUNT (*) AS new_value
                        FROM dfn_ntp.t56_product_subscription_data t56
                    GROUP BY t56.t56_product_id_m152) t56
             WHERE t73.new_product_id = t56.t56_product_id_m152(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T73_CUST_SUBSCRIBE_PRD',
                     'T56_PRODUCT_SUBSCRIPTION_DATA',
                     'PRODUCT WISE',
                     i.m152_product_name,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [12.2] EXCHANGE PRICE/PRODUCT SUBSCRIPTION - EXCHANGE PRODUCT WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   exchange_product
              FROM (  SELECT m153_map.new_exg_subs_prd_id,
                                MAX (
                                    NVL (map16.map16_ntp_code,
                                         m153.m153_exchange_code_m01))
                             || '-'
                             || m153_map.new_exg_subs_prd_id
                                 AS exchange_product,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.t73_cust_subscribe_prd@mubasher_db_link t73,
                             mubasher_oms.m236_price_subscription_fees@mubasher_db_link m236,
                             m153_exg_subs_prd_mappings m153_map,
                             dfn_ntp.m153_exchange_subscription_prd m153,
                             map16_optional_exchanges_m01 map16
                       WHERE     t73.t73_fee_id = m236.m236_id(+)
                             AND m236.m236_id = m153_map.old_exg_subs_prd_id -- Joined to Skip Not Migrated Records
                             AND m153_map.new_exg_subs_prd_id = m153.m153_id -- Joined to Skip Not Migrated Records
                             AND m153.m153_exchange_code_m01 =
                                     map16.map16_oms_code(+)
                    GROUP BY m153_map.new_exg_subs_prd_id) t73,
                   (  SELECT t57.t57_exchange_product_id_m153,
                             COUNT (*) AS new_value
                        FROM dfn_ntp.t57_exchange_subscription_data t57
                    GROUP BY t57.t57_exchange_product_id_m153) t57
             WHERE t73.new_exg_subs_prd_id =
                       t57.t57_exchange_product_id_m153(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('T73_CUST_SUBSCRIBE_PRD',
                     'T57_EXCHANGE_SUBSCRIPTION_DATA',
                     'EXCHANGE PRODUCT WISE',
                     i.exchange_product,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/
*/

-- [13.1] SYMBOL - EXCHANGE WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   NVL (map16.map16_ntp_code, m77.m77_exchange) AS exchange
              FROM (  SELECT m77.m77_exchange, COUNT (*) AS old_value
                        FROM mubasher_oms.m77_symbols@mubasher_db_link m77
                    GROUP BY m77.m77_exchange) m77,
                   map16_optional_exchanges_m01 map16,
                   (  SELECT m20.m20_exchange_code_m01, COUNT (*) AS new_value
                        FROM dfn_ntp.m20_symbol m20
                    GROUP BY m20.m20_exchange_code_m01) m20
             WHERE     m77.m77_exchange = map16.map16_oms_code(+)
                   AND NVL (map16.map16_ntp_code, m77.m77_exchange) =
                           m20.m20_exchange_code_m01(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M77_SYMBOLS',
                     'M20_SYMBOL',
                     'EXCHANGE WISE',
                     i.exchange,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [13.2] SYMBOL - ISIN WISE

BEGIN
    FOR i
        IN (SELECT old_value, NVL (new_value, 0) AS new_value, m77_isincode
              FROM (  SELECT m77.m77_isincode, COUNT (*) AS old_value
                        FROM mubasher_oms.m77_symbols@mubasher_db_link m77
                    GROUP BY m77.m77_isincode) m77,
                   (  SELECT m20.m20_isincode, COUNT (*) AS new_value
                        FROM dfn_ntp.m20_symbol m20
                    GROUP BY m20.m20_isincode) m20
             WHERE    m77.m77_isincode = m20.m20_isincode
                   OR (m77.m77_isincode IS NULL AND m20.m20_isincode IS NULL))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M77_SYMBOLS',
                     'M20_SYMBOL',
                     'ISIN WISE',
                     i.m77_isincode,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [13.3] SYMBOL - RIC WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   m77_reuters_code
              FROM (  SELECT m77.m77_reuters_code, COUNT (*) AS old_value
                        FROM mubasher_oms.m77_symbols@mubasher_db_link m77
                    GROUP BY m77.m77_reuters_code) m77,
                   (  SELECT m20.m20_reuters_code, COUNT (*) AS new_value
                        FROM dfn_ntp.m20_symbol m20
                    GROUP BY m20.m20_reuters_code) m20
             WHERE    m77.m77_reuters_code = m20.m20_reuters_code
                   OR (    m77.m77_reuters_code IS NULL
                       AND m20.m20_reuters_code IS NULL))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M77_SYMBOLS',
                     'M20_SYMBOL',
                     'RIC WISE',
                     i.m77_reuters_code,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/

-- [14] DEALER ACCOUNT - STATUS WISE

BEGIN
    FOR i
        IN (SELECT old_value,
                   NVL (new_value, 0) AS new_value,
                   map01_description
              FROM (  SELECT map01.map01_ntp_id,
                             MAX (map01.map01_description) AS map01_description,
                             COUNT (*) AS old_value
                        FROM mubasher_oms.m06_employees@mubasher_db_link m06,
                             mubasher_oms.m71_employee_subtype@mubasher_db_link m71,
                             mubasher_oms.m70_employee_type@mubasher_db_link m70,
                             map01_approval_status_v01 map01
                       WHERE     m06.m06_employee_subtype = m71.m71_id
                             AND m71.m71_employee_type = m70.m70_id
                             AND m70.m70_id = 3 -- Dealer
                             AND m06.m06_status_id = map01.map01_oms_id
                    GROUP BY map01.map01_ntp_id) m06,
                   (  SELECT u17.u17_status_id_v01, COUNT (*) AS new_value
                        FROM dfn_ntp.u17_employee u17,
                             dfn_ntp.m11_employee_type m11
                       WHERE     u17.u17_type_id_m11 = m11.m11_id
                             AND m11.m11_category = 2 -- Dealer
                    GROUP BY u17.u17_status_id_v01) u17
             WHERE m06.map01_ntp_id = u17.u17_status_id_v01(+))
    LOOP
        INSERT INTO sfc_data_verification (source_table,
                                           target_table,
                                           verification_condition,
                                           verification_value,
                                           old_value,
                                           new_value,
                                           difference)
             VALUES ('M06_EMPLOYEES',
                     'U17_EMPLOYEE',
                     'DEALERS STATUS WISE',
                     i.map01_description,
                     i.old_value,
                     i.new_value,
                     (i.new_value - i.old_value));
    END LOOP;
END;
/
