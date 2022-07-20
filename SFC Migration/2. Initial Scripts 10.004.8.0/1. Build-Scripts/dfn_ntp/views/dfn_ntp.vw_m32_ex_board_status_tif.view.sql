CREATE OR REPLACE FORCE VIEW dfn_ntp.vw_m32_ex_board_status_tif
(
    m32_id,
    m32_tif_type_id_v10,
    m32_brd_status_id_v19,
    m32_board_code_m54,
    tif_type,
    m32_order_type_id_v06,
    order_type,
    m32_status_id_m30,
    board_status,
    m32_exchange_code_m01,
    m32_exchange_id_m01,
    m32_exchange_order_type_id_m57,
    m01_institute_id_m02,
    ord_typ_id
)
AS
    SELECT m32.m32_id,
           m32.m32_tif_type_id_v10,
           m32.m32_brd_status_id_v19,
           m32.m32_board_code_m54,
           v10.v10_description AS tif_type,
           m32.m32_order_type_id_v06,
           v06.v06_description_1 AS order_type,
           m32.m32_status_id_m30,
           v19.v19_status AS board_status,
           m32.m32_exchange_code_m01,
           m32.m32_exchange_id_m01,
           m32.m32_exchange_order_type_id_m57,
           m01.m01_institute_id_m02,
           v06.v06_type_id AS ord_typ_id
      FROM m32_ex_board_status_tif m32
           JOIN v10_tif v10
               ON m32.m32_tif_type_id_v10 = v10.v10_id
           JOIN v06_order_type v06
               ON m32.m32_order_type_id_v06 = v06.v06_id
           LEFT JOIN v19_board_status v19
               ON v19.v19_id = m32.m32_brd_status_id_v19
           JOIN m01_exchanges m01
               ON m32.m32_exchange_id_m01 = m01.m01_id
/