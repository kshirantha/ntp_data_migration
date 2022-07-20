CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_announcements
(
    id,
    announcement_date,
    symbol,
    exchangecode,
    heading_1,
    body_1
)
AS
    SELECT a.id,
           a.time AS announcement_date,
           a.symbol,
           a.exchangecode,
           a.heading_1,
           TO_CHAR (SUBSTR (a.body_1, 1, 2200)) AS body_1
      FROM dfn_price.announcements a;
/
