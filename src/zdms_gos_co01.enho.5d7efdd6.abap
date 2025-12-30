"Name: \PR:SAPLCOKO1\FO:HEADER_POSITION_READ_PBO\SE:BEGIN\EI
ENHANCEMENT 0 ZDMS_GOS_CO01.

*----------------------------------------------------------------------*
* Title CO01 DMS GOS Activation
*----------------------------------------------------------------------*
* Project      : Bluecross DMS Implementation
* Request	     : BCDK925296
* Author       : Karthik (BCLLDEVP1)
* Requested by : Vaibhav
* Date         : 16.12.2019
*----------------------------------------------------------------------*
* Short description of the program:
*    - To activate DMS in CO01 transaction
*----------------------------------------------------------------------*

* T-Code Check
IF sy-tcode = 'CO01'.

DATA: Lo_GOS_MANAGER TYPE REF TO CL_GOS_MANAGER,
      LS_BORIDENT TYPE BORIDENT.

CONCATENATE 'PP' 'DMS' INTO LS_BORIDENT-OBJKEY.
CONDENSE LS_BORIDENT-OBJKEY.

CREATE OBJECT Lo_GOS_MANAGER
EXPORTING
IS_OBJECT = LS_BORIDENT
IP_NO_COMMIT = 'R'
EXCEPTIONS
OBJECT_INVALID = 1.

ENDIF.

ENDENHANCEMENT.
