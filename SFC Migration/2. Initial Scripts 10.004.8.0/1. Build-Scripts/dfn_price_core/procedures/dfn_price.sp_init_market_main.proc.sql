
CREATE OR REPLACE PROCEDURE DFN_PRICE.SP_INIT_MARKET_MAIN (
    v_exchangecode IN VARCHAR2 DEFAULT NULL)
AS
    v_last_intit_date   DATE;
BEGIN
    SELECT last_init_date
      INTO v_last_intit_date
      FROM esp_exchangemaster
     WHERE exchange = v_exchangecode;

    DBMS_OUTPUT.put_line (v_last_intit_date);

    IF TRUNC (v_last_intit_date) <> TRUNC (SYSDATE)
    THEN
        BEGIN
            sp_init_indicies_at_mkt_init (v_exchangecode);
            sp_init_tables_at_mkt_init (v_exchangecode);
            sp_init_tday_shots_at_mkt_init (v_exchangecode);
        END;
    END IF;
END;
/
/
