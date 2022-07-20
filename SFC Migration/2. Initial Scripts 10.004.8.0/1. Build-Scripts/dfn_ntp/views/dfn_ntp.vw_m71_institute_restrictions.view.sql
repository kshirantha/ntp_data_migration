CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m71_institute_restrictions
(
    m71_restriction_id,
    m71_institution_id_m02,
    m71_type,
    restriction_type,
    m71_stock_trading,
    stock_trading,
    m71_stock_transaction,
    stock_transaction,
    m71_stock_transfer,
    stock_transfer,
    m71_pledge,
    pledge,
    m71_cash_transactions,
    cash_transactions,
    m71_cash_transfer,
    cash_transfer
)
AS
    (SELECT m71.m71_restriction_id,
            m71.m71_institution_id_m02,
            m71.m71_type,
            CASE
                WHEN m71.m71_type = 1 THEN 'Customer ID Expired'
                WHEN m71.m71_type = 2 THEN 'CMA Details Expired'
                WHEN m71.m71_type = 3 THEN 'Inactive'
                WHEN m71.m71_type = 4 THEN 'Dormant'
                WHEN m71.m71_type = 5 THEN 'Account Closure'
            END
                AS restriction_type,
            m71.m71_stock_trading,
            CASE
                WHEN m71.m71_stock_trading = 0 THEN 'None'
                WHEN m71.m71_stock_trading = 1 THEN 'Buy'
                WHEN m71.m71_stock_trading = 2 THEN 'Sell'
                ELSE 'Buy/Sell'
            END
                AS stock_trading,
            m71.m71_stock_transaction,
            CASE
                WHEN m71.m71_stock_transaction = 0 THEN 'None'
                WHEN m71.m71_stock_transaction = 1 THEN 'Withdrawal'
                WHEN m71.m71_stock_transaction = 2 THEN 'Deposit'
                ELSE 'Deposit/Withdrawal'
            END
                AS stock_transaction,
            m71.m71_stock_transfer,
            CASE WHEN m71.m71_stock_transfer = 0 THEN 'No' ELSE 'Yes' END
                AS stock_transfer,
            m71.m71_pledge,
            CASE
                WHEN m71.m71_pledge = 0 THEN 'None'
                WHEN m71.m71_pledge = 1 THEN 'Pledge In'
                WHEN m71.m71_pledge = 2 THEN 'Pledge Out'
                ELSE 'Both'
            END
                AS pledge,
            m71.m71_cash_transactions,
            CASE
                WHEN m71.m71_cash_transactions = 0 THEN 'None'
                WHEN m71.m71_cash_transactions = 1 THEN 'Withdrawal'
                WHEN m71.m71_cash_transactions = 2 THEN 'Deposit'
                ELSE 'Deposit/Withdrawal'
            END
                AS cash_transactions,
            m71.m71_cash_transfer,
            CASE
                WHEN m71.m71_cash_transfer = 0 THEN 'None'
                WHEN m71.m71_cash_transfer = 1 THEN 'Offline'
                WHEN m71.m71_cash_transfer = 2 THEN 'Online'
                ELSE 'Both'
            END
                AS cash_transfer
       FROM m71_institute_restrictions m71);
/
