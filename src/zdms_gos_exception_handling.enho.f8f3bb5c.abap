"Name: \TY:CL_OS_TRANSACTION\ME:EXCEPTION_RAISER\SE:BEGIN\EI
ENHANCEMENT 0 ZDMS_GOS_EXCEPTION_HANDLING.

*----------------------------------------------------------------------*
* Title DMS GOS Activation
*----------------------------------------------------------------------*
* Project      : Bluecross DMS Implementation
* Request	     : BCDK924580
* Author       : Karthik (BCLLDEVP1)
* Requested by : Vaibhav
* Date         : 30.09.2019
*----------------------------------------------------------------------*
* Short description of the program:
*    - To handle the OS Commit transaction failure at run time
*----------------------------------------------------------------------**

DATA: lv_flag(1) TYPE C.

IMPORT lv_flag TO lv_flag FROM MEMORY ID 'ZDUMP'.

IF lv_flag EQ 'X'.

 IF sy-tcode EQ 'ZQMS'
   OR sy-tcode EQ 'CS01' OR sy-tcode EQ 'CS02' OR sy-tcode EQ 'CS03'
   OR sy-tcode = 'FB01' OR sy-tcode EQ 'FB02' OR sy-tcode EQ 'FB03'
   OR sy-tcode EQ 'QP01' OR sy-tcode EQ 'QP02' OR sy-tcode EQ 'QP03'
   OR sy-tcode EQ 'PA30' OR sy-tcode EQ 'PA40'
   OR sy-tcode EQ 'MIRO' OR sy-tcode EQ 'MIR4'
   OR sy-tcode EQ 'CO01' OR sy-tcode EQ 'CO02' OR sy-tcode EQ 'CO03'
   OR sy-tcode EQ 'MSC1N' OR sy-tcode EQ 'MSC2N' OR sy-tcode EQ 'MSC3N' or sy-tcode eq 'ZADSUPD'
*   or sy-tcode eq 'ZSOPUPD'.
   or sy-tcode eq 'ZMFG1' OR SY-TCODE EQ 'ZMFG3'
   OR SY-TCODE EQ 'ZLLM_INV'  "3.8.21
    OR SY-TCODE EQ 'ZHW_REPORT'  " 15.9.21
*    OR SY-TCODE EQ 'ZDMS_SOP_1'  " 13.4.22
*      OR SY-TCODE EQ 'ZDMS_SOP_C'  "
*    OR SY-TCODE EQ 'ZDMS_SOP_7'  "
    or sy-tcode eq 'ZDEV1'  "added by Jyotsna
   or sy-tcode eq 'ZDEV2' OR SY-TCODE EQ 'ZDEV3' or sy-tcode eq 'ZDEV6'
*   OR SY-TCODE EQ 'ZDEV8'
   OR SY-TCODE EQ 'ZDEV4' or sy-tcode eq 'ZDEV5'
*   OR SY-TCODE EQ 'ZDEV7'  "21.9.22
   OR SY-TCODE EQ 'ZDEV_PR' OR SY-TCODE EQ 'ZDEV9'
   OR SY-TCODE EQ 'ZTPBATCH'  OR SY-TCODE EQ 'ZTPBATCH_R' or sy-tcode eq 'ZTP'  "31.12.23.  "31.12.23
   or sy-tcode eq 'ZOOS1' OR SY-TCODE EQ 'ZOOS2' OR SY-TCODE EQ 'ZOOS3'  "ADDED ON 17.11.24
   or sy-tcode eq 'ZOOS_P2A' or sy-tcode eq 'ZOOS_P2B' or sy-tcode eq 'ZOOS_P2C' or sy-tcode eq 'ZOOS_P3'
   or sy-tcode eq 'ZOOS_F1' OR sy-tcode eq 'ZOOS_P4' OR sy-tcode eq 'ZOOS_P1'
    or sy-tcode eq 'ZREJECT1' OR sy-tcode eq 'ZREJECT3'.

*   or sy-tcode eq 'ZEMPDATA' or sy-tcode eq 'ZDMS_SOP'.
*   OR SY-TCODE EQ 'ZSOPUPD'.        "13.2.2020.

  CASE I_EXCEPTION_TYPE.
   WHEN 4.
    CLEAR I_EXCEPTION_TYPE.
  ENDCASE.

 ENDIF.

ENDIF.

ENDENHANCEMENT.
