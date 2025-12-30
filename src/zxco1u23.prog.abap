**&---------------------------------------------------------------------*
**& Include          ZXCO1U23
**&---------------------------------------------------------------------*
**- To check component not to be add,change & Delete in process order
*******************************************************************************
*** Program Title : components tab in Process order should be validate w.r.t to user para meter  *
*** Program Name  : EXIT_SAPLCOMK_014                                         *
*** Created By    : Madhavi Wadekar                                            *
*** Created Date  : 04.09.2025                                                *
*** Reviewer      :                                                           *
*** Review Date   :                                                           *
*******************************************************************************
*** Modification history:                                                     *
*******************************************************************************
*******************************************************************************
***  Date:      Programmer:   TR #    Defect#    Reviewer        Review Date  *
***---------- --------------- --------- -------- ----------- -----------------*
***04/09/2025     Madhavi    DS4K900183
***->Description : components tab in Process order should be validate w.r.t to user para meter   *
***&--------------------------------------------------------------------------*
*
DATA :PARAMETER_ID    TYPE  USR05-PARID VALUE 'ZCOR1',
      PARAMETER_VALUE TYPE  USR05-PARVA,
      RC              TYPE  SY-SUBRC.
"SOC by ABAP01 : ZCORQ for Restriction on Requirement Quantity Value changes.
DATA :PARAMETER_ID2    TYPE  USR05-PARID VALUE 'ZCORQ',
      PARAMETER_VALUE2 TYPE  USR05-PARVA,
      RC2              TYPE  SY-SUBRC.
"EOC by ABAP01
*


CALL FUNCTION 'G_GET_USER_PARAMETER'
  EXPORTING
    PARAMETER_ID    = PARAMETER_ID
  IMPORTING
    PARAMETER_VALUE = PARAMETER_VALUE
    RC              = RC.
IF PARAMETER_VALUE IS INITIAL.
  IF IS_HEADER-AUART = 'ZNS1' OR IS_HEADER-AUART = 'ZNS3' OR IS_HEADER-AUART = 'ZNS4' OR IS_HEADER-AUART = 'ZGS1'
   OR IS_HEADER-AUART = 'ZGS3' OR IS_HEADER-AUART = 'ZGS4' OR IS_HEADER-AUART = 'ZNS5'.


    CHECK IS_HEADER-AUTYP = '40' .
    IF SY-TCODE NE 'COR1' .
      IF IS_COMPONENT NE IS_COMPONENT_OLD.

*      MESSAGE e001(zpp) WITH is_component-posnr is_component-matnr.
        MESSAGE E005(ZPP).
      ENDIF.
    ELSEIF SY-TCODE EQ 'COR1' AND IS_COMPONENT_OLD IS NOT INITIAL.
      IF IS_COMPONENT NE IS_COMPONENT_OLD.
*      MESSAGE e005(zpp) WITH is_component-posnr is_component-matnr.
        MESSAGE E005(ZPP).
      ENDIF.
    ENDIF.

    IF I_FCODE = 'DEL' AND I_MARKED = ABAP_TRUE.
*    MESSAGE e005(zpp) WITH is_component-posnr is_component-matnr.
      MESSAGE E005(ZPP).

    ENDIF.
  ENDIF.
ENDIF.

****************SOC ABAP01 condition for restricting RQ change and zero Value.**********************

CALL FUNCTION 'G_GET_USER_PARAMETER'
  EXPORTING
    PARAMETER_ID    = PARAMETER_ID2
  IMPORTING
    PARAMETER_VALUE = PARAMETER_VALUE2
    RC              = RC2.

IF PARAMETER_VALUE2 IS INITIAL.
  IF IS_HEADER-AUART = 'ZNS1' OR IS_HEADER-AUART = 'ZNS3' OR IS_HEADER-AUART = 'ZNS4'
    OR IS_HEADER-AUART = 'ZGS1' OR IS_HEADER-AUART = 'ZGS3' OR IS_HEADER-AUART = 'ZGS4' OR IS_HEADER-AUART = 'ZNS5'.
    IF SY-TCODE = 'COR1' OR SY-TCODE = 'COR2' OR SY-TCODE = 'COR7'.
      IF IS_COMPONENT-MENGE NE IS_COMPONENT_OLD-MENGE.
        MESSAGE E008(ZPP).
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.

IF SY-TCODE = 'COR1' OR SY-TCODE = 'COR2' OR SY-TCODE = 'COR7'.
  IF IS_HEADER-AUART = 'ZNS1' OR IS_HEADER-AUART = 'ZNS3' OR IS_HEADER-AUART = 'ZNS4'
   OR IS_HEADER-AUART = 'ZGS1' OR IS_HEADER-AUART = 'ZGS3' OR IS_HEADER-AUART = 'ZGS4' OR IS_HEADER-AUART = 'ZNS5'.
    IF IS_COMPONENT-MENGE EQ 0 AND I_FCODE <> 'DEL'.
      MESSAGE E007(ZPP).
    ENDIF.
  ENDIF.
ENDIF.


DATA: LV_LEN_HEADER TYPE I,
      LV_LEN_COMP   TYPE I,
      LV_MATNR      TYPE MATNR,
      C_425_925     TYPE CHAR3.


CLEAR: LV_MATNR.
LV_MATNR = IS_HEADER-PLNBEZ.
SHIFT LV_MATNR LEFT DELETING LEADING '0'.
LV_LEN_HEADER   = STRLEN( LV_MATNR ).

CLEAR: C_425_925.
C_425_925 = LV_MATNR+0(3).

IF C_425_925 EQ '425'.

ELSEIF C_425_925 EQ '925'.

ELSE.
  IF LV_LEN_HEADER EQ '8'.
    SELECT MATNR,
           MTART
      FROM MARA
      INTO TABLE @DATA(LI_MTART)
      WHERE MATNR = @IS_COMPONENT_OLD-MATNR AND MTART = 'ZHLB'.
    IF SY-SUBRC = 0.
      IF SY-TCODE = 'COR1' OR SY-TCODE = 'COR2' OR SY-TCODE = 'COR7'.
        LV_LEN_COMP   = STRLEN( IS_COMPONENT-MATNR ).
        IF  LV_LEN_COMP LT '8'.
          MESSAGE E975(ZHR_MESSAGE).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
