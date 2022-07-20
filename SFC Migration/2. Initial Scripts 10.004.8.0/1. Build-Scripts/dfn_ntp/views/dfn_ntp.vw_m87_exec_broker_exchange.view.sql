CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m87_exec_broker_exchange
(
    m87_id,
    m87_exec_broker_id_m26,
    exec_broker_name,
    m87_exchange_code_m01,
    m87_exchange_id_m01,
    m87_fix_tag_50,
    m87_fix_tag_142,
    m87_fix_tag_57,
    m87_fix_tag_115,
    m87_fix_tag_116,
    m87_fix_tag_128,
    m87_fix_tag_22,
    m87_fix_tag_109,
    m87_fix_tag_100,
    fix_tag_22,
    status
)
AS
    (SELECT m87.m87_id,
            m87.m87_exec_broker_id_m26,
            CASE
                WHEN m26.m26_sid IS NOT NULL
                THEN
                    m26.m26_sid || '-' || m26.m26_name
                ELSE
                    m26.m26_name
            END AS exec_broker_name,
            m87.m87_exchange_code_m01,
            m87.m87_exchange_id_m01,
            m87.m87_fix_tag_50,
            m87.m87_fix_tag_142,
            m87.m87_fix_tag_57,
            m87.m87_fix_tag_115,
            m87.m87_fix_tag_116,
            m87.m87_fix_tag_128,
            m87.m87_fix_tag_22,
            m87.m87_fix_tag_109,
            m87.m87_fix_tag_100,
            CASE m87.m87_fix_tag_22
                WHEN '4' THEN 'ISIN Number'
                WHEN '5' THEN 'RIC code'
                WHEN '8' THEN 'Exchange Symbol'
                WHEN 'A' THEN 'Bloomberg Symbol'
                ELSE 'Exchange Symbol'
            END AS fix_tag_22,
            2   AS status -- This is to show the edit button by default since no status is maintained
     FROM m87_exec_broker_exchange m87
          JOIN vw_m26_exec_broker m26
              ON m87.m87_exec_broker_id_m26 = m26.m26_id)
/