*&---------------------------------------------------------------------*
*& Include          ZXCO1U06
*&---------------------------------------------------------------------*
*BREAK-POINT.

*IF sy-tcode = 'COR1' OR sy-tcode = 'COR2' OR sy-tcode = 'COR3'.
*
*
*DATA: Lo_GOS_MANAGER TYPE REF TO CL_GOS_MANAGER,
*      LS_BORIDENT TYPE BORIDENT,
*      lv_matnr TYPE matnr.
*
*DATA: LT_SEL TYPE TGOS_SELS,
*        LS_SEL TYPE SGOS_SELS.
*
*LS_SEL-SIGN = 'I'.
*    LS_SEL-OPTION = 'EQ'.
*    LS_SEL-LOW = 'ARL_LINK'.
*    LS_SEL-HIGH = 'ARL_LINK'.
*    APPEND LS_SEL TO LT_SEL.
*    CLEAR LS_SEL.
* LS_SEL-SIGN = 'I'.
*    LS_SEL-OPTION = 'EQ'.
*    LS_SEL-LOW = 'VIEW_ATTA'.
*    LS_SEL-HIGH = 'VIEW_ATTA'.
*    APPEND LS_SEL TO LT_SEL.
*    CLEAR LS_SEL.
*
*LS_BORIDENT-OBJKEY = HEADER_IMP-aufnr.
*
* LS_BORIDENT-objtype = 'BUS0001'.
*
*CREATE OBJECT Lo_GOS_MANAGER
*EXPORTING
*        IS_OBJECT = LS_BORIDENT
**        IP_NO_COMMIT = 'R'
*IT_SERVICE_SELECTION = LT_SEL
*        IP_NO_COMMIT = 'X'
*
*EXCEPTIONS
*OBJECT_INVALID = 1.
*
*ENDIF.
