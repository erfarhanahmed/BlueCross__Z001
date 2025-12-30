*----------------------------------------------------------------------*
*   INCLUDE ZP000120                                                   *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  MOD_PBO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODULE_PBO_0001 OUTPUT.
tables : ZTHR_HEQ_DES.
data : text(30).

select single * from ZTHR_HEQ_DES where ZZ_HQCODE = P0001-ZZ_HQCODE.

if sy-subrc = 0.
text =  ZTHR_HEQ_DES-ZZ_HQDESC.
endif.

ENDMODULE.                 " MOD_PBO  OUTPUT
