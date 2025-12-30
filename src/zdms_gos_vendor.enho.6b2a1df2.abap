"Name: \PR:SAPMF05A\FO:PBO_DYNPRO_MODIFIZIEREN\SE:BEGIN\EI
ENHANCEMENT 0 ZDMS_GOS_VENDOR.

*----------------------------------------------------------------------*
* Title  DMS GOS Activation
*----------------------------------------------------------------------*
* Project      : Bluecross DMS
* Request	     : BCDK925296
* Author       : Karthik
* Requested by : Vaibhav
* Date         : 27.11.2019
*----------------------------------------------------------------------*
* Short description of the program:
*    - To activate GOS for F-43, F-02 and FB01.
*----------------------------------------------------------------------*

IF sy-tcode = 'FB01'. " T-Code Check

DATA: Lo_GOS_MANAGER TYPE REF TO CL_GOS_MANAGER,
      LS_BORIDENT TYPE BORIDENT.

LS_BORIDENT-OBJTYPE = 'BUS2081'.

CONCATENATE 'FI' 'DMS' INTO LS_BORIDENT-OBJKEY.
CONDENSE LS_BORIDENT-OBJKEY.

CREATE OBJECT Lo_GOS_MANAGER
EXPORTING
IS_OBJECT = LS_BORIDENT
IP_NO_COMMIT = ' '
EXCEPTIONS
OBJECT_INVALID = 1.

ENDIF.

ENDENHANCEMENT.
