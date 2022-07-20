CREATE TABLE dfn_ntp.h50_daily_portfolio_value_b
(
    h50_date               DATE,
    h50_portfolio_id_u07   NUMBER (10, 0),
    h50_value              NUMBER (21, 3)
)
/

ALTER TABLE dfn_ntp.h50_daily_portfolio_value_b
ADD CONSTRAINT h50_pk_b PRIMARY KEY (h50_date, h50_portfolio_id_u07)
USING INDEX
/
