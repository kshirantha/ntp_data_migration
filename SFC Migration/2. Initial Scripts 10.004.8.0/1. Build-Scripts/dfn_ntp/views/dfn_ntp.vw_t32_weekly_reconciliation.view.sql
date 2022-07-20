CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t32_weekly_reconciliation
(
    symbol,
    investor_id,
    equator_no,
    isin,
    current_balance,
    available_balance,
    pledge_qty,
    position_date,
    change_date,
    primary_institute_id,
    batch_id
)
AS
    SELECT TRIM (REPLACE (t32_symbol, '"', '')) AS symbol,
           TRIM (REPLACE (t32_broker_code, '"', '')) AS investor_id,
           LPAD (TRIM (REPLACE (t32_equator_no, '"', '')), 10, '0')
               AS equator_no,
           TRIM (REPLACE (t32_isin, '"', '')) AS isin,
           TO_NUMBER (TRIM (REPLACE (t32_current_qty, '"', '')))
               AS current_balance,
           TO_NUMBER (TRIM (REPLACE (t32_available_qty, '"', '')))
               AS available_balance,
           TO_NUMBER (TRIM (REPLACE (t32_pledged_qty, '"', '')))
               AS pledge_qty,
           TO_DATE (TRIM (REPLACE (t32_position_date, '"', '')), 'YYYYMMDD')
               AS position_date,
           TO_DATE (TRIM (REPLACE (t32_change_date, '"', '')), 'YYYYMMDD')
               AS change_date,
           a.t32_primary_institute_id_m02 AS primary_institute_id,
           a.t32_batch_id_t80 AS batch_id
      FROM t32_weekly_reconciliation a
/
