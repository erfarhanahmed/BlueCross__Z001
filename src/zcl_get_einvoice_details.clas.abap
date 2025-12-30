class ZCL_GET_EINVOICE_DETAILS definition
  public
  final
  create public .

public section.

  methods GET_DATA
    importing
      !I_BUKRS type BUKRS
      !I_DOCNO type J_1IG_DOCNO
      !I_DOC_YEAR type J_1IG_DOC_YEAR optional
    exporting
      !E_J_1IG_INVREFNUM type J_1IG_INVREFNUM .
  methods GET_DATA_ADOBE
    importing
      !IM_INV_NUM type EDOCUMENT-SOURCE_KEY
    exporting
      !E_EDOINEINV type EDOINEINV .
  methods GET_DATA_SMARTFORM
    importing
      !IM_INV_NUM type EDOCUMENT-SOURCE_KEY
    exporting
      !LV_QR type STRING
      !LV_IRN type STRING
      !LV_EWB type EDOINEINV-EWBNO
      !LV_EWB_DATE type EDOINEINV-EWB_VALID_END_DATE
      !E_EDOINEINV type EDOINEINV
      !LV_EWB_CREATE_DATE type EDOINEINV-EWB_CREATE_DATE .
  methods GET_DATA_B2C
    importing
      !LV_KUNNR type KUNNR
      !I_NETWR type NETWR
      !I_BUKRS type BUKRS .
  methods GET_DATA_EWAY
    importing
      !IM_INV_NUM type EDOCUMENT-SOURCE_KEY
    exporting
      !E_EDOINEWB type EDOINEWB .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GET_EINVOICE_DETAILS IMPLEMENTATION.


  method GET_DATA.

        IF I_BUKRS IS NOT INITIAL AND I_DOCNO IS NOT INITIAL AND I_DOC_YEAR IS NOT INITIAL.
  SELECT SINGLE
                * FROM J_1IG_INVREFNUM
                  INTO  E_J_1IG_INVREFNUM
                  WHERE BUKRS = I_BUKRS
                  AND DOCNO = I_DOCNO
                  AND DOC_YEAR = I_DOC_YEAR
                  AND IRN_STATUS = 'CRT'.
 else.
     SELECT SINGLE
                * FROM J_1IG_INVREFNUM
                  INTO  E_J_1IG_INVREFNUM
                  WHERE BUKRS = I_BUKRS
                  AND DOCNO = I_DOCNO
                  AND IRN_STATUS = 'CRT'.
 ENDIF.

  endmethod.


  method GET_DATA_ADOBE.

     DATA:lv_edoc_guid TYPE edoc_guid.
    CLEAR: lv_edoc_guid,e_edoineinv.
    SELECT SINGLE edoc_guid FROM edocument
        INTO lv_edoc_guid
        WHERE source_key = im_inv_num AND
              edoc_type = 'IN_EINV'." AND
            "( proc_status = 'COMPLETED' OR
             " proc_status = 'GEN_EINV' ).
    IF sy-subrc = 0.
      SELECT SINGLE * FROM edoineinv
        INTO e_edoineinv
       WHERE edoc_guid = lv_edoc_guid.
    ENDIF.

  endmethod.


  method GET_DATA_B2C.

    data:str1 TYPE string.
    SELECT SINGLE *
               FROM kna1
               INTO @DATA(wa_kna1)
               WHERE kunnr = @lv_kunnr.
    IF wa_kna1-stcd3 IS INITIAL AND str1 IS INITIAL.
      DATA: lv_netwr(15).
      lv_netwr = i_netwr. "invoice total value incl
      condense lv_netwr.
      SELECT SINGLE *
                     FROM j_1ig_vpaid
                     INTO @DATA(wa_J_1IG_VPAID)
                     WHERE Bukrs = @i_bukrs.
      CONCATENATE 'upi://pay?pa=' wa_J_1IG_VPAID-j_1ig_vpaddr
                  '&pn=' wa_J_1IG_VPAID-j_1ig_accname
                  '&mc=&tn='
                  '&am=' lv_netwr
                  '&cu=INR&url=-' INTO DATA(lv_upi).
      CONDENSE lv_upi.
      EXPORT lv_upi = lv_upi TO  MEMORY ID 'B2C'.
    ENDIF.

  endmethod.


  method GET_DATA_EWAY.
    DATA:lv_edoc_guid1 TYPE edoc_guid.
    CLEAR: lv_edoc_guid1,e_edoinewb.
    SELECT SINGLE edoc_guid FROM edocument
        INTO lv_edoc_guid1
        WHERE source_key = im_inv_num AND
              edoc_type = 'IN_EWB'." AND
              "( proc_status = 'COMPLETED' OR
              " proc_status = 'GEN_EINV' ).
    IF sy-subrc = 0.
      SELECT SINGLE * FROM edoinewb
        INTO e_edoinewb
       WHERE edoc_guid = lv_edoc_guid1.
    ENDIF.

  endmethod.


  method GET_DATA_SMARTFORM.

      DATA:lv_edoc_guid TYPE edoc_guid.
    DATA: str1         TYPE string,
          str2         TYPE string,
          str3         TYPE string,
          str4         TYPE string,
          str5         TYPE string,
          str6         TYPE string,
          str7         TYPE string,
          str8         TYPE string,
          str9         TYPE string,
          it_SWASTRTAB TYPE TABLE OF swastrtab,
          wa_SWASTRTAB TYPE swastrtab.
    CLEAR: lv_edoc_guid,e_edoineinv.
    SELECT SINGLE edoc_guid FROM edocument
        INTO lv_edoc_guid
        WHERE source_key = im_inv_num AND
              edoc_type = 'IN_EINV' .
    IF sy-subrc = 0.
      SELECT SINGLE * FROM edoineinv
        INTO e_edoineinv
       WHERE edoc_guid = lv_edoc_guid.
      IF sy-subrc EQ 0.
        lv_irn             = e_edoineinv-inv_reg_num.
        lv_qr              = e_edoineinv-qrcode.
        lv_ewb             = e_edoineinv-ewbno.
        lv_EWB_DATE        = e_edoineinv-ewb_valid_end_date.
        lv_ewb_create_date = e_EDOINEINV-ewb_create_date.
        REPLACE ALL OCCURRENCES OF '\' IN lv_qr WITH ' '.
        CLEAR: str1, str2, str3.
        SPLIT lv_qr AT '.' INTO : str1 str2 str3.
        CONCATENATE str1 '.' INTO str1.
        CONCATENATE str2 '.' INTO str2.

        CALL FUNCTION 'SWA_STRING_SPLIT'
          EXPORTING
            input_string         = str2
            max_component_length = 255
          TABLES
            string_components    = it_swastrtab.

        IF it_swastrtab IS NOT INITIAL.
          CLEAR wa_swastrtab-str.
          LOOP AT it_swastrtab INTO wa_swastrtab.
            CASE sy-tabix.
              WHEN '1'.
                str4 = wa_swastrtab-str.
              WHEN '2'.
                str5 = wa_swastrtab-str.
              WHEN '3'.
                str6 = wa_swastrtab-str.
              WHEN '4'.
                str7 = wa_swastrtab-str.
            ENDCASE.
            CLEAR wa_swastrtab-str.
          ENDLOOP.
        ENDIF.
        REFRESH it_swastrtab.
        CALL FUNCTION 'SWA_STRING_SPLIT'
          EXPORTING
            input_string         = str3
            max_component_length = 255
          TABLES
            string_components    = it_swastrtab.
        IF it_swastrtab IS NOT INITIAL.
          CLEAR wa_swastrtab-str.
          LOOP AT it_swastrtab INTO wa_swastrtab.
            CASE sy-tabix.
              WHEN '1'.
                str8 = wa_swastrtab-str.
              WHEN '2'.
                str9 = wa_swastrtab-str.
            ENDCASE.
            CLEAR wa_swastrtab-str.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

  endmethod.
ENDCLASS.
