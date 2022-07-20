CREATE OR REPLACE PROCEDURE dfn_ntp.sp_job_schedular_action (
    get_job_name   IN     VARCHAR2,
    pstat             OUT NUMBER,
    pmsg              OUT VARCHAR2)
IS
    i_errorcode      VARCHAR2 (4000);
    i_errormessage   VARCHAR2 (4000);
    l_is_one_time    NUMBER (1) := 0;
    l_count          NUMBER (1) := 0;
BEGIN
    pstat := 1;
    pmsg := get_job_name || ' - ' || 'succeeded!';

    --Verify JOB Configuration and throw exception if not in job master

    SELECT COUNT (*)
      INTO l_count
      FROM v07_db_jobs a
     WHERE a.v07_job_name = get_job_name;

    IF (l_count = 0)
    THEN
        pstat := 0;
        pmsg := get_job_name || ' - Not Defined in Job Master Table!';
        RETURN; -- terminate execution
    END IF;

    --Verify JOB execution count by Configuration

    SELECT COUNT (*)
      INTO l_is_one_time
      FROM v07_db_jobs a
     WHERE     a.v07_job_name = get_job_name
           AND TRUNC (v07_last_success_date) = TRUNC (SYSDATE)
           AND v07_is_one_time = 1;

    IF (l_is_one_time = 1)
    THEN
        pstat := 0;
        pmsg := get_job_name || ' Already Executed Once successfully!.';
        RETURN; -- terminate execution
    END IF;

    --DFN_NTP.APPLY_POSITION_BLOCKS

    IF (get_job_name = 'APPLY_POSITION_BLOCKS')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_apply_position_blocks; END;';
    --DFN_NTP.ARCHIVE_TABLE_DATA

    ELSIF (get_job_name = 'ARCHIVE_TABLE_DATA') -- check and enable
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_archive_table_data; END;';
    --DFN_NTP.BOND_MATURITY

    ELSIF (get_job_name = 'BOND_MATURITY')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_process_bond_maturity;  END;';
    --DFN_NTP.CALCULATE_CUSTODY_CHARGES

    ELSIF (get_job_name = 'CALCULATE_CUSTODY_CHARGES')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_calculate_custody_charges; END;';
    --DFN_NTP.CALCULATE_INT_CHARGES_LOCAL

    ELSIF (get_job_name = 'CALCULATE_INT_CHARGES_LOCAL')
    THEN
        EXECUTE IMMEDIATE
            'BEGIN dfn_ntp.job_calculate_int_charg_locl_b; END;';
    --DFN_NTP.CALCULATE_INT_CHARGES_LOCAL

    ELSIF (get_job_name = 'CALCULATE_INT_CHARGES_INTL')
    THEN
        EXECUTE IMMEDIATE
            'BEGIN dfn_ntp.job_calculate_int_charg_intl_b; END;';
    --DFN_NTP.CAPITALIZE_CUSTODY_CHARGES

    ELSIF (get_job_name = 'CAPITALIZE_CUSTODY_CHARGES')
    THEN
        EXECUTE IMMEDIATE
            'BEGIN dfn_ntp.job_capitalize_custody_charges; END;';
    --DFN_NTP.CAPITALIZE_INT_CHARGES_LOCAL

    ELSIF (get_job_name = 'CAPITALIZE_INT_CHARGES_LOCAL')
    THEN
        EXECUTE IMMEDIATE
            'BEGIN dfn_ntp.job_capitalz_int_charge_locl_b; END;';
    --DFN_NTP.CAPITALIZE_INT_CHARGES_INTL
    ELSIF (get_job_name = 'CAPITALIZE_INT_CHARGES_INTL')
    THEN
        EXECUTE IMMEDIATE
            'BEGIN dfn_ntp.job_capitalz_int_charge_intl_b; END;';
    --DFN_NTP.DISABLE_TRADING_FOR_RHT

    ELSIF (get_job_name = 'DISABLE_TRADING_FOR_RHT')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_disable_trading_for_rht; END;';
    --DFN_NTP.DISABLE_TRANSACTION

    ELSIF (get_job_name = 'DISABLE_TRANSACTION')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_disable_transaction; END;';
    --DFN_NTP.ENABLE_TRANSACTION

    ELSIF (get_job_name = 'ENABLE_TRANSACTION')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_enable_transaction; END;';
    --DFN_NTP.EOD_TRADE_CONFIRM_ACTIVITY

    ELSIF (get_job_name = 'EOD_TRADE_CONFIRM_ACTIVITY')
    THEN
        EXECUTE IMMEDIATE
            'BEGIN dfn_ntp.job_eod_trade_confirm_activity; END;';
    --DFN_NTP.M2M_PROFIT_CALCULATION

    ELSIF (get_job_name = 'M2M_PROFIT_CALCULATION')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_m2m_profit_calculation; END;';
    --DFN_NTP.MARGIN_FUNDING_COVERING_LOCAL

    ELSIF (get_job_name = 'MARGIN_FUNDING_COVERING_LOCAL')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_margin_fund_cover_locl_b; END;';
    --DFN_NTP.MARGIN_FUNDING_COVERING_INTL

    ELSIF (get_job_name = 'MARGIN_FUNDING_COVERING_INTL')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_margin_fund_cover_intl_b; END;';
    --DFN_NTP.MARGIN_TRD_NOTIFICATION

    ELSIF (get_job_name = 'MARGIN_TRD_NOTIFICATION')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_margin_trd_notification; END;';
    --DFN_NTP.NOTIFY_ORDER_LIMIT_BREACH

    ELSIF (get_job_name = 'NOTIFY_ORDER_LIMIT_BREACH')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_notify_order_limit_breach; END;';
    --DFN_NTP.NOTIFY_TRADABLE_RIGHTS_SMS

    ELSIF (get_job_name = 'NOTIFY_TRADABLE_RIGHTS_SMS')
    THEN
        EXECUTE IMMEDIATE
            'BEGIN dfn_ntp.job_notify_tradable_rights_sms; END;';
    --DFN_NTP.POPULATE_EOD_PRICES

    ELSIF (get_job_name = 'POPULATE_EOD_PRICES')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_populate_eod_prices; END;';
    --DFN_NTP.POPULATE_HISTORY_TABLES

    ELSIF (get_job_name = 'POPULATE_HISTORY_TABLES')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_populate_history_tables; END;';
    --DFN_NTP.POPULATE_REPORT_SUMMARY_TABLES

    ELSIF (get_job_name = 'POPULATE_REPORT_SUMMARY_TABLES')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_populate_rpt_summary_tbls; END;';
    --DFN_NTP.UPDATE_CASH_ACCOUNTS

    ELSIF (get_job_name = 'UPDATE_CASH_ACCOUNTS')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_update_cash_accounts; END;';
    --DFN_NTP.UPDATE_CUSTOMERS

    ELSIF (get_job_name = 'UPDATE_CUSTOMERS')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_update_customers; END;';
    --DFN_NTP.UPDATE_INCENTIVE

    ELSIF (get_job_name = 'UPDATE_INCENTIVE')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_update_incentive; END;';
    --DFN_NTP.UPDATE_MASTER_DATA

    ELSIF (get_job_name = 'UPDATE_MASTER_DATA')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_update_master_data; END;';
    --DFN_NTP.UPDATE_OMINI_BANK_BALANCES

    ELSIF (get_job_name = 'UPDATE_OMINI_BANK_BALANCES')
    THEN
        EXECUTE IMMEDIATE
            'BEGIN dfn_ntp.job_update_omini_bank_balances; END;';
    --DFN_NTP.UPDATE_PENDING_CASH

    ELSIF (get_job_name = 'UPDATE_PENDING_CASH')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_update_pending_cash; END;';
    --DFN_NTP.UPDATE_PENDING_CASH_EOD

    ELSIF (get_job_name = 'UPDATE_PENDING_CASH_EOD')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_update_pending_cash_eod; END;';
    --DFN_NTP.UPDATE_PENDING_HOLDING

    ELSIF (get_job_name = 'UPDATE_PENDING_HOLDING')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_update_pending_holding; END;';
    --DFN_NTP.UPDATE_PENDING_HOLDING_EOD

    ELSIF (get_job_name = 'UPDATE_PENDING_HOLDING_EOD')
    THEN
        EXECUTE IMMEDIATE
            'BEGIN dfn_ntp.job_update_pending_holding_eod; END;';
    --DFN_NTP.UPDATE_SYMBOL_DATA

    ELSIF (get_job_name = 'UPDATE_SYMBOL_DATA')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_update_symbol_data; END;';
    --DFN_NTP.CUSTODY_EXECB_SETTLEMENT

    ELSIF (get_job_name = 'CUSTODY_EXECB_SETTLEMENT')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_custody_execb_settlement; END;';
    --DFN_NTP.PORTFOLIO_VALUATION_B

    ELSIF (get_job_name = 'PORTFOLIO_VALUATION_B')
    THEN
        EXECUTE IMMEDIATE
            'BEGIN dfn_ntp.job_populate_portfolio_value_b; END;';
    --DFN_NTP.DERIVATIVE_SYMBOL_EXPIRY
    ELSIF (get_job_name = 'DERIVATIVE_SYMBOL_EXPIRY')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_derivative_symbol_expiry; END;';
    --DFN_NTP.DAILY_OWNED_HOLDING_B
    ELSIF (get_job_name = 'DAILY_OWNED_HOLDING_B')
    THEN
        EXECUTE IMMEDIATE
            'BEGIN dfn_ntp.job_populat_daily_owned_hold_b; END;';
    ELSIF (get_job_name = 'LB_ACCOUNTING_ENTRIES')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_lb_accounting_entries_b; END;';
    ELSIF (get_job_name = 'LB_ACCOUNTING_PRE_VALIDATION')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_lb_gl_pre_validation_b; END;';
    ELSIF (get_job_name = 'EOD_CASH_TRN_FEE_BULK_UPDATE_FTB_B')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_eod_csh_fee_blk_b2b_b; END;';
	ELSIF (get_job_name = 'OMS_CACHE_UPDATE')
    THEN
        EXECUTE IMMEDIATE 'BEGIN dfn_ntp.job_oms_cache_update; END;';
    END IF;
EXCEPTION
    WHEN OTHERS
    THEN
        pstat := 0;
        i_errorcode := SQLCODE;
        i_errormessage :=
               get_job_name
            || ' - '
            || TO_CHAR (i_errorcode, '9999.9')
            || SUBSTR (SQLERRM, 1, 200);
        pmsg := i_errorcode;
        raise_application_error (-20101, i_errormessage);
END;
/