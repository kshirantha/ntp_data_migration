CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m60_institute_banks
(
    m60_id,
    m60_institute_id_m02,
    m60_bank_id_m16,
    bank_name,
    bank_name_lang,
    m60_created_by_id_u17,
    created_by_full_name,
    m60_created_date,
    m60_modified_by_id_u17,
    modified_by_full_name,
    m60_modified_date,
    m60_is_default,
    is_default,
    m16_bank_identifier
)
AS
    ( (SELECT m60.m60_id,
              m60.m60_institute_id_m02,
              m60.m60_bank_id_m16,
              m16.m16_name AS bank_name,
              m16.m16_name_lang AS bank_name_lang,
              m60.m60_created_by_id_u17,
              u17_created_by.u17_full_name AS created_by_full_name,
              m60.m60_created_date,
              m60.m60_modified_by_id_u17,
              u17_modified_by.u17_full_name AS modified_by_full_name,
              m60.m60_modified_date,
              m60.m60_is_default,
              CASE WHEN m60.m60_is_default = 0 THEN 'NO' ELSE 'YES' END
                  AS is_default,
              m16.m16_bank_identifier
         FROM m60_institute_banks m60
              LEFT JOIN u17_employee u17_created_by
                  ON m60.m60_created_by_id_u17 = u17_created_by.u17_id
              LEFT JOIN u17_employee u17_modified_by
                  ON m60.m60_modified_by_id_u17 = u17_modified_by.u17_id
              LEFT JOIN m16_bank m16
                  ON m60.m60_bank_id_m16 = m16.m16_id));
/
