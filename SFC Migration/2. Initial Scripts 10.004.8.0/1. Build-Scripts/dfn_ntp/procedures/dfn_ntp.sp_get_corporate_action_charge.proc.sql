CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_corporate_action_charge (
    p_view             OUT SYS_REFCURSOR,
    prows              OUT NUMBER,
    p_currency             VARCHAR,
    p_exchange             VARCHAR,
    p_institution_id       NUMBER)
IS
BEGIN
    OPEN p_view FOR
        SELECT m118.m118_exchange_id_m01,
               m118.m118_exchange_code_m01,
               m118.m118_currency_id_m03,
               m118.m118_currency_code_m03,
                 m118_broker_fee
               * get_exchange_rate (p_institution_id,
                                    m118.m118_exchange_code_m01,
                                    p_currency)
                   AS broker_fee,
                 m118_exchange_fee
               * get_exchange_rate (p_institution_id,
                                    m118.m118_exchange_code_m01,
                                    p_currency)
                   AS exchange_fee,
                 m118_broker_vat
               * get_exchange_rate (p_institution_id,
                                    m118.m118_exchange_code_m01,
                                    p_currency)
                   AS broker_vat,
                 m118_exchange_vat
               * get_exchange_rate (p_institution_id,
                                    m118.m118_exchange_code_m01,
                                    p_currency)
                   AS exchange_vat
          FROM     m117_charge_groups m117
               INNER JOIN
                   m118_charge_fee_structure m118
               ON m117.m117_id = m118.m118_group_id_m117
         WHERE     m118.m118_exchange_code_m01 = p_exchange
               AND m117_is_default = 1
               AND m117.m117_institute_id_m02 = p_institution_id
               AND m118.m118_charge_code_m97 = 'CACHRG';
END;
/
