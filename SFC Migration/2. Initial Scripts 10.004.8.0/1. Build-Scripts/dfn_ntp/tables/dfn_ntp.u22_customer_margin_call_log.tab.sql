CREATE TABLE dfn_ntp.u22_customer_margin_call_log
(
    u22_id                      NUMBER (18, 0) NOT NULL,
    u22_margin_prdouct_id_u23   NUMBER (18, 0) NOT NULL,
    u22_date                    DATE,
    u22_type                    NUMBER (1, 0),
    u22_utilized_amount         NUMBER (25, 10),
    u22_utilized_percentage     NUMBER (25, 10),
    u22_top_up_amount           NUMBER (25, 10),
    u22_cash_balance            NUMBER (25, 10),
    u22_block_amount            NUMBER (25, 10),
    u22_margin_blocked          NUMBER (25, 10),
    u22_rapv                    NUMBER (25, 10)
)
/



COMMENT ON COLUMN dfn_ntp.u22_customer_margin_call_log.u22_block_amount IS
    'Value at the time of req. generated'
/
COMMENT ON COLUMN dfn_ntp.u22_customer_margin_call_log.u22_cash_balance IS
    'Value at the time of req. generated'
/
COMMENT ON COLUMN dfn_ntp.u22_customer_margin_call_log.u22_margin_blocked IS
    'Value at the time of req. generated'
/
COMMENT ON COLUMN dfn_ntp.u22_customer_margin_call_log.u22_rapv IS
    'Value at the time of req. generated'
/
COMMENT ON COLUMN dfn_ntp.u22_customer_margin_call_log.u22_top_up_amount IS
    'Value at the time of req. generated'
/
COMMENT ON COLUMN dfn_ntp.u22_customer_margin_call_log.u22_type IS
    '1 - Notify | 2 - Remind | 3 - Liquidation'
/
COMMENT ON COLUMN dfn_ntp.u22_customer_margin_call_log.u22_utilized_amount IS
    'Value at the time of req. generated'
/
COMMENT ON COLUMN dfn_ntp.u22_customer_margin_call_log.u22_utilized_percentage IS
    'Value at the time of req. generated'
/
