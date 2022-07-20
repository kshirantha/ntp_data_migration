CREATE TABLE dfn_ntp.m157_subcription_prd_channels
(
    m157_subs_prd_id_m152   NUMBER (4, 0) NOT NULL,
    m157_channel_id_v29     NUMBER (4, 0) NOT NULL
)
/

ALTER TABLE dfn_ntp.m157_subcription_prd_channels
ADD CONSTRAINT pk_m157 PRIMARY KEY (m157_subs_prd_id_m152, m157_channel_id_v29)
USING INDEX
/

