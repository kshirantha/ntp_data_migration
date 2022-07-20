CREATE OR REPLACE VIEW dfn_ntp.vw_m182_murabaha_bskt_comp (
   m182_id,
   m182_symbol_code_m20,
   m182_symbol_id_m20,
   m182_basket_id_m181,
   m182_exchange_id_m01,
   m182_percentage,
   m182_allowed_change,
   is_allowed_change,
   symbol_description,
   m182_status_id_v01 )
AS
SELECT m182.m182_id,
           m182.m182_symbol_code_m20,
           m182.m182_symbol_id_m20,
           m182.m182_basket_id_m181,
           m182.m182_exchange_id_m01,
           m182.m182_percentage,
           m182.m182_allowed_change,
           CASE
               WHEN m182.m182_allowed_change = 1 THEN 'Yes'
               WHEN m182.m182_allowed_change = 0 THEN 'No'
           END
               AS is_allowed_change,
           m20.m20_long_description AS symbol_description,
           m182.m182_status_id_v01
      FROM m182_murabaha_bskt_composition m182
           LEFT JOIN m20_symbol m20
               ON m182.m182_symbol_id_m20 = m20.m20_id
           LEFT JOIN u17_employee u17_created_by
               ON m182.m182_created_by_id_u17 = u17_created_by.u17_id
           LEFT JOIN u17_employee u17_modified_by
               ON m182.m182_modified_by_id_u17 = u17_modified_by.u17_id
           LEFT JOIN vw_status_list status_list
               ON m182.m182_status_id_v01 = status_list.v01_id
/