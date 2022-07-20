CREATE TABLE dfn_ntp.u02_customer_contact_info
(
    u02_id                         NUMBER (10, 0) NOT NULL,
    u02_customer_id_u01            NUMBER (10, 0) NOT NULL,
    u02_is_default                 NUMBER (1, 0) NOT NULL,
    u02_mobile                     VARCHAR2 (20 BYTE),
    u02_fax                        VARCHAR2 (20 BYTE),
    u02_email                      VARCHAR2 (50 BYTE),
    u02_po_box                     VARCHAR2 (255 BYTE),
    u02_zip_code                   VARCHAR2 (100 BYTE),
    u02_address_line1              VARCHAR2 (255 BYTE),
    u02_address_line1_lang         VARCHAR2 (255 BYTE),
    u02_address_line2              VARCHAR2 (255 BYTE),
    u02_address_line2_lang         VARCHAR2 (255 BYTE),
    u02_telephone                  VARCHAR2 (20 BYTE),
    u02_contact_description        VARCHAR2 (100 BYTE),
    u02_created_by_id_u17          NUMBER (10, 0),
    u02_created_date               DATE,
    u02_modified_by_id_u17         NUMBER (10, 0),
    u02_modified_date              DATE,
    u02_city_id_m06                NUMBER (5, 0),
    u02_country_id_m05             NUMBER (5, 0),
    u02_building_no                NUMBER (10, 0),
    u02_unit_no                    NUMBER (10, 0),
    u02_district                   VARCHAR2 (100 BYTE),
    u02_additional_code            NUMBER (10, 0),
    u02_status_id_v01              NUMBER (5, 0),
    u02_status_changed_by_id_u17   NUMBER (10, 0),
    u02_status_changed_date        DATE,
    u02_district_lang              VARCHAR2 (100 BYTE),
    u02_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    u02_cc_email                   VARCHAR2 (50 BYTE),
    u02_bcc_email                  VARCHAR2 (50 BYTE),
    CONSTRAINT pk_u02_id PRIMARY KEY (u02_id)
)
SEGMENT CREATION IMMEDIATE
ORGANIZATION INDEX
PCTTHRESHOLD 50
/

ALTER TABLE dfn_ntp.u02_customer_contact_info
 MODIFY (
  u02_mobile VARCHAR2 (35 BYTE),
  u02_fax VARCHAR2 (35 BYTE),
  u02_email VARCHAR2 (100 BYTE),
  u02_telephone VARCHAR2 (35 BYTE),
  u02_contact_description VARCHAR2 (350 BYTE),
  u02_cc_email VARCHAR2 (350 BYTE),
  u02_bcc_email VARCHAR2 (350 BYTE)

 )
/

CREATE INDEX dfn_ntp.idx_u02_customer_id_u01
    ON dfn_ntp.u02_customer_contact_info (u02_customer_id_u01 DESC)
    NOPARALLEL
    LOGGING
/

CREATE INDEX dfn_ntp.idx_u02_city_id_m06
    ON dfn_ntp.u02_customer_contact_info (u02_city_id_m06 ASC)
/

CREATE INDEX dfn_ntp.idx_u02_country_id_m05
    ON dfn_ntp.u02_customer_contact_info (u02_country_id_m05 ASC)
/
