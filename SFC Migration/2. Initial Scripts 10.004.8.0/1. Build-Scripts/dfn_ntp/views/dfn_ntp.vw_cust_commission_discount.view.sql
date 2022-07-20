CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_cust_commission_discount
(
    u01_id,
    u01_customer_no,
    u01_institute_id_m02,
    u01_display_name,
    u07_id,
    u07_display_name_u06,
    u07_exchange_code_m01,
    u07_display_name,
    u07_discount_percentage,
    u07_discount_prec_from_date,
    u07_discount_prec_to_date,
    u07_created_date,
    commission_grp,
    discount_grp
)
AS
    SELECT u01.u01_id,
           u01.u01_customer_no,
           u01.u01_institute_id_m02,
           u01.u01_display_name,
           u07.u07_id,
           u07.u07_display_name_u06,
           u07.u07_exchange_code_m01,
           u07.u07_display_name,
           u07.u07_discount_percentage,
           u07.u07_discount_prec_from_date,
           u07.u07_discount_prec_to_date,
           u07.u07_created_date,
           m22.m22_description AS commission_grp,
           m24.m24_name AS discount_grp
      FROM u07_trading_account u07
           JOIN u01_customer u01
               ON u07.u07_customer_id_u01 = u01.u01_id
           LEFT JOIN m24_commission_discount_group m24
               ON u07.u07_commission_dis_grp_id_m24 = m24.m24_id
           LEFT JOIN m22_commission_group m22
               ON u07.u07_commission_group_id_m22 = m22.m22_id
/