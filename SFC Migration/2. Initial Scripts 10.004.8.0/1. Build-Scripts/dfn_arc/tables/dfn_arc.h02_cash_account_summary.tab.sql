DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.h02_cash_account_summary
(
    h02_cash_account_id_u06        NUMBER (10, 0) NOT NULL,
    h02_date                       DATE,
    h02_customer_id_u01            NUMBER (10, 0) NOT NULL,
    h02_currency_code_m03          CHAR (3 BYTE) NOT NULL,
    h02_balance                    NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h02_blocked                    NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h02_open_buy_blocked           NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h02_payable_blocked            NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h02_manual_trade_blocked       NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h02_manual_full_blocked        NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h02_manual_transfer_blocked    NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h02_receivable_amount          NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h02_currency_id_m03            NUMBER (5, 0),
    h02_margin_enabled             NUMBER (5, 0) DEFAULT 0,
    h02_pending_deposit            NUMBER (25, 10) DEFAULT 0,
    h02_pending_withdraw           NUMBER (25, 10) DEFAULT 0,
    h02_primary_od_limit           NUMBER (25, 10),
    h02_primary_start              DATE,
    h02_primary_expiry             DATE,
    h02_secondary_od_limit         NUMBER (25, 10),
    h02_secondary_start            DATE,
    h02_secondary_expiry           DATE,
    h02_investment_account_no      VARCHAR2 (75 BYTE),
    h02_daily_withdraw_limit       NUMBER (18, 5) DEFAULT 0,
    h02_daily_cum_withdraw_amt     NUMBER (18, 5) DEFAULT 0,
    h02_margin_due                 NUMBER (18, 5),
    h02_margin_block               NUMBER (18, 5),
    h02_margin_product_id_u23      NUMBER (5, 0),
    h02_net_receivable             NUMBER (25, 10) DEFAULT 0 NOT NULL,
    h02_opening_balance            NUMBER (25, 10),
    h02_deposits                   NUMBER (25, 10),
    h02_withdrawals                NUMBER (25, 10),
    h02_net_buy                    NUMBER (25, 10),
    h02_net_sell                   NUMBER (25, 10),
    h02_net_charges_refunds        NUMBER (25, 10),
    h02_net_commission             NUMBER (25, 10),
    h02_accrued_interest           NUMBER (18, 5) DEFAULT 0,
    h02_trade_processing_id_t17    VARCHAR2 (22 BYTE),
    h02_is_history_adjusted        NUMBER (1, 0) DEFAULT 0,
    h02_primary_institute_id_m02   NUMBER (5, 0)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (h02_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION h02_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_h02_date ON dfn_arc.h02_cash_account_summary (h02_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.h02_cash_account_summary TO dfn_ntp
/

GRANT INSERT ON dfn_arc.h02_cash_account_summary TO dfn_ntp
/

CREATE INDEX idx_arc_h02_cash_acc_id_u06
    ON dfn_arc.h02_cash_account_summary (h02_cash_account_id_u06)
/

ALTER TABLE dfn_arc.h02_cash_account_summary
 MODIFY (
  h02_date NOT NULL
 )
/

ALTER TABLE dfn_arc.h02_cash_account_summary
 ADD (
  h02_is_archive_ready NUMBER (1, 0) DEFAULT 0 NOT NULL
 )
/

COMMENT ON COLUMN dfn_arc.h02_cash_account_summary.h02_is_archive_ready IS
    'flag to check before archive'
/

ALTER TABLE dfn_arc.h02_cash_account_summary
 ADD (
  h02_margin_utilized NUMBER (25, 10)
 )
/

ALTER TABLE dfn_arc.h02_cash_account_summary
 MODIFY (
  h02_margin_utilized DEFAULT 0
 )
/

ALTER TABLE dfn_arc.h02_cash_account_summary
 ADD (
  h02_gainloss NUMBER (18, 5)
 )
/

ALTER TABLE dfn_arc.h02_cash_account_summary
 ADD (
  h02_loan_amount NUMBER (25, 10)
 )
/

UPDATE dfn_arc.h02_cash_account_summary
   SET h02_loan_amount = 0;

ALTER TABLE dfn_arc.h02_cash_account_summary
 MODIFY (
  h02_loan_amount DEFAULT 0
 )
/
