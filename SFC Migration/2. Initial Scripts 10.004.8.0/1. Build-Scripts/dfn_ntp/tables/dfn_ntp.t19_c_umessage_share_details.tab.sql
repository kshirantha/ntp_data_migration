-- Table DFN_NTP.T19_C_UMESSAGE_SHARE_DETAILS

CREATE TABLE dfn_ntp.t19_c_umessage_share_details
(
    t19_id                      NUMBER (18, 0),
    t19_t18_id                  VARCHAR2 (25),
    t19_exchange                VARCHAR2 (10),
    t19_symbol                  VARCHAR2 (25),
    t19_isin_9719               VARCHAR2 (25),
    t19_shares_53               NUMBER (18, 0),
    t19_shares_available_9957   NUMBER (18, 0),
    t19_shares_pledge_9958      NUMBER (18, 0),
    t19_position_date_9720      DATE,
    t19_change_date_9721        DATE,
    t19_net_holding             NUMBER (18, 0)
)
/

-- Constraints for  DFN_NTP.T19_C_UMESSAGE_SHARE_DETAILS


  ALTER TABLE dfn_ntp.t19_c_umessage_share_details MODIFY (t19_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.t19_c_umessage_share_details ADD CONSTRAINT t19_pk PRIMARY KEY (t19_id)
  USING INDEX  ENABLE
/



-- End of DDL Script for Table DFN_NTP.T19_C_UMESSAGE_SHARE_DETAILS

ALTER TABLE DFN_NTP.T19_C_UMESSAGE_SHARE_DETAILS 
 ADD (
  T19_INSTITUTE_ID_M02 NUMBER (3, 0)
 )
/

ALTER TABLE dfn_ntp.t19_c_umessage_share_details
 ADD (
  t19_symbol_id_m20 NUMBER (10)
 )
/