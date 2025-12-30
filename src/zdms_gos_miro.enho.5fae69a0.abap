"Name: \PR:SAPLMR1M\FO:VARIANT_TRANSACTION\SE:BEGIN\EI
ENHANCEMENT 0 ZDMS_GOS_MIRO.

*----------------------------------------------------------------------*
* Title  DMS GOS Activation
*----------------------------------------------------------------------*
* Project      : Bluecross DMS
* Request	     : BCDK925296
* Author       : Karthik
* Requested by : Vaibhav
* Date         : 28.11.2019
*----------------------------------------------------------------------*
* Short description of the program:
*    - To activate GOS for MIRO.
*----------------------------------------------------------------------*

IF sy-tcode = 'MIRO'. " T-Code Check

DATA: Lo_GOS_MANAGER TYPE REF TO CL_GOS_MANAGER,
      LS_BORIDENT TYPE BORIDENT.

LS_BORIDENT-OBJTYPE = 'BUS2081'.

CONCATENATE 'MIRO' 'DMS' INTO LS_BORIDENT-OBJKEY.
CONDENSE LS_BORIDENT-OBJKEY.

CREATE OBJECT Lo_GOS_MANAGER
EXPORTING
IS_OBJECT = LS_BORIDENT
IP_NO_COMMIT = ' '
EXCEPTIONS
OBJECT_INVALID = 1.

ENDIF.

ENDENHANCEMENT.
