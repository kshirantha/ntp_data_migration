CREATE TABLE dfn_ntp.t89_channel_cum_order_values
(
    t89_id                     NUMBER (10, 0),
    t89_cash_account_id_u06    NUMBER (10, 0),
    t89_channel_id_v29         NUMBER (5, 0),
    t89_cum_sell_order_value   NUMBER (18, 5),
    t89_cum_buy_order_value    NUMBER (18, 5),
    t89_modified_date          DATE,
    t89_modified_by_u17        NUMBER (10, 0)
)
/

ALTER TABLE dfn_ntp.t89_channel_cum_order_values
ADD CONSTRAINT pk_t89 PRIMARY KEY (t89_id)
USING INDEX
/