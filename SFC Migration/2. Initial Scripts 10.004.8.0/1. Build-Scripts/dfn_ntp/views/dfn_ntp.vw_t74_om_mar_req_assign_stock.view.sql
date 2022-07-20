CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_t74_om_mar_req_assign_stock
(
    t74_margin_request_id_m73,
    t74_murahaba_basket_id_m181,
    t74_exchange_code_m01,
    t74_symbol_code_m20,
    t74_amount,
    t74_custom_type,
    t74_institution_id_m02,
    m20_short_description,
    m20_short_description_lang,
    m20_id,
    t74_symbol_id_m20
)
AS
    SELECT t74.t74_margin_request_id_m73,
           t74.t74_murahaba_basket_id_m181,
           t74.t74_exchange_code_m01,
           t74.t74_symbol_code_m20,
           t74.t74_amount,
           t74.t74_custom_type,
           t74.t74_institution_id_m02,
           m20.m20_short_description,
           m20.m20_short_description_lang,
           m20_id,
           t74_symbol_id_m20
      FROM     t74_om_margin_req_murabh_bskt t74
           LEFT JOIN
               m20_symbol m20
           ON t74.t74_symbol_id_m20 = m20.m20_id
/
