CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_i_user_login
(
    usrid,
    u01customerid,
    loginname,
    password,
    authsts,
    l2authtyp,
    failatmps,
    rejresn,
    mubno,
    cusnme,
    preflang,
    clacctype,
    dlrid,
    instid,
    lgnals,
    cntrycode,
    prcusr
)
AS
    (SELECT u09_id AS usrid,
            u09_customer_id_u01 AS u01customerid,
            u09_login_name AS loginname,
            u09_login_password AS password,
            u09_login_status_id_v01 AS authsts,
            u09_login_auth_type_id_v01 AS l2authtyp,
            u09_failed_attempts AS failatmps,
            u09_login_status_id_v01 AS rejresn,
            u01_customer_no AS mubno,
            u01_display_name AS cusnme,
            u01_preferred_lang_id_v01 AS preflang,
            u01_account_type_id_v01 AS clacctype,
            0 AS dlrid,
            0 AS instid,
            u01_display_name AS lgnals,
            '' AS cntrycode,
            'MUBASHER/vc1TQBV1EI1QQBT1Eg1RQBS1Hw16wBB1E+1QgBB1D61LgBV1EJ1SQBc1DE1NQ1w1DE1MQ1+1D11511a1DQ15Q1J1DI1f1B613I16w1w1DM1Mw1C1DQ1M11y1Dg15Q1J1D81Mw1A1DQ1511A1D11M11F1Dk1M11O1Dg1N11y1G+='
                AS prcusr
       FROM u09_customer_login, u01_customer
      WHERE u09_customer_id_u01 = u01_id);
/
