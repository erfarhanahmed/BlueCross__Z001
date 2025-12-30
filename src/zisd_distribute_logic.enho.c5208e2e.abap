"Name: \TY:J_1IG_CL_ISDN\ME:CREATE_INVOICE_ALV\SE:BEGIN\EI
ENHANCEMENT 0 ZISD_DISTRIBUTE_LOGIC.

  DATA: gt_dis TYPE j_1ig_isd_distr_tt.
  DATA: ls_dis TYPE j_1ig_isd_distr.
  LOOP AT gt_dist_sum INTO DATA(ls_dist_sum).
    IF ls_dist_sum-isd_mwskz NA 'Z'.
      MOVE-CORRESPONDING ls_dist_sum TO ls_dis.
      APPEND ls_dis TO gt_dis.
      CLEAR: ls_dis.
    ENDIF.
  ENDLOOP.

  IF gt_dis IS NOT INITIAL.
    REFRESH gt_dist_sum.
    MOVE-CORRESPONDING gt_dis TO gt_dist_sum.
  ENDIF.





ENDENHANCEMENT.
