CREATE TABLE dfn_ntp.m160_offline_symbol_update_log
(
    m160_id                        NUMBER (20, 0) NOT NULL,
    m160_symbol                    VARCHAR2 (40 BYTE),
    m160_date                      DATE,
    m160_status                    NUMBER (5, 0),
    m160_old_ltp                   NUMBER (21, 6),
    m160_new_ltp                   NUMBER (21, 6),
    m160_old_previous_close        NUMBER (21, 6),
    m160_new_previous_close        NUMBER (21, 6),
    m160_old_last_trade_date       DATE,
    m160_new_last_trade_date       DATE,
    m160_old_max_price             NUMBER (21, 6),
    m160_new_max_price             NUMBER (21, 6),
    m160_old_bid_price             NUMBER (21, 6),
    m160_new_bid_price             NUMBER (21, 6),
    m160_old_ask_price             NUMBER (21, 6),
    m160_new_ask_price             NUMBER (21, 6),
    m160_old_maturity_date         DATE,
    m160_new_maturity_date         DATE,
    m160_old_min_price             NUMBER (21, 6),
    m160_new_min_price             NUMBER (21, 6),
    m160_updated_by_id_u17         NUMBER (5, 0),
    m160_updated_date              DATE,
    m160_reason                    VARCHAR2 (400 BYTE),
    m160_reuters_code              VARCHAR2 (30 BYTE),
    m160_currency                  VARCHAR2 (30 BYTE),
    m160_exchange                  VARCHAR2 (10 BYTE),
    m160_volume                    NUMBER (21, 0),
    m160_coupon_rate               NUMBER (21, 6),
    m160_isin                      VARCHAR2 (100 BYTE),
    m160_custom_type               VARCHAR2 (50 BYTE) DEFAULT '1',
    m160_symbol_sessions_id_m159   NUMBER (20, 0)
)
/



COMMENT ON COLUMN dfn_ntp.m160_offline_symbol_update_log.m160_status IS
    '3 - Rejected , 17 - Processed'
/