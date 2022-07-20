DECLARE
    l_pkey   NUMBER (10) := 0;
BEGIN
    SELECT NVL (MAX (m98_id), 0)
      INTO l_pkey
      FROM dfn_ntp.m98_institution_txn_codes;



    FOR i IN (SELECT a.m97_id,
                     a.m97_code,
                     a.m97_description,
                     a.m97_description_lang,
                     a.m97_category,
                     a.m97_b2b_enabled,
                     a.m97_visible,
                     a.m97_statement,
                     a.m97_charge_type,
                     a.m97_created_by_id_u17,
                     a.m97_created_date,
                     a.m97_modified_by_id_u17,
                     a.m97_modified_date,
                     a.m97_status_id_v01,
                     a.m97_status_changed_by_id_u17,
                     a.m97_status_changed_date,
                     a.m97_txn_impact_type,
                     a.m97_custom_type
              FROM dfn_ntp.m97_transaction_codes a)
    LOOP
        l_pkey := l_pkey + 1;

        INSERT
          INTO dfn_ntp.m98_institution_txn_codes (
                   m98_id,
                   m98_transaction_code_id_m97,
                   m98_transaction_code_m97,
                   m98_institution_id_m02,
                   m98_b2b_enabled,
                   m98_statement,
                   m98_created_by_id_u17,
                   m98_created_date,
                   m98_modified_by_id_u17,
                   m98_modified_date,
                   m98_status_id_v01,
                   m98_status_changed_by_id_u17,
                   m98_status_changed_date,
                   m98_txn_code_description_m97)
        VALUES (l_pkey,
                i.m97_id,
                i.m97_code,
                1, --m98_institution_id_m02
                0,  --m98_b2b_enabled disabled by default -Janaka
                i.m97_statement,
                1,  --dfnadmin or system
                SYSDATE,
                NULL,
                NULL,
                2,
                1,
                SYSDATE,
                i.m97_description);
    END LOOP;
END;
/

commit;