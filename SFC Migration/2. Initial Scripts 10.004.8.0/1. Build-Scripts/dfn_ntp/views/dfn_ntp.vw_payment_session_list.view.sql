CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_payment_session_list
(
    t500_id,
    t500_date,
    t500_symbol_code_m20,
    t500_file_name,
    t500_status_id_v01,
    status,
    t500_uploaded_by_id_u17,
    uploaded_by_name,
    t500_uploaded_date,
    t500_validated_by_id_u17,
    validated_by_name,
    t500_validated_date,
    t500_processed_by_id_u17,
    processed_by_name,
    t500_processed_date,
    t500_custom_type,
    t500_institute_id_m02
)
AS
    SELECT t500.t500_id,
           t500.t500_date,
           t500.t500_symbol_code_m20,
           t500.t500_file_name,
           t500.t500_status_id_v01,
           status_list.v01_description AS status,
           t500.t500_uploaded_by_id_u17,
           uploaded_by.u17_full_name AS uploaded_by_name,
           t500.t500_uploaded_date,
           t500.t500_validated_by_id_u17,
           validated_by.u17_full_name AS validated_by_name,
           t500.t500_validated_date,
           t500.t500_processed_by_id_u17,
           processed_by.u17_full_name AS processed_by_name,
           t500.t500_processed_date,
           t500.t500_custom_type,
           t500.t500_institute_id_m02
      FROM t500_payment_sessions_c t500,
           vw_status_list status_list,
           u17_employee uploaded_by,
           u17_employee validated_by,
           u17_employee processed_by
     WHERE     t500.t500_status_id_v01 = status_list.v01_id(+)
           AND t500.t500_uploaded_by_id_u17 = uploaded_by.u17_id(+)
           AND t500.t500_validated_by_id_u17 = validated_by.u17_id(+)
           AND t500.t500_processed_by_id_u17 = processed_by.u17_id(+)
/