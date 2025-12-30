data : lv_emlif type emlif,
       lv_adrnr TYPE AD_ADDRNUM.

CLEAR GW_ADRC.
CLEAR GW_LFA1.
**** check vendor in deliv.address tab
*BREAK-POINT.
clear lv_emlif.
select single emlif into lv_emlif
   from ekpo where
  ebeln = objky.
  if sy-subrc = 0. "if available get vend.address
    CLEAR GW_LFA1.
    SELECT SINGLE * FROM lfa1 INTO GW_LFA1
      WHERE LIFNR = lv_emlif.
      if sy-subrc = 0.
        CLEAR gw_adrc.
        SELECT SINGLE * FROM adrc INTO gw_adrc
           WHERE ADDRNUMBER = GW_LFA1-adrnr.
        endif.
    endif.




















