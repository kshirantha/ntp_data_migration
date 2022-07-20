CREATE OR REPLACE PROCEDURE dfn_ntp.sp_m151_set_as_default(
       pm151_id  IN Number, 
       pm151_institute_id_m02 IN Number,
       pm151_modified_by_id_u17 IN Number) 
IS
BEGIN
       UPDATE
          m151_trade_confirm_config
       SET
           m151_is_default = 0
       WHERE m151_institute_id_m02 = pm151_institute_id_m02;

       UPDATE
          m151_trade_confirm_config
       SET
          m151_is_default = 1,
          m151_modified_by_id_u17 = pm151_modified_by_id_u17,
          m151_modified_date = Sysdate
       WHERE m151_id= pm151_Id AND m151_institute_id_m02 = pm151_institute_id_m02;
END;
/
