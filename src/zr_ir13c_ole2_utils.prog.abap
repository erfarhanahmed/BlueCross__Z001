*&---------------------------------------------------------------------*
*& Include  ZR_IR13C_OLE2_UTILS
*&---------------------------------------------------------------------*
*&DESCRIPTION       : Used in ZIR13C for Excel formatting using OLE object
*CREATED BY         : Shraddha Pradhan
*CREATED ON         : 08/09/2022
*Request No         : BCDK931623
*&---------------------------------------------------------------------*
*&Modification History
*&---------------------------
*&Changed by/date       :
*&DESCRIPTION           :
*&
*&Request No.          :
*&---------------------------------------------------------------------*

type-pools: soi,ole2.

data: go_application type  ole2_object,
      go_workbook    type  ole2_object,
      go_workbooks   type  ole2_object,
      go_worksheet   type  ole2_object.

data: gv_lines          type i. "Lines printed by the moment

* Data to be printed.
* You must to concatenate the fields of the line you want to print
* separated by cl_abap_char_utilities=>horizontal_tab.
* Use the subrutine add_line2print for fill the tabla.
types: ty_data(1500) type c.
data: gt_data type table of ty_data,
      gs_data like line of gt_data.

* Data to be printed.
* Fill the table with the text you want to print in a line.
* Use the subrutine add_line2print_from_table to pass the
* table.
types: begin of ty_line,
         value type char255,
       end of ty_line.
data: gt_lines type table of ty_line,
      gs_lines like line of gt_lines.

* Fields to be printed
* Use the subrutine print_data_fieldcat.
types: begin of ty_fieldcat,
         field like dd03d-fieldname,  "Field name in your internal table
         text  like dd03p-ddtext,     "Description of the column
         width type i,                "Width of the column
       end of  ty_fieldcat.
data: gt_fieldcat type table of ty_fieldcat,
      gs_fieldcat like line of gt_fieldcat.

* Some colours you can use:
constants:
  c_col_black       type i value 0,
  c_col_white       type i value 2,
  c_col_red         type i value 3,
  c_col_light_green type i value 4,
  c_col_dark_blue   type i value 5,
  c_col_yellow      type i value 6,
  c_col_pink        type i value 7,
  c_col_light_blue  type i value 8,
  c_col_brown       type i value 9.

* Theme Colours:
* Use the subrutine set_soft_colour.
constants:
  c_theme_col_white      type i value 1,
  c_theme_col_black      type i value 2,
  c_theme_col_yellow     type i value 3,
  c_theme_col_dark_blue  type i value 4,
  c_theme_col_light_blue type i value 5,
  c_theme_col_red        type i value 6,
  c_theme_col_green      type i value 7,
  c_theme_col_violet     type i value 8,
  c_theme_col_pal_blue   type i value 9,
  c_theme_col_orange     type i value 10.

* Align:
constants:
  c_center type i value -4108,
  c_left   type i value -4131,
  c_right  type i value -4152.

*&———————————————————————*
*&      Form  CREATE_DOCUMENT
*&———————————————————————*
*  Instanciate the application, workbook and the first worksheet.
*———————————————————————-*
*  –>  p1        text
*  <–  p2        text
*———————————————————————-*
form create_document.

  create object go_application 'Excel.Application'.
  call method of go_application 'Workbooks' = go_workbooks.
  call method of go_workbooks 'Add' = go_workbook.
  set property of go_application 'Visible' = 0.
  get property of go_application 'ACTIVESHEET' = go_worksheet.

endform.                    " create_document

*&———————————————————————*
*&      Form  CLOSE_DOCUMENT
*&———————————————————————*
*   Close the document and free memory objects.
*———————————————————————-*
*  –>  p1        text
*  <–  p2        text
*———————————————————————-*
form close_document.

  call method of go_application 'QUIT'.
  free object go_worksheet.
  free object go_workbook.
  free object go_workbooks.
  free object go_application.

endform.                    "close_document

*&———————————————————————*
*&      Form  PRINT_LINE
*&———————————————————————*
*  Print line cell by cell with colurs, etc.
*———————————————————————-*
*  –>  p_data       Data to print
*  –>  p_row        Number of the Row in excel to print
*  –>  p_num_cols   Number of fields to be printed, if 0 all the fields
*                    will be printed
*  –>  p_colour     Colour of the font
*  –>  p_colourx    Set to X if want to change the Colour
*  –>  p_bkg_col    Background colour of the cell
*  –>  p_bkg_colx   Set to X if want to change the Background colour
*  –>  p_size       Size of the font
*  –>  p_sizex      Set to X if want to change the Size
*  –>  p_bold       Bold
*  –>  p_boldx      Set to X if want to change to Bold
*———————————————————————-*
form print_line
using
p_data       type any
p_row        type i
p_num_cols   type i
p_colour     type i
p_colourx    type char1
p_bkg_col    type i
p_bkg_colx   type char1
p_size       type i
p_sizex      type char1
p_bold       type i
p_boldx      type char1.

  data: lo_font     type ole2_object,
        lo_cell     type ole2_object,
        lo_interior type ole2_object,
        lv_cont     type i.

  field-symbols: <field> type any.

  do.
    add 1 to lv_cont.
    assign component lv_cont of structure p_data to <field>.
    if sy-subrc ne 0. exit. endif.

*   Select the cell;
    call method of go_worksheet 'Cells' = lo_cell
    exporting
    #1 = p_row
    #2 = lv_cont.
*   Assign the value;
    set property of lo_cell 'Value' = <field>.
*   Format:
    call method of lo_cell 'FONT' = lo_font.
*   Colour:
    if p_colourx eq 'X'.
      set property of lo_font 'ColorIndex' = p_colour.
    endif.
*   Background colour;
    if p_bkg_colx eq 'X'.
      call method of lo_cell 'Interior' = lo_interior.
      set property of lo_interior 'ColorIndex' = p_bkg_col.
    endif.
*   Size
    if p_sizex eq 'X'.
      set property of lo_font 'SIZE' = p_size.
    endif.
*   Bold
    if p_boldx eq 'X'.
      set property of lo_font 'BOLD' = p_bold.
    endif.

*   Exit the loop?
    if lv_cont eq p_num_cols. exit. endif.
  enddo.

endform.                    "print_line
*&———————————————————————*
*&      Form  add_line2print
*&———————————————————————*
*& Add line to be printed in subrutine PASTE_CLIPBOARD
*&———————————————————————*
*  –>  p_data       Data to print
*  –>  p_num_cols   Number of fields to be printed, if 0 all the field
*                    will be printed
*&———————————————————————*
form add_line2print
using
p_data       type any
p_num_cols   type i.

  field-symbols: <field> type any.
  data: lv_cont type i,
        lv_char type char128.

  data: lo_abap_typedescr type ref to cl_abap_typedescr.

  clear gs_data.
  do.
    add 1 to lv_cont.
    assign component lv_cont of structure p_data to <field>.
    if sy-subrc ne 0. exit. endif.

*   Convert data depend on the kind type.
    call method cl_abap_typedescr=>describe_by_data
      exporting
        p_data      = <field>
      receiving
        p_descr_ref = lo_abap_typedescr.
    case lo_abap_typedescr->type_kind.
*     Char
      when lo_abap_typedescr->typekind_char.
        concatenate gs_data <field> into gs_data
        separated by cl_abap_char_utilities=>horizontal_tab.
*     Date
      when lo_abap_typedescr->typekind_date.
        write <field> to lv_char dd/mm/yyyy.
        concatenate gs_data lv_char into gs_data
        separated by cl_abap_char_utilities=>horizontal_tab.
*     Time
      when lo_abap_typedescr->typekind_time.
        concatenate <field>(2) <field>+2(2) <field>+4(2) into lv_char separated by ':'.
        concatenate gs_data lv_char into gs_data
        separated by cl_abap_char_utilities=>horizontal_tab.
*    Others
      when others.
        write <field> to lv_char.
        concatenate gs_data lv_char into gs_data
        separated by cl_abap_char_utilities=>horizontal_tab.
    endcase.

*   Exit the loop?
    if lv_cont eq p_num_cols. exit. endif.
  enddo.

* Quit the first horizontal_tab:
  shift gs_data by 1 places left.

  append gs_data to gt_data. clear gs_data.

endform.                    "add_line2print
*&———————————————————————*
*&      Form  add_line2print_from_table
*&———————————————————————*
*& Add line to be printed in subrutine PASTE_CLIPBOARD from a table.
*&———————————————————————*
form add_line2print_from_table.

  clear gs_data.
  loop at gt_lines into gs_lines.
    concatenate gs_data gs_lines-value into gs_data
    separated by cl_abap_char_utilities=>horizontal_tab.
  endloop.

* Quit the first horizontal_tab:
  shift gs_data by 1 places left.

  append gs_data to gt_data. clear gs_data.

endform.                    "add_line2print_from_table
*&———————————————————————*
*&      Form  PASTE_CLIPBOARD
*&———————————————————————*
*& Paste Clipboard from the cell passed by parameter
*&———————————————————————*
*  –>  p_row
*  –>  p_col
*&———————————————————————*
form paste_clipboard using p_row type i
                           p_col type i.

  data: lo_cell type ole2_object.

* Copy to clipboard into ABAP
  call function 'CONTROL_FLUSH'
    exceptions
      others = 3.
  call function 'CLPB_EXPORT'
    tables
      data_tab   = gt_data
    exceptions
      clpb_error = 1
      others     = 2.

* Select the cell A1
  call method of go_worksheet 'Cells' = lo_cell
  exporting
  #1 = p_row
  #2 = p_col.

* Paste clipboard from cell A1
  call method of lo_cell 'SELECT'.
  call method of go_worksheet 'PASTE'.

endform.  "paste_clipboard
*&———————————————————————*
*&      Form  change_format
*&———————————————————————*
*& Change cell format
*&———————————————————————*
*  –>  p_rowini  p_colini Initial Range Cell
*  –>  p_rowend  p_colend End Range Cell
*  –>  p_colour     Colour of the font
*  –>  p_colourx    Set to X if want to change the Colour
*  –>  p_bkg_col    Background colour of the cell
*  –>  p_bkg_colx   Set to X if want to change the Background colour
*  –>  p_size       Size of the font
*  –>  p_sizex      Set to X if want to change the Size
*  –>  p_bold       Bold
*  –>  p_boldx      Set to X if want to change to Bold
*&———————————————————————*
form change_format  using  p_rowini  p_colini
                           p_rowend  p_colend
p_colour     type i
p_colourx    type char1
p_bkg_col    type i
p_bkg_colx   type char1
p_size       type i
p_sizex      type char1
p_bold       type i
p_boldx      type char1.

  data: lo_cellstart type ole2_object,
        lo_cellend   type ole2_object,
        lo_selection type ole2_object,
        lo_range     type ole2_object,
        lo_font      type ole2_object,
        lo_interior  type ole2_object.

* Select the Range of Cells:
  call method of go_worksheet 'Cells' = lo_cellstart
  exporting
  #1 = p_rowini
  #2 = p_colini.
  call method of go_worksheet 'Cells' = lo_cellend
  exporting
  #1 = p_rowend
  #2 = p_colend.
  call method of go_worksheet 'Range' = lo_range
  exporting
  #1 = lo_cellstart
  #2 = lo_cellend.

*   Format:
  call method of lo_range 'FONT' = lo_font.
*   Colour:
  if p_colourx eq 'X'.
    set property of lo_font 'ColorIndex' = p_colour.
  endif.
*   Background colour;
  if p_bkg_colx eq 'X'.
    call method of lo_range 'Interior' = lo_interior.
    set property of lo_interior 'ColorIndex' = p_bkg_col.
  endif.
*   Size
  if p_sizex eq 'X'.
    set property of lo_font 'SIZE' = p_size.
  endif.
*   Bold
  if p_boldx eq 'X'.
    set property of lo_font 'BOLD' = p_bold.
  endif.

endform.                  "change_format
*&———————————————————————*
*&      Form  set_soft_colour
*&———————————————————————*
*& Set a theme colour.
*& For colour and bkgcolour use the theme colour constants.
*& Shade and bkg_shade values : from -1 to 1.
*&———————————————————————*
*  –>  p_rowini  p_colini Initial Range Cell
*  –>  p_rowend  p_colend End Range Cell
*  –>  p_colour     Colour of the font
*  –>  p_colourx    Set to X if want to change the Colour
*  –>  p_shade      Tint and Shade
*  –>  p_shadex     Set to X if want to change the shade
*  –>  p_bkg_col    Background colour of the cell
*  –>  p_bkg_colx   Set to X if want to change the Background colour
*  –>  p_bkg_shade  Tint and Shade
*  –>  p_bkg_shadex Set to X if want to change the shade
*&———————————————————————*

form set_soft_colour  using  p_rowini  p_colini
p_rowend  p_colend
p_colour   type i
p_colourx  type char1
p_shade    type float
p_shadex   type char1
p_bkg_col  type i
p_bkg_colx type char1
p_bkg_shade type float
p_bkg_shadex type char1.

  data: lo_cellstart type ole2_object,
        lo_cellend   type ole2_object,
        lo_selection type ole2_object,
        lo_range     type ole2_object,
        lo_font      type ole2_object,
        lo_interior  type ole2_object.

* Select the Range of Cells:
  call method of go_worksheet 'Cells' = lo_cellstart
  exporting
  #1 = p_rowini
  #2 = p_colini.
  call method of go_worksheet 'Cells' = lo_cellend
  exporting
  #1 = p_rowend
  #2 = p_colend.
  call method of go_worksheet 'Range' = lo_range
  exporting
  #1 = lo_cellstart
  #2 = lo_cellend.

*   Format:
  call method of lo_range 'FONT' = lo_font.

*   Colour:
  if p_colourx eq 'X'.
    set property of lo_font 'ThemeColor' = p_colour.
    if  p_shadex eq 'X'.
      set property of lo_font 'TintAndShade' = p_shade.
    endif.
  endif.

* BackGround Colour:
  if p_bkg_colx eq 'X'.
    call method of lo_range 'Interior' = lo_interior.
    set property of lo_interior 'ThemeColor' = p_bkg_col.
*    set property of lo_interior 'Color' = p_bkg_col.
    if p_bkg_shadex eq 'X'.
      set property of lo_interior 'TintAndShade' = p_bkg_shade.
    endif.
  endif.

endform.       "set_soft_colour
*&———————————————————————*
*&      Form  Column_width
*&———————————————————————*
*    Adjust column width
*———————————————————————-*
*  –>  p_column Column numbe
*  –>  p_width  Width
*———————————————————————-*
form column_width  using p_column type i
p_width   type i.

  data: lo_cellstart type ole2_object,
        lo_cellend   type ole2_object,
        lo_selection type ole2_object,
        lo_column    type ole2_object.

* Select the Column
  call method of go_worksheet 'Columns' = lo_column
  exporting
  #1 = p_column.

  call method of lo_column 'select'.
  call method of go_application 'selection' = lo_selection.

  set property of lo_column 'ColumnWidth' = p_width.

endform.                    "column_width
*&———————————————————————*
*&      Form  WrapText
*&———————————————————————*
*  Wrap Text
*———————————————————————-*
*  –>  p_rowini  p_colini Initial Range Cell
*  –>  p_rowend  p_colend End Range Cell
*———————————————————————-*
form wrap_text  using p_rowini
p_colini
p_rowend
p_colend.

  data: lo_cellstart type ole2_object,
        lo_cellend   type ole2_object,
        lo_selection type ole2_object,
        lo_range     type ole2_object.

* Select the Range of Cells:
  call method of go_worksheet 'Cells' = lo_cellstart
  exporting
  #1 = p_rowini
  #2 = p_colini.
  call method of go_worksheet 'Cells' = lo_cellend
  exporting
  #1 = p_rowend
  #2 = p_colend.
  call method of go_worksheet 'Range' = lo_range
  exporting
  #1 = lo_cellstart
  #2 = lo_cellend.

  set property of lo_range 'WrapText' = 1.

endform.                    "wraptext
*&———————————————————————*
*&      Form  Merge Cells
*&———————————————————————*
*  Merge Cells
*———————————————————————-*
*  –>  p_rowini  p_colini Initial Range Cell
*  –>  p_rowend  p_colend End Range Cell
*———————————————————————-*
form merge_cells  using p_rowini
p_colini
p_rowend
p_colend.

  data: lo_cellstart type ole2_object,
        lo_cellend   type ole2_object,
        lo_selection type ole2_object,
        lo_range     type ole2_object.

* Select the Range of Cells:
  call method of go_worksheet 'Cells' = lo_cellstart
  exporting
  #1 = p_rowini
  #2 = p_colini.
  call method of go_worksheet 'Cells' = lo_cellend
  exporting
  #1 = p_rowend
  #2 = p_colend.
  call method of go_worksheet 'Range' = lo_range
  exporting
  #1 = lo_cellstart
  #2 = lo_cellend.

  call method of lo_range 'Select' .
  call method of lo_range 'Merge' .

endform.   "merge_cells
*&———————————————————————*
*&      Form  align Cells
*&———————————————————————*
*  Align Cells
*———————————————————————-*
*  –>  p_rowini  p_colini Initial Range Cell
*  –>  p_rowend  p_colend End Range Cell
*  –>  p_align   Align: c_center, c_left, c_right.
*———————————————————————-*
form align_cells  using p_rowini p_colini
p_rowend p_colend
p_align.

  data: lo_cellstart type ole2_object,
        lo_cellend   type ole2_object,
        lo_selection type ole2_object,
        lo_range     type ole2_object.

* Select the Range of Cells:
  call method of go_worksheet 'Cells' = lo_cellstart
  exporting
  #1 = p_rowini
  #2 = p_colini.
  call method of go_worksheet 'Cells' = lo_cellend
  exporting
  #1 = p_rowend
  #2 = p_colend.
  call method of go_worksheet 'Range' = lo_range
  exporting
  #1 = lo_cellstart
  #2 = lo_cellend.

  call method of lo_range 'select'.
  set property of lo_range 'HorizontalAlignment' = p_align.

endform.   "align_cells
*&———————————————————————*
*&      Form  Lock cells
*&———————————————————————*
*  Lock Cells
*———————————————————————-*
*  –>  p_rowini  p_colini Initial Range Cell
*  –>  p_rowend  p_colend End Range Cell
*———————————————————————-*
form lock_cells  using p_rowini p_colini
p_rowend p_colend.

  data: lo_cellstart type ole2_object,
        lo_cellend   type ole2_object,
        lo_selection type ole2_object,
        lo_range     type ole2_object.

* Select the Range of Cells:
  call method of go_worksheet 'Cells' = lo_cellstart
  exporting
  #1 = p_rowini
  #2 = p_colini.
  call method of go_worksheet 'Cells' = lo_cellend
  exporting
  #1 = p_rowend
  #2 = p_colend.
  call method of go_worksheet 'Range' = lo_range
  exporting
  #1 = lo_cellstart
  #2 = lo_cellend.

  call method of lo_range 'select'.
  call method of go_application 'Selection' = lo_selection.
  set property of lo_selection 'Locked' = 1.

  call method of go_worksheet 'Protect'
    exporting
      #01 = 0
      #02 = 0.

endform.   "lock_cells
*&———————————————————————*
*&      Form  Add Border
*&———————————————————————*
*  Add Border
*———————————————————————-*
*  –>  p_rowini  p_colini Initial Range Cell
*  –>  p_rowend  p_colend End Range Cell
*———————————————————————-*
form add_border  using p_rowini p_colini
p_rowend p_colend.

  data: lo_cellstart type ole2_object,
        lo_cellend   type ole2_object,
        lo_selection type ole2_object,
        lo_range     type ole2_object,
        lo_borders   type ole2_object.

* Select the Range of Cells:
  call method of go_worksheet 'Cells' = lo_cellstart
  exporting
  #1 = p_rowini
  #2 = p_colini.
  call method of go_worksheet 'Cells' = lo_cellend
  exporting
  #1 = p_rowend
  #2 = p_colend.
  call method of go_worksheet 'Range' = lo_range
  exporting
  #1 = lo_cellstart
  #2 = lo_cellend.

  call method of lo_range 'Borders' = lo_borders exporting #1 = '7'.
  "xledgeleft
  set property of lo_borders 'LineStyle' = '1'. "xlcontinuous

  call method of lo_range 'Borders' = lo_borders exporting #1 = '8'. "xledgetop
  set property of lo_borders 'LineStyle' = '1'. "xlcontinuous

  call method of lo_range 'Borders' = lo_borders exporting #1 = '9'. "xledgebottom
  set property of lo_borders 'LineStyle' = '1'. "xlcontinuous

  call method of lo_range 'Borders' = lo_borders exporting #1 = '10'. "xledgeright
  set property of lo_borders 'LineStyle' = '1'. "xlcontinuous

  call method of lo_range 'Borders' = lo_borders exporting #1 = '11'. "xlinsidevertical
  set property of lo_borders 'LineStyle' = '1'. "xlcontinuous

  call method of lo_range 'Borders' = lo_borders exporting #1 = '12'. "xlinsidehorizontal
  set property of lo_borders 'LineStyle' = '1'. "xlcontinuous

endform.   "add border
*&———————————————————————*
*&      Form  set_range_name
*&———————————————————————*
*  set_range_name
*———————————————————————-*
*  –>  p_rowini  p_colini Initial Range Cell
*  –>  p_rowend  p_colend End Range Cell
*  –>  p_name    name of the range
*———————————————————————-*
form set_range_name  using p_rowini p_colini
p_rowend p_colend
p_name.

  data: lo_cellstart type ole2_object,
        lo_cellend   type ole2_object,
        lo_selection type ole2_object,
        lo_range     type ole2_object.

* Select the Range of Cells:
  call method of go_worksheet 'Cells' = lo_cellstart
  exporting
  #1 = p_rowini
  #2 = p_colini.
  call method of go_worksheet 'Cells' = lo_cellend
  exporting
  #1 = p_rowend
  #2 = p_colend.
  call method of go_worksheet 'Range' = lo_range
  exporting
  #1 = lo_cellstart
  #2 = lo_cellend.

* Set a name to this Range
  set property of lo_range 'Name' = p_name.

endform.   "set_range_name
*&———————————————————————*
*&      Form  drop_down_list
*&———————————————————————*
*  drop_down_list
*———————————————————————-*
*  –>  p_rowini  p_colini Initial Range Cell
*  –>  p_rowend  p_colend End Range Cell
*  –>  p_name    name of the value list
*———————————————————————-*
form drop_down_list using p_rowini p_colini
p_rowend p_colend
p_name.

  data: lo_cellstart  type ole2_object,
        lo_cellend    type ole2_object,
        lo_selection  type ole2_object,
        lo_range      type ole2_object,
        lo_validation type ole2_object.

  data: lv_range_name type char24.

* Select the Range of Cells:
  call method of go_worksheet 'Cells' = lo_cellstart
  exporting
  #1 = p_rowini
  #2 = p_colini.
  call method of go_worksheet 'Cells' = lo_cellend
  exporting
  #1 = p_rowend
  #2 = p_colend.
  call method of go_worksheet 'Range' = lo_range
  exporting
  #1 = lo_cellstart
  #2 = lo_cellend.

  call method of lo_range 'select'.
  call method of go_application 'selection' = lo_selection.
  call method of lo_selection 'Validation' = lo_validation.
  concatenate '=' p_name into lv_range_name.
  call method of lo_validation 'Add'
    exporting
      #1 = 3 "'xlValidateList'
      #2 = 1 "'xlvalidalertstop'
      #3 = 1 "'xlbetween'
      #4 = lv_range_name.

endform.   "drop_down_list
*&———————————————————————*
*&      Form  print_data_fieldcat
*&———————————————————————*
*& Add data to be printed in subrutine PASTE_CLIPBOARD
*& Only the fields in table gt_fieldcat will be included.
*&———————————————————————*
*  –>  p_data       Data to print
*  –>  p_row p_col  Cell from the data will be printed
*  –>  p_header     Print the header
*&———————————————————————*
form print_data_fieldcat using p_data type standard table
p_row type i
p_col type i
p_header.

  field-symbols: <field>   type any,
                 <ls_data> type any.
  data: lv_char      type char128,
        lv_othr      type string,
        lv_cont      type i,
        lo_column    type ole2_object,
        lo_selection type ole2_object.

  data: lo_cell      type ole2_object,
        lo_cellend   type ole2_object,
        lo_range     type ole2_object,
        lo_font      type ole2_object,
        lo_interior  type ole2_object.

  data: lo_abap_typedescr type ref to cl_abap_typedescr.

  clear: gs_data, gt_data[].

* Print the header:
  if p_header eq 'X'.
    clear gt_lines[].
    loop at gt_fieldcat into gs_fieldcat.
      gs_lines-value = gs_fieldcat-text. append gs_lines to gt_lines.
    endloop.
    perform add_line2print_from_table.
  endif.

  clear lv_cont.
  describe table p_data lines lv_cont.
* Print the data:
  loop at p_data assigning <ls_data>.
    loop at gt_fieldcat into gs_fieldcat.
      assign component gs_fieldcat-field of structure <ls_data> to <field>.
      if sy-subrc eq 0.
*         Convert data depend on the kind type.
        call method cl_abap_typedescr=>describe_by_data
          exporting
            p_data      = <field>
          receiving
            p_descr_ref = lo_abap_typedescr.
        case lo_abap_typedescr->type_kind.
*           Char
          when lo_abap_typedescr->typekind_char.
            concatenate gs_data <field> into gs_data
            separated by cl_abap_char_utilities=>horizontal_tab.
*           Date
          when lo_abap_typedescr->typekind_date.
            write <field> to lv_char dd/mm/yyyy.
            concatenate gs_data lv_char into gs_data
            separated by cl_abap_char_utilities=>horizontal_tab.
*           Time
          when lo_abap_typedescr->typekind_time.
            concatenate <field>(2) <field>+2(2) <field>+4(2) into lv_char separated by ':'.
            concatenate gs_data lv_char into gs_data
            separated by cl_abap_char_utilities=>horizontal_tab.
*          Others
          when others.
*          WRITE <field> TO lv_char.
            lv_othr = <field>.
            concatenate gs_data lv_othr into gs_data
            separated by cl_abap_char_utilities=>horizontal_tab.
        endcase.
        endif.

    endloop.
*   Quit the first horizontal_tab:
    shift gs_data by 1 places left.

    append gs_data to gt_data. clear gs_data.
  endloop.

* Print the data:
  perform paste_clipboard using p_row p_col.

  data: lo_columns type ole2_object.
  call method of go_application 'Columns' = lo_columns.
  call method of lo_columns 'Autofit'.


* Set the columns width
  clear lv_cont.
  loop at gt_fieldcat into gs_fieldcat.
    add 1 to lv_cont.
    if gs_fieldcat-width ne 0.
      call method of go_worksheet 'Columns' = lo_column
      exporting
      #1 = lv_cont.

      call method of lo_column 'select'.
      call method of go_application 'selection' = lo_selection.
      set property of lo_column 'ColumnWidth' = gs_fieldcat-width.
    endif.
  endloop.

endform.                    "print_data_fieldcat
