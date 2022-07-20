CREATE TABLE dfn_ntp.v29_order_channel
(
    v29_id                       NUMBER (5, 0) NOT NULL,
    v29_description              VARCHAR2 (50 BYTE) NOT NULL,
    v29_order_channel_category   NUMBER (2, 0) DEFAULT 2 NOT NULL,
    v29_trader_id_prefix         VARCHAR2 (5 BYTE),
    v29_custom_type              VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.v29_order_channel
ADD CONSTRAINT v29_pk PRIMARY KEY (v29_id)
USING INDEX
/

COMMENT ON COLUMN dfn_ntp.v29_order_channel.v29_order_channel_category IS
    '1= Online | 2= Offline'
/

ALTER TABLE dfn_ntp.v29_order_channel
 ADD (
  v29_order_channel_type NUMBER (5,0) DEFAULT 2
 )
/

COMMENT ON COLUMN dfn_ntp.v29_order_channel.v29_order_channel_type IS
    '1=Employee Channel(AT/DT/AMS) | 2=Other Channel'
/

COMMENT ON COLUMN dfn_ntp.V29_ORDER_CHANNEL.V29_ORDER_CHANNEL_TYPE IS '1=Employee Channel(AT/DT/AMS/System) | 2=Other Channel'
/

ALTER TABLE dfn_ntp.v29_order_channel
 ADD (
  v29_authentication_type NUMBER (5,0) DEFAULT 2
 )
/

COMMENT ON COLUMN dfn_ntp.V29_ORDER_CHANNEL.V29_AUTHENTICATION_TYPE IS '1=NONE|2=DB|3=LDAP'
/

DECLARE
    l_count   NUMBER := 0;
    l_ddl     VARCHAR2 (1000)
                  := 'ALTER TABLE dfn_ntp.v29_order_channel
 ADD (
  v29_ignore_price_subscription NUMBER (1) DEFAULT 0
 )
';
BEGIN
    SELECT COUNT (*)
      INTO l_count
      FROM all_tab_columns
     WHERE     owner = UPPER ('dfn_ntp')
           AND table_name = UPPER ('v29_order_channel')
           AND column_name = UPPER ('v29_ignore_price_subscription');

    IF l_count = 0
    THEN
        EXECUTE IMMEDIATE l_ddl;
    END IF;
END;
/

COMMENT ON COLUMN dfn_ntp.v29_order_channel.v29_ignore_price_subscription IS
    '1=Ignore'
/

ALTER TABLE dfn_ntp.v29_order_channel
  DROP COLUMN v29_ignore_price_subscription
/