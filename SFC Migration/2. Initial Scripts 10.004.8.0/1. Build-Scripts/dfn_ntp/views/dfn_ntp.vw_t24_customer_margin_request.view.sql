CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t24_customer_margin_request
(
    t24_id,
    u01_customer_no,
    u01_external_ref_no,
    u01_institute_id_m02,
    t24_cust_margin_product_id_u23,
    margin_product,
    m73_product_type,
    margin_product_type_desc,
    request_type,
    t24_customer_id_u01,
    t24_default_cash_acc_id_u06,
    default_cash_account,
    t24_margin_products_id_m73,
    t24_interest_group_id_m74,
    interest_group,
    t24_max_margin_limit,
    t24_max_limit_curr_id_m03,
    t24_max_limit_curr_code_m03,
    t24_margin_expiry_date,
    t24_margin_call_level_1,
    t24_margin_call_level_2,
    t24_liquidation_level,
    t24_symbol_margnblty_grps_m77,
    t24_current_approval_level,
    symbol_margin_group,
    t24_stock_conctrn_group_id_m75,
    stock_concentration_group,
    t24_borrowers_name,
    t24_created_by_id_u17,
    created_by,
    t24_created_date,
    t24_status_id_v01,
    approval_status,
    aprroved_by,
    t24_margin_percentage,
    t24_no_of_approval,
    t24_next_status,
    next_approval_status,
    next_approval_status_lang,
    last_changed_by,
    t24_last_updated_date,
    other_cash_accounts,
    other_cash_acc_display_name,
    t24_restore_level,
    t24_exempt_liquidation,
	t24_request_action,
    exempt_liquidation
)
AS
    (SELECT t24_id,
            u01.u01_customer_no,
            u01.u01_external_ref_no,
            u01.u01_institute_id_m02,
            t24_cust_margin_product_id_u23,
            m73.m73_name AS margin_product,
            m73.m73_product_type,
            CASE
                WHEN m73.m73_product_type = 1 THEN 'Coverage Ratio'
                WHEN m73.m73_product_type = 2 THEN 'Initial Margin'
            END
                AS margin_product_type_desc,
            CASE
                WHEN t24.t24_request_type = 1 THEN 'Approve'
                WHEN t24.t24_request_type = 2 THEN 'Delete'
                ELSE ''
            END
                AS request_type,
            t24_customer_id_u01,
            t24_default_cash_acc_id_u06,
            u06.u06_display_name AS default_cash_account,
            t24_margin_products_id_m73,
            t24_interest_group_id_m74,
            m74.m74_description AS interest_group,
            t24_max_margin_limit,
            t24_max_limit_curr_id_m03,
            t24_max_limit_curr_code_m03,
            t24_margin_expiry_date,
            t24_margin_call_level_1,
            t24_margin_call_level_2,
            t24_liquidation_level,
            t24_symbol_margnblty_grps_m77,
            t24.t24_current_approval_level,
            m77.m77_name AS symbol_margin_group,
            t24_stock_conctrn_group_id_m75,
            m75.m75_description AS stock_concentration_group,
            t24_borrowers_name,
            t24_created_by_id_u17,
            created.u17_full_name AS created_by,
            t24_created_date,
            t24_status_id_v01,
            status.v01_description AS approval_status,
            modified.u17_full_name AS aprroved_by,
            t24_margin_percentage,
            t24.t24_no_of_approval,
            t24.t24_next_status,
            next_status.v01_description AS next_approval_status,
            next_status.v01_description_lang AS next_approval_status_lang,
            modified.u17_full_name AS last_changed_by,
            t24.t24_last_updated_date,
            t24.t24_other_cash_acc_ids_u06 AS other_cash_accounts,
            other.other_cash_acc_display_name,
            t24.t24_restore_level,
            t24.t24_exempt_liquidation,
			t24.t24_request_action,
            CASE t24.t24_exempt_liquidation
                WHEN 0 THEN 'No'
                WHEN 1 THEN 'Yes'
            END
                AS exempt_liquidation
       FROM t24_customer_margin_request t24
            JOIN u01_customer u01
                ON t24.t24_customer_id_u01 = u01.u01_id
            JOIN vw_status_list status
                ON t24.t24_status_id_v01 = status.v01_id
            JOIN vw_status_list next_status
                ON t24.t24_next_status = next_status.v01_id
            JOIN m73_margin_products m73
                ON t24.t24_margin_products_id_m73 = m73.m73_id
            JOIN m74_margin_interest_group m74
                ON t24.t24_interest_group_id_m74 = m74.m74_id
            JOIN m77_symbol_marginability_grps m77
                ON t24.t24_symbol_margnblty_grps_m77 = m77.m77_id
            JOIN m75_stock_concentration_group m75
                ON t24.t24_stock_conctrn_group_id_m75 = m75.m75_id
            JOIN u06_cash_account u06
                ON t24.t24_default_cash_acc_id_u06 = u06.u06_id
            JOIN u17_employee created
                ON t24.t24_created_by_id_u17 = created.u17_id
            LEFT JOIN u17_employee modified
                ON t24.t24_last_updated_by_id_u17 = modified.u17_id
            LEFT JOIN (  SELECT other.u23_id,
                                LISTAGG (u06.u06_display_name, ',')
                                WITHIN GROUP (ORDER BY u06.u06_display_name)
                                    AS other_cash_acc_display_name
                           FROM     (SELECT *
                                       FROM (WITH u23
                                                  AS (SELECT u23_id,
                                                             u23_other_cash_acc_ids_u06
                                                        FROM u23_customer_margin_product)
                                                 SELECT DISTINCT
                                                        u23_id,
                                                        TRIM (
                                                            REGEXP_SUBSTR (
                                                                other_cash_account,
                                                                '[^,]+',
                                                                1,
                                                                LEVEL))
                                                            other_cash_account
                                                   FROM (SELECT u23_id,
                                                                u23_other_cash_acc_ids_u06
                                                                    other_cash_account
                                                           FROM u23)
                                             CONNECT BY INSTR (
                                                            other_cash_account,
                                                            ',',
                                                            1,
                                                            LEVEL - 1) > 0)
                                      WHERE other_cash_account IS NOT NULL) other
                                JOIN
                                    u06_cash_account u06
                                ON other.other_cash_account = u06.u06_id
                       GROUP BY other.u23_id) other
                ON t24.t24_cust_margin_product_id_u23 = other.u23_id)
/
