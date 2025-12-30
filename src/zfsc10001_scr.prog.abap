*&---------------------------------------------------------------------*
*&  Include           ZFS_UPLOAD_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN: BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
PARAMETER: p_local LIKE rlgrap-filename OBLIGATORY.
PARAMETER: p_backg RADIOBUTTON GROUP g1 DEFAULT 'X',
           p_foreg RADIOBUTTON GROUP g1.
SELECTION-SCREEN: END OF BLOCK b2.
