CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_customer_sms_all
(
    u01_id,
    u01_customer_no,
    u02_mobile,
    u02_email,
    m02_name,
    u01_full_name,
    m05_name
)
AS
    SELECT u01.u01_id,
           u01.u01_customer_no,
           u01_def_mobile AS u02_mobile,
           u01.u01_def_email AS u02_email,
           m02.m02_name,
           u01.u01_full_name,
           m05.m05_name
      FROM u01_customer u01
           JOIN m05_country m05
               ON u01.u01_nationality_id_m05 = m05.m05_id
           JOIN m02_institute m02
               ON u01.u01_institute_id_m02 = m02.m02_id;
/
