DATA:
  lt_cs TYPE sys_callst,
  l_cs  TYPE sys_calls.

CONSTANTS:
  l_event_wip TYPE sys_calls-eventname VALUE 'K_WIP_OBJECT_CALC',
  l_event_scrap TYPE sys_calls-eventname VALUE 'K_SCRAP_OBJECT_CALC',
  l_event_target TYPE sys_calls-eventname VALUE 'K_TARGETCOSTS_OBJECT_CALC',
  l_event_target_repo TYPE sys_calls-eventname VALUE 'K_TARGETCOSTS_OBJECT_RECALC'.

STATICS:
  l_wip TYPE xflag,
  l_target TYPE xflag.

IF  l_wip IS INITIAL
AND l_target IS INITIAL.

  CALL FUNCTION 'SYSTEM_CALLSTACK'
    IMPORTING
      ET_CALLSTACK = lt_cs.

  LOOP AT lt_cs INTO l_cs
     WHERE ( eventname = l_event_wip OR
             eventname = l_event_scrap OR
             eventname = l_event_target OR
             eventname = l_event_target_repo ).
    CASE l_cs-eventname.
      WHEN l_event_wip.
        l_wip = 'X'.
      WHEN OTHERS.
        l_target = 'X'.
    ENDCASE.
  ENDLOOP.

ENDIF.
*&---------------------------------------------------------------------*
*& Include          ZXKSCU01
*&---------------------------------------------------------------------*
*bREAK-POINT.
