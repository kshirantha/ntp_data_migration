-- Table DFN_NTP.M80_MARGIN_PRODUCTS_EQUATION

CREATE TABLE dfn_ntp.m80_margin_products_equation
(
    m80_id         NUMBER (5, 0),
    m80_equation   VARCHAR2 (15)
)
/

-- Constraints for  DFN_NTP.M80_MARGIN_PRODUCTS_EQUATION


  ALTER TABLE dfn_ntp.m80_margin_products_equation ADD CONSTRAINT m80_id PRIMARY KEY (m80_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m80_margin_products_equation MODIFY (m80_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m80_margin_products_equation MODIFY (m80_equation NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.M80_MARGIN_PRODUCTS_EQUATION
