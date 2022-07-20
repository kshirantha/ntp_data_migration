CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_symbol_price_upload_summary
(
    m159_id,
    m159_file_name,
    m159_uploaded_by_id_u17,
    uploaded_by_name,
    m159_uploaded_date,
    m159_custom_type,
    m159_institute_id_m02
)
AS
    SELECT m159.m159_id,
           m159.m159_file_name,
           m159.m159_uploaded_by_id_u17,
           uploaded_by.u17_full_name AS uploaded_by_name,
           m159.m159_uploaded_date,
           m159.m159_custom_type,
           m159.m159_institute_id_m02
      FROM m159_offline_symbol_sessions m159, u17_employee uploaded_by
     WHERE m159.m159_uploaded_by_id_u17 = uploaded_by.u17_id(+)
/