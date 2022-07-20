CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_currency_rates
(
    m04_id,
    m04_institute_id_m02,
    code,
    m04_from_currency_code_m03,
    m04_to_currency_code_m03,
    m04_from_currency_id_m03,
    m04_to_currency_id_m03,
    m04_rate,
    description,
    approvalstatus,
    m04_status_id_v01,
    statuschangedby,
    m04_buy_rate,
    m04_sell_rate,
    m04_spread,
    m04_category_v01,
    category
)
AS
    SELECT m04_id,
           m04.m04_institute_id_m02,
           (m04.m04_from_currency_code_m03 || m04.m04_to_currency_code_m03)
               code,
           m04.m04_from_currency_code_m03,
           m04.m04_to_currency_code_m03,
           m04.m04_from_currency_id_m03,
           m04.m04_to_currency_id_m03,
           m04.m04_rate,
              'One '
           || (c1.m03_description || ' Converted to ' || c2.m03_description)
           || '(s)'
               description,
           NVL (status.v01_description, '') AS approvalstatus,
           m04.m04_status_id_v01,
           NVL (u17.u17_full_name, '') AS statuschangedby,
           m04_buy_rate,
           m04_sell_rate,
           m04_spread,
           m04_category_v01,
           v01.v01_description AS category
      FROM m04_currency_rate m04,
           m03_currency c1,
           m03_currency c2,
           vw_status_list status,
           u17_employee u17,
           v01_system_master_data v01
     WHERE     m04.m04_from_currency_code_m03 = c1.m03_code
           AND m04.m04_to_currency_code_m03 = c2.m03_code
           AND m04.m04_status_id_v01 = status.v01_id(+)
           AND m04.m04_status_changed_by_id_u17 = u17.u17_id(+)
           AND m04.m04_category_v01 = v01.v01_id
           AND v01.v01_type = 86;
/