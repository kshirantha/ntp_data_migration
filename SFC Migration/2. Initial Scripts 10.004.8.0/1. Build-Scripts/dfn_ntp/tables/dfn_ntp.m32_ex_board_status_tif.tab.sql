CREATE TABLE dfn_ntp.m32_ex_board_status_tif
(
    m32_id                           NUMBER (3, 0),
    m32_tif_type_id_v10              NUMBER (3, 0),
    m32_status_id_m30                NUMBER (4, 0),
    m32_order_type_id_v06            NUMBER (4, 0),
    m32_board_code_m54               VARCHAR2 (6 BYTE),
    m32_brd_status_id_v19            NUMBER (2, 0),
    m32_exchange_code_m01            VARCHAR2 (10 BYTE),
    m32_exchange_id_m01              NUMBER (10, 0),
    m32_exchange_order_type_id_m57   NUMBER (10, 0),
    m32_custom_type                  VARCHAR2 (50 BYTE) DEFAULT 1
)
/

ALTER TABLE dfn_ntp.m32_ex_board_status_tif
 MODIFY (
  m32_board_code_m54 VARCHAR2 (10 BYTE)

 )
/