CREATE TABLE dfn_ntp.e_tmpl_6_customer_default
    (MEMBER                         VARCHAR2(100 BYTE),
    account                        VARCHAR2(100 BYTE),
    reference                      VARCHAR2(100 BYTE),
    identification_number          VARCHAR2(100 BYTE),
    registry_ident                 VARCHAR2(100 BYTE),
    birth_date                     VARCHAR2(100 BYTE),
    title                          VARCHAR2(100 BYTE),
    long_name                      VARCHAR2(100 BYTE),
    guardian_ident_number          VARCHAR2(100 BYTE),
    guardian                       VARCHAR2(100 BYTE),
    address_line_one               VARCHAR2(100 BYTE),
    address_line_two               VARCHAR2(100 BYTE),
    address_line_three             VARCHAR2(100 BYTE),
    postal_code                    VARCHAR2(100 BYTE),
    city                           VARCHAR2(100 BYTE),
    tax_collection_point           VARCHAR2(100 BYTE),
    country_code                   VARCHAR2(100 BYTE),
    guard_address_line_one         VARCHAR2(100 BYTE),
    postal_code2                   VARCHAR2(100 BYTE),
    city2                          VARCHAR2(100 BYTE),
    tax_collection_point2          VARCHAR2(100 BYTE),
    country_code2                  VARCHAR2(100 BYTE),
    phone_number_one               VARCHAR2(100 BYTE),
    swift_code                     VARCHAR2(100 BYTE),
    bank_account                   VARCHAR2(100 BYTE),
    individual_id_one              VARCHAR2(100 BYTE),
    individual_id_two              VARCHAR2(100 BYTE),
    individual_id_three            VARCHAR2(100 BYTE),
    corporate_id_one               VARCHAR2(100 BYTE),
    corporate_id_two               VARCHAR2(100 BYTE),
    citizenship                    VARCHAR2(100 BYTE),
    gender                         VARCHAR2(100 BYTE),
    change_date                    VARCHAR2(100 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
    ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'
    FIELDS TERMINATED BY '|'
   )
   LOCATION (
    ext_dir:'customer_upload_default.txt'
   )
  )
  NOPARALLEL
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000) := 'DROP TABLE dfn_ntp.e_tmpl_6_customer_default';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tables
     WHERE owner = UPPER ('dfn_ntp') AND table_name = UPPER ('e_tmpl_6_customer_default');

    IF l_count > 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

CREATE TABLE dfn_ntp.e_tmpl_6_customer_default
    (MEMBER                         VARCHAR2(100 BYTE),
    account                        VARCHAR2(100 BYTE),
    reference                      VARCHAR2(100 BYTE),
    identification_number          VARCHAR2(100 BYTE),
    registry_ident                 VARCHAR2(100 BYTE),
    birth_date                     VARCHAR2(100 BYTE),
    title                          VARCHAR2(100 BYTE),
    long_name                      VARCHAR2(100 BYTE),
    guardian_ident_number          VARCHAR2(100 BYTE),
    guardian                       VARCHAR2(100 BYTE),
    address_line_one               VARCHAR2(100 BYTE),
    address_line_two               VARCHAR2(100 BYTE),
    address_line_three             VARCHAR2(100 BYTE),
    postal_code                    VARCHAR2(100 BYTE),
    city                           VARCHAR2(100 BYTE),
    tax_collection_point           VARCHAR2(100 BYTE),
    country_code                   VARCHAR2(100 BYTE),
    guard_address_line_one         VARCHAR2(100 BYTE),
    postal_code2                   VARCHAR2(100 BYTE),
    city2                          VARCHAR2(100 BYTE),
    tax_collection_point2          VARCHAR2(100 BYTE),
    country_code2                  VARCHAR2(100 BYTE),
    phone_number_one               VARCHAR2(100 BYTE),
    swift_code                     VARCHAR2(100 BYTE),
    bank_account                   VARCHAR2(100 BYTE),
    individual_id_one              VARCHAR2(100 BYTE),
    individual_id_two              VARCHAR2(100 BYTE),
    individual_id_three            VARCHAR2(100 BYTE),
    corporate_id_one               VARCHAR2(100 BYTE),
    corporate_id_two               VARCHAR2(100 BYTE),
    citizenship                    VARCHAR2(100 BYTE),
    gender                         VARCHAR2(100 BYTE),
    change_date                    VARCHAR2(100 BYTE))
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION EXTERNAL (
   DEFAULT DIRECTORY  ext_dir
    ACCESS PARAMETERS(RECORDS DELIMITED BY '\n'
    FIELDS TERMINATED BY '|'
   )
   LOCATION (
    ext_dir:'customer_default_6.txt'
   )
  )
  NOPARALLEL
/