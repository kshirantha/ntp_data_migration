CREATE TABLE dfn_ntp.m34_exec_broker_commission
(
    m34_start                    NUMBER (18, 5),
    m34_end                      NUMBER (18, 5),
    m34_percent                  NUMBER (18, 5),
    m34_flat_comm                NUMBER (15, 5),
    m34_min_comm                 NUMBER (15, 5),
    m34_exec_broker_id_m26       NUMBER (4, 0),
    m34_exchange_code_m01        VARCHAR2 (10 BYTE),
    m34_instrument_type          VARCHAR2 (20 BYTE),
    m34_type                     NUMBER (5, 0),
    m34_currency_code_m03        VARCHAR2 (4 BYTE),
    m34_id                       NUMBER (5, 0),
    m34_currency_id_m03          NUMBER (15, 0),
    m34_exchange_id_m01          NUMBER (15, 0),
    m34_created_by_id_u17        NUMBER (10, 0),
    m34_created_date             DATE,
    m34_modified_by_id_u17       NUMBER (10, 0),
    m34_modified_date            DATE,
    m34_instrument_type_id_v09   NUMBER (5, 0),
    m34_vat_percentage           NUMBER (15, 4),
    m34_vat_charge_type_m124     NUMBER (10, 0)
)
/

alter table dfn_ntp.M34_EXEC_BROKER_COMMISSION
	add M34_CUSTOM_TYPE varchar2(50) default 1
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE DFN_NTP.M34_EXEC_BROKER_COMMISSION 
 ADD (
  M34_CATEGORY NUMBER (5, 0) DEFAULT 0
)
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('DFN_NTP')
           AND table_name = UPPER ('M34_EXEC_BROKER_COMMISSION')
           AND column_name = UPPER ('M34_CATEGORY');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN DFN_NTP.M34_EXEC_BROKER_COMMISSION.M34_CATEGORY IS '0 - Exchange | 1 - CMA | 2 - CCP | 3 - DCM/GCM'
/
