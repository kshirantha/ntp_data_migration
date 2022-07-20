CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m190_exchange_comm_types
(
    m190_id,
    m190_exchange_id_m01,
    m190_comm_type_id_m124,
    m190_priority,
    m124_value,
    m124_type,
    m124_description,
    m124_description_lang
)
AS
    SELECT m190.m190_id,
           m190.m190_exchange_id_m01,
           m190.m190_comm_type_id_m124,
           m190.m190_priority,
           m124.m124_value,
           m124.m124_type,
           m124.m124_description,
           m124.m124_description_lang
      FROM m190_exchange_comm_types m190
           JOIN m124_commission_types m124
               ON m190.m190_comm_type_id_m124 = m124.m124_id
/