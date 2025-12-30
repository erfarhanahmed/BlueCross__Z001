*&---------------------------------------------------------------------*
*&      Form  roundoff
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->AMOUNT     text
*----------------------------------------------------------------------*
FORM roundoff USING uv_bukrs
              CHANGING cv_amount.

  DATA lv_amount TYPE t001r_bf-amount.

  IF cv_amount IS NOT INITIAL.

    lv_amount = cv_amount.

    CALL FUNCTION 'FI_ROUND_AMOUNT'
      EXPORTING
        amount_in           = lv_amount
        company             = uv_bukrs
        currency            = 'INR'
     IMPORTING
       amount_out          = lv_amount
*   DIFFERENCE          =
*   ROUNDING_UNIT       =
              .

    cv_amount = lv_amount.

  ENDIF.

ENDFORM.                    "roundoff























