CREATE TABLE dfn_ntp.m164_cust_charge_discounts
(
    m164_id                         NUMBER (15, 0) NOT NULL,
    m164_cash_account_u06           NUMBER (18, 0) NOT NULL,
    m164_charges_group_m117         NUMBER (5, 0) NOT NULL,
    m164_charge_structure_m118      NUMBER (10, 0) NOT NULL,
    m164_flat_discount              NUMBER (18, 5) DEFAULT 0,
    m164_discount_percentage        NUMBER (18, 5) DEFAULT 0,
    m164_status_id_v01              NUMBER (2, 0) NOT NULL,
    m164_created_by_id_u17          NUMBER (10, 0) NOT NULL,
    m164_created_date               DATE NOT NULL,
    m164_status_changed_by_id_u17   NUMBER (10, 0) NOT NULL,
    m164_status_changed_date        DATE,
    m164_modified_date              DATE,
    m164_modified_by_id_u17         NUMBER (10, 0),
    m164_custom_type                VARCHAR2 (50 BYTE) DEFAULT 1,
    m164_institute_id_m02           NUMBER (3, 0) DEFAULT 1
)
SEGMENT CREATION IMMEDIATE
NOPARALLEL
LOGGING
MONITORING
/

ALTER TABLE dfn_ntp.m164_cust_charge_discounts
ADD CONSTRAINT m164_pk PRIMARY KEY (m164_id)
USING INDEX
/

ALTER TABLE dfn_ntp.m164_cust_charge_discounts
 ADD (
	  m164_exchange_code_m01          VARCHAR2 (10 BYTE),
    m164_exchange_id_m01            NUMBER (5, 0),
    m164_fee_type_m121              NUMBER (3, 0) DEFAULT 0,
    m164_discount_group_id_m165     NUMBER (10, 0),
    m164_currency_code_m03          CHAR (3 BYTE),
    m164_currency_id_m03            NUMBER (5, 0),
    m164_charge_code_m97            VARCHAR2 (10 BYTE)
 )
/

ALTER TABLE dfn_ntp.m164_cust_charge_discounts
 MODIFY (
  m164_institute_id_m02 DEFAULT NULL
 )
/

ALTER TABLE dfn_ntp.m164_cust_charge_discounts
 drop column m164_charges_group_m117
/

ALTER TABLE dfn_ntp.m164_cust_charge_discounts
 drop column m164_cash_account_u06
/

ALTER TABLE dfn_ntp.m164_cust_charge_discounts
 DROP COLUMN m164_charge_structure_m118
/

ALTER TABLE dfn_ntp.m164_cust_charge_discounts
 DROP COLUMN m164_exchange_code_m01
/

ALTER TABLE dfn_ntp.m164_cust_charge_discounts
 DROP COLUMN m164_exchange_id_m01
/

ALTER TABLE dfn_ntp.m164_cust_charge_discounts
 MODIFY (
  m164_status_id_v01 NUMBER (5, 0)
 )
/

ALTER TABLE dfn_ntp.m164_cust_charge_discounts
    DROP COLUMN m164_fee_type_m121
/