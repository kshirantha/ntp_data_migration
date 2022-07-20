CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_i_employee_login
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
    SELECT u17_id AS usrid,
           0 AS u01customerid,
           u17_login_name AS loginname,
           u17_password AS password,
           u17_login_status AS authsts,
           u17_type_id_m11 AS l2authtyp,
           u17_failed_attempts AS failatmps,
           u17_login_status AS rejresn,
           0 AS mubno,
           u17_full_name AS cusnme,
           '' AS preflang,
           '' AS clacctype,
           0 AS dlrid,
           u17_institution_id_m02 AS instid,
           u17_full_name AS lgnals,
           '' AS cntrycode,
           'MUBASHER/vc1TQBV1EI1QQBT1Eg1RQBS1Hw16wBB1E+1QgBB1D61LgBV1EJ1SQBc1DE1NQ1w1DE1MQ1+1D11511a1DQ15Q1J1DI1f1B613I16w1w1DM1Mw1C1DQ1M11y1Dg15Q1J1D81Mw1A1DQ1511A1D11M11F1Dk1M11O1Dg1N11y1G+='
               AS prcusr
      FROM u17_employee;
/
