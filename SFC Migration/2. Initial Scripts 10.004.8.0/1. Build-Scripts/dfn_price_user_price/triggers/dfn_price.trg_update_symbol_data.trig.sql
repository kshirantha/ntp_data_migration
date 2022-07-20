CREATE OR REPLACE TRIGGER dfn_price.trg_update_symbol_data
    AFTER UPDATE
    ON dfn_price.esp_todays_snapshots
    REFERENCING NEW AS new OLD AS old
    FOR EACH ROW
BEGIN
    UPDATE dfn_ntp.m20_symbol m20
       SET m20.m20_settle_category_v11 =
               DECODE (NVL (:new.loosing_category, -1),
                       -1, 0,
                       :new.loosing_category)
     WHERE     m20.m20_price_exchange_code_m01 = :new.exchangecode
           AND m20.m20_price_symbol_code_m20 = :new.symbol;
END;
/
