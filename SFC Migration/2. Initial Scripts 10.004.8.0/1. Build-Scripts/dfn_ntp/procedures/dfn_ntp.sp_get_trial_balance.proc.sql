CREATE OR REPLACE PROCEDURE dfn_ntp.sp_get_trial_balance (
    p_view            OUT SYS_REFCURSOR,
    prows             OUT NUMBER,
    pdate          IN     DATE,
    pinstituteid   IN     NUMBER,
    peventcatid    IN     NUMBER)
IS
BEGIN
    OPEN p_view FOR
          SELECT t28.t28_acc_cat_id_m134,
                 t28.t28_currency_id_m03,
                 m134.m134_description AS account_category_desc,
                 m134.m134_description_lang AS account_category_desc_lang,
                 m135.m135_code AS accounts_code,
                 t28.t28_currency_code_m03,
                 m135.m135_external_ref AS accounts_external_ref,
                 SUM (t28.t28_dr) AS t28_dr,
                 SUM (t28.t28_cr) AS t28_cr,
                 CASE
                     WHEN SUM (t28.t28_dr) > SUM (t28.t28_cr)
                     THEN
                         SUM (t28.t28_dr) - SUM (t28.t28_cr)
                     ELSE
                         0
                 END
                     AS debet_balance,
                 CASE
                     WHEN SUM (t28.t28_cr) > SUM (t28.t28_dr)
                     THEN
                         SUM (t28.t28_cr) - SUM (t28.t28_dr)
                     ELSE
                         0
                 END
                     creditbalance
            FROM t28_gl_record_wise_entries t28
                 JOIN t27_gl_batches t27
                     ON t28.t28_batch_id_t27 = t27.t27_id
                 JOIN m134_gl_account_categories m134
                     ON t28.t28_acc_cat_id_m134 = m134.m134_id
                 LEFT JOIN m135_gl_accounts m135
                     ON     t28.t28_acc_cat_id_m134 = m135.m135_acc_cat_id_m134
                        AND t28.t28_currency_id_m03 = m135_currency_id_m03
           WHERE     TRUNC (t27.t27_date) <= TRUNC (pdate) --SYSDATE => pdate
                 AND t27.t27_institute_id_m02 = pinstituteid --pinstitute_id
                 AND t27.t27_event_cat_id_m136 = peventcatid --pevent_cat_id_m136
        GROUP BY t28.t28_acc_cat_id_m134,
                 t28.t28_currency_id_m03,
                 t28.t28_currency_code_m03,
                 m134.m134_description,
                 m134.m134_description_lang,
                 m135.m135_code,
                 m135.m135_external_ref;
END;
/
