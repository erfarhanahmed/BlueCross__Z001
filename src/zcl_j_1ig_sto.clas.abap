class ZCL_J_1IG_STO definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_BADI_J_1IG_STO .
protected section.
private section.
ENDCLASS.



CLASS ZCL_J_1IG_STO IMPLEMENTATION.


  method IF_BADI_J_1IG_STO~ADD_MOVEMENT_TYPE.
  endmethod.


  method IF_BADI_J_1IG_STO~CHANGE_BEFORE_DISPLAY.
  endmethod.


  method IF_BADI_J_1IG_STO~CHANGE_BEFORE_POST.
*
*    "Code added by madhavi
*
*     IF SY-TCODE = 'J_1IG_INV' . " AND SY-UCOMM = '&GST'.
*
*
*    DATA: LV_LINE_CNT TYPE POSNR_ACC, "VALUE '0000000001'.
*          LS_INCOM    TYPE MEICO,
*          LV_SUBRC    TYPE SY-SUBRC,
*          LV_NUM      TYPE SY-MSGNO,
*          LV_EKORG    TYPE EKORG,
*          IM_WERKS    TYPE WERKS_D,
*          LV_LIFNR    TYPE LIFNR,
*          LS_EINE     TYPE EINE,
*          LV_MWSKZ    TYPE MWSKZ,
*          IM_BADI     TYPE REF TO BADI_J_1IG_STO,
*          LS_BKPF     TYPE BKPF,
*          LS_RETURN   TYPE BAPIRET2,
*          IT_RETURN   TYPE STANDARD TABLE OF BAPIRET2,
*          LV_TAXPS    TYPE TAXPS VALUE IS INITIAL,
*          WA_ACCGL    TYPE BAPIACGL09,
*          WA_CURR     TYPE BAPIACCR09.
*
*    SORT T_BSEG BY BUKRS BELNR GJAHR BUZEI.                 "2527708
*
*    DESCRIBE TABLE T_BSEG LINES LV_LINE_CNT.
*
*    LOOP AT T_ACCGL ASSIGNING FIELD-SYMBOL(<FS_ACCGL>).
*      READ TABLE T_BSEG INTO DATA(LS_BSEG) INDEX <FS_ACCGL>-ITEMNO_ACC.
*      IF SY-SUBRC = 0.
*
*        IF LS_BSEG-MATNR IS NOT INITIAL.
*
*          SELECT SINGLE MATNR,
*                        SPART
*            FROM MARA INTO @DATA(LS_MARA)
*            WHERE MATNR = @LS_BSEG-MATNR.
*
*          IF <FS_ACCGL>-PLANT IS NOT INITIAL.
*            SELECT SINGLE MATNR,
*                          WERKS,
*                          PRCTR
*              FROM MARC
*              INTO @DATA(LS_MARC)
*              WHERE MATNR = @LS_BSEG-MATNR
*                AND WERKS = @<FS_ACCGL>-PLANT.
*
*            SELECT SINGLE WERKS,
*                          SPART,
*                          GSBER
*                     FROM T134G
*              INTO @DATA(LS_T134G)
*              WHERE WERKS = @<FS_ACCGL>-PLANT
*                AND SPART = @LS_MARA-SPART.
*
*          ENDIF.
*
*        ENDIF.
*
*        <FS_ACCGL>-BUS_AREA   = LS_T134G-GSBER.
*        <FS_ACCGL>-PROFIT_CTR = LS_MARC-PRCTR.
*
*        CLEAR: LS_MARA,
*               LS_MARC,
*               LS_T134G.
*
*      ENDIF.
*
*    ENDLOOP.
*
*    UNASSIGN <FS_ACCGL>.
*    CLEAR LS_BSEG.
*
*    LOOP AT T_BSEG INTO DATA(WA_BSEG).
*
*      IF WA_BSEG-KOART = 'S' AND
*             WA_BSEG-BUZID = 'R' AND
*             WA_BSEG-KTOSL NE 'SPL'.
*
*        LV_LINE_CNT = LV_LINE_CNT + 1.
*
*        READ TABLE T_ACCGL INTO DATA(LS_ACCGL) INDEX 1.
*        IF SY-SUBRC = 0.
*          IM_WERKS = LS_ACCGL-PLANT.
*        ENDIF.
*
**** Get the Puchase Org.
*        SELECT SINGLE EKORG FROM EKKO INTO LV_EKORG
*                                      WHERE EBELN = WA_BSEG-EBELN.
*
**** Get the vendor assigned to sending plant
*        SELECT SINGLE LIFNR FROM T001W INTO LV_LIFNR
*                                       WHERE WERKS = WA_BSEG-WERKS.
*
*        LS_BKPF = IM_BKPF.
*
*        CLEAR: LS_INCOM,
*               LV_SUBRC,
*               LV_NUM.
*
*        LS_INCOM-ESOKZ = '0'.
*        LS_INCOM-EKORG = LV_EKORG.
*        LS_INCOM-WERKS = IM_WERKS.
*        LS_INCOM-LIFNR = LV_LIFNR.
*        LS_INCOM-MATNR = WA_BSEG-MATNR.
*
*
*        CALL FUNCTION 'ME_READ_INFORECORD'
*          EXPORTING
*            INCOM             = LS_INCOM
**           INPREISSIM        =
**           I_NO_OTHER_ORG    =
**           I_SET_ENQUEUE     =
**           I_REALLY_EXIST    = ' '
*          IMPORTING
**           DATEN             =
**           EINADATEN         =
*            EINEDATEN         = LS_EINE
**           EXCOM             =
**           EXPREISSIM        =
**           E_ENQUEUE_FAILED  =
** TABLES
**           ELEMENTE          =
*          EXCEPTIONS
*            BAD_COMIN         = 1
*            BAD_MATERIAL      = 2
*            BAD_MATERIALCLASS = 3
*            BAD_SUPPLIER      = 4
*            NOT_FOUND         = 5
*            OTHERS            = 6.
*
*        LV_SUBRC = SY-SUBRC.
*
*        IF LV_SUBRC = 0 AND
*           LS_EINE-MWSKZ IS NOT INITIAL.
*          CLEAR: LV_MWSKZ.
*          LV_MWSKZ = LS_EINE-MWSKZ.
*        ELSE.
*          IF IM_BADI IS BOUND.
*            CALL BADI IM_BADI->CHANGE_TAX_CODE
*              EXPORTING
*                IM_BKPF  = LS_BKPF
*                IM_BSEG  = WA_BSEG
*              CHANGING
*                CH_MWSKZ = LV_MWSKZ.
*
*            IF LV_MWSKZ IS NOT INITIAL.
*              CLEAR: LV_SUBRC.
*            ENDIF.
*          ENDIF.
*
*          CASE LV_SUBRC.
*            WHEN '1'.
*              LV_NUM = 007.
*            WHEN '2' .
*              LV_NUM = 008.
*            WHEN '3' .
*              LV_NUM = 009.
*            WHEN '4' .
*              LV_NUM = 010.
*            WHEN '5' .
*              LV_NUM = 011.
*            WHEN OTHERS.
*
*          ENDCASE.
*
*          IF LV_NUM IS NOT INITIAL.
*            CALL FUNCTION 'BALW_BAPIRETURN_GET2'
*              EXPORTING
*                TYPE   = 'E'
*                CL     = 'J_1IG_MSGS'
*                NUMBER = LV_NUM
*              IMPORTING
*                RETURN = LS_RETURN.
*
*            APPEND LS_RETURN TO IT_RETURN.
*            CLEAR: LS_RETURN.
*
**** Display info record error
*            CALL FUNCTION 'J_1IG_BAPIRET_DISPLAY'
*              EXPORTING
*                IT_MESSAGE = IT_RETURN.
*            EXIT.
*          ENDIF.
*        ENDIF.
*
**** Tax docu item number
*        IF LV_TAXPS IS INITIAL.
*          LV_TAXPS = 000001.
*        ELSE.
*          LV_TAXPS = LV_TAXPS + 1.
*        ENDIF.
*
**** GL Line
*        WA_ACCGL-ITEMNO_ACC = LV_LINE_CNT.
*        WA_ACCGL-GL_ACCOUNT = WA_BSEG-HKONT.
*        WA_ACCGL-COMP_CODE  = WA_BSEG-BUKRS.
*        WA_ACCGL-TAX_CODE   = LV_MWSKZ.
*        WA_ACCGL-ITEMNO_TAX = LV_TAXPS.
*        WA_ACCGL-PLANT      = IM_WERKS.
*        WA_ACCGL-MATERIAL   = WA_BSEG-MATNR.
*        WA_ACCGL-QUANTITY   = WA_BSEG-MENGE.                " 2533680
*        WA_ACCGL-BASE_UOM   = WA_BSEG-MEINS.                " 2533680
*
*        IF WA_BSEG-MATNR IS NOT INITIAL.
*
*          SELECT SINGLE MATNR,
*                        SPART
*            FROM MARA INTO @DATA(LS_MARA1)
*            WHERE MATNR = @WA_BSEG-MATNR.
*
*          IF LS_ACCGL-PLANT IS NOT INITIAL.
*            SELECT SINGLE MATNR,
*                          WERKS,
*                          PRCTR
*              FROM MARC
*              INTO @DATA(LS_MARC1)
*              WHERE MATNR = @WA_BSEG-MATNR
*                AND WERKS = @LS_ACCGL-PLANT.
*
*            SELECT SINGLE WERKS,
*                          SPART,
*                          GSBER
*                     FROM T134G
*              INTO @DATA(LS_T134G1)
*              WHERE WERKS = @LS_ACCGL-PLANT
*                AND SPART = @LS_MARA1-SPART.
*
*          ENDIF.
*
*          IF WA_BSEG-HKONT IS NOT INITIAL AND LS_T134G-GSBER IS NOT INITIAL.
*            SELECT SINGLE BUKRS,
*                          KSTAR,
**              BWKEY
*                          GSBER,
*                          KOSTL
*                     FROM TKA3C
*                    INTO  @DATA(LS_TKA3C1)
*                    WHERE BUKRS = @WA_BSEG-BUKRS
*                      AND KSTAR = @WA_BSEG-HKONT
*                      AND GSBER = @LS_T134G1-GSBER.
*          ENDIF.
*
*        ENDIF.
*
*        WA_ACCGL-BUS_AREA   = LS_T134G1-GSBER.
*        WA_ACCGL-PROFIT_CTR = LS_MARC1-PRCTR.
*        WA_ACCGL-COSTCENTER = LS_TKA3C1-KOSTL.
*
*        CLEAR: LS_MARA1,
*               LS_MARC1,
*               LS_T134G1,
*               LS_TKA3C1.
*
*        APPEND WA_ACCGL TO T_ACCGL.
*        CLEAR: WA_ACCGL.
*
*** GL Line currency
*        WA_CURR-ITEMNO_ACC = LV_LINE_CNT.
*        WA_CURR-CURR_TYPE  = '00'.
*        WA_CURR-CURRENCY   =  WA_BSEG-PSWSL.
*        IF WA_BSEG-SHKZG = 'H'.
*          WA_CURR-AMT_DOCCUR =  WA_BSEG-WRBTR.
*        ELSEIF WA_BSEG-SHKZG = 'S'.
*          WA_CURR-AMT_DOCCUR =  WA_BSEG-WRBTR * -1.
*        ENDIF.
*
*        APPEND WA_CURR TO T_CURR.
*        CLEAR: WA_CURR.
*
*      ENDIF.
*    ENDLOOP.
*
*  ENDIF.
*
*
*"end of code
*




  endmethod.


  METHOD IF_BADI_J_1IG_STO~CHANGE_TAX_CODE.
  "for getting same MWSKZ as maintained in ekpo
    SELECT SINGLE MWSKZ FROM EKPO INTO CH_MWSKZ WHERE EBELN = IM_BSEG-EBELN
                                                AND EBELP = IM_BSEG-EBELP .
  "End of code by Madhavi
  ENDMETHOD.
ENDCLASS.
