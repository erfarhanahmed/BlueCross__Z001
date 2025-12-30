*&---------------------------------------------------------------------*
*& Report Z_AUTO_J_1IG
*&---------------------------------------------------------------------*
*&Changes : DS4K905745   22082025
*&changes done by ss variant change from 100000 to 5000000
*&---------------------------------------------------------------------*
REPORT Z_AUTO_J_1IG.

data  : s_swerks type RANGE OF mseg-werks ,
        s_werks  type RANGE OF mseg-werks,
        s_date   type range of vbrk-erdat. "sy-datum.." ,

data :  s_swerks1 like line of s_swerks ,
        s_werks1  like line of s_werks,
        s_date1   like line of s_date .
data :  s_date1_1 like vbrk-erdat,
        s_date1_2 like vbrk-erdat.

perform fil_data.
*submit J_1IG_INB_INV_STO with p_bukrs = '1000'
*                         with s_swerks in s_swerks "-low and s_swerks-high.
*                         with s_werks  in s_werks
*                         with p_fkart  = 'ZSTO'
*                         with r_cre    = 'X'
*                         with r1       = 'X'
*                         with s_date   in s_date
*                         with P_COUNT  = '100000' and RETURN..

submit J_1IG_INB_INV_STO with p_bukrs = '1000'
                         with s_swerks in s_swerks "-low and s_swerks-high.
                         with s_werks  in s_werks
                         with p_fkart  = 'ZSTO'
                         with r_cre    = 'X'
                         with r1       = 'X'
                         with s_date   in s_date
                         with P_COUNT  = '5000000' and RETURN.."Changes by ss 100000 to 5000000 22082025 "DS4K905745
**&---------------------------------------------------------------------*
**& Form fil_data
**&---------------------------------------------------------------------*
**& text
**&---------------------------------------------------------------------*
**& -->  p1        text
**& <--  p2        text
**&---------------------------------------------------------------------*
FORM FIL_DATA .
s_swerks1-sign   = 'I'.
s_swerks1-option = 'BT'.
s_swerks1-low  = '1000'.
s_swerks1-high = '3001'.
append s_swerks1 to s_swerks.
append s_swerks1 to s_werks.

s_date1_1 = sy-datum - 60.
s_date1-sign   = 'I'.
s_date1-option = 'BT'.
s_date1-low    = s_date1_1.
s_date1-high   = sy-datum.
append s_date1 to s_date.
ENDFORM.
