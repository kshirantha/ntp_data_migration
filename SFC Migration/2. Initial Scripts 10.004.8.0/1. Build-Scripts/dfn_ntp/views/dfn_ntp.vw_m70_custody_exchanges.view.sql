CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m70_custody_exchanges
(
    m70_id,
    m70_exec_broker_id_m26,
    custodian_name,
    m70_exchange_code_m01,
    m70_exchange_id_m01,
    institute_id
)
AS
    SELECT m70.m70_id,
           m70.m70_exec_broker_id_m26,
		   m26.m26_sid || '-' || m26.m26_name AS custodian_name,
           m70.m70_exchange_code_m01,
           m70.m70_exchange_id_m01,
           m01.m01_institute_id_m02 AS institute_id
      FROM m70_custody_exchanges m70
           INNER JOIN vw_m26_custody m26
               ON m70.m70_exec_broker_id_m26 = m26.m26_id
           INNER JOIN m01_exchanges m01
               ON m70.m70_exchange_id_m01 = m01.m01_id
/
