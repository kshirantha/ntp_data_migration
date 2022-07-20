CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_e01_corporate_actions
(
    symbol,
    investor_id,
    equator_no,
    isin,
    current_balance,
    available_balance,
    pledge_qty,
    position_date,
    change_date
)
AS
    SELECT TRIM (REPLACE (e01_symbol, '"', '')) AS symbol,
           TRIM (REPLACE (e01_broker_code, '"', '')) AS investor_id,
           LPAD (TRIM (REPLACE (e01_equator_no, '"', '')), 10, '0')
               AS equator_no,
           TRIM (REPLACE (e01_isin, '"', '')) AS isin,
           TO_NUMBER (TRIM (REPLACE (e01_current_qty, '"', '')))
               AS current_balance,
           TO_NUMBER (TRIM (REPLACE (e01_available_qty, '"', '')))
               AS available_balance,
           TO_NUMBER (TRIM (REPLACE (e01_pledged_qty, '"', '')))
               AS pledge_qty,
           TO_DATE (TRIM (REPLACE (e01_position_date, '"', '')), 'YYYYMMDD')
               AS position_date,
           TO_DATE (TRIM (REPLACE (e01_change_date, '"', '')), 'YYYYMMDD')
               AS change_date
      FROM dfn_ntp.e01_corporate_actions
/