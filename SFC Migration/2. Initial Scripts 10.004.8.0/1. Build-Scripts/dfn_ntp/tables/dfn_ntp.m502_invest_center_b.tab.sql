CREATE TABLE dfn_ntp.m502_invest_center_b
(
    m502_id             NUMBER (10, 0),
    m502_name           VARCHAR2 (100 BYTE),
    m502_name_lang      VARCHAR2 (100 BYTE),
    m502_contact_no     VARCHAR2 (20 BYTE),
    m502_address        VARCHAR2 (200 BYTE),
    m502_address_lang   VARCHAR2 (200 BYTE),
    m502_x_cordinate    VARCHAR2 (20 BYTE),
    m502_y_cordinate    VARCHAR2 (20 BYTE),
    m502_created_date     DATE DEFAULT SYSDATE
)
/
