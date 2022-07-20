CREATE TABLE dfn_ntp.v36_margin_product_equation
(
    v36_id                      NUMBER (3, 0) NOT NULL,
    v36_margin_product_id_v01   NUMBER (2, 0) NOT NULL,
    v36_equation_id_v01         NUMBER (5, 0) NOT NULL
)
/

ALTER TABLE dfn_ntp.V36_MARGIN_PRODUCT_EQUATION 
 MODIFY (
  V36_MARGIN_PRODUCT_ID_V01 NUMBER (5, 0)

 )
/

ALTER TABLE dfn_ntp.V36_MARGIN_PRODUCT_EQUATION 
 ADD (
  V36_IS_VISIBLE NUMBER (1, 0) DEFAULT 1 NOT NULL
 )
/

ALTER TABLE dfn_ntp.V36_MARGIN_PRODUCT_EQUATION 
 MODIFY (
  V36_ID NUMBER (10, 0)

 )
/

