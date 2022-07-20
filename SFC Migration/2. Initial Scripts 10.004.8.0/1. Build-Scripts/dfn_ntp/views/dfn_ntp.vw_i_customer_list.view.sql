CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_i_customer_list
(
    id,
    customerno,
    instid,
    institute,
    category,
    accounttype,
    firstname,
    firstnamelang,
    secondname,
    secondnamelang,
    thirdname,
    thirdnamelang,
    lastname,
    lastnamelang,
    displayname,
    displaynamelang,
    gender,
    title
)
AS
    (SELECT a.u01_id AS id,
            a.u01_customer_no AS customerno,
            a.u01_institute_id_m02 AS instid,
            a.m02_name AS institute,
            a.u01_account_category_id_v01 AS category,
            a.acctype AS accounttype,
            a.u01_first_name AS firstname,
            a.u01_first_name_lang AS firstnamelang,
            a.u01_second_name AS secondname,
            a.u01_second_name_lang AS secondnamelang,
            a.u01_third_name AS thirdname,
            a.u01_third_name_lang AS thirdnamelang,
            a.u01_last_name AS lastname,
            a.u01_last_name_lang AS lastnamelang,
            a.u01_display_name AS displayname,
            a.u01_display_name_lang AS displaynamelang,
            a.u01_gender AS gender,
            a.u01_title_id_v01 AS title
       FROM vw_customer_list a);
/
