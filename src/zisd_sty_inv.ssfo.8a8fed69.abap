
*data : lwa_data      type zist_einv_9030,
*       lit_swastrtab type table of swastrtab,
*       lv_qrcode     type string,
*       wa_swastrtab  type swastrtab.
*CLEAR :lwa_data.
*
*data(bill_no) = IS_HDREF-BIL_NUMBER.
**SHIFT bill_no LEFT DELETING LEADING '0'.
*select single * from zita_einv_9013 into gwa_irn_data
*       where vbeln eq bill_no.
*
**break ibs_sd.
*if gwa_irn_data is not initial.
*  lwa_data-vbeln = gwa_irn_data-vbeln.
*  lwa_data-bukrs = gwa_irn_data-bukrs.
*  lwa_data-belnr = gwa_irn_data-belnr.
*  lwa_data-gjahr = gwa_irn_data-gjahr.
*  IRN = gwa_irn_data-IRN.
*
*  call function 'ZIFM_EINV_9013_QR_CODE'
*    exporting
*      im_data = lwa_data
*    importing
*      ex_data = lv_qrcode.
*
*  call function 'SWA_STRING_SPLIT'
*    exporting
*      input_string         = lv_qrcode
*      max_component_length = 255
*    tables
*      string_components    = lit_swastrtab.
*
*  if lit_swastrtab is not initial.
*    clear wa_swastrtab-str.
*    loop at lit_swastrtab into wa_swastrtab.
*      case sy-tabix.
*        when '1'.
*          str1 = wa_swastrtab-str.
*        when '2'.
*          str2 = wa_swastrtab-str.
*        when '3'.
*          str3 = wa_swastrtab-str.
*        when '4'.
*          str4 = wa_swastrtab-str.
*        when '5'.
*          str5 = wa_swastrtab-str.
*        when '6'.
*          str6 = wa_swastrtab-str.
*        when '7'.
*          str7 = wa_swastrtab-str.
*        when '8'.
*          str8 = wa_swastrtab-str.
*        when '9'.
*          str9 = wa_swastrtab-str.
*      endcase.
*      clear wa_swastrtab-str.
*    endloop.
*  endif.
*endif.





















