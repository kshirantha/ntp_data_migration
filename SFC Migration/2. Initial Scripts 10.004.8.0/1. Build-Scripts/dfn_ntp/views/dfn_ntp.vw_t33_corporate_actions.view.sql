CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t33_corporate_actions
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
    SELECT TRIM (REPLACE (t33_symbol, '"', '')) AS symbol,
           TRIM (REPLACE (t33_broker_code, '"', '')) AS investor_id,
           LPAD (TRIM (REPLACE (t33_equator_no, '"', '')), 10, '0')
               AS equator_no,
           TRIM (REPLACE (t33_isin, '"', '')) AS isin,
           TO_NUMBER (TRIM (REPLACE (t33_current_qty, '"', '')))
               AS current_balance,
           TO_NUMBER (TRIM (REPLACE (t33_available_qty, '"', '')))
               AS available_balance,
           TO_NUMBER (TRIM (REPLACE (t33_pledged_qty, '"', '')))
               AS pledge_qty,
           TO_DATE (TRIM (REPLACE (t33_position_date, '"', '')), 'YYYYMMDD')
               AS position_date,
           TO_DATE (TRIM (REPLACE (t33_change_date, '"', '')), 'YYYYMMDD')
               AS change_date,
           t33_primary_institute_id_m02 AS primary_institute_id,
           t33_batch_id_t80 AS batch_id
      FROM dfn_ntp.t33_corporate_actions
/
