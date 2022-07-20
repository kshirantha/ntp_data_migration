CREATE OR REPLACE FUNCTION dfn_ntp.get_tplus_count (
    p_day_of_week    NUMBER,
    p_tplus_sun      NUMBER DEFAULT 0,
    p_tplus_mon      NUMBER DEFAULT 0,
    p_tplus_tue      NUMBER DEFAULT 0,
    p_tplus_wed      NUMBER DEFAULT 0,
    p_tplus_thu      NUMBER DEFAULT 0,
    p_tplus_fri      NUMBER DEFAULT 0,
    p_tplus_sat      NUMBER DEFAULT 0)
    RETURN INT
IS
    tplus   NUMBER DEFAULT 0;
BEGIN
    IF p_day_of_week = 1
    THEN
        tplus := p_tplus_sun;
    ELSIF p_day_of_week = 2
    THEN
        tplus := p_tplus_mon;
    ELSIF p_day_of_week = 3
    THEN
        tplus := p_tplus_tue;
    ELSIF p_day_of_week = 4
    THEN
        tplus := p_tplus_wed;
    ELSIF p_day_of_week = 5
    THEN
        tplus := p_tplus_thu;
    ELSIF p_day_of_week = 6
    THEN
        tplus := p_tplus_fri;
    ELSIF p_day_of_week = 7
    THEN
        tplus := p_tplus_sat;
    END IF;

    RETURN tplus;
END;
/
/
