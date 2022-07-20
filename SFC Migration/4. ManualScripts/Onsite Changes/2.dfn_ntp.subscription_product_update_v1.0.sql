DELETE dfn_ntp.v35_products;

INSERT INTO dfn_ntp.v35_products (v35_id,
                                  v35_product_code,
                                  v35_product_name,
                                  v35_product_name_lang,
                                  v35_rank,
                                  v35_premium_product)
     VALUES (1,
             '1',
             'Delay Price',
             'Delay Price',
             0,
             0);

DELETE dfn_ntp.m152_products;

INSERT INTO dfn_ntp.m152_products (m152_id,
                                   m152_product_code,
                                   m152_product_name,
                                   m152_product_name_lang,
                                   m152_institution_id_m02,
                                   m152_is_active,
                                   m152_rank,
                                   m152_premium_product,
                                   m152_currency_code_m03,
                                   m152_currency_id_m03,
                                   m152_duration,
                                   m152_service_fee,
                                   m152_broker_fee,
                                   m152_vat_pct,
                                   m152_created_date,
                                   m152_created_by_id_u17,
                                   m152_modified_date,
                                   m152_modified_by_id_u17,
                                   m152_custom_type,
                                   m152_product_id_v35,
                                   m152_status_id_v01,
                                   m152_status_changed_by_id_u17,
                                   m152_status_changed_date)
     VALUES (1,
             '1',
             'Delay Price',
             'Delay Price',
             1,
             1,
             0,
             0,
             'SAR',
             '19',
             1,
             0,
             0,
             0,
             SYSDATE,
             0,
             SYSDATE,
             0,
             '4',
             1,
             2,
             NULL,
             NULL);

DELETE dfn_ntp.m157_subcription_prd_channels;

INSERT
  INTO dfn_ntp.m157_subcription_prd_channels (m157_subs_prd_id_m152,
                                              m157_channel_id_v29)
VALUES (1, 1);

INSERT
  INTO dfn_ntp.m157_subcription_prd_channels (m157_subs_prd_id_m152,
                                              m157_channel_id_v29)
VALUES (1, 16);

UPDATE dfn_ntp.m02_institute
   SET m02_default_product_id_m152 = 1;

COMMIT;
