CREATE OR REPLACE TRIGGER dfn_price.trg_update_symbol_prices
    AFTER UPDATE
    ON dfn_price.esp_todays_snapshots
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
BEGIN
    UPDATE dfn_ntp.m20_symbol m20
       SET m20.m20_today_closed = :new.todaysclosed * m20.m20_price_ratio,
           m20.m20_previous_closed = :new.previousclosed * m20.m20_price_ratio,
           m20.m20_minprice = :new.minprice * m20.m20_price_ratio,
           m20.m20_maxprice = :new.maxprice * m20.m20_price_ratio,
           m20.m20_vwap = :new.vwap * m20.m20_price_ratio,
           m20.m20_lasttradeprice = :new.lasttradeprice * m20.m20_price_ratio,
           m20.m20_bestbidprice = :new.bestbidprice * m20.m20_price_ratio,
           m20.m20_bestaskprice = :new.bestaskprice * m20.m20_price_ratio,
           m20.m20_strike_price = :new.strikeprice * m20.m20_price_ratio,
           m20.m20_date_of_last_price = SYSDATE,
           m20.m20_last_updated_date = SYSDATE,
           m20.m20_last_updated_by_id_u17 = 0,
           m20.m20_static_min = :new.static_min,
           m20.m20_static_max = :new.static_max,
           m20.m20_fixing_price = :new.settlement_price
     WHERE     m20.m20_price_exchange_code_m01 = :new.exchangecode
           AND m20.m20_price_symbol_code_m20 = :new.symbol;
END;
/
