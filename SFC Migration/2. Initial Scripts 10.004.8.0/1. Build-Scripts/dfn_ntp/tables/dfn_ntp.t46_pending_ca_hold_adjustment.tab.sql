CREATE TABLE dfn_ntp.t46_pending_ca_hold_adjustment
(
    t46_id                      NUMBER (5, 0),
    t46_id_t41                  NUMBER (5, 0),
    t46_approved_quantity_t42   NUMBER (18, 0),
    t46_is_approved             NUMBER (1, 0),
    t46_id_t44                  NUMBER (5, 0),
    t46_eligible_quantity_t42   NUMBER (18, 5),
    t46_avg_cost_t42            NUMBER (18, 5),
    t46_id_m142                 NUMBER (5, 0)
)
/

alter table dfn_ntp.T46_PENDING_CA_HOLD_ADJUSTMENT
	add T46_CUSTOM_TYPE varchar2(50) default 1
/

ALTER TABLE dfn_ntp.t46_pending_ca_hold_adjustment
 ADD (
  t46_institute_id_m02 NUMBER (3, 0) DEFAULT 1
 )
/

ALTER TABLE dfn_ntp.t46_pending_ca_hold_adjustment
 MODIFY (
  t46_id_t41 NUMBER (15, 0)
 )
/
