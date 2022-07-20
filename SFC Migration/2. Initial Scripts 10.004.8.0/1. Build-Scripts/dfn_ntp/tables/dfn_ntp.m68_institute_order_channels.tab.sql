-- Table DFN_NTP.M68_INSTITUTE_ORDER_CHANNELS

CREATE TABLE dfn_ntp.m68_institute_order_channels
(
    m68_id                          NUMBER (10, 0),
    m68_channel_id_v29              NUMBER (10, 0),
    m68_institution_id_m02          NUMBER (10, 0),
    m68_ignore_commision_discount   NUMBER (1, 0) DEFAULT 0
)
/

-- Constraints for  DFN_NTP.M68_INSTITUTE_ORDER_CHANNELS


  ALTER TABLE dfn_ntp.m68_institute_order_channels ADD CONSTRAINT m68_pk PRIMARY KEY (m68_id)
  USING INDEX  ENABLE
/

  ALTER TABLE dfn_ntp.m68_institute_order_channels MODIFY (m68_id NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m68_institute_order_channels MODIFY (m68_channel_id_v29 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m68_institute_order_channels MODIFY (m68_institution_id_m02 NOT NULL ENABLE)
/

  ALTER TABLE dfn_ntp.m68_institute_order_channels MODIFY (m68_ignore_commision_discount NOT NULL ENABLE)
/



-- Comments for  DFN_NTP.M68_INSTITUTE_ORDER_CHANNELS

COMMENT ON COLUMN dfn_ntp.m68_institute_order_channels.m68_channel_id_v29 IS
    'fk from v29'
/
COMMENT ON COLUMN dfn_ntp.m68_institute_order_channels.m68_institution_id_m02 IS
    'fk from m02'
/
COMMENT ON COLUMN dfn_ntp.m68_institute_order_channels.m68_ignore_commision_discount IS
    '0 - No, 1 - Ignore'
/
-- End of DDL Script for Table DFN_NTP.M68_INSTITUTE_ORDER_CHANNELS

alter table dfn_ntp.M68_INSTITUTE_ORDER_CHANNELS
	add M68_CUSTOM_TYPE varchar2(50) default 1
/
