-- Table DFN_NTP.M55_PRICE_BLOCK_TYPES

CREATE TABLE dfn_ntp.m55_price_block_types
(
    m55_id                 NUMBER (2, 0),
    m55_description        VARCHAR2 (75),
    m55_description_lang   VARCHAR2 (75)
)
/

-- Constraints for  DFN_NTP.M55_PRICE_BLOCK_TYPES


  ALTER TABLE dfn_ntp.m55_price_block_types ADD CONSTRAINT m55_pk PRIMARY KEY (m55_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m55_price_block_types MODIFY (m55_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m55_price_block_types MODIFY (m55_description NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M55_PRICE_BLOCK_TYPES
