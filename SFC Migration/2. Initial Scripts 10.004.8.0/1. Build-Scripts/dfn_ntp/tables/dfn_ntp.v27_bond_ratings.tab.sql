-- Table DFN_NTP.V27_BOND_RATINGS

CREATE TABLE dfn_ntp.v27_bond_ratings
(
    v27_id            NUMBER (2, 0),
    v27_description   VARCHAR2 (50)
)
/

-- Constraints for  DFN_NTP.V27_BOND_RATINGS


  ALTER TABLE dfn_ntp.v27_bond_ratings MODIFY (v27_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.v27_bond_ratings MODIFY (v27_description NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.V27_BOND_RATINGS
