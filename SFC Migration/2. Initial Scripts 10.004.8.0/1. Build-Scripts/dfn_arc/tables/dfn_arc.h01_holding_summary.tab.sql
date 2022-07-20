DECLARE
    l_enable_partition     dfn_arc.config_partition.enable_partition%TYPE;
    l_min_partition_date   dfn_arc.config_partition.min_partition_date%TYPE;
BEGIN
    SELECT enable_partition, min_partition_date
      INTO l_enable_partition, l_min_partition_date
      FROM dfn_arc.config_partition;

    EXECUTE IMMEDIATE
        (   'CREATE TABLE dfn_arc.h01_holding_summary
(
    h01_trading_acnt_id_u07        NUMBER (10, 0),
    h01_exchange_code_m01          VARCHAR2 (10 BYTE),
    h01_symbol_id_m20              NUMBER (10, 0),
    h01_date                       DATE,
    h01_custodian_id_m26           NUMBER (10, 0),
    h01_holding_block              NUMBER (18, 0) DEFAULT 0,
    h01_sell_pending               NUMBER (18, 0),
    h01_buy_pending                NUMBER (18, 0),
    h01_weighted_avg_price         NUMBER (18, 5),
    h01_avg_price                  NUMBER (18, 5),
    h01_weighted_avg_cost          NUMBER (18, 5),
    h01_avg_cost                   NUMBER (18, 5),
    h01_receivable_holding         NUMBER (18, 0) DEFAULT 0,
    h01_payable_holding            NUMBER (18, 0) DEFAULT 0,
    h01_symbol_code_m20            VARCHAR2 (25 BYTE),
    h01_realized_gain_lost         NUMBER (18, 5),
    h01_currency_code_m03          VARCHAR2 (5 BYTE),
    h01_price_inst_type            NUMBER (5, 0),
    h01_pledge_qty                 NUMBER (18, 0) DEFAULT 0,
    h01_last_trade_price           NUMBER (18, 5) DEFAULT 0,
    h01_vwap                       NUMBER (18, 5) DEFAULT 0,
    h01_market_price               NUMBER (18, 5) DEFAULT 0,
    h01_previous_closed            NUMBER (18, 5) DEFAULT 0,
    h01_todays_closed              NUMBER (18, 5) DEFAULT 0,
    h01_manual_block               NUMBER (18, 0) DEFAULT 0,
    h01_net_holding                NUMBER (18, 0) DEFAULT 0,
    h01_custodian_code_m26         VARCHAR2 (50 BYTE),
    h01_short_holdings             NUMBER (18, 0) DEFAULT 0,
    h01_net_receivable             NUMBER (18, 0),
    h01_is_history_adjusted        NUMBER (1, 0) DEFAULT 0,
    h01_trade_processing_id_t17    VARCHAR2 (22 BYTE),
    h01_primary_institute_id_m02   NUMBER (5, 0),
    h01_subscribed_qty             NUMBER (18, 0),
    h01_pending_subscribe_qty      NUMBER (18, 0)
)'
         || CASE
                WHEN l_enable_partition = 1
                THEN
                       'PARTITION BY RANGE (h01_date)
    INTERVAL ( NUMTOYMINTERVAL (3, ''MONTH'') )
    (
        PARTITION h01_data_p0
            VALUES LESS THAN (TO_DATE ('''
                    || TO_CHAR (TRUNC (l_min_partition_date, 'Q'),
                                'DD/MM/YYYY')
                    || ''', ''DD/MM/YYYY''))
    )'
            END);

    EXECUTE IMMEDIATE
           'CREATE INDEX idx_arc_h01_date ON dfn_arc.h01_holding_summary (h01_date DESC) '
        || CASE WHEN l_enable_partition = 1 THEN 'LOCAL' END;
END;
/

GRANT SELECT ON dfn_arc.h01_holding_summary TO dfn_ntp
/

GRANT INSERT ON dfn_arc.h01_holding_summary TO dfn_ntp
/

CREATE INDEX idx_arc_h01_trad_acnt_id_u07
    ON dfn_arc.h01_holding_summary (h01_trading_acnt_id_u07)
/

CREATE INDEX idx_arc_h01_exchange_code_m01
    ON dfn_arc.h01_holding_summary (h01_exchange_code_m01)
/

CREATE INDEX idx_arc_h01_symbol_id_m20
    ON dfn_arc.h01_holding_summary (h01_symbol_id_m20)
/

CREATE INDEX idx_arc_h01_custodian_id_m26
    ON dfn_arc.h01_holding_summary (h01_custodian_id_m26)
/

ALTER TABLE dfn_arc.h01_holding_summary
 MODIFY (
  h01_trading_acnt_id_u07 NOT NULL,
  h01_exchange_code_m01 NOT NULL,
  h01_symbol_id_m20 NOT NULL,
  h01_date NOT NULL,
  h01_custodian_id_m26 NOT NULL
 )
/

ALTER TABLE dfn_arc.h01_holding_summary
 ADD (
  h01_is_archive_ready NUMBER (1, 0) DEFAULT 0
 )
/

COMMENT ON COLUMN dfn_arc.h01_holding_summary.h01_is_archive_ready IS
    'flag to check before archive'
/

ALTER TABLE dfn_arc.h01_holding_summary
 MODIFY (
  h01_is_archive_ready NOT NULL
 )
/

ALTER TABLE dfn_arc.h01_holding_summary
 MODIFY (
  h01_symbol_code_m20 VARCHAR2 (50 BYTE)

 )
/