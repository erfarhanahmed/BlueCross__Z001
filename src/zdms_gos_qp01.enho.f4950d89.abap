"Name: \PR:SAPLCPDI\FO:HEADER_FILL_PBO\SE:BEGIN\EI
ENHANCEMENT 0 ZDMS_GOS_QP01.

*----------------------------------------------------------------------*
* Title  GOS Activation for QP01/02/03
*----------------------------------------------------------------------*
* Project      : Bluecross DMS Implementation
*----------------------------------------------------------------------*
* Short description of the program:
*    - To activate GOS for QP01/02/03 transactions.
*----------------------------------------------------------------------*

IF sy-tcode = 'QP01' OR sy-tcode = 'QP02' OR sy-tcode = 'QP03'.

DATA: Lo_GOS_MANAGER TYPE REF TO CL_GOS_MANAGER,
      LS_BORIDENT TYPE BORIDENT,
      lv_matnr TYPE matnr.

DATA: LT_SEL TYPE TGOS_SELS,
        LS_SEL TYPE SGOS_SELS.

LS_SEL-SIGN = 'I'.
    LS_SEL-OPTION = 'EQ'.
    LS_SEL-LOW = 'ARL_LINK'.
    LS_SEL-HIGH = 'ARL_LINK'.
    APPEND LS_SEL TO LT_SEL.
    CLEAR LS_SEL.
 LS_SEL-SIGN = 'I'.
    LS_SEL-OPTION = 'EQ'.
    LS_SEL-LOW = 'VIEW_ATTA'.
    LS_SEL-HIGH = 'VIEW_ATTA'.
    APPEND LS_SEL TO LT_SEL.
    CLEAR LS_SEL.

lv_matnr = RC27M-matnr.
*
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
  EXPORTING
    INPUT         = lv_matnr
 IMPORTING
   OUTPUT        = lv_matnr.

CONCATENATE lv_matnr RC27M-werks RC271-PLNNR INTO LS_BORIDENT-OBJKEY.
LS_BORIDENT-OBJTYPE = 'BUS1191'.
CREATE OBJECT Lo_GOS_MANAGER
EXPORTING
IS_OBJECT = LS_BORIDENT
IT_SERVICE_SELECTION = LT_SEL
IP_NO_COMMIT = ' '
EXCEPTIONS
OBJECT_INVALID = 1.

ENDIF.

ENDENHANCEMENT.
