---------------------------- CORE ----------------------------

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'APPLY_POSITION_BLOCKS';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'APPLY_POSITION_BLOCKS');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'ARCHIVE_TABLE_DATA';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'ARCHIVE_TABLE_DATA');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'BOND_MATURITY';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'BOND_MATURITY');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'CALCULATE_CUSTODY_CHARGES';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'CALCULATE_CUSTODY_CHARGES');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'CALCULATE_INT_CHARGES';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'CALCULATE_INT_CHARGES');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'CALCULATE_INT_CHARGES_INTL';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'CALCULATE_INT_CHARGES_INTL');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'CALCULATE_INT_CHARGES_LOCAL';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'CALCULATE_INT_CHARGES_LOCAL');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'CAPITALIZE_CUSTODY_CHARGES';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'CAPITALIZE_CUSTODY_CHARGES');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'CAPITALIZE_INT_CHARGES';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'CAPITALIZE_INT_CHARGES');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'CAPITALIZE_INT_CHARGES_INTL';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'CAPITALIZE_INT_CHARGES_INTL');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'CAPITALIZE_INT_CHARGES_LOCAL';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'CAPITALIZE_INT_CHARGES_LOCAL');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'CUSTODY_EXECB_SETTLEMENT';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'CUSTODY_EXECB_SETTLEMENT');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'DAILY_OWNED_HOLDING_B';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'DAILY_OWNED_HOLDING_B');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'DERIVATIVE_SYMBOL_EXPIRY';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'DERIVATIVE_SYMBOL_EXPIRY');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'DISABLE_TRADING_FOR_RHT';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'DISABLE_TRADING_FOR_RHT');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'DISABLE_TRANSACTION';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'DISABLE_TRANSACTION');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'ENABLE_TRANSACTION';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'ENABLE_TRANSACTION');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'EOD_TRADE_CONFIRM_ACTIVITY';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'EOD_TRADE_CONFIRM_ACTIVITY');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'M2M_PROFIT_CALCULATION';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'M2M_PROFIT_CALCULATION');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'MARGIN_FUNDING_COVERING';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'MARGIN_FUNDING_COVERING');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'MARGIN_FUNDING_COVERING_INTL';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'MARGIN_FUNDING_COVERING_INTL');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'MARGIN_FUNDING_COVERING_LOCAL';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'MARGIN_FUNDING_COVERING_LOCAL');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'MARGIN_TRD_NOTIFICATION';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'MARGIN_TRD_NOTIFICATION');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'NOTIFY_ORDER_LIMIT_BREACH';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'NOTIFY_ORDER_LIMIT_BREACH');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'NOTIFY_TRADABLE_RIGHTS_SMS';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'NOTIFY_TRADABLE_RIGHTS_SMS');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'POPULATE_EOD_PRICES';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'POPULATE_EOD_PRICES');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'POPULATE_HISTORY_TABLES';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'POPULATE_HISTORY_TABLES');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'POPULATE_REPORT_SUMMARY_TABLES';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'POPULATE_REPORT_SUMMARY_TABLES');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'UPDATE_CASH_ACCOUNTS';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'UPDATE_CASH_ACCOUNTS');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'UPDATE_CUSTOMERS';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'UPDATE_CUSTOMERS');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'UPDATE_INCENTIVE';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'UPDATE_INCENTIVE');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'UPDATE_MASTER_DATA';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'UPDATE_MASTER_DATA');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'UPDATE_OMINI_BANK_BALANCES';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'UPDATE_OMINI_BANK_BALANCES');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'UPDATE_PENDING_CASH';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'UPDATE_PENDING_CASH');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'UPDATE_PENDING_CASH_EOD';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'UPDATE_PENDING_CASH_EOD');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'UPDATE_PENDING_HOLDING';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'UPDATE_PENDING_HOLDING');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'UPDATE_PENDING_HOLDING_EOD';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'UPDATE_PENDING_HOLDING_EOD');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'UPDATE_SYMBOL_DATA';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'UPDATE_SYMBOL_DATA');
    END IF;
END;
/

---------------------------- SFC ----------------------------

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'EOD_CASH_TRN_FEE_BULK_UPDATE_FTB_B';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'EOD_CASH_TRN_FEE_BULK_UPDATE_FTB_B');
    END IF;
END;
/

DECLARE
    l_count   NUMBER := 0;
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM user_scheduler_jobs
     WHERE job_name = 'PORTFOLIO_VALUATION_B';

    IF l_count = 1
    THEN
        DBMS_SCHEDULER.disable (name => 'PORTFOLIO_VALUATION_B');
    END IF;
END;
/