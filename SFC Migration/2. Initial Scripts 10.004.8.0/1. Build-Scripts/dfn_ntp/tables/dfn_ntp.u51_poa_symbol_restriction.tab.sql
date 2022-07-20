-- Table DFN_NTP.U51_POA_SYMBOL_RESTRICTION

CREATE TABLE dfn_ntp.u51_poa_symbol_restriction
(
    u51_id                   NUMBER (10, 0),
    u51_poa_id_u47           NUMBER (10, 0),
    u51_symbol_id_m20        NUMBER (10, 0),
    u51_restriction_id_v31   NUMBER (10, 0)
)
/

-- Constraints for  DFN_NTP.U51_POA_SYMBOL_RESTRICTION


  ALTER TABLE dfn_ntp.u51_poa_symbol_restriction MODIFY (u51_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u51_poa_symbol_restriction MODIFY (u51_poa_id_u47 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u51_poa_symbol_restriction MODIFY (u51_symbol_id_m20 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.u51_poa_symbol_restriction MODIFY (u51_restriction_id_v31 NOT NULL ENABLE)
/



-- End of DDL Script for Table DFN_NTP.U51_POA_SYMBOL_RESTRICTION
