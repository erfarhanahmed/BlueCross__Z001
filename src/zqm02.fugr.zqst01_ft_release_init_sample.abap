FUNCTION ZQST01_FT_RELEASE_INIT_SAMPLE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_VIQMEL) TYPE  VIQMEL
*"     VALUE(I_CUSTOMIZING) TYPE  V_TQ85
*"     VALUE(I_MANUM) LIKE  QMSM-MANUM OPTIONAL
*"----------------------------------------------------------------------
  DATA:TI_IVIQMFE TYPE TABLE OF WQMFE,
       TI_IVIQMUR TYPE TABLE OF  WQMUR,
       TI_IVIQMSM TYPE TABLE OF  WQMSM,
       TI_IVIQMMA TYPE TABLE OF  WQMMA,
       TI_IHPA    TYPE TABLE OF  IHPA.
*      TE_CONTAINER  type table of  SWCONT OPTIONAL,
*      TE_LINES  type table of  TLINE OPTIONAL.
*"  EXCEPTIONS

  CALL FUNCTION 'QST01_FT_RELEASE_INIT_SAMPLE' "ESTINATION 'NONE'
    EXPORTING
      I_VIQMEL       = I_VIQMEL
      I_CUSTOMIZING  = I_CUSTOMIZING
      I_MANUM        = I_MANUM
*     I_FBCALL       =
* IMPORTING
*     E_QNQMASM0     =
*     E_QNQMAQMEL0   =
*     E_BUCH         =
    TABLES
      TI_IVIQMFE     = TI_IVIQMFE
      TI_IVIQMUR     = TI_IVIQMUR
      TI_IVIQMSM     = TI_IVIQMSM
      TI_IVIQMMA     = TI_IVIQMMA
      TI_IHPA        = TI_IHPA
*     TE_CONTAINER   =
*     TE_LINES       =
    EXCEPTIONS
      ACTION_STOPPED = 1
      OTHERS         = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here

  ENDIF.

  COMMIT WORK AND WAIT.
WAIT UP TO 5 SECONDS.
data i_wqmsm type  WQMSM .
i_wqmsm-QMNUM = I_VIQMEL-QMNUM.
*I_WQMSM-q
data e_subrc type sy-subrc.
*data E_PROTOCOL type TABLE OF
CALL FUNCTION 'QST01_FA_RELEASE_INIT_SAMPLE'"DESTINATION 'LOCAL'
 EXPORTING
   I_WQMSM          =  I_WQMSM
   I_VIQMEL         =    I_VIQMEL
 IMPORTING
   E_SUBRC          =  E_SUBRC
* TABLES
*   E_PROTOCOL       =
          .

COMMIT WORK AND WAIT.



ENDFUNCTION.
