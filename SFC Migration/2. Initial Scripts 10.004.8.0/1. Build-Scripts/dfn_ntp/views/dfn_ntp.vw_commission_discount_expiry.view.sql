CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_commission_discount_expiry
(
    u01_id,
    u01_customer_no,
    u01_external_ref_no,
    u01_display_name,
    u01_institute_id_m02,
    m24_name,
    m25_starting_date,
    m25_ending_date,
    m25_percentage,
    m25_flat_discount,
    m25_currency_code_m03,
    u07_id,
    u07_display_name_u06,
    u07_display_name,
    u07_exchange_code_m01,
    commission_grp
)
AS
    SELECT u01.u01_id,
           u01.u01_customer_no,
           u01.u01_external_ref_no,
           u01.u01_display_name,
           u01.u01_institute_id_m02,
           m24.m24_name,
           m25.m25_starting_date,
           m25.m25_ending_date,
           m25.m25_percentage,
           m25.m25_flat_discount,
           m25.m25_currency_code_m03,
           u07.u07_id,
           u07.u07_display_name_u06,
           u07.u07_display_name,
           u07.u07_exchange_code_m01,
           m22.m22_description AS commission_grp
      FROM u01_customer u01
           JOIN u07_trading_account u07
               ON u07.u07_customer_id_u01 = u01.u01_id
           LEFT JOIN m24_commission_discount_group m24
               ON u07.u07_commission_dis_grp_id_m24 = m24.m24_id
           LEFT JOIN m25_commission_discount_slabs m25
               ON m24.m24_id = m25.m25_discount_group_id_m24
           LEFT JOIN m22_commission_group m22
               ON u07.u07_commission_group_id_m22 = m22.m22_id
/