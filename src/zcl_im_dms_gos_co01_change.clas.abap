class ZCL_IM_DMS_GOS_CO01_CHANGE definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_WORKORDER_UPDATE .

  class-data GV_RELEASED type CHAR1 .
  class-data GV_OBJ type NROBJ .
  class-data GV_SUBOBJ type NRSOBJ .
  class-data GV_YEAR type NRYEAR .
  class-data GV_NRNR type NRNR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_DMS_GOS_CO01_CHANGE IMPLEMENTATION.


  method IF_EX_WORKORDER_UPDATE~ARCHIVE_OBJECTS.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~AT_DELETION_FROM_DATABASE.
  endmethod.


  METHOD IF_EX_WORKORDER_UPDATE~AT_RELEASE.
*&---------------------------------------------------------*&
* Below requirement is part of F2S-PP-01 - Batch Creation
*  logic for Process Orders; it should trigger only for
*  process order type ZNS1, ZNS3, ZNS4, ZGS1, ZGS3, ZGS4
*&---------------------------------------------------------*&
    IF ( SY-TCODE = 'COR1' OR
         SY-TCODE = 'COR2' )
        AND SY-UCOMM = 'FREI'.      "Proess Order Release

      FIELD-SYMBOLS: <F1> TYPE ANY.
      TYPES: LR_AUART_TY TYPE RANGE OF AUFART.
      DATA: LT_AUART  TYPE LR_AUART_TY.

      DATA:
        LV_NUMB4  TYPE NUMC4,
        LV_NUMB2  TYPE NUMC2,
        LV_NUMBC  TYPE CHAR4,
        LV_PERIO  TYPE MONAT,
        LS_RETURN TYPE BAPIRETURN1.

      LT_AUART = VALUE LR_AUART_TY( SIGN = 'I' OPTION = 'EQ'
                                  ( LOW = 'ZNS1' )
                                  ( LOW = 'ZNS3' )
                                  ( LOW = 'ZNS4' )
                                  ( LOW = 'ZGS1' )
                                  ( LOW = 'ZGS3' )
                                  ( LOW = 'ZGS4' )
                                  ( LOW = 'ZNS5' ) ).

      CHECK IS_HEADER_DIALOG-AUART IN LT_AUART.
      IF IS_HEADER_DIALOG-AUART = 'ZNS5'.
        IF IS_HEADER_DIALOG-MATNR+0(1) <> 'G'.
          RETURN.
        ENDIF.
      ENDIF.

      SELECT SINGLE * FROM ZTQM_MATPRFX INTO @DATA(LS_MATPRFX)
                               WHERE WERKS = @IS_HEADER_DIALOG-WERKS
                                 AND MATNR = @IS_HEADER_DIALOG-MATNR.
      IF SY-SUBRC <> 0.
        MESSAGE W604(ZPP) WITH IS_HEADER_DIALOG-MATNR 'ZMATPRX'.
        RAISE FREE_FAILED_ERROR .
      ENDIF.

      ASSIGN ('(SAPLCOKO)AFPOD-CHARG') TO <F1>.

      SELECT SINGLE FROM T001W AS A
      INNER JOIN T001K AS B ON B~BWKEY = A~BWKEY
        FIELDS
        A~WERKS,
        B~BUKRS
        WHERE A~WERKS = @IS_HEADER_DIALOG-WERKS
        INTO @DATA(LS_BUKRS).

      GV_RELEASED = 'X'.

* Get fiscal year based on start date
      CALL FUNCTION 'BAPI_COMPANYCODE_GET_PERIOD'
        EXPORTING
          COMPANYCODEID = LS_BUKRS-BUKRS
          POSTING_DATE  = IS_HEADER_DIALOG-GSTRP
        IMPORTING
          FISCAL_YEAR   = GV_YEAR
          FISCAL_PERIOD = LV_PERIO
          RETURN        = LS_RETURN.

      GV_OBJ    = 'ZCHARG'.
*      gv_nrnr   = '01'.
*      gv_subobj = 'ABCD'.
      GV_SUBOBJ = LS_MATPRFX-PRFIX.
      GV_NRNR   = LS_MATPRFX-NRRANGENR.     "Number range number

      SELECT SINGLE NRLEVEL INTO LV_NUMB4
             FROM NRIV WHERE OBJECT    = GV_OBJ
                         AND SUBOBJECT = GV_SUBOBJ
                         AND NRRANGENR = GV_NRNR
                         AND TOYEAR    = GV_YEAR.

      IF SY-SUBRC = 0 AND <F1> IS ASSIGNED.

        LV_NUMB4 = LV_NUMB4 + 1.
        IF LV_NUMB4 < 10.
          LV_NUMB2 = LV_NUMB4.
          LV_NUMBC = LV_NUMB2.
        ELSE.
          LV_NUMBC = |{ LV_NUMB4 ALPHA = OUT }|.
        ENDIF.
*          CONCATENATE gv_subobj gv_year+2(2) lv_numb INTO <f1>.
        CONDENSE LV_NUMBC.
        CONCATENATE GV_SUBOBJ GV_YEAR+2(2) LV_NUMBC INTO <F1>.
      ELSE.
        MESSAGE W605(ZPP) WITH GV_OBJ GV_SUBOBJ GV_YEAR GV_NRNR.
        RAISE FREE_FAILED_ERROR .
      ENDIF.
    ENDIF.

    UNASSIGN <F1>.
  ENDMETHOD.


  METHOD if_ex_workorder_update~at_save.

*&---------------------------------------------------------*&
* Below requirement is part of F2S-PP-01 - Batch Creation
*  logic for Process Orders
*
*&---------------------------------------------------------*&
    IF GV_released IS NOT INITIAL.

*   Generate next batch number number
      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr                   = gv_nrnr
          object                        = gV_OBJ
          QUANTITY                      = '1'
          SUBOBJECT                     = GV_SUBOBJ
          TOYEAR                        = GV_YEAR
*         IGNORE_BUFFER                 = LV_YEAR
*       IMPORTING
*         NUMBER                        =
*         QUANTITY                      =
*         RETURNCODE                    =
       EXCEPTIONS
         INTERVAL_NOT_FOUND            = 1
         NUMBER_RANGE_NOT_INTERN       = 2
         OBJECT_NOT_FOUND              = 3
         QUANTITY_IS_0                 = 4
         QUANTITY_IS_NOT_1             = 5
         INTERVAL_OVERFLOW             = 6
         BUFFER_OVERFLOW               = 7
         OTHERS                        = 8
                .
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      clear: GV_released, gv_subobj, gv_year, gv_nrnr, gv_obj.
    ENDIF.
  ENDMETHOD.


  METHOD IF_EX_WORKORDER_UPDATE~BEFORE_UPDATE.
*----------------------------------------------------------------------*
* Project      : Bluecross DMS
* Request	     : BCDK925296
* Requested by : Vaibhav
* Date         : 16.12.2019
*----------------------------------------------------------------------*
* Short description of the program:
*    - To change DMS file name for attachments added through CO01
*----------------------------------------------------------------------*

*& Begin of insertion

    IF SY-TCODE EQ 'CO01' AND SY-UCOMM EQ 'BU' OR SY-UCOMM = 'YES'.
      DATA: T_ZDMS_GOS TYPE STANDARD TABLE OF ZDMS_GOS.
      FIELD-SYMBOLS:<FS> LIKE LINE OF T_ZDMS_GOS.
      DATA: LV_KEY  TYPE STRING,
            LV_PRE  TYPE STRING,
            LV_POST TYPE STRING.

      READ TABLE IT_HEADER INTO DATA(LS_HEAD) INDEX 1.
      IF SY-SUBRC = 0.

        LV_KEY = LS_HEAD-AUFNR.
        CONDENSE LV_KEY.

        SELECT *
          FROM ZDMS_GOS
          INTO TABLE T_ZDMS_GOS
         WHERE DOC_KEY EQ 'PPDMS'
           AND ZDATE   EQ SY-DATUM.
        IF SY-SUBRC EQ 0.
          DATA(LT_ZDMS_GOS) = T_ZDMS_GOS.
          LOOP AT T_ZDMS_GOS ASSIGNING <FS>.
            <FS>-DOC_KEY = LV_KEY.

            SPLIT <FS>-FILENAME AT '-' INTO LV_PRE LV_POST.
            CONDENSE LV_POST.
            CLEAR <FS>-FILENAME.
            CONCATENATE LV_KEY '-' LV_POST INTO <FS>-FILENAME.
            CONDENSE <FS>-FILENAME.

          ENDLOOP.

          DELETE ZDMS_GOS FROM TABLE LT_ZDMS_GOS.
          MODIFY ZDMS_GOS FROM TABLE T_ZDMS_GOS.

        ENDIF.
      ENDIF.
    ENDIF.

*& End of insertion
    "Addition of code for getting component material count same or greater than header material(Validations)
    "date - 06-11-2025 BY M.

*    DATA: LV_LEN_HEADER TYPE I,
*          LV_LEN_COMP   TYPE I.
*
*
*    IF SY-TCODE = 'COR1' OR SY-TCODE = 'COR2'.
*
*      SELECT MATNR,MTART FROM MARA INTO TABLE @DATA(LI_MTART) FOR ALL ENTRIES IN @IT_COMPONENT WHERE MATNR = @IT_COMPONENT-MATNR AND MTART = 'ZHLB'.
*
*      LOOP AT IT_COMPONENT INTO DATA(LWA_COMPONENT).
*
*        READ TABLE LI_MTART INTO DATA(LW_MTART) WITH  KEY MATNR = LWA_COMPONENT-MATNR.
*        IF SY-SUBRC = 0.
*
*          SHIFT LWA_COMPONENT-MATNR LEFT DELETING LEADING '0'.
*          SHIFT LWA_COMPONENT-BAUGR LEFT DELETING LEADING '0'.
*          LV_LEN_HEADER = STRLEN( LWA_COMPONENT-BAUGR ).
*          LV_LEN_COMP   = STRLEN( LWA_COMPONENT-MATNR ).
*
*          IF   LV_LEN_HEADER > LV_LEN_COMP.
*
*            MESSAGE |Component material { LWA_COMPONENT-MATNR } is shorter than header material length { LV_LEN_HEADER }| TYPE 'W' DISPLAY LIKE 'E' .
*            IF SY-SUBRC = 0.
*              CONTINUE.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.

    "Eoc by M.
  ENDMETHOD.


  method IF_EX_WORKORDER_UPDATE~CMTS_CHECK.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~INITIALIZE.



  endmethod.


  method IF_EX_WORKORDER_UPDATE~IN_UPDATE.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~NUMBER_SWITCH.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~REORG_STATUS_ACTIVATE.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~REORG_STATUS_ACT_CHECK.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~REORG_STATUS_REVOKE.
  endmethod.
ENDCLASS.
