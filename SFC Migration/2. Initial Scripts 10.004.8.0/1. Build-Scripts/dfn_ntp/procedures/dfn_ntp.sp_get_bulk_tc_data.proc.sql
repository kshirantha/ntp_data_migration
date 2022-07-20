CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_bulk_tc_data (
    p_view             OUT SYS_REFCURSOR,
    prows              OUT NUMBER,
    p_customer_id   IN     NUMBER,
    p_from_date     IN     DATE,
    p_to_date       IN     DATE)
IS
    l_defaul_mailing_address   VARCHAR (500);
BEGIN
    BEGIN
        SELECT fn_get_customer_address (p_customer_id, 0)
          INTO l_defaul_mailing_address
          FROM DUAL;

        OPEN p_view FOR
            SELECT customer.u01_full_name,
                   customer.u01_full_name_lang,
                   customer.default_email,
                   customer.u01_preferred_lang_id_v01,
                   customer.u01_default_id_no,
                   customer.u01_default_id_type_txt,
                   customer.u01_default_id_type_txt_lang,
                   customer.u01_external_ref_no,
                   customer.u01_tax_ref,
                   customer.u01_vat_waive_off,
                   l_defaul_mailing_address AS defaul_mailing_address,
                   orders.t01_cl_ord_id,
                   orders.t01_date,
                   orders.t01_trading_acntno_u07,
                   orders.t01_exchange_code_m01,
                   orders.m20_isincode,
                   orders.m20_currency_id_m03,
                   orders.m20_currency_code_m03,
                   orders.t01_avg_price,
                   orders.t01_quantity,
                   orders.t01_cum_quantity,
                   orders.t01_cum_ord_value,
                   orders.t01_cum_commission,
                   orders.t01_cum_net_value,
                   orders.order_side,
                   orders.t01_ord_no,
                   orders.m20_long_description,
                   orders.m20_long_description_lang,
                   orders.t01_cum_broker_tax,
                   orders.t01_cum_exchange_tax,
                   '' AS amount_in_words,
                   orders.t01_cash_settle_date,
                   orders.t01_holding_settle_date
              FROM     vw_customer_list customer
                   JOIN
                       vw_order_list orders
                   ON customer.u01_id = orders.t01_customer_id_u01
             WHERE     customer.u01_id = p_customer_id
                   AND orders.t01_date BETWEEN p_from_date
                                           AND p_to_date + 0.99999
                   AND orders.t01_cum_quantity > 0;
    END;
END;
/
