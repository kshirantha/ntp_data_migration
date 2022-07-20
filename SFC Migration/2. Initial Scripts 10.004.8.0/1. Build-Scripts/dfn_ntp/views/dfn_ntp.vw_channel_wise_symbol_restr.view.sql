CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_channel_wise_symbol_restr
(
    m184_id,
    m184_exchange_id_m01,
    m184_exchange_code_m01,
    m01_description,
    m184_symbol_id_m20,
    m184_symbol_code_m20,
    m184_apply_to_all_symbol,
    m184_channel_id_v29,
    v29_description,
    m184_restriction_id_v31,
    v31_name,
    m184_reason,
    m184_from_date,
    m184_to_date,
    m184_status_id_v01,
    status,
    m184_created_by_id_u17,
    created_by,
    m184_created_date,
    m184_status_changed_by_id_u17,
    status_changed_by,
    m184_status_changed_date,
    m184_modified_by_id_u17,
    modified_by,
    m184_modified_date,
    m184_institute_id_m02
)
AS
    SELECT m184.m184_id,
           m184.m184_exchange_id_m01,
           m184.m184_exchange_code_m01,
           m01.m01_description,
           m184.m184_symbol_id_m20,
           CASE
               WHEN m184.m184_apply_to_all_symbol = 1
               THEN
                   'All'
               WHEN m184.m184_apply_to_all_symbol = 0
               THEN
                   m184.m184_symbol_code_m20
           END
               AS m184_symbol_code_m20,
           m184.m184_apply_to_all_symbol,
           m184.m184_channel_id_v29,
           v29.v29_description,
           m184.m184_restriction_id_v31,
           CASE
               WHEN m184.m184_restriction_id_v31 = -1 THEN 'Both'
               ELSE v31.v31_name
           END
               AS v31_name,
           m184.m184_reason,
           m184.m184_from_date,
           m184.m184_to_date,
           m184.m184_status_id_v01,
           vw_status_list.v01_description,
           m184.m184_created_by_id_u17,
           createdby.u17_full_name,
           m184.m184_created_date,
           m184.m184_status_changed_by_id_u17,
           statuschangedby.u17_full_name,
           m184.m184_status_changed_date,
           m184.m184_modified_by_id_u17,
           modifiedby.u17_full_name,
           m184.m184_modified_date,
           m184.m184_institute_id_m02
      FROM m184_channel_wise_symbol_restr m184
           LEFT JOIN m01_exchanges m01
               ON m184.m184_exchange_id_m01 = m01.m01_id
           JOIN v29_order_channel v29
               ON m184.m184_channel_id_v29 = v29.v29_id
           LEFT JOIN v31_restriction v31
               ON m184.m184_restriction_id_v31 = v31.v31_id
           JOIN vw_status_list
               ON m184.m184_status_id_v01 = vw_status_list.v01_id
           JOIN u17_employee createdby
               ON m184.m184_created_by_id_u17 = createdby.u17_id
           JOIN u17_employee statuschangedby
               ON m184.m184_status_changed_by_id_u17 = statuschangedby.u17_id
           LEFT JOIN u17_employee modifiedby
               ON m184.m184_modified_by_id_u17 = modifiedby.u17_id
/