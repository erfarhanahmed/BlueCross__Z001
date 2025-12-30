**TABLES VBAK.
**CLEAR SET.
*
*DATA:LW_VBFA_C TYPE VBFA,
*      LW_VBFA_U TYPE VBFA, name_rr TYPE THEAD-TDNAME,
*      LW_VBRP TYPE VBRP ,
*      LINES TYPE TABLE OF TLINE WITH HEADER LINE.
*BREAK PWC_ABAP1.
**if GV_FKART = 'ZDEM' or gv_fkart = 'ZST1'.
*
*  name_rr = IS_HDREF-DELIV_NUMB.
*if name_rr IS NOT INITIAL.
*  CALL FUNCTION 'READ_TEXT'
*    EXPORTING
**     CLIENT                        = SY-MANDT
*      ID                            = '0001'
*      LANGUAGE                      = 'E'
*      NAME                          = name_rr
*      OBJECT                        = 'VBBK'
**     ARCHIVE_HANDLE                = 0
**     LOCAL_CAT                     = ' '
**   IMPORTING
**     HEADER                        =
**     OLD_LINE_COUNTER              =
*    TABLES
*      LINES                         = LINES
*   EXCEPTIONS
*     ID                            = 1
*     LANGUAGE                      = 2
*     NAME                          = 3
*     NOT_FOUND                     = 4
*     OBJECT                        = 5
*     REFERENCE_CHECK               = 6
*     WRONG_ACCESS_TO_ARCHIVE       = 7
*     OTHERS                        = 8
*            .
*  IF SY-SUBRC <> 0.
** Implement suitable error handling here
*  ENDIF.
*  IF SY-SUBRC = 0.
*    LOOP AT LINES.
*      if sy-tabix = 1 or sy-tabix = 2 or
*        sy-tabix = 3.
*      CONCATENATE ADV_LIC_T LINES-TDLINE INTO ADV_LIC_T
*      SEPARATED BY SPACE.
*        endif.
*  if sy-tabix = 4 or sy-tabix = 5 or
*        sy-tabix = 6 .
*      CONCATENATE ADV_LIC_T1 LINES-TDLINE INTO ADV_LIC_T1
*      SEPARATED BY SPACE.
*        endif.
*  if sy-tabix = 7 or sy-tabix = 8 or
*        sy-tabix = 9 .
*      CONCATENATE ADV_LIC_T2 LINES-TDLINE INTO ADV_LIC_T2
*      SEPARATED BY SPACE.
*        endif.
*    ENDLOOP.
*  ENDIF.
*  ENDIF.
*
**SELECT SINGLE * FROM VBFA
**              INTO LW_VBFA_C
**WHERE VBELN = IS_HDREF-BIL_NUMBER
**  AND VBTYP_V = 'C'.
**IF SY-SUBRC EQ 0.
**  SELECT SINGLE * FROM VBFA
**  INTO LW_VBFA_C
**  WHERE VBELV = LW_VBFA_C-VBELV
**  AND VBTYP_N = 'U'.
**  IF SY-SUBRC EQ 0.
**SELECT SINGLE * FROM VBRP
**      INTO LW_VBRP
**      WHERE VBELN = LW_VBFA_C-VBELN.
**  IF SY-SUBRC EQ 0.
**    SELECT SINGLE * FROM ZADV_LIC_HDR
**              INTO LW_ZADV
**    WHERE LICNO = LW_VBRP-LICNO.
**  ENDIF.
**  ENDIF.
**ENDIF.
**ENDIF.
