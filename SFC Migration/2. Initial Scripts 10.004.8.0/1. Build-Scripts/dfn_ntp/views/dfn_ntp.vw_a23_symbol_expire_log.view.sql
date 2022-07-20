CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_a23_symbol_expire_log
(
    a23_id,
    a23_reference_id,
    a23_request_date,
    a23_expire_date,
    m20_symbol_code,
    a23_exchange_code_m01,
    customer_no,
    customer_name,
    u07_display_name,
    a23_failed_reason,
    status,
    a23_institute_id_m02
)
AS
    SELECT a23.a23_id,
           a23.a23_reference_id,
           a23.a23_request_date,
           a23.a23_expire_date,
           m20.m20_symbol_code,
           a23.a23_exchange_code_m01,
           u07.u07_customer_no_u01 AS customer_no,
           u07.u07_display_name_u01 AS customer_name,
           u07.u07_display_name,
           a23.a23_failed_reason,
           CASE WHEN a23.a23_status = 1 THEN 'SUCCESS' ELSE 'FAILED' END
               AS status,
           a23.a23_institute_id_m02
      FROM a23_expirable_symbol_log a23
           JOIN m20_symbol m20
               ON a23.a23_symbol_id_m20 = m20.m20_id
           JOIN u07_trading_account u07
               ON a23.a23_trading_ac_id_u07 = u07.u07_id
/