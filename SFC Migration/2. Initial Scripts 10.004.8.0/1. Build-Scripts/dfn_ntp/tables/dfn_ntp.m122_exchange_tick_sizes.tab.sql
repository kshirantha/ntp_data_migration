CREATE TABLE dfn_ntp.m122_exchange_tick_sizes
(
    m122_id                         NUMBER (10, 0) NOT NULL,
    m122_exchange_id_m01            NUMBER (5, 0) NOT NULL,
    m122_exchange_code_m01          VARCHAR2 (10 BYTE) NOT NULL,
    m122_range_low                  NUMBER (22, 0) DEFAULT 0.00 NOT NULL,
    m122_range_high                 NUMBER (22, 0) DEFAULT 0.00 NOT NULL,
    m122_price_unit                 FLOAT (18) DEFAULT 0.00 NOT NULL,
    m122_currency_code_m03          VARCHAR2 (3 BYTE),
    m122_currency_id_m03            NUMBER (5, 0),
    m122_instrument_type_id_v09     NUMBER (5, 0) NOT NULL,
    m122_created_by_id_u17          NUMBER (18, 0),
    m122_created_date               DATE,
    m122_modified_by_id_u17         NUMBER (18, 0),
    m122_modified_date              DATE,
    m122_status_id_v01              NUMBER (18, 0) DEFAULT 1,
    m122_status_changed_by_id_u17   NUMBER (18, 0),
    m122_status_changed_date        DATE,
    m122_instrument_type_code_v09   VARCHAR2 (50 BYTE),
    m122_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1
)
/


ALTER TABLE dfn_ntp.m122_exchange_tick_sizes
ADD CONSTRAINT m122_exch_tick_sizes_pk PRIMARY KEY (m122_id)
USING INDEX
/

COMMENT ON TABLE dfn_ntp.m122_exchange_tick_sizes IS
    'TDWL:
The New Price Change Unit of the above table shows the efficiency and the practicality of the listed companies pricing policy.
For instance, if we use the same example as above of the stock priced 11 Riyals, the price change unit for this
share is 5 halalas, which means that change would be either (5 halalas) down to 10.95 Riyals or (5 halalas) up to 11.05 which
represents (0.45%) change in the stock price.'
/
COMMENT ON COLUMN dfn_ntp.m122_exchange_tick_sizes.m122_currency_code_m03 IS
    'E.g. SAR'
/
COMMENT ON COLUMN dfn_ntp.m122_exchange_tick_sizes.m122_exchange_code_m01 IS
    'Exchange Code'
/
COMMENT ON COLUMN dfn_ntp.m122_exchange_tick_sizes.m122_instrument_type_code_v09 IS
    'v09_code'
/
COMMENT ON COLUMN dfn_ntp.m122_exchange_tick_sizes.m122_instrument_type_id_v09 IS
    'v09_ID'
/
COMMENT ON COLUMN dfn_ntp.m122_exchange_tick_sizes.m122_price_unit IS
    'E.g. 0.05'
/
COMMENT ON COLUMN dfn_ntp.m122_exchange_tick_sizes.m122_range_high IS
    'E.g. 50.00, 0 means upper max'
/
COMMENT ON COLUMN dfn_ntp.m122_exchange_tick_sizes.m122_range_low IS
    'E.g. 20.10 or 10.00, 0 means lowest'
/
