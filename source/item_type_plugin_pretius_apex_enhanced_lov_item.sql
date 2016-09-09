set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin ();
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/pretius_apex_enhanced_lov_item
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(149091135813470623)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'PRETIUS_APEX_ENHANCED_LOV_ITEM'
,p_display_name=>'Pretius APEX Enhanced LOV item'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'e_temp exception;',
'e_no_data_found exception;',
'e_temp_msg varchar2(4000);',
'',
'g_translation_dict boolean := true;',
'g_translation varchar2(4000) := ''{',
'  ''''PAELI_AUTOFILTER_NDF'''': ''''No data found for:'''',',
'  ''''PAELI_PASTED_LENGTH'''': ''''Pasted content exceeds maximum length of #limit# characters for this input. '''',',
'  ''''PAELI_POPUP_LENGTH'''': ''''Length of selected values exceeds #limit# characters. Please select less values.'''',',
'  ''''PAELI_POPUP_WARNING'''': ''''Warning!'''',',
'  ''''PAELI_POPUP_WARNINGINFO'''': ''''Confirming this dialog will overwrite all pasted values with selected below. No matches found for given values:'''',',
'  ''''PAELI_BTN_SELECT'''': ''''Select'''',',
'  ''''PAELI_POPUP_NDF_AUTOFILTER'''': ''''No records found for given string "#SEARCH_STRING#".'''',',
'  ''''PAELI_POPUP_NDF'''': ''''Dictionary has no values.'''',',
'  ''''PAELI_POPUP_NDF_SELECTED'''': ''''Within selected rows there is no result for "#SEARCH_STRING#". If you wanted to search in all values, please deselect "Select all" checkbox. '''',',
'  ''''PAELI_POPUP_SELECT_ALL'''': ''''Select all'''',',
'  ''''PAELI_POPUP_SHOW_SELECTED'''': ''''Show selected'''',',
'  ''''PAELI_SELECT_ALL_WARNING'''': ''''You want to select values that exceeds limit of #LIMIT# characters. Inserting to many values may result with error. Would you like to proceed?'''',',
'  ''''PAELI_SELECT_ALL_AUTOFILTER'''': ''''Select all values'''',',
'  ''''PAELI_POPUP_SUFIX'''': '''' - POPUP''''',
'}'';',
'',
'',
'function trim_json(',
'  p_string in clob,',
'  p_escape in boolean default true',
') return clob',
'is ',
'  v_result clob;',
'begin',
'  v_result := replace(p_string, chr(9), '''');',
'  v_result := replace(v_result, chr(160), '''');',
'  v_result := replace(p_string, chr(10), '''');',
'  v_result := replace(v_result, chr(13), '''');',
'  v_result := replace(v_result, chr(92), chr(92)||chr(92));',
'  v_result := rtrim(v_result, '' '');',
'  v_result := rtrim(v_result, '','');',
'  ',
'  if p_escape then',
'    v_result := htf.escape_sc(v_result);',
'  end if;',
'',
'  return v_result;',
'exception ',
'  when others then',
'    htp.p(''{"error": 1,"SQLERRM": "''||SQLERRM||''","func_name": "trim_json"}'');',
'',
'end trim_json;',
'',
'',
'',
'function current_time_ms',
'  return number',
'is',
'  out_result number;',
'begin',
'  select ',
'    extract(day from(systimestamp - to_timestamp(''1970-01-01'', ''YYYY-MM-DD''))) * 86400000 + to_number(to_char(sys_extract_utc(systimestamp), ''SSSSSFF3''))',
'  into ',
'    out_result',
'  from ',
'    dual;',
'    ',
'  return out_result;',
'end current_time_ms;',
'',
'function perform_binds(',
'  p_query in varchar2',
') return varchar2 ',
'is',
'  v_item_names DBMS_SQL.VARCHAR2_TABLE;',
'  v_item_value varchar2(100);',
'  v_af_query varchar2(32000);',
'begin',
'  v_af_query := p_query;',
'  v_item_names := WWV_FLOW_UTILITIES.GET_BINDS(v_af_query); ',
'  ',
'  for i in 1..v_item_names.count loop',
'  ',
'    v_item_value := APEX_UTIL.GET_SESSION_STATE (',
'      p_item => ltrim(v_item_names(i), '':'')',
'    );',
'    ',
'    v_item_value := APEX_PLUGIN_UTIL.ESCAPE (',
'      p_value  => v_item_value,',
'      p_escape => true',
'    );',
'  ',
'    if REGEXP_LIKE (v_item_value, ''^\d*$'') then',
'      v_af_query := replace(v_af_query, v_item_names(i), v(ltrim(v_item_names(i), '':'')));',
'    else',
'      v_af_query := replace(v_af_query, v_item_names(i), chr(39)||v(ltrim(v_item_names(i), '':''))||chr(39));',
'    end if;',
'  ',
'  end loop;',
'  ',
'  v_af_query := apex_plugin_util.replace_substitutions (',
'    p_value => v_af_query,',
'    p_escape => true ',
'  );',
'  ',
'  return v_af_query;',
'  ',
'end perform_binds;',
'',
'',
'procedure force_delete_collection(',
'  p_collection_name in varchar2',
') is',
'BEGIN',
'  APEX_COLLECTION.DELETE_COLLECTION( p_collection_name );',
'  APEX_COLLECTION.DELETE_COLLECTION( p_collection_name );',
'exception',
'  when others then',
'    null;',
'end;',
'',
'-------------',
'-- render_pal',
'-------------',
'function render_pal (',
'  p_item in apex_plugin.t_page_item,',
'  p_plugin in apex_plugin.t_plugin,',
'  p_value in varchar2,',
'  p_is_readonly in boolean,',
'  p_is_printer_friendly in boolean',
') return apex_plugin.t_page_item_render_result',
'is',
'  l_name varchar2(30);',
'  l_result apex_plugin.t_page_item_render_result;',
'  l_item_html varchar2(32000);',
'  v_item_mask_attr varchar2(4000);',
' ',
'  v_translation_JSON varchar2(32000) := g_translation; ',
'',
'  v_autofilter varchar2(1)           := NVL(p_item.attribute_01, ''N'');',
'  v_is_lov_avail varchar2(1)         := NVL(p_item.attribute_02, ''N'');',
'  v_multiple varchar2(3)             := NVL(p_item.attribute_03, ''N'');',
'  v_separator varchar2(1)            := NVL(p_item.attribute_05, '':'');',
'  v_debounce_ms varchar2(4)          := NVL(p_item.attribute_06, 300);',
'  v_is_paste_allowed varchar2(1)     := NVL(p_item.attribute_08, ''N'');',
'  v_max_chars varchar2(5)            := NVL(p_item.attribute_11, 4000);',
'  v_returnCollumn varchar2(1)        := NVL(p_item.attribute_12, ''N''); ',
'  v_submit_page varchar2(1)          := NVL(p_item.attribute_13, ''N''); ',
'  v_show_processing varchar2(1)      := NVL(p_item.attribute_14, ''N''); ',
'  v_recreate_coll varchar2(1)        := NVL(p_item.attribute_15, ''N''); ',
' ',
'  v_translation_dict varchar2(32000);  ',
'  v_options varchar2(32000);',
'  v_lang varchar2(20);',
'  ',
'  v_collection_name varchar2(100) := p_item.name;',
'  v_sql varchar2(4000);',
'',
'  v_lov_display_extra varchar2(5); ',
'  v_lov_display_null varchar2(5); ',
'  v_lov_exists varchar2(1);',
'  v_apex_version number;',
'begin',
'',
'  select substr(VERSION_NO, 1, 1) into v_apex_version from apex_release;',
'',
'  v_sql := perform_binds(p_item.lov_definition);',
'',
'  if v_sql is not null then',
'    v_lov_exists := ''Y'';',
'  else',
'    v_lov_exists := ''N'';',
'  end if;',
'',
'  if :REQUEST = ''PAELI_CLEAR'' then',
'    --wyczysci kolekcje kazdego itemu typu ten plugin',
'    force_delete_collection( v_collection_name );',
'',
'  elsif instr(:REQUEST, ''PAELI_CLEAR'') > 0 then',
'    --wyczyscie kolekcjie dla konkretnego itemu',
'    force_delete_collection( substr( :REQUEST,  13, length(:request)) );',
'  end if;',
'',
'  if g_translation_dict then',
'    select APPLICATION_PRIMARY_LANGUAGE into v_lang from APEX_APPLICATIONS where application_id = :APP_ID;',
'    ',
'    for i in (',
'      select ',
'        TRANSLATABLE_MESSAGE,',
'        MESSAGE_TEXT',
'      from',
'        APEX_APPLICATION_TRANSLATIONS ',
'      where',
'        APPLICATION_ID = :APP_ID',
'        and LANGUAGE_CODE = v_lang',
'        and TRANSLATABLE_MESSAGE like ''PAELI%''',
'    ) loop',
'      v_translation_dict := v_translation_dict||apex_javascript.add_attribute(i.TRANSLATABLE_MESSAGE, i.MESSAGE_TEXT, false);',
'    end loop;',
'    ',
'    v_translation_dict := ''{''||rtrim(v_translation_dict, '','')||''}'';',
'  ',
'  else',
'    v_translation_dict := ''{}'';',
'  end if;',
'',
'  if v_recreate_coll = ''Y'' then',
'    ',
'    force_delete_collection( v_collection_name );',
'',
'    APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY_B  (',
'      p_collection_name => v_collection_name,',
'      p_query => v_sql',
'    );',
'      ',
'  end if;',
'',
'  l_name := apex_plugin.get_input_name_for_page_item(p_is_multi_value => false);',
'  ',
'  v_item_mask_attr := ''size="''||p_item.element_width||''" maxlength="''||p_item.element_max_length||''" ''||p_item.element_attributes||'' ''||p_item.element_option_attributes;',
'',
'  if p_is_readonly then',
'    v_item_mask_attr := v_item_mask_attr||'' readonly="readonly"'';',
'  end if;',
'  ',
'  l_item_html := ''',
'    <div class="palv2_pluginContainer" id="P''||p_item.id||''">',
'      <input type="hidden" name="''||l_name||''" id="''||p_item.name||''"  value="''||htf.escape_sc(p_value)||''" >',
'      <input type="text" autocomplete="off" class="palv2_pluginMask" value="''||htf.escape_sc(p_value)||''" id="''||p_item.name||''_DISPLAY" for="''||p_item.name||''" ''||v_item_mask_attr||''>',
'      <span class="icons">',
'        <i class="palv2_iconLoader palv2_iconHidden"></i>',
'  '';',
'  ',
'  if not p_is_readonly then',
'  ',
'    if v_is_lov_avail = ''Y'' then',
'      l_item_html := l_item_html||''',
'        <i class="palv2_iconTrigger"></i>',
'      '';',
'    elsif v_is_lov_avail = ''N'' and v_is_paste_allowed = ''Y'' then',
'      l_item_html := l_item_html||''',
'        <i class="palv2_iconTrigger" style="display: none"></i>',
'      '';',
'',
'    else',
'      l_item_html := l_item_html||''',
'        <i class="palv2_iconTrigger" style="visibility: hidden"></i>',
'      '';',
'    end if;',
'  end if;',
'  ',
'  l_item_html := l_item_html||''',
'        <i class="palv2_iconPasted palv2_iconHidden"></i>',
'      </span>',
'    </div>',
'  '';',
'  ',
'  htp.p(l_item_html);',
'',
'  if p_item.lov_display_extra then',
'    v_lov_display_extra := ''true'';',
'  else',
'    v_lov_display_extra := ''false'';',
'  end if;',
'',
'  if p_item.lov_display_null then',
'    v_lov_display_null := ''true'';',
'  else',
'    v_lov_display_null := ''false'';',
'  end if;',
'',
'',
'  if  v_multiple = ''MD'' then',
'   v_multiple := ''Y'';',
'   v_options :=apex_javascript.add_attribute(''_multiple'', v_multiple)||apex_javascript.add_attribute(''_multipleDisplay'', ''Y'');',
'  else',
'   v_options :=apex_javascript.add_attribute(''_multiple'', v_multiple)||apex_javascript.add_attribute(''_multipleDisplay'', ''N'');',
'  end if;',
'',
'',
'  v_options := v_options ||          ',
'    apex_javascript.add_attribute(''_allowPaste'', v_is_paste_allowed)||',
'    apex_javascript.add_attribute(''_maxChars'', v_max_chars)||',
'    apex_javascript.add_attribute(''_showProcessing'', v_show_processing)||',
'    apex_javascript.add_attribute(''_submitPage'', v_submit_page)||',
'    apex_javascript.add_attribute(''_debounce_ms'', v_debounce_ms)||',
'    apex_javascript.add_attribute(''_separator'', v_separator)||',
'    ''"_translation_DICT":''||v_translation_dict||'',''||',
'    ''"_translation_ITEM":''||trim_json(v_translation_JSON, false)||'',''||',
'    apex_javascript.add_attribute(''_returnCollumn'', v_returnCollumn)||    ',
'    apex_javascript.add_attribute(''_lov'', v_is_lov_avail)||',
'    apex_javascript.add_attribute(''_lov_sql_exists'', v_lov_exists)||',
'    apex_javascript.add_attribute(''_autofilter'', v_autofilter)||',
'    apex_javascript.add_attribute(''itemApexId'', p_item.id)||',
'    apex_javascript.add_attribute(''label'', p_item.plain_label)||',
'    apex_javascript.add_attribute(''ajaxIdentifier'', apex_plugin.get_ajax_identifier)||',
'    apex_javascript.add_attribute(''dependingOnSelector'', apex_plugin_util.page_item_names_to_jquery(p_item.lov_cascade_parent_items))||',
'    replace(replace(apex_javascript.add_attribute(''lov_display_extra'', v_lov_display_extra), ''"true"'', ''true''), ''"false"'', ''false'')||',
'    replace(replace(apex_javascript.add_attribute(''lov_display_null'', v_lov_display_null), ''"true"'', ''true''), ''"false"'', ''false'')||',
'    replace(apex_javascript.add_attribute(''lov_null_text'', nvl(p_item.lov_null_text, ''null'')), ''"null"'', ''null'')||',
'    replace(apex_javascript.add_attribute(''lov_null_value'', nvl(p_item.lov_null_value, ''null'')), ''"null"'', ''null'')||',
'    apex_javascript.add_attribute(''optimizeRefresh'', p_item.ajax_optimize_refresh)||',
'    apex_javascript.add_attribute(''pageItemsToSubmit'', apex_plugin_util.page_item_names_to_jquery(p_item.ajax_items_to_submit))||',
'    apex_javascript.add_attribute(''nullValue'', p_item.lov_null_value, false, false)',
'  ;',
'  ',
'  apex_javascript.add_onload_code (',
'    p_code => ''palv2_init("''||p_item.name||''",{''||v_options||''});'',',
'    p_key => ''palv2_init''||p_item.name',
'  );',
'',
'  apex_javascript.add_library(',
'    p_name => ''jquery1.11'', ',
'    p_directory => p_plugin.file_prefix, ',
'    p_version => null ',
'  );',
'',
'  apex_javascript.add_library(',
'    p_name => ''mustache'', ',
'    p_directory => p_plugin.file_prefix, ',
'    p_version => null ',
'  );',
'',
'  apex_css.add_file (  ',
'    p_name => ''style'',',
'    p_directory => p_plugin.file_prefix, ',
'    p_version => null',
'  );',
'',
'  apex_css.add_file (  ',
'    p_name => ''style''||v_apex_version,',
'    p_directory => p_plugin.file_prefix, ',
'    p_version => null',
'  );',
'',
'',
'  apex_javascript.add_library(',
'    p_name => ''bootstrap.min-popover'', ',
'    p_directory => p_plugin.file_prefix, ',
'    p_version => null ',
'  );',
'',
'  apex_css.add_file (  ',
'    p_name => ''bootstrap.min-popover'',',
'    p_directory => p_plugin.file_prefix, ',
'    p_version => null',
'  );',
'',
'  apex_javascript.add_library(',
'    p_name => ''jquery-catchpaste-1.0.0'', ',
'    p_directory => p_plugin.file_prefix, ',
'    p_version => null ',
'  );',
'',
'  apex_javascript.add_library(',
'    p_name => ''jquery.caret.1.02.min2'', ',
'    p_directory => p_plugin.file_prefix, ',
'    p_version => null ',
'  );',
'',
'  apex_javascript.add_library(',
'    p_name => ''onload'', ',
'    p_directory => p_plugin.file_prefix, ',
'    p_version => null ',
'  );',
'',
'',
'  return l_result;',
'end render_pal;',
'',
'----------------',
'-- apex_ajax_pal',
'----------------',
'function apex_ajax_pal (',
'  p_item   in apex_plugin.t_page_item,',
'  p_plugin in apex_plugin.t_plugin',
') return apex_plugin.t_page_item_ajax_result',
'is',
'  v_autofilter_multiple varchar2(10) := ''false'';',
'  v_af_query varchar2(32000);',
'  v_collection_name varchar2(100) := p_item.name;',
'  v_get_mask varchar2(4000);',
'  v_get_return_value varchar2(4000);',
'',
'  v_sql varchar2(4000);',
'',
'  v_temp_return_value varchar2(2000);',
'  v_temp_display_value varchar2(2000);',
'  v_time_start number;',
'  v_time_end number;',
'  v_time_diff number;',
'  v_class number;',
'  v_rownum_plus number := 0;',
'  v_search_escape varchar2(120) := ''replace(replace( replace(v_search, chr(92), chr(92)||chr(92)), ''''%'''', chr(92)||''''%''''), ''''_'''', chr(92)||''''_'''')'';',
'  v_coll_getmask varchar2(200) := p_item.name||''MASKCOLL'';',
'  v_dict_length number :=0;',
'',
'  v_column_seq_sort number := 1;',
'',
'  v_mode varchar2(100) := apex_application.g_x01;',
'  v_search varchar2(32000) := upper(apex_application.g_x02);',
'',
'  v_column_seq number        := NVL(p_item.attribute_10, -1);  ',
'  v_separator varchar2(1)    := NVL(p_item.attribute_05, '':''); ',
'  v_filter_columns number    := NVL(p_item.attribute_09, -1);  ',
'  v_prompt_like number       := NVL(p_item.attribute_04, -1);  ',
'  v_is_lov_avail varchar2(1) := NVL(p_item.attribute_02, ''N''); ',
'  v_multiple varchar2(2)     := NVL(p_item.attribute_03, ''N''); ',
'',
'begin',
'  v_time_start := current_time_ms();',
'  ',
'  v_sql := perform_binds(p_item.lov_definition);',
'  ',
'  begin',
'    if v_mode = ''forceRefresh'' then',
'      ',
'      if APEX_COLLECTION.COLLECTION_EXISTS (v_collection_name) then',
'        force_delete_collection( v_collection_name );',
'      end if;',
'      ',
'      APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY_B  (',
'        p_collection_name => v_collection_name,',
'        p_query => v_sql',
'      );',
'      ',
'      return null;',
'    end if;',
'  exception',
'    when others then',
'      e_temp_msg := ''Recreate collection:\n''||SQLERRM;',
'      raise e_temp;',
'  end;',
'',
'  begin',
'    if NOT APEX_COLLECTION.COLLECTION_EXISTS (v_collection_name) then',
'      force_delete_collection( v_collection_name );',
'',
'      APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY_B  (',
'        p_collection_name => v_collection_name,',
'        p_query => v_sql',
'      );',
'    end if;',
'  exception',
'    when others then',
'      e_temp_msg := ''Creating plugin collection:\n''||SQLERRM;',
'      raise e_temp;',
'  end;',
'  ',
'  v_dict_length := APEX_COLLECTION.COLLECTION_MEMBER_COUNT (v_collection_name);',
'    ',
'  if v_dict_length = 0 then',
'    e_temp_msg := ''Dictionary source returned 0 rows.\nPlease check dictionary source'';',
'    raise e_temp;',
'  end if;',
'  ',
'  if v_column_seq in (1, 4, 11) then',
'    v_column_seq_sort := 1;',
'  elsif v_column_seq in (2, 3, 7) then',
'    v_column_seq_sort := 2;',
'  elsif v_column_seq in (6, 12, 16) then',
'    v_column_seq_sort := 3;',
'  elsif v_column_seq in (8, 10, 14) then',
'    v_column_seq_sort := 4;',
'  elsif v_column_seq in (17, 21, 25) then',
'    v_column_seq_sort := 5;',
'  elsif v_column_seq in (18, 22, 26) then',
'    v_column_seq_sort := 6;',
'  elsif v_column_seq in (19, 23, 27) then',
'    v_column_seq_sort := 7;',
'  elsif v_column_seq in (20, 24, 28) then',
'    v_column_seq_sort := 8;',
'  end if;',
'',
'  htp.p(''',
'    {',
'      "values": [',
'  '');  ',
'',
'  if v_mode = ''autofilter'' then',
'    v_af_query := ''',
'      select',
'    '';',
'',
'    if v_column_seq in (1,3,6,7,8,14,17,18,19,20,25,26) then',
'      v_af_query := v_af_query||''c001 as c001a,'';',
'    else',
'      v_af_query := v_af_query||''c002 as c001a,'';',
'    end if;',
'',
'    if v_column_seq in (2,3,10,11,12,14,21,22,23,24,25,26) then',
'      v_af_query := v_af_query||''c001 as c002a,'';',
'    else',
'      v_af_query := v_af_query||''c002 as c002a,'';',
'    end if;',
'',
'    v_af_query := v_af_query||''',
'        rownum rn,',
'        count(*) over (partition by 1) as cnt',
'',
'      from (',
'        select  ',
'          c001,',
'          c002',
'        from',
'          apex_collections',
'        where',
'          collection_name = v_collection_name',
'',
'    '';',
'',
'    --sprwadz czy w ogole jest mozliwosc wybrania wielu wartosci w popup',
'    if v_is_lov_avail = ''Y'' and  (v_multiple = ''Y'' or v_multiple = ''MD'') then',
'      if regexp_like( v_search, ''^[0-9]*$'' ) then',
'        v_autofilter_multiple := ''false'';',
'',
'      elsif regexp_like( v_search, ''^[0-9''||v_separator||'']*$'' ) then',
'        v_autofilter_multiple := ''true'';',
'',
'        v_af_query := v_af_query ||''',
'          and (',
'            c001 in (''''''||replace(v_search, v_separator, '''''','''''')||'''''')',
'            or c002 in (''''''||replace(v_search, v_separator, '''''','''''')||'''''')',
'          )',
'        '';',
'      end if;',
'    end if;',
'',
'    if v_autofilter_multiple = ''false'' then',
'      v_autofilter_multiple := ''false'';',
'',
'      -- z lewej',
'      if v_filter_columns = 1 AND v_prompt_like = 1 then',
'        v_af_query := v_af_query ||''',
'          and upper(c001) like ''''%''''||v_search',
'        '';',
'      end if;',
'',
'      if v_filter_columns = 1 AND v_prompt_like = 4 then',
'        v_af_query := v_af_query ||''',
'          and upper(c001) like ''''%''''||''||v_search_escape||'' escape chr(92)',
'        '';',
'      end if;',
'',
'      --z prawej',
'      if v_filter_columns = 1 AND v_prompt_like = 2 then',
'        v_af_query := v_af_query ||''',
'          and upper(c001) like v_search||''''%''''',
'        '';',
'      end if;',
'      ',
'      if v_filter_columns = 1 AND v_prompt_like = 5 then',
'        v_af_query := v_af_query ||''',
'          and upper(c001) like ''||v_search_escape||''||''''%'''' escape chr(92)',
'        '';',
'      end if;',
'',
'      -- z obu',
'      if v_filter_columns = 1 AND v_prompt_like in (3) then',
'        v_af_query := v_af_query ||'' and upper(c001) like ''''%''''||v_search||''''%'''''';',
'      end if;',
'',
'      if v_filter_columns = 1 AND v_prompt_like in (6) then',
'        v_af_query := v_af_query ||'' and upper(c001) like ''''%''''||''||v_search_escape||''||''''%'''' escape chr(92)'';',
'      end if;',
'',
'      --z zadnej',
'      if v_filter_columns = 1 AND v_prompt_like in (7) then',
'        v_af_query := v_af_query ||'' and upper(c001) like v_search'';',
'      end if;',
'',
'      if v_filter_columns = 1 AND v_prompt_like in (8) then',
'        v_af_query := v_af_query ||'' and upper(c001) like ''||v_search_escape||'' escape chr(92)'';',
'      end if;',
'      ',
'      -- z lewej',
'      if v_filter_columns = 2 AND v_prompt_like in (1) then',
'        v_af_query := v_af_query ||'' and upper(c002) like ''''%''''||v_search'';',
'      end if;',
'',
'      if v_filter_columns = 2 AND v_prompt_like in (4) then',
'        v_af_query := v_af_query ||'' and upper(c002) like ''''%''''||''||v_search_escape||'' escape chr(92)'';',
'      end if;',
'      ',
'      --z prawej',
'      if v_filter_columns = 2 AND v_prompt_like in (2) then',
'        v_af_query := v_af_query ||'' and upper(c002) like v_search||''''%'''''';',
'      end if;',
'',
'      if v_filter_columns = 2 AND v_prompt_like in (5) then',
'        v_af_query := v_af_query ||'' and upper(c002) like ''||v_search_escape||''||''''%'''' escape chr(92)'';',
'      end if;',
'      ',
'      --z obu',
'      if v_filter_columns = 2 AND v_prompt_like in (3) then',
'        v_af_query := v_af_query ||'' and upper(c002) like ''''%''''||v_search||''''%'''''';',
'      end if;',
'',
'      if v_filter_columns = 2 AND v_prompt_like in (6) then',
'        v_af_query := v_af_query ||'' and upper(c002) like ''''%''''||''||v_search_escape||''||''''%'''' escape chr(92)'';',
'      end if;',
'',
'      --zadnej',
'      if v_filter_columns = 2 AND v_prompt_like in (7) then',
'        v_af_query := v_af_query ||'' and upper(c002) like v_search'';',
'      end if;',
'',
'      if v_filter_columns = 2 AND v_prompt_like in (8) then',
'        v_af_query := v_af_query ||'' and upper(c002) like ''||v_search_escape||'' escape chr(92)'';',
'      end if;',
'      ',
'      --z lewej',
'      if v_filter_columns = 3 AND v_prompt_like in (1) then',
'        v_af_query := v_af_query ||''',
'          and (',
'            upper(c001) like ''''%''''||v_search',
'            OR upper(c002) like ''''%''''||v_search',
'          )',
'        '';',
'      end if;',
'      ',
'      if v_filter_columns = 3 AND v_prompt_like in (4) then',
'        v_af_query := v_af_query ||''',
'          and (',
'            upper(c001) like ''''%''''||''||v_search_escape||'' escape chr(92)',
'            OR upper(c002) like ''''%''''||''||v_search_escape||'' escape chr(92)',
'          )',
'        '';',
'      end if;',
'',
'      ',
'      --z prawej',
'      if v_filter_columns = 3 AND v_prompt_like in (2) then',
'        v_af_query := v_af_query ||''',
'          and (',
'            upper(c001) like v_search||''''%''''',
'            OR upper(c002) like v_search||''''%''''',
'          )',
'        '';',
'      end if;',
'      ',
'      if v_filter_columns = 3 AND v_prompt_like in (5) then',
'        v_af_query := v_af_query ||''',
'          and (',
'            upper(c001) like ''||v_search_escape||''||''''%'''' escape chr(92)',
'            OR upper(c002) like ''||v_search_escape||''||''''%'''' escape chr(92)',
'          )',
'        '';',
'      end if;',
'',
'      --z obu',
'      if v_filter_columns = 3 AND v_prompt_like in (3) then',
'        v_af_query := v_af_query ||''',
'          and (',
'            upper(c001) like ''''%''''||v_search||''''%''''',
'            OR upper(c002) like ''''%''''||v_search||''''%''''',
'          )',
'        '';',
'      end if;',
'      ',
'      if v_filter_columns = 3 AND v_prompt_like in (6) then',
'        v_af_query := v_af_query ||''',
'          and (',
'            upper(c001) like ''''%''''||''||v_search_escape||''||''''%'''' escape chr(92)',
'            OR upper(c002) like ''''%''''||''||v_search_escape||''||''''%'''' escape chr(92)',
'          )',
'        '';',
'      end if;',
'',
'      --z zadnej',
'      if v_filter_columns = 3 AND v_prompt_like in (7) then',
'        v_af_query := v_af_query ||''',
'          and (',
'            upper(c001) like v_search',
'            OR upper(c002) like v_search',
'          )',
'        '';',
'      end if;',
'      ',
'      if v_filter_columns = 3 AND v_prompt_like in (8) then',
'        v_af_query := v_af_query ||''',
'          and (',
'            upper(c001) like ''||v_search_escape||'' escape chr(92)',
'            OR upper(c002) like ''||v_search_escape||'' escape chr(92)',
'          )',
'        '';',
'      end if;',
'    end if;      ',
'',
'',
'    if v_column_seq_sort = 1 then',
'      v_af_query := v_af_query ||'' order by c002 asc )'';',
'    elsif v_column_seq_sort = 2 then',
'      v_af_query := v_af_query ||'' order by c001 asc )'';',
'    elsif v_column_seq_sort = 3 then',
'      v_af_query := v_af_query ||'' order by c002 desc )'';',
'    elsif v_column_seq_sort = 4 then',
'      v_af_query := v_af_query ||'' order by c001 desc )'';',
'    elsif v_column_seq_sort = 5 then',
'      v_af_query := v_af_query ||'' order by to_number(c001) asc )'';',
'    elsif v_column_seq_sort = 6 then',
'      v_af_query := v_af_query ||'' order by to_number(c001) desc )'';',
'    elsif v_column_seq_sort = 7 then',
'      v_af_query := v_af_query ||'' order by to_number(c002) asc )'';',
'    elsif v_column_seq_sort = 8 then',
'      v_af_query := v_af_query ||'' order by to_number(c002) desc )'';',
'',
'    end if;',
'',
'',
'',
'    v_af_query := ''',
'      declare',
'        v_temp_return_value varchar2(2000);',
'        v_temp_display_value varchar2(2000);',
'        v_search varchar2(2000) := :1;',
'        v_column_seq number := :2;',
'        v_collection_name varchar2(50) := :3;',
'',
'        function removeInvalidChars(',
'          p_string in varchar2',
'        ) return varchar2 ',
'        is',
'          v_string varchar2(4000);',
'        begin',
'          v_string := htf.escape_sc( p_string );',
'          v_string := replace( v_string, chr(10),  ''''  '''' );',
'          v_string := replace( v_string, chr(13),  ''''  '''' );',
'          v_string := replace( v_string, chr(160),  ''''  '''' );',
'          v_string := replace( v_string, chr(9),  ''''  '''' );',
'          return v_string;',
'        end;',
'      begin',
'        for i in (  ',
'          ''||v_af_query||''',
'        ) loop',
'          v_temp_display_value := removeInvalidChars(i.c002a) ;',
'          v_temp_return_value :=  removeInvalidChars(i.c001a) ;',
'          ',
'          if i.rn = i.cnt then',
'            htp.p(''''{"r":"''''|| v_temp_return_value  ||''''","d":"''''|| v_temp_display_value ||''''","i":''''||i.rn||''''}'''');',
'          else',
'            htp.p(''''{"r":"''''|| v_temp_return_value  ||''''","d":"''''|| v_temp_display_value ||''''","i":''''||i.rn||''''},'''');',
'          end if;',
'        ',
'        end loop;',
'      end;',
'    '';',
'',
'    execute immediate v_af_query USING v_search, v_column_seq, v_collection_name;',
'  elsif v_mode = ''getAllMask'' then',
'',
'    force_delete_collection( v_coll_getmask );',
'',
'    APEX_COLLECTION.CREATE_COLLECTION( v_coll_getmask );',
'    APEX_COLLECTION.ADD_MEMBERS( v_coll_getmask, APEX_UTIL.STRING_TO_TABLE(v_search, v_separator) );',
'',
'    for i in (',
'      select ',
'        case',
'          when v_column_seq in (1,3,6,7,8,14,17,18,19,20,25,26) then p.c001',
'          when v_column_seq in (2,4,10,11,12,16,21,22,23,24,27,28) then p.c002',
'          else ''Wrong column seq''',
'        end c001,',
'        case ',
'          when v_column_seq in (2,3,10,11,12,14,21,22,23,24,25,26) then p.c001',
'          when v_column_seq in (1,4,6,7,8,16,17,18,19,20,27,28) then p.c002',
'          else ''Wrong column seq''',
'        end c002,',
'        count(*) over (partition by 1) as cnt, rownum as rn',
'      from (',
'        select',
'          SEQ_ID,',
'          c001',
'        from',
'          apex_collections ',
'        where',
'          collection_name = v_coll_getmask',
'      ) m',
'      left join (',
'        select ',
'          c001,',
'          c002',
'        from',
'          apex_collections ',
'        where',
'          collection_name = v_collection_name',
'      ) p',
'      on',
'        v_column_seq in (1,3,6,7,8,14,17,18,19,20,25,26) and m.c001 = p.c001',
'        or v_column_seq in (2,4,10,11,12,16,21,22,23,24,27,28) and m.c001 = p.c002',
'      order by ',
'        m.SEQ_ID',
'    ) LOOP',
'      v_temp_display_value := trim_json(  i.c002 );',
'      v_temp_return_value := trim_json( i.c001 );',
'',
'      if i.rn = i.cnt then',
'        htp.p(''{"r":"''|| v_temp_return_value  ||''","d":"''|| v_temp_display_value ||''"}'');',
'      else',
'        htp.p(''{"r":"''|| v_temp_return_value  ||''","d":"''|| v_temp_display_value ||''"},'');',
'      end if;',
'    end loop;',
'',
'  elsif v_mode = ''popupLOV'' then',
'',
'    if p_item.lov_display_null then',
'      htp.p(''{"r": "''||trim_json( p_item.lov_null_value )||''","d": "''|| trim_json( p_item.lov_null_text ) ||''","i": ''||1||''},'');',
'',
'      v_rownum_plus := 1;',
'    end if;',
'',
'    for i in (',
'      select',
'        case',
'          when v_column_seq in (1,3,6,7,8,14,17,18,19,20,25,26) then c001',
'          when v_column_seq in (2,4,10,11,12,16,21,22,23,24,27,28) then c002',
'          else ''Wrong column seq''',
'        end c001,',
'        case ',
'          when v_column_seq in (2,3,10,11,12,14,21,22,23,24,25,26) then c001',
'          when v_column_seq in (1,4,6,7,8,16,17,18,19,20,27,28) then c002',
'          else ''Wrong column seq''',
'        end c002,',
'        rownum rn,',
'        count(*) over (partition by 1) as cnt',
'      from (',
'        select  ',
'          c001, c002',
'        from',
'          apex_collections',
'        where',
'          collection_name = v_collection_name',
'        order by',
'          decode(v_column_seq_sort, 1, c002) asc,',
'          decode(v_column_seq_sort, 2, c001) asc,',
'          decode(v_column_seq_sort, 3, c002) desc,',
'          decode(v_column_seq_sort, 4, c001) desc,',
'          decode(v_column_seq_sort, 5, to_number(c001)) asc,',
'          decode(v_column_seq_sort, 6, to_number(c001)) desc,',
'          decode(v_column_seq_sort, 7, to_number(c002)) asc,',
'          decode(v_column_seq_sort, 8, to_number(c002)) desc',
'      )',
'    ) loop',
'',
'      v_temp_display_value := trim_json( i.c002 );',
'      v_temp_return_value := trim_json( i.c001 );',
'      ',
'      if i.rn = i.cnt then',
'        htp.p(''{"r":"''|| v_temp_return_value  ||''","d":"''|| v_temp_display_value ||''","i":''||(i.rn +v_rownum_plus)||''}'');',
'      else',
'        htp.p(''{"r":"''|| v_temp_return_value  ||''","d":"''|| v_temp_display_value ||''","i":''||(i.rn + v_rownum_plus)||''},'');',
'      end if;',
'',
'      v_dict_length := v_dict_length +1;      ',
'    end loop;   ',
'    ',
'  elsif v_mode = ''getMask'' then',
'',
'    begin',
'      select',
'        case ',
'          when v_column_seq in (1,3,6,7,8,14,17,18,19,20,25,26) then c001',
'          when v_column_seq in (2,4,10,11,12,16,21,22,23,24,27,28) then c002',
'          else ''Wrong column seq''',
'        end return_value,',
'        case ',
'          when v_column_seq in (2,3,10,11,12,14,21,22,23,24,25,26) then c001',
'          when v_column_seq in (1,4,6,7,8,16,17,18,19,20,27,28) then c002',
'          else ''Wrong column seq''',
'        end mask',
'      into',
'        v_get_return_value,',
'        v_get_mask',
'      from',
'        apex_collections',
'      where',
'        rownum = 1',
'        and collection_name = v_collection_name',
'        and (',
'          upper(c001) = upper(v_search)',
'          OR upper(c002) = upper(v_search)',
'        );',
'      ',
'      htp.p(''{"r": "''||trim_json(v_get_return_value)||''","d": "''||trim_json(v_get_mask)||''","index": ''||1||'', "matched": true}'');',
'',
'    exception',
'      when no_data_found then',
'        htp.p(''{"r": "''||trim_json(v_search) ||''","d": "''||trim_json(v_search)||''","index": ''||1||'', "matched": false}'');',
'      when others then',
'        e_temp_msg := ''Error durring retrieving plugin mask: \n''||SQLERRM;',
'        raise e_temp;',
'    end;',
'    ',
'  end if;',
'  ',
'  v_time_end := current_time_ms();',
'  v_time_diff := v_time_end - v_time_start;',
'  ',
'  htp.p(''',
'      ],',
'      "time": {',
'        "ms": "''     ||replace(to_char( v_time_diff,          ''999G999G999G999G990D0000''),'' '', '''')||''",',
'        "seconds": "''||replace(to_char((v_time_diff/1000),    ''999G999G999G999G990D0000''),'' '', '''')||''",',
'        "minutes": "''||replace(to_char((v_time_diff/1000/60), ''999G999G999G999G990D0000''),'' '', '''')||''"',
'      },',
'      "autofilter": {',
'        "searchMultiple": ''||v_autofilter_multiple||''',
'      },',
'      "plugin": {',
'        "plugin_id": "''||p_item.id||''",',
'        "item_id": "''||p_item.name||''",',
'        "plain_label": "''||p_item.plain_label||''",',
'        "column_seq": "''|| v_column_seq ||''",',
'        "v_filter_columns": ''|| v_filter_columns ||'',',
'        "v_prompt_like": ''|| v_prompt_like ||''',
'      },',
'      "input": {',
'        "mode": "''||trim_json(v_mode)||''",',
'        "p_search": "''||trim_json(v_search)||''"',
'      }, ',
'      "error": {',
'        "error": 0,',
'        "mode": "''|| v_mode ||''",',
'        "SQLERRM": "",',
'        "func_name": "apex_ajax_pal"',
'      }',
'    }',
'  '');  ',
'  ',
'  return null;',
'  ',
'exception ',
'  when e_temp then',
'    htp.p(''',
'      {',
'        "values": [],',
'        "plugin": {',
'          "plugin_id": "''||p_item.id||''",',
'          "item_id": "''||p_item.name||''",',
'          "plain_label": "''||p_item.plain_label||''"',
'        },',
'        "input": {',
'          "mode": "''||htf.escape_sc(v_mode)||''",',
'          "p_search": "''||trim_json(v_search)||''"',
'        }, ',
'        "error": {',
'          "error": 1,',
'          "mode": "''|| v_mode ||''",',
'          "SQLERRM": "''||trim_json( e_temp_msg )||''",',
'          "func_name": "apex_ajax_pal"',
'        }',
'      }',
'    '');  ',
'    return null;',
'    ',
'  when others then',
'    htp.p(''',
'        ],',
'        "plugin": {',
'          "plugin_id": "''||p_item.id||''",',
'          "item_id": "''||p_item.name||''",',
'          "plain_label": "''||p_item.plain_label||''"',
'        },',
'        "input": {',
'          "mode": "''||trim_json(v_mode)||''",',
'          "p_search": "''||trim_json(v_search)||''"',
'        }, ',
'        "error": {',
'          "error": 1,',
'          "mode": "''|| v_mode ||''",',
'          "SQLERRM": "''||trim_json(SQLERRM )||''",',
'          "func_name": "apex_ajax_pal"',
'        }',
'      }    ',
'    '');  ',
'    return null;',
'end apex_ajax_pal;',
'     '))
,p_render_function=>'render_pal'
,p_ajax_function=>'apex_ajax_pal'
,p_standard_attributes=>'VISIBLE:SESSION_STATE:READONLY:QUICKPICK:SOURCE:ELEMENT:WIDTH:ELEMENT_OPTION:LOV:LOV_REQUIRED:LOV_DISPLAY_NULL:CASCADING_LOV'
,p_sql_min_column_count=>2
,p_sql_max_column_count=>2
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'2.2.1.1'
,p_about_url=>'http://apex.pretius.com'
,p_files_version=>6
);
end;
/
begin
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(149091318282474997)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Autocomplete available'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'<p>If set to <strong>Yes</strong>, the plugin instance supports displaying <span style="color: rgb(0,0,0);">autocomplete</span> results while typing</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(149091823477476468)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'POPUP DIALOG available'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'<p><span style="color: rgb(0,0,0);">If set to <strong>Yes</strong>, <span> the plugin instance </span>supports displaying all values from collection in popup dialog.</span></p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(52811798432521171)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'POPUP DIALOG Multiple selection'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Yes -  Plugin instance supports selecting multiple values in popup dialog',
'Yes with multiple display - Plugin instance supports selecting multiple values in popup dialog  and returns display values sepereted with SEPARATOR to textbox'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(52812636590522215)
,p_plugin_attribute_id=>wwv_flow_api.id(52811798432521171)
,p_display_sequence=>10
,p_display_value=>'Yes'
,p_return_value=>'Y'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(52813086567523127)
,p_plugin_attribute_id=>wwv_flow_api.id(52811798432521171)
,p_display_sequence=>20
,p_display_value=>'No'
,p_return_value=>'N'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(52813450231524028)
,p_plugin_attribute_id=>wwv_flow_api.id(52811798432521171)
,p_display_sequence=>30
,p_display_value=>'Yes with multiple display'
,p_return_value=>'MD'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(149441630281988773)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>12
,p_prompt=>'Autocomplete search cases'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'2'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(149091318282474997)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  This attribute Defines the method of filtering data in a autocomplete. Table below describes available values.',
'</p>',
'',
'<table cellpadding="2" cellspacing="10">',
'<tbody>',
'  <tr>',
'    <th>',
'      Option',
'    </th>',
'    <th colspan="1">',
'      Description',
'    </th>',
'    <th colspan="1">',
'      <p>',
'        Special characters',
'      </p>',
'      <p style="text-align: center;">',
'        "%", "_"',
'      </p>',
'    </th>',
'  </tr>',
'  <tr>',
'    <td valign="top">',
'      %search_string',
'    </td>',
'    <td valign="top" colspan="1">',
'      Left side LIKE',
'    </td>',
'    <td valign="top" colspan="1">',
'      Works',
'    </td>',
'  </tr>',
'  <tr>',
'    <td valign="top">',
'      search_string%',
'    </td>',
'    <td valign="top" colspan="1">',
'      Right side LIKE',
'    </td>',
'    <td valign="top" colspan="1">',
'      Works',
'    </td>',
'  </tr>',
'  <tr>',
'    <td valign="top">',
'      %search_string%',
'    </td>',
'    <td valign="top" colspan="1">',
'      Both sides LIKE',
'    </td>',
'    <td valign="top" colspan="1">',
'      Works',
'    </td>',
'  </tr>',
'  <tr>',
'    <td valign="top" colspan="1">',
'      %search_string [%]',
'    </td>',
'    <td valign="top" colspan="1">',
'      Left side LIKE',
'    </td>',
'    <td valign="top" colspan="1">',
'      No effect',
'    </td>',
'  </tr>',
'  <tr>',
'    <td valign="top" colspan="1">',
'      search_string% [%]',
'    </td>',
'    <td valign="top" colspan="1">',
'      Right side LIKE',
'    </td>',
'    <td valign="top" colspan="1">',
'      No effect',
'    </td>',
'  </tr>',
'  <tr>',
'    <td valign="top" colspan="1">',
'      %search_string% [%]',
'    </td>',
'    <td valign="top" colspan="1">',
'      Both sides LIKE',
'    </td>',
'    <td valign="top" colspan="1">',
'      No effect',
'    </td>',
'  </tr>',
'</tbody>',
'</table>',
''))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(52004404878176081)
,p_plugin_attribute_id=>wwv_flow_api.id(149441630281988773)
,p_display_sequence=>1
,p_display_value=>'Search string'
,p_return_value=>'7'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(149442334783990086)
,p_plugin_attribute_id=>wwv_flow_api.id(149441630281988773)
,p_display_sequence=>10
,p_display_value=>'%search_string'
,p_return_value=>'1'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(149442709633992289)
,p_plugin_attribute_id=>wwv_flow_api.id(149441630281988773)
,p_display_sequence=>20
,p_display_value=>'search_string%'
,p_return_value=>'2'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(149443111711992956)
,p_plugin_attribute_id=>wwv_flow_api.id(149441630281988773)
,p_display_sequence=>30
,p_display_value=>'%search_string%'
,p_return_value=>'3'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(52004807302176830)
,p_plugin_attribute_id=>wwv_flow_api.id(149441630281988773)
,p_display_sequence=>35
,p_display_value=>'search string [%]'
,p_return_value=>'8'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(62408804332806243)
,p_plugin_attribute_id=>wwv_flow_api.id(149441630281988773)
,p_display_sequence=>40
,p_display_value=>'%search_string [%]'
,p_return_value=>'4'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(62409206756806961)
,p_plugin_attribute_id=>wwv_flow_api.id(149441630281988773)
,p_display_sequence=>50
,p_display_value=>'search_string% [%]'
,p_return_value=>'5'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(62409609526807698)
,p_plugin_attribute_id=>wwv_flow_api.id(149441630281988773)
,p_display_sequence=>60
,p_display_value=>'%search_string% [%]'
,p_return_value=>'6'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(149308125529808033)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Values separator'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>':'
,p_display_length=>5
,p_max_length=>1
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  This attribute specify what character will be used to delimit multiple values.',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(62299994289453190)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Debounce time in ms'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'300'
,p_display_length=>10
,p_max_length=>4
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'Time in milliseconds after which autocomplete be triggered.',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(149096423046495268)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>35
,p_prompt=>'Enable paste event'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  If set to <strong>YES</strong>, the plugin instance</span> supports paste event.',
'</p>',
'<p>    ',
'  <strong>Important note</strong></br>',
'  After paste event, values are not being matched automatically with collection data! Values being pasted are setted as the plugin instance value. Only after opening dialog mode and confirming matched values the proper values are being set to item.',
'</p>  '))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(149096929626497177)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>11
,p_prompt=>'Autocomplete filter by column'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'1'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(149091318282474997)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'   This attrubute defines how data will be filtered. The condition to match is defined in "autocomplete search cases" attribute.',
'</p>',
'<table cellspacing="2" cellpadding="10">',
'<tbody>',
'<tr>',
'  <td valign="top" colspan="1">',
'    Value',
'  </td>',
'  <td valign="top" colspan="1">',
'    Description',
'  </td>',
'</tr>',
'<tr>',
'  <td valign="top" colspan="1">',
'    <strong>Column_1</strong>',
'  </td>',
'  <td valign="top" colspan="1">',
'    By first column in plugin data source. If APEX LOV used as data source it will be "return" column from LOV.',
'  </td>',
'</tr>',
'<tr>',
'  <td valign="top">',
'    <strong>Column_2&nbsp;</strong>',
'  </td>',
'  <td valign="top">',
'    By second column in plugin data source. If APEX LOV used as data source it will be "display" column from LOV.',
'  </td>',
'</tr>',
'<tr>',
'  <td valign="top" colspan="1">',
'    <strong>Both</strong>',
'  </td>',
'  <td valign="top" colspan="1">',
'    By borh columns in plugin data source or APEX LOV. ',
'  </td>',
'</tr>',
'</tbody>',
'</table>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(149097431357497662)
,p_plugin_attribute_id=>wwv_flow_api.id(149096929626497177)
,p_display_sequence=>10
,p_display_value=>'Column_1'
,p_return_value=>'1'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(149097832743498128)
,p_plugin_attribute_id=>wwv_flow_api.id(149096929626497177)
,p_display_sequence=>20
,p_display_value=>'Column_2'
,p_return_value=>'2'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(149098234474498568)
,p_plugin_attribute_id=>wwv_flow_api.id(149096929626497177)
,p_display_sequence=>30
,p_display_value=>'Both'
,p_return_value=>'3'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(149098710017501039)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Column sequence'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'1'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  This attribute defines which column is treated as return and which as display column in data source. </br>',
'</p>',
'<p>',
'  Example SQL (might be source of APEX LOV):',
'  <pre style="background-color: #F2F2F2;padding:5px;">',
'    select d, r from emp</pre>',
'  Column <b>d</b> is represented by <b>Column_1</b> string in this attribute.</br>',
'  Column <b>r</b> is represented by <b>Column_2</b> string in this attribute.</br>',
'</p>',
'<p>',
'  <ul>',
'    <li style="padding: 5px;">',
'      <b>Column_1, Column_2</b></br>',
'      The return value will be value from column <b>d</b></br>',
'      The label will be value from column <b>r</b> ',
'    </li>',
'    <li style="padding: 5px;">',
'      <b>Column_2, Column_1</b></br>',
'      The return value will be value from column <b>r</b></br>',
'      The label will be value from column <b>d</b> ',
'      ',
'    </li>',
'    <li style="padding: 5px;">',
'      <b>Column_1, Column_1</b></br>',
'      The return value will be value from column <b>d</b></br>',
'      The label will be value from column <b>d</b> ',
'    </li>',
'    <li style="padding: 5px;">',
'      <b>Column_2, Column_2</b></br>',
'      The return value will be value from column <b>r</b></br>',
'      The label will be value from column <b>r</b> ',
'    </li>    ',
'    ',
'  </ul>',
'</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(149100016251502851)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>200
,p_display_value=>'Column_1, Column_1 | Column_1 asc'
,p_return_value=>'3'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47347877283357002)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>210
,p_display_value=>'Column_1, Column_1 | Column_1 desc'
,p_return_value=>'14'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47426396980790247)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>220
,p_display_value=>'Column_1, Column_1 | Column_1 asc (number)'
,p_return_value=>'25'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47426766289790792)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>230
,p_display_value=>'Column_1, Column_1 | Column_1 desc (number)'
,p_return_value=>'26'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(149100418329503454)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>240
,p_display_value=>'Column_2, Column_2 | Column_2 asc'
,p_return_value=>'4'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47348282131358357)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>250
,p_display_value=>'Column_2, Column_2 | Column_2 desc'
,p_return_value=>'16'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47427169060791634)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>260
,p_display_value=>'Column_2, Column_2 | Column_2 asc (number)'
,p_return_value=>'27'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47428877371794066)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>270
,p_display_value=>'Column_2, Column_2 | Column_2 desc (number) '
,p_return_value=>'28'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47329273080327380)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>280
,p_display_value=>'Column_1, Column_2 | Column_1 asc'
,p_return_value=>'7'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47329677236328624)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>290
,p_display_value=>'Column_1, Column_2 | Column_1 desc'
,p_return_value=>'8'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47403984692474406)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>300
,p_display_value=>'Column_1, Column_2 | Column_1 asc (number)'
,p_return_value=>'17'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47415765578639278)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>310
,p_display_value=>'Column_1, Column_2 | Column_1 desc (number)'
,p_return_value=>'18'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(149099211403501460)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>320
,p_display_value=>'Column_1, Column_2 | Column_2 asc '
,p_return_value=>'1'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47328866500325513)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>330
,p_display_value=>'Column_1, Column_2 | Column_2 desc'
,p_return_value=>'6'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47423981396785773)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>340
,p_display_value=>'Column_1, Column_2 | Column_2 asc (number)'
,p_return_value=>'19'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47424384166786573)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>350
,p_display_value=>'Column_1, Column_2 | Column_2 desc (number)'
,p_return_value=>'20'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(149099614173502208)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>360
,p_display_value=>'Column_2, Column_1 | Column_1 asc'
,p_return_value=>'2'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47339997799343973)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>370
,p_display_value=>'Column_2, Column_1 | Column_1 desc'
,p_return_value=>'10'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47424786590787201)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>380
,p_display_value=>'Column_2, Column_1 | Column_1 asc (number)'
,p_return_value=>'21'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47425188668787864)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>390
,p_display_value=>'Column_2, Column_1 | Column_1 desc (number)'
,p_return_value=>'22'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47340370918345678)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>400
,p_display_value=>'Column_2, Column_1 | Column_2 asc'
,p_return_value=>'11'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47340772996346324)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>410
,p_display_value=>'Column_2, Column_1 | Column_2 desc'
,p_return_value=>'12'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47425593516789197)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>420
,p_display_value=>'Column_2, Column_1 | Column_2 asc (number)'
,p_return_value=>'23'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47425995248789767)
,p_plugin_attribute_id=>wwv_flow_api.id(149098710017501039)
,p_display_sequence=>430
,p_display_value=>'Column_2, Column_1 | Column_2 desc (number)'
,p_return_value=>'24'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(153489109231463196)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Max length for multiple values'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'32000'
,p_display_length=>5
,p_max_length=>5
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  Specify how many characters can be passed to the plugin instance. If computed length of selected or pasted values exceeds limit, plugin will display confirm dialog box to choose what action should be applied.',
'</p>',
'<p>',
'<strong>Important note: </strong></br>',
'The length of pasted value might be different from computed length of returned string in popup mode. It is because of possible difference in length of return and display value - depends on whether they were pasted values of return or display column.',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(149101831142507095)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Show return column'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  If set to <strong >YES</strong>, the plugin instance supports displaying "return value" in autocomplete and popup dialog.',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(149102336337508579)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Submit when enter pressed'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  If set to <strong >YES, </strong>APEX form is submitted after pressing Enter key within the plugin instance.',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(149102810841510754)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Show APEX processing'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(149102336337508579)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'<p>If set to YES then after submitting APEX form (with Enter key) the APEX submit indicator is visible.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(150217322375904371)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>150
,p_prompt=>'Recreate collection on page load'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  If set to <strong>YES</strong> data source will be reloaded into collection each time page ends loading.',
'</p>'))
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(150760626052613335)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_name=>'plugin_init_retrieve_mask'
,p_display_name=>'after mask retrieved'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(47058597050573113)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_name=>'plugin_value_changed'
,p_display_name=>'value changed'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A6170657820352A2F0D0A692E70616C76325F69636F6E4C6F61646572207B0D0A20206261636B67726F756E642D696D6167653A2075726C28616A61782D6C6F616465722E676966293B0D0A7D0D0A0D0A692E70616C76325F69636F6E506173746564';
wwv_flow_api.g_varchar2_table(2) := '207B0D0A20206261636B67726F756E642D696D6167653A2075726C287061737465642D69636F6E2E676966293B0D0A7D0D0A0D0A2E70616C76325F69636F6E54726967676572207B0D0A20206261636B67726F756E642D696D6167653A2075726C287061';
wwv_flow_api.g_varchar2_table(3) := '6C5F7374617475732E676966293B0D0A7D0D0A0D0A2E70616C76325F706F707570416A6178436F6E7461696E65722074643A66697273742D6368696C64207B0D0A202070616464696E672D6C6566743A20313370783B0D0A7D0D0A2E70616C76325F6469';
wwv_flow_api.g_varchar2_table(4) := '7653686F7753656C656374656420696E7075745B747970653D636865636B626F785D2C0D0A2E70616C76325F706F707570416A6178436F6E7461696E657220696E7075745B747970653D636865636B626F785D2C0D0A2E70616C76325F706F707570416A';
wwv_flow_api.g_varchar2_table(5) := '6178436F6E7461696E657220696E7075745B747970653D726164696F5D207B0D0A20206D617267696E2D746F703A3570783B0D0A7D0D0A0D0A2E70616C76325F7461626C65486561646572436F6E7461696E6572207B0D0A20206261636B67726F756E64';
wwv_flow_api.g_varchar2_table(6) := '3A20234646464646463B0D0A202070616464696E673A2036707820313270782021696D706F7274616E743B0D0A7D0D0A0D0A2E70616C76325F706F7075704F75746572436F6E7461696E6572202E75692D6469616C6F672D627574746F6E70616E65207B';
wwv_flow_api.g_varchar2_table(7) := '0D0A20206261636B67726F756E643A20234646464646463B0D0A2020626F726465722D746F703A2031707820736F6C696420236161612021696D706F7274616E743B0D0A7D0D0A0D0A2E70616C76325F706F7075704F75746572436F6E7461696E657220';
wwv_flow_api.g_varchar2_table(8) := '2E75692D6469616C6F672D627574746F6E70616E6520627574746F6E203E207370616E207B0D0A202070616464696E673A20347078203670783B0D0A7D0D0A0D0A2E70616C76325F706F707570416A6178436F6E7461696E65722074723A6E74682D6368';
wwv_flow_api.g_varchar2_table(9) := '696C64286576656E29207B0D0A20206261636B67726F756E643A20236663666366633B0D0A7D0D0A0D0A2E70616C76325F64697653686F7753656C6563746564207B0D0A202070616464696E673A203070782021696D706F7274616E743B0D0A7D0D0A2E';
wwv_flow_api.g_varchar2_table(10) := '70616C76325F64697653656C656374416C6C206C6162656C2C0D0A2E70616C76325F64697653686F7753656C6563746564206C6162656C207B0D0A2020746F703A202D3270783B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A20207061';
wwv_flow_api.g_varchar2_table(11) := '6464696E672D6C6566743A203870783B0D0A7D0D0A0D0A2E736561726368626F78446976207B0D0A2020202070616464696E673A20367078203070782031327078203070783B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(39140145951661057)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'style5.css'
,p_mime_type=>'text/css'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A6170657820342A2F0D0A692E70616C76325F69636F6E4C6F61646572207B0D0A20206261636B67726F756E642D696D6167653A2075726C28616A61782D6C6F616465722E676966293B0D0A7D0D0A0D0A692E70616C76325F69636F6E506173746564';
wwv_flow_api.g_varchar2_table(2) := '207B0D0A20206261636B67726F756E642D696D6167653A2075726C287061737465642D69636F6E2E676966293B0D0A7D0D0A0D0A2E70616C76325F69636F6E54726967676572207B0D0A20206261636B67726F756E642D696D6167653A2075726C287061';
wwv_flow_api.g_varchar2_table(3) := '6C5F7374617475732E676966293B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(47317393912135748)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'style4.css'
,p_mime_type=>'text/css'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E70616C76325F706F7075704F75746572436F6E7461696E6572202E75692D69636F6E2D636C6F7365746869636B207B0D0A202070616464696E673A203070783B0D0A7D0D0A0D0A2E70616C76325F64697653686F7753656C6563746564207B0D0A2020';
wwv_flow_api.g_varchar2_table(2) := '666C6F61743A206C6566743B0D0A202070616464696E673A203670782030707820307078203970783B0D0A7D0D0A0D0A2E736561726368626F78446976207B0D0A202070616464696E673A203670782030707820367078203070783B0D0A7D0D0A0D0A2E';
wwv_flow_api.g_varchar2_table(3) := '70616C76325F7461626C65486561646572436F6E7461696E6572207B0D0A202070616464696E673A20367078203070782036707820313370783B0D0A2020626F726465722D626F74746F6D3A2031707820736F6C696420236161613B0D0A7D0D0A0D0A2E';
wwv_flow_api.g_varchar2_table(4) := '70616C76325F706F7075704F75746572436F6E7461696E6572202A7B0D0A20202020666F6E742D73697A653A20313270783B0D0A0D0A7D0D0A0D0A0D0A692E70616C76325F69636F6E4C6F61646572207B0D0A2020646973706C61793A20696E6C696E65';
wwv_flow_api.g_varchar2_table(5) := '2D626C6F636B3B0D0A202077696474683A20313670783B0D0A20206865696768743A20313670783B0D0A7D0D0A0D0A692E70616C76325F69636F6E506173746564207B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A2020776964';
wwv_flow_api.g_varchar2_table(6) := '74683A20313770783B0D0A20206865696768743A20313470783B0D0A2020637572736F723A20706F696E7465723B0D0A7D0D0A0D0A2E70616C76325F69636F6E54726967676572207B0D0A202077696474683A20313670783B0D0A20206865696768743A';
wwv_flow_api.g_varchar2_table(7) := '20313670783B0D0A20206261636B67726F756E642D7265706561743A207265706561742D793B0D0A20206261636B67726F756E642D706F736974696F6E3A20307078203070783B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A20';
wwv_flow_api.g_varchar2_table(8) := '20637572736F723A20706F696E7465723B0D0A7D0D0A0D0A0D0A2E70616C76325F69636F6E48696464656E2C0D0A2E70616C76325F69636F6E547269676765722E70616C76325F69636F6E48696464656E2C0D0A692E70616C76325F69636F6E4C6F6164';
wwv_flow_api.g_varchar2_table(9) := '65722E70616C76325F69636F6E48696464656E2C0D0A692E70616C76325F69636F6E5061737465642E70616C76325F69636F6E48696464656E207B0D0A2020646973706C61793A206E6F6E653B0D0A7D0D0A0D0A2370616C76325F70726F6D7074416A61';
wwv_flow_api.g_varchar2_table(10) := '78436F6E7461696E6572207B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20207A2D696E6465783A2039393939393B0D0A20206261636B67726F756E643A2077686974653B0D0A2020626F726465723A2031707820736F6C6964207369';
wwv_flow_api.g_varchar2_table(11) := '6C7665723B0D0A20206F766572666C6F772D793A207363726F6C6C3B0D0A20200D0A7D0D0A2370616C76325F70726F6D7074416A6178436F6E7461696E6572207370616E2E6E6F2D646174612D666F756E64207B0D0A202070616464696E673A20357078';
wwv_flow_api.g_varchar2_table(12) := '3B0D0A202077686974652D73706163653A206E6F777261703B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A7D0D0A0D0A2370616C76325F70726F6D7074416A6178436F6E7461696E657220646976207B0D0A20206D617267696E';
wwv_flow_api.g_varchar2_table(13) := '3A20303B0D0A20206261636B67726F756E643A2077686974653B0D0A7D0D0A2370616C76325F70726F6D7074416A6178436F6E7461696E6572207461626C65207B0D0A2020626F726465722D72696768743A2031707820736F6C69642073696C7665723B';
wwv_flow_api.g_varchar2_table(14) := '0D0A7D0D0A0D0A2370616C76325F70726F6D7074416A6178436F6E7461696E65722074687B0D0A2020666F6E742D73697A653A20313070783B0D0A20206C696E652D6865696768743A20313470783B0D0A7D0D0A2370616C76325F70726F6D7074416A61';
wwv_flow_api.g_varchar2_table(15) := '78436F6E7461696E6572207464207B0D0A2020666F6E742D73697A653A20313270783B0D0A20206C696E652D6865696768743A20313470783B0D0A7D0D0A0D0A2370616C76325F70726F6D7074416A6178436F6E7461696E65722074642C0D0A2370616C';
wwv_flow_api.g_varchar2_table(16) := '76325F70726F6D7074416A6178436F6E7461696E65722074687B0D0A202070616464696E673A2035707820313070783B0D0A202077686974652D73706163653A206E6F777261703B0D0A7D0D0A2370616C76325F70726F6D7074416A6178436F6E746169';
wwv_flow_api.g_varchar2_table(17) := '6E6572207472207B0D0A2020637572736F723A20706F696E7465723B0D0A20200D0A7D0D0A0D0A2370616C76325F70726F6D7074416A6178436F6E7461696E65722074722074647B0D0A2020626F726465722D626F74746F6D3A2031707820736F6C6964';
wwv_flow_api.g_varchar2_table(18) := '2073696C7665723B0D0A7D0D0A0D0A2370616C76325F70726F6D7074416A6178436F6E7461696E65722074723A6E74682D6368696C64286F6464297B0D0A20206261636B67726F756E643A20234634463446343B0D0A7D0D0A0D0A0D0A2370616C76325F';
wwv_flow_api.g_varchar2_table(19) := '70726F6D7074416A6178436F6E7461696E65722074722E70616C76325F70726F6D70744974656D53656C65637465642C0D0A2370616C76325F70726F6D7074416A6178436F6E7461696E65722074722E686F766572207B0D0A0D0A20206261636B67726F';
wwv_flow_api.g_varchar2_table(20) := '756E643A20234646464643373B0D0A7D0D0A0D0A0D0A0D0A0D0A0D0A2E70616C76325F69636F6E547269676765722E70616C76325F69636F6E53696E676C6520207B0D0A20206261636B67726F756E642D706F736974696F6E3A20307078202D31367078';
wwv_flow_api.g_varchar2_table(21) := '3B0D0A7D0D0A0D0A2E70616C76325F69636F6E547269676765722E70616C76325F69636F6E53696E676C652E72656420207B0D0A20206261636B67726F756E642D706F736974696F6E3A20307078202D343870783B0D0A7D0D0A0D0A2E70616C76325F69';
wwv_flow_api.g_varchar2_table(22) := '636F6E547269676765722E70616C76325F69636F6E53696E676C652E677265656E20207B0D0A20206261636B67726F756E642D706F736974696F6E3A20307078202D383070783B0D0A7D0D0A0D0A0D0A2E70616C76325F69636F6E547269676765722E70';
wwv_flow_api.g_varchar2_table(23) := '616C76325F69636F6E4D756C7469706C6520207B0D0A20206261636B67726F756E642D706F736974696F6E3A20307078202D333270783B0D0A7D0D0A0D0A2E70616C76325F69636F6E547269676765722E70616C76325F69636F6E4D756C7469706C652E';
wwv_flow_api.g_varchar2_table(24) := '72656420207B0D0A20206261636B67726F756E642D706F736974696F6E3A20307078202D363470783B0D0A7D0D0A0D0A2E70616C76325F69636F6E547269676765722E70616C76325F69636F6E4D756C7469706C652E677265656E20207B0D0A20206261';
wwv_flow_api.g_varchar2_table(25) := '636B67726F756E642D706F736974696F6E3A20307078202D393670783B0D0A7D0D0A0D0A0D0A2E70616C76325F706F707570416A6178436F6E7461696E6572207B0D0A20206D61782D6865696768743A2035303070783B0D0A7D0D0A0D0A2E70616C7632';
wwv_flow_api.g_varchar2_table(26) := '5F706F707570416A6178436F6E7461696E6572207461626C65207B0D0A202077696474683A20313030253B0D0A2020746578742D616C69676E3A206C6566743B0D0A7D0D0A0D0A2E70616C76325F706F707570416A6178436F6E7461696E65722074723A';
wwv_flow_api.g_varchar2_table(27) := '6E74682D6368696C64286F646429207B0D0A20206261636B67726F756E643A20234634463446343B0D0A7D0D0A0D0A2E70616C76325F706F707570416A6178436F6E7461696E65722074722E686F766572207B0D0A20206261636B67726F756E643A2023';
wwv_flow_api.g_varchar2_table(28) := '4646464643373B0D0A7D0D0A0D0A0D0A2E70616C76325F706F707570416A6178436F6E7461696E65722074647B0D0A202070616464696E673A203570783B0D0A7D0D0A0D0A2E70616C76325F706F707570416A6178436F6E7461696E6572206C6162656C';
wwv_flow_api.g_varchar2_table(29) := '207B0D0A2020637572736F723A20706F696E7465723B0D0A2020646973706C61793A20626C6F636B3B0D0A20206C696E652D6865696768743A20313470783B0D0A2020666F6E742D73697A653A313270783B0D0A2020666F6E742D7765696768743A206E';
wwv_flow_api.g_varchar2_table(30) := '6F726D616C3B0D0A20200D0A7D0D0A0D0A0D0A0D0A2E70616C76325F706F707570416A6178436F6E7461696E657220696E707574207B0D0A20206D617267696E3A3070783B0D0A202070616464696E673A3070783B0D0A20206865696768743A20617574';
wwv_flow_api.g_varchar2_table(31) := '6F3B0D0A7D0D0A0D0A2E70616C76325F706F707570536561726368436F6E7461696E6572207B0D0A20206261636B67726F756E643A2077686974653B0D0A7D0D0A0D0A2E70616C76325F706F707570536561726368436F6E7461696E657220696E707574';
wwv_flow_api.g_varchar2_table(32) := '207B0D0A202070616464696E673A203270783B0D0A7D0D0A0D0A2E70616C76325F706F707570536561726368526573756C7473207B0D0A2020746578742D616C69676E3A2063656E7465723B0D0A7D0D0A0D0A0D0A2E70616C76325F706F707570536561';
wwv_flow_api.g_varchar2_table(33) := '726368426F782C0D0A2E70616C76325F706F707570536561726368526573756C7473207B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A202070616464696E673A20313070783B0D0A7D0D0A0D0A2E70616C76325F706F70757053';
wwv_flow_api.g_varchar2_table(34) := '6561726368526573756C74732061207B0D0A2020637572736F723A20706F696E7465723B0D0A2020636F6C6F723A20626C75653B0D0A20206D617267696E2D6C6566743A20313070783B0D0A2020746578742D6465636F726174696F6E3A206E6F6E653B';
wwv_flow_api.g_varchar2_table(35) := '0D0A7D0D0A0D0A2E70616C76325F706F707570536561726368526573756C747320613A686F76657220207B0D0A2020636F6C6F723A20626C61636B3B0D0A7D0D0A0D0A2F2A0D0A2E75692D6469616C6F67202E75692D6469616C6F672D7469746C656261';
wwv_flow_api.g_varchar2_table(36) := '722D636C6F7365207370616E7B0D0A20206D617267696E3A2D3870782030707820307078202D3870783B0D0A7D0D0A0D0A2E75692D69636F6E2C202E75692D7769646765742D636F6E74656E74202E75692D69636F6E207B0D0A2020646973706C61793A';
wwv_flow_api.g_varchar2_table(37) := '20696E6C696E652D626C6F636B3B0D0A2020746F703A203370783B0D0A2020706F736974696F6E3A2072656C61746976653B20200D0A20206D617267696E2D72696768743A203570783B0D0A7D0D0A2A2F0D0A0D0A2E736561726368626F78446976202E';
wwv_flow_api.g_varchar2_table(38) := '75692D69636F6E2C202E736561726368626F78446976202E75692D7769646765742D636F6E74656E74202E75692D69636F6E207B0D0A2020646973706C61793A20696E6C696E652D626C6F636B3B0D0A2020746F703A203370783B0D0A2020706F736974';
wwv_flow_api.g_varchar2_table(39) := '696F6E3A2072656C61746976653B20200D0A20206D617267696E2D72696768743A203570783B0D0A7D0D0A0D0A2E70616C76325F706C7567696E436F6E7461696E6572207B0D0A2020706F736974696F6E3A72656C61746976653B0D0A20207768697465';
wwv_flow_api.g_varchar2_table(40) := '2D73706163653A6E6F777261703B0D0A7D0D0A0D0A2E70616C76325F706C7567696E436F6E7461696E6572202E706F706F766572207B0D0A7D0D0A0D0A2E70616C76325F706C7567696E436F6E7461696E6572202E706F706F7665722068337B0D0A2020';
wwv_flow_api.g_varchar2_table(41) := '666F6E742D73697A653A20313070783B0D0A20206C696E652D6865696768743A313470783B0D0A7D0D0A0D0A0D0A2E70616C76325F706C7567696E436F6E7461696E6572202E706F706F7665722D636F6E74656E74207B0D0A20206F766572666C6F773A';
wwv_flow_api.g_varchar2_table(42) := '206175746F3B0D0A20206D61782D6865696768743A2033303070783B0D0A20200D0A20206D696E2D77696474683A2031353070783B0D0A20206D61782D77696474683A2034303070783B0D0A20200D0A7D0D0A0D0A2E70616C76325F706C7567696E436F';
wwv_flow_api.g_varchar2_table(43) := '6E7461696E6572202E706F706F766572207464207B0D0A2020666F6E742D73697A653A20313270783B0D0A202077686974652D73706163653A206E6F777261703B0D0A202070616464696E673A203370783B0D0A7D0D0A0D0A0D0A2E70616C76325F706C';
wwv_flow_api.g_varchar2_table(44) := '7567696E436F6E7461696E6572202E706F706F7665722074722E70616C76325F74724576656E207B0D0A20206261636B67726F756E643A20234634463446343B0D0A7D0D0A0D0A2E70616C76325F706C7567696E436F6E7461696E6572202E706F706F76';
wwv_flow_api.g_varchar2_table(45) := '65722074722E70616C76325F74724F6464207B0D0A0D0A7D0D0A0D0A2E70616C76325F7061737465644E6F74466F756E64207B0D0A20206261636B67726F756E642D636F6C6F723A20236632646564653B0D0A202070616464696E673A20313570783B0D';
wwv_flow_api.g_varchar2_table(46) := '0A20206D617267696E3A20313570783B0D0A20206F766572666C6F773A206175746F3B0D0A20206D61782D6865696768743A20363070783B0D0A7D0D0A0D0A2E70616C76325F7061737465644E6F74466F756E642070207B0D0A20206D617267696E3A20';
wwv_flow_api.g_varchar2_table(47) := '3070783B0D0A7D0D0A0D0A0D0A2E6572726F725F66756E635F6E616D65207B0D0A2020746578742D7472616E73666F726D3A7570706572636173653B0D0A2020666F6E742D7765696768743A20626F6C643B0D0A7D0D0A0D0A2E70616C76325F6572726F';
wwv_flow_api.g_varchar2_table(48) := '72207461626C65207B0D0A202077686974652D73706163653A206E6F777261703B0D0A7D0D0A0D0A2E70616C76325F6572726F7220707265207B0D0A20206D617267696E3A203070783B0D0A202070616464696E673A203070783B0D0A20200D0A7D0D0A';
wwv_flow_api.g_varchar2_table(49) := '0D0A2E70616C76325F6572726F72207461626C65207464207B0D0A2020766572746963616C2D616C69676E3A20746F703B0D0A7D0D0A0D0A2E70616C76325F706F7075704F75746572436F6E7461696E657220627574746F6E207B0D0A20207061646469';
wwv_flow_api.g_varchar2_table(50) := '6E673A203370783B0D0A7D0D0A0D0A2E70616C76325F706F7075704F75746572436F6E7461696E6572206C6162656C207B0D0A2020666F6E742D7765696768743A206E6F726D616C3B0D0A7D0D0A0D0A2E70616C76325F706F707570416A6178436F6E74';
wwv_flow_api.g_varchar2_table(51) := '61696E6572207461626C652C0D0A2370616C76325F70726F6D7074416A6178436F6E7461696E6572207461626C652C0D0A2E70616C76325F6572726F72207461626C652C0D0A2E70616C76325F706C7567696E436F6E7461696E6572202E706F706F7665';
wwv_flow_api.g_varchar2_table(52) := '72207461626C65207B0D0A20206D617267696E3A203070783B0D0A202077696474683A20313030253B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(47475669126767899)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'style.css'
,p_mime_type=>'text/css'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '537472696E672E70726F746F747970652E7365617263684C696B65203D2066756E6374696F6E282073656172636856616C75652029207B0D0A2020766172200D0A20202020726567657870203D206E756C6C2C0D0A20202020736561726368203D207365';
wwv_flow_api.g_varchar2_table(2) := '6172636856616C75652E746F537472696E6728293B0D0A0D0A2F2A0D0A202069662028207365617263682E696E6465784F66282725272920213D20302029207B0D0A20202020736561726368203D20736561726368202B202725273B0D0A20207D0D0A20';
wwv_flow_api.g_varchar2_table(3) := '202A2F0D0A0D0A20206966202873656172636856616C75652E696E6465784F662827252729203E202D312029207B0D0A20202020736561726368203D207365617263682E7265706C616365282F5C2E2F67692C20275C5C2E27293B0D0A20202020736561';
wwv_flow_api.g_varchar2_table(4) := '726368203D207365617263682E7265706C616365282F5C282F67692C20275C5C2827293B0D0A20202020736561726368203D207365617263682E7265706C616365282F5C292F67692C20275C5C2927293B0D0A20202020736561726368203D2073656172';
wwv_flow_api.g_varchar2_table(5) := '63682E7265706C616365282F5C5B2F67692C20275C5C5B27293B0D0A20202020736561726368203D207365617263682E7265706C616365282F5C5D2F67692C20275C5C5D27293B0D0A20202020736561726368203D207365617263682E7265706C616365';
wwv_flow_api.g_varchar2_table(6) := '282F5C7B2F67692C20275C5C7B27293B0D0A20202020736561726368203D207365617263682E7265706C616365282F5C7D2F67692C20275C5C7D27293B0D0A20202020736561726368203D207365617263682E7265706C616365282F5C3F2F67692C2027';
wwv_flow_api.g_varchar2_table(7) := '5C5C3F27293B0D0A20202020736561726368203D207365617263682E7265706C616365282F5C2B2F67692C20275C5C2B27293B0D0A20202020736561726368203D207365617263682E7265706C616365282F5C2A2F67692C20275C5C2A27293B0D0A2020';
wwv_flow_api.g_varchar2_table(8) := '20200D0A202020202F2F7A616D69656E2025206E61207A726F7A756D69616C65207720250D0A20202020736561726368203D207365617263682E7265706C616365282F252F67692C20272E2A27293B0D0A202020200D0A20202020726567657870203D20';
wwv_flow_api.g_varchar2_table(9) := '6E6577205265674578702820275E272B7365617263682B2724272C2022676922293B0D0A0D0A2020202072657475726E20746869732E736561726368282072656765787020293B0D0A0D0A20207D0D0A2020656C7365207B0D0A2020202072657475726E';
wwv_flow_api.g_varchar2_table(10) := '20746869732E696E6465784F66282073656172636856616C756520293B0D0A20207D0D0A0D0A7D3B0D0A0D0A0D0A7661722069734D534945203D202F2A4063635F6F6E21402A2F66616C73653B0D0A0D0A6A51756572792E62726F77736572203D207B7D';
wwv_flow_api.g_varchar2_table(11) := '3B0D0A6A51756572792E62726F777365722E6D6F7A696C6C61203D202F6D6F7A696C6C612F2E74657374286E6176696761746F722E757365724167656E742E746F4C6F7765724361736528292920262620212F7765626B69742F2E74657374286E617669';
wwv_flow_api.g_varchar2_table(12) := '6761746F722E757365724167656E742E746F4C6F776572436173652829293B0D0A6A51756572792E62726F777365722E7765626B6974203D202F7765626B69742F2E74657374286E6176696761746F722E757365724167656E742E746F4C6F7765724361';
wwv_flow_api.g_varchar2_table(13) := '73652829293B0D0A6A51756572792E62726F777365722E6F70657261203D202F6F706572612F2E74657374286E6176696761746F722E757365724167656E742E746F4C6F776572436173652829293B0D0A6A51756572792E62726F777365722E6D736965';
wwv_flow_api.g_varchar2_table(14) := '203D202F6D7369652F2E74657374286E6176696761746F722E757365724167656E742E746F4C6F776572436173652829293B0D0A0D0A2F2A0D0A202073656C6563746F727320737472696E67730D0A2A2F0D0A0D0A766172200D0A202073656C6563746F';
wwv_flow_api.g_varchar2_table(15) := '725F706C7567696E416A61784572726F72203D202770616C76325F6572726F72272C0D0A20206E61766967617465436F646573203D205B273430272C20273338272C20273337272C20273339272C20273335272C20273336272C2034302C2033382C2033';
wwv_flow_api.g_varchar2_table(16) := '372C2033392C2033352C2033365D2C0D0A0D0A202073656C6563746F725F706F707570436F6E7461696E6572203D202770616C76325F706F707570436F6E7461696E6572272C202F2F706C7567696E50616C32506F707570436F6E7461696E65720D0A20';
wwv_flow_api.g_varchar2_table(17) := '2073656C6563746F725F706F707570416A6178436F6E7461696E6572203D202770616C76325F706F707570416A6178436F6E7461696E6572272C202F2F706C7567696E50616C32506F707570436F6E7461696E6572416A61780D0A202073656C6563746F';
wwv_flow_api.g_varchar2_table(18) := '725F706F7075705365617263684E6F74466F756E64203D202770616C76325F706F7075705365617263684E6F74466F756E64272C202F2F2770616C325F646976536561726368726573756C74734E6F466F756E64272C0D0A202073656C6563746F725F70';
wwv_flow_api.g_varchar2_table(19) := '6F707570536561726368526573756C7473203D202770616C76325F706F707570536561726368526573756C7473272C202F2F2770616C325F646976536561726368726573756C7473272C0D0A202073656C6563746F725F706F707570536561726368436F';
wwv_flow_api.g_varchar2_table(20) := '6E7461696E6572203D202770616C76325F706F707570536561726368436F6E7461696E6572272C202F2F27706C7567696E50616C32506F707570536561726368426172272C0D0A202073656C6563746F725F706F707570466F6F7465725472203D202770';
wwv_flow_api.g_varchar2_table(21) := '616C76325F706F707570466F6F7465725472272C202F2F2770616C325F706F707570466F6F7465725472272C0D0A202073656C6563746F725F706F7075704F75746572436F6E7461696E6572203D202770616C76325F706F7075704F75746572436F6E74';
wwv_flow_api.g_varchar2_table(22) := '61696E6572272C202F2F2770616C325F6D6F64616C436F6E7461696E6572272C0D0A202073656C6563746F725F706F707570536561726368426F78203D202770616C76325F706F707570536561726368426F78272C202F2F2770616C325F646976536561';
wwv_flow_api.g_varchar2_table(23) := '726368426F78272C0D0A0D0A202073656C6563746F725F70726F6D7074416A6178436F6E7461696E6572203D202770616C76325F70726F6D7074416A6178436F6E7461696E6572272C202F2F27706C7567696E50616C32416A6178436F6E7461696E6572';
wwv_flow_api.g_varchar2_table(24) := '272C0D0A0D0A202073656C6563746F725F7061737465644E6F74466F756E64203D202770616C76325F7061737465644E6F74466F756E64272C202F2F2770616C325F7061737465644E6F74466F756E64272C0D0A202073656C6563746F725F706F707570';
wwv_flow_api.g_varchar2_table(25) := '536561726368496E707574203D202770616C76325F706F707570536561726368496E707574272C202F2F27706C7567696E50616C32506F707570536561726368496E707574272C0D0A202073656C6563746F725F706F7075704D617463684E6F74466F75';
wwv_flow_api.g_varchar2_table(26) := '6E64203D202770616C76325F706F7075704D617463684E6F74466F756E64272C202F2F276E6F745F666F756E645F756C272C0D0A0D0A202073656C6563746F725F706C7567696E4D61736B203D202770616C76325F706C7567696E4D61736B272C202F2F';
wwv_flow_api.g_varchar2_table(27) := '27706C7567696E5F70616C325F6D61736B272C0D0A202073656C6563746F725F706C7567696E436F6E7461696E6572203D202770616C76325F706C7567696E436F6E7461696E6572272C202F2F27706C7567696E5F70616C5F32272C0D0A0D0A20207365';
wwv_flow_api.g_varchar2_table(28) := '6C6563746F725F69636F6E506173746564203D202770616C76325F69636F6E506173746564272C202F2F27706C7567696E5F70616C325F706173746564272C0D0A202073656C6563746F725F69636F6E54726967676572203D202770616C76325F69636F';
wwv_flow_api.g_varchar2_table(29) := '6E54726967676572272C202F2F27706C7567696E5F70616C325F6C6F76272C0D0A202073656C6563746F725F69636F6E4C6F61646572203D202770616C76325F69636F6E4C6F61646572272C202F2F27706C7567696E5F70616C325F6C6F61646572272C';
wwv_flow_api.g_varchar2_table(30) := '0D0A202073656C6563746F725F69636F6E53696E676C65203D202770616C76325F69636F6E53696E676C65272C202F2F2773696E676C65272C0D0A0D0A202073656C6563746F725F69636F6E4D756C7469706C65203D202770616C76325F69636F6E4D75';
wwv_flow_api.g_varchar2_table(31) := '6C7469706C65272C202F2F276D756C7469706C65272C0D0A202073656C6563746F725F70726F6D70744974656D53656C6563746564203D202770616C76325F70726F6D70744974656D53656C6563746564272C202F2F2768656C7065725F73656C656374';
wwv_flow_api.g_varchar2_table(32) := '6564272C0D0A0D0A202073656C6563746F725F69636F6E48696464656E203D202770616C76325F69636F6E48696464656E272C202F2F2768696464656E272C0D0A202073656C6563746F725F74724576656E203D202770616C76325F74724576656E272C';
wwv_flow_api.g_varchar2_table(33) := '202F2F276576656E272C0D0A202073656C6563746F725F74724F6464203D202770616C76325F74724F6464273B202F2F276F6464273B0D0A0D0A0D0A6A517565727950414C28646F63756D656E74292E6F6E2827636C69636B272C206E756C6C2C206675';
wwv_flow_api.g_varchar2_table(34) := '6E6374696F6E286576656E74297B20200D0A2020766172200D0A2020202068656C706572446976203D206A517565727950414C2824782873656C6563746F725F70726F6D7074416A6178436F6E7461696E657229292C0D0A20202020696E707574203D20';
wwv_flow_api.g_varchar2_table(35) := '6A517565727950414C282723272B68656C7065724469762E6174747228276974656D27292B275F444953504C415927290D0A20200D0A2020696E7075742E74726967676572282772656D6F766550726F6D707427293B0D0A7D292E6F6E2827636C69636B';
wwv_flow_api.g_varchar2_table(36) := '272C20272E272B73656C6563746F725F69636F6E5061737465642B272C20272B73656C6563746F725F706C7567696E436F6E7461696E65722B27202E706F706F766572272C2066756E6374696F6E286576656E74297B0D0A20206576656E742E73746F70';
wwv_flow_api.g_varchar2_table(37) := '50726F7061676174696F6E28293B0D0A7D292E6F6E2827636C69636B272C202723272B73656C6563746F725F70726F6D7074416A6178436F6E7461696E65722B272074723A6E6F74283A6861732874682929272C2066756E6374696F6E2865297B0D0A20';
wwv_flow_api.g_varchar2_table(38) := '202F2A0D0A20202020476479206B6C696B6E6965636965206E6120656C656D656E74206C69737479207A206175746F66696C7472750D0A20202A2F0D0A0D0A2020766172200D0A2020202073656C66203D20242874686973292C0D0A2020202070617265';
wwv_flow_api.g_varchar2_table(39) := '6E74446976203D2073656C662E706172656E7473282723272B73656C6563746F725F70726F6D7074416A6178436F6E7461696E6572292C0D0A202020206D61736B203D206A517565727950414C28706172656E744469762E6461746128276D61736B2729';
wwv_flow_api.g_varchar2_table(40) := '292C0D0A2020202072203D2073656C662E66696E6428272E72657475726E27292E7465787428292C0D0A2020202076616C756573203D206E756C6C2C0D0A2020202064203D2073656C662E66696E6428272E646973706C617927292E7465787428293B0D';
wwv_flow_api.g_varchar2_table(41) := '0A0D0A2020696620282073656C662E697328272E73656C656374416C6C56616C75657327292029207B0D0A2020202076616C756573203D206A517565727950414C2E6D61702820706172656E744469762E66696E6428272E72657475726E27292C206675';
wwv_flow_api.g_varchar2_table(42) := '6E6374696F6E28656C656D2C20696E646578297B0D0A20202020202072657475726E202428656C656D292E7465787428293B0D0A202020207D293B0D0A0D0A202020206D61736B2E74726967676572282773657456616C756546726F6D50726F6D707427';
wwv_flow_api.g_varchar2_table(43) := '2C200D0A2020202020207B0D0A202020202020202027646973706C61795F76616C7565273A20706172656E744469762E66696E6428272E646973706C617927292E666972737428292E7465787428292C0D0A20202020202020202772657475726E5F7661';
wwv_flow_api.g_varchar2_table(44) := '6C7565273A2076616C7565732E6A6F696E2820706172656E744469762E646174612827736570617261746F72272920290D0A2020202020207D0D0A20202020293B20200D0A0D0A20207D0D0A2020656C7365207B0D0A202020206D61736B2E7472696767';
wwv_flow_api.g_varchar2_table(45) := '6572282773657456616C756546726F6D50726F6D7074272C207B27646973706C61795F76616C7565273A20642C202772657475726E5F76616C7565273A727D293B20200D0A20207D0D0A20200D0A7D292E6F6E2827636C69636B272C202723272B73656C';
wwv_flow_api.g_varchar2_table(46) := '6563746F725F70726F6D7074416A6178436F6E7461696E65722C2066756E6374696F6E286576656E74297B0D0A20206576656E742E73746F7050726F7061676174696F6E28293B0D0A7D292E6F6E28276D6F7573656F766572272C202723272B73656C65';
wwv_flow_api.g_varchar2_table(47) := '63746F725F70726F6D7074416A6178436F6E7461696E65722B272074722C2023272B73656C6563746F725F706F707570416A6178436F6E7461696E65722B27207472272C2066756E6374696F6E28297B0D0A20206A517565727950414C2874686973292E';
wwv_flow_api.g_varchar2_table(48) := '616464436C6173732827686F7665722729200D0A20206A517565727950414C282723272B73656C6563746F725F70726F6D7074416A6178436F6E7461696E65722B27202E272B73656C6563746F725F70726F6D70744974656D53656C6563746564292E72';
wwv_flow_api.g_varchar2_table(49) := '656D6F7665436C6173732873656C6563746F725F70726F6D70744974656D53656C6563746564293B0D0A20200D0A7D292E6F6E28276D6F7573656F7574272C202723272B73656C6563746F725F70726F6D7074416A6178436F6E7461696E65722B272074';
wwv_flow_api.g_varchar2_table(50) := '722C2023272B73656C6563746F725F706F707570416A6178436F6E7461696E65722B27207472272C2066756E6374696F6E28297B0D0A20206A517565727950414C2874686973292E72656D6F7665436C6173732827686F7665722729200D0A7D293B0D0A';
wwv_flow_api.g_varchar2_table(51) := '0D0A0D0A66756E6374696F6E206465626F756E63652866756E632C20776169742C20696D6D65646961746529207B0D0A097661722074696D656F75743B0D0A0972657475726E2066756E6374696F6E2829207B0D0A090976617220636F6E74657874203D';
wwv_flow_api.g_varchar2_table(52) := '20746869732C2061726773203D20617267756D656E74733B0D0A0909766172206C61746572203D2066756E6374696F6E2829207B0D0A09090974696D656F7574203D206E756C6C3B0D0A0909096966202821696D6D656469617465292066756E632E6170';
wwv_flow_api.g_varchar2_table(53) := '706C7928636F6E746578742C2061726773293B0D0A09097D3B0D0A09097661722063616C6C4E6F77203D20696D6D656469617465202626202174696D656F75743B0D0A0909636C65617254696D656F75742874696D656F7574293B0D0A090974696D656F';
wwv_flow_api.g_varchar2_table(54) := '7574203D2073657454696D656F7574286C617465722C2077616974293B0D0A09096966202863616C6C4E6F77292066756E632E6170706C7928636F6E746578742C2061726773293B0D0A097D3B0D0A7D3B0D0A0D0A66756E6374696F6E2070616C76325F';
wwv_flow_api.g_varchar2_table(55) := '696E69742869642C20705F6F7074696F6E73496E29207B0D0A0D0A202066756E6374696F6E207061645370616365286E756D62657229207B0D0A20202020766172207370616365203D2027273B0D0A20202020666F7220287661722069203D20303B2069';
wwv_flow_api.g_varchar2_table(56) := '203C3D206E756D6265723B20692B2B290D0A2020202020207370616365202B3D2720273B0D0A202020200D0A2020202072657475726E2073706163653B0D0A20207D0D0A2F2A0D0A202066756E6374696F6E206170657864656275677374617274287374';
wwv_flow_api.g_varchar2_table(57) := '72696E6729207B0D0A20202020617065782E6465627567287061645370616365286170657844656275675370616365292B737472696E67293B0D0A2020202061706578446562756753706163652B3D313B0D0A20207D0D0A20200D0A202066756E637469';
wwv_flow_api.g_varchar2_table(58) := '6F6E20617065786465627567656E6428737472696E6729207B0D0A2020202061706578446562756753706163652D3D313B0D0A20202020617065782E6465627567287061645370616365286170657844656275675370616365292B737472696E67293B0D';
wwv_flow_api.g_varchar2_table(59) := '0A20207D0D0A2A2F20200D0A20200D0A202066756E6374696F6E20646973706C61794572726F7250617273654A534F4E28206D65737361676520297B0D0A20202020766172200D0A2020202020206572726F725F6964203D206E61746976655F6974656D';
wwv_flow_api.g_varchar2_table(60) := '5F69642B275F504F5055505F4552524F52272C0D0A202020202020706F7075705F6572726F72203D2024282723272B6572726F725F6964293B0D0A202020200D0A20202020706F7075705F6572726F722E68746D6C28206D657373616765292E6469616C';
wwv_flow_api.g_varchar2_table(61) := '6F6728276F70656E27293B0D0A20207D0D0A20200D0A202066756E6374696F6E20646973706C6179437573746F6D4572726F722820616A61785F72657475726E20297B0D0A20202020766172200D0A2020202020206572726F725F6964203D20616A6178';
wwv_flow_api.g_varchar2_table(62) := '5F72657475726E2E706C7567696E2E6974656D5F69642B275F504F5055505F4552524F52272C0D0A202020202020706F7075705F6572726F72203D2024282723272B6572726F725F6964293B0D0A0D0A2020202069662028706C7567696E4F626A656374';
wwv_flow_api.g_varchar2_table(63) := '2E636F6E7461696E65722E6469616C6F67282769734F70656E272929200D0A202020202020706C7567696E4F626A6563742E636F6E7461696E65722E6469616C6F672827636C6F736527292E646174612827616A61785F72657475726E272C20616A6178';
wwv_flow_api.g_varchar2_table(64) := '5F72657475726E293B0D0A202020200D0A20202020706F7075705F6572726F722E68746D6C28207472616E736C6174696F6E732E5041454C495F504F5055505F4E444620292E6469616C6F6728276F70656E27293B0D0A20207D0D0A20200D0A20206675';
wwv_flow_api.g_varchar2_table(65) := '6E6374696F6E20646973706C61794572726F7246726F6D416A61782820616A61785F72657475726E20297B0D0A20202020766172200D0A2020202020206469616C6F674572726F72436F6E666967203D207B0D0A20202020202020206175746F4F70656E';
wwv_flow_api.g_varchar2_table(66) := '3A2066616C73652C0D0A2020202020202020647261676761626C653A2066616C73652C0D0A20202020202020206D61784865696768743A203530302C0D0A20202020202020206D617857696474683A203630302C0D0A20202020202020206D696E576964';
wwv_flow_api.g_varchar2_table(67) := '74683A20276175746F272C0D0A20202020202020206469616C6F67436C6173733A2073656C6563746F725F706C7567696E416A61784572726F722C0D0A20202020202020207469746C653A206C6162656C5F746578742B27202D204552524F52272C0D0A';
wwv_flow_api.g_varchar2_table(68) := '20202020202020206D6F64616C3A20747275652C0D0A20202020202020206372656174653A2066756E6374696F6E28297B0D0A202020202020202020206E756C6C3B0D0A20202020202020207D2C0D0A20202020202020206F70656E3A2066756E637469';
wwv_flow_api.g_varchar2_table(69) := '6F6E28297B0D0A202020202020202020206E756C6C3B0D0A20202020202020207D2C0D0A2020202020202020636C6F73653A2066756E6374696F6E2829207B0D0A202020202020202020206E756C6C3B0D0A20202020202020207D0D0A2020202020207D';
wwv_flow_api.g_varchar2_table(70) := '2C0D0A0D0A202020202020646976203D202428646F63756D656E742E637265617465456C656D656E7428276469762729292E61747472287B0D0A202020202020202027636C617373273A2073656C6563746F725F706C7567696E416A61784572726F722C';
wwv_flow_api.g_varchar2_table(71) := '0D0A2020202020202020276964273A2069642B275F504F5055505F4552524F52270D0A2020202020207D292E6469616C6F6728206469616C6F674572726F72436F6E66696720292C202020200D0A0D0A2020202020206572726F725F6964203D20616A61';
wwv_flow_api.g_varchar2_table(72) := '785F72657475726E2E706C7567696E2E6974656D5F69642B275F504F5055505F4552524F52272C0D0A202020202020706F7075705F6572726F72203D2024282723272B6572726F725F6964293B0D0A0D0A2020202069662028706C7567696E4F626A6563';
wwv_flow_api.g_varchar2_table(73) := '742E636F6E7461696E657220213D20756E646566696E656420262620706C7567696E4F626A6563742E636F6E7461696E65722E6469616C6F67282769734F70656E272929200D0A202020202020706C7567696E4F626A6563742E636F6E7461696E65722E';
wwv_flow_api.g_varchar2_table(74) := '6469616C6F672827636C6F736527292E646174612827616A61785F72657475726E272C20616A61785F72657475726E293B0D0A202020200D0A20202020706F7075705F6572726F722E68746D6C280D0A202020202020273C7461626C653E270D0A202020';
wwv_flow_api.g_varchar2_table(75) := '20202020202B273C74723E270D0A202020202020202020202B273C74643E4974656D3A3C2F74643E203C74643E272B20616A61785F72657475726E2E706C7567696E2E6974656D5F6964202B272028272B20616A61785F72657475726E2E706C7567696E';
wwv_flow_api.g_varchar2_table(76) := '2E706C61696E5F6C6162656C202B27293C2F74643E270D0A20202020202020202B273C2F74723E272020202020200D0A20202020202020202B273C74723E270D0A202020202020202020202B273C74643E46756E6374696F6E3A3C2F74643E203C74643E';
wwv_flow_api.g_varchar2_table(77) := '272B20616A61785F72657475726E2E6572726F722E66756E635F6E616D65202B273C2F74643E270D0A20202020202020202B273C2F74723E272020202020200D0A20202020202020202B273C74723E270D0A202020202020202020202B273C74643E4D6F';
wwv_flow_api.g_varchar2_table(78) := '64653A3C2F74643E203C74643E272B20616A61785F72657475726E2E6572726F722E6D6F6465202B273C2F74643E270D0A20202020202020202B273C2F74723E272020202020200D0A20202020202020202B273C74723E270D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(79) := '2B273C74643E4572726F72206D6573736167653A3C2F74643E203C74643E203C7072653E272B20616A61785F72657475726E2E6572726F722E53514C4552524D202B273C2F7072653E3C2F74643E270D0A20202020202020202B273C2F74723E27202020';
wwv_flow_api.g_varchar2_table(80) := '2020200D0A2020202020202B273C2F7461626C653E270D0A20202020292E6469616C6F6728276F70656E27293B0D0A20207D0D0A0D0A0D0A202066756E6374696F6E205F706C7567696E5F7365745F76616C7565282076616C75652029207B0D0A202020';
wwv_flow_api.g_varchar2_table(81) := '20706C7567696E2E76616C282076616C756520293B0D0A20207D0D0A0D0A202066756E6374696F6E205F706C7567696E5F6765745F76616C7565282076616C75652029207B0D0A2020202072657475726E20706C7567696E2E76616C28293B0D0A20207D';
wwv_flow_api.g_varchar2_table(82) := '0D0A20200D0A20200D0A202066756E6374696F6E205F6D61736B5F7365745F76616C7565282076616C75652029207B0D0A202020206D61736B2E76616C282076616C756520293B0D0A20207D0D0A20200D0A202066756E6374696F6E205F6D61736B5F73';
wwv_flow_api.g_varchar2_table(83) := '65745F64617461286461746129207B0D0A202020206D61736B2E646174612864617461293B0D0A20207D0D0A20200D0A202066756E6374696F6E205F6D61736B5F72657365745F6461746128297B0D0A202020205F6D61736B5F7365745F64617461287B';
wwv_flow_api.g_varchar2_table(84) := '0D0A2020202020207061737465645F76616C7565733A205B5D2C0D0A20202020202073696E676C655F76616C75653A206E756C6C2C0D0A2020202020206576656E7450617374653A2066616C73650D0A2020202020200D0A202020207D293B0D0A20207D';
wwv_flow_api.g_varchar2_table(85) := '0D0A0D0A202066756E6374696F6E205F6D61736B5F6765745F76616C756528297B0D0A2020202072657475726E206D61736B2E76616C28293B0D0A20207D0D0A20200D0A202066756E6374696F6E205F706F706F7665725F636F6E74656E7428297B0D0A';
wwv_flow_api.g_varchar2_table(86) := '20202020766172200D0A20202020202069636F6E203D2069636F6E50617374650D0A20202020202076616C756573203D206D61736B2E6461746128277061737465645F76616C75657327292C0D0A202020202020746432636F7079203D202428646F6375';
wwv_flow_api.g_varchar2_table(87) := '6D656E742E637265617465456C656D656E74282774642729292C0D0A202020202020747232636F7079203D202428646F63756D656E742E637265617465456C656D656E74282774722729292C0D0A20202020202074656D705F7464203D2028746432636F';
wwv_flow_api.g_varchar2_table(88) := '70792E636C6F6E652866616C736529292E7465787428274E6F2E206F66207061737465642076616C7565733A20272B76616C7565732E6C656E677468292C0D0A20202020202074656D705F7472203D2028747232636F70792E636C6F6E652866616C7365';
wwv_flow_api.g_varchar2_table(89) := '29292E617070656E642874656D705F7464292C0D0A2020202020207461626C65203D202428646F63756D656E742E637265617465456C656D656E7428277461626C652729292E617070656E642874656D705F7472293B0D0A0D0A20202020666F72202869';
wwv_flow_api.g_varchar2_table(90) := '20696E2076616C75657329207B0D0A20202020202074656D705F7464203D2028746432636F70792E636C6F6E652866616C736529292E746578742827272B76616C7565735B695D293B0D0A20202020202074656D705F7472203D2028747232636F70792E';
wwv_flow_api.g_varchar2_table(91) := '636C6F6E652866616C736529292E616464436C61737328206925323D3D30203F2073656C6563746F725F74724576656E203A2073656C6563746F725F74724F646420292E617070656E64282074656D705F746420293B0D0A2020202020200D0A20202020';
wwv_flow_api.g_varchar2_table(92) := '20207461626C652E617070656E64282074656D705F747220293B0D0A202020207D0D0A202020200D0A2020202072657475726E207461626C652E68746D6C28293B0D0A20207D0D0A0D0A202066756E6374696F6E205F69636F6E5F6C6F6164696E675F73';
wwv_flow_api.g_varchar2_table(93) := '686F7728297B0D0A2020202069636F6E4C6F6164696E672E72656D6F7665436C6173732873656C6563746F725F69636F6E48696464656E293B0D0A0D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C20277061656C695F';
wwv_flow_api.g_varchar2_table(94) := '69636F6E5F6C6F6164696E675F73686F7727290D0A20207D0D0A0D0A202066756E6374696F6E205F69636F6E5F6C6F6164696E675F6869646528297B0D0A2020202069636F6E4C6F6164696E672E616464436C6173732873656C6563746F725F69636F6E';
wwv_flow_api.g_varchar2_table(95) := '48696464656E293B0D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C20277061656C695F69636F6E5F6C6F6164696E675F6869646527290D0A20207D0D0A0D0A202066756E6374696F6E205F69636F6E5F747269676765';
wwv_flow_api.g_varchar2_table(96) := '725F73686F7728297B0D0A2020202069636F6E547269676765722E72656D6F7665436C6173732873656C6563746F725F69636F6E48696464656E293B0D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C20277061656C69';
wwv_flow_api.g_varchar2_table(97) := '5F69636F6E5F747269676765725F73686F7727290D0A20207D0D0A0D0A202066756E6374696F6E205F69636F6E5F747269676765725F6869646528297B0D0A2020202069636F6E547269676765722E616464436C6173732873656C6563746F725F69636F';
wwv_flow_api.g_varchar2_table(98) := '6E48696464656E293B0D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C20277061656C695F69636F6E5F747269676765725F6869646527290D0A20207D0D0A0D0A202066756E6374696F6E205F69636F6E5F7472696767';
wwv_flow_api.g_varchar2_table(99) := '65725F72657365742829207B0D0A2020202069636F6E547269676765722E72656D6F7665436C6173732827656D70747920677265656E2072656420272B73656C6563746F725F69636F6E53696E676C652B2720272B73656C6563746F725F69636F6E4D75';
wwv_flow_api.g_varchar2_table(100) := '6C7469706C65293B0D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C20277061656C695F69636F6E5F747269676765725F6869646527293B0D0A20207D0D0A20200D0A202066756E6374696F6E205F69636F6E5F747269';
wwv_flow_api.g_varchar2_table(101) := '676765725F73696E676C6528297B0D0A202020205F69636F6E5F747269676765725F726573657428293B0D0A202020200D0A2020202069636F6E547269676765722E616464436C617373282073656C6563746F725F69636F6E53696E676C6520293B0D0A';
wwv_flow_api.g_varchar2_table(102) := '20202020617065782E6576656E742E747269676765722820706C7567696E2C20277061656C695F69636F6E5F747269676765725F73696E676C6527293B0D0A20207D0D0A0D0A202066756E6374696F6E205F69636F6E5F747269676765725F73696E676C';
wwv_flow_api.g_varchar2_table(103) := '655F6D61746368656428297B0D0A202020205F69636F6E5F747269676765725F726573657428293B0D0A202020200D0A2020202069636F6E547269676765722E616464436C617373282073656C6563746F725F69636F6E53696E676C6520292E61646443';
wwv_flow_api.g_varchar2_table(104) := '6C6173732827677265656E27293B0D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C20277061656C695F69636F6E5F747269676765725F73696E676C655F6D61746368656427293B0D0A20207D0D0A20200D0A20200D0A';
wwv_flow_api.g_varchar2_table(105) := '202066756E6374696F6E205F69636F6E5F747269676765725F6D756C7469706C6528297B0D0A202020205F69636F6E5F747269676765725F726573657428293B0D0A202020200D0A2020202069636F6E547269676765722E616464436C61737328207365';
wwv_flow_api.g_varchar2_table(106) := '6C6563746F725F69636F6E4D756C7469706C6520293B0D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C20277061656C695F69636F6E5F747269676765725F6D756C7469706C6527293B0D0A20207D0D0A0D0A20206675';
wwv_flow_api.g_varchar2_table(107) := '6E6374696F6E205F69636F6E5F747269676765725F6D756C7469706C655F6D61746368656428297B0D0A202020205F69636F6E5F747269676765725F726573657428293B0D0A202020200D0A2020202069636F6E547269676765722E616464436C617373';
wwv_flow_api.g_varchar2_table(108) := '282073656C6563746F725F69636F6E4D756C7469706C6520292E616464436C6173732827677265656E27293B0D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C20277061656C695F69636F6E5F747269676765725F6D75';
wwv_flow_api.g_varchar2_table(109) := '6C7469706C655F6D61746368656427293B0D0A20207D0D0A20200D0A20200D0A202066756E6374696F6E205F69636F6E5F70617374655F73686F7728297B0D0A2020202069636F6E50617374652E72656D6F7665436C6173732873656C6563746F725F69';
wwv_flow_api.g_varchar2_table(110) := '636F6E48696464656E293B0D0A202020202F2F69636F6E50617374652E706F706F766572282773686F7727293B0D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C20277061656C695F69636F6E5F70617374655F73686F';
wwv_flow_api.g_varchar2_table(111) := '7727293B0D0A20207D0D0A0D0A202066756E6374696F6E205F69636F6E5F70617374655F6869646528297B0D0A2020202069636F6E50617374652E616464436C6173732873656C6563746F725F69636F6E48696464656E293B0D0A2020202069636F6E50';
wwv_flow_api.g_varchar2_table(112) := '617374652E706F706F76657228276869646527293B0D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C20277061656C695F69636F6E5F70617374655F6869646527293B0D0A20207D0D0A20200D0A202066756E6374696F';
wwv_flow_api.g_varchar2_table(113) := '6E205F736574506F706F76657228297B0D0A2020202076617220706F706F7665724F7074696F6E73203D207B0D0A2020202020202768746D6C273A20747275652C0D0A20202020202027706C6163656D656E74273A20277269676874272C0D0A20202020';
wwv_flow_api.g_varchar2_table(114) := '20202774726967676572273A2027636C69636B272C0D0A202020202020277469746C65273A20275061737465642076616C756573272C0D0A20202020202027636F6E74656E74273A205F706F706F7665725F636F6E74656E742C0D0A2020202020202763';
wwv_flow_api.g_varchar2_table(115) := '6F6E7461696E6572273A2027626F647927202F2F706F646D69656E69616E65206E612073656C660D0A202020207D3B0D0A0D0A20202020706F706F7665724F7074696F6E732E636F6E7461696E6572203D206974656D5F636F6E7461696E65723B0D0A20';
wwv_flow_api.g_varchar2_table(116) := '20202069636F6E50617374652E706F706F7665722820706F706F7665724F7074696F6E7320293B0D0A20207D0D0A20200D0A202066756E6374696F6E205F636F70795F706C7567696E5F76616C75655F325F6D61736B28297B0D0A202020205F6D61736B';
wwv_flow_api.g_varchar2_table(117) := '5F7365745F76616C756528205F706C7567696E5F6765745F76616C756528292E73706C69742820736570617261746F7220295B305D20293B0D0A20207D0D0A0D0A0D0A202066756E6374696F6E205F5F726573706F6E655F69734572726F7228616A6178';
wwv_flow_api.g_varchar2_table(118) := '5F72657475726E297B0D0A2020202069662028616A61785F72657475726E2E6572726F722E6572726F72203D3D2031207C7C20616A61785F72657475726E2E6572726F722E6572726F72203D3D2027312729207B0D0A20202020202072657475726E2074';
wwv_flow_api.g_varchar2_table(119) := '7275653B0D0A202020207D0D0A202020200D0A2020202072657475726E2066616C73653B0D0A20207D0D0A20200D0A202020200D0A202066756E6374696F6E205F7365745F706F7075707328297B0D0A0D0A2020202066756E6374696F6E206469616C6F';
wwv_flow_api.g_varchar2_table(120) := '67436F6E6669675F73686F7753656C65637465642829207B0D0A202020202020766172200D0A20202020202020206964203D206E61746976655F6974656D5F69642B275F73686F775F73656C6563746564272C0D0A2020202020202020636F6E7461696E';
wwv_flow_api.g_varchar2_table(121) := '6572203D20242820646F63756D656E742E637265617465456C656D656E742827646976272920292E617474722827636C617373272C202770616C76325F64697653686F7753656C656374656427292C0D0A2020202020202020636865636B626F78203D20';
wwv_flow_api.g_varchar2_table(122) := '6E756C6C3B0D0A0D0A202020202020636865636B626F78203D20242820646F63756D656E742E637265617465456C656D656E742827696E707574272920292E61747472287B0D0A202020202020202020202774797065273A2027636865636B626F78272C';
wwv_flow_api.g_varchar2_table(123) := '0D0A20202020202020202020276964273A2069640D0A2020202020207D292E62696E6428276368616E6765272C2066756E6374696F6E28297B0D0A2020202020202020766172200D0A2020202020202020202073656C66203D20242874686973292C0D0A';
wwv_flow_api.g_varchar2_table(124) := '2020202020202020202073656C656374656441727261793B0D0A20202020202020200D0A2020202020202020706C7567696E4F626A6563742E646174612E68616E646C6572732E696E7075745365617263682E76616C28206E756C6C20293B0D0A202020';
wwv_flow_api.g_varchar2_table(125) := '20202020200D0A2020202020202020696620282073656C662E697328273A636865636B656427292029207B0D0A2020202020202020202073656C662E70726F702827636865636B6564272C20706C7567696E4F626A6563742E646174612E73686F775365';
wwv_flow_api.g_varchar2_table(126) := '6C6563746564282920293B0D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A20202020202020202020706C7567696E4F626A6563742E646174612E68616E646C6572732E636865636B626F7853656C656374416C6C2E70726F7028';
wwv_flow_api.g_varchar2_table(127) := '27636865636B6564272C2066616C7365293B0D0A20202020202020202020706C7567696E4F626A6563742E646174612E73686F77416C6C28293B0D0A20202020202020207D0D0A20202020202020200D0A2020202020202020706C7567696E4F626A6563';
wwv_flow_api.g_varchar2_table(128) := '742E646174612E697353686F7753656C6563746564203D2073656C662E697328273A636865636B656427293B0D0A2020202020207D293B0D0A0D0A202020202020636F6E7461696E65722E617070656E642820636865636B626F7820292E617070656E64';
wwv_flow_api.g_varchar2_table(129) := '2820273C6C6162656C20666F723D22272B69642B27223E272B7472616E736C6174696F6E732E5041454C495F504F5055505F53484F575F53454C45435445442B273C2F6C6162656C3E2720293B0D0A2020202020200D0A20202020202072657475726E20';
wwv_flow_api.g_varchar2_table(130) := '636F6E7461696E65723B0D0A202020207D0D0A0D0A2020202066756E6374696F6E206469616C6F67436F6E6669675F73656172636828297B0D0A202020202020766172200D0A2020202020202020736561726368426F78436F6E7461696E6572203D206A';
wwv_flow_api.g_varchar2_table(131) := '517565727950414C28646F63756D656E742E637265617465456C656D656E7428276469762729292E617474722827636C617373272C2073656C6563746F725F706F707570536561726368436F6E7461696E6572292C0D0A20202020202020206469765F73';
wwv_flow_api.g_varchar2_table(132) := '6561726368426F78203D206A517565727950414C28646F63756D656E742E637265617465456C656D656E7428276469762729292E617474722827636C617373272C2027736561726368626F7844697627292C0D0A2020202020202020696E707574536561';
wwv_flow_api.g_varchar2_table(133) := '72636849636F6E203D206A517565727950414C28646F63756D656E742E637265617465456C656D656E7428277370616E2729292E616464436C617373282775692D69636F6E2075692D69636F6E2D73656172636827292C0D0A2020202020202020696E70';
wwv_flow_api.g_varchar2_table(134) := '75745365617263684C6F6164696E67203D206A517565727950414C28646F63756D656E742E637265617465456C656D656E742827692729292E616464436C617373282770616C76325F69636F6E4C6F616465722070616C76325F69636F6E48696464656E';
wwv_flow_api.g_varchar2_table(135) := '27292E63737328276D617267696E2D6C656674272C2035292C0D0A2020202020202020696E707574536561726368203D206A517565727950414C28646F63756D656E742E637265617465456C656D656E742827696E7075742729293B0D0A0D0A20202020';
wwv_flow_api.g_varchar2_table(136) := '2020696E7075745365617263682E64626C636C69636B2866756E6374696F6E28297B0D0A20202020202020202F2F636F6E736F6C652E6C6F672820706C7567696E4F626A65637420293B0D0A2020202020207D290D0A2020202020200D0A202020202020';
wwv_flow_api.g_varchar2_table(137) := '696E7075745365617263682E61747472282774797065272C20277465787427292E6B65797570282066756E6374696F6E28297B0D0A20202020202020207661722073656C66203D20242874686973293B0D0A202020202020202073656C662E6E65787428';
wwv_flow_api.g_varchar2_table(138) := '272E70616C76325F69636F6E4C6F6164657227292E72656D6F7665436C617373282770616C76325F69636F6E48696464656E27293B0D0A2020202020202020706C7567696E4F626A6563742E646174612E72657365744D6F726553657428293B0D0A2020';
wwv_flow_api.g_varchar2_table(139) := '202020202020706C7567696E4F626A6563742E646174612E636C65617228293B0D0A0D0A2020202020207D20293B0D0A202020202020696E7075745365617263682E61747472282774797065272C20277465787427292E6B6579757028206465626F756E';
wwv_flow_api.g_varchar2_table(140) := '63652866756E6374696F6E28297B0D0A2020202020202020766172200D0A2020202020202020202073656C66203D20242874686973292C0D0A202020202020202020207365617263685F737472696E67203D2073656C662E76616C28293B0D0A20202020';
wwv_flow_api.g_varchar2_table(141) := '202020200D0A2020202020202020706C7567696E4F626A6563742E646174612E72656E6465722820706C7567696E4F626A6563742E646174612E66696E6428207365617263685F737472696E67202920293B0D0A0D0A202020202020202073656C662E6E';
wwv_flow_api.g_varchar2_table(142) := '65787428272E70616C76325F69636F6E4C6F6164657227292E616464436C617373282770616C76325F69636F6E48696464656E27293B0D0A2020202020207D2C203630302920293B0D0A2020202020200D0A2020202020206469765F736561726368426F';
wwv_flow_api.g_varchar2_table(143) := '782E617070656E642820696E70757453656172636849636F6E20292E617070656E642820696E70757453656172636820292E617070656E642820696E7075745365617263684C6F6164696E6720293B0D0A202020202020736561726368426F78436F6E74';
wwv_flow_api.g_varchar2_table(144) := '61696E65722E617070656E64286469765F736561726368426F78293B0D0A2020202020200D0A20202020202072657475726E20736561726368426F78436F6E7461696E65723B0D0A202020207D0D0A0D0A2020202066756E6374696F6E206469616C6F67';
wwv_flow_api.g_varchar2_table(145) := '436F6E6669675F73656C656374416C6C2829207B0D0A202020202020766172200D0A2020202020202020636F6E7461696E6572203D206A517565727950414C28646F63756D656E742E637265617465456C656D656E7428276469762729292E6174747228';
wwv_flow_api.g_varchar2_table(146) := '27636C617373272C202770616C76325F64697653656C656374416C6C27292C0D0A2020202020202020636865636B626F784964203D206E61746976655F6974656D5F69642B275F73656C6563745F616C6C273B0D0A2020202020200D0A20202020202076';
wwv_flow_api.g_varchar2_table(147) := '617220636865636B626F78203D202428646F63756D656E742E637265617465456C656D656E742827696E7075742729292E61747472287B0D0A2020202020202020276964273A20636865636B626F7849642C0D0A20202020202020202774797065273A20';
wwv_flow_api.g_varchar2_table(148) := '27636865636B626F78272C0D0A202020202020202027636C617373273A202770616C325F706F70757053656C656374416C6C56697369626C65272C0D0A202020202020202027666F72273A2027706F70757056616C756573270D0A2020202020207D292E';
wwv_flow_api.g_varchar2_table(149) := '62696E6428276368616E6765272C2066756E6374696F6E28297B0D0A2020202020202020766172200D0A2020202020202020202073656C66203D20242874686973292C0D0A2020202020202020202073656C66537461747573203D2073656C662E697328';
wwv_flow_api.g_varchar2_table(150) := '273A636865636B656427292C0D0A20202020202020202020726573756C74203D20706C7567696E4F626A6563742E646174612E6368616E6765537461747573416C6C282073656C6653746174757320293B0D0A20202020202020200D0A20202020202020';
wwv_flow_api.g_varchar2_table(151) := '2073656C662E70726F702827636865636B6564272C2073656C6653746174757320262620726573756C74203F2074727565203A2066616C7365290D0A20202020202020200D0A20202020202020202F2F706C7567696E4F626A6563742E646174612E6973';
wwv_flow_api.g_varchar2_table(152) := '53656C656374416C6C203D2073656C662E697328273A636865636B656427293B0D0A2020202020207D293B0D0A2020202020200D0A0D0A0D0A202020202020636F6E7461696E65722E617070656E642820636865636B626F7820292E617070656E642827';
wwv_flow_api.g_varchar2_table(153) := '203C6C6162656C20666F723D22272B636865636B626F7849642B27223E272B7472616E736C6174696F6E732E5041454C495F504F5055505F53454C4543545F414C4C2B273C2F6C6162656C3E27293B0D0A2020202020200D0A2020202020207265747572';
wwv_flow_api.g_varchar2_table(154) := '6E20636F6E7461696E65723B0D0A202020207D0D0A0D0A2020202066756E6374696F6E206469616C6F67436F6E6669675F6372656174652829207B0D0A202020202020766172200D0A202020202020202073656C66203D206A517565727950414C287468';
wwv_flow_api.g_varchar2_table(155) := '6973292C0D0A20202020202020202F2F627574746F6E436F6E7461696E6572203D2073656C662E6E65787428292C0D0A2020202020202020627574746F6E436F6E7461696E6572203D2073656C662E6E657874416C6C28272E75692D6469616C6F672D62';
wwv_flow_api.g_varchar2_table(156) := '7574746F6E70616E6527292C0D0A20202020202020200D0A2020202020202020686561646572436F6E7461696E6572203D20242820646F63756D656E742E637265617465456C656D656E742827646976272920292E617474722827636C617373272C2027';
wwv_flow_api.g_varchar2_table(157) := '70616C76325F7461626C65486561646572436F6E7461696E657227292E617070656E6428206469616C6F67436F6E6669675F736561726368282920293B0D0A2020202020200D0A2020202020200D0A0D0A20202020202073656C662E6F6E28276368616E';
wwv_flow_api.g_varchar2_table(158) := '6765272C20273A726164696F272C2066756E6374696F6E28297B0D0A2020202020202020766172200D0A20202020202020202020726F776E756D203D20242874686973292E617474722827726F776E756D27292C0D0A2020202020202020202063686563';
wwv_flow_api.g_varchar2_table(159) := '6B6564203D20242874686973292E697328273A636865636B656427293B0D0A0D0A20202020202020202F2F706C7567696E4F626A6563742E646174612E646573656C656374416C6C53656C656374656428293B0D0A2020202020202020706C7567696E4F';
wwv_flow_api.g_varchar2_table(160) := '626A6563742E646174612E646573656C656374416C6C28293B0D0A2020202020202020706C7567696E4F626A6563742E646174612E6368616E67655374617475732820726F776E756D2C20636865636B656420293B20202020202020200D0A2020202020';
wwv_flow_api.g_varchar2_table(161) := '207D292E6F6E28276368616E6765272C20273A636865636B626F78272C2066756E6374696F6E28297B0D0A202020202020202076617220726F776E756D203D20242874686973292E617474722827726F776E756D27293B0D0A2020202020202020706C75';
wwv_flow_api.g_varchar2_table(162) := '67696E4F626A6563742E646174612E6368616E67655374617475732820726F776E756D2C20242874686973292E697328273A636865636B6564272920293B0D0A2020202020207D292E6F6E28276D6F7573656F766572272C20277472272C2066756E6374';
wwv_flow_api.g_varchar2_table(163) := '696F6E28297B0D0A2020202020202020242874686973292E616464436C6173732827686F76657227293B0D0A2020202020207D292E6F6E28276D6F7573656F7574272C20277472272C2066756E6374696F6E28297B0D0A20202020202020202428746869';
wwv_flow_api.g_varchar2_table(164) := '73292E72656D6F7665436C6173732827686F76657227293B0D0A2020202020207D292E6265666F72652820686561646572436F6E7461696E657220293B0D0A2020202020200D0A202020202020696620286F7074696F6E732E5F6D756C7469706C65203D';
wwv_flow_api.g_varchar2_table(165) := '3D20275927290D0A2020202020202020686561646572436F6E7461696E65722E617070656E6428206469616C6F67436F6E6669675F73656C656374416C6C282920293B0D0A2020202020200D0A202020202020627574746F6E436F6E7461696E65722E61';
wwv_flow_api.g_varchar2_table(166) := '7070656E6428206469616C6F67436F6E6669675F73686F7753656C6563746564282920293B0D0A2020202020200D0A202020207D0D0A0D0A2020202066756E6374696F6E206469616C6F67436F6E6669675F6F70656E2829207B0D0A202020202020706C';
wwv_flow_api.g_varchar2_table(167) := '7567696E4F626A6563742E636F6E7461696E65722E64617461282762746E436C69636B272C2066616C7365293B0D0A202020202020617065782E6576656E742E747269676765722820706C7567696E2C2027706C7567696E5F706F7075705F6F70656E65';
wwv_flow_api.g_varchar2_table(168) := '6427293B0D0A202020202020242827626F647927292E63737328276F766572666C6F77272C202768696464656E27293B0D0A202020207D0D0A0D0A2020202066756E6374696F6E206469616C6F67436F6E6669675F636C6F73652829207B0D0A20202020';
wwv_flow_api.g_varchar2_table(169) := '2020766172200D0A2020202020202020706F707570203D206A517565727950414C282069636F6E547269676765722E646174612827706F707570272920292C0D0A2020202020202020706F707570506172656E74203D20706F7075702E706172656E7428';
wwv_flow_api.g_varchar2_table(170) := '293B200D0A0D0A2020202020200D0A2020202020200D0A202020202020706F707570506172656E742E66696E642824785F4279436C617373282073656C6563746F725F7061737465644E6F74466F756E642920292E616464436C617373282073656C6563';
wwv_flow_api.g_varchar2_table(171) := '746F725F69636F6E48696464656E20293B0D0A202020202020706F707570506172656E742E66696E642824785F4279436C617373282073656C6563746F725F706F707570536561726368526573756C74732920292E74657874282727293B0D0A20202020';
wwv_flow_api.g_varchar2_table(172) := '2020706F707570506172656E742E66696E642824785F4279436C617373282073656C6563746F725F706F707570536561726368496E7075742920292E76616C282727293B0D0A2020202020200D0A202020202020706C7567696E4F626A6563742E646174';
wwv_flow_api.g_varchar2_table(173) := '612E646573656C656374416C6C28293B20202020202020200D0A0D0A202020202020242827626F647927292E63737328276F766572666C6F77272C20276175746F27293B0D0A0D0A2020202020206966202820706C7567696E4F626A6563742E636F6E74';
wwv_flow_api.g_varchar2_table(174) := '61696E65722E64617461282762746E436C69636B27292029207B0D0A2020202020202020617065782E6576656E742E747269676765722820706C7567696E2C2027706C7567696E5F706F7075705F636C6F73655F62746E27293B0D0A2020202020207D0D';
wwv_flow_api.g_varchar2_table(175) := '0A202020202020656C7365207B0D0A2020202020202020617065782E6576656E742E747269676765722820706C7567696E2C2027706C7567696E5F706F7075705F636C6F736527293B0D0A2020202020207D0D0A0D0A2020202020200D0A202020207D0D';
wwv_flow_api.g_varchar2_table(176) := '0A0D0A2020202066756E6374696F6E206469616C6F67436F6E6669675F62746E5F636C69636B28297B0D0A202020202020766172200D0A202020202020202066697273744F626A65637453656C6563746564203D205B5D2C0D0A20202020202020207265';
wwv_flow_api.g_varchar2_table(177) := '73756C74537472696E67203D2027272C0D0A202020202020202073656C656374656456616C7565734172726179203D205B5D2C0D0A090973656C6563746564446973706C61794172726179203D205B5D2C202F2F20646F64616E6F0D0A0909646973706C';
wwv_flow_api.g_varchar2_table(178) := '6179537472696E67203D202727202F2F20646F64616E6F0D0A0909646973706C6179537472696E674C696D6974203D203130303B202F2F646F64616E6F202D20747761726479206C696D6974207A6E616B6F7720646F20706F6B617A616E6961202C2072';
wwv_flow_api.g_varchar2_table(179) := '61637A656A2074727A6562612062792070727A656E6965736320646F20706172616D6574726F770D0A09093B0D0A2020202020200D0A20202020202073656C656374656456616C7565734172726179203D20706C7567696E4F626A6563742E646174612E';
wwv_flow_api.g_varchar2_table(180) := '676574436865636B656456616C75657328293B0D0A202020202020726573756C74537472696E67203D2073656C656374656456616C75657341727261792E6A6F696E2820736570617261746F7220293B0D0A2020202020200D0A20202020202069662028';
wwv_flow_api.g_varchar2_table(181) := '20726573756C74537472696E672E6C656E677468203E206F7074696F6E732E5F6D6178436861727329207B0D0A2020202020202020616C6572742820287472616E736C6174696F6E732E5041454C495F504F5055505F4C454E475448292E7265706C6163';
wwv_flow_api.g_varchar2_table(182) := '652827236C696D697423272C206F7074696F6E732E5F6D617843686172732920293B0D0A202020202020202072657475726E2066616C73653B0D0A2020202020207D20200D0A202020202020656C7365207B0D0A20202020202020200D0A202020202020';
wwv_flow_api.g_varchar2_table(183) := '20206966202820726573756C74537472696E672E6C656E677468203E20302029207B0D0A2020202020202020202066697273744F626A65637453656C6563746564203D20706C7567696E4F626A6563742E646174612E676574466972737453656C656374';
wwv_flow_api.g_varchar2_table(184) := '65644F626A65637428293B20200D0A202020202020202020205F706C7567696E5F7365745F76616C75652820726573756C74537472696E6720293B0D0A090920200D0A090920202F2F205A6D69616E6120646F20777973776965746C616E696120776965';
wwv_flow_api.g_varchar2_table(185) := '6C7520776172746F7363690D0A09092020696620286F7074696F6E732E5F6D756C7469706C65446973706C6179203D3D20275927297B0D0A09090973656C6563746564446973706C61794172726179203D20706C7567696E4F626A6563742E646174612E';
wwv_flow_api.g_varchar2_table(186) := '676574436865636B6564446973706C617928293B0D0A0909092F2F636F6E736F6C652E6C6F672873656C6563746564446973706C61794172726179293B0D0A090909646973706C6179537472696E67203D2073656C6563746564446973706C6179417272';
wwv_flow_api.g_varchar2_table(187) := '61792E6A6F696E2820736570617261746F7220293B0D0A090909696628646973706C6179537472696E672E6C656E676874203E20646973706C6179537472696E674C696D6974297B0D0A09090909646973706C6179537472696E67203D20646973706C61';
wwv_flow_api.g_varchar2_table(188) := '79537472696E672E737562737472696E6728302C20646973706C6179537472696E674C696D69742D34293B0D0A09090909646973706C6179537472696E67203D20646973706C6179537472696E67202B20272E2E2E273B0D0A0909097D0D0A0909095F6D';
wwv_flow_api.g_varchar2_table(189) := '61736B5F7365745F76616C75652820646973706C6179537472696E67293B0D0A090920207D656C73657B0D0A09092020205F6D61736B5F7365745F76616C7565282066697273744F626A65637453656C65637465642E6420293B0D0A090920207D0D0A09';
wwv_flow_api.g_varchar2_table(190) := '0920202F2F4B6F6E696563207A6D69616E790D0A2020202020202020200D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A202020202020202020205F706C7567696E5F7365745F76616C756528206E756C6C20293B0D0A20202020';
wwv_flow_api.g_varchar2_table(191) := '2020202020205F6D61736B5F7365745F76616C756528206E756C6C20293B0D0A202020202020202020200D0A20202020202020207D0D0A20202020202020200D0A20202020202020205F69636F6E5F70617374655F6869646528293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(192) := '20200D0A2020202020202020706C7567696E4F626A6563742E636F6E7461696E65722E64617461282762746E436C69636B272C2074727565293B0D0A2020202020202020706C7567696E4F626A6563742E636F6E7461696E65722E6469616C6F67282763';
wwv_flow_api.g_varchar2_table(193) := '6C6F736527293B0D0A2020202020202020706C7567696E2E7472696767657228276368616E6765272C205B747275655D293B0D0A2020202020207D0D0A2020202020200D0A20202020202072657475726E20766F69642830293B2020202020200D0A2020';
wwv_flow_api.g_varchar2_table(194) := '20207D0D0A0D0A2020202076617220200D0A2020202020206469616C6F67436F6E666967203D207B0D0A2020202020202020276175746F4F70656E273A2066616C73652C0D0A2020202020202020276D696E486569676874273A203330302C0D0A202020';
wwv_flow_api.g_varchar2_table(195) := '202020202027686569676874273A20276175746F272C0D0A2020202020202020276D6178486569676874273A20242877696E646F77292E6F7574657248656967687428292A302E392C0D0A2020202020202020276D696E5769647468273A203435302C0D';
wwv_flow_api.g_varchar2_table(196) := '0A2020202020202020277469746C65273A206C6162656C5F746578742B7472616E736C6174696F6E732E5041454C495F504F5055505F53554649582C0D0A2020202020202020276469616C6F67436C617373273A2073656C6563746F725F706F7075704F';
wwv_flow_api.g_varchar2_table(197) := '75746572436F6E7461696E65722C0D0A2020202020202020276D6F64616C273A20747275652C0D0A202020202020202027637265617465273A206469616C6F67436F6E6669675F6372656174652C0D0A2020202020202020276F70656E273A206469616C';
wwv_flow_api.g_varchar2_table(198) := '6F67436F6E6669675F6F70656E2C0D0A202020202020202027627574746F6E73273A205B0D0A202020202020202020207B0D0A202020202020202020202020746578743A207472616E736C6174696F6E732E5041454C495F42544E5F53454C4543542C0D';
wwv_flow_api.g_varchar2_table(199) := '0A202020202020202020202020636C69636B3A206469616C6F67436F6E6669675F62746E5F636C69636B0D0A202020202020202020207D0D0A20202020202020205D2C0D0A202020202020202027636C6F7365273A206469616C6F67436F6E6669675F63';
wwv_flow_api.g_varchar2_table(200) := '6C6F73650D0A2020202020207D2C0D0A202020202020706F707570436F6E7461696E6572203D202428646F63756D656E742E637265617465456C656D656E7428276469762729292E61747472287B0D0A2020202020202020276964273A2069642B275F50';
wwv_flow_api.g_varchar2_table(201) := '4F505550270D0A2020202020207D292C0D0A202020202020706F707570436F6E7461696E6572416A6178203D202428646F63756D656E742E637265617465456C656D656E7428276469762729292E61747472287B0D0A202020202020202027636C617373';
wwv_flow_api.g_varchar2_table(202) := '273A2073656C6563746F725F706F707570416A6178436F6E7461696E65720D0A2020202020207D293B0D0A202020200D0A20202020706F707570436F6E7461696E65722E62696E6428277363726F6C6C272C206465626F756E6365280D0A202020202020';
wwv_flow_api.g_varchar2_table(203) := '66756E6374696F6E2865297B0D0A2020202020202020766172200D0A20202020202020202020636F6E7461696E6572203D202428652E63757272656E74546172676574292C0D0A202020202020202020207461626C65203D20636F6E7461696E65722E66';
wwv_flow_api.g_varchar2_table(204) := '696E6428277461626C6527292E666972737428292C0D0A202020202020202020207461626C65426F74746F6D4C696D6974203D207461626C652E6F7574657248656967687428292C0D0A2020202020202020202063616C63756C617465645363726F6C6C';
wwv_flow_api.g_varchar2_table(205) := '546F426F74746F6D203D204D6174682E616273287461626C652E6F666673657428292E746F7029202B20636F6E7461696E65722E6865696768742829202B20636F6E7461696E65722E6F666673657428292E746F703B0D0A20202020202020200D0A2020';
wwv_flow_api.g_varchar2_table(206) := '202020202020696620282063616C63756C617465645363726F6C6C546F426F74746F6D202B20323030203E3D20207461626C65426F74746F6D4C696D697429207B0D0A20202020202020202020706C7567696E4F626A6563742E646174612E72656E6465';
wwv_flow_api.g_varchar2_table(207) := '724D6F726528293B0D0A20202020202020207D0D0A2020202020207D2C203230300D0A2020202029292E617070656E642820706F707570436F6E7461696E6572416A617820292E6469616C6F6728206469616C6F67436F6E66696720293B0D0A20202020';
wwv_flow_api.g_varchar2_table(208) := '0D0A202020202F2F646F20777977616C656E6961202D207265666163746F72696E670D0A2020202069636F6E547269676765722E646174612827706F707570272C20706F707570436F6E7461696E6572293B0D0A202020200D0A20202020706C7567696E';
wwv_flow_api.g_varchar2_table(209) := '4F626A6563742E636F6E7461696E6572203D20706F707570436F6E7461696E65723B0D0A20202020706C7567696E4F626A6563742E706F707570416A6178436F6E7461696E6572203D20706F707570436F6E7461696E6572416A61783B0D0A20207D0D0A';
wwv_flow_api.g_varchar2_table(210) := '0D0A202066756E6374696F6E20616A617844617461287265714F7074696F6E7329207B0D0A20202020766172206C44617461203D207B200D0A202020202020705F726571756573743A20224E41544956453D222B6F7074696F6E732E616A61784964656E';
wwv_flow_api.g_varchar2_table(211) := '7469666965722C0D0A202020202020705F666C6F775F69643A202476282770466C6F77496427292C0D0A202020202020705F666C6F775F737465705F69643A202476282770466C6F7753746570496427292C0D0A202020202020705F696E7374616E6365';
wwv_flow_api.g_varchar2_table(212) := '3A202476282770496E7374616E636527292C0D0A2020202020207830313A207265714F7074696F6E732E6D6F64652C0D0A2020202020207830323A207265714F7074696F6E732E7365617263680D0A202020207D3B0D0A0D0A2020202024286F7074696F';
wwv_flow_api.g_varchar2_table(213) := '6E732E646570656E64696E674F6E53656C6563746F722B272C272B6F7074696F6E732E706167654974656D73546F5375626D6974292E656163682866756E6374696F6E28297B0D0A202020202020766172206C4964783B0D0A202020202020696620286C';
wwv_flow_api.g_varchar2_table(214) := '446174612E705F6172675F6E616D65733D3D3D756E646566696E656429207B0D0A20202020202020206C446174612E705F6172675F6E616D657320203D205B5D3B0D0A20202020202020206C446174612E705F6172675F76616C756573203D205B5D3B0D';
wwv_flow_api.g_varchar2_table(215) := '0A20202020202020206C496478203D20303B0D0A2020202020207D200D0A202020202020656C7365207B0D0A20202020202020206C496478203D206C446174612E705F6172675F6E616D65732E6C656E6774683B0D0A2020202020207D0D0A2020202020';
wwv_flow_api.g_varchar2_table(216) := '200D0A2020202020206C446174612E705F6172675F6E616D6573205B6C4964785D203D20746869732E69643B0D0A2020202020206C446174612E705F6172675F76616C7565735B6C4964785D203D2024762874686973293B0D0A202020207D293B0D0A0D';
wwv_flow_api.g_varchar2_table(217) := '0A202020200D0A2020202072657475726E206C446174613B0D0A20207D0D0A202020200D0A202066756E6374696F6E205F616A61785F7365745F63757272656E745F726571756573742820616A61784F626A20297B0D0A20202020706C7567696E2E6461';
wwv_flow_api.g_varchar2_table(218) := '74612827616A61785F68616E646C6572272C20616A61784F626A293B0D0A20207D0D0A20200D0A202066756E6374696F6E205F616A61785F61626F72745F70726576696F757328297B0D0A2020202076617220786872203D20706C7567696E2E64617461';
wwv_flow_api.g_varchar2_table(219) := '2827616A61785F68616E646C65722729203D3D20756E646566696E6564203F206E756C6C203A20706C7567696E2E646174612827616A61785F68616E646C657227293B0D0A202020200D0A202020206966202878687220213D206E756C6C29207B0D0A20';
wwv_flow_api.g_varchar2_table(220) := '20202020207868722E61626F727428293B0D0A202020207D0D0A202020200D0A202020205F69636F6E5F6C6F6164696E675F6869646528293B0D0A202020205F69636F6E5F747269676765725F73686F7728293B0D0A20207D0D0A20200D0A202066756E';
wwv_flow_api.g_varchar2_table(221) := '6374696F6E20666F7263655F726566726573685F706172656E742829207B0D0A202020205F636C65616E506C7567696E28293B0D0A202020205F616A61785F61626F72745F70726576696F757328293B0D0A202020205F69636F6E5F6C6F6164696E675F';
wwv_flow_api.g_varchar2_table(222) := '73686F7728293B0D0A202020205F69636F6E5F747269676765725F6869646528293B0D0A202020200D0A2020202076617220646174614F7074696F6E73203D207B0D0A2020202020206D6F64653A2027666F72636552656672657368272C0D0A20202020';
wwv_flow_api.g_varchar2_table(223) := '20207365617263683A206E756C6C0D0A202020207D0D0A202020200D0A20202020706C7567696E2E747269676765722827617065786265666F72657265667265736827293B0D0A0D0A2020202076617220786872203D20242E616A6178287B0D0A202020';
wwv_flow_api.g_varchar2_table(224) := '20202075726C3A277777765F666C6F772E73686F77272C0D0A202020202020747970653A27706F7374272C0D0A20202020202064617461547970653A276A736F6E272C0D0A202020202020747261646974696F6E616C3A20747275652C0D0A2020202020';
wwv_flow_api.g_varchar2_table(225) := '20646174613A20616A61784461746128646174614F7074696F6E73292C0D0A202020202020737563636573733A2066756E6374696F6E28297B200D0A20202020202020205F69636F6E5F6C6F6164696E675F6869646528293B0D0A20202020202020205F';
wwv_flow_api.g_varchar2_table(226) := '69636F6E5F747269676765725F73686F7728293B0D0A2020202020202020706C7567696E2E7472696767657228276170657861667465727265667265736827293B0D0A2020202020207D0D0A202020207D293B0D0A202020200D0A202020205F616A6178';
wwv_flow_api.g_varchar2_table(227) := '5F7365745F63757272656E745F72657175657374282078687220290D0A20207D0D0A0D0A20202066756E6374696F6E205F636C65616E506C7567696E2829207B0D0A2020202069636F6E547269676765722E72656D6F7665436C6173732873656C656374';
wwv_flow_api.g_varchar2_table(228) := '6F725F69636F6E4D756C7469706C65292E72656D6F7665436C6173732873656C6563746F725F69636F6E53696E676C65293B0D0A202020200D0A202020205F6D61736B5F7365745F76616C756528206E756C6C20290D0A202020200D0A202020205F706C';
wwv_flow_api.g_varchar2_table(229) := '7567696E5F7365745F76616C7565286E756C6C293B0D0A202020205F6D61736B5F72657365745F6461746128293B0D0A202020205F69636F6E5F70617374655F6869646528290D0A20207D0D0A20200D0A202066756E6374696F6E205F7365745F706173';
wwv_flow_api.g_varchar2_table(230) := '746528297B0D0A2020202069662028206F7074696F6E732E5F616C6C6F775061737465203D3D202759272029207B0D0A2020202020206966202869734D53494529207B0D0A20202020202020206D61736B2E62696E6428277061737465272C205F655F6D';
wwv_flow_api.g_varchar2_table(231) := '61736B5F7061737465293B0D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020206D61736B2E6361746368706173746528205F655F6D61736B5F706173746520293B0D0A2020202020207D0D0A202020207D0D0A20207D0D0A';
wwv_flow_api.g_varchar2_table(232) := '20200D0A202066756E6374696F6E205F7365745F6D61736B2829207B0D0A0D0A2020202066756E6374696F6E20616A61785F726573706F6E736528206461746120297B200D0A20202020202069662028205F5F726573706F6E655F69734572726F722864';
wwv_flow_api.g_varchar2_table(233) := '617461292029207B0D0A20202020202020205F69636F6E5F6C6F6164696E675F6869646528293B0D0A20202020202020205F69636F6E5F747269676765725F73686F7728293B0D0A20202020202020205F636F70795F706C7567696E5F76616C75655F32';
wwv_flow_api.g_varchar2_table(234) := '5F6D61736B28293B0D0A20202020202020205F655F7265616C5F6576656E745F6368616E676528293B0D0A202020202020202020200D0A202020202020202072657475726E20766F69642830293B0D0A2020202020207D0D0A202020200D0A2020202020';
wwv_flow_api.g_varchar2_table(235) := '205F69636F6E5F6C6F6164696E675F6869646528293B0D0A2020202020205F69636F6E5F747269676765725F73686F7728293B0D0A0D0A0D0A2020202020205F6D61736B5F7365745F76616C75652820646174612E76616C7565735B305D2E6420293B0D';
wwv_flow_api.g_varchar2_table(236) := '0A0D0A202020202020696620282076616C7565734265666F72654D61736B2E6C656E677468203E20312029207B0D0A2020202020202020696620286F7074696F6E732E5F6D756C7469706C65203D3D20274E2729207B0D0A202020202020202020205F70';
wwv_flow_api.g_varchar2_table(237) := '6C7567696E5F7365745F76616C75652820646174612E76616C7565735B305D2E7220293B0D0A20202020202020207D200D0A2020202020202020656C7365207B0D0A202020202020202020205F706C7567696E5F7365745F76616C7565282076616C7565';
wwv_flow_api.g_varchar2_table(238) := '734265666F72654D61736B2E6A6F696E2820736570617261746F72202920293B202020200D0A20202020202020207D200D0A20202020202020200D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020205F706C7567696E5F73';
wwv_flow_api.g_varchar2_table(239) := '65745F76616C75652820646174612E76616C7565735B305D2E7220293B20200D0A2020202020207D0D0A2020202020200D0A2020202020202F2F747520706F77696E6E612069736320696E666F726D61636A61207A65206D61736B61206A65737420646F';
wwv_flow_api.g_varchar2_table(240) := '7061736F77616E61206C7562206E69650D0A202020202020617065782E6576656E742E747269676765722820706C7567696E2C2027706C7567696E5F696E69745F72657472696576655F6D61736B27290D0A2020202020205F655F7265616C5F6576656E';
wwv_flow_api.g_varchar2_table(241) := '745F6368616E676528206E756C6C2C20646174612E76616C7565735B305D2E6D61746368656420293B0D0A202020207D0D0A0D0A20202020766172200D0A20202020202076616C7565734265666F72654D61736B203D205F706C7567696E5F6765745F76';
wwv_flow_api.g_varchar2_table(242) := '616C756528292E73706C69742820736570617261746F7220292C0D0A202020202020666972737456616C7565203D20285F706C7567696E5F6765745F76616C756528292E73706C69742820736570617261746F722029295B305D2C0D0A20202020202078';
wwv_flow_api.g_varchar2_table(243) := '6872203D20706C7567696E2E646174612827616A61785F68616E646C65722729203D3D20756E646566696E6564203F206E756C6C203A20706C7567696E2E646174612827616A61785F68616E646C657227292C0D0A202020202020646174614F7074696F';
wwv_flow_api.g_varchar2_table(244) := '6E73203D207B0D0A2020202020202020276D6F6465273A20276765744D61736B272C0D0A202020202020202027736561726368273A20666972737456616C75650D0A2020202020207D3B0D0A0D0A202020205F69636F6E5F6C6F6164696E675F73686F77';
wwv_flow_api.g_varchar2_table(245) := '28293B0D0A202020205F69636F6E5F747269676765725F6869646528293B0D0A202020200D0A202020206966202820242E696E417272617928666972737456616C75652C205B6E756C6C2C20756E646566696E65642C2027275D29203E202D312029207B';
wwv_flow_api.g_varchar2_table(246) := '0D0A2020202020205F69636F6E5F6C6F6164696E675F6869646528293B0D0A2020202020205F69636F6E5F747269676765725F73686F7728293B0D0A2020202020200D0A2020202020205F636F70795F706C7567696E5F76616C75655F325F6D61736B28';
wwv_flow_api.g_varchar2_table(247) := '293B2020202020200D0A2020202020200D0A20202020202072657475726E20766F69642830293B0D0A202020207D0D0A202020200D0A202020206966202878687220213D206E756C6C29207B0D0A2020202020207868722E61626F727428293B0D0A2020';
wwv_flow_api.g_varchar2_table(248) := '20207D0D0A202020200D0A20202020786872203D20242E616A6178287B0D0A20202020202075726C3A277777765F666C6F772E73686F77272C0D0A202020202020747970653A27706F7374272C0D0A20202020202064617461547970653A276A736F6E27';
wwv_flow_api.g_varchar2_table(249) := '2C0D0A202020202020747261646974696F6E616C3A20747275652C0D0A202020202020737563636573733A20616A61785F726573706F6E73652C0D0A202020202020646174613A20616A61784461746128646174614F7074696F6E73290D0A202020207D';
wwv_flow_api.g_varchar2_table(250) := '293B200D0A202020200D0A20202020706C7567696E2E646174612827616A61785F68616E646C6572272C20786872293B0D0A202020200D0A20207D0D0A20200D0A202066756E6374696F6E205F655F7265616C5F6576656E745F6368616E676528657665';
wwv_flow_api.g_varchar2_table(251) := '6E742C2069735F646174615F6D61746368656429207B0D0A20202020766172200D0A20202020202076616C756573203D205F706C7567696E5F6765745F76616C756528292E73706C69742820736570617261746F7220292C0D0A2020202020206D617463';
wwv_flow_api.g_varchar2_table(252) := '686564203D2066616C73652C0D0A2020202020206D756C7469706C65203D2066616C73652C0D0A2020202020206974656D4F626A656374203D207B7D2C0D0A2020202020206576656E744F626A656374203D207B7D3B0D0A0D0A202020202F2F6E696520';
wwv_flow_api.g_varchar2_table(253) := '6D61206F62736C7567692067647920302C20626F2073706C6974207A207075737465676F20737472696E6761207A2064616E796D20736570617261746F72656D207A7772616361207461626C696365206A65646E6F656C656D656E746F77610D0A202020';
wwv_flow_api.g_varchar2_table(254) := '20696620282076616C7565732E6C656E677468203D3D20312029207B202F2F776172746FC59B6369206A657374206A65646E6120692069206E6965206A6573742070757374610D0A0D0A202020202020696620282076616C7565735B305D20213D202727';
wwv_flow_api.g_varchar2_table(255) := '2029207B0D0A20202020202020206966202869735F646174615F6D61746368656429207B0D0A202020202020202020205F69636F6E5F747269676765725F73696E676C655F6D61746368656428293B0D0A202020202020202020206D617463686564203D';
wwv_flow_api.g_varchar2_table(256) := '20747275653B0D0A202020202020202020206D756C7469706C65203D2066616C73653B0D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A202020202020202020205F69636F6E5F747269676765725F73696E676C6528293B0D0A20';
wwv_flow_api.g_varchar2_table(257) := '2020202020202020206D617463686564203D2066616C73653B0D0A202020202020202020206D756C7469706C65203D2066616C73653B0D0A20202020202020207D0D0A2020202020207D0D0A202020202020656C7365207B202F2F77796272616E6F2030';
wwv_flow_api.g_varchar2_table(258) := '20636865636B626F78C3B377207A20706F7075702C20637A796C206972657365746F77616E696520776172746FC59B63690D0A20202020202020205F69636F6E5F747269676765725F726573657428293B2020202020200D0A20202020202020206D6174';
wwv_flow_api.g_varchar2_table(259) := '63686564203D206E756C6C3B0D0A20202020202020206D756C7469706C65203D206E756C6C3B0D0A2020202020207D0D0A202020207D0D0A20202020656C7365207B202F2F776172746FC59B6369206A6573742077696563656A206E697A206A65646E61';
wwv_flow_api.g_varchar2_table(260) := '20282076616C7565732E6C656E677468203E203120290D0A2020202020206966202869735F646174615F6D61746368656429207B0D0A20202020202020205F69636F6E5F747269676765725F6D756C7469706C655F6D61746368656428293B0D0A202020';
wwv_flow_api.g_varchar2_table(261) := '20202020206D617463686564203D20747275653B0D0A20202020202020206D756C7469706C65203D20747275653B0D0A0D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020205F69636F6E5F747269676765725F6D756C7469';
wwv_flow_api.g_varchar2_table(262) := '706C6528293B0D0A20202020202020206D617463686564203D2066616C73653B0D0A20202020202020206D756C7469706C65203D20747275653B0D0A2020202020207D0D0A202020207D0D0A0D0A202020206974656D4F626A656374203D205F706C7567';
wwv_flow_api.g_varchar2_table(263) := '696E5F747269676765725F6461746128293B0D0A0D0A202020206576656E744F626A656374203D207B0D0A202020202020275041454C49273A207B0D0A2020202020202020276368616E6765644D756C7469706C65273A206D756C7469706C652C0D0A20';
wwv_flow_api.g_varchar2_table(264) := '20202020202020276368616E6765644D617463686564273A206D6174636865640D0A2020202020207D0D0A202020207D3B0D0A202020200D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C2027706C7567696E5F76616C';
wwv_flow_api.g_varchar2_table(265) := '75655F6368616E676564272C20242E657874656E6428747275652C206974656D4F626A6563742C206576656E744F626A6563742920293B0D0A20207D20200D0A0D0A202066756E6374696F6E205F706C7567696E5F747269676765725F64617461282070';
wwv_flow_api.g_varchar2_table(266) := '5F68656C70657220297B0D0A2020202072657475726E207B0D0A2020202020205041454C493A207B0D0A2020202020202020226D61736B223A207B0D0A20202020202020202020226974656D223A206D61736B2C0D0A2020202020202020202022696422';
wwv_flow_api.g_varchar2_table(267) := '3A206E61746976655F6974656D5F69642B275F444953504C4159272C0D0A202020202020202020202276616C7565223A205F6D61736B5F6765745F76616C756528292C0D0A202020202020202020202268656C706572223A20705F68656C7065720D0A20';
wwv_flow_api.g_varchar2_table(268) := '202020202020207D2C0D0A202020202020202022617065784974656D223A207B0D0A20202020202020202020276974656D273A20706C7567696E2C0D0A20202020202020202020226964223A206E61746976655F6974656D5F69642C0D0A202020202020';
wwv_flow_api.g_varchar2_table(269) := '202020202276616C7565223A205F706C7567696E5F6765745F76616C756528292C0D0A2020202020202020202022636F6E7461696E6572223A206974656D5F636F6E7461696E65720D0A20202020202020207D2C0D0A2020202020202020226C6162656C';
wwv_flow_api.g_varchar2_table(270) := '223A207B0D0A20202020202020202020227265666572656E6365223A206C6162656C2C0D0A202020202020202020202274657874223A206C6162656C5F746578740D0A20202020202020207D0D0A2020202020207D0D0A202020207D3B0D0A20207D0D0A';
wwv_flow_api.g_varchar2_table(271) := '0D0A20200D0A202066756E6374696F6E205F676574436C6970426F61726441734172726179324428736F7572636529207B0D0A20202020766172207363686F77656B203D20242E7472696D28736F75726365293B0D0A202020200D0A202020207363686F';
wwv_flow_api.g_varchar2_table(272) := '77656B3D7363686F77656B2E7265706C616365282F5C742F67692C20225C742022293B0D0A202020207661722077696572737A65203D207363686F77656B2E73706C6974282F5C6E2F6769293B0D0A202020200D0A2020202076617220636C6970426F61';
wwv_flow_api.g_varchar2_table(273) := '7264203D205B5D3B0D0A202020200D0A20202020766172206C69637A62615F77696572737A79203D2077696572737A652E6C656E6774683B0D0A20202020766172206C69637A62615F6B6F6C756D6E203D2077696572737A655B305D2E73706C6974282F';
wwv_flow_api.g_varchar2_table(274) := '5C742F6769292E6C656E6774683B0D0A202020200D0A20202020666F7220287661722078203D20303B2078203C206C69637A62615F77696572737A79203B20782B2B29207B0D0A202020202020636C6970426F6172645B785D203D205B5D3B0D0A202020';
wwv_flow_api.g_varchar2_table(275) := '202020666F7220287661722079203D20303B2079203C206C69637A62615F6B6F6C756D6E203B20792B2B29207B0D0A2020202020202020636C6970426F6172645B785D5B795D203D206E756C6C3B0D0A2020202020207D0D0A202020207D0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(276) := '2020666F722876617220783D303B783C77696572737A652E6C656E6774683B782B2B297B0D0A202020202020766172206B6F6C756D6E79203D2077696572737A655B785D2E73706C6974282F5C742F6769293B0D0A202020202020666F72287661722079';
wwv_flow_api.g_varchar2_table(277) := '3D303B793C6B6F6C756D6E792E6C656E6774683B792B2B297B0D0A2020202020202020636C6970426F6172645B785D5B795D203D20242E7472696D286B6F6C756D6E795B795D293B0D0A2020202020207D0D0A202020207D20200D0A2020202072657475';
wwv_flow_api.g_varchar2_table(278) := '726E20636C6970426F6172643B0D0A20207D0D0A20200D0A202066756E6374696F6E205F655F6D61736B5F706173746528706173746529207B0D0A202020200D0A2020202069636F6E50617374652E706F706F76657228276869646527293B0D0A202020';
wwv_flow_api.g_varchar2_table(279) := '2076617220696E7075745F74657874203D206A517565727950414C2874686973293B0D0A20202020766172207461626C653264203D205B5D3B0D0A202020200D0A202020206D61736B2E6461746128276576656E745061737465272C2074727565293B0D';
wwv_flow_api.g_varchar2_table(280) := '0A202020200D0A202020207461626C653264203D2069734D534945203F205F676574436C6970426F6172644173417272617932442877696E646F772E636C6970626F617264446174612E67657444617461282254657874222929203A205F676574436C69';
wwv_flow_api.g_varchar2_table(281) := '70426F617264417341727261793244287061737465293B0D0A202020200D0A2020202069662028207461626C6532642E6C656E677468203E20302029207B0D0A2020202020206D61736B2E76616C286E756C6C293B0D0A202020207D0D0A202020200D0A';
wwv_flow_api.g_varchar2_table(282) := '20202020766172206E65775F617272203D205B5D3B0D0A202020200D0A20202020666F7220286920696E207461626C65326429207B0D0A2020202020206E65775F6172722E70757368287461626C6532645B695D5B305D293B0D0A202020207D0D0A2020';
wwv_flow_api.g_varchar2_table(283) := '20200D0A20202020766172207461626C6532645F737472696E67203D206E65775F6172722E6A6F696E2820736570617261746F7220293B0D0A202020200D0A2020202069662028207461626C6532645F737472696E672E6C656E677468203E206F707469';
wwv_flow_api.g_varchar2_table(284) := '6F6E732E5F6D6178436861727329207B0D0A2020202020200D0A2020202020206966202821636F6E6669726D2820287472616E736C6174696F6E732E5041454C495F5041535445445F4C454E475448292E7265706C6163652827236C696D697423272C20';
wwv_flow_api.g_varchar2_table(285) := '6F7074696F6E732E5F6D6178436861727329202929207B0D0A20202020202020205F6D61736B5F72657365745F6461746128293B0D0A20202020202020205F6D61736B5F7365745F76616C7565286E756C6C293B0D0A20202020202020206D61736B2E74';
wwv_flow_api.g_varchar2_table(286) := '72696767657228276368616E676527293B0D0A20202020202020200D0A202020202020202072657475726E206E756C6C3B0D0A2020202020207D0D0A2020202020206E65775F617272203D2066696E616C537472696E6728207461626C6532645F737472';
wwv_flow_api.g_varchar2_table(287) := '696E6720292E73706C69742820736570617261746F7220293B0D0A20202020202069636F6E50617374652E706F706F76657228276869646527293B0D0A202020207D0D0A202020200D0A202020205F6D61736B5F7365745F6461746128207B2770617374';
wwv_flow_api.g_varchar2_table(288) := '65645F76616C756573273A206E65775F617272207D20293B0D0A202020205F6D61736B5F7365745F76616C756528206E65775F6172725B305D20293B0D0A0D0A20202020696620286E65775F6172722E6C656E677468203D3D203129207B0D0A20202020';
wwv_flow_api.g_varchar2_table(289) := '20200D0A202020202020696620286F7074696F6E732E5F6175746F66696C746572203D3D2027592729207B0D0A20202020202020206D61736B2E6461746128276576656E745061737465272C2066616C7365293B0D0A20202020202020206D61736B2E74';
wwv_flow_api.g_varchar2_table(290) := '72696767657228276368616E676527293B20200D0A20202020202020206D61736B2E7472696767657228276B6579757027293B0D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020205F69636F6E5F70617374655F73686F77';
wwv_flow_api.g_varchar2_table(291) := '28293B0D0A20202020202020206D61736B2E7472696767657228276368616E676527293B20200D0A2020202020207D0D0A202020207D0D0A20202020656C7365207B0D0A2020202020205F69636F6E5F70617374655F73686F7728293B0D0A2020202020';
wwv_flow_api.g_varchar2_table(292) := '206D61736B2E7472696767657228276368616E676527293B20200D0A202020207D0D0A202020200D0A202020200D0A202020200D0A202020200D0A202020200D0A2020202072657475726E206E756C6C3B0D0A20207D0D0A200D0A202066756E6374696F';
wwv_flow_api.g_varchar2_table(293) := '6E205F655F6D61736B5F6368616E676528297B202020200D0A202020200D0A202020200D0A202020200D0A20202020696620286A517565727950414C282723272B73656C6563746F725F70726F6D7074416A6178436F6E7461696E65722B273A68617328';
wwv_flow_api.g_varchar2_table(294) := '7461626C652927292E73697A6528293E3029207B0D0A2020202020200D0A20202020202072657475726E2066616C73653B0D0A202020207D0D0A202020200D0A20202020696620286D61736B2E6461746128277061737465645F76616C75657327292E6C';
wwv_flow_api.g_varchar2_table(295) := '656E677468203D3D20302029207B0D0A2020202020202F2F617065782E646562756728275041454C49202D206D61736B202D206576656E7420226368616E676522202D206E612064617461207061737465642C20686964652069636F6E20706173746527';
wwv_flow_api.g_varchar2_table(296) := '293B0D0A2020202020205F69636F6E5F70617374655F6869646528293B0D0A202020207D0D0A202020200D0A20202020696620286D61736B2E6461746128277061737465645F76616C75657327292E6C656E677468203E20302029207B0D0A2020202020';
wwv_flow_api.g_varchar2_table(297) := '202F2F617065782E646562756728275041454C49202D206D61736B202D206576656E7420226368616E676522202D20736574207061737465642076616C75657327293B0D0A202020202020706C7567696E2E76616C28206D61736B2E6461746128277061';
wwv_flow_api.g_varchar2_table(298) := '737465645F76616C75657327292E6A6F696E2820736570617261746F72202920293B0D0A202020207D0D0A202020200D0A20202020656C73652069662028206D61736B2E64617461282773696E676C655F76616C7565272920213D206E756C6C29207B0D';
wwv_flow_api.g_varchar2_table(299) := '0A2020202020202F2F617065782E646562756728275041454C49202D206D61736B202D206576656E7420226368616E676522202D2073696E676C652076616C756527293B0D0A202020202020706C7567696E2E76616C28206D61736B2E64617461282773';
wwv_flow_api.g_varchar2_table(300) := '696E676C655F76616C7565272920293B0D0A2020202020202F2F617065782E646562756728275041454C49202D206D61736B202D206576656E7420226368616E676522202D20706C7567696E207365742076616C7565203D2022272B6D61736B2E646174';
wwv_flow_api.g_varchar2_table(301) := '61282773696E676C655F76616C756527292B272227293B0D0A202020207D0D0A20202020656C7365207B0D0A2020202020202F2F617065782E646562756728275041454C49202D206D61736B202D206576656E7420226368616E676522202D206D61736B';
wwv_flow_api.g_varchar2_table(302) := '206368616E676564206D616E75616C6C7927293B0D0A202020202020706C7567696E2E76616C28206D61736B2E76616C282920293B0D0A202020207D0D0A202020200D0A20202020617065782E6576656E742E7472696767657228706C7567696E2C2027';
wwv_flow_api.g_varchar2_table(303) := '6368616E6765272C66616C7365293B0D0A202020200D0A20207D20200D0A20200D0A20200D0A202066756E6374696F6E205F616A61785F68656C7065725F63726561746528297B0D0A2020202076617220646976436F6E7461696E6572203D202428646F';
wwv_flow_api.g_varchar2_table(304) := '63756D656E742E637265617465456C656D656E7428276469762729293B0D0A0D0A20202020646976436F6E7461696E65722E61747472287B0D0A202020202020276964273A2073656C6563746F725F70726F6D7074416A6178436F6E7461696E65722C0D';
wwv_flow_api.g_varchar2_table(305) := '0A202020202020276974656D273A2069640D0A202020207D292E64617461287B0D0A202020202020276D61736B273A206A517565727950414C286D61736B292C0D0A20202020202027736570617261746F72273A20736570617261746F720D0A20202020';
wwv_flow_api.g_varchar2_table(306) := '7D292E637373287B0D0A202020202020276D696E2D7769647468273A206D61736B2E6F75746572576964746828292C0D0A202020202020276D61782D7769647468273A2028242877696E646F77292E6F75746572576964746828292D6D61736B2E6F6666';
wwv_flow_api.g_varchar2_table(307) := '73657428292E6C656674292A302E392C0D0A20202020202027746F70273A206D61736B2E6F666673657428292E746F702B6D61736B2E6F7574657248656967687428292C0D0A202020202020276C656674273A206D61736B2E6F666673657428292E6C65';
wwv_flow_api.g_varchar2_table(308) := '66740D0A0D0A202020207D293B0D0A202020200D0A2020202072657475726E20646976436F6E7461696E65723B0D0A20207D0D0A20200D0A202066756E6374696F6E205F616A61785F6D61736B5F6175746F66696C7465725F63616C6C6261636B286461';
wwv_flow_api.g_varchar2_table(309) := '746129207B0D0A0D0A20202020766172200D0A202020202020646976436F6E7461696E6572203D205F616A61785F68656C7065725F63726561746528292C0D0A202020202020616A61785F72657475726E203D20646174612C2020200D0A202020202020';
wwv_flow_api.g_varchar2_table(310) := '696E707574203D206D61736B2C0D0A2020202020202F2F6D757374616368652074656D706C617465730D0A20202020202074656D706C617465203D2027272C0D0A20202020202074656D706C6174655F686561646572203D2027272C0D0A202020202020';
wwv_flow_api.g_varchar2_table(311) := '74656D706C6174655F666F6F746572203D2027272C0D0A20202020202072657475726E5F636F6C203D206F7074696F6E732E5F72657475726E436F6C6C756D6E2C0D0A20202020202073656C6563745F616C6C5F7464203D20273C747220636C6173733D';
wwv_flow_api.g_varchar2_table(312) := '2273656C656374416C6C56616C756573223E3C7464272B202872657475726E5F636F6C203D3D20275927203F202720636F6C7370616E3D22322227203A20272729202B273E20272B7472616E736C6174696F6E732E5041454C495F53454C4543545F414C';
wwv_flow_api.g_varchar2_table(313) := '4C5F4155544F46494C5445522B27203C2F74643E3C2F74723E20272C0D0A2020202020206F7574707574203D206E756C6C2C0D0A20202020202073656C6563746564203D206E756C6C3B0D0A202020200D0A2020202069662028616A61785F7265747572';
wwv_flow_api.g_varchar2_table(314) := '6E2E6572726F722E6572726F72203D3D2031207C7C20616A61785F72657475726E2E6572726F722E6572726F72203D3D2027312729207B0D0A202020202020646973706C61794572726F7246726F6D416A61782820616A61785F72657475726E20293B0D';
wwv_flow_api.g_varchar2_table(315) := '0A20202020202072657475726E2066616C73653B0D0A202020207D0D0A20202020656C7365207B0D0A2020202020200D0A2020202020206966202820616A61785F72657475726E2E76616C7565732E6C656E677468203D3D20302029207B0D0A20202020';
wwv_flow_api.g_varchar2_table(316) := '2020202074656D706C617465203D20273C7370616E20636C6173733D226E6F2D646174612D666F756E64223E272B7472616E736C6174696F6E732E5041454C495F4155544F46494C5445525F4E44462B2720223C693E272B28616A61785F72657475726E';
wwv_flow_api.g_varchar2_table(317) := '2E696E7075742E705F736561726368292B273C2F693E223C7370616E3E273B0D0A2020202020207D0D0A202020202020656C7365207B0D0A0D0A202020202020202074656D706C6174655F686561646572203D20273C7461626C652063656C6C73706163';
wwv_flow_api.g_varchar2_table(318) := '696E673D2230222063656C6C70616464696E673D2230223E273B2F2F273C7461626C652063656C6C73706163696E673D2230222063656C6C70616464696E673D2230223E272B2872657475726E5F636F6C203D3D20275927203F20273C74723E3C74683E';
wwv_flow_api.g_varchar2_table(319) := '52657475726E3C2F74683E3C74683E446973706C61793C2F74683E3C2F74723E27203A202727293B0D0A202020202020202074656D706C6174655F686561646572202B3D202820616A61785F72657475726E2E6175746F66696C7465722E736561726368';
wwv_flow_api.g_varchar2_table(320) := '4D756C7469706C65203D3D2074727565203F2073656C6563745F616C6C5F7464203A20272720293B0D0A0D0A202020202020202074656D706C617465203D204D757374616368652E72656E6465722827270D0A202020202020202020202B277B7B237661';
wwv_flow_api.g_varchar2_table(321) := '6C7565737D7D270D0A202020202020202020202B2720203C74723E270D0A202020202020202020202B2020202020273C746420636C6173733D2272657475726E2220272B282072657475726E5F636F6C203D3D20275927203F202727203A20277374796C';
wwv_flow_api.g_varchar2_table(322) := '653D22646973706C61793A6E6F6E652227292B273E7B7B727D7D3C2F74643E270D0A202020202020202020202B27202020203C74642020636C6173733D22646973706C6179223E7B7B647D7D3C2F74643E270D0A202020202020202020202B2720203C2F';
wwv_flow_api.g_varchar2_table(323) := '74723E270D0A202020202020202020202B277B7B2F76616C7565737D7D272C20616A61785F72657475726E293B0D0A202020202020202020200D0A202020202020202074656D706C6174655F666F6F746572203D20273C2F7461626C653E273B0D0A2020';
wwv_flow_api.g_varchar2_table(324) := '202020207D0D0A2020202020206F7574707574203D20273C6469763E272B74656D706C6174655F6865616465722B74656D706C6174652B74656D706C6174655F666F6F7465722B273C2F6469763E273B0D0A202020207D0D0A202020200D0A2020202064';
wwv_flow_api.g_varchar2_table(325) := '6976436F6E7461696E65722E68746D6C28206F757470757420293B0D0A202020200D0A2020202073656C6563746564203D20646976436F6E7461696E65722E66696E6428272E73656C656374416C6C56616C75657327292E73697A652829203D3D203020';
wwv_flow_api.g_varchar2_table(326) := '3F20646976436F6E7461696E65722E66696E642827747227292E666972737428276E6F743A686173287468292729203A20646976436F6E7461696E65722E66696E6428272E73656C656374416C6C56616C75657327293B0D0A2020202073656C65637465';
wwv_flow_api.g_varchar2_table(327) := '642E616464436C6173732827686F76657227293B0D0A202020200D0A202020205F616A61785F68656C7065725F72656D6F766528293B0D0A202020205F616A61785F68656C7065725F6164642820646976436F6E7461696E657220293B0D0A202020200D';
wwv_flow_api.g_varchar2_table(328) := '0A202020206D61736B2E64617461287B0D0A2020202020202770726F6D7074273A20646976436F6E7461696E65722C0D0A2020202020202773656C6563746564273A2073656C65637465640D0A202020207D293B0D0A202020200D0A202020205F69636F';
wwv_flow_api.g_varchar2_table(329) := '6E5F6C6F6164696E675F6869646528293B0D0A202020205F69636F6E5F747269676765725F73686F7728293B0D0A20207D202020200D0A20200D0A202066756E6374696F6E205F616A61785F68656C7065725F6164642820656C656D20297B0D0A202020';
wwv_flow_api.g_varchar2_table(330) := '202F2F6974656D5F636F6E7461696E65722E617070656E642820656C656D20293B0D0A2020202076617220626F6479203D20242827626F647927293B0D0A20202020656C656D203D20626F64792E617070656E642820656C656D20292E66696E64282065';
wwv_flow_api.g_varchar2_table(331) := '6C656D20293B0D0A0D0A20202020656C656D2E637373287B0D0A202020202020276D6178486569676874273A20656C656D2E66696E6428272E6E6F2D646174612D666F756E6427292E73697A652829203E2030203F20656C656D2E66696E6428272E6E6F';
wwv_flow_api.g_varchar2_table(332) := '2D646174612D666F756E6427292E6F757465724865696768742829203A2020656C656D2E66696E642827747227292E666972737428292E6F7574657248656967687428292A350D0A202020207D293B0D0A0D0A20202020617065782E6576656E742E7472';
wwv_flow_api.g_varchar2_table(333) := '69676765722820706C7567696E2C2027706C7567696E5F68656C7065725F706F706564272C205F706C7567696E5F747269676765725F646174612820656C656D2029293B0D0A20207D0D0A20200D0A202066756E6374696F6E205F616A61785F68656C70';
wwv_flow_api.g_varchar2_table(334) := '65725F72656D6F766528297B0D0A20202020242827626F647927292E66696E64282723272B73656C6563746F725F70726F6D7074416A6178436F6E7461696E6572292E72656D6F766528293B0D0A20207D0D0A200D0A20200D0A202066756E6374696F6E';
wwv_flow_api.g_varchar2_table(335) := '205F655F6D61736B5F6B657970726573732865297B0D0A202020200D0A202020200D0A202020200D0A20202020652E73746F7050726F7061676174696F6E28293B0D0A202020200D0A202020206966202820652E6B6579436F646520213D203133202920';
wwv_flow_api.g_varchar2_table(336) := '7B0D0A0D0A2020202020200D0A20202020202072657475726E20766F69642830293B0D0A202020207D0D0A20202020200D0A202020202F2F77796B7279746F20656E74657220776965632070727A65747761727A616D792064616C656A0D0A2020202069';
wwv_flow_api.g_varchar2_table(337) := '662028206A517565727950414C282478282073656C6563746F725F70726F6D7074416A6178436F6E7461696E65722029292E697328273A686173287461626C652927292029207B0D0A2020202020207661722073656C6563746564203D206A5175657279';
wwv_flow_api.g_varchar2_table(338) := '50414C286D61736B2E64617461282773656C65637465642729293B0D0A20202020202076617220706172656E74446976203D206A517565727950414C286D61736B2E64617461282770726F6D70742729293B0D0A2020202020207661722076616C756573';
wwv_flow_api.g_varchar2_table(339) := '203D206E756C6C3B0D0A0D0A202020202020696620282073656C65637465642E697328272E73656C656374416C6C56616C75657327292029207B0D0A202020202020202076616C756573203D206A517565727950414C2E6D61702820706172656E744469';
wwv_flow_api.g_varchar2_table(340) := '762E66696E6428272E72657475726E27292C2066756E6374696F6E28656C656D2C20696E646578297B0D0A2020202020202020202072657475726E202428656C656D292E7465787428293B0D0A20202020202020207D293B0D0A0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(341) := '6D61736B2E74726967676572282773657456616C756546726F6D50726F6D7074272C200D0A202020202020202020207B0D0A20202020202020202020202027646973706C61795F76616C7565273A20706172656E744469762E66696E6428272E64697370';
wwv_flow_api.g_varchar2_table(342) := '6C617927292E666972737428292E7465787428292C0D0A2020202020202020202020202772657475726E5F76616C7565273A2076616C7565732E6A6F696E2820706172656E744469762E646174612827736570617261746F72272920290D0A2020202020';
wwv_flow_api.g_varchar2_table(343) := '20202020207D0D0A2020202020202020293B20200D0A0D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020206D61736B2E74726967676572282773657456616C756546726F6D50726F6D7074272C207B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(344) := '202020646973706C61795F76616C75653A2073656C65637465642E66696E6428272E646973706C617927292E7465787428292C0D0A2020202020202020202072657475726E5F76616C75653A2073656C65637465642E66696E6428272E72657475726E27';
wwv_flow_api.g_varchar2_table(345) := '292E7465787428290D0A20202020202020207D293B0D0A2020202020207D2020202020200D0A2020202020200D0A20202020202072657475726E20766F69642830293B0D0A2020202020200D0A202020207D0D0A20202020656C7365207B0D0A20202020';
wwv_flow_api.g_varchar2_table(346) := '202069662028206F7074696F6E732E5F7375626D697450616765203D3D2027592720297B0D0A2020202020202020617065782E7375626D6974287B726571756573743A2069642C2073686F77576169743A20286F7074696F6E732E5F73686F7750726F63';
wwv_flow_api.g_varchar2_table(347) := '657373696E67203D3D2027592729207D293B0D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020200D0A202020202020202072657475726E2066616C73653B0D0A2020202020207D0D0A202020207D0D0A0D0A202020200D0A';
wwv_flow_api.g_varchar2_table(348) := '202020200D0A20207D0D0A0D0A202066756E6374696F6E205F616A61785F6D61736B5F6175746F66696C74657228297B0D0A0D0A20202020696620286F7074696F6E732E5F6175746F66696C746572203D3D20274E2729207B0D0A202020202020726574';
wwv_flow_api.g_varchar2_table(349) := '75726E20766F69642830293B0D0A202020207D0D0A202020200D0A202020205F616A61785F61626F72745F70726576696F757328293B0D0A202020205F69636F6E5F6C6F6164696E675F73686F7728293B0D0A202020205F69636F6E5F74726967676572';
wwv_flow_api.g_varchar2_table(350) := '5F6869646528293B0D0A202020200D0A2020202076617220646174614F7074696F6E73203D207B0D0A2020202020206D6F64653A20276175746F66696C746572272C0D0A2020202020207365617263683A205F6D61736B5F6765745F76616C756528290D';
wwv_flow_api.g_varchar2_table(351) := '0A202020207D0D0A202020200D0A2020202076617220786872203D20242E616A6178287B0D0A20202020202075726C3A277777765F666C6F772E73686F77272C0D0A202020202020747970653A27706F7374272C0D0A2020202020206461746154797065';
wwv_flow_api.g_varchar2_table(352) := '3A276A736F6E272C0D0A202020202020747261646974696F6E616C3A20747275652C0D0A202020202020646174613A20616A61784461746128646174614F7074696F6E73292C0D0A2020202020206572726F723A2066756E6374696F6E28206A71584852';
wwv_flow_api.g_varchar2_table(353) := '2C20746578745374617475732C206572726F725468726F776E20297B0D0A20202020202020206966202874657874537461747573203D3D202761626F72742729207B0D0A2020202020202020202072657475726E20766F69642830293B0D0A2020202020';
wwv_flow_api.g_varchar2_table(354) := '2020207D0D0A20202020202020205F69636F6E5F6C6F6164696E675F6869646528293B0D0A20202020202020205F69636F6E5F747269676765725F73686F7728293B0D0A20202020202020200D0A2020202020202020646973706C61794572726F725061';
wwv_flow_api.g_varchar2_table(355) := '7273654A534F4E28274175746F66696C746572206572726F723A2028272B746578745374617475732B272920272B6572726F725468726F776E293B0D0A20202020202020200D0A2020202020207D2C0D0A202020202020737563636573733A2066756E63';
wwv_flow_api.g_varchar2_table(356) := '74696F6E2820616A61785F72657475726E20297B200D0A20202020202020205F69636F6E5F6C6F6164696E675F6869646528293B0D0A20202020202020205F69636F6E5F747269676765725F73686F7728293B0D0A20202020202020200D0A2020202020';
wwv_flow_api.g_varchar2_table(357) := '2020205F616A61785F6D61736B5F6175746F66696C7465725F63616C6C6261636B2820616A61785F72657475726E20293B0D0A2020202020207D0D0A202020207D293B0D0A202020200D0A202020205F616A61785F7365745F63757272656E745F726571';
wwv_flow_api.g_varchar2_table(358) := '75657374282078687220293B0D0A20207D0D0A20200D0A202066756E6374696F6E205F6D61736B5F69735F70726F6D707428297B0D0A2020202069662028206D61736B2E64617461282770726F6D70742729203D3D206E756C6C207C7C206D61736B2E64';
wwv_flow_api.g_varchar2_table(359) := '617461282770726F6D70742729203D3D20756E646566696E65642029207B0D0A20202020202072657475726E2066616C73653B0D0A202020207D0D0A202020200D0A2020202072657475726E20747275653B0D0A20207D0D0A20200D0A202066756E6374';
wwv_flow_api.g_varchar2_table(360) := '696F6E205F655F6D61736B5F72656D6F766550726F6D707428646F65735F6D61735F6368616E6765297B0D0A202020200D0A2020202024286D61736B2E64617461282770726F6D70742729292E72656D6F766528293B0D0A202020206D61736B2E646174';
wwv_flow_api.g_varchar2_table(361) := '6128207B2770726F6D7074273A206E756C6C2C202773656C6563746564273A206E756C6C7D20293B0D0A202020200D0A2020202069662028646F65735F6D61735F6368616E676529207B0D0A2020202020202F2F617065782E646562756728275041454C';
wwv_flow_api.g_varchar2_table(362) := '49202D206D61736B202D206576656E74202272656D6F766550726F6D707422202D2074726967676572206D61736B206368616E676527293B0D0A2020202020206D61736B2E7472696767657228276368616E676527293B0D0A202020207D0D0A20202020';
wwv_flow_api.g_varchar2_table(363) := '2F2F637A7920747520706F77696E69656E2062796320747269676765723F0D0A20202020617065782E6576656E742E747269676765722820706C7567696E2C2027706C7567696E5F68656C7065725F72656D6F76656427293B0D0A202020200D0A202020';
wwv_flow_api.g_varchar2_table(364) := '200D0A20207D0D0A20200D0A202066756E6374696F6E205F655F6D61736B5F6B61797570286529207B0D0A202020200D0A20202020696620286D61736B2E6461746128276576656E74506173746527292029207B0D0A2020202020202F2F617065782E64';
wwv_flow_api.g_varchar2_table(365) := '6562756728275041454C49202D206D61736B202D206576656E7420226B6579757022202D206576656E7420706173746520696E2070726F677265737327293B0D0A2020202020200D0A2020202020206966202820652E6B6579436F6465203D3D20313720';
wwv_flow_api.g_varchar2_table(366) := '29207B0D0A20202020202020206D61736B2E6461746128207B276576656E745061737465273A2066616C73657D20293B0D0A20202020202020200D0A20202020202020200D0A202020202020202072657475726E2066616C73653B0D0A2020202020200D';
wwv_flow_api.g_varchar2_table(367) := '0A2020202020207D0D0A20202020202072657475726E2066616C73653B0D0A202020207D0D0A0D0A202020206966202820652E6B6579436F6465203D3D2031372029207B0D0A2020202020206D61736B2E6461746128207B276374726C273A2066616C73';
wwv_flow_api.g_varchar2_table(368) := '657D293B0D0A0D0A202020202020696620286D61736B2E64617461282773656C656374416C6C272929207B0D0A20202020202020206D61736B2E64617461282773656C656374416C6C272C2066616C7365293B20200D0A20202020202020207265747572';
wwv_flow_api.g_varchar2_table(369) := '6E2066616C73653B0D0A2020202020207D0D0A202020207D0D0A202020202F2F73656C65637420616C6C0D0A202020206966202820652E6B6579436F6465203D3D203635202626206D61736B2E6461746128276374726C272929207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(370) := '6D61736B2E64617461282773656C656374416C6C272C2074727565293B0D0A20202020202072657475726E2066616C73653B0D0A202020207D0D0A202020200D0A202020200D0A202020206D61736B2E64617461287B0D0A202020202020276576656E74';
wwv_flow_api.g_varchar2_table(371) := '5061737465273A2066616C73652C0D0A202020202020277061737465645F76616C756573273A205B5D2C0D0A2020202020202773696E676C655F76616C7565273A205F6D61736B5F6765745F76616C756528290D0A202020207D293B0D0A202020200D0A';
wwv_flow_api.g_varchar2_table(372) := '202020202F2F5F69636F6E5F70617374655F6869646528293B0D0A20200D0A202020206966202820242E696E417272617928652E6B6579436F64652C206E61766967617465436F64657329203E202D312029207B0D0A2020202020200D0A202020202020';
wwv_flow_api.g_varchar2_table(373) := '0D0A20202020202072657475726E2066616C73653B0D0A2020202020200D0A202020207D0D0A20202020656C7365207B0D0A2020202020200D0A2020202020206966202820652E6B6579436F6465203D3D20382029207B0D0A20202020202020202F2F61';
wwv_flow_api.g_varchar2_table(374) := '7065782E646562756728275041454C49202D206D61736B202D206576656E7420226B6579757022202D20286261636B73706163652927293B0D0A20202020202020205F616A61785F61626F72745F70726576696F757328293B0D0A2020202020207D0D0A';
wwv_flow_api.g_varchar2_table(375) := '2020202020200D0A202020202020656C7365206966202820652E6B6579436F6465203D3D2031332029207B0D0A20202020202020202F2F617065782E646562756728275041454C49202D206D61736B202D206576656E7420226B6579757022202D20454E';
wwv_flow_api.g_varchar2_table(376) := '442028656E7465722927293B0D0A202020202020202072657475726E20766F69642830293B0D0A2020202020207D0D0A2020202020200D0A202020202020656C7365206966202820652E6B6579436F6465203D3D2032372029207B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(377) := '205F655F6D61736B5F72656D6F766550726F6D707428293B0D0A20202020202020205F616A61785F61626F72745F70726576696F757328293B0D0A20202020202020202F2F617065782E646562756728275041454C49202D206D61736B202D206576656E';
wwv_flow_api.g_varchar2_table(378) := '7420226B6579757022202D20454E4420286573636170652927293B0D0A202020202020202072657475726E20766F69642830293B0D0A2020202020207D0D0A2020202020200D0A20202020202069662028205F6D61736B5F6765745F76616C756528292E';
wwv_flow_api.g_varchar2_table(379) := '6C656E677468203D3D20302029207B0D0A20202020202020202F2F617065782E646562756728275041454C49202D206D61736B202D206576656E7420226B6579757022202D2030206C656E677468202D3E2072656D6F766550726F6D707427293B0D0A20';
wwv_flow_api.g_varchar2_table(380) := '202020202020200D0A20202020202020205F655F6D61736B5F72656D6F766550726F6D707428293B0D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020205F655F6D61736B5F72656D6F766550726F6D707428293B0D0A2020';
wwv_flow_api.g_varchar2_table(381) := '2020202020205F616A61785F6D61736B5F6175746F66696C74657228293B0D0A2020202020207D0D0A202020200D0A20200D0A202020207D0D0A202020200D0A202020200D0A20207D0D0A0D0A202066756E6374696F6E205F6D61736B5F70726F6D7074';
wwv_flow_api.g_varchar2_table(382) := '5F6E61766967617465446F776E2820656C656D2029207B0D0A20202020766172200D0A2020202020206E657874456C656D203D206E756C6C2C0D0A20202020202070726F6D7074203D2024286D61736B2E64617461282770726F6D70742729292C0D0A20';
wwv_flow_api.g_varchar2_table(383) := '202020202074725F686569676874203D2070726F6D70742E66696E642827747227292E666972737428292E6F7574657248656967687428293B0D0A202020200D0A202020200D0A2020202069662028656C656D203D3D206E756C6C207C7C20656C656D20';
wwv_flow_api.g_varchar2_table(384) := '3D3D20756E646566696E656429207B0D0A202020202020656C656D203D2024282774723A6E6F74283A68617328746829293A6669727374272C2070726F6D707420293B0D0A202020207D0D0A20202020656C7365207B0D0A202020202020656C656D203D';
wwv_flow_api.g_varchar2_table(385) := '202428656C656D293B0D0A202020207D0D0A202020200D0A2020202069662028656C656D2E697328272E686F766572272929207B0D0A2020202020206E657874456C656D203D20656C656D2E6E65787428293B0D0A0D0A202020202020696620286E6578';
wwv_flow_api.g_varchar2_table(386) := '74456C656D2E73697A652829203D3D203029207B0D0A20202020202020200D0A20202020202020206E657874456C656D203D202428656C656D2E70726576416C6C28273A6E6F74283A68617328746829293A6C6173742729292E73697A652829203D3D20';
wwv_flow_api.g_varchar2_table(387) := '30203F20656C656D203A202428656C656D2E70726576416C6C28273A6E6F74283A68617328746829293A6C6173742729293B0D0A20202020202020200D0A2020202020207D0D0A2020202020200D0A20202020202070726F6D70742E7363726F6C6C546F';
wwv_flow_api.g_varchar2_table(388) := '7028206E657874456C656D2E70726576416C6C28273A6E6F74283A686173287468292927292E73697A6528292A74725F68656967687420293B0D0A2020202020200D0A202020202020656C656D2E72656D6F7665436C6173732827686F76657227293B0D';
wwv_flow_api.g_varchar2_table(389) := '0A2020202020206E657874456C656D2E616464436C6173732827686F76657227293B0D0A2020202020200D0A2020202020206D61736B2E64617461282773656C6563746564272C206E657874456C656D293B0D0A202020207D0D0A20202020656C736520';
wwv_flow_api.g_varchar2_table(390) := '7B0D0A202020202020656C656D2E616464436C6173732827686F76657227293B0D0A2020202020206D61736B2E64617461282773656C6563746564272C20656C656D293B0D0A202020207D0D0A20207D0D0A20200D0A202066756E6374696F6E205F6D61';
wwv_flow_api.g_varchar2_table(391) := '736B5F70726F6D70745F6E6176696761746555702820656C656D2029207B0D0A20202020766172206E657874456C656D203D206E756C6C3B0D0A202020207661722070726F6D7074203D2024286D61736B2E64617461282770726F6D70742729293B0D0A';
wwv_flow_api.g_varchar2_table(392) := '202020200D0A202020207661722074725F686569676874203D2070726F6D70742E66696E642827747227292E666972737428292E6F7574657248656967687428293B0D0A202020200D0A2020202069662028656C656D203D3D206E756C6C207C7C20656C';
wwv_flow_api.g_varchar2_table(393) := '656D203D3D20756E646566696E656429207B0D0A202020202020656C656D203D2024282774723A6C617374272C2070726F6D707420293B0D0A202020207D0D0A20202020656C7365207B0D0A202020202020656C656D203D202428656C656D293B0D0A20';
wwv_flow_api.g_varchar2_table(394) := '2020207D0D0A202020200D0A2020202069662028656C656D2E697328272E686F766572272929207B0D0A2020202020206E657874456C656D203D20656C656D2E7072657628273A6E6F74283A686173287468292927293B0D0A0D0A202020202020696620';
wwv_flow_api.g_varchar2_table(395) := '286E657874456C656D2E73697A652829203D3D203029207B0D0A20202020202020206E657874456C656D203D202428656C656D2E6E657874416C6C28273A6C6173742729292E73697A652829203D3D2030203F20656C656D203A202428656C656D2E6E65';
wwv_flow_api.g_varchar2_table(396) := '7874416C6C28273A6C6173742729293B0D0A2020202020207D0D0A2020202020200D0A20202020202070726F6D70742E7363726F6C6C546F7028206E657874456C656D2E70726576416C6C28273A6E6F74283A686173287468292927292E73697A652829';
wwv_flow_api.g_varchar2_table(397) := '2A74725F68656967687420293B0D0A202020202020656C656D2E72656D6F7665436C6173732827686F76657227293B0D0A2020202020206E657874456C656D2E616464436C6173732827686F76657227293B0D0A2020202020200D0A2020202020206D61';
wwv_flow_api.g_varchar2_table(398) := '736B2E64617461282773656C6563746564272C206E657874456C656D293B0D0A202020207D0D0A20202020656C7365207B0D0A202020202020656C656D2E616464436C6173732827686F76657227293B0D0A2020202020206D61736B2E64617461282773';
wwv_flow_api.g_varchar2_table(399) := '656C6563746564272C20656C656D293B0D0A202020207D0D0A20207D20200D0A20200D0A20202F2A0D0A2020202066756E6B636A61205F655F6D61736B5F6B6179646F776E0D0A2020202070727A657A6E61637A656E69653A207779636877797477616E';
wwv_flow_api.g_varchar2_table(400) := '696520637A79207A6F737461C58220776369C59B6E69C4997479206B6C617769737A20656E7465722C206F72617A20646F206F6273C582756769206E6177696761636A6920766961207374727A61C5826B690D0A20202A2F0D0A202066756E6374696F6E';
wwv_flow_api.g_varchar2_table(401) := '205F655F6D61736B5F6B6179646F776E286529207B0D0A202020200D0A202020206966202820652E6B6579436F6465203D3D2031372029207B0D0A2020202020206D61736B2E6461746128276374726C272C2074727565293B0D0A2020202020200D0A20';
wwv_flow_api.g_varchar2_table(402) := '2020207D0D0A0D0A202020202F2F617065782E646562756728275041454C49202D206D61736B202D206576656E7420226B6579646F776E22202D20535441525427293B0D0A202020200D0A202020206966202820242E696E417272617928652E6B657943';
wwv_flow_api.g_varchar2_table(403) := '6F64652C205B31332C20395D29203C203020262620242E696E417272617928652E6B6579436F64652C206E61766967617465436F64657329203C20302029207B0D0A2020202020202F2F617065782E646562756728275041454C49202D206D61736B202D';
wwv_flow_api.g_varchar2_table(404) := '206576656E7420226B6579646F776E22202D20454E4420286E6F7468696E6720746F20646F2927293B0D0A20202020202072657475726E20766F69642830293B0D0A202020207D0D0A202020200D0A202020206966202820652E6B6579436F6465203D3D';
wwv_flow_api.g_varchar2_table(405) := '20392029207B0D0A2020202020206D61736B2E74726967676572282772656D6F766550726F6D707427293B0D0A202020207D0D0A202020206966202820652E6B6579436F6465203D3D2031332029207B0D0A202020202020652E70726576656E74446566';
wwv_flow_api.g_varchar2_table(406) := '61756C7428293B0D0A2020202020202F2F0D0A2020202020202F2F6966202821242E62726F777365722E6D6F7A696C6C6129207B0D0A20202020202020205F655F6D61736B5F6B657970726573732865293B0D0A2020202020202F2F7D0D0A202020207D';
wwv_flow_api.g_varchar2_table(407) := '0D0A202020200D0A202020206966202820242E696E417272617928652E6B6579436F64652C206E61766967617465436F64657329203E202D312029207B0D0A0D0A20202020202069662028205F6D61736B5F69735F70726F6D707428292029207B0D0A20';
wwv_flow_api.g_varchar2_table(408) := '202020202020206966202820652E6B6579436F6465203D3D2033382029207B0D0A202020202020202020205F6D61736B5F70726F6D70745F6E61766967617465557028206D61736B2E64617461282773656C6563746564272920293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(409) := '202020200D0A20202020202020207D0D0A2020202020202020656C7365206966202820652E6B6579436F6465203D3D2034302029207B0D0A202020202020202020205F6D61736B5F70726F6D70745F6E61766967617465446F776E28206D61736B2E6461';
wwv_flow_api.g_varchar2_table(410) := '7461282773656C6563746564272920293B0D0A20202020202020207D0D0A20202020202020200D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020202F2F6E6965206D612070726F6D70740D0A202020202020202069662028';
wwv_flow_api.g_varchar2_table(411) := '205F6D61736B5F6765745F76616C756528292E6C656E67746820213D20302029207B0D0A202020202020202020205F616A61785F6D61736B5F6175746F66696C74657228293B0D0A20202020202020207D0D0A2020202020207D0D0A202020207D0D0A20';
wwv_flow_api.g_varchar2_table(412) := '2020202F2F617065782E646562756728275041454C49202D206D61736B202D206576656E7420226B6579646F776E22202D20454E4427293B0D0A20207D0D0A0D0A0D0A202066756E6374696F6E20676574416C6C4D61736B28652C2064617461297B0D0A';
wwv_flow_api.g_varchar2_table(413) := '20202020766172200D0A20202020202066616B65506C7567696E44617461203D20646174612C0D0A202020202020646174614F7074696F6E73203D207B0D0A20202020202020206D6F64653A2027676574416C6C4D61736B272C0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(414) := '7365617263683A20646174612E76616C7565730D0A2020202020207D2C0D0A202020202020786872203D206E756C6C3B0D0A0D0A20202020786872203D20242E616A6178287B0D0A20202020202075726C3A277777765F666C6F772E73686F77272C0D0A';
wwv_flow_api.g_varchar2_table(415) := '202020202020747970653A27706F7374272C0D0A20202020202064617461547970653A276A736F6E272C0D0A202020202020747261646974696F6E616C3A20747275652C0D0A202020202020737563636573733A2066756E6374696F6E2864617461297B';
wwv_flow_api.g_varchar2_table(416) := '200D0A20202020202020200D0A2020202020202020646174612E636F6C756D6E4E616D65203D2066616B65506C7567696E446174612E636F6C756D6E4E616D653B0D0A0D0A202020202020202024282066616B65506C7567696E446174612E726567696F';
wwv_flow_api.g_varchar2_table(417) := '6E20292E666972737428292E747269676765722827736574416C6C4D61736B272C2064617461293B0D0A202020202020202072657475726E20766F69642830293B0D0A0D0A2020202020207D2C0D0A202020202020646174613A20616A61784461746128';
wwv_flow_api.g_varchar2_table(418) := '646174614F7074696F6E73290D0A202020207D293B0D0A202020200D0A20202020706C7567696E2E646174612827616A61785F68616E646C6572272C20786872293B0D0A20207D0D0A0D0A202066756E6374696F6E205F70617273655F4A534F4E28206A';
wwv_flow_api.g_varchar2_table(419) := '736F6E3270617273652029207B0D0A202020200D0A20202020766172207061727365644A534F4E203D206E756C6C3B0D0A202020200D0A20202020747279207B0D0A2020202020207061727365644A534F4E203D20242E70617273654A534F4E28206A73';
wwv_flow_api.g_varchar2_table(420) := '6F6E32706172736520293B0D0A2020202020200D0A202020207D206361746368286572726F7229207B0D0A202020202020646973706C61794572726F7250617273654A534F4E28275768696C652070617273696E67204A534F4E20726573706F6E736520';
wwv_flow_api.g_varchar2_table(421) := '6572726F72206F6363757265643A20272B6572726F72293B0D0A20202020202072657475726E2066616C73653B0D0A202020207D0D0A202020200D0A2020202069662028207061727365644A534F4E2E6572726F722E6572726F72203D3D2031207C7C20';
wwv_flow_api.g_varchar2_table(422) := '7061727365644A534F4E2E6572726F722E6572726F72203D3D2027312729207B0D0A202020202020646973706C61794572726F7246726F6D416A617828207061727365644A534F4E20293B0D0A20202020202072657475726E2066616C73653B0D0A2020';
wwv_flow_api.g_varchar2_table(423) := '20207D0D0A202020200D0A20202020696620287061727365644A534F4E2E6572726F722E6572726F72203D3D2032207C7C207061727365644A534F4E2E6572726F722E6572726F72203D3D2027322729207B0D0A202020202020646973706C6179437573';
wwv_flow_api.g_varchar2_table(424) := '746F6D4572726F7228207061727365644A534F4E20293B0D0A20202020202072657475726E2066616C73653B0D0A202020207D0D0A202020200D0A2020202072657475726E207061727365644A534F4E3B0D0A202020200D0A20207D0D0A0D0A20206675';
wwv_flow_api.g_varchar2_table(425) := '6E6374696F6E205F657874656E64506F7075706C6F764F626A28206F626A65637420297B0D0A202020200D0A2020202076617220636F6E7461696E6572203D2024282723272B6E61746976655F6974656D5F69642B275F504F50555027293B0D0A202020';
wwv_flow_api.g_varchar2_table(426) := '2076617220706F707570486561646572446976203D20636F6E7461696E65722E7072657628293B0D0A202020200D0A202020206F626A6563742E736561726368537472696E67203D2027273B0D0A202020200D0A202020206F626A6563742E73656C6563';
wwv_flow_api.g_varchar2_table(427) := '746564203D20303B0D0A202020206F626A6563742E68616E646C657273203D207B0D0A20202020202027706F707570486561646572446976273A20706F7075704865616465724469762C0D0A20202020202027726573756C74436F6E7461696E6572273A';
wwv_flow_api.g_varchar2_table(428) := '20636F6E7461696E65722E66696E6428275B636C6173733D272B73656C6563746F725F706F707570416A6178436F6E7461696E65722B275D27292C0D0A20202020202027696E707574536561726368273A20706F7075704865616465724469762E66696E';
wwv_flow_api.g_varchar2_table(429) := '6428272E736561726368626F78446976203A696E70757427292C0D0A20202020202027636865636B626F7853656C656374416C6C273A20706F7075704865616465724469762E66696E6428275B69642A3D5F73656C6563745F616C6C5D27292C0D0A2020';
wwv_flow_api.g_varchar2_table(430) := '20202020276C6162656C53656C656374416C6C273A20706F7075704865616465724469762E66696E6428276C6162656C5B666F722A3D5F73656C6563745F616C6C5D27292C0D0A20202020202027636865636B626F7853686F7753656C6563746564273A';
wwv_flow_api.g_varchar2_table(431) := '20636F6E7461696E65722E706172656E7428292E66696E6428275B69642A3D5F73686F775F73656C65637465645D27292C0D0A202020202020276C6162656C53686F7753656C6563746564273A20636F6E7461696E65722E706172656E7428292E66696E';
wwv_flow_api.g_varchar2_table(432) := '6428275B666F722A3D5F73686F775F73656C65637465645D27292C0D0A202020207D3B0D0A202020200D0A202020200D0A202020206F626A6563742E66696E64203D2066756E6374696F6E28736561726368297B0D0A2020202020207661722073656C66';
wwv_flow_api.g_varchar2_table(433) := '203D20746869733B0D0A2020202020207661722074656D70203D206E756C6C3B0D0A20202020202076617220697353686F7753656C6563746564203D20746869732E697353686F7753656C65637465640D0A0D0A202020202020736561726368203D2073';
wwv_flow_api.g_varchar2_table(434) := '65617263682E746F55707065724361736528293B0D0A202020202020746869732E736561726368537472696E67203D207365617263683B0D0A20202020202074656D70203D20242873656C662E76616C756573292E66696C7465722866756E6374696F6E';
wwv_flow_api.g_varchar2_table(435) := '28696E6465782C2076616C7565297B0D0A20202020202020200D0A20202020202020206966202820697353686F7753656C6563746564203D3D20747275652026262076616C75652E636865636B656420213D207472756529207B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(436) := '202072657475726E2066616C73653B0D0A20202020202020207D0D0A0D0A20202020202020202F2F72657475726E2076616C75652E722E746F55707065724361736528292E696E6465784F662873656172636829203E202D31207C7C2076616C75652E64';
wwv_flow_api.g_varchar2_table(437) := '2E746F55707065724361736528292E696E6465784F662873656172636829203E202D313B0D0A0D0A0D0A202020202020202069662028206F7074696F6E732E5F72657475726E436F6C6C756D6E203D3D2027592720290D0A202020202020202020207265';
wwv_flow_api.g_varchar2_table(438) := '7475726E2076616C75652E722E746F55707065724361736528292E7365617263684C696B652873656172636829203E202D31207C7C2076616C75652E642E746F55707065724361736528292E7365617263684C696B652873656172636829203E202D313B';
wwv_flow_api.g_varchar2_table(439) := '0D0A2020202020202020656C7365207B0D0A2020202020202020202072657475726E2076616C75652E642E746F55707065724361736528292E7365617263684C696B652873656172636829203E202D313B0D0A20202020202020207D0D0A202020202020';
wwv_flow_api.g_varchar2_table(440) := '20200D0A2020202020207D293B0D0A2020202020200D0A202020202020746869732E73686F77416C6C436F756E74282074656D702E6C656E67746820293B0D0A2020202020200D0A20202020202072657475726E20242E6D616B6541727261792874656D';
wwv_flow_api.g_varchar2_table(441) := '70293B0D0A202020207D0D0A0D0A202020206F626A6563742E676574466972737453656C65637465644F626A656374203D2066756E6374696F6E28297B0D0A0D0A20202020202076617220666972737453656C6563746564203D206E756C6C3B0D0A2020';
wwv_flow_api.g_varchar2_table(442) := '20200D0A202020202020666F7220282076617220693D302C206C656E677468203D20746869732E76616C7565732E6C656E6774683B2069203C206C656E6774683B20692B2B2029207B0D0A20202020202020206966202820746869732E76616C7565735B';
wwv_flow_api.g_varchar2_table(443) := '695D2E636865636B65642029207B0D0A20202020202020202020666972737453656C6563746564203D20746869732E76616C7565735B695D3B0D0A20202020202020202020627265616B3B0D0A20202020202020207D0D0A2020202020207D0D0A202020';
wwv_flow_api.g_varchar2_table(444) := '2020200D0A20202020202072657475726E20666972737453656C65637465643B0D0A2020202020200D0A202020207D0D0A202020200D0A202020206F626A6563742E73656C656374427956616C7565203D2066756E6374696F6E282076616C7565202920';
wwv_flow_api.g_varchar2_table(445) := '7B0D0A20202020202076616C7565203D2076616C75652E746F55707065724361736528293B0D0A2020202020200D0A202020202020666F72202876617220693D302C206C656E677468203D20746869732E76616C7565732E6C656E6774683B2069203C20';
wwv_flow_api.g_varchar2_table(446) := '6C656E6774683B20692B2B29207B0D0A20202020202020206966202820746869732E76616C7565735B695D2E722E746F5570706572436173652829203D3D2076616C7565207C7C20746869732E76616C7565735B695D2E642E746F557070657243617365';
wwv_flow_api.g_varchar2_table(447) := '2829203D3D2076616C75652029207B0D0A20202020202020202020746869732E76616C7565735B695D2E636865636B6564203D20747275653B0D0A20202020202020202020746869732E63616C63756C61746553656C656374656428207472756520293B';
wwv_flow_api.g_varchar2_table(448) := '0D0A0D0A20202020202020207D0D0A2020202020207D0D0A202020207D0D0A202020200D0A202020200D0A0D0A202020206F626A6563742E73656C65637446726F6D506C7567696E203D2066756E6374696F6E28297B0D0A202020202020766172206172';
wwv_flow_api.g_varchar2_table(449) := '726179203D20706C7567696E2E76616C28292E73706C69742820736570617261746F7220293B0D0A2020202020200D0A202020202020666F7220282076617220693D302C206C656E677468203D2061727261792E6C656E6774683B2069203C206C656E67';
wwv_flow_api.g_varchar2_table(450) := '74683B20692B2B2029207B0D0A2020202020202020746869732E73656C656374427956616C7565282061727261795B695D20293B0D0A20202020202020200D0A2020202020207D0D0A2020202020200D0A202020207D3B0D0A202020200D0A202020206F';
wwv_flow_api.g_varchar2_table(451) := '626A6563742E63616C63756C61746553656C6563746564203D2066756E6374696F6E28737461747573297B0D0A20202020202069662028737461747573290D0A2020202020202020746869732E73656C6563746564202B3D20313B0D0A20202020202065';
wwv_flow_api.g_varchar2_table(452) := '6C73650D0A2020202020202020746869732E73656C6563746564202D3D20313B0D0A202020207D0D0A202020200D0A202020206F626A6563742E72657365744D6F7265536574203D2066756E6374696F6E2829207B0D0A202020202020746869732E6D6F';
wwv_flow_api.g_varchar2_table(453) := '72653272656E646572203D205B5D3B0D0A202020207D0D0A0D0A202020206F626A6563742E72656E6465724D6F7265203D2066756E6374696F6E28297B0D0A2020202020206966202820746869732E6D6F72653272656E6465722E6C656E677468203E20';
wwv_flow_api.g_varchar2_table(454) := '302029200D0A2020202020202020746869732E72656E6465722820746869732E6D6F72653272656E64657220293B0D0A202020207D0D0A0D0A202020206F626A6563742E646573656C656374416C6C203D2066756E6374696F6E2829207B0D0A20202020';
wwv_flow_api.g_varchar2_table(455) := '2020666F72202820766172206C656E677468203D20746869732E76616C7565732E6C656E6774682C20693D303B2069203C206C656E6774683B20692B2B2029207B0D0A2020202020202020746869732E76616C7565735B695D2E636865636B6564203D20';
wwv_flow_api.g_varchar2_table(456) := '66616C73653B0D0A2020202020207D0D0A2020202020200D0A202020202020746869732E73656C6563746564203D20303B0D0A202020202020746869732E68616E646C6572732E696E7075745365617263682E76616C286E756C6C293B0D0A2020202020';
wwv_flow_api.g_varchar2_table(457) := '20746869732E68616E646C6572732E636865636B626F7853656C656374416C6C2E70726F702827636865636B6564272C2066616C7365293B0D0A202020202020746869732E73686F7753656C6563746564436F756E7428293B0D0A202020207D0D0A2020';
wwv_flow_api.g_varchar2_table(458) := '20200D0A202020200D0A202020206F626A6563742E646573656C656374416C6C53656C6563746564203D2066756E6374696F6E2829207B0D0A202020202020666F72202820766172206C656E677468203D20746869732E76616C7565732E6C656E677468';
wwv_flow_api.g_varchar2_table(459) := '2C20693D303B2069203C206C656E6774683B20692B2B2029207B0D0A20202020202020206966202820746869732E697353686F7753656C65637465642029207B0D0A20202020202020202020746869732E76616C7565735B695D2E636865636B6564203D';
wwv_flow_api.g_varchar2_table(460) := '2066616C73653B0D0A20202020202020202020746869732E63616C63756C61746553656C6563746564282066616C736520293B0D0A20202020202020207D0D0A2020202020207D0D0A202020207D0D0A202020200D0A202020206F626A6563742E636861';
wwv_flow_api.g_varchar2_table(461) := '6E6765537461747573416C6C203D2066756E6374696F6E28737461747573297B0D0A2020202020200D0A2020202020202F2F7661722063757272656E744C656E677468203D20242E6D616B6541727261792820746869732E676574436865636B65642829';
wwv_flow_api.g_varchar2_table(462) := '20292E6C656E6774683B0D0A2020202020207661722063757272656E744C656E677468203D20746869732E67657441727261794C656E6774682820242E6D616B6541727261792820746869732E676574436865636B65642829202920293B0D0A20202020';
wwv_flow_api.g_varchar2_table(463) := '2020766172206465737453656C65637465644C656E677468203D20303B0D0A20202020202076617220726573756C74417272617952656E646572203D205B5D3B0D0A2020202020200D0A2020202020206966202820746869732E6861734F776E50726F70';
wwv_flow_api.g_varchar2_table(464) := '657274792827736561726368537472696E67272920262620746869732E736561726368537472696E672E6C656E677468203E20302029207B0D0A20202020202020206465737453656C65637465644C656E677468203D20746869732E6765744172726179';
wwv_flow_api.g_varchar2_table(465) := '4C656E6774682820746869732E66696E642820746869732E736561726368537472696E67202920293B0D0A20202020202020200D0A202020202020202069662028207374617475732026262063757272656E744C656E677468202B206465737453656C65';
wwv_flow_api.g_varchar2_table(466) := '637465644C656E677468203E206F7074696F6E732E5F6D617843686172732029207B0D0A20202020202020202020696620282021636F6E6669726D2820287472616E736C6174696F6E732E5041454C495F53454C4543545F414C4C5F5741524E494E4729';
wwv_flow_api.g_varchar2_table(467) := '2E7265706C6163652827234C494D495423272C206F7074696F6E732E5F6D617843686172732920292029207B0D0A20202020202020202020202072657475726E2066616C73653B0D0A202020202020202020207D0D0A20202020202020207D0D0A202020';
wwv_flow_api.g_varchar2_table(468) := '20202020200D0A20202020202020206966202820746869732E697353686F7753656C656374656420213D20747275652029207B0D0A202020202020202020200D0A202020202020202020202F2F6764792073686F772073656C6563746564206E6965206A';
wwv_flow_api.g_varchar2_table(469) := '657374207A617A6E61637A6F6E650D0A0D0A20202020202020202020666F72202820766172206C656E677468203D20746869732E76616C7565732E6C656E6774682C20693D303B2069203C206C656E6774683B20692B2B2029207B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(470) := '20202020202F2A6E6F77652A2F0D0A20202020202020202020202069662028206F7074696F6E732E5F72657475726E436F6C6C756D6E203D3D202759272029207B0D0A20202020202020202020202020206966202820746869732E76616C7565735B695D';
wwv_flow_api.g_varchar2_table(471) := '2E722E746F55707065724361736528292E7365617263684C696B652820746869732E736561726368537472696E672029203E202D31207C7C20746869732E76616C7565735B695D2E642E746F55707065724361736528292E7365617263684C696B652820';
wwv_flow_api.g_varchar2_table(472) := '746869732E736561726368537472696E672029203E202D312029207B0D0A20202020202020202020202020202020746869732E76616C7565735B695D2E636865636B6564203D207374617475733B0D0A20202020202020202020202020207D0D0A202020';
wwv_flow_api.g_varchar2_table(473) := '2020202020202020207D0D0A20202020202020202020202020200D0A202020202020202020202020656C7365207B0D0A20202020202020202020202020206966202820746869732E76616C7565735B695D2E642E746F55707065724361736528292E7365';
wwv_flow_api.g_varchar2_table(474) := '617263684C696B652820746869732E736561726368537472696E672029203E202D312029207B0D0A20202020202020202020202020202020746869732E76616C7565735B695D2E636865636B6564203D207374617475733B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(475) := '202020207D0D0A2020202020202020202020207D0D0A202020202020202020207D0D0A202020202020202020200D0A20202020202020202020726573756C74417272617952656E646572203D20746869732E66696E642820746869732E73656172636853';
wwv_flow_api.g_varchar2_table(476) := '7472696E6720293B0D0A202020202020202020200D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A20202020202020202020666F72202820766172206C656E677468203D20746869732E76616C7565732E6C656E6774682C20693D';
wwv_flow_api.g_varchar2_table(477) := '303B2069203C206C656E6774683B20692B2B2029207B0D0A20202020202020202020202069662028206F7074696F6E732E5F72657475726E436F6C6C756D6E203D3D202759272029207B0D0A20202020202020202020202020206966202820746869732E';
wwv_flow_api.g_varchar2_table(478) := '76616C7565735B695D2E722E746F55707065724361736528292E7365617263684C696B652820746869732E736561726368537472696E672029203E202D31207C7C20746869732E76616C7565735B695D2E642E746F55707065724361736528292E736561';
wwv_flow_api.g_varchar2_table(479) := '7263684C696B652820746869732E736561726368537472696E672029203E202D312029207B0D0A202020202020202020202020202020206966202820746869732E76616C7565735B695D2E636865636B6564203D3D20747275652029207B0D0A20202020';
wwv_flow_api.g_varchar2_table(480) := '2020202020202020202020202020746869732E76616C7565735B695D2E636865636B6564203D207374617475733B0D0A202020202020202020202020202020207D0D0A20202020202020202020202020207D0D0A2020202020202020202020207D0D0A20';
wwv_flow_api.g_varchar2_table(481) := '202020202020202020202020200D0A202020202020202020202020656C7365207B0D0A20202020202020202020202020206966202820746869732E76616C7565735B695D2E642E746F55707065724361736528292E7365617263684C696B652820746869';
wwv_flow_api.g_varchar2_table(482) := '732E736561726368537472696E672029203E202D312029207B0D0A202020202020202020202020202020206966202820746869732E76616C7565735B695D2E636865636B6564203D3D20747275652029207B0D0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(483) := '2020746869732E76616C7565735B695D2E636865636B6564203D207374617475733B0D0A202020202020202020202020202020207D0D0A20202020202020202020202020207D0D0A2020202020202020202020207D0D0A202020202020202020207D0D0A';
wwv_flow_api.g_varchar2_table(484) := '2020202020202020202020200D0A202020202020202020206966202820746869732E73656C6563746564203E20302029207B0D0A202020202020202020202020746869732E68616E646C6572732E696E7075745365617263682E76616C28206E756C6C20';
wwv_flow_api.g_varchar2_table(485) := '293B0D0A202020202020202020202020746869732E736561726368537472696E67203D2027273B0D0A202020202020202020202020746869732E68616E646C6572732E636865636B626F7853656C656374416C6C2E70726F702827636865636B6564272C';
wwv_flow_api.g_varchar2_table(486) := '2074727565293B0D0A202020202020202020202020726573756C74417272617952656E646572203D20242E6D616B6541727261792820746869732E676574436865636B6564282920293B0D0A202020202020202020207D0D0A2020202020202020202065';
wwv_flow_api.g_varchar2_table(487) := '6C7365207B0D0A202020202020202020202020726573756C74417272617952656E646572203D20746869732E76616C7565733B0D0A202020202020202020207D0D0A20202020202020202020200D0A20202020202020207D0D0A20202020202020200D0A';
wwv_flow_api.g_varchar2_table(488) := '2020202020207D0D0A202020202020656C73652069662028746869732E697353686F7753656C656374656429207B0D0A20202020202020207661722063757272656E746C7953656C6563746564203D20746869732E676574436865636B656428293B0D0A';
wwv_flow_api.g_varchar2_table(489) := '20202020202020200D0A2020202020202020666F72202876617220693D302C206C656E677468203D2063757272656E746C7953656C65637465642E6C656E6774683B2069203C206C656E6774683B20692B2B2029207B0D0A202020202020202020206375';
wwv_flow_api.g_varchar2_table(490) := '7272656E746C7953656C65637465645B695D2E636865636B6564203D207374617475733B0D0A20202020202020207D0D0A20202020202020200D0A2020202020202020746869732E68616E646C6572732E636865636B626F7853656C656374416C6C2E70';
wwv_flow_api.g_varchar2_table(491) := '726F702827636865636B6564272C20737461747573293B0D0A2020202020202020726573756C74417272617952656E646572203D20746869732E76616C7565733B0D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020206465';
wwv_flow_api.g_varchar2_table(492) := '737453656C65637465644C656E677468203D20746869732E67657441727261794C656E67746828746869732E76616C756573293B0D0A20202020202020200D0A0D0A20202020202020206966202820737461747573202626206465737453656C65637465';
wwv_flow_api.g_varchar2_table(493) := '644C656E677468203E206F7074696F6E732E5F6D617843686172732029207B0D0A20202020202020202020696620282021636F6E6669726D2820287472616E736C6174696F6E732E5041454C495F53454C4543545F414C4C5F5741524E494E47292E7265';
wwv_flow_api.g_varchar2_table(494) := '706C6163652827234C494D495423272C206F7074696F6E732E5F6D617843686172732920292029207B0D0A20202020202020202020202072657475726E2066616C73653B0D0A202020202020202020207D0D0A20202020202020207D0D0A202020202020';
wwv_flow_api.g_varchar2_table(495) := '20200D0A2020202020202020666F72202820766172206C656E677468203D20746869732E76616C7565732E6C656E6774682C20693D303B2069203C206C656E6774683B20692B2B2029207B0D0A20202020202020202020746869732E76616C7565735B69';
wwv_flow_api.g_varchar2_table(496) := '5D2E636865636B6564203D207374617475733B0D0A20202020202020207D0D0A20202020202020200D0A202020202020202069662028737461747573290D0A20202020202020202020746869732E73656C6563746564203D20746869732E76616C756573';
wwv_flow_api.g_varchar2_table(497) := '2E6C656E6774683B0D0A2020202020202020656C7365200D0A20202020202020202020746869732E73656C6563746564203D20303B0D0A20202020202020200D0A20202020202020200D0A2020202020202020726573756C74417272617952656E646572';
wwv_flow_api.g_varchar2_table(498) := '203D20746869732E76616C7565733B0D0A20202020202020200D0A2020202020207D0D0A2020202020200D0A202020202020746869732E636C65617228293B0D0A202020202020746869732E73686F7753656C6563746564436F756E742874727565293B';
wwv_flow_api.g_varchar2_table(499) := '0D0A202020202020746869732E72656E6465722820726573756C74417272617952656E64657220293B0D0A202020202020746869732E73686F77416C6C436F756E742820726573756C74417272617952656E6465722E6C656E67746820293B0D0A202020';
wwv_flow_api.g_varchar2_table(500) := '2020200D0A20202020202072657475726E20747275653B0D0A202020207D0D0A202020200D0A202020206F626A6563742E67657441727261794C656E677468203D2066756E6374696F6E286172726179297B0D0A2020202020207661722074656D70203D';
wwv_flow_api.g_varchar2_table(501) := '20242E6D61702861727261792C2066756E6374696F6E2876616C2C2069297B0D0A202020202020202072657475726E2076616C2E723B20200D0A2020202020207D293B0D0A0D0A20202020202072657475726E202874656D702E6A6F696E286F7074696F';
wwv_flow_api.g_varchar2_table(502) := '6E732E736570617261746F7229292E6C656E6774683B0D0A202020207D3B0D0A0D0A202020206F626A6563742E73686F7753656C6563746564436F756E74203D2066756E6374696F6E28726563616C63756C61746553656C6563746564297B0D0A202020';
wwv_flow_api.g_varchar2_table(503) := '2020200D0A2020202020200D0A20202020202069662028726563616C63756C61746553656C656374656429207B0D0A2020202020202020746869732E73656C6563746564203D2028746869732E676574436865636B65642829292E73697A6528293B0D0A';
wwv_flow_api.g_varchar2_table(504) := '20202020202020200D0A2020202020207D0D0A20202020202020200D0A2020202020200D0A202020202020746869732E68616E646C6572732E6C6162656C53686F7753656C65637465642E68746D6C28207472616E736C6174696F6E732E5041454C495F';
wwv_flow_api.g_varchar2_table(505) := '504F5055505F53484F575F53454C45435445442B272028272B746869732E73656C65637465642B27292720293B0D0A2020202020200D0A2020202020206966202820746869732E73656C6563746564203D3D20302029207B0D0A20202020202020207468';
wwv_flow_api.g_varchar2_table(506) := '69732E697353686F7753656C6563746564203D2066616C73653B0D0A2020202020202020746869732E68616E646C6572732E636865636B626F7853686F7753656C65637465642E70726F702827636865636B6564272C2066616C7365293B0D0A20202020';
wwv_flow_api.g_varchar2_table(507) := '202020202F2F746869732E68616E646C6572732E6C6162656C53686F7753656C65637465642E706172656E7428292E6869646528293B0D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020202F2F746869732E68616E646C65';
wwv_flow_api.g_varchar2_table(508) := '72732E6C6162656C53686F7753656C65637465642E706172656E7428292E73686F7728293B0D0A20202020202020206E756C6C3B0D0A2020202020207D0D0A202020207D0D0A202020200D0A202020206F626A6563742E72656E64657253656C65637465';
wwv_flow_api.g_varchar2_table(509) := '64203D2066756E6374696F6E28297B0D0A202020202020766172206172726179203D20242E6D616B6541727261792820746869732E676574436865636B6564282920293B0D0A202020202020746869732E636C65617228293B0D0A202020202020746869';
wwv_flow_api.g_varchar2_table(510) := '732E73686F77416C6C436F756E74282061727261792E6C656E67746820293B0D0A202020202020746869732E72656E6465722820617272617920293B0D0A0D0A2020202020202F2F747520736965206265647A69652077796B6C75637A6163207A20636C';
wwv_flow_api.g_varchar2_table(511) := '6561722E207720636C656172206E616A70696572772077796C61637A79207A617A6E61637A656E69652C206120706F6E697A656A206C696E6961207A617A6E61637A790D0A202020202020746869732E68616E646C6572732E636865636B626F7853656C';
wwv_flow_api.g_varchar2_table(512) := '656374416C6C2E70726F702827636865636B6564272C2074727565293B0D0A2020202020200D0A202020207D0D0A202020200D0A202020206F626A6563742E6368616E6765537461747573203D2066756E6374696F6E2820726F776E756D2C2069734368';
wwv_flow_api.g_varchar2_table(513) := '65636B65642029207B0D0A2020202020200D0A2020202020206F626A6563742E76616C7565735B726F776E756D2D315D2E636865636B6564203D206973436865636B65643B0D0A2020202020200D0A202020202020746869732E63616C63756C61746553';
wwv_flow_api.g_varchar2_table(514) := '656C656374656428206973436865636B656420293B0D0A2020202020200D0A2020202020206966202820746869732E697353686F7753656C656374656420262620746869732E73656C6563746564203D3D203029207B0D0A20202020202020200D0A2020';
wwv_flow_api.g_varchar2_table(515) := '202020202020746869732E73686F7753656C6563746564436F756E7428293B0D0A2020202020202020746869732E73686F77416C6C28293B0D0A202020202020202072657475726E20766F69642830293B0D0A2020202020207D20656C7365207B0D0A20';
wwv_flow_api.g_varchar2_table(516) := '20202020202020746869732E73686F7753656C6563746564436F756E7428293B0D0A2020202020207D0D0A2020202020200D0A2020202020206966202820746869732E697353686F7753656C656374656420290D0A2020202020202020746869732E7265';
wwv_flow_api.g_varchar2_table(517) := '6E64657253656C656374656428293B0D0A2020202020200D0A202020207D0D0A202020200D0A202020206F626A6563742E636C656172203D2066756E6374696F6E28297B0D0A2020202020207661722073656C66203D20746869733B0D0A202020202020';
wwv_flow_api.g_varchar2_table(518) := '746869732E72657365744D6F726553657428293B0D0A2020202020202F2F746869732E68616E646C6572732E726573756C74436F6E7461696E65722E6368696C6472656E28292E666164654F7574283530302C2066756E6374696F6E28297B0D0A202020';
wwv_flow_api.g_varchar2_table(519) := '202020202073656C662E68616E646C6572732E726573756C74436F6E7461696E65722E68746D6C286E756C6C293B20200D0A202020202020202073656C662E68616E646C6572732E636865636B626F7853656C656374416C6C2E70726F70282763686563';
wwv_flow_api.g_varchar2_table(520) := '6B6564272C2066616C7365293B0D0A2020202020202F2F7D293B0D0A202020207D0D0A202020200D0A202020206F626A6563742E676574436865636B656456616C756573203D2066756E6374696F6E2829207B0D0A202020202020766172206172726179';
wwv_flow_api.g_varchar2_table(521) := '4F664F626A65637473203D20746869732E676574436865636B656428293B0D0A2020202020207661722074656D70203D205B5D3B0D0A202020202020766172206C656E677468203D2061727261794F664F626A656374732E6C656E6774683B0D0A202020';
wwv_flow_api.g_varchar2_table(522) := '2020200D0A202020202020666F7220287661722069203D20303B20693C206C656E6774683B20692B2B2029207B0D0A202020202020202074656D702E70757368282061727261794F664F626A656374735B695D2E7220293B0D0A2020202020207D0D0A20';
wwv_flow_api.g_varchar2_table(523) := '20202020200D0A20202020202072657475726E2074656D703B0D0A202020207D0D0A202020202F2F5A7772616361207461626C696365207A20777973776965746C616E796D6920776172746F736369616D69207A617A6E61637A6F6E79636820706F7A79';
wwv_flow_api.g_varchar2_table(524) := '636A690D0A096F626A6563742E676574436865636B6564446973706C6179203D2066756E6374696F6E2829207B0D0A2020202020207661722061727261794F664F626A65637473203D20746869732E676574436865636B656428293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(525) := '7661722074656D70203D205B5D3B0D0A202020202020766172206C656E677468203D2061727261794F664F626A656374732E6C656E6774683B0D0A2020202020200D0A202020202020666F7220287661722069203D20303B20693C206C656E6774683B20';
wwv_flow_api.g_varchar2_table(526) := '692B2B2029207B0D0A202020202020202074656D702E70757368282061727261794F664F626A656374735B695D2E6420293B0D0A2020202020207D0D0A20202020202F2F20636F6E736F6C652E6C6F672874656D70293B0D0A2020202020207265747572';
wwv_flow_api.g_varchar2_table(527) := '6E2074656D703B0D0A202020207D090D0A0920200D0A0920200D0A0920200D0A202020200D0A202020206F626A6563742E676574436865636B6564203D2066756E6374696F6E28297B0D0A20202020202076617220636865636B65644172726179203D20';
wwv_flow_api.g_varchar2_table(528) := '2428746869732E76616C756573292E66696C7465722866756E6374696F6E28696E6465782C2076616C7565297B0D0A202020202020202072657475726E2076616C75652E636865636B6564203F2074727565203A2066616C73653B0D0A2020202020207D';
wwv_flow_api.g_varchar2_table(529) := '293B0D0A2020202020200D0A20202020202072657475726E20636865636B656441727261793B0D0A202020207D3B0D0A202020200D0A202020200D0A202020200D0A202020206F626A6563742E73686F7753656C6563746564203D2066756E6374696F6E';
wwv_flow_api.g_varchar2_table(530) := '28297B0D0A2020202020207661722073656C65637465644172726179203D20242E6D616B6541727261792820746869732E676574436865636B6564282920293B0D0A2020202020200D0A202020202020696620282073656C656374656441727261792E6C';
wwv_flow_api.g_varchar2_table(531) := '656E677468203D3D20302029207B0D0A20202020202020202F2F616C65727428274E6965206D61207A617A6E61637A6F6E79636820776172746FC59B636927293B0D0A202020202020202072657475726E2066616C73653B0D0A2020202020207D0D0A20';
wwv_flow_api.g_varchar2_table(532) := '20202020200D0A20202020202024282723272B6E61746976655F6974656D5F69642B275F73656C6563745F616C6C27292E70726F702827636865636B6564272C2074727565293B0D0A2020202020200D0A202020202020746869732E636C65617228293B';
wwv_flow_api.g_varchar2_table(533) := '202020200D0A202020202020746869732E68616E646C6572732E636865636B626F7853656C656374416C6C2E70726F702827636865636B6564272C2074727565293B0D0A202020202020746869732E73686F77416C6C436F756E74282073656C65637465';
wwv_flow_api.g_varchar2_table(534) := '6441727261792E6C656E67746820293B0D0A202020202020746869732E72656E646572282073656C6563746564417272617920293B0D0A20202020202072657475726E20747275653B0D0A202020207D0D0A0D0A202020200D0A202020206F626A656374';
wwv_flow_api.g_varchar2_table(535) := '2E73686F77416C6C203D2066756E6374696F6E28297B0D0A202020202020746869732E636C65617228293B0D0A202020202020746869732E73686F77416C6C436F756E742820746869732E76616C7565732E6C656E67746820293B0D0A20202020202074';
wwv_flow_api.g_varchar2_table(536) := '6869732E73686F7753656C6563746564436F756E7428293B0D0A202020202020746869732E68616E646C6572732E636865636B626F7853656C656374416C6C2E70726F702827636865636B6564272C2066616C7365293B0D0A202020202020746869732E';
wwv_flow_api.g_varchar2_table(537) := '72656E6465722820746869732E76616C75657320293B0D0A202020207D0D0A0D0A202020206F626A6563742E73686F77416C6C436F756E74203D2066756E6374696F6E2820636F756E7420297B0D0A202020202020746869732E68616E646C6572732E6C';
wwv_flow_api.g_varchar2_table(538) := '6162656C53656C656374416C6C2E68746D6C28207472616E736C6174696F6E732E5041454C495F504F5055505F53454C4543545F414C4C2B272028272B636F756E742B27292720293B0D0A202020207D0D0A202020200D0A202020206F626A6563742E72';
wwv_flow_api.g_varchar2_table(539) := '656E646572416C6C203D2066756E6374696F6E28297B0D0A202020202020746869732E73686F77416C6C436F756E742820636F756E7420293B0D0A202020202020746869732E72656E6465722820746869732E76616C75657320293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(540) := '0D0A202020207D3B0D0A202020200D0A202020206F626A6563742E72656E646572203D2066756E6374696F6E286172726179297B0D0A2020202020200D0A2020202020206172726179203D20242E657874656E64285B5D2C206172726179293B0D0A2020';
wwv_flow_api.g_varchar2_table(541) := '202020200D0A2020202020207661722061727261794C656E677468203D2061727261792E6C656E6774683B0D0A2020202020207661722073656C6563746F72203D20242820746869732E68616E646C6572732E726573756C74436F6E7461696E65722029';
wwv_flow_api.g_varchar2_table(542) := '3B0D0A202020202020746869732E68616E646C6572732E636865636B626F7853656C656374416C6C2E70726F70282764697361626C6564272C2066616C7365293B0D0A0D0A2020202020200D0A202020202020696620282061727261794C656E67746820';
wwv_flow_api.g_varchar2_table(543) := '3D3D20302029207B0D0A2020202020202020746869732E68616E646C6572732E636865636B626F7853656C656374416C6C2E70726F70282764697361626C6564272C2074727565293B0D0A20202020202020200D0A202020202020202069662028746869';
wwv_flow_api.g_varchar2_table(544) := '732E697353686F7753656C6563746564290D0A2020202020202020202073656C6563746F722E617070656E642820273C64697620636C6173733D226E6F5F646174615F666F756E64223E272B287472616E736C6174696F6E732E5041454C495F504F5055';
wwv_flow_api.g_varchar2_table(545) := '505F4E44465F53454C4543544544292E7265706C6163652827235345415243485F535452494E4723272C20746869732E736561726368537472696E6729202B273C2F6469763E2720293B0D0A2020202020202020656C7365207B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(546) := '2020766172206D7367203D20287472616E736C6174696F6E732E5041454C495F504F5055505F4E44465F4155544F46494C544552292E7265706C6163652827235345415243485F535452494E4723272C20746869732E736561726368537472696E67293B';
wwv_flow_api.g_varchar2_table(547) := '0D0A202020202020202020200D0A2020202020202020202073656C6563746F722E617070656E642820273C64697620636C6173733D226E6F5F646174615F666F756E64223E272B206D7367202B273C2F6469763E2720293B0D0A20202020202020207D0D';
wwv_flow_api.g_varchar2_table(548) := '0A20202020202020200D0A202020202020202072657475726E20766F69642830293B0D0A2020202020207D0D0A2020202020200D0A2020202020207661722061727261793272656E646572203D2061727261792E73706C69636528302C31303030293B0D';
wwv_flow_api.g_varchar2_table(549) := '0A2020202020207661722061727261793273746F7265203D2061727261793B0D0A202020202020746869732E6D6F72653272656E646572203D2061727261793273746F72653B0D0A2020202020200D0A2020202020207661722074656D706C617465203D';
wwv_flow_api.g_varchar2_table(550) := '2027270D0A202020202020202020202B277B7B2376616C7565737D7D270D0A202020202020202020202B2720203C74723E270D0A202020202020202020202B27202020203C74642077696474683D223136223E270D0A202020202020202020202B272020';
wwv_flow_api.g_varchar2_table(551) := '202020203C696E707574207B7B23636865636B65647D7D636865636B65643D2274727565227B7B2F636865636B65647D7D2020747970653D22272B28206F7074696F6E732E5F6D756C7469706C65203D3D20275927203F2027636865636B626F7827203A';
wwv_flow_api.g_varchar2_table(552) := '2027726164696F2720292B2722206E616D653D22706F70757056616C756573222069643D22272B206E61746976655F6974656D5F6964202B275F726F775F7B7B697D7D222076616C75653D227B7B727D7D2220726F776E756D3D7B7B697D7D3E270D0A20';
wwv_flow_api.g_varchar2_table(553) := '2020202020202020202B27202020203C2F74643E270D0A202020202020202020202B202020202028206F7074696F6E732E5F72657475726E436F6C6C756D6E203D3D20275927203F20273C74643E3C6C6162656C20666F723D22272B206E61746976655F';
wwv_flow_api.g_varchar2_table(554) := '6974656D5F6964202B275F726F775F7B7B697D7D2220636C6173733D2272657475726E223E7B7B727D7D3C2F6C6162656C3E3C2F74643E27203A202727290D0A202020202020202020202B27202020203C74643E270D0A202020202020202020202B2720';
wwv_flow_api.g_varchar2_table(555) := '20202020203C6C6162656C20666F723D22272B206E61746976655F6974656D5F6964202B275F726F775F7B7B697D7D223E7B7B647D7D3C2F6C6162656C3E270D0A202020202020202020202B27202020203C2F74643E270D0A202020202020202020202B';
wwv_flow_api.g_varchar2_table(556) := '2720203C2F74723E270D0A202020202020202020202B277B7B2F76616C7565737D7D273B0D0A202020202020202020200D0A202020202020726573756C74203D204D757374616368652E72656E6465722874656D706C6174652C207B2276616C75657322';
wwv_flow_api.g_varchar2_table(557) := '3A2061727261793272656E6465727D293B20200D0A2020202020200D0A202020202020696620282073656C6563746F722E66696E6428277461626C6527292E73697A652829203E20302029207B0D0A202020202020202073656C6563746F722E66696E64';
wwv_flow_api.g_varchar2_table(558) := '28277461626C6527292E617070656E6428726573756C74290D0A2020202020207D0D0A202020202020656C7365207B0D0A202020202020202073656C6563746F722E617070656E642820273C7461626C652063656C6C73706163696E673D223022206365';
wwv_flow_api.g_varchar2_table(559) := '6C6C70616464696E673D2230223E272B726573756C742B273C2F7461626C653E2720293B20200D0A2020202020207D0D0A2020202020200D0A202020207D0D0A202020200D0A202020200D0A2020202072657475726E206F626A6563743B0D0A20207D0D';
wwv_flow_api.g_varchar2_table(560) := '0A0D0A202066756E6374696F6E20706F7075704F70656E286576656E7429207B0D0A202020206966202820706C7567696E4F626A6563742E636F6E7461696E6572203D3D20756E646566696E656420290D0A2020202020205F7365745F706F7075707328';
wwv_flow_api.g_varchar2_table(561) := '293B0D0A0D0A20202020696620286F7074696F6E732E5F6C6F7620213D2027592729207B0D0A20202020202072657475726E2066616C73653B0D0A202020207D0D0A202020200D0A202020205F69636F6E5F6C6F6164696E675F73686F7728293B0D0A20';
wwv_flow_api.g_varchar2_table(562) := '2020205F69636F6E5F747269676765725F6869646528293B0D0A202020200D0A2020202069636F6E50617374652E706F706F76657228276869646527293B0D0A202020200D0A2020202076617220616A61785F666E5F6964203D206F7074696F6E732E61';
wwv_flow_api.g_varchar2_table(563) := '6A61784964656E7469666965723B0D0A2020202076617220616A617852657175657374203D206E65772068746D6C64625F476574286E756C6C2C2476282770466C6F77496427292C2027504C5547494E3D272B616A61785F666E5F69642C202476282770';
wwv_flow_api.g_varchar2_table(564) := '466C6F775374657049642729293B0D0A0D0A20202020616A6178526571756573742E616464506172616D2827783031272C2027706F7075704C4F5627293B0D0A20202020616A6178526571756573742E616464506172616D2827783032272C20706C7567';
wwv_flow_api.g_varchar2_table(565) := '696E2E76616C2829293B0D0A2020202020200D0A20202020616A6178526571756573742E4765744173796E632866756E6374696F6E28297B0D0A20202020202076617220616A61785F72657475726E203D206E756C6C3B0D0A2020202020200D0A202020';
wwv_flow_api.g_varchar2_table(566) := '20202069662028702E7265616479537461746520213D203429207B0D0A202020202020202072657475726E2066616C73653B0D0A2020202020207D0D0A2020202020200D0A2020202020205F69636F6E5F6C6F6164696E675F6869646528293B0D0A2020';
wwv_flow_api.g_varchar2_table(567) := '202020205F69636F6E5F747269676765725F73686F7728293B0D0A2020202020200D0A202020202020616A61785F72657475726E203D205F70617273655F4A534F4E2820702E726573706F6E73655465787420293B0D0A2020202020200D0A2020202020';
wwv_flow_api.g_varchar2_table(568) := '206966202820616A61785F72657475726E203D3D2066616C73652029207B0D0A202020202020202072657475726E2066616C73653B0D0A2020202020207D0D0A2020202020200D0A202020202020706C7567696E4F626A6563742E64617461203D205F65';
wwv_flow_api.g_varchar2_table(569) := '7874656E64506F7075706C6F764F626A2820616A61785F72657475726E20293B0D0A2020202020200D0A202020202020706C7567696E4F626A6563742E646174612E73656C65637446726F6D506C7567696E28293B2020202020200D0A20202020202070';
wwv_flow_api.g_varchar2_table(570) := '6C7567696E4F626A6563742E646174612E73686F77416C6C28293B0D0A0D0A202020202020706C7567696E4F626A6563742E636F6E7461696E65722E6469616C6F6728276F70656E27293B0D0A2020202020200D0A202020207D293B0D0A20207D0D0A20';
wwv_flow_api.g_varchar2_table(571) := '200D0A202066756E6374696F6E2066696E616C537472696E6728737472696E6729207B0D0A2020202076617220746162203D205B5D3B0D0A202020200D0A202020206966202820737472696E672E6C656E677468203E206F7074696F6E732E5F6D617843';
wwv_flow_api.g_varchar2_table(572) := '686172732029207B0D0A202020202020746162203D20737472696E672E73706C69742820736570617261746F7220293B0D0A2020202020207461622E706F7028293B0D0A2020202020200D0A202020202020737472696E67203D207461622E6A6F696E28';
wwv_flow_api.g_varchar2_table(573) := '20736570617261746F7220293B0D0A202020202020737472696E67203D2066696E616C537472696E672820737472696E6720293B0D0A202020207D0D0A20202020656C7365207B0D0A20202020202072657475726E20737472696E673B0D0A202020207D';
wwv_flow_api.g_varchar2_table(574) := '0D0A202020200D0A2020202072657475726E20737472696E673B0D0A20207D202020200D0A20200D0A2020766172200D0A202020206E61746976655F6974656D5F6964203D2069642C0D0A20202020706C7567696E203D2024282723272B6964292C0D0A';
wwv_flow_api.g_varchar2_table(575) := '202020206D61736B203D206A517565727950414C28706C7567696E2E6E65787428272E272B73656C6563746F725F706C7567696E4D61736B2B272729292C0D0A202020206974656D5F636F6E7461696E6572203D20706C7567696E2E706172656E747328';
wwv_flow_api.g_varchar2_table(576) := '272E272B73656C6563746F725F706C7567696E436F6E7461696E65722B273A666972737427292C0D0A202020202F2F6C6162656C203D20706C7567696E2E706172656E747328277461626C6527292E66696E6428276C6162656C5B666F723D272B69642B';
wwv_flow_api.g_varchar2_table(577) := '275D27293B0D0A202020202F2F6C6162656C203D206C6162656C2E73697A652829203D3D2030203F202428275B666F723D272B69642B275D2729203A206C6162656C3B0D0A202020206C6162656C203D202428275B666F723D272B69642B275D27292C0D';
wwv_flow_api.g_varchar2_table(578) := '0A202020206C6162656C5F74657874203D206C6162656C2E6368696C6472656E2829203E2030203F206C6162656C2E6368696C6472656E28292E6C61737428292E746578742829203A206C6162656C2E7465787428292C0D0A2020202069636F6E547269';
wwv_flow_api.g_varchar2_table(579) := '67676572203D20706C7567696E2E6E657874416C6C28272E69636F6E7327292E66696E6428272E272B73656C6563746F725F69636F6E54726967676572292C0D0A2020202069636F6E4C6F6164696E67203D20706C7567696E2E6E657874416C6C28272E';
wwv_flow_api.g_varchar2_table(580) := '69636F6E7327292E66696E6428272E272B73656C6563746F725F69636F6E4C6F61646572292C0D0A2020202069636F6E5061737465203D206A517565727950414C28706C7567696E2E6E657874416C6C28272E69636F6E7327292E66696E6428272E272B';
wwv_flow_api.g_varchar2_table(581) := '73656C6563746F725F69636F6E50617374656429292C0D0A0D0A20202020706C7567696E4F626A656374203D207B0D0A202020202020706F7075703A207B0D0A2020202020202020636F6E7461696E65723A206E756C6C2C0D0A20202020202020206461';
wwv_flow_api.g_varchar2_table(582) := '74613A206E756C6C0D0A2020202020207D0D0A202020207D2C0D0A202020206F7074696F6E73203D20242E657874656E64280D0A2020202020207B0D0A2020202020202020646570656E64696E674F6E53656C6563746F72203A206E756C6C2C0D0A2020';
wwv_flow_api.g_varchar2_table(583) := '2020202020206F7074696D697A6552656672657368203A20747275652C0D0A2020202020202020706167654974656D73546F5375626D6974203A206E756C6C2C0D0A20202020202020206F7074696F6E41747472696275746573203A206E756C6C0D0A20';
wwv_flow_api.g_varchar2_table(584) := '20202020207D2C200D0A202020202020705F6F7074696F6E73496E0D0A20202020292C202020200D0A202020207472616E736C6174696F6E73203D20242E657874656E64286F7074696F6E732E5F7472616E736C6174696F6E5F4954454D2C206F707469';
wwv_flow_api.g_varchar2_table(585) := '6F6E732E5F7472616E736C6174696F6E5F44494354292C0D0A202020206469616C6F67436F6E666967203D206E756C6C2C0D0A202020206170657844656275675370616365203D20302C0D0A20202020736570617261746F72203D206F7074696F6E732E';
wwv_flow_api.g_varchar2_table(586) := '5F736570617261746F723B0D0A0D0A202020200D0A0D0A2020617065782E7769646765742E696E6974506167654974656D280D0A20202020706C7567696E2E617474722827696427292C200D0A202020207B0D0A2020202020202F2A0D0A202020202020';
wwv_flow_api.g_varchar2_table(587) := '6E756C6C56616C7565203A2066756E6374696F6E28297B0D0A20202020202020200D0A2020202020207D2C0D0A2020202020202A2F0D0A20202020202061667465724D6F646966793A2066756E6374696F6E28297B0D0A20202020202020206E756C6C3B';
wwv_flow_api.g_varchar2_table(588) := '0D0A2020202020207D2C0D0A202020202020686964653A2066756E6374696F6E28297B0D0A20202020202020206974656D5F636F6E7461696E65722E6869646528293B0D0A20202020202020206C6162656C2E6869646528293B0D0A2020202020207D2C';
wwv_flow_api.g_varchar2_table(589) := '0D0A20202020202073686F773A66756E6374696F6E28297B0D0A20202020202020206974656D5F636F6E7461696E65722E73686F7728293B0D0A20202020202020206C6162656C2E73686F7728293B0D0A2020202020207D2C0D0A202020202020656E61';
wwv_flow_api.g_varchar2_table(590) := '626C653A66756E6374696F6E28297B0D0A20202020202020206D61736B2E61747472282764697361626C6564272C2066616C7365293B0D0A20202020202020205F69636F6E5F747269676765725F73686F7728293B0D0A2020202020207D2C0D0A202020';
wwv_flow_api.g_varchar2_table(591) := '20202064697361626C653A66756E6374696F6E28297B0D0A20202020202020206D61736B2E61747472282764697361626C6564272C2074727565293B0D0A2020202020202020706C7567696E2E61747472282764697361626C6564272C2074727565293B';
wwv_flow_api.g_varchar2_table(592) := '0D0A20202020202020200D0A20202020202020205F69636F6E5F747269676765725F6869646528293B0D0A20202020202020205F69636F6E5F70617374655F6869646528293B0D0A20202020202020205F69636F6E5F6C6F6164696E675F686964652829';
wwv_flow_api.g_varchar2_table(593) := '3B0D0A20202020202020205F636C65616E506C7567696E28293B0D0A20202020202020200D0A2020202020207D2C0D0A20202020202073657456616C75653A66756E6374696F6E2876616C7565297B0D0A20202020202020205F6D61736B5F7265736574';
wwv_flow_api.g_varchar2_table(594) := '5F6461746128293B0D0A20202020202020205F706C7567696E5F7365745F76616C7565282076616C756520293B20202020202020200D0A20202020202020205F7365745F6D61736B28293B0D0A2020202020207D0D0A2020202020200D0A202020207D0D';
wwv_flow_api.g_varchar2_table(595) := '0A2020293B0D0A20200D0A202069662028206F7074696F6E732E646570656E64696E674F6E53656C6563746F7229207B0D0A2020202024286F7074696F6E732E646570656E64696E674F6E53656C6563746F72292E6368616E676528666F7263655F7265';
wwv_flow_api.g_varchar2_table(596) := '66726573685F706172656E74290D0A20207D0D0A20200D0A202069636F6E547269676765722E62696E642827636C69636B272C20706F7075704F70656E293B0D0A20200D0A2020706C7567696E2E62696E64280D0A202020202761706578726566726573';
wwv_flow_api.g_varchar2_table(597) := '68272C20666F7263655F726566726573685F706172656E740D0A2020292E62696E64280D0A20202020276368616E6765272C205F655F7265616C5F6576656E745F6368616E67650D0A2020292E62696E64280D0A2020202027676574416C6C4D61736B27';
wwv_flow_api.g_varchar2_table(598) := '2C20676574416C6C4D61736B0D0A2020292E64617461287B0D0A20202020276F7074696F6E73273A206F7074696F6E730D0A20207D293B0D0A0D0A20206D61736B2E62696E64280D0A20202020276B65797570272C206465626F756E6365285F655F6D61';
wwv_flow_api.g_varchar2_table(599) := '736B5F6B617975702C206F7074696F6E732E5F6465626F756E63655F6D73290D0A2020292E62696E64280D0A20202020276B6579646F776E272C205F655F6D61736B5F6B6179646F776E0D0A2020292E62696E64280D0A20202020276368616E6765272C';
wwv_flow_api.g_varchar2_table(600) := '205F655F6D61736B5F6368616E67650D0A2020292E62696E64280D0A20202020276B65797072657373272C205F655F6D61736B5F6B657970726573730D0A2020292E62696E64280D0A202020202772656D6F766550726F6D7074272C205F655F6D61736B';
wwv_flow_api.g_varchar2_table(601) := '5F72656D6F766550726F6D70740D0A2020292E62696E64282773657456616C756546726F6D50726F6D7074272C2066756E6374696F6E28652C64617461297B0D0A2020202020205F6D61736B5F7365745F76616C756528646174612E646973706C61795F';
wwv_flow_api.g_varchar2_table(602) := '76616C7565293B0D0A2020202020205F706C7567696E5F7365745F76616C756528646174612E72657475726E5F76616C7565293B0D0A2020202020202F2F5F655F7265616C5F6576656E745F6368616E67652874727565293B0D0A2020202020205F655F';
wwv_flow_api.g_varchar2_table(603) := '6D61736B5F72656D6F766550726F6D707428293B0D0A2020202020206D61736B2E666F63757328293B0D0A202020202020706C7567696E2E7472696767657228276368616E6765272C205B747275655D293B0D0A202020207D0D0A2020293B0D0A20200D';
wwv_flow_api.g_varchar2_table(604) := '0A20205F6D61736B5F72657365745F6461746128293B20200D0A20205F736574506F706F76657228293B0D0A20205F7365745F706173746528293B0D0A20200D0A20200D0A20202428646F63756D656E74292E72656164792866756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(605) := '200D0A202020202F2F676479206E6965206D6120706F7075700D0A202020202F2F676479206E6965206D61206175746F66696C7472750D0A202020202F2F616C65206A6573742070617374650D0A2020202069662028206F7074696F6E732E5F6C6F7620';
wwv_flow_api.g_varchar2_table(606) := '3D3D20274E27202626206F7074696F6E732E5F6175746F66696C746572203D3D20274E27202626206F7074696F6E732E5F616C6C6F775061737465203D3D202759272029207B0D0A202020202020766172206172726179203D20706C7567696E2E76616C';
wwv_flow_api.g_varchar2_table(607) := '28292E73706C697428206F7074696F6E732E5F736570617261746F72293B0D0A0D0A202020202020696620282061727261792E6C656E677468203E20312029207B0D0A20202020202020205F6D61736B5F7365745F76616C7565282061727261795B315D';
wwv_flow_api.g_varchar2_table(608) := '20293B0D0A20202020202020205F6D61736B5F7365745F6461746128207B277061737465645F76616C756573273A206172726179207D20293B0D0A20202020202020205F69636F6E5F70617374655F73686F7728293B0D0A0D0A2020202020207D0D0A20';
wwv_flow_api.g_varchar2_table(609) := '2020207D0D0A0D0A202020206966202820286F7074696F6E732E5F6175746F66696C746572203D3D20275927207C7C206F7074696F6E732E5F6C6F76203D3D2027592729202626206F7074696F6E732E5F6C6F765F73716C5F657869737473203D3D2027';
wwv_flow_api.g_varchar2_table(610) := '59272029207B0D0A2020202020205F7365745F6D61736B28293B0D0A202020207D0D0A20207D293B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(52798772900393471)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'onload.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '47494638396110007000A2040000000000AC1BAE0505A80505FFFFFF00000000000000000021FF0B584D502044617461584D503C3F787061636B657420626567696E3D22EFBBBF222069643D2257354D304D7043656869487A7265537A4E54637A6B6339';
wwv_flow_api.g_varchar2_table(2) := '64223F3E203C783A786D706D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D2241646F626520584D5020436F726520352E302D633036302036312E3133343737372C20323031302F30322F31322D31373A33';
wwv_flow_api.g_varchar2_table(3) := '323A30302020202020202020223E203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F313939392F30322F32322D7264662D73796E7461782D6E7323223E203C7264663A4465736372697074696F6E207264';
wwv_flow_api.g_varchar2_table(4) := '663A61626F75743D222220786D6C6E733A786D703D22687474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F2220786D6C6E733A786D704D4D3D22687474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F6D6D2F2220786D';
wwv_flow_api.g_varchar2_table(5) := '6C6E733A73745265663D22687474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F73547970652F5265736F75726365526566232220786D703A43726561746F72546F6F6C3D2241646F62652050686F746F73686F70204353352057696E64';
wwv_flow_api.g_varchar2_table(6) := '6F77732220786D704D4D3A496E7374616E636549443D22786D702E6969643A36343042334432334439323231314534414230433939304443314643373046342220786D704D4D3A446F63756D656E7449443D22786D702E6469643A363430423344323444';
wwv_flow_api.g_varchar2_table(7) := '3932323131453441423043393930444331464337304634223E203C786D704D4D3A4465726976656446726F6D2073745265663A696E7374616E636549443D22786D702E6969643A3634304233443231443932323131453441423043393930444331464337';
wwv_flow_api.g_varchar2_table(8) := '304634222073745265663A646F63756D656E7449443D22786D702E6469643A3634304233443232443932323131453441423043393930444331464337304634222F3E203C2F7264663A4465736372697074696F6E3E203C2F7264663A5244463E203C2F78';
wwv_flow_api.g_varchar2_table(9) := '3A786D706D6574613E203C3F787061636B657420656E643D2272223F3E01FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0EFEEEDECEBEAE9E8E7E6E5E4E3E2E1E0DFDEDDDCDBDAD9D8D7D6D5D4D3D2D1D0CFCECDCCCBCAC9C8C7C6C5C4C3C2C1C0BFBEBDBCBBBA';
wwv_flow_api.g_varchar2_table(10) := 'B9B8B7B6B5B4B3B2B1B0AFAEADACABAAA9A8A7A6A5A4A3A2A1A09F9E9D9C9B9A999897969594939291908F8E8D8C8B8A898887868584838281807F7E7D7C7B7A797877767574737271706F6E6D6C6B6A696867666564636261605F5E5D5C5B5A59585756';
wwv_flow_api.g_varchar2_table(11) := '5554535251504F4E4D4C4B4A494847464544434241403F3E3D3C3B3A393837363534333231302F2E2D2C2B2A292827262524232221201F1E1D1C1B1A191817161514131211100F0E0D0C0B0A090807060504030201000021F90401000004002C00000000';
wwv_flow_api.g_varchar2_table(12) := '100070000003A148BADCFE303A40AB9D36CBCD5BD6DE5775E4268EE159AE6CEBB2171133F1FC962785A9F79A033B516F482C426A281ACA663C2E930BA4AE29910253572675CB9508BE020538DC188BC1DDC7784D66B0CDE9F2FBEB98D3E3783C1CEE4613';
wwv_flow_api.g_varchar2_table(13) := 'F8797B7E7D77807A7E8604038B64028B0379915D0194010A95960D989795920498A0990CA19B92A49D9AA7A29EAC3DA5A5A3A8B079AFA8B1949CB8A6B2B60BB5BAAD1109003B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(60861880814963959)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'pal_status.gif'
,p_mime_type=>'image/gif'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A21206A51756572792076312E31312E30207C2028632920323030352C2032303134206A517565727920466F756E646174696F6E2C20496E632E207C206A71756572792E6F72672F6C6963656E7365202A2F0D0A2166756E6374696F6E28612C62297B';
wwv_flow_api.g_varchar2_table(2) := '226F626A656374223D3D747970656F66206D6F64756C652626226F626A656374223D3D747970656F66206D6F64756C652E6578706F7274733F6D6F64756C652E6578706F7274733D612E646F63756D656E743F6228612C2130293A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(3) := '61297B69662821612E646F63756D656E74297468726F77206E6577204572726F7228226A517565727920726571756972657320612077696E646F772077697468206120646F63756D656E7422293B72657475726E20622861297D3A622861297D2822756E';
wwv_flow_api.g_varchar2_table(4) := '646566696E656422213D747970656F662077696E646F773F77696E646F773A746869732C66756E6374696F6E28612C62297B76617220633D5B5D2C643D632E736C6963652C653D632E636F6E6361742C663D632E707573682C673D632E696E6465784F66';
wwv_flow_api.g_varchar2_table(5) := '2C683D7B7D2C693D682E746F537472696E672C6A3D682E6861734F776E50726F70657274792C6B3D22222E7472696D2C6C3D7B7D2C6D3D22312E31312E30222C6E3D66756E6374696F6E28612C62297B72657475726E206E6577206E2E666E2E696E6974';
wwv_flow_api.g_varchar2_table(6) := '28612C62297D2C6F3D2F5E5B5C735C75464546465C7841305D2B7C5B5C735C75464546465C7841305D2B242F672C703D2F5E2D6D732D2F2C713D2F2D285B5C64612D7A5D292F67692C723D66756E6374696F6E28612C62297B72657475726E20622E746F';
wwv_flow_api.g_varchar2_table(7) := '55707065724361736528297D3B6E2E666E3D6E2E70726F746F747970653D7B6A71756572793A6D2C636F6E7374727563746F723A6E2C73656C6563746F723A22222C6C656E6774683A302C746F41727261793A66756E6374696F6E28297B72657475726E';
wwv_flow_api.g_varchar2_table(8) := '20642E63616C6C2874686973297D2C6765743A66756E6374696F6E2861297B72657475726E206E756C6C213D613F303E613F746869735B612B746869732E6C656E6774685D3A746869735B615D3A642E63616C6C2874686973297D2C7075736853746163';
wwv_flow_api.g_varchar2_table(9) := '6B3A66756E6374696F6E2861297B76617220623D6E2E6D6572676528746869732E636F6E7374727563746F7228292C61293B72657475726E20622E707265764F626A6563743D746869732C622E636F6E746578743D746869732E636F6E746578742C627D';
wwv_flow_api.g_varchar2_table(10) := '2C656163683A66756E6374696F6E28612C62297B72657475726E206E2E6561636828746869732C612C62297D2C6D61703A66756E6374696F6E2861297B72657475726E20746869732E70757368537461636B286E2E6D617028746869732C66756E637469';
wwv_flow_api.g_varchar2_table(11) := '6F6E28622C63297B72657475726E20612E63616C6C28622C632C62297D29297D2C736C6963653A66756E6374696F6E28297B72657475726E20746869732E70757368537461636B28642E6170706C7928746869732C617267756D656E747329297D2C6669';
wwv_flow_api.g_varchar2_table(12) := '7273743A66756E6374696F6E28297B72657475726E20746869732E65712830297D2C6C6173743A66756E6374696F6E28297B72657475726E20746869732E6571282D31297D2C65713A66756E6374696F6E2861297B76617220623D746869732E6C656E67';
wwv_flow_api.g_varchar2_table(13) := '74682C633D2B612B28303E613F623A30293B72657475726E20746869732E70757368537461636B28633E3D302626623E633F5B746869735B635D5D3A5B5D297D2C656E643A66756E6374696F6E28297B72657475726E20746869732E707265764F626A65';
wwv_flow_api.g_varchar2_table(14) := '63747C7C746869732E636F6E7374727563746F72286E756C6C297D2C707573683A662C736F72743A632E736F72742C73706C6963653A632E73706C6963657D2C6E2E657874656E643D6E2E666E2E657874656E643D66756E6374696F6E28297B76617220';
wwv_flow_api.g_varchar2_table(15) := '612C622C632C642C652C662C673D617267756D656E74735B305D7C7C7B7D2C683D312C693D617267756D656E74732E6C656E6774682C6A3D21313B666F722822626F6F6C65616E223D3D747970656F6620672626286A3D672C673D617267756D656E7473';
wwv_flow_api.g_varchar2_table(16) := '5B685D7C7C7B7D2C682B2B292C226F626A656374223D3D747970656F6620677C7C6E2E697346756E6374696F6E2867297C7C28673D7B7D292C683D3D3D69262628673D746869732C682D2D293B693E683B682B2B296966286E756C6C213D28653D617267';
wwv_flow_api.g_varchar2_table(17) := '756D656E74735B685D2929666F72286420696E206529613D675B645D2C633D655B645D2C67213D3D632626286A2626632626286E2E6973506C61696E4F626A6563742863297C7C28623D6E2E6973417272617928632929293F28623F28623D21312C663D';
wwv_flow_api.g_varchar2_table(18) := '6126266E2E697341727261792861293F613A5B5D293A663D6126266E2E6973506C61696E4F626A6563742861293F613A7B7D2C675B645D3D6E2E657874656E64286A2C662C6329293A766F69642030213D3D63262628675B645D3D6329293B7265747572';
wwv_flow_api.g_varchar2_table(19) := '6E20677D2C6E2E657874656E64287B657870616E646F3A226A5175657279222B286D2B4D6174682E72616E646F6D2829292E7265706C616365282F5C442F672C2222292C697352656164793A21302C6572726F723A66756E6374696F6E2861297B746872';
wwv_flow_api.g_varchar2_table(20) := '6F77206E6577204572726F722861297D2C6E6F6F703A66756E6374696F6E28297B7D2C697346756E6374696F6E3A66756E6374696F6E2861297B72657475726E2266756E6374696F6E223D3D3D6E2E747970652861297D2C697341727261793A41727261';
wwv_flow_api.g_varchar2_table(21) := '792E697341727261797C7C66756E6374696F6E2861297B72657475726E226172726179223D3D3D6E2E747970652861297D2C697357696E646F773A66756E6374696F6E2861297B72657475726E206E756C6C213D612626613D3D612E77696E646F777D2C';
wwv_flow_api.g_varchar2_table(22) := '69734E756D657269633A66756E6374696F6E2861297B72657475726E20612D7061727365466C6F61742861293E3D307D2C6973456D7074794F626A6563743A66756E6374696F6E2861297B76617220623B666F72286220696E20612972657475726E2131';
wwv_flow_api.g_varchar2_table(23) := '3B72657475726E21307D2C6973506C61696E4F626A6563743A66756E6374696F6E2861297B76617220623B69662821617C7C226F626A65637422213D3D6E2E747970652861297C7C612E6E6F6465547970657C7C6E2E697357696E646F77286129297265';
wwv_flow_api.g_varchar2_table(24) := '7475726E21313B7472797B696628612E636F6E7374727563746F722626216A2E63616C6C28612C22636F6E7374727563746F7222292626216A2E63616C6C28612E636F6E7374727563746F722E70726F746F747970652C22697350726F746F747970654F';
wwv_flow_api.g_varchar2_table(25) := '6622292972657475726E21317D63617463682863297B72657475726E21317D6966286C2E6F776E4C61737429666F72286220696E20612972657475726E206A2E63616C6C28612C62293B666F72286220696E2061293B72657475726E20766F696420303D';
wwv_flow_api.g_varchar2_table(26) := '3D3D627C7C6A2E63616C6C28612C62297D2C747970653A66756E6374696F6E2861297B72657475726E206E756C6C3D3D613F612B22223A226F626A656374223D3D747970656F6620617C7C2266756E6374696F6E223D3D747970656F6620613F685B692E';
wwv_flow_api.g_varchar2_table(27) := '63616C6C2861295D7C7C226F626A656374223A747970656F6620617D2C676C6F62616C4576616C3A66756E6374696F6E2862297B6226266E2E7472696D286229262628612E657865635363726970747C7C66756E6374696F6E2862297B612E6576616C2E';
wwv_flow_api.g_varchar2_table(28) := '63616C6C28612C62297D292862297D2C63616D656C436173653A66756E6374696F6E2861297B72657475726E20612E7265706C61636528702C226D732D22292E7265706C61636528712C72297D2C6E6F64654E616D653A66756E6374696F6E28612C6229';
wwv_flow_api.g_varchar2_table(29) := '7B72657475726E20612E6E6F64654E616D652626612E6E6F64654E616D652E746F4C6F7765724361736528293D3D3D622E746F4C6F7765724361736528297D2C656163683A66756E6374696F6E28612C622C63297B76617220642C653D302C663D612E6C';
wwv_flow_api.g_varchar2_table(30) := '656E6774682C673D732861293B69662863297B69662867297B666F72283B663E653B652B2B29696628643D622E6170706C7928615B655D2C63292C643D3D3D213129627265616B7D656C736520666F72286520696E206129696628643D622E6170706C79';
wwv_flow_api.g_varchar2_table(31) := '28615B655D2C63292C643D3D3D213129627265616B7D656C73652069662867297B666F72283B663E653B652B2B29696628643D622E63616C6C28615B655D2C652C615B655D292C643D3D3D213129627265616B7D656C736520666F72286520696E206129';
wwv_flow_api.g_varchar2_table(32) := '696628643D622E63616C6C28615B655D2C652C615B655D292C643D3D3D213129627265616B3B72657475726E20617D2C7472696D3A6B2626216B2E63616C6C28225C75666566665C78613022293F66756E6374696F6E2861297B72657475726E206E756C';
wwv_flow_api.g_varchar2_table(33) := '6C3D3D613F22223A6B2E63616C6C2861297D3A66756E6374696F6E2861297B72657475726E206E756C6C3D3D613F22223A28612B2222292E7265706C616365286F2C2222297D2C6D616B6541727261793A66756E6374696F6E28612C62297B7661722063';
wwv_flow_api.g_varchar2_table(34) := '3D627C7C5B5D3B72657475726E206E756C6C213D6126262873284F626A656374286129293F6E2E6D6572676528632C22737472696E67223D3D747970656F6620613F5B615D3A61293A662E63616C6C28632C6129292C637D2C696E41727261793A66756E';
wwv_flow_api.g_varchar2_table(35) := '6374696F6E28612C622C63297B76617220643B69662862297B696628672972657475726E20672E63616C6C28622C612C63293B666F7228643D622E6C656E6774682C633D633F303E633F4D6174682E6D617828302C642B63293A633A303B643E633B632B';
wwv_flow_api.g_varchar2_table(36) := '2B296966286320696E20622626625B635D3D3D3D612972657475726E20637D72657475726E2D317D2C6D657267653A66756E6374696F6E28612C62297B76617220633D2B622E6C656E6774682C643D302C653D612E6C656E6774683B7768696C6528633E';
wwv_flow_api.g_varchar2_table(37) := '6429615B652B2B5D3D625B642B2B5D3B69662863213D3D63297768696C6528766F69642030213D3D625B645D29615B652B2B5D3D625B642B2B5D3B72657475726E20612E6C656E6774683D652C617D2C677265703A66756E6374696F6E28612C622C6329';
wwv_flow_api.g_varchar2_table(38) := '7B666F722876617220642C653D5B5D2C663D302C673D612E6C656E6774682C683D21633B673E663B662B2B29643D216228615B665D2C66292C64213D3D682626652E7075736828615B665D293B72657475726E20657D2C6D61703A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(39) := '612C622C63297B76617220642C663D302C673D612E6C656E6774682C683D732861292C693D5B5D3B6966286829666F72283B673E663B662B2B29643D6228615B665D2C662C63292C6E756C6C213D642626692E707573682864293B656C736520666F7228';
wwv_flow_api.g_varchar2_table(40) := '6620696E206129643D6228615B665D2C662C63292C6E756C6C213D642626692E707573682864293B72657475726E20652E6170706C79285B5D2C69297D2C677569643A312C70726F78793A66756E6374696F6E28612C62297B76617220632C652C663B72';
wwv_flow_api.g_varchar2_table(41) := '657475726E22737472696E67223D3D747970656F662062262628663D615B625D2C623D612C613D66292C6E2E697346756E6374696F6E2861293F28633D642E63616C6C28617267756D656E74732C32292C653D66756E6374696F6E28297B72657475726E';
wwv_flow_api.g_varchar2_table(42) := '20612E6170706C7928627C7C746869732C632E636F6E63617428642E63616C6C28617267756D656E74732929297D2C652E677569643D612E677569643D612E677569647C7C6E2E677569642B2B2C65293A766F696420307D2C6E6F773A66756E6374696F';
wwv_flow_api.g_varchar2_table(43) := '6E28297B72657475726E2B6E657720446174657D2C737570706F72743A6C7D292C6E2E656163682822426F6F6C65616E204E756D62657220537472696E672046756E6374696F6E204172726179204461746520526567457870204F626A65637420457272';
wwv_flow_api.g_varchar2_table(44) := '6F72222E73706C697428222022292C66756E6374696F6E28612C62297B685B225B6F626A65637420222B622B225D225D3D622E746F4C6F7765724361736528297D293B66756E6374696F6E20732861297B76617220623D612E6C656E6774682C633D6E2E';
wwv_flow_api.g_varchar2_table(45) := '747970652861293B72657475726E2266756E6374696F6E223D3D3D637C7C6E2E697357696E646F772861293F21313A313D3D3D612E6E6F6465547970652626623F21303A226172726179223D3D3D637C7C303D3D3D627C7C226E756D626572223D3D7479';
wwv_flow_api.g_varchar2_table(46) := '70656F6620622626623E302626622D3120696E20617D76617220743D66756E6374696F6E2861297B76617220622C632C642C652C662C672C682C692C6A2C6B2C6C2C6D2C6E2C6F2C702C712C722C733D2273697A7A6C65222B2D6E657720446174652C74';
wwv_flow_api.g_varchar2_table(47) := '3D612E646F63756D656E742C753D302C763D302C773D656228292C783D656228292C793D656228292C7A3D66756E6374696F6E28612C62297B72657475726E20613D3D3D622626286A3D2130292C307D2C413D22756E646566696E6564222C423D313C3C';
wwv_flow_api.g_varchar2_table(48) := '33312C433D7B7D2E6861734F776E50726F70657274792C443D5B5D2C453D442E706F702C463D442E707573682C473D442E707573682C483D442E736C6963652C493D442E696E6465784F667C7C66756E6374696F6E2861297B666F722876617220623D30';
wwv_flow_api.g_varchar2_table(49) := '2C633D746869732E6C656E6774683B633E623B622B2B29696628746869735B625D3D3D3D612972657475726E20623B72657475726E2D317D2C4A3D22636865636B65647C73656C65637465647C6173796E637C6175746F666F6375737C6175746F706C61';
wwv_flow_api.g_varchar2_table(50) := '797C636F6E74726F6C737C64656665727C64697361626C65647C68696464656E7C69736D61707C6C6F6F707C6D756C7469706C657C6F70656E7C726561646F6E6C797C72657175697265647C73636F706564222C4B3D225B5C5C7832305C5C745C5C725C';
wwv_flow_api.g_varchar2_table(51) := '5C6E5C5C665D222C4C3D22283F3A5C5C5C5C2E7C5B5C5C772D5D7C5B5E5C5C7830302D5C5C7861305D292B222C4D3D4C2E7265706C616365282277222C22772322292C4E3D225C5C5B222B4B2B222A28222B4C2B2229222B4B2B222A283F3A285B2A5E24';
wwv_flow_api.g_varchar2_table(52) := '7C217E5D3F3D29222B4B2B222A283F3A285B275C225D2928283F3A5C5C5C5C2E7C5B5E5C5C5C5C5D292A3F295C5C337C28222B4D2B22297C297C29222B4B2B222A5C5C5D222C4F3D223A28222B4C2B2229283F3A5C5C2828285B275C225D2928283F3A5C';
wwv_flow_api.g_varchar2_table(53) := '5C5C5C2E7C5B5E5C5C5C5C5D292A3F295C5C337C28283F3A5C5C5C5C2E7C5B5E5C5C5C5C28295B5C5C5D5D7C222B4E2E7265706C61636528332C38292B22292A297C2E2A295C5C297C29222C503D6E65772052656745787028225E222B4B2B222B7C2828';
wwv_flow_api.g_varchar2_table(54) := '3F3A5E7C5B5E5C5C5C5C5D29283F3A5C5C5C5C2E292A29222B4B2B222B24222C226722292C513D6E65772052656745787028225E222B4B2B222A2C222B4B2B222A22292C523D6E65772052656745787028225E222B4B2B222A285B3E2B7E5D7C222B4B2B';
wwv_flow_api.g_varchar2_table(55) := '2229222B4B2B222A22292C533D6E65772052656745787028223D222B4B2B222A285B5E5C5C5D275C225D2A3F29222B4B2B222A5C5C5D222C226722292C543D6E657720526567457870284F292C553D6E65772052656745787028225E222B4D2B22242229';
wwv_flow_api.g_varchar2_table(56) := '2C563D7B49443A6E65772052656745787028225E2328222B4C2B222922292C434C4153533A6E65772052656745787028225E5C5C2E28222B4C2B222922292C5441473A6E65772052656745787028225E28222B4C2E7265706C616365282277222C22772A';
wwv_flow_api.g_varchar2_table(57) := '22292B222922292C415454523A6E65772052656745787028225E222B4E292C50534555444F3A6E65772052656745787028225E222B4F292C4348494C443A6E65772052656745787028225E3A286F6E6C797C66697273747C6C6173747C6E74687C6E7468';
wwv_flow_api.g_varchar2_table(58) := '2D6C617374292D286368696C647C6F662D7479706529283F3A5C5C28222B4B2B222A286576656E7C6F64647C28285B2B2D5D7C29285C5C642A296E7C29222B4B2B222A283F3A285B2B2D5D7C29222B4B2B222A285C5C642B297C2929222B4B2B222A5C5C';
wwv_flow_api.g_varchar2_table(59) := '297C29222C226922292C626F6F6C3A6E65772052656745787028225E283F3A222B4A2B222924222C226922292C6E65656473436F6E746578743A6E65772052656745787028225E222B4B2B222A5B3E2B7E5D7C3A286576656E7C6F64647C65717C67747C';
wwv_flow_api.g_varchar2_table(60) := '6C747C6E74687C66697273747C6C61737429283F3A5C5C28222B4B2B222A28283F3A2D5C5C64293F5C5C642A29222B4B2B222A5C5C297C29283F3D5B5E2D5D7C2429222C226922297D2C573D2F5E283F3A696E7075747C73656C6563747C746578746172';
wwv_flow_api.g_varchar2_table(61) := '65617C627574746F6E29242F692C583D2F5E685C64242F692C593D2F5E5B5E7B5D2B5C7B5C732A5C5B6E6174697665205C772F2C5A3D2F5E283F3A23285B5C772D5D2B297C285C772B297C5C2E285B5C772D5D2B2929242F2C243D2F5B2B7E5D2F2C5F3D';
wwv_flow_api.g_varchar2_table(62) := '2F277C5C5C2F672C61623D6E65772052656745787028225C5C5C5C285B5C5C64612D665D7B312C367D222B4B2B223F7C28222B4B2B22297C2E29222C22696722292C62623D66756E6374696F6E28612C622C63297B76617220643D223078222B622D3635';
wwv_flow_api.g_varchar2_table(63) := '3533363B72657475726E2064213D3D647C7C633F623A303E643F537472696E672E66726F6D43686172436F646528642B3635353336293A537472696E672E66726F6D43686172436F646528643E3E31307C35353239362C3130323326647C353633323029';
wwv_flow_api.g_varchar2_table(64) := '7D3B7472797B472E6170706C7928443D482E63616C6C28742E6368696C644E6F646573292C742E6368696C644E6F646573292C445B742E6368696C644E6F6465732E6C656E6774685D2E6E6F6465547970657D6361746368286362297B473D7B6170706C';
wwv_flow_api.g_varchar2_table(65) := '793A442E6C656E6774683F66756E6374696F6E28612C62297B462E6170706C7928612C482E63616C6C286229297D3A66756E6374696F6E28612C62297B76617220633D612E6C656E6774682C643D303B7768696C6528615B632B2B5D3D625B642B2B5D29';
wwv_flow_api.g_varchar2_table(66) := '3B612E6C656E6774683D632D317D7D7D66756E6374696F6E20646228612C622C642C65297B76617220662C672C682C692C6A2C6D2C702C712C752C763B69662828623F622E6F776E6572446F63756D656E747C7C623A7429213D3D6C26266B2862292C62';
wwv_flow_api.g_varchar2_table(67) := '3D627C7C6C2C643D647C7C5B5D2C21617C7C22737472696E6722213D747970656F6620612972657475726E20643B69662831213D3D28693D622E6E6F64655479706529262639213D3D692972657475726E5B5D3B6966286E26262165297B696628663D5A';
wwv_flow_api.g_varchar2_table(68) := '2E6578656328612929696628683D665B315D297B696628393D3D3D69297B696628673D622E676574456C656D656E74427949642868292C21677C7C21672E706172656E744E6F64652972657475726E20643B696628672E69643D3D3D682972657475726E';
wwv_flow_api.g_varchar2_table(69) := '20642E707573682867292C647D656C736520696628622E6F776E6572446F63756D656E74262628673D622E6F776E6572446F63756D656E742E676574456C656D656E74427949642868292926267228622C67292626672E69643D3D3D682972657475726E';
wwv_flow_api.g_varchar2_table(70) := '20642E707573682867292C647D656C73657B696628665B325D2972657475726E20472E6170706C7928642C622E676574456C656D656E747342795461674E616D65286129292C643B69662828683D665B335D292626632E676574456C656D656E74734279';
wwv_flow_api.g_varchar2_table(71) := '436C6173734E616D652626622E676574456C656D656E74734279436C6173734E616D652972657475726E20472E6170706C7928642C622E676574456C656D656E74734279436C6173734E616D65286829292C647D696628632E717361262628216F7C7C21';
wwv_flow_api.g_varchar2_table(72) := '6F2E7465737428612929297B696628713D703D732C753D622C763D393D3D3D692626612C313D3D3D692626226F626A65637422213D3D622E6E6F64654E616D652E746F4C6F776572436173652829297B6D3D6F622861292C28703D622E67657441747472';
wwv_flow_api.g_varchar2_table(73) := '6962757465282269642229293F713D702E7265706C616365285F2C225C5C242622293A622E73657441747472696275746528226964222C71292C713D225B69643D27222B712B22275D20222C6A3D6D2E6C656E6774683B7768696C65286A2D2D296D5B6A';
wwv_flow_api.g_varchar2_table(74) := '5D3D712B7062286D5B6A5D293B753D242E7465737428612926266D6228622E706172656E744E6F6465297C7C622C763D6D2E6A6F696E28222C22297D69662876297472797B72657475726E20472E6170706C7928642C752E717565727953656C6563746F';
wwv_flow_api.g_varchar2_table(75) := '72416C6C287629292C647D63617463682877297B7D66696E616C6C797B707C7C622E72656D6F76654174747269627574652822696422297D7D7D72657475726E20786228612E7265706C61636528502C22243122292C622C642C65297D66756E6374696F';
wwv_flow_api.g_varchar2_table(76) := '6E20656228297B76617220613D5B5D3B66756E6374696F6E206228632C65297B72657475726E20612E7075736828632B222022293E642E63616368654C656E677468262664656C65746520625B612E736869667428295D2C625B632B2220225D3D657D72';
wwv_flow_api.g_varchar2_table(77) := '657475726E20627D66756E6374696F6E2066622861297B72657475726E20615B735D3D21302C617D66756E6374696F6E2067622861297B76617220623D6C2E637265617465456C656D656E74282264697622293B7472797B72657475726E212161286229';
wwv_flow_api.g_varchar2_table(78) := '7D63617463682863297B72657475726E21317D66696E616C6C797B622E706172656E744E6F64652626622E706172656E744E6F64652E72656D6F76654368696C642862292C623D6E756C6C7D7D66756E6374696F6E20686228612C62297B76617220633D';
wwv_flow_api.g_varchar2_table(79) := '612E73706C697428227C22292C653D612E6C656E6774683B7768696C6528652D2D29642E6174747248616E646C655B635B655D5D3D627D66756E6374696F6E20696228612C62297B76617220633D622626612C643D632626313D3D3D612E6E6F64655479';
wwv_flow_api.g_varchar2_table(80) := '70652626313D3D3D622E6E6F6465547970652626287E622E736F75726365496E6465787C7C42292D287E612E736F75726365496E6465787C7C42293B696628642972657475726E20643B69662863297768696C6528633D632E6E6578745369626C696E67';
wwv_flow_api.g_varchar2_table(81) := '29696628633D3D3D622972657475726E2D313B72657475726E20613F313A2D317D66756E6374696F6E206A622861297B72657475726E2066756E6374696F6E2862297B76617220633D622E6E6F64654E616D652E746F4C6F7765724361736528293B7265';
wwv_flow_api.g_varchar2_table(82) := '7475726E22696E707574223D3D3D632626622E747970653D3D3D617D7D66756E6374696F6E206B622861297B72657475726E2066756E6374696F6E2862297B76617220633D622E6E6F64654E616D652E746F4C6F7765724361736528293B72657475726E';
wwv_flow_api.g_varchar2_table(83) := '2822696E707574223D3D3D637C7C22627574746F6E223D3D3D63292626622E747970653D3D3D617D7D66756E6374696F6E206C622861297B72657475726E2066622866756E6374696F6E2862297B72657475726E20623D2B622C66622866756E6374696F';
wwv_flow_api.g_varchar2_table(84) := '6E28632C64297B76617220652C663D61285B5D2C632E6C656E6774682C62292C673D662E6C656E6774683B7768696C6528672D2D29635B653D665B675D5D262628635B655D3D2128645B655D3D635B655D29297D297D297D66756E6374696F6E206D6228';
wwv_flow_api.g_varchar2_table(85) := '61297B72657475726E20612626747970656F6620612E676574456C656D656E747342795461674E616D65213D3D412626617D633D64622E737570706F72743D7B7D2C663D64622E6973584D4C3D66756E6374696F6E2861297B76617220623D6126262861';
wwv_flow_api.g_varchar2_table(86) := '2E6F776E6572446F63756D656E747C7C61292E646F63756D656E74456C656D656E743B72657475726E20623F2248544D4C22213D3D622E6E6F64654E616D653A21317D2C6B3D64622E736574446F63756D656E743D66756E6374696F6E2861297B766172';
wwv_flow_api.g_varchar2_table(87) := '20622C653D613F612E6F776E6572446F63756D656E747C7C613A742C673D652E64656661756C74566965773B72657475726E2065213D3D6C2626393D3D3D652E6E6F6465547970652626652E646F63756D656E74456C656D656E743F286C3D652C6D3D65';
wwv_flow_api.g_varchar2_table(88) := '2E646F63756D656E74456C656D656E742C6E3D21662865292C67262667213D3D672E746F70262628672E6164644576656E744C697374656E65723F672E6164644576656E744C697374656E65722822756E6C6F6164222C66756E6374696F6E28297B6B28';
wwv_flow_api.g_varchar2_table(89) := '297D2C2131293A672E6174746163684576656E742626672E6174746163684576656E7428226F6E756E6C6F6164222C66756E6374696F6E28297B6B28297D29292C632E617474726962757465733D67622866756E6374696F6E2861297B72657475726E20';
wwv_flow_api.g_varchar2_table(90) := '612E636C6173734E616D653D2269222C21612E6765744174747269627574652822636C6173734E616D6522297D292C632E676574456C656D656E747342795461674E616D653D67622866756E6374696F6E2861297B72657475726E20612E617070656E64';
wwv_flow_api.g_varchar2_table(91) := '4368696C6428652E637265617465436F6D6D656E7428222229292C21612E676574456C656D656E747342795461674E616D6528222A22292E6C656E6774687D292C632E676574456C656D656E74734279436C6173734E616D653D592E7465737428652E67';
wwv_flow_api.g_varchar2_table(92) := '6574456C656D656E74734279436C6173734E616D6529262667622866756E6374696F6E2861297B72657475726E20612E696E6E657248544D4C3D223C64697620636C6173733D2761273E3C2F6469763E3C64697620636C6173733D27612069273E3C2F64';
wwv_flow_api.g_varchar2_table(93) := '69763E222C612E66697273744368696C642E636C6173734E616D653D2269222C323D3D3D612E676574456C656D656E74734279436C6173734E616D6528226922292E6C656E6774687D292C632E676574427949643D67622866756E6374696F6E2861297B';
wwv_flow_api.g_varchar2_table(94) := '72657475726E206D2E617070656E644368696C642861292E69643D732C21652E676574456C656D656E747342794E616D657C7C21652E676574456C656D656E747342794E616D652873292E6C656E6774687D292C632E676574427949643F28642E66696E';
wwv_flow_api.g_varchar2_table(95) := '642E49443D66756E6374696F6E28612C62297B696628747970656F6620622E676574456C656D656E7442794964213D3D4126266E297B76617220633D622E676574456C656D656E74427949642861293B72657475726E20632626632E706172656E744E6F';
wwv_flow_api.g_varchar2_table(96) := '64653F5B635D3A5B5D7D7D2C642E66696C7465722E49443D66756E6374696F6E2861297B76617220623D612E7265706C6163652861622C6262293B72657475726E2066756E6374696F6E2861297B72657475726E20612E67657441747472696275746528';
wwv_flow_api.g_varchar2_table(97) := '22696422293D3D3D627D7D293A2864656C65746520642E66696E642E49442C642E66696C7465722E49443D66756E6374696F6E2861297B76617220623D612E7265706C6163652861622C6262293B72657475726E2066756E6374696F6E2861297B766172';
wwv_flow_api.g_varchar2_table(98) := '20633D747970656F6620612E6765744174747269627574654E6F6465213D3D412626612E6765744174747269627574654E6F64652822696422293B72657475726E20632626632E76616C75653D3D3D627D7D292C642E66696E642E5441473D632E676574';
wwv_flow_api.g_varchar2_table(99) := '456C656D656E747342795461674E616D653F66756E6374696F6E28612C62297B72657475726E20747970656F6620622E676574456C656D656E747342795461674E616D65213D3D413F622E676574456C656D656E747342795461674E616D652861293A76';
wwv_flow_api.g_varchar2_table(100) := '6F696420307D3A66756E6374696F6E28612C62297B76617220632C643D5B5D2C653D302C663D622E676574456C656D656E747342795461674E616D652861293B696628222A223D3D3D61297B7768696C6528633D665B652B2B5D29313D3D3D632E6E6F64';
wwv_flow_api.g_varchar2_table(101) := '65547970652626642E707573682863293B72657475726E20647D72657475726E20667D2C642E66696E642E434C4153533D632E676574456C656D656E74734279436C6173734E616D65262666756E6374696F6E28612C62297B72657475726E2074797065';
wwv_flow_api.g_varchar2_table(102) := '6F6620622E676574456C656D656E74734279436C6173734E616D65213D3D4126266E3F622E676574456C656D656E74734279436C6173734E616D652861293A766F696420307D2C703D5B5D2C6F3D5B5D2C28632E7173613D592E7465737428652E717565';
wwv_flow_api.g_varchar2_table(103) := '727953656C6563746F72416C6C292926262867622866756E6374696F6E2861297B612E696E6E657248544D4C3D223C73656C65637420743D27273E3C6F7074696F6E2073656C65637465643D27273E3C2F6F7074696F6E3E3C2F73656C6563743E222C61';
wwv_flow_api.g_varchar2_table(104) := '2E717565727953656C6563746F72416C6C28225B745E3D27275D22292E6C656E67746826266F2E7075736828225B2A5E245D3D222B4B2B222A283F3A27277C5C225C222922292C612E717565727953656C6563746F72416C6C28225B73656C6563746564';
wwv_flow_api.g_varchar2_table(105) := '5D22292E6C656E6774687C7C6F2E7075736828225C5C5B222B4B2B222A283F3A76616C75657C222B4A2B222922292C612E717565727953656C6563746F72416C6C28223A636865636B656422292E6C656E6774687C7C6F2E7075736828223A636865636B';
wwv_flow_api.g_varchar2_table(106) := '656422297D292C67622866756E6374696F6E2861297B76617220623D652E637265617465456C656D656E742822696E70757422293B622E736574417474726962757465282274797065222C2268696464656E22292C612E617070656E644368696C642862';
wwv_flow_api.g_varchar2_table(107) := '292E73657441747472696275746528226E616D65222C224422292C612E717565727953656C6563746F72416C6C28225B6E616D653D645D22292E6C656E67746826266F2E7075736828226E616D65222B4B2B222A5B2A5E247C217E5D3F3D22292C612E71';
wwv_flow_api.g_varchar2_table(108) := '7565727953656C6563746F72416C6C28223A656E61626C656422292E6C656E6774687C7C6F2E7075736828223A656E61626C6564222C223A64697361626C656422292C612E717565727953656C6563746F72416C6C28222A2C3A7822292C6F2E70757368';
wwv_flow_api.g_varchar2_table(109) := '28222C2E2A3A22297D29292C28632E6D61746368657353656C6563746F723D592E7465737428713D6D2E7765626B69744D61746368657353656C6563746F727C7C6D2E6D6F7A4D61746368657353656C6563746F727C7C6D2E6F4D61746368657353656C';
wwv_flow_api.g_varchar2_table(110) := '6563746F727C7C6D2E6D734D61746368657353656C6563746F722929262667622866756E6374696F6E2861297B632E646973636F6E6E65637465644D617463683D712E63616C6C28612C2264697622292C712E63616C6C28612C225B73213D27275D3A78';
wwv_flow_api.g_varchar2_table(111) := '22292C702E707573682822213D222C4F297D292C6F3D6F2E6C656E67746826266E657720526567457870286F2E6A6F696E28227C2229292C703D702E6C656E67746826266E65772052656745787028702E6A6F696E28227C2229292C623D592E74657374';
wwv_flow_api.g_varchar2_table(112) := '286D2E636F6D70617265446F63756D656E74506F736974696F6E292C723D627C7C592E74657374286D2E636F6E7461696E73293F66756E6374696F6E28612C62297B76617220633D393D3D3D612E6E6F6465547970653F612E646F63756D656E74456C65';
wwv_flow_api.g_varchar2_table(113) := '6D656E743A612C643D622626622E706172656E744E6F64653B72657475726E20613D3D3D647C7C212821647C7C31213D3D642E6E6F6465547970657C7C2128632E636F6E7461696E733F632E636F6E7461696E732864293A612E636F6D70617265446F63';
wwv_flow_api.g_varchar2_table(114) := '756D656E74506F736974696F6E2626313626612E636F6D70617265446F63756D656E74506F736974696F6E28642929297D3A66756E6374696F6E28612C62297B69662862297768696C6528623D622E706172656E744E6F646529696628623D3D3D612972';
wwv_flow_api.g_varchar2_table(115) := '657475726E21303B72657475726E21317D2C7A3D623F66756E6374696F6E28612C62297B696628613D3D3D622972657475726E206A3D21302C303B76617220643D21612E636F6D70617265446F63756D656E74506F736974696F6E2D21622E636F6D7061';
wwv_flow_api.g_varchar2_table(116) := '7265446F63756D656E74506F736974696F6E3B72657475726E20643F643A28643D28612E6F776E6572446F63756D656E747C7C61293D3D3D28622E6F776E6572446F63756D656E747C7C62293F612E636F6D70617265446F63756D656E74506F73697469';
wwv_flow_api.g_varchar2_table(117) := '6F6E2862293A312C3126647C7C21632E736F727444657461636865642626622E636F6D70617265446F63756D656E74506F736974696F6E2861293D3D3D643F613D3D3D657C7C612E6F776E6572446F63756D656E743D3D3D7426267228742C61293F2D31';
wwv_flow_api.g_varchar2_table(118) := '3A623D3D3D657C7C622E6F776E6572446F63756D656E743D3D3D7426267228742C62293F313A693F492E63616C6C28692C61292D492E63616C6C28692C62293A303A3426643F2D313A31297D3A66756E6374696F6E28612C62297B696628613D3D3D6229';
wwv_flow_api.g_varchar2_table(119) := '72657475726E206A3D21302C303B76617220632C643D302C663D612E706172656E744E6F64652C673D622E706172656E744E6F64652C683D5B615D2C6B3D5B625D3B69662821667C7C21672972657475726E20613D3D3D653F2D313A623D3D3D653F313A';
wwv_flow_api.g_varchar2_table(120) := '663F2D313A673F313A693F492E63616C6C28692C61292D492E63616C6C28692C62293A303B696628663D3D3D672972657475726E20696228612C62293B633D613B7768696C6528633D632E706172656E744E6F646529682E756E73686966742863293B63';
wwv_flow_api.g_varchar2_table(121) := '3D623B7768696C6528633D632E706172656E744E6F6465296B2E756E73686966742863293B7768696C6528685B645D3D3D3D6B5B645D29642B2B3B72657475726E20643F696228685B645D2C6B5B645D293A685B645D3D3D3D743F2D313A6B5B645D3D3D';
wwv_flow_api.g_varchar2_table(122) := '3D743F313A307D2C65293A6C7D2C64622E6D6174636865733D66756E6374696F6E28612C62297B72657475726E20646228612C6E756C6C2C6E756C6C2C62297D2C64622E6D61746368657353656C6563746F723D66756E6374696F6E28612C62297B6966';
wwv_flow_api.g_varchar2_table(123) := '2828612E6F776E6572446F63756D656E747C7C6129213D3D6C26266B2861292C623D622E7265706C61636528532C223D272431275D22292C212821632E6D61746368657353656C6563746F727C7C216E7C7C702626702E746573742862297C7C6F26266F';
wwv_flow_api.g_varchar2_table(124) := '2E7465737428622929297472797B76617220643D712E63616C6C28612C62293B696628647C7C632E646973636F6E6E65637465644D617463687C7C612E646F63756D656E7426263131213D3D612E646F63756D656E742E6E6F6465547970652972657475';
wwv_flow_api.g_varchar2_table(125) := '726E20647D63617463682865297B7D72657475726E20646228622C6C2C6E756C6C2C5B615D292E6C656E6774683E307D2C64622E636F6E7461696E733D66756E6374696F6E28612C62297B72657475726E28612E6F776E6572446F63756D656E747C7C61';
wwv_flow_api.g_varchar2_table(126) := '29213D3D6C26266B2861292C7228612C62297D2C64622E617474723D66756E6374696F6E28612C62297B28612E6F776E6572446F63756D656E747C7C6129213D3D6C26266B2861293B76617220653D642E6174747248616E646C655B622E746F4C6F7765';
wwv_flow_api.g_varchar2_table(127) := '724361736528295D2C663D652626432E63616C6C28642E6174747248616E646C652C622E746F4C6F776572436173652829293F6528612C622C216E293A766F696420303B72657475726E20766F69642030213D3D663F663A632E61747472696275746573';
wwv_flow_api.g_varchar2_table(128) := '7C7C216E3F612E6765744174747269627574652862293A28663D612E6765744174747269627574654E6F6465286229292626662E7370656369666965643F662E76616C75653A6E756C6C7D2C64622E6572726F723D66756E6374696F6E2861297B746872';
wwv_flow_api.g_varchar2_table(129) := '6F77206E6577204572726F72282253796E746178206572726F722C20756E7265636F676E697A65642065787072657373696F6E3A20222B61297D2C64622E756E69717565536F72743D66756E6374696F6E2861297B76617220622C643D5B5D2C653D302C';
wwv_flow_api.g_varchar2_table(130) := '663D303B6966286A3D21632E6465746563744475706C6963617465732C693D21632E736F7274537461626C652626612E736C6963652830292C612E736F7274287A292C6A297B7768696C6528623D615B662B2B5D29623D3D3D615B665D262628653D642E';
wwv_flow_api.g_varchar2_table(131) := '70757368286629293B7768696C6528652D2D29612E73706C69636528645B655D2C31297D72657475726E20693D6E756C6C2C617D2C653D64622E676574546578743D66756E6374696F6E2861297B76617220622C633D22222C643D302C663D612E6E6F64';
wwv_flow_api.g_varchar2_table(132) := '65547970653B69662866297B696628313D3D3D667C7C393D3D3D667C7C31313D3D3D66297B69662822737472696E67223D3D747970656F6620612E74657874436F6E74656E742972657475726E20612E74657874436F6E74656E743B666F7228613D612E';
wwv_flow_api.g_varchar2_table(133) := '66697273744368696C643B613B613D612E6E6578745369626C696E6729632B3D652861297D656C736520696628333D3D3D667C7C343D3D3D662972657475726E20612E6E6F646556616C75657D656C7365207768696C6528623D615B642B2B5D29632B3D';
wwv_flow_api.g_varchar2_table(134) := '652862293B72657475726E20637D2C643D64622E73656C6563746F72733D7B63616368654C656E6774683A35302C63726561746550736575646F3A66622C6D617463683A562C6174747248616E646C653A7B7D2C66696E643A7B7D2C72656C6174697665';
wwv_flow_api.g_varchar2_table(135) := '3A7B223E223A7B6469723A22706172656E744E6F6465222C66697273743A21307D2C2220223A7B6469723A22706172656E744E6F6465227D2C222B223A7B6469723A2270726576696F75735369626C696E67222C66697273743A21307D2C227E223A7B64';
wwv_flow_api.g_varchar2_table(136) := '69723A2270726576696F75735369626C696E67227D7D2C70726546696C7465723A7B415454523A66756E6374696F6E2861297B72657475726E20615B315D3D615B315D2E7265706C6163652861622C6262292C615B335D3D28615B345D7C7C615B355D7C';
wwv_flow_api.g_varchar2_table(137) := '7C2222292E7265706C6163652861622C6262292C227E3D223D3D3D615B325D262628615B335D3D2220222B615B335D2B222022292C612E736C69636528302C34297D2C4348494C443A66756E6374696F6E2861297B72657475726E20615B315D3D615B31';
wwv_flow_api.g_varchar2_table(138) := '5D2E746F4C6F7765724361736528292C226E7468223D3D3D615B315D2E736C69636528302C33293F28615B335D7C7C64622E6572726F7228615B305D292C615B345D3D2B28615B345D3F615B355D2B28615B365D7C7C31293A322A28226576656E223D3D';
wwv_flow_api.g_varchar2_table(139) := '3D615B335D7C7C226F6464223D3D3D615B335D29292C615B355D3D2B28615B375D2B615B385D7C7C226F6464223D3D3D615B335D29293A615B335D262664622E6572726F7228615B305D292C617D2C50534555444F3A66756E6374696F6E2861297B7661';
wwv_flow_api.g_varchar2_table(140) := '7220622C633D21615B355D2626615B325D3B72657475726E20562E4348494C442E7465737428615B305D293F6E756C6C3A28615B335D2626766F69642030213D3D615B345D3F615B325D3D615B345D3A632626542E74657374286329262628623D6F6228';
wwv_flow_api.g_varchar2_table(141) := '632C21302929262628623D632E696E6465784F66282229222C632E6C656E6774682D62292D632E6C656E67746829262628615B305D3D615B305D2E736C69636528302C62292C615B325D3D632E736C69636528302C6229292C612E736C69636528302C33';
wwv_flow_api.g_varchar2_table(142) := '29297D7D2C66696C7465723A7B5441473A66756E6374696F6E2861297B76617220623D612E7265706C6163652861622C6262292E746F4C6F7765724361736528293B72657475726E222A223D3D3D613F66756E6374696F6E28297B72657475726E21307D';
wwv_flow_api.g_varchar2_table(143) := '3A66756E6374696F6E2861297B72657475726E20612E6E6F64654E616D652626612E6E6F64654E616D652E746F4C6F7765724361736528293D3D3D627D7D2C434C4153533A66756E6374696F6E2861297B76617220623D775B612B2220225D3B72657475';
wwv_flow_api.g_varchar2_table(144) := '726E20627C7C28623D6E6577205265674578702822285E7C222B4B2B2229222B612B2228222B4B2B227C242922292926267728612C66756E6374696F6E2861297B72657475726E20622E746573742822737472696E67223D3D747970656F6620612E636C';
wwv_flow_api.g_varchar2_table(145) := '6173734E616D652626612E636C6173734E616D657C7C747970656F6620612E676574417474726962757465213D3D412626612E6765744174747269627574652822636C61737322297C7C2222297D297D2C415454523A66756E6374696F6E28612C622C63';
wwv_flow_api.g_varchar2_table(146) := '297B72657475726E2066756E6374696F6E2864297B76617220653D64622E6174747228642C61293B72657475726E206E756C6C3D3D653F22213D223D3D3D623A623F28652B3D22222C223D223D3D3D623F653D3D3D633A22213D223D3D3D623F65213D3D';
wwv_flow_api.g_varchar2_table(147) := '633A225E3D223D3D3D623F632626303D3D3D652E696E6465784F662863293A222A3D223D3D3D623F632626652E696E6465784F662863293E2D313A22243D223D3D3D623F632626652E736C696365282D632E6C656E677468293D3D3D633A227E3D223D3D';
wwv_flow_api.g_varchar2_table(148) := '3D623F282220222B652B222022292E696E6465784F662863293E2D313A227C3D223D3D3D623F653D3D3D637C7C652E736C69636528302C632E6C656E6774682B31293D3D3D632B222D223A2131293A21307D7D2C4348494C443A66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(149) := '2C622C632C642C65297B76617220663D226E746822213D3D612E736C69636528302C33292C673D226C61737422213D3D612E736C696365282D34292C683D226F662D74797065223D3D3D623B72657475726E20313D3D3D642626303D3D3D653F66756E63';
wwv_flow_api.g_varchar2_table(150) := '74696F6E2861297B72657475726E2121612E706172656E744E6F64657D3A66756E6374696F6E28622C632C69297B766172206A2C6B2C6C2C6D2C6E2C6F2C703D66213D3D673F226E6578745369626C696E67223A2270726576696F75735369626C696E67';
wwv_flow_api.g_varchar2_table(151) := '222C713D622E706172656E744E6F64652C723D682626622E6E6F64654E616D652E746F4C6F7765724361736528292C743D2169262621683B69662871297B69662866297B7768696C652870297B6C3D623B7768696C65286C3D6C5B705D29696628683F6C';
wwv_flow_api.g_varchar2_table(152) := '2E6E6F64654E616D652E746F4C6F7765724361736528293D3D3D723A313D3D3D6C2E6E6F6465547970652972657475726E21313B6F3D703D226F6E6C79223D3D3D612626216F2626226E6578745369626C696E67227D72657475726E21307D6966286F3D';
wwv_flow_api.g_varchar2_table(153) := '5B673F712E66697273744368696C643A712E6C6173744368696C645D2C67262674297B6B3D715B735D7C7C28715B735D3D7B7D292C6A3D6B5B615D7C7C5B5D2C6E3D6A5B305D3D3D3D7526266A5B315D2C6D3D6A5B305D3D3D3D7526266A5B325D2C6C3D';
wwv_flow_api.g_varchar2_table(154) := '6E2626712E6368696C644E6F6465735B6E5D3B7768696C65286C3D2B2B6E26266C26266C5B705D7C7C286D3D6E3D30297C7C6F2E706F70282929696628313D3D3D6C2E6E6F64655479706526262B2B6D26266C3D3D3D62297B6B5B615D3D5B752C6E2C6D';
wwv_flow_api.g_varchar2_table(155) := '5D3B627265616B7D7D656C736520696628742626286A3D28625B735D7C7C28625B735D3D7B7D29295B615D2926266A5B305D3D3D3D75296D3D6A5B315D3B656C7365207768696C65286C3D2B2B6E26266C26266C5B705D7C7C286D3D6E3D30297C7C6F2E';
wwv_flow_api.g_varchar2_table(156) := '706F7028292969662828683F6C2E6E6F64654E616D652E746F4C6F7765724361736528293D3D3D723A313D3D3D6C2E6E6F6465547970652926262B2B6D26262874262628286C5B735D7C7C286C5B735D3D7B7D29295B615D3D5B752C6D5D292C6C3D3D3D';
wwv_flow_api.g_varchar2_table(157) := '622929627265616B3B72657475726E206D2D3D652C6D3D3D3D647C7C6D25643D3D3D3026266D2F643E3D307D7D7D2C50534555444F3A66756E6374696F6E28612C62297B76617220632C653D642E70736575646F735B615D7C7C642E73657446696C7465';
wwv_flow_api.g_varchar2_table(158) := '72735B612E746F4C6F7765724361736528295D7C7C64622E6572726F722822756E737570706F727465642070736575646F3A20222B61293B72657475726E20655B735D3F652862293A652E6C656E6774683E313F28633D5B612C612C22222C625D2C642E';
wwv_flow_api.g_varchar2_table(159) := '73657446696C746572732E6861734F776E50726F706572747928612E746F4C6F776572436173652829293F66622866756E6374696F6E28612C63297B76617220642C663D6528612C62292C673D662E6C656E6774683B7768696C6528672D2D29643D492E';
wwv_flow_api.g_varchar2_table(160) := '63616C6C28612C665B675D292C615B645D3D2128635B645D3D665B675D297D293A66756E6374696F6E2861297B72657475726E206528612C302C63297D293A657D7D2C70736575646F733A7B6E6F743A66622866756E6374696F6E2861297B7661722062';
wwv_flow_api.g_varchar2_table(161) := '3D5B5D2C633D5B5D2C643D6728612E7265706C61636528502C2224312229293B72657475726E20645B735D3F66622866756E6374696F6E28612C622C632C65297B76617220662C673D6428612C6E756C6C2C652C5B5D292C683D612E6C656E6774683B77';
wwv_flow_api.g_varchar2_table(162) := '68696C6528682D2D2928663D675B685D29262628615B685D3D2128625B685D3D6629297D293A66756E6374696F6E28612C652C66297B72657475726E20625B305D3D612C6428622C6E756C6C2C662C63292C21632E706F7028297D7D292C6861733A6662';
wwv_flow_api.g_varchar2_table(163) := '2866756E6374696F6E2861297B72657475726E2066756E6374696F6E2862297B72657475726E20646228612C62292E6C656E6774683E307D7D292C636F6E7461696E733A66622866756E6374696F6E2861297B72657475726E2066756E6374696F6E2862';
wwv_flow_api.g_varchar2_table(164) := '297B72657475726E28622E74657874436F6E74656E747C7C622E696E6E6572546578747C7C65286229292E696E6465784F662861293E2D317D7D292C6C616E673A66622866756E6374696F6E2861297B72657475726E20552E7465737428617C7C222229';
wwv_flow_api.g_varchar2_table(165) := '7C7C64622E6572726F722822756E737570706F72746564206C616E673A20222B61292C613D612E7265706C6163652861622C6262292E746F4C6F7765724361736528292C66756E6374696F6E2862297B76617220633B646F20696628633D6E3F622E6C61';
wwv_flow_api.g_varchar2_table(166) := '6E673A622E6765744174747269627574652822786D6C3A6C616E6722297C7C622E67657441747472696275746528226C616E6722292972657475726E20633D632E746F4C6F7765724361736528292C633D3D3D617C7C303D3D3D632E696E6465784F6628';
wwv_flow_api.g_varchar2_table(167) := '612B222D22293B7768696C652828623D622E706172656E744E6F6465292626313D3D3D622E6E6F646554797065293B72657475726E21317D7D292C7461726765743A66756E6374696F6E2862297B76617220633D612E6C6F636174696F6E2626612E6C6F';
wwv_flow_api.g_varchar2_table(168) := '636174696F6E2E686173683B72657475726E20632626632E736C6963652831293D3D3D622E69647D2C726F6F743A66756E6374696F6E2861297B72657475726E20613D3D3D6D7D2C666F6375733A66756E6374696F6E2861297B72657475726E20613D3D';
wwv_flow_api.g_varchar2_table(169) := '3D6C2E616374697665456C656D656E74262628216C2E686173466F6375737C7C6C2E686173466F6375732829292626212128612E747970657C7C612E687265667C7C7E612E746162496E646578297D2C656E61626C65643A66756E6374696F6E2861297B';
wwv_flow_api.g_varchar2_table(170) := '72657475726E20612E64697361626C65643D3D3D21317D2C64697361626C65643A66756E6374696F6E2861297B72657475726E20612E64697361626C65643D3D3D21307D2C636865636B65643A66756E6374696F6E2861297B76617220623D612E6E6F64';
wwv_flow_api.g_varchar2_table(171) := '654E616D652E746F4C6F7765724361736528293B72657475726E22696E707574223D3D3D6226262121612E636865636B65647C7C226F7074696F6E223D3D3D6226262121612E73656C65637465647D2C73656C65637465643A66756E6374696F6E286129';
wwv_flow_api.g_varchar2_table(172) := '7B72657475726E20612E706172656E744E6F64652626612E706172656E744E6F64652E73656C6563746564496E6465782C612E73656C65637465643D3D3D21307D2C656D7074793A66756E6374696F6E2861297B666F7228613D612E6669727374436869';
wwv_flow_api.g_varchar2_table(173) := '6C643B613B613D612E6E6578745369626C696E6729696628612E6E6F6465547970653C362972657475726E21313B72657475726E21307D2C706172656E743A66756E6374696F6E2861297B72657475726E21642E70736575646F732E656D707479286129';
wwv_flow_api.g_varchar2_table(174) := '7D2C6865616465723A66756E6374696F6E2861297B72657475726E20582E7465737428612E6E6F64654E616D65297D2C696E7075743A66756E6374696F6E2861297B72657475726E20572E7465737428612E6E6F64654E616D65297D2C627574746F6E3A';
wwv_flow_api.g_varchar2_table(175) := '66756E6374696F6E2861297B76617220623D612E6E6F64654E616D652E746F4C6F7765724361736528293B72657475726E22696E707574223D3D3D62262622627574746F6E223D3D3D612E747970657C7C22627574746F6E223D3D3D627D2C746578743A';
wwv_flow_api.g_varchar2_table(176) := '66756E6374696F6E2861297B76617220623B72657475726E22696E707574223D3D3D612E6E6F64654E616D652E746F4C6F77657243617365282926262274657874223D3D3D612E747970652626286E756C6C3D3D28623D612E6765744174747269627574';
wwv_flow_api.g_varchar2_table(177) := '652822747970652229297C7C2274657874223D3D3D622E746F4C6F776572436173652829297D2C66697273743A6C622866756E6374696F6E28297B72657475726E5B305D7D292C6C6173743A6C622866756E6374696F6E28612C62297B72657475726E5B';
wwv_flow_api.g_varchar2_table(178) := '622D315D7D292C65713A6C622866756E6374696F6E28612C622C63297B72657475726E5B303E633F632B623A635D7D292C6576656E3A6C622866756E6374696F6E28612C62297B666F722876617220633D303B623E633B632B3D3229612E707573682863';
wwv_flow_api.g_varchar2_table(179) := '293B72657475726E20617D292C6F64643A6C622866756E6374696F6E28612C62297B666F722876617220633D313B623E633B632B3D3229612E707573682863293B72657475726E20617D292C6C743A6C622866756E6374696F6E28612C622C63297B666F';
wwv_flow_api.g_varchar2_table(180) := '722876617220643D303E633F632B623A633B2D2D643E3D303B29612E707573682864293B72657475726E20617D292C67743A6C622866756E6374696F6E28612C622C63297B666F722876617220643D303E633F632B623A633B2B2B643C623B29612E7075';
wwv_flow_api.g_varchar2_table(181) := '73682864293B72657475726E20617D297D7D2C642E70736575646F732E6E74683D642E70736575646F732E65713B666F72286220696E7B726164696F3A21302C636865636B626F783A21302C66696C653A21302C70617373776F72643A21302C696D6167';
wwv_flow_api.g_varchar2_table(182) := '653A21307D29642E70736575646F735B625D3D6A622862293B666F72286220696E7B7375626D69743A21302C72657365743A21307D29642E70736575646F735B625D3D6B622862293B66756E6374696F6E206E6228297B7D6E622E70726F746F74797065';
wwv_flow_api.g_varchar2_table(183) := '3D642E66696C746572733D642E70736575646F732C642E73657446696C746572733D6E6577206E623B66756E6374696F6E206F6228612C62297B76617220632C652C662C672C682C692C6A2C6B3D785B612B2220225D3B6966286B2972657475726E2062';
wwv_flow_api.g_varchar2_table(184) := '3F303A6B2E736C6963652830293B683D612C693D5B5D2C6A3D642E70726546696C7465723B7768696C652868297B2821637C7C28653D512E65786563286829292926262865262628683D682E736C69636528655B305D2E6C656E677468297C7C68292C69';
wwv_flow_api.g_varchar2_table(185) := '2E7075736828663D5B5D29292C633D21312C28653D522E6578656328682929262628633D652E736869667428292C662E70757368287B76616C75653A632C747970653A655B305D2E7265706C61636528502C222022297D292C683D682E736C6963652863';
wwv_flow_api.g_varchar2_table(186) := '2E6C656E67746829293B666F72286720696E20642E66696C746572292128653D565B675D2E65786563286829297C7C6A5B675D26262128653D6A5B675D286529297C7C28633D652E736869667428292C662E70757368287B76616C75653A632C74797065';
wwv_flow_api.g_varchar2_table(187) := '3A672C6D6174636865733A657D292C683D682E736C69636528632E6C656E67746829293B696628216329627265616B7D72657475726E20623F682E6C656E6774683A683F64622E6572726F722861293A7828612C69292E736C6963652830297D66756E63';
wwv_flow_api.g_varchar2_table(188) := '74696F6E2070622861297B666F722876617220623D302C633D612E6C656E6774682C643D22223B633E623B622B2B29642B3D615B625D2E76616C75653B72657475726E20647D66756E6374696F6E20716228612C622C63297B76617220643D622E646972';
wwv_flow_api.g_varchar2_table(189) := '2C653D63262622706172656E744E6F6465223D3D3D642C663D762B2B3B72657475726E20622E66697273743F66756E6374696F6E28622C632C66297B7768696C6528623D625B645D29696628313D3D3D622E6E6F6465547970657C7C652972657475726E';
wwv_flow_api.g_varchar2_table(190) := '206128622C632C66297D3A66756E6374696F6E28622C632C67297B76617220682C692C6A3D5B752C665D3B69662867297B7768696C6528623D625B645D2969662828313D3D3D622E6E6F6465547970657C7C652926266128622C632C6729297265747572';
wwv_flow_api.g_varchar2_table(191) := '6E21307D656C7365207768696C6528623D625B645D29696628313D3D3D622E6E6F6465547970657C7C65297B696628693D625B735D7C7C28625B735D3D7B7D292C28683D695B645D292626685B305D3D3D3D752626685B315D3D3D3D662972657475726E';
wwv_flow_api.g_varchar2_table(192) := '206A5B325D3D685B325D3B696628695B645D3D6A2C6A5B325D3D6128622C632C67292972657475726E21307D7D7D66756E6374696F6E2072622861297B72657475726E20612E6C656E6774683E313F66756E6374696F6E28622C632C64297B7661722065';
wwv_flow_api.g_varchar2_table(193) := '3D612E6C656E6774683B7768696C6528652D2D2969662821615B655D28622C632C64292972657475726E21313B72657475726E21307D3A615B305D7D66756E6374696F6E20736228612C622C632C642C65297B666F722876617220662C673D5B5D2C683D';
wwv_flow_api.g_varchar2_table(194) := '302C693D612E6C656E6774682C6A3D6E756C6C213D623B693E683B682B2B2928663D615B685D2926262821637C7C6328662C642C652929262628672E707573682866292C6A2626622E70757368286829293B72657475726E20677D66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(195) := '746228612C622C632C642C652C66297B72657475726E2064262621645B735D262628643D7462286429292C65262621655B735D262628653D746228652C6629292C66622866756E6374696F6E28662C672C682C69297B766172206A2C6B2C6C2C6D3D5B5D';
wwv_flow_api.g_varchar2_table(196) := '2C6E3D5B5D2C6F3D672E6C656E6774682C703D667C7C776228627C7C222A222C682E6E6F6465547970653F5B685D3A682C5B5D292C713D21617C7C21662626623F703A736228702C6D2C612C682C69292C723D633F657C7C28663F613A6F7C7C64293F5B';
wwv_flow_api.g_varchar2_table(197) := '5D3A673A713B6966286326266328712C722C682C69292C64297B6A3D736228722C6E292C64286A2C5B5D2C682C69292C6B3D6A2E6C656E6774683B7768696C65286B2D2D29286C3D6A5B6B5D29262628725B6E5B6B5D5D3D2128715B6E5B6B5D5D3D6C29';
wwv_flow_api.g_varchar2_table(198) := '297D69662866297B696628657C7C61297B69662865297B6A3D5B5D2C6B3D722E6C656E6774683B7768696C65286B2D2D29286C3D725B6B5D2926266A2E7075736828715B6B5D3D6C293B65286E756C6C2C723D5B5D2C6A2C69297D6B3D722E6C656E6774';
wwv_flow_api.g_varchar2_table(199) := '683B7768696C65286B2D2D29286C3D725B6B5D292626286A3D653F492E63616C6C28662C6C293A6D5B6B5D293E2D31262628665B6A5D3D2128675B6A5D3D6C29297D7D656C736520723D736228723D3D3D673F722E73706C696365286F2C722E6C656E67';
wwv_flow_api.g_varchar2_table(200) := '7468293A72292C653F65286E756C6C2C672C722C69293A472E6170706C7928672C72297D297D66756E6374696F6E2075622861297B666F722876617220622C632C652C663D612E6C656E6774682C673D642E72656C61746976655B615B305D2E74797065';
wwv_flow_api.g_varchar2_table(201) := '5D2C693D677C7C642E72656C61746976655B2220225D2C6A3D673F313A302C6B3D71622866756E6374696F6E2861297B72657475726E20613D3D3D627D2C692C2130292C6C3D71622866756E6374696F6E2861297B72657475726E20492E63616C6C2862';
wwv_flow_api.g_varchar2_table(202) := '2C61293E2D317D2C692C2130292C6D3D5B66756E6374696F6E28612C632C64297B72657475726E2167262628647C7C63213D3D68297C7C2828623D63292E6E6F6465547970653F6B28612C632C64293A6C28612C632C6429297D5D3B663E6A3B6A2B2B29';
wwv_flow_api.g_varchar2_table(203) := '696628633D642E72656C61746976655B615B6A5D2E747970655D296D3D5B7162287262286D292C63295D3B656C73657B696628633D642E66696C7465725B615B6A5D2E747970655D2E6170706C79286E756C6C2C615B6A5D2E6D617463686573292C635B';
wwv_flow_api.g_varchar2_table(204) := '735D297B666F7228653D2B2B6A3B663E653B652B2B29696628642E72656C61746976655B615B655D2E747970655D29627265616B3B72657475726E207462286A3E3126267262286D292C6A3E312626706228612E736C69636528302C6A2D31292E636F6E';
wwv_flow_api.g_varchar2_table(205) := '636174287B76616C75653A2220223D3D3D615B6A2D325D2E747970653F222A223A22227D29292E7265706C61636528502C22243122292C632C653E6A2626756228612E736C696365286A2C6529292C663E652626756228613D612E736C69636528652929';
wwv_flow_api.g_varchar2_table(206) := '2C663E6526267062286129297D6D2E707573682863297D72657475726E207262286D297D66756E6374696F6E20766228612C62297B76617220633D622E6C656E6774683E302C653D612E6C656E6774683E302C663D66756E6374696F6E28662C672C692C';
wwv_flow_api.g_varchar2_table(207) := '6A2C6B297B766172206D2C6E2C6F2C703D302C713D2230222C723D6626265B5D2C733D5B5D2C743D682C763D667C7C652626642E66696E642E54414728222A222C6B292C773D752B3D6E756C6C3D3D743F313A4D6174682E72616E646F6D28297C7C2E31';
wwv_flow_api.g_varchar2_table(208) := '2C783D762E6C656E6774683B666F72286B262628683D67213D3D6C262667293B71213D3D7826266E756C6C213D286D3D765B715D293B712B2B297B6966286526266D297B6E3D303B7768696C65286F3D615B6E2B2B5D296966286F286D2C672C6929297B';
wwv_flow_api.g_varchar2_table(209) := '6A2E70757368286D293B627265616B7D6B262628753D77297D63262628286D3D216F26266D292626702D2D2C662626722E70757368286D29297D696628702B3D712C63262671213D3D70297B6E3D303B7768696C65286F3D625B6E2B2B5D296F28722C73';
wwv_flow_api.g_varchar2_table(210) := '2C672C69293B69662866297B696628703E30297768696C6528712D2D29725B715D7C7C735B715D7C7C28735B715D3D452E63616C6C286A29293B733D73622873297D472E6170706C79286A2C73292C6B262621662626732E6C656E6774683E302626702B';
wwv_flow_api.g_varchar2_table(211) := '622E6C656E6774683E31262664622E756E69717565536F7274286A297D72657475726E206B262628753D772C683D74292C727D3B72657475726E20633F66622866293A667D673D64622E636F6D70696C653D66756E6374696F6E28612C62297B76617220';
wwv_flow_api.g_varchar2_table(212) := '632C643D5B5D2C653D5B5D2C663D795B612B2220225D3B6966282166297B627C7C28623D6F62286129292C633D622E6C656E6774683B7768696C6528632D2D29663D756228625B635D292C665B735D3F642E707573682866293A652E707573682866293B';
wwv_flow_api.g_varchar2_table(213) := '663D7928612C766228652C6429297D72657475726E20667D3B66756E6374696F6E20776228612C622C63297B666F722876617220643D302C653D622E6C656E6774683B653E643B642B2B29646228612C625B645D2C63293B72657475726E20637D66756E';
wwv_flow_api.g_varchar2_table(214) := '6374696F6E20786228612C622C652C66297B76617220682C692C6A2C6B2C6C2C6D3D6F622861293B69662821662626313D3D3D6D2E6C656E677468297B696628693D6D5B305D3D6D5B305D2E736C6963652830292C692E6C656E6774683E322626224944';
wwv_flow_api.g_varchar2_table(215) := '223D3D3D286A3D695B305D292E747970652626632E676574427949642626393D3D3D622E6E6F64655479706526266E2626642E72656C61746976655B695B315D2E747970655D297B696628623D28642E66696E642E4944286A2E6D6174636865735B305D';
wwv_flow_api.g_varchar2_table(216) := '2E7265706C6163652861622C6262292C62297C7C5B5D295B305D2C21622972657475726E20653B613D612E736C69636528692E736869667428292E76616C75652E6C656E677468297D683D562E6E65656473436F6E746578742E746573742861293F303A';
wwv_flow_api.g_varchar2_table(217) := '692E6C656E6774683B7768696C6528682D2D297B6966286A3D695B685D2C642E72656C61746976655B6B3D6A2E747970655D29627265616B3B696628286C3D642E66696E645B6B5D29262628663D6C286A2E6D6174636865735B305D2E7265706C616365';
wwv_flow_api.g_varchar2_table(218) := '2861622C6262292C242E7465737428695B305D2E747970652926266D6228622E706172656E744E6F6465297C7C622929297B696628692E73706C69636528682C31292C613D662E6C656E677468262670622869292C21612972657475726E20472E617070';
wwv_flow_api.g_varchar2_table(219) := '6C7928652C66292C653B627265616B7D7D7D72657475726E206728612C6D2928662C622C216E2C652C242E7465737428612926266D6228622E706172656E744E6F6465297C7C62292C657D72657475726E20632E736F7274537461626C653D732E73706C';
wwv_flow_api.g_varchar2_table(220) := '6974282222292E736F7274287A292E6A6F696E282222293D3D3D732C632E6465746563744475706C6963617465733D21216A2C6B28292C632E736F727444657461636865643D67622866756E6374696F6E2861297B72657475726E203126612E636F6D70';
wwv_flow_api.g_varchar2_table(221) := '617265446F63756D656E74506F736974696F6E286C2E637265617465456C656D656E7428226469762229297D292C67622866756E6374696F6E2861297B72657475726E20612E696E6E657248544D4C3D223C6120687265663D2723273E3C2F613E222C22';
wwv_flow_api.g_varchar2_table(222) := '23223D3D3D612E66697273744368696C642E67657441747472696275746528226872656622297D297C7C68622822747970657C687265667C6865696768747C7769647468222C66756E6374696F6E28612C622C63297B72657475726E20633F766F696420';
wwv_flow_api.g_varchar2_table(223) := '303A612E67657441747472696275746528622C2274797065223D3D3D622E746F4C6F7765724361736528293F313A32297D292C632E61747472696275746573262667622866756E6374696F6E2861297B72657475726E20612E696E6E657248544D4C3D22';
wwv_flow_api.g_varchar2_table(224) := '3C696E7075742F3E222C612E66697273744368696C642E736574417474726962757465282276616C7565222C2222292C22223D3D3D612E66697273744368696C642E676574417474726962757465282276616C756522297D297C7C6862282276616C7565';
wwv_flow_api.g_varchar2_table(225) := '222C66756E6374696F6E28612C622C63297B72657475726E20637C7C22696E70757422213D3D612E6E6F64654E616D652E746F4C6F7765724361736528293F766F696420303A612E64656661756C7456616C75657D292C67622866756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(226) := '297B72657475726E206E756C6C3D3D612E676574417474726962757465282264697361626C656422297D297C7C6862284A2C66756E6374696F6E28612C622C63297B76617220643B72657475726E20633F766F696420303A615B625D3D3D3D21303F622E';
wwv_flow_api.g_varchar2_table(227) := '746F4C6F7765724361736528293A28643D612E6765744174747269627574654E6F6465286229292626642E7370656369666965643F642E76616C75653A6E756C6C7D292C64627D2861293B6E2E66696E643D742C6E2E657870723D742E73656C6563746F';
wwv_flow_api.g_varchar2_table(228) := '72732C6E2E657870725B223A225D3D6E2E657870722E70736575646F732C6E2E756E697175653D742E756E69717565536F72742C6E2E746578743D742E676574546578742C6E2E6973584D4C446F633D742E6973584D4C2C6E2E636F6E7461696E733D74';
wwv_flow_api.g_varchar2_table(229) := '2E636F6E7461696E733B76617220753D6E2E657870722E6D617463682E6E65656473436F6E746578742C763D2F5E3C285C772B295C732A5C2F3F3E283F3A3C5C2F5C313E7C29242F2C773D2F5E2E5B5E3A235C5B5C2E2C5D2A242F3B66756E6374696F6E';
wwv_flow_api.g_varchar2_table(230) := '207828612C622C63297B6966286E2E697346756E6374696F6E2862292972657475726E206E2E6772657028612C66756E6374696F6E28612C64297B72657475726E2121622E63616C6C28612C642C6129213D3D637D293B696628622E6E6F646554797065';
wwv_flow_api.g_varchar2_table(231) := '2972657475726E206E2E6772657028612C66756E6374696F6E2861297B72657475726E20613D3D3D62213D3D637D293B69662822737472696E67223D3D747970656F662062297B696628772E746573742862292972657475726E206E2E66696C74657228';
wwv_flow_api.g_varchar2_table(232) := '622C612C63293B623D6E2E66696C74657228622C61297D72657475726E206E2E6772657028612C66756E6374696F6E2861297B72657475726E206E2E696E417272617928612C62293E3D30213D3D637D297D6E2E66696C7465723D66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(233) := '612C622C63297B76617220643D625B305D3B72657475726E2063262628613D223A6E6F7428222B612B222922292C313D3D3D622E6C656E6774682626313D3D3D642E6E6F6465547970653F6E2E66696E642E6D61746368657353656C6563746F7228642C';
wwv_flow_api.g_varchar2_table(234) := '61293F5B645D3A5B5D3A6E2E66696E642E6D61746368657328612C6E2E6772657028622C66756E6374696F6E2861297B72657475726E20313D3D3D612E6E6F6465547970657D29297D2C6E2E666E2E657874656E64287B66696E643A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(235) := '2861297B76617220622C633D5B5D2C643D746869732C653D642E6C656E6774683B69662822737472696E6722213D747970656F6620612972657475726E20746869732E70757368537461636B286E2861292E66696C7465722866756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(236) := '666F7228623D303B653E623B622B2B296966286E2E636F6E7461696E7328645B625D2C74686973292972657475726E21307D29293B666F7228623D303B653E623B622B2B296E2E66696E6428612C645B625D2C63293B72657475726E20633D746869732E';
wwv_flow_api.g_varchar2_table(237) := '70757368537461636B28653E313F6E2E756E697175652863293A63292C632E73656C6563746F723D746869732E73656C6563746F723F746869732E73656C6563746F722B2220222B613A612C637D2C66696C7465723A66756E6374696F6E2861297B7265';
wwv_flow_api.g_varchar2_table(238) := '7475726E20746869732E70757368537461636B287828746869732C617C7C5B5D2C213129297D2C6E6F743A66756E6374696F6E2861297B72657475726E20746869732E70757368537461636B287828746869732C617C7C5B5D2C213029297D2C69733A66';
wwv_flow_api.g_varchar2_table(239) := '756E6374696F6E2861297B72657475726E21217828746869732C22737472696E67223D3D747970656F6620612626752E746573742861293F6E2861293A617C7C5B5D2C2131292E6C656E6774687D7D293B76617220792C7A3D612E646F63756D656E742C';
wwv_flow_api.g_varchar2_table(240) := '413D2F5E283F3A5C732A283C5B5C775C575D2B3E295B5E3E5D2A7C23285B5C772D5D2A2929242F2C423D6E2E666E2E696E69743D66756E6374696F6E28612C62297B76617220632C643B69662821612972657475726E20746869733B6966282273747269';
wwv_flow_api.g_varchar2_table(241) := '6E67223D3D747970656F662061297B696628633D223C223D3D3D612E6368617241742830292626223E223D3D3D612E63686172417428612E6C656E6774682D31292626612E6C656E6774683E3D333F5B6E756C6C2C612C6E756C6C5D3A412E6578656328';
wwv_flow_api.g_varchar2_table(242) := '61292C21637C7C21635B315D2626622972657475726E21627C7C622E6A71756572793F28627C7C79292E66696E642861293A746869732E636F6E7374727563746F722862292E66696E642861293B696628635B315D297B696628623D6220696E7374616E';
wwv_flow_api.g_varchar2_table(243) := '63656F66206E3F625B305D3A622C6E2E6D6572676528746869732C6E2E706172736548544D4C28635B315D2C622626622E6E6F6465547970653F622E6F776E6572446F63756D656E747C7C623A7A2C213029292C762E7465737428635B315D2926266E2E';
wwv_flow_api.g_varchar2_table(244) := '6973506C61696E4F626A65637428622929666F72286320696E2062296E2E697346756E6374696F6E28746869735B635D293F746869735B635D28625B635D293A746869732E6174747228632C625B635D293B72657475726E20746869737D696628643D7A';
wwv_flow_api.g_varchar2_table(245) := '2E676574456C656D656E744279496428635B325D292C642626642E706172656E744E6F6465297B696628642E6964213D3D635B325D2972657475726E20792E66696E642861293B746869732E6C656E6774683D312C746869735B305D3D647D7265747572';
wwv_flow_api.g_varchar2_table(246) := '6E20746869732E636F6E746578743D7A2C746869732E73656C6563746F723D612C746869737D72657475726E20612E6E6F6465547970653F28746869732E636F6E746578743D746869735B305D3D612C746869732E6C656E6774683D312C74686973293A';
wwv_flow_api.g_varchar2_table(247) := '6E2E697346756E6374696F6E2861293F22756E646566696E656422213D747970656F6620792E72656164793F792E72656164792861293A61286E293A28766F69642030213D3D612E73656C6563746F72262628746869732E73656C6563746F723D612E73';
wwv_flow_api.g_varchar2_table(248) := '656C6563746F722C746869732E636F6E746578743D612E636F6E74657874292C6E2E6D616B65417272617928612C7468697329297D3B422E70726F746F747970653D6E2E666E2C793D6E287A293B76617220433D2F5E283F3A706172656E74737C707265';
wwv_flow_api.g_varchar2_table(249) := '76283F3A556E74696C7C416C6C29292F2C443D7B6368696C6472656E3A21302C636F6E74656E74733A21302C6E6578743A21302C707265763A21307D3B6E2E657874656E64287B6469723A66756E6374696F6E28612C622C63297B76617220643D5B5D2C';
wwv_flow_api.g_varchar2_table(250) := '653D615B625D3B7768696C652865262639213D3D652E6E6F646554797065262628766F696420303D3D3D637C7C31213D3D652E6E6F6465547970657C7C216E2865292E69732863292929313D3D3D652E6E6F6465547970652626642E707573682865292C';
wwv_flow_api.g_varchar2_table(251) := '653D655B625D3B72657475726E20647D2C7369626C696E673A66756E6374696F6E28612C62297B666F722876617220633D5B5D3B613B613D612E6E6578745369626C696E6729313D3D3D612E6E6F646554797065262661213D3D622626632E7075736828';
wwv_flow_api.g_varchar2_table(252) := '61293B72657475726E20637D7D292C6E2E666E2E657874656E64287B6861733A66756E6374696F6E2861297B76617220622C633D6E28612C74686973292C643D632E6C656E6774683B72657475726E20746869732E66696C7465722866756E6374696F6E';
wwv_flow_api.g_varchar2_table(253) := '28297B666F7228623D303B643E623B622B2B296966286E2E636F6E7461696E7328746869732C635B625D292972657475726E21307D297D2C636C6F736573743A66756E6374696F6E28612C62297B666F722876617220632C643D302C653D746869732E6C';
wwv_flow_api.g_varchar2_table(254) := '656E6774682C663D5B5D2C673D752E746573742861297C7C22737472696E6722213D747970656F6620613F6E28612C627C7C746869732E636F6E74657874293A303B653E643B642B2B29666F7228633D746869735B645D3B63262663213D3D623B633D63';
wwv_flow_api.g_varchar2_table(255) := '2E706172656E744E6F646529696628632E6E6F6465547970653C3131262628673F672E696E6465782863293E2D313A313D3D3D632E6E6F64655479706526266E2E66696E642E6D61746368657353656C6563746F7228632C612929297B662E7075736828';
wwv_flow_api.g_varchar2_table(256) := '63293B627265616B7D72657475726E20746869732E70757368537461636B28662E6C656E6774683E313F6E2E756E697175652866293A66297D2C696E6465783A66756E6374696F6E2861297B72657475726E20613F22737472696E67223D3D747970656F';
wwv_flow_api.g_varchar2_table(257) := '6620613F6E2E696E417272617928746869735B305D2C6E286129293A6E2E696E417272617928612E6A71756572793F615B305D3A612C74686973293A746869735B305D2626746869735B305D2E706172656E744E6F64653F746869732E66697273742829';
wwv_flow_api.g_varchar2_table(258) := '2E70726576416C6C28292E6C656E6774683A2D317D2C6164643A66756E6374696F6E28612C62297B72657475726E20746869732E70757368537461636B286E2E756E69717565286E2E6D6572676528746869732E67657428292C6E28612C62292929297D';
wwv_flow_api.g_varchar2_table(259) := '2C6164644261636B3A66756E6374696F6E2861297B72657475726E20746869732E616464286E756C6C3D3D613F746869732E707265764F626A6563743A746869732E707265764F626A6563742E66696C746572286129297D7D293B66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(260) := '4528612C62297B646F20613D615B625D3B7768696C652861262631213D3D612E6E6F646554797065293B72657475726E20617D6E2E65616368287B706172656E743A66756E6374696F6E2861297B76617220623D612E706172656E744E6F64653B726574';
wwv_flow_api.g_varchar2_table(261) := '75726E206226263131213D3D622E6E6F6465547970653F623A6E756C6C7D2C706172656E74733A66756E6374696F6E2861297B72657475726E206E2E64697228612C22706172656E744E6F646522297D2C706172656E7473556E74696C3A66756E637469';
wwv_flow_api.g_varchar2_table(262) := '6F6E28612C622C63297B72657475726E206E2E64697228612C22706172656E744E6F6465222C63297D2C6E6578743A66756E6374696F6E2861297B72657475726E204528612C226E6578745369626C696E6722297D2C707265763A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(263) := '61297B72657475726E204528612C2270726576696F75735369626C696E6722297D2C6E657874416C6C3A66756E6374696F6E2861297B72657475726E206E2E64697228612C226E6578745369626C696E6722297D2C70726576416C6C3A66756E6374696F';
wwv_flow_api.g_varchar2_table(264) := '6E2861297B72657475726E206E2E64697228612C2270726576696F75735369626C696E6722297D2C6E657874556E74696C3A66756E6374696F6E28612C622C63297B72657475726E206E2E64697228612C226E6578745369626C696E67222C63297D2C70';
wwv_flow_api.g_varchar2_table(265) := '726576556E74696C3A66756E6374696F6E28612C622C63297B72657475726E206E2E64697228612C2270726576696F75735369626C696E67222C63297D2C7369626C696E67733A66756E6374696F6E2861297B72657475726E206E2E7369626C696E6728';
wwv_flow_api.g_varchar2_table(266) := '28612E706172656E744E6F64657C7C7B7D292E66697273744368696C642C61297D2C6368696C6472656E3A66756E6374696F6E2861297B72657475726E206E2E7369626C696E6728612E66697273744368696C64297D2C636F6E74656E74733A66756E63';
wwv_flow_api.g_varchar2_table(267) := '74696F6E2861297B72657475726E206E2E6E6F64654E616D6528612C22696672616D6522293F612E636F6E74656E74446F63756D656E747C7C612E636F6E74656E7457696E646F772E646F63756D656E743A6E2E6D65726765285B5D2C612E6368696C64';
wwv_flow_api.g_varchar2_table(268) := '4E6F646573297D7D2C66756E6374696F6E28612C62297B6E2E666E5B615D3D66756E6374696F6E28632C64297B76617220653D6E2E6D617028746869732C622C63293B72657475726E22556E74696C22213D3D612E736C696365282D3529262628643D63';
wwv_flow_api.g_varchar2_table(269) := '292C64262622737472696E67223D3D747970656F662064262628653D6E2E66696C74657228642C6529292C746869732E6C656E6774683E31262628445B615D7C7C28653D6E2E756E69717565286529292C432E74657374286129262628653D652E726576';
wwv_flow_api.g_varchar2_table(270) := '65727365282929292C746869732E70757368537461636B2865297D7D293B76617220463D2F5C532B2F672C473D7B7D3B66756E6374696F6E20482861297B76617220623D475B615D3D7B7D3B72657475726E206E2E6561636828612E6D61746368284629';
wwv_flow_api.g_varchar2_table(271) := '7C7C5B5D2C66756E6374696F6E28612C63297B625B635D3D21307D292C627D6E2E43616C6C6261636B733D66756E6374696F6E2861297B613D22737472696E67223D3D747970656F6620613F475B615D7C7C482861293A6E2E657874656E64287B7D2C61';
wwv_flow_api.g_varchar2_table(272) := '293B76617220622C632C642C652C662C672C683D5B5D2C693D21612E6F6E636526265B5D2C6A3D66756E6374696F6E286C297B666F7228633D612E6D656D6F727926266C2C643D21302C663D677C7C302C673D302C653D682E6C656E6774682C623D2130';
wwv_flow_api.g_varchar2_table(273) := '3B682626653E663B662B2B29696628685B665D2E6170706C79286C5B305D2C6C5B315D293D3D3D21312626612E73746F704F6E46616C7365297B633D21313B627265616B7D623D21312C68262628693F692E6C656E67746826266A28692E736869667428';
wwv_flow_api.g_varchar2_table(274) := '29293A633F683D5B5D3A6B2E64697361626C652829297D2C6B3D7B6164643A66756E6374696F6E28297B69662868297B76617220643D682E6C656E6774683B2166756E6374696F6E20662862297B6E2E6561636828622C66756E6374696F6E28622C6329';
wwv_flow_api.g_varchar2_table(275) := '7B76617220643D6E2E747970652863293B2266756E6374696F6E223D3D3D643F612E756E6971756526266B2E6861732863297C7C682E707573682863293A632626632E6C656E677468262622737472696E6722213D3D642626662863297D297D28617267';
wwv_flow_api.g_varchar2_table(276) := '756D656E7473292C623F653D682E6C656E6774683A63262628673D642C6A286329297D72657475726E20746869737D2C72656D6F76653A66756E6374696F6E28297B72657475726E206826266E2E6561636828617267756D656E74732C66756E6374696F';
wwv_flow_api.g_varchar2_table(277) := '6E28612C63297B76617220643B7768696C652828643D6E2E696E417272617928632C682C6429293E2D3129682E73706C69636528642C31292C62262628653E3D642626652D2D2C663E3D642626662D2D297D292C746869737D2C6861733A66756E637469';
wwv_flow_api.g_varchar2_table(278) := '6F6E2861297B72657475726E20613F6E2E696E417272617928612C68293E2D313A212821687C7C21682E6C656E677468297D2C656D7074793A66756E6374696F6E28297B72657475726E20683D5B5D2C653D302C746869737D2C64697361626C653A6675';
wwv_flow_api.g_varchar2_table(279) := '6E6374696F6E28297B72657475726E20683D693D633D766F696420302C746869737D2C64697361626C65643A66756E6374696F6E28297B72657475726E21687D2C6C6F636B3A66756E6374696F6E28297B72657475726E20693D766F696420302C637C7C';
wwv_flow_api.g_varchar2_table(280) := '6B2E64697361626C6528292C746869737D2C6C6F636B65643A66756E6374696F6E28297B72657475726E21697D2C66697265576974683A66756E6374696F6E28612C63297B72657475726E21687C7C64262621697C7C28633D637C7C5B5D2C633D5B612C';
wwv_flow_api.g_varchar2_table(281) := '632E736C6963653F632E736C69636528293A635D2C623F692E707573682863293A6A286329292C746869737D2C666972653A66756E6374696F6E28297B72657475726E206B2E666972655769746828746869732C617267756D656E7473292C746869737D';
wwv_flow_api.g_varchar2_table(282) := '2C66697265643A66756E6374696F6E28297B72657475726E2121647D7D3B72657475726E206B7D2C6E2E657874656E64287B44656665727265643A66756E6374696F6E2861297B76617220623D5B5B227265736F6C7665222C22646F6E65222C6E2E4361';
wwv_flow_api.g_varchar2_table(283) := '6C6C6261636B7328226F6E6365206D656D6F727922292C227265736F6C766564225D2C5B2272656A656374222C226661696C222C6E2E43616C6C6261636B7328226F6E6365206D656D6F727922292C2272656A6563746564225D2C5B226E6F7469667922';
wwv_flow_api.g_varchar2_table(284) := '2C2270726F6772657373222C6E2E43616C6C6261636B7328226D656D6F727922295D5D2C633D2270656E64696E67222C643D7B73746174653A66756E6374696F6E28297B72657475726E20637D2C616C776179733A66756E6374696F6E28297B72657475';
wwv_flow_api.g_varchar2_table(285) := '726E20652E646F6E6528617267756D656E7473292E6661696C28617267756D656E7473292C746869737D2C7468656E3A66756E6374696F6E28297B76617220613D617267756D656E74733B72657475726E206E2E44656665727265642866756E6374696F';
wwv_flow_api.g_varchar2_table(286) := '6E2863297B6E2E6561636828622C66756E6374696F6E28622C66297B76617220673D6E2E697346756E6374696F6E28615B625D292626615B625D3B655B665B315D5D2866756E6374696F6E28297B76617220613D672626672E6170706C7928746869732C';
wwv_flow_api.g_varchar2_table(287) := '617267756D656E7473293B6126266E2E697346756E6374696F6E28612E70726F6D697365293F612E70726F6D69736528292E646F6E6528632E7265736F6C7665292E6661696C28632E72656A656374292E70726F677265737328632E6E6F74696679293A';
wwv_flow_api.g_varchar2_table(288) := '635B665B305D2B2257697468225D28746869733D3D3D643F632E70726F6D69736528293A746869732C673F5B615D3A617267756D656E7473297D297D292C613D6E756C6C7D292E70726F6D69736528297D2C70726F6D6973653A66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(289) := '297B72657475726E206E756C6C213D613F6E2E657874656E6428612C64293A647D7D2C653D7B7D3B72657475726E20642E706970653D642E7468656E2C6E2E6561636828622C66756E6374696F6E28612C66297B76617220673D665B325D2C683D665B33';
wwv_flow_api.g_varchar2_table(290) := '5D3B645B665B315D5D3D672E6164642C682626672E6164642866756E6374696F6E28297B633D687D2C625B315E615D5B325D2E64697361626C652C625B325D5B325D2E6C6F636B292C655B665B305D5D3D66756E6374696F6E28297B72657475726E2065';
wwv_flow_api.g_varchar2_table(291) := '5B665B305D2B2257697468225D28746869733D3D3D653F643A746869732C617267756D656E7473292C746869737D2C655B665B305D2B2257697468225D3D672E66697265576974687D292C642E70726F6D6973652865292C612626612E63616C6C28652C';
wwv_flow_api.g_varchar2_table(292) := '65292C657D2C7768656E3A66756E6374696F6E2861297B76617220623D302C633D642E63616C6C28617267756D656E7473292C653D632E6C656E6774682C663D31213D3D657C7C6126266E2E697346756E6374696F6E28612E70726F6D697365293F653A';
wwv_flow_api.g_varchar2_table(293) := '302C673D313D3D3D663F613A6E2E446566657272656428292C683D66756E6374696F6E28612C622C63297B72657475726E2066756E6374696F6E2865297B625B615D3D746869732C635B615D3D617267756D656E74732E6C656E6774683E313F642E6361';
wwv_flow_api.g_varchar2_table(294) := '6C6C28617267756D656E7473293A652C633D3D3D693F672E6E6F746966795769746828622C63293A2D2D667C7C672E7265736F6C76655769746828622C63297D7D2C692C6A2C6B3B696628653E3129666F7228693D6E65772041727261792865292C6A3D';
wwv_flow_api.g_varchar2_table(295) := '6E65772041727261792865292C6B3D6E65772041727261792865293B653E623B622B2B29635B625D26266E2E697346756E6374696F6E28635B625D2E70726F6D697365293F635B625D2E70726F6D69736528292E646F6E65286828622C6B2C6329292E66';
wwv_flow_api.g_varchar2_table(296) := '61696C28672E72656A656374292E70726F6772657373286828622C6A2C6929293A2D2D663B72657475726E20667C7C672E7265736F6C766557697468286B2C63292C672E70726F6D69736528297D7D293B76617220493B6E2E666E2E72656164793D6675';
wwv_flow_api.g_varchar2_table(297) := '6E6374696F6E2861297B72657475726E206E2E72656164792E70726F6D69736528292E646F6E652861292C746869737D2C6E2E657874656E64287B697352656164793A21312C7265616479576169743A312C686F6C6452656164793A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(298) := '2861297B613F6E2E7265616479576169742B2B3A6E2E7265616479282130297D2C72656164793A66756E6374696F6E2861297B696628613D3D3D21303F212D2D6E2E7265616479576169743A216E2E69735265616479297B696628217A2E626F64792972';
wwv_flow_api.g_varchar2_table(299) := '657475726E2073657454696D656F7574286E2E7265616479293B6E2E697352656164793D21302C61213D3D213026262D2D6E2E7265616479576169743E307C7C28492E7265736F6C766557697468287A2C5B6E5D292C6E2E666E2E747269676765722626';
wwv_flow_api.g_varchar2_table(300) := '6E287A292E747269676765722822726561647922292E6F6666282272656164792229297D7D7D293B66756E6374696F6E204A28297B7A2E6164644576656E744C697374656E65723F287A2E72656D6F76654576656E744C697374656E65722822444F4D43';
wwv_flow_api.g_varchar2_table(301) := '6F6E74656E744C6F61646564222C4B2C2131292C612E72656D6F76654576656E744C697374656E657228226C6F6164222C4B2C213129293A287A2E6465746163684576656E7428226F6E726561647973746174656368616E6765222C4B292C612E646574';
wwv_flow_api.g_varchar2_table(302) := '6163684576656E7428226F6E6C6F6164222C4B29297D66756E6374696F6E204B28297B287A2E6164644576656E744C697374656E65727C7C226C6F6164223D3D3D6576656E742E747970657C7C22636F6D706C657465223D3D3D7A2E7265616479537461';
wwv_flow_api.g_varchar2_table(303) := '7465292626284A28292C6E2E72656164792829297D6E2E72656164792E70726F6D6973653D66756E6374696F6E2862297B696628214929696628493D6E2E446566657272656428292C22636F6D706C657465223D3D3D7A2E726561647953746174652973';
wwv_flow_api.g_varchar2_table(304) := '657454696D656F7574286E2E7265616479293B656C7365206966287A2E6164644576656E744C697374656E6572297A2E6164644576656E744C697374656E65722822444F4D436F6E74656E744C6F61646564222C4B2C2131292C612E6164644576656E74';
wwv_flow_api.g_varchar2_table(305) := '4C697374656E657228226C6F6164222C4B2C2131293B656C73657B7A2E6174746163684576656E7428226F6E726561647973746174656368616E6765222C4B292C612E6174746163684576656E7428226F6E6C6F6164222C4B293B76617220633D21313B';
wwv_flow_api.g_varchar2_table(306) := '7472797B633D6E756C6C3D3D612E6672616D65456C656D656E7426267A2E646F63756D656E74456C656D656E747D63617463682864297B7D632626632E646F5363726F6C6C26262166756E6374696F6E206528297B696628216E2E69735265616479297B';
wwv_flow_api.g_varchar2_table(307) := '7472797B632E646F5363726F6C6C28226C65667422297D63617463682861297B72657475726E2073657454696D656F757428652C3530297D4A28292C6E2E726561647928297D7D28297D72657475726E20492E70726F6D6973652862297D3B766172204C';
wwv_flow_api.g_varchar2_table(308) := '3D22756E646566696E6564222C4D3B666F72284D20696E206E286C2929627265616B3B6C2E6F776E4C6173743D223022213D3D4D2C6C2E696E6C696E65426C6F636B4E656564734C61796F75743D21312C6E2866756E6374696F6E28297B76617220612C';
wwv_flow_api.g_varchar2_table(309) := '622C633D7A2E676574456C656D656E747342795461674E616D652822626F647922295B305D3B63262628613D7A2E637265617465456C656D656E74282264697622292C612E7374796C652E637373546578743D22626F726465723A303B77696474683A30';
wwv_flow_api.g_varchar2_table(310) := '3B6865696768743A303B706F736974696F6E3A6162736F6C7574653B746F703A303B6C6566743A2D3939393970783B6D617267696E2D746F703A317078222C623D7A2E637265617465456C656D656E74282264697622292C632E617070656E644368696C';
wwv_flow_api.g_varchar2_table(311) := '642861292E617070656E644368696C642862292C747970656F6620622E7374796C652E7A6F6F6D213D3D4C262628622E7374796C652E637373546578743D22626F726465723A303B6D617267696E3A303B77696474683A3170783B70616464696E673A31';
wwv_flow_api.g_varchar2_table(312) := '70783B646973706C61793A696E6C696E653B7A6F6F6D3A31222C286C2E696E6C696E65426C6F636B4E656564734C61796F75743D333D3D3D622E6F6666736574576964746829262628632E7374796C652E7A6F6F6D3D3129292C632E72656D6F76654368';
wwv_flow_api.g_varchar2_table(313) := '696C642861292C613D623D6E756C6C297D292C66756E6374696F6E28297B76617220613D7A2E637265617465456C656D656E74282264697622293B6966286E756C6C3D3D6C2E64656C657465457870616E646F297B6C2E64656C657465457870616E646F';
wwv_flow_api.g_varchar2_table(314) := '3D21303B7472797B64656C65746520612E746573747D63617463682862297B6C2E64656C657465457870616E646F3D21317D7D613D6E756C6C7D28292C6E2E616363657074446174613D66756E6374696F6E2861297B76617220623D6E2E6E6F44617461';
wwv_flow_api.g_varchar2_table(315) := '5B28612E6E6F64654E616D652B222022292E746F4C6F7765724361736528295D2C633D2B612E6E6F6465547970657C7C313B72657475726E2031213D3D63262639213D3D633F21313A21627C7C62213D3D21302626612E67657441747472696275746528';
wwv_flow_api.g_varchar2_table(316) := '22636C617373696422293D3D3D627D3B766172204E3D2F5E283F3A5C7B5B5C775C575D2A5C7D7C5C5B5B5C775C575D2A5C5D29242F2C4F3D2F285B412D5A5D292F673B66756E6374696F6E205028612C622C63297B696628766F696420303D3D3D632626';
wwv_flow_api.g_varchar2_table(317) := '313D3D3D612E6E6F646554797065297B76617220643D22646174612D222B622E7265706C616365284F2C222D243122292E746F4C6F7765724361736528293B696628633D612E6765744174747269627574652864292C22737472696E67223D3D74797065';
wwv_flow_api.g_varchar2_table(318) := '6F662063297B7472797B633D2274727565223D3D3D633F21303A2266616C7365223D3D3D633F21313A226E756C6C223D3D3D633F6E756C6C3A2B632B22223D3D3D633F2B633A4E2E746573742863293F6E2E70617273654A534F4E2863293A637D636174';
wwv_flow_api.g_varchar2_table(319) := '63682865297B7D6E2E6461746128612C622C63297D656C736520633D766F696420307D72657475726E20637D66756E6374696F6E20512861297B76617220623B666F72286220696E20612969662828226461746122213D3D627C7C216E2E6973456D7074';
wwv_flow_api.g_varchar2_table(320) := '794F626A65637428615B625D2929262622746F4A534F4E22213D3D622972657475726E21313B72657475726E21307D66756E6374696F6E205228612C622C642C65297B6966286E2E61636365707444617461286129297B76617220662C672C683D6E2E65';
wwv_flow_api.g_varchar2_table(321) := '7870616E646F2C693D612E6E6F6465547970652C6A3D693F6E2E63616368653A612C6B3D693F615B685D3A615B685D2626683B6966286B26266A5B6B5D262628657C7C6A5B6B5D2E64617461297C7C766F69642030213D3D647C7C22737472696E672221';
wwv_flow_api.g_varchar2_table(322) := '3D747970656F6620622972657475726E206B7C7C286B3D693F615B685D3D632E706F7028297C7C6E2E677569642B2B3A68292C6A5B6B5D7C7C286A5B6B5D3D693F7B7D3A7B746F4A534F4E3A6E2E6E6F6F707D292C28226F626A656374223D3D74797065';
wwv_flow_api.g_varchar2_table(323) := '6F6620627C7C2266756E6374696F6E223D3D747970656F66206229262628653F6A5B6B5D3D6E2E657874656E64286A5B6B5D2C62293A6A5B6B5D2E646174613D6E2E657874656E64286A5B6B5D2E646174612C6229292C673D6A5B6B5D2C657C7C28672E';
wwv_flow_api.g_varchar2_table(324) := '646174617C7C28672E646174613D7B7D292C673D672E64617461292C766F69642030213D3D64262628675B6E2E63616D656C436173652862295D3D64292C22737472696E67223D3D747970656F6620623F28663D675B625D2C6E756C6C3D3D6626262866';
wwv_flow_api.g_varchar2_table(325) := '3D675B6E2E63616D656C436173652862295D29293A663D672C660D0A7D7D66756E6374696F6E205328612C622C63297B6966286E2E61636365707444617461286129297B76617220642C652C663D612E6E6F6465547970652C673D663F6E2E6361636865';
wwv_flow_api.g_varchar2_table(326) := '3A612C683D663F615B6E2E657870616E646F5D3A6E2E657870616E646F3B696628675B685D297B69662862262628643D633F675B685D3A675B685D2E6461746129297B6E2E697341727261792862293F623D622E636F6E636174286E2E6D617028622C6E';
wwv_flow_api.g_varchar2_table(327) := '2E63616D656C4361736529293A6220696E20643F623D5B625D3A28623D6E2E63616D656C436173652862292C623D6220696E20643F5B625D3A622E73706C69742822202229292C653D622E6C656E6774683B7768696C6528652D2D2964656C6574652064';
wwv_flow_api.g_varchar2_table(328) := '5B625B655D5D3B696628633F21512864293A216E2E6973456D7074794F626A6563742864292972657475726E7D28637C7C2864656C65746520675B685D2E646174612C5128675B685D292929262628663F6E2E636C65616E44617461285B615D2C213029';
wwv_flow_api.g_varchar2_table(329) := '3A6C2E64656C657465457870616E646F7C7C67213D672E77696E646F773F64656C65746520675B685D3A675B685D3D6E756C6C297D7D7D6E2E657874656E64287B63616368653A7B7D2C6E6F446174613A7B226170706C657420223A21302C22656D6265';
wwv_flow_api.g_varchar2_table(330) := '6420223A21302C226F626A65637420223A22636C7369643A44323743444236452D414536442D313163662D393642382D343434353533353430303030227D2C686173446174613A66756E6374696F6E2861297B72657475726E20613D612E6E6F64655479';
wwv_flow_api.g_varchar2_table(331) := '70653F6E2E63616368655B615B6E2E657870616E646F5D5D3A615B6E2E657870616E646F5D2C212161262621512861297D2C646174613A66756E6374696F6E28612C622C63297B72657475726E205228612C622C63297D2C72656D6F7665446174613A66';
wwv_flow_api.g_varchar2_table(332) := '756E6374696F6E28612C62297B72657475726E205328612C62297D2C5F646174613A66756E6374696F6E28612C622C63297B72657475726E205228612C622C632C2130297D2C5F72656D6F7665446174613A66756E6374696F6E28612C62297B72657475';
wwv_flow_api.g_varchar2_table(333) := '726E205328612C622C2130297D7D292C6E2E666E2E657874656E64287B646174613A66756E6374696F6E28612C62297B76617220632C642C652C663D746869735B305D2C673D662626662E617474726962757465733B696628766F696420303D3D3D6129';
wwv_flow_api.g_varchar2_table(334) := '7B696628746869732E6C656E677468262628653D6E2E646174612866292C313D3D3D662E6E6F6465547970652626216E2E5F6461746128662C227061727365644174747273222929297B633D672E6C656E6774683B7768696C6528632D2D29643D675B63';
wwv_flow_api.g_varchar2_table(335) := '5D2E6E616D652C303D3D3D642E696E6465784F662822646174612D2229262628643D6E2E63616D656C4361736528642E736C696365283529292C5028662C642C655B645D29293B6E2E5F6461746128662C227061727365644174747273222C2130297D72';
wwv_flow_api.g_varchar2_table(336) := '657475726E20657D72657475726E226F626A656374223D3D747970656F6620613F746869732E656163682866756E6374696F6E28297B6E2E6461746128746869732C61297D293A617267756D656E74732E6C656E6774683E313F746869732E6561636828';
wwv_flow_api.g_varchar2_table(337) := '66756E6374696F6E28297B6E2E6461746128746869732C612C62297D293A663F5028662C612C6E2E6461746128662C6129293A766F696420307D2C72656D6F7665446174613A66756E6374696F6E2861297B72657475726E20746869732E656163682866';
wwv_flow_api.g_varchar2_table(338) := '756E6374696F6E28297B6E2E72656D6F76654461746128746869732C61297D297D7D292C6E2E657874656E64287B71756575653A66756E6374696F6E28612C622C63297B76617220643B72657475726E20613F28623D28627C7C22667822292B22717565';
wwv_flow_api.g_varchar2_table(339) := '7565222C643D6E2E5F6461746128612C62292C6326262821647C7C6E2E697341727261792863293F643D6E2E5F6461746128612C622C6E2E6D616B654172726179286329293A642E70757368286329292C647C7C5B5D293A766F696420307D2C64657175';
wwv_flow_api.g_varchar2_table(340) := '6575653A66756E6374696F6E28612C62297B623D627C7C226678223B76617220633D6E2E717565756528612C62292C643D632E6C656E6774682C653D632E736869667428292C663D6E2E5F7175657565486F6F6B7328612C62292C673D66756E6374696F';
wwv_flow_api.g_varchar2_table(341) := '6E28297B6E2E6465717565756528612C62297D3B22696E70726F6772657373223D3D3D65262628653D632E736869667428292C642D2D292C65262628226678223D3D3D622626632E756E73686966742822696E70726F677265737322292C64656C657465';
wwv_flow_api.g_varchar2_table(342) := '20662E73746F702C652E63616C6C28612C672C6629292C21642626662626662E656D7074792E6669726528297D2C5F7175657565486F6F6B733A66756E6374696F6E28612C62297B76617220633D622B227175657565486F6F6B73223B72657475726E20';
wwv_flow_api.g_varchar2_table(343) := '6E2E5F6461746128612C63297C7C6E2E5F6461746128612C632C7B656D7074793A6E2E43616C6C6261636B7328226F6E6365206D656D6F727922292E6164642866756E6374696F6E28297B6E2E5F72656D6F76654461746128612C622B22717565756522';
wwv_flow_api.g_varchar2_table(344) := '292C6E2E5F72656D6F76654461746128612C63297D297D297D7D292C6E2E666E2E657874656E64287B71756575653A66756E6374696F6E28612C62297B76617220633D323B72657475726E22737472696E6722213D747970656F662061262628623D612C';
wwv_flow_api.g_varchar2_table(345) := '613D226678222C632D2D292C617267756D656E74732E6C656E6774683C633F6E2E717565756528746869735B305D2C61293A766F696420303D3D3D623F746869733A746869732E656163682866756E6374696F6E28297B76617220633D6E2E7175657565';
wwv_flow_api.g_varchar2_table(346) := '28746869732C612C62293B6E2E5F7175657565486F6F6B7328746869732C61292C226678223D3D3D61262622696E70726F677265737322213D3D635B305D26266E2E6465717565756528746869732C61297D297D2C646571756575653A66756E6374696F';
wwv_flow_api.g_varchar2_table(347) := '6E2861297B72657475726E20746869732E656163682866756E6374696F6E28297B6E2E6465717565756528746869732C61297D297D2C636C65617251756575653A66756E6374696F6E2861297B72657475726E20746869732E717565756528617C7C2266';
wwv_flow_api.g_varchar2_table(348) := '78222C5B5D297D2C70726F6D6973653A66756E6374696F6E28612C62297B76617220632C643D312C653D6E2E446566657272656428292C663D746869732C673D746869732E6C656E6774682C683D66756E6374696F6E28297B2D2D647C7C652E7265736F';
wwv_flow_api.g_varchar2_table(349) := '6C76655769746828662C5B665D297D3B22737472696E6722213D747970656F662061262628623D612C613D766F69642030292C613D617C7C226678223B7768696C6528672D2D29633D6E2E5F6461746128665B675D2C612B227175657565486F6F6B7322';
wwv_flow_api.g_varchar2_table(350) := '292C632626632E656D707479262628642B2B2C632E656D7074792E616464286829293B72657475726E206828292C652E70726F6D6973652862297D7D293B76617220543D2F5B2B2D5D3F283F3A5C642A5C2E7C295C642B283F3A5B65455D5B2B2D5D3F5C';
wwv_flow_api.g_varchar2_table(351) := '642B7C292F2E736F757263652C553D5B22546F70222C225269676874222C22426F74746F6D222C224C656674225D2C563D66756E6374696F6E28612C62297B72657475726E20613D627C7C612C226E6F6E65223D3D3D6E2E63737328612C22646973706C';
wwv_flow_api.g_varchar2_table(352) := '617922297C7C216E2E636F6E7461696E7328612E6F776E6572446F63756D656E742C61297D2C573D6E2E6163636573733D66756E6374696F6E28612C622C632C642C652C662C67297B76617220683D302C693D612E6C656E6774682C6A3D6E756C6C3D3D';
wwv_flow_api.g_varchar2_table(353) := '633B696628226F626A656374223D3D3D6E2E74797065286329297B653D21303B666F72286820696E2063296E2E61636365737328612C622C682C635B685D2C21302C662C67297D656C736520696628766F69642030213D3D64262628653D21302C6E2E69';
wwv_flow_api.g_varchar2_table(354) := '7346756E6374696F6E2864297C7C28673D2130292C6A262628673F28622E63616C6C28612C64292C623D6E756C6C293A286A3D622C623D66756E6374696F6E28612C622C63297B72657475726E206A2E63616C6C286E2861292C63297D29292C62292966';
wwv_flow_api.g_varchar2_table(355) := '6F72283B693E683B682B2B296228615B685D2C632C673F643A642E63616C6C28615B685D2C682C6228615B685D2C632929293B72657475726E20653F613A6A3F622E63616C6C2861293A693F6228615B305D2C63293A667D2C583D2F5E283F3A63686563';
wwv_flow_api.g_varchar2_table(356) := '6B626F787C726164696F29242F693B2166756E6374696F6E28297B76617220613D7A2E637265617465446F63756D656E74467261676D656E7428292C623D7A2E637265617465456C656D656E74282264697622292C633D7A2E637265617465456C656D65';
wwv_flow_api.g_varchar2_table(357) := '6E742822696E70757422293B696628622E7365744174747269627574652822636C6173734E616D65222C227422292C622E696E6E657248544D4C3D2220203C6C696E6B2F3E3C7461626C653E3C2F7461626C653E3C6120687265663D272F61273E613C2F';
wwv_flow_api.g_varchar2_table(358) := '613E222C6C2E6C656164696E67576869746573706163653D333D3D3D622E66697273744368696C642E6E6F6465547970652C6C2E74626F64793D21622E676574456C656D656E747342795461674E616D65282274626F647922292E6C656E6774682C6C2E';
wwv_flow_api.g_varchar2_table(359) := '68746D6C53657269616C697A653D2121622E676574456C656D656E747342795461674E616D6528226C696E6B22292E6C656E6774682C6C2E68746D6C35436C6F6E653D223C3A6E61763E3C2F3A6E61763E22213D3D7A2E637265617465456C656D656E74';
wwv_flow_api.g_varchar2_table(360) := '28226E617622292E636C6F6E654E6F6465282130292E6F7574657248544D4C2C632E747970653D22636865636B626F78222C632E636865636B65643D21302C612E617070656E644368696C642863292C6C2E617070656E64436865636B65643D632E6368';
wwv_flow_api.g_varchar2_table(361) := '65636B65642C622E696E6E657248544D4C3D223C74657874617265613E783C2F74657874617265613E222C6C2E6E6F436C6F6E65436865636B65643D2121622E636C6F6E654E6F6465282130292E6C6173744368696C642E64656661756C7456616C7565';
wwv_flow_api.g_varchar2_table(362) := '2C612E617070656E644368696C642862292C622E696E6E657248544D4C3D223C696E70757420747970653D27726164696F2720636865636B65643D27636865636B656427206E616D653D2774272F3E222C6C2E636865636B436C6F6E653D622E636C6F6E';
wwv_flow_api.g_varchar2_table(363) := '654E6F6465282130292E636C6F6E654E6F6465282130292E6C6173744368696C642E636865636B65642C6C2E6E6F436C6F6E654576656E743D21302C622E6174746163684576656E74262628622E6174746163684576656E7428226F6E636C69636B222C';
wwv_flow_api.g_varchar2_table(364) := '66756E6374696F6E28297B6C2E6E6F436C6F6E654576656E743D21317D292C622E636C6F6E654E6F6465282130292E636C69636B2829292C6E756C6C3D3D6C2E64656C657465457870616E646F297B6C2E64656C657465457870616E646F3D21303B7472';
wwv_flow_api.g_varchar2_table(365) := '797B64656C65746520622E746573747D63617463682864297B6C2E64656C657465457870616E646F3D21317D7D613D623D633D6E756C6C7D28292C66756E6374696F6E28297B76617220622C632C643D7A2E637265617465456C656D656E742822646976';
wwv_flow_api.g_varchar2_table(366) := '22293B666F72286220696E7B7375626D69743A21302C6368616E67653A21302C666F637573696E3A21307D29633D226F6E222B622C286C5B622B22427562626C6573225D3D6320696E2061297C7C28642E73657441747472696275746528632C22742229';
wwv_flow_api.g_varchar2_table(367) := '2C6C5B622B22427562626C6573225D3D642E617474726962757465735B635D2E657870616E646F3D3D3D2131293B643D6E756C6C7D28293B76617220593D2F5E283F3A696E7075747C73656C6563747C746578746172656129242F692C5A3D2F5E6B6579';
wwv_flow_api.g_varchar2_table(368) := '2F2C243D2F5E283F3A6D6F7573657C636F6E746578746D656E75297C636C69636B2F2C5F3D2F5E283F3A666F637573696E666F6375737C666F6375736F7574626C757229242F2C61623D2F5E285B5E2E5D2A29283F3A5C2E282E2B297C29242F3B66756E';
wwv_flow_api.g_varchar2_table(369) := '6374696F6E20626228297B72657475726E21307D66756E6374696F6E20636228297B72657475726E21317D66756E6374696F6E20646228297B7472797B72657475726E207A2E616374697665456C656D656E747D63617463682861297B7D7D6E2E657665';
wwv_flow_api.g_varchar2_table(370) := '6E743D7B676C6F62616C3A7B7D2C6164643A66756E6374696F6E28612C622C632C642C65297B76617220662C672C682C692C6A2C6B2C6C2C6D2C6F2C702C712C723D6E2E5F646174612861293B69662872297B632E68616E646C6572262628693D632C63';
wwv_flow_api.g_varchar2_table(371) := '3D692E68616E646C65722C653D692E73656C6563746F72292C632E677569647C7C28632E677569643D6E2E677569642B2B292C28673D722E6576656E7473297C7C28673D722E6576656E74733D7B7D292C286B3D722E68616E646C65297C7C286B3D722E';
wwv_flow_api.g_varchar2_table(372) := '68616E646C653D66756E6374696F6E2861297B72657475726E20747970656F66206E3D3D3D4C7C7C6126266E2E6576656E742E7472696767657265643D3D3D612E747970653F766F696420303A6E2E6576656E742E64697370617463682E6170706C7928';
wwv_flow_api.g_varchar2_table(373) := '6B2E656C656D2C617267756D656E7473297D2C6B2E656C656D3D61292C623D28627C7C2222292E6D617463682846297C7C5B22225D2C683D622E6C656E6774683B7768696C6528682D2D29663D61622E6578656328625B685D297C7C5B5D2C6F3D713D66';
wwv_flow_api.g_varchar2_table(374) := '5B315D2C703D28665B325D7C7C2222292E73706C697428222E22292E736F727428292C6F2626286A3D6E2E6576656E742E7370656369616C5B6F5D7C7C7B7D2C6F3D28653F6A2E64656C6567617465547970653A6A2E62696E6454797065297C7C6F2C6A';
wwv_flow_api.g_varchar2_table(375) := '3D6E2E6576656E742E7370656369616C5B6F5D7C7C7B7D2C6C3D6E2E657874656E64287B747970653A6F2C6F726967547970653A712C646174613A642C68616E646C65723A632C677569643A632E677569642C73656C6563746F723A652C6E6565647343';
wwv_flow_api.g_varchar2_table(376) := '6F6E746578743A6526266E2E657870722E6D617463682E6E65656473436F6E746578742E746573742865292C6E616D6573706163653A702E6A6F696E28222E22297D2C69292C286D3D675B6F5D297C7C286D3D675B6F5D3D5B5D2C6D2E64656C65676174';
wwv_flow_api.g_varchar2_table(377) := '65436F756E743D302C6A2E736574757026266A2E73657475702E63616C6C28612C642C702C6B29213D3D21317C7C28612E6164644576656E744C697374656E65723F612E6164644576656E744C697374656E6572286F2C6B2C2131293A612E6174746163';
wwv_flow_api.g_varchar2_table(378) := '684576656E742626612E6174746163684576656E7428226F6E222B6F2C6B2929292C6A2E6164642626286A2E6164642E63616C6C28612C6C292C6C2E68616E646C65722E677569647C7C286C2E68616E646C65722E677569643D632E6775696429292C65';
wwv_flow_api.g_varchar2_table(379) := '3F6D2E73706C696365286D2E64656C6567617465436F756E742B2B2C302C6C293A6D2E70757368286C292C6E2E6576656E742E676C6F62616C5B6F5D3D2130293B613D6E756C6C7D7D2C72656D6F76653A66756E6374696F6E28612C622C632C642C6529';
wwv_flow_api.g_varchar2_table(380) := '7B76617220662C672C682C692C6A2C6B2C6C2C6D2C6F2C702C712C723D6E2E6861734461746128612926266E2E5F646174612861293B696628722626286B3D722E6576656E747329297B623D28627C7C2222292E6D617463682846297C7C5B22225D2C6A';
wwv_flow_api.g_varchar2_table(381) := '3D622E6C656E6774683B7768696C65286A2D2D29696628683D61622E6578656328625B6A5D297C7C5B5D2C6F3D713D685B315D2C703D28685B325D7C7C2222292E73706C697428222E22292E736F727428292C6F297B6C3D6E2E6576656E742E73706563';
wwv_flow_api.g_varchar2_table(382) := '69616C5B6F5D7C7C7B7D2C6F3D28643F6C2E64656C6567617465547970653A6C2E62696E6454797065297C7C6F2C6D3D6B5B6F5D7C7C5B5D2C683D685B325D26266E6577205265674578702822285E7C5C5C2E29222B702E6A6F696E28225C5C2E283F3A';
wwv_flow_api.g_varchar2_table(383) := '2E2A5C5C2E7C2922292B22285C5C2E7C242922292C693D663D6D2E6C656E6774683B7768696C6528662D2D29673D6D5B665D2C2165262671213D3D672E6F726967547970657C7C632626632E67756964213D3D672E677569647C7C68262621682E746573';
wwv_flow_api.g_varchar2_table(384) := '7428672E6E616D657370616365297C7C64262664213D3D672E73656C6563746F72262628222A2A22213D3D647C7C21672E73656C6563746F72297C7C286D2E73706C69636528662C31292C672E73656C6563746F7226266D2E64656C6567617465436F75';
wwv_flow_api.g_varchar2_table(385) := '6E742D2D2C6C2E72656D6F766526266C2E72656D6F76652E63616C6C28612C6729293B692626216D2E6C656E6774682626286C2E74656172646F776E26266C2E74656172646F776E2E63616C6C28612C702C722E68616E646C6529213D3D21317C7C6E2E';
wwv_flow_api.g_varchar2_table(386) := '72656D6F76654576656E7428612C6F2C722E68616E646C65292C64656C657465206B5B6F5D297D656C736520666F72286F20696E206B296E2E6576656E742E72656D6F766528612C6F2B625B6A5D2C632C642C2130293B6E2E6973456D7074794F626A65';
wwv_flow_api.g_varchar2_table(387) := '6374286B2926262864656C65746520722E68616E646C652C6E2E5F72656D6F76654461746128612C226576656E74732229297D7D2C747269676765723A66756E6374696F6E28622C632C642C65297B76617220662C672C682C692C6B2C6C2C6D2C6F3D5B';
wwv_flow_api.g_varchar2_table(388) := '647C7C7A5D2C703D6A2E63616C6C28622C227479706522293F622E747970653A622C713D6A2E63616C6C28622C226E616D65737061636522293F622E6E616D6573706163652E73706C697428222E22293A5B5D3B696628683D6C3D643D647C7C7A2C3321';
wwv_flow_api.g_varchar2_table(389) := '3D3D642E6E6F646554797065262638213D3D642E6E6F6465547970652626215F2E7465737428702B6E2E6576656E742E74726967676572656429262628702E696E6465784F6628222E22293E3D30262628713D702E73706C697428222E22292C703D712E';
wwv_flow_api.g_varchar2_table(390) := '736869667428292C712E736F72742829292C673D702E696E6465784F6628223A22293C302626226F6E222B702C623D625B6E2E657870616E646F5D3F623A6E6577206E2E4576656E7428702C226F626A656374223D3D747970656F662062262662292C62';
wwv_flow_api.g_varchar2_table(391) := '2E6973547269676765723D653F323A332C622E6E616D6573706163653D712E6A6F696E28222E22292C622E6E616D6573706163655F72653D622E6E616D6573706163653F6E6577205265674578702822285E7C5C5C2E29222B712E6A6F696E28225C5C2E';
wwv_flow_api.g_varchar2_table(392) := '283F3A2E2A5C5C2E7C2922292B22285C5C2E7C242922293A6E756C6C2C622E726573756C743D766F696420302C622E7461726765747C7C28622E7461726765743D64292C633D6E756C6C3D3D633F5B625D3A6E2E6D616B65417272617928632C5B625D29';
wwv_flow_api.g_varchar2_table(393) := '2C6B3D6E2E6576656E742E7370656369616C5B705D7C7C7B7D2C657C7C216B2E747269676765727C7C6B2E747269676765722E6170706C7928642C6329213D3D213129297B69662821652626216B2E6E6F427562626C652626216E2E697357696E646F77';
wwv_flow_api.g_varchar2_table(394) := '286429297B666F7228693D6B2E64656C6567617465547970657C7C702C5F2E7465737428692B70297C7C28683D682E706172656E744E6F6465293B683B683D682E706172656E744E6F6465296F2E707573682868292C6C3D683B6C3D3D3D28642E6F776E';
wwv_flow_api.g_varchar2_table(395) := '6572446F63756D656E747C7C7A2926266F2E70757368286C2E64656661756C74566965777C7C6C2E706172656E7457696E646F777C7C61297D6D3D303B7768696C652828683D6F5B6D2B2B5D29262621622E697350726F7061676174696F6E53746F7070';
wwv_flow_api.g_varchar2_table(396) := '6564282929622E747970653D6D3E313F693A6B2E62696E64547970657C7C702C663D286E2E5F6461746128682C226576656E747322297C7C7B7D295B622E747970655D26266E2E5F6461746128682C2268616E646C6522292C662626662E6170706C7928';
wwv_flow_api.g_varchar2_table(397) := '682C63292C663D672626685B675D2C662626662E6170706C7926266E2E61636365707444617461286829262628622E726573756C743D662E6170706C7928682C63292C622E726573756C743D3D3D21312626622E70726576656E7444656661756C742829';
wwv_flow_api.g_varchar2_table(398) := '293B696628622E747970653D702C2165262621622E697344656661756C7450726576656E7465642829262628216B2E5F64656661756C747C7C6B2E5F64656661756C742E6170706C79286F2E706F7028292C63293D3D3D21312926266E2E616363657074';
wwv_flow_api.g_varchar2_table(399) := '446174612864292626672626645B705D2626216E2E697357696E646F77286429297B6C3D645B675D2C6C262628645B675D3D6E756C6C292C6E2E6576656E742E7472696767657265643D703B7472797B645B705D28297D63617463682872297B7D6E2E65';
wwv_flow_api.g_varchar2_table(400) := '76656E742E7472696767657265643D766F696420302C6C262628645B675D3D6C297D72657475726E20622E726573756C747D7D2C64697370617463683A66756E6374696F6E2861297B613D6E2E6576656E742E6669782861293B76617220622C632C652C';
wwv_flow_api.g_varchar2_table(401) := '662C672C683D5B5D2C693D642E63616C6C28617267756D656E7473292C6A3D286E2E5F6461746128746869732C226576656E747322297C7C7B7D295B612E747970655D7C7C5B5D2C6B3D6E2E6576656E742E7370656369616C5B612E747970655D7C7C7B';
wwv_flow_api.g_varchar2_table(402) := '7D3B696628695B305D3D612C612E64656C65676174655461726765743D746869732C216B2E70726544697370617463687C7C6B2E70726544697370617463682E63616C6C28746869732C6129213D3D2131297B683D6E2E6576656E742E68616E646C6572';
wwv_flow_api.g_varchar2_table(403) := '732E63616C6C28746869732C612C6A292C623D303B7768696C652828663D685B622B2B5D29262621612E697350726F7061676174696F6E53746F707065642829297B612E63757272656E745461726765743D662E656C656D2C673D303B7768696C652828';
wwv_flow_api.g_varchar2_table(404) := '653D662E68616E646C6572735B672B2B5D29262621612E6973496D6D65646961746550726F7061676174696F6E53746F707065642829292821612E6E616D6573706163655F72657C7C612E6E616D6573706163655F72652E7465737428652E6E616D6573';
wwv_flow_api.g_varchar2_table(405) := '706163652929262628612E68616E646C654F626A3D652C612E646174613D652E646174612C633D28286E2E6576656E742E7370656369616C5B652E6F726967547970655D7C7C7B7D292E68616E646C657C7C652E68616E646C6572292E6170706C792866';
wwv_flow_api.g_varchar2_table(406) := '2E656C656D2C69292C766F69642030213D3D63262628612E726573756C743D63293D3D3D2131262628612E70726576656E7444656661756C7428292C612E73746F7050726F7061676174696F6E282929297D72657475726E206B2E706F73744469737061';
wwv_flow_api.g_varchar2_table(407) := '74636826266B2E706F737444697370617463682E63616C6C28746869732C61292C612E726573756C747D7D2C68616E646C6572733A66756E6374696F6E28612C62297B76617220632C642C652C662C673D5B5D2C683D622E64656C6567617465436F756E';
wwv_flow_api.g_varchar2_table(408) := '742C693D612E7461726765743B696628682626692E6E6F64655479706526262821612E627574746F6E7C7C22636C69636B22213D3D612E747970652929666F72283B69213D746869733B693D692E706172656E744E6F64657C7C7468697329696628313D';
wwv_flow_api.g_varchar2_table(409) := '3D3D692E6E6F646554797065262628692E64697361626C6564213D3D21307C7C22636C69636B22213D3D612E7479706529297B666F7228653D5B5D2C663D303B683E663B662B2B29643D625B665D2C633D642E73656C6563746F722B2220222C766F6964';
wwv_flow_api.g_varchar2_table(410) := '20303D3D3D655B635D262628655B635D3D642E6E65656473436F6E746578743F6E28632C74686973292E696E6465782869293E3D303A6E2E66696E6428632C746869732C6E756C6C2C5B695D292E6C656E677468292C655B635D2626652E707573682864';
wwv_flow_api.g_varchar2_table(411) := '293B652E6C656E6774682626672E70757368287B656C656D3A692C68616E646C6572733A657D297D72657475726E20683C622E6C656E6774682626672E70757368287B656C656D3A746869732C68616E646C6572733A622E736C6963652868297D292C67';
wwv_flow_api.g_varchar2_table(412) := '7D2C6669783A66756E6374696F6E2861297B696628615B6E2E657870616E646F5D2972657475726E20613B76617220622C632C642C653D612E747970652C663D612C673D746869732E666978486F6F6B735B655D3B677C7C28746869732E666978486F6F';
wwv_flow_api.g_varchar2_table(413) := '6B735B655D3D673D242E746573742865293F746869732E6D6F757365486F6F6B733A5A2E746573742865293F746869732E6B6579486F6F6B733A7B7D292C643D672E70726F70733F746869732E70726F70732E636F6E63617428672E70726F7073293A74';
wwv_flow_api.g_varchar2_table(414) := '6869732E70726F70732C613D6E6577206E2E4576656E742866292C623D642E6C656E6774683B7768696C6528622D2D29633D645B625D2C615B635D3D665B635D3B72657475726E20612E7461726765747C7C28612E7461726765743D662E737263456C65';
wwv_flow_api.g_varchar2_table(415) := '6D656E747C7C7A292C333D3D3D612E7461726765742E6E6F646554797065262628612E7461726765743D612E7461726765742E706172656E744E6F6465292C612E6D6574614B65793D2121612E6D6574614B65792C672E66696C7465723F672E66696C74';
wwv_flow_api.g_varchar2_table(416) := '657228612C66293A617D2C70726F70733A22616C744B657920627562626C65732063616E63656C61626C65206374726C4B65792063757272656E74546172676574206576656E745068617365206D6574614B65792072656C617465645461726765742073';
wwv_flow_api.g_varchar2_table(417) := '686966744B6579207461726765742074696D655374616D702076696577207768696368222E73706C697428222022292C666978486F6F6B733A7B7D2C6B6579486F6F6B733A7B70726F70733A22636861722063686172436F6465206B6579206B6579436F';
wwv_flow_api.g_varchar2_table(418) := '6465222E73706C697428222022292C66696C7465723A66756E6374696F6E28612C62297B72657475726E206E756C6C3D3D612E7768696368262628612E77686963683D6E756C6C213D622E63686172436F64653F622E63686172436F64653A622E6B6579';
wwv_flow_api.g_varchar2_table(419) := '436F6465292C617D7D2C6D6F757365486F6F6B733A7B70726F70733A22627574746F6E20627574746F6E7320636C69656E745820636C69656E74592066726F6D456C656D656E74206F666673657458206F66667365745920706167655820706167655920';
wwv_flow_api.g_varchar2_table(420) := '73637265656E582073637265656E5920746F456C656D656E74222E73706C697428222022292C66696C7465723A66756E6374696F6E28612C62297B76617220632C642C652C663D622E627574746F6E2C673D622E66726F6D456C656D656E743B72657475';
wwv_flow_api.g_varchar2_table(421) := '726E206E756C6C3D3D612E706167655826266E756C6C213D622E636C69656E7458262628643D612E7461726765742E6F776E6572446F63756D656E747C7C7A2C653D642E646F63756D656E74456C656D656E742C633D642E626F64792C612E7061676558';
wwv_flow_api.g_varchar2_table(422) := '3D622E636C69656E74582B28652626652E7363726F6C6C4C6566747C7C632626632E7363726F6C6C4C6566747C7C30292D28652626652E636C69656E744C6566747C7C632626632E636C69656E744C6566747C7C30292C612E70616765593D622E636C69';
wwv_flow_api.g_varchar2_table(423) := '656E74592B28652626652E7363726F6C6C546F707C7C632626632E7363726F6C6C546F707C7C30292D28652626652E636C69656E74546F707C7C632626632E636C69656E74546F707C7C3029292C21612E72656C61746564546172676574262667262628';
wwv_flow_api.g_varchar2_table(424) := '612E72656C617465645461726765743D673D3D3D612E7461726765743F622E746F456C656D656E743A67292C612E77686963687C7C766F696420303D3D3D667C7C28612E77686963683D3126663F313A3226663F333A3426663F323A30292C617D7D2C73';
wwv_flow_api.g_varchar2_table(425) := '70656369616C3A7B6C6F61643A7B6E6F427562626C653A21307D2C666F6375733A7B747269676765723A66756E6374696F6E28297B69662874686973213D3D646228292626746869732E666F637573297472797B72657475726E20746869732E666F6375';
wwv_flow_api.g_varchar2_table(426) := '7328292C21317D63617463682861297B7D7D2C64656C6567617465547970653A22666F637573696E227D2C626C75723A7B747269676765723A66756E6374696F6E28297B72657475726E20746869733D3D3D646228292626746869732E626C75723F2874';
wwv_flow_api.g_varchar2_table(427) := '6869732E626C757228292C2131293A766F696420307D2C64656C6567617465547970653A22666F6375736F7574227D2C636C69636B3A7B747269676765723A66756E6374696F6E28297B72657475726E206E2E6E6F64654E616D6528746869732C22696E';
wwv_flow_api.g_varchar2_table(428) := '7075742229262622636865636B626F78223D3D3D746869732E747970652626746869732E636C69636B3F28746869732E636C69636B28292C2131293A766F696420307D2C5F64656661756C743A66756E6374696F6E2861297B72657475726E206E2E6E6F';
wwv_flow_api.g_varchar2_table(429) := '64654E616D6528612E7461726765742C226122297D7D2C6265666F7265756E6C6F61643A7B706F737444697370617463683A66756E6374696F6E2861297B766F69642030213D3D612E726573756C74262628612E6F726967696E616C4576656E742E7265';
wwv_flow_api.g_varchar2_table(430) := '7475726E56616C75653D612E726573756C74297D7D7D2C73696D756C6174653A66756E6374696F6E28612C622C632C64297B76617220653D6E2E657874656E64286E6577206E2E4576656E742C632C7B747970653A612C697353696D756C617465643A21';
wwv_flow_api.g_varchar2_table(431) := '302C6F726967696E616C4576656E743A7B7D7D293B643F6E2E6576656E742E7472696767657228652C6E756C6C2C62293A6E2E6576656E742E64697370617463682E63616C6C28622C65292C652E697344656661756C7450726576656E74656428292626';
wwv_flow_api.g_varchar2_table(432) := '632E70726576656E7444656661756C7428297D7D2C6E2E72656D6F76654576656E743D7A2E72656D6F76654576656E744C697374656E65723F66756E6374696F6E28612C622C63297B612E72656D6F76654576656E744C697374656E65722626612E7265';
wwv_flow_api.g_varchar2_table(433) := '6D6F76654576656E744C697374656E657228622C632C2131297D3A66756E6374696F6E28612C622C63297B76617220643D226F6E222B623B612E6465746163684576656E74262628747970656F6620615B645D3D3D3D4C262628615B645D3D6E756C6C29';
wwv_flow_api.g_varchar2_table(434) := '2C612E6465746163684576656E7428642C6329297D2C6E2E4576656E743D66756E6374696F6E28612C62297B72657475726E207468697320696E7374616E63656F66206E2E4576656E743F28612626612E747970653F28746869732E6F726967696E616C';
wwv_flow_api.g_varchar2_table(435) := '4576656E743D612C746869732E747970653D612E747970652C746869732E697344656661756C7450726576656E7465643D612E64656661756C7450726576656E7465647C7C766F696420303D3D3D612E64656661756C7450726576656E74656426262861';
wwv_flow_api.g_varchar2_table(436) := '2E72657475726E56616C75653D3D3D21317C7C612E67657450726576656E7444656661756C742626612E67657450726576656E7444656661756C742829293F62623A6362293A746869732E747970653D612C6226266E2E657874656E6428746869732C62';
wwv_flow_api.g_varchar2_table(437) := '292C746869732E74696D655374616D703D612626612E74696D655374616D707C7C6E2E6E6F7728292C766F696428746869735B6E2E657870616E646F5D3D213029293A6E6577206E2E4576656E7428612C62297D2C6E2E4576656E742E70726F746F7479';
wwv_flow_api.g_varchar2_table(438) := '70653D7B697344656661756C7450726576656E7465643A63622C697350726F7061676174696F6E53746F707065643A63622C6973496D6D65646961746550726F7061676174696F6E53746F707065643A63622C70726576656E7444656661756C743A6675';
wwv_flow_api.g_varchar2_table(439) := '6E6374696F6E28297B76617220613D746869732E6F726967696E616C4576656E743B746869732E697344656661756C7450726576656E7465643D62622C61262628612E70726576656E7444656661756C743F612E70726576656E7444656661756C742829';
wwv_flow_api.g_varchar2_table(440) := '3A612E72657475726E56616C75653D2131297D2C73746F7050726F7061676174696F6E3A66756E6374696F6E28297B76617220613D746869732E6F726967696E616C4576656E743B746869732E697350726F7061676174696F6E53746F707065643D6262';
wwv_flow_api.g_varchar2_table(441) := '2C61262628612E73746F7050726F7061676174696F6E2626612E73746F7050726F7061676174696F6E28292C612E63616E63656C427562626C653D2130297D2C73746F70496D6D65646961746550726F7061676174696F6E3A66756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(442) := '746869732E6973496D6D65646961746550726F7061676174696F6E53746F707065643D62622C746869732E73746F7050726F7061676174696F6E28297D7D2C6E2E65616368287B6D6F757365656E7465723A226D6F7573656F766572222C6D6F7573656C';
wwv_flow_api.g_varchar2_table(443) := '656176653A226D6F7573656F7574227D2C66756E6374696F6E28612C62297B6E2E6576656E742E7370656369616C5B615D3D7B64656C6567617465547970653A622C62696E64547970653A622C68616E646C653A66756E6374696F6E2861297B76617220';
wwv_flow_api.g_varchar2_table(444) := '632C643D746869732C653D612E72656C617465645461726765742C663D612E68616E646C654F626A3B72657475726E2821657C7C65213D3D642626216E2E636F6E7461696E7328642C652929262628612E747970653D662E6F726967547970652C633D66';
wwv_flow_api.g_varchar2_table(445) := '2E68616E646C65722E6170706C7928746869732C617267756D656E7473292C612E747970653D62292C637D7D7D292C6C2E7375626D6974427562626C65737C7C286E2E6576656E742E7370656369616C2E7375626D69743D7B73657475703A66756E6374';
wwv_flow_api.g_varchar2_table(446) := '696F6E28297B72657475726E206E2E6E6F64654E616D6528746869732C22666F726D22293F21313A766F6964206E2E6576656E742E61646428746869732C22636C69636B2E5F7375626D6974206B657970726573732E5F7375626D6974222C66756E6374';
wwv_flow_api.g_varchar2_table(447) := '696F6E2861297B76617220623D612E7461726765742C633D6E2E6E6F64654E616D6528622C22696E70757422297C7C6E2E6E6F64654E616D6528622C22627574746F6E22293F622E666F726D3A766F696420303B632626216E2E5F6461746128632C2273';
wwv_flow_api.g_varchar2_table(448) := '75626D6974427562626C657322292626286E2E6576656E742E61646428632C227375626D69742E5F7375626D6974222C66756E6374696F6E2861297B612E5F7375626D69745F627562626C653D21307D292C6E2E5F6461746128632C227375626D697442';
wwv_flow_api.g_varchar2_table(449) := '7562626C6573222C213029297D297D2C706F737444697370617463683A66756E6374696F6E2861297B612E5F7375626D69745F627562626C6526262864656C65746520612E5F7375626D69745F627562626C652C746869732E706172656E744E6F646526';
wwv_flow_api.g_varchar2_table(450) := '2621612E69735472696767657226266E2E6576656E742E73696D756C61746528227375626D6974222C746869732E706172656E744E6F64652C612C213029297D2C74656172646F776E3A66756E6374696F6E28297B72657475726E206E2E6E6F64654E61';
wwv_flow_api.g_varchar2_table(451) := '6D6528746869732C22666F726D22293F21313A766F6964206E2E6576656E742E72656D6F766528746869732C222E5F7375626D697422297D7D292C6C2E6368616E6765427562626C65737C7C286E2E6576656E742E7370656369616C2E6368616E67653D';
wwv_flow_api.g_varchar2_table(452) := '7B73657475703A66756E6374696F6E28297B72657475726E20592E7465737428746869732E6E6F64654E616D65293F282822636865636B626F78223D3D3D746869732E747970657C7C22726164696F223D3D3D746869732E74797065292626286E2E6576';
wwv_flow_api.g_varchar2_table(453) := '656E742E61646428746869732C2270726F70657274796368616E67652E5F6368616E6765222C66756E6374696F6E2861297B22636865636B6564223D3D3D612E6F726967696E616C4576656E742E70726F70657274794E616D65262628746869732E5F6A';
wwv_flow_api.g_varchar2_table(454) := '7573745F6368616E6765643D2130297D292C6E2E6576656E742E61646428746869732C22636C69636B2E5F6368616E6765222C66756E6374696F6E2861297B746869732E5F6A7573745F6368616E676564262621612E6973547269676765722626287468';
wwv_flow_api.g_varchar2_table(455) := '69732E5F6A7573745F6368616E6765643D2131292C6E2E6576656E742E73696D756C61746528226368616E6765222C746869732C612C2130297D29292C2131293A766F6964206E2E6576656E742E61646428746869732C226265666F7265616374697661';
wwv_flow_api.g_varchar2_table(456) := '74652E5F6368616E6765222C66756E6374696F6E2861297B76617220623D612E7461726765743B592E7465737428622E6E6F64654E616D65292626216E2E5F6461746128622C226368616E6765427562626C657322292626286E2E6576656E742E616464';
wwv_flow_api.g_varchar2_table(457) := '28622C226368616E67652E5F6368616E6765222C66756E6374696F6E2861297B21746869732E706172656E744E6F64657C7C612E697353696D756C617465647C7C612E6973547269676765727C7C6E2E6576656E742E73696D756C61746528226368616E';
wwv_flow_api.g_varchar2_table(458) := '6765222C746869732E706172656E744E6F64652C612C2130297D292C6E2E5F6461746128622C226368616E6765427562626C6573222C213029297D297D2C68616E646C653A66756E6374696F6E2861297B76617220623D612E7461726765743B72657475';
wwv_flow_api.g_varchar2_table(459) := '726E2074686973213D3D627C7C612E697353696D756C617465647C7C612E6973547269676765727C7C22726164696F22213D3D622E74797065262622636865636B626F7822213D3D622E747970653F612E68616E646C654F626A2E68616E646C65722E61';
wwv_flow_api.g_varchar2_table(460) := '70706C7928746869732C617267756D656E7473293A766F696420307D2C74656172646F776E3A66756E6374696F6E28297B72657475726E206E2E6576656E742E72656D6F766528746869732C222E5F6368616E676522292C21592E746573742874686973';
wwv_flow_api.g_varchar2_table(461) := '2E6E6F64654E616D65297D7D292C6C2E666F637573696E427562626C65737C7C6E2E65616368287B666F6375733A22666F637573696E222C626C75723A22666F6375736F7574227D2C66756E6374696F6E28612C62297B76617220633D66756E6374696F';
wwv_flow_api.g_varchar2_table(462) := '6E2861297B6E2E6576656E742E73696D756C61746528622C612E7461726765742C6E2E6576656E742E6669782861292C2130297D3B6E2E6576656E742E7370656369616C5B625D3D7B73657475703A66756E6374696F6E28297B76617220643D74686973';
wwv_flow_api.g_varchar2_table(463) := '2E6F776E6572446F63756D656E747C7C746869732C653D6E2E5F6461746128642C62293B657C7C642E6164644576656E744C697374656E657228612C632C2130292C6E2E5F6461746128642C622C28657C7C30292B31297D2C74656172646F776E3A6675';
wwv_flow_api.g_varchar2_table(464) := '6E6374696F6E28297B76617220643D746869732E6F776E6572446F63756D656E747C7C746869732C653D6E2E5F6461746128642C62292D313B653F6E2E5F6461746128642C622C65293A28642E72656D6F76654576656E744C697374656E657228612C63';
wwv_flow_api.g_varchar2_table(465) := '2C2130292C6E2E5F72656D6F76654461746128642C6229297D7D7D292C6E2E666E2E657874656E64287B6F6E3A66756E6374696F6E28612C622C632C642C65297B76617220662C673B696628226F626A656374223D3D747970656F662061297B22737472';
wwv_flow_api.g_varchar2_table(466) := '696E6722213D747970656F662062262628633D637C7C622C623D766F69642030293B666F72286620696E206129746869732E6F6E28662C622C632C615B665D2C65293B72657475726E20746869737D6966286E756C6C3D3D6326266E756C6C3D3D643F28';
wwv_flow_api.g_varchar2_table(467) := '643D622C633D623D766F69642030293A6E756C6C3D3D6426262822737472696E67223D3D747970656F6620623F28643D632C633D766F69642030293A28643D632C633D622C623D766F6964203029292C643D3D3D213129643D63623B656C736520696628';
wwv_flow_api.g_varchar2_table(468) := '21642972657475726E20746869733B72657475726E20313D3D3D65262628673D642C643D66756E6374696F6E2861297B72657475726E206E28292E6F66662861292C672E6170706C7928746869732C617267756D656E7473297D2C642E677569643D672E';
wwv_flow_api.g_varchar2_table(469) := '677569647C7C28672E677569643D6E2E677569642B2B29292C746869732E656163682866756E6374696F6E28297B6E2E6576656E742E61646428746869732C612C642C632C62297D297D2C6F6E653A66756E6374696F6E28612C622C632C64297B726574';
wwv_flow_api.g_varchar2_table(470) := '75726E20746869732E6F6E28612C622C632C642C31297D2C6F66663A66756E6374696F6E28612C622C63297B76617220642C653B696628612626612E70726576656E7444656661756C742626612E68616E646C654F626A2972657475726E20643D612E68';
wwv_flow_api.g_varchar2_table(471) := '616E646C654F626A2C6E28612E64656C6567617465546172676574292E6F666628642E6E616D6573706163653F642E6F726967547970652B222E222B642E6E616D6573706163653A642E6F726967547970652C642E73656C6563746F722C642E68616E64';
wwv_flow_api.g_varchar2_table(472) := '6C6572292C746869733B696628226F626A656374223D3D747970656F662061297B666F72286520696E206129746869732E6F666628652C622C615B655D293B72657475726E20746869737D72657475726E28623D3D3D21317C7C2266756E6374696F6E22';
wwv_flow_api.g_varchar2_table(473) := '3D3D747970656F66206229262628633D622C623D766F69642030292C633D3D3D2131262628633D6362292C746869732E656163682866756E6374696F6E28297B6E2E6576656E742E72656D6F766528746869732C612C632C62297D297D2C747269676765';
wwv_flow_api.g_varchar2_table(474) := '723A66756E6374696F6E28612C62297B72657475726E20746869732E656163682866756E6374696F6E28297B6E2E6576656E742E7472696767657228612C622C74686973297D297D2C7472696767657248616E646C65723A66756E6374696F6E28612C62';
wwv_flow_api.g_varchar2_table(475) := '297B76617220633D746869735B305D3B72657475726E20633F6E2E6576656E742E7472696767657228612C622C632C2130293A766F696420307D7D293B66756E6374696F6E2065622861297B76617220623D66622E73706C697428227C22292C633D612E';
wwv_flow_api.g_varchar2_table(476) := '637265617465446F63756D656E74467261676D656E7428293B696628632E637265617465456C656D656E74297768696C6528622E6C656E67746829632E637265617465456C656D656E7428622E706F702829293B72657475726E20637D7661722066623D';
wwv_flow_api.g_varchar2_table(477) := '22616262727C61727469636C657C61736964657C617564696F7C6264697C63616E7661737C646174617C646174616C6973747C64657461696C737C66696763617074696F6E7C6669677572657C666F6F7465727C6865616465727C6867726F75707C6D61';
wwv_flow_api.g_varchar2_table(478) := '726B7C6D657465727C6E61767C6F75747075747C70726F67726573737C73656374696F6E7C73756D6D6172797C74696D657C766964656F222C67623D2F206A51756572795C642B3D22283F3A6E756C6C7C5C642B29222F672C68623D6E65772052656745';
wwv_flow_api.g_varchar2_table(479) := '787028223C283F3A222B66622B22295B5C5C732F3E5D222C226922292C69623D2F5E5C732B2F2C6A623D2F3C283F21617265617C62727C636F6C7C656D6265647C68727C696D677C696E7075747C6C696E6B7C6D6574617C706172616D2928285B5C773A';
wwv_flow_api.g_varchar2_table(480) := '5D2B295B5E3E5D2A295C2F3E2F67692C6B623D2F3C285B5C773A5D2B292F2C6C623D2F3C74626F64792F692C6D623D2F3C7C26233F5C772B3B2F2C6E623D2F3C283F3A7363726970747C7374796C657C6C696E6B292F692C6F623D2F636865636B65645C';
wwv_flow_api.g_varchar2_table(481) := '732A283F3A5B5E3D5D7C3D5C732A2E636865636B65642E292F692C70623D2F5E247C5C2F283F3A6A6176617C65636D61297363726970742F692C71623D2F5E747275655C2F282E2A292F2C72623D2F5E5C732A3C21283F3A5C5B43444154415C5B7C2D2D';
wwv_flow_api.g_varchar2_table(482) := '297C283F3A5C5D5C5D7C2D2D293E5C732A242F672C73623D7B6F7074696F6E3A5B312C223C73656C656374206D756C7469706C653D276D756C7469706C65273E222C223C2F73656C6563743E225D2C6C6567656E643A5B312C223C6669656C647365743E';
wwv_flow_api.g_varchar2_table(483) := '222C223C2F6669656C647365743E225D2C617265613A5B312C223C6D61703E222C223C2F6D61703E225D2C706172616D3A5B312C223C6F626A6563743E222C223C2F6F626A6563743E225D2C74686561643A5B312C223C7461626C653E222C223C2F7461';
wwv_flow_api.g_varchar2_table(484) := '626C653E225D2C74723A5B322C223C7461626C653E3C74626F64793E222C223C2F74626F64793E3C2F7461626C653E225D2C636F6C3A5B322C223C7461626C653E3C74626F64793E3C2F74626F64793E3C636F6C67726F75703E222C223C2F636F6C6772';
wwv_flow_api.g_varchar2_table(485) := '6F75703E3C2F7461626C653E225D2C74643A5B332C223C7461626C653E3C74626F64793E3C74723E222C223C2F74723E3C2F74626F64793E3C2F7461626C653E225D2C5F64656661756C743A6C2E68746D6C53657269616C697A653F5B302C22222C2222';
wwv_flow_api.g_varchar2_table(486) := '5D3A5B312C22583C6469763E222C223C2F6469763E225D7D2C74623D6562287A292C75623D74622E617070656E644368696C64287A2E637265617465456C656D656E7428226469762229293B73622E6F707467726F75703D73622E6F7074696F6E2C7362';
wwv_flow_api.g_varchar2_table(487) := '2E74626F64793D73622E74666F6F743D73622E636F6C67726F75703D73622E63617074696F6E3D73622E74686561642C73622E74683D73622E74643B66756E6374696F6E20766228612C62297B76617220632C642C653D302C663D747970656F6620612E';
wwv_flow_api.g_varchar2_table(488) := '676574456C656D656E747342795461674E616D65213D3D4C3F612E676574456C656D656E747342795461674E616D6528627C7C222A22293A747970656F6620612E717565727953656C6563746F72416C6C213D3D4C3F612E717565727953656C6563746F';
wwv_flow_api.g_varchar2_table(489) := '72416C6C28627C7C222A22293A766F696420303B696628216629666F7228663D5B5D2C633D612E6368696C644E6F6465737C7C613B6E756C6C213D28643D635B655D293B652B2B2921627C7C6E2E6E6F64654E616D6528642C62293F662E707573682864';
wwv_flow_api.g_varchar2_table(490) := '293A6E2E6D6572676528662C766228642C6229293B72657475726E20766F696420303D3D3D627C7C6226266E2E6E6F64654E616D6528612C62293F6E2E6D65726765285B615D2C66293A667D66756E6374696F6E2077622861297B582E7465737428612E';
wwv_flow_api.g_varchar2_table(491) := '7479706529262628612E64656661756C74436865636B65643D612E636865636B6564297D66756E6374696F6E20786228612C62297B72657475726E206E2E6E6F64654E616D6528612C227461626C65222926266E2E6E6F64654E616D65283131213D3D62';
wwv_flow_api.g_varchar2_table(492) := '2E6E6F6465547970653F623A622E66697273744368696C642C22747222293F612E676574456C656D656E747342795461674E616D65282274626F647922295B305D7C7C612E617070656E644368696C6428612E6F776E6572446F63756D656E742E637265';
wwv_flow_api.g_varchar2_table(493) := '617465456C656D656E74282274626F64792229293A617D66756E6374696F6E2079622861297B72657475726E20612E747970653D286E756C6C213D3D6E2E66696E642E6174747228612C22747970652229292B222F222B612E747970652C617D66756E63';
wwv_flow_api.g_varchar2_table(494) := '74696F6E207A622861297B76617220623D71622E6578656328612E74797065293B72657475726E20623F612E747970653D625B315D3A612E72656D6F766541747472696275746528227479706522292C617D66756E6374696F6E20416228612C62297B66';
wwv_flow_api.g_varchar2_table(495) := '6F722876617220632C643D303B6E756C6C213D28633D615B645D293B642B2B296E2E5F6461746128632C22676C6F62616C4576616C222C21627C7C6E2E5F6461746128625B645D2C22676C6F62616C4576616C2229297D66756E6374696F6E2042622861';
wwv_flow_api.g_varchar2_table(496) := '2C62297B696628313D3D3D622E6E6F64655479706526266E2E68617344617461286129297B76617220632C642C652C663D6E2E5F646174612861292C673D6E2E5F6461746128622C66292C683D662E6576656E74733B69662868297B64656C6574652067';
wwv_flow_api.g_varchar2_table(497) := '2E68616E646C652C672E6576656E74733D7B7D3B666F72286320696E206829666F7228643D302C653D685B635D2E6C656E6774683B653E643B642B2B296E2E6576656E742E61646428622C632C685B635D5B645D297D672E64617461262628672E646174';
wwv_flow_api.g_varchar2_table(498) := '613D6E2E657874656E64287B7D2C672E6461746129297D7D66756E6374696F6E20436228612C62297B76617220632C642C653B696628313D3D3D622E6E6F646554797065297B696628633D622E6E6F64654E616D652E746F4C6F7765724361736528292C';
wwv_flow_api.g_varchar2_table(499) := '216C2E6E6F436C6F6E654576656E742626625B6E2E657870616E646F5D297B653D6E2E5F646174612862293B666F72286420696E20652E6576656E7473296E2E72656D6F76654576656E7428622C642C652E68616E646C65293B622E72656D6F76654174';
wwv_flow_api.g_varchar2_table(500) := '74726962757465286E2E657870616E646F297D22736372697074223D3D3D632626622E74657874213D3D612E746578743F2879622862292E746578743D612E746578742C7A62286229293A226F626A656374223D3D3D633F28622E706172656E744E6F64';
wwv_flow_api.g_varchar2_table(501) := '65262628622E6F7574657248544D4C3D612E6F7574657248544D4C292C6C2E68746D6C35436C6F6E652626612E696E6E657248544D4C2626216E2E7472696D28622E696E6E657248544D4C29262628622E696E6E657248544D4C3D612E696E6E65724854';
wwv_flow_api.g_varchar2_table(502) := '4D4C29293A22696E707574223D3D3D632626582E7465737428612E74797065293F28622E64656661756C74436865636B65643D622E636865636B65643D612E636865636B65642C622E76616C7565213D3D612E76616C7565262628622E76616C75653D61';
wwv_flow_api.g_varchar2_table(503) := '2E76616C756529293A226F7074696F6E223D3D3D633F622E64656661756C7453656C65637465643D622E73656C65637465643D612E64656661756C7453656C65637465643A2822696E707574223D3D3D637C7C227465787461726561223D3D3D63292626';
wwv_flow_api.g_varchar2_table(504) := '28622E64656661756C7456616C75653D612E64656661756C7456616C7565297D7D6E2E657874656E64287B636C6F6E653A66756E6374696F6E28612C622C63297B76617220642C652C662C672C682C693D6E2E636F6E7461696E7328612E6F776E657244';
wwv_flow_api.g_varchar2_table(505) := '6F63756D656E742C61293B6966286C2E68746D6C35436C6F6E657C7C6E2E6973584D4C446F632861297C7C2168622E7465737428223C222B612E6E6F64654E616D652B223E22293F663D612E636C6F6E654E6F6465282130293A2875622E696E6E657248';
wwv_flow_api.g_varchar2_table(506) := '544D4C3D612E6F7574657248544D4C2C75622E72656D6F76654368696C6428663D75622E66697273744368696C6429292C21286C2E6E6F436C6F6E654576656E7426266C2E6E6F436C6F6E65436865636B65647C7C31213D3D612E6E6F64655479706526';
wwv_flow_api.g_varchar2_table(507) := '263131213D3D612E6E6F6465547970657C7C6E2E6973584D4C446F632861292929666F7228643D76622866292C683D76622861292C673D303B6E756C6C213D28653D685B675D293B2B2B6729645B675D2626436228652C645B675D293B69662862296966';
wwv_flow_api.g_varchar2_table(508) := '286329666F7228683D687C7C76622861292C643D647C7C76622866292C673D303B6E756C6C213D28653D685B675D293B672B2B29426228652C645B675D293B656C736520426228612C66293B72657475726E20643D766228662C2273637269707422292C';
wwv_flow_api.g_varchar2_table(509) := '642E6C656E6774683E302626416228642C21692626766228612C227363726970742229292C643D683D653D6E756C6C2C667D2C6275696C64467261676D656E743A66756E6374696F6E28612C622C632C64297B666F722876617220652C662C672C682C69';
wwv_flow_api.g_varchar2_table(510) := '2C6A2C6B2C6D3D612E6C656E6774682C6F3D65622862292C703D5B5D2C713D303B6D3E713B712B2B29696628663D615B715D2C667C7C303D3D3D6629696628226F626A656374223D3D3D6E2E74797065286629296E2E6D6572676528702C662E6E6F6465';
wwv_flow_api.g_varchar2_table(511) := '547970653F5B665D3A66293B656C7365206966286D622E74657374286629297B683D687C7C6F2E617070656E644368696C6428622E637265617465456C656D656E7428226469762229292C693D286B622E657865632866297C7C5B22222C22225D295B31';
wwv_flow_api.g_varchar2_table(512) := '5D2E746F4C6F7765724361736528292C6B3D73625B695D7C7C73622E5F64656661756C742C682E696E6E657248544D4C3D6B5B315D2B662E7265706C616365286A622C223C24313E3C2F24323E22292B6B5B325D2C653D6B5B305D3B7768696C6528652D';
wwv_flow_api.g_varchar2_table(513) := '2D29683D682E6C6173744368696C643B696628216C2E6C656164696E6757686974657370616365262669622E746573742866292626702E7075736828622E637265617465546578744E6F64652869622E657865632866295B305D29292C216C2E74626F64';
wwv_flow_api.g_varchar2_table(514) := '79297B663D227461626C6522213D3D697C7C6C622E746573742866293F223C7461626C653E22213D3D6B5B315D7C7C6C622E746573742866293F303A683A682E66697273744368696C642C653D662626662E6368696C644E6F6465732E6C656E6774683B';
wwv_flow_api.g_varchar2_table(515) := '7768696C6528652D2D296E2E6E6F64654E616D65286A3D662E6368696C644E6F6465735B655D2C2274626F647922292626216A2E6368696C644E6F6465732E6C656E6774682626662E72656D6F76654368696C64286A297D6E2E6D6572676528702C682E';
wwv_flow_api.g_varchar2_table(516) := '6368696C644E6F646573292C682E74657874436F6E74656E743D22223B7768696C6528682E66697273744368696C6429682E72656D6F76654368696C6428682E66697273744368696C64293B683D6F2E6C6173744368696C647D656C736520702E707573';
wwv_flow_api.g_varchar2_table(517) := '6828622E637265617465546578744E6F6465286629293B6826266F2E72656D6F76654368696C642868292C6C2E617070656E64436865636B65647C7C6E2E6772657028766228702C22696E70757422292C7762292C713D303B7768696C6528663D705B71';
wwv_flow_api.g_varchar2_table(518) := '2B2B5D296966282821647C7C2D313D3D3D6E2E696E417272617928662C642929262628673D6E2E636F6E7461696E7328662E6F776E6572446F63756D656E742C66292C683D7662286F2E617070656E644368696C642866292C2273637269707422292C67';
wwv_flow_api.g_varchar2_table(519) := '262641622868292C6329297B653D303B7768696C6528663D685B652B2B5D2970622E7465737428662E747970657C7C2222292626632E707573682866297D72657475726E20683D6E756C6C2C6F7D2C636C65616E446174613A66756E6374696F6E28612C';
wwv_flow_api.g_varchar2_table(520) := '62297B666F722876617220642C652C662C672C683D302C693D6E2E657870616E646F2C6A3D6E2E63616368652C6B3D6C2E64656C657465457870616E646F2C6D3D6E2E6576656E742E7370656369616C3B6E756C6C213D28643D615B685D293B682B2B29';
wwv_flow_api.g_varchar2_table(521) := '69662828627C7C6E2E6163636570744461746128642929262628663D645B695D2C673D6626266A5B665D29297B696628672E6576656E747329666F72286520696E20672E6576656E7473296D5B655D3F6E2E6576656E742E72656D6F766528642C65293A';
wwv_flow_api.g_varchar2_table(522) := '6E2E72656D6F76654576656E7428642C652C672E68616E646C65293B6A5B665D26262864656C657465206A5B665D2C6B3F64656C65746520645B695D3A747970656F6620642E72656D6F7665417474726962757465213D3D4C3F642E72656D6F76654174';
wwv_flow_api.g_varchar2_table(523) := '747269627574652869293A645B695D3D6E756C6C2C632E70757368286629297D7D7D292C6E2E666E2E657874656E64287B746578743A66756E6374696F6E2861297B72657475726E205728746869732C66756E6374696F6E2861297B72657475726E2076';
wwv_flow_api.g_varchar2_table(524) := '6F696420303D3D3D613F6E2E746578742874686973293A746869732E656D70747928292E617070656E642828746869735B305D2626746869735B305D2E6F776E6572446F63756D656E747C7C7A292E637265617465546578744E6F6465286129297D2C6E';
wwv_flow_api.g_varchar2_table(525) := '756C6C2C612C617267756D656E74732E6C656E677468297D2C617070656E643A66756E6374696F6E28297B72657475726E20746869732E646F6D4D616E697028617267756D656E74732C66756E6374696F6E2861297B696628313D3D3D746869732E6E6F';
wwv_flow_api.g_varchar2_table(526) := '6465547970657C7C31313D3D3D746869732E6E6F6465547970657C7C393D3D3D746869732E6E6F646554797065297B76617220623D786228746869732C61293B622E617070656E644368696C642861297D7D297D2C70726570656E643A66756E6374696F';
wwv_flow_api.g_varchar2_table(527) := '6E28297B72657475726E20746869732E646F6D4D616E697028617267756D656E74732C66756E6374696F6E2861297B696628313D3D3D746869732E6E6F6465547970657C7C31313D3D3D746869732E6E6F6465547970657C7C393D3D3D746869732E6E6F';
wwv_flow_api.g_varchar2_table(528) := '646554797065297B76617220623D786228746869732C61293B622E696E736572744265666F726528612C622E66697273744368696C64297D7D297D2C6265666F72653A66756E6374696F6E28297B72657475726E20746869732E646F6D4D616E69702861';
wwv_flow_api.g_varchar2_table(529) := '7267756D656E74732C66756E6374696F6E2861297B746869732E706172656E744E6F64652626746869732E706172656E744E6F64652E696E736572744265666F726528612C74686973297D297D2C61667465723A66756E6374696F6E28297B7265747572';
wwv_flow_api.g_varchar2_table(530) := '6E20746869732E646F6D4D616E697028617267756D656E74732C66756E6374696F6E2861297B746869732E706172656E744E6F64652626746869732E706172656E744E6F64652E696E736572744265666F726528612C746869732E6E6578745369626C69';
wwv_flow_api.g_varchar2_table(531) := '6E67297D297D2C72656D6F76653A66756E6374696F6E28612C62297B666F722876617220632C643D613F6E2E66696C74657228612C74686973293A746869732C653D303B6E756C6C213D28633D645B655D293B652B2B29627C7C31213D3D632E6E6F6465';
wwv_flow_api.g_varchar2_table(532) := '547970657C7C6E2E636C65616E44617461287662286329292C632E706172656E744E6F64652626286226266E2E636F6E7461696E7328632E6F776E6572446F63756D656E742C63292626416228766228632C227363726970742229292C632E706172656E';
wwv_flow_api.g_varchar2_table(533) := '744E6F64652E72656D6F76654368696C64286329293B72657475726E20746869737D2C656D7074793A66756E6374696F6E28297B666F722876617220612C623D303B6E756C6C213D28613D746869735B625D293B622B2B297B313D3D3D612E6E6F646554';
wwv_flow_api.g_varchar2_table(534) := '79706526266E2E636C65616E4461746128766228612C213129293B7768696C6528612E66697273744368696C6429612E72656D6F76654368696C6428612E66697273744368696C64293B612E6F7074696F6E7326266E2E6E6F64654E616D6528612C2273';
wwv_flow_api.g_varchar2_table(535) := '656C6563742229262628612E6F7074696F6E732E6C656E6774683D30297D72657475726E20746869737D2C636C6F6E653A66756E6374696F6E28612C62297B72657475726E20613D6E756C6C3D3D613F21313A612C623D6E756C6C3D3D623F613A622C74';
wwv_flow_api.g_varchar2_table(536) := '6869732E6D61702866756E6374696F6E28297B72657475726E206E2E636C6F6E6528746869732C612C62297D297D2C68746D6C3A66756E6374696F6E2861297B72657475726E205728746869732C66756E6374696F6E2861297B76617220623D74686973';
wwv_flow_api.g_varchar2_table(537) := '5B305D7C7C7B7D2C633D302C643D746869732E6C656E6774683B696628766F696420303D3D3D612972657475726E20313D3D3D622E6E6F6465547970653F622E696E6E657248544D4C2E7265706C6163652867622C2222293A766F696420303B69662821';
wwv_flow_api.g_varchar2_table(538) := '2822737472696E6722213D747970656F6620617C7C6E622E746573742861297C7C216C2E68746D6C53657269616C697A65262668622E746573742861297C7C216C2E6C656164696E6757686974657370616365262669622E746573742861297C7C73625B';
wwv_flow_api.g_varchar2_table(539) := '286B622E657865632861297C7C5B22222C22225D295B315D2E746F4C6F7765724361736528295D29297B613D612E7265706C616365286A622C223C24313E3C2F24323E22293B7472797B666F72283B643E633B632B2B29623D746869735B635D7C7C7B7D';
wwv_flow_api.g_varchar2_table(540) := '2C313D3D3D622E6E6F6465547970652626286E2E636C65616E4461746128766228622C213129292C622E696E6E657248544D4C3D61293B623D307D63617463682865297B7D7D622626746869732E656D70747928292E617070656E642861297D2C6E756C';
wwv_flow_api.g_varchar2_table(541) := '6C2C612C617267756D656E74732E6C656E677468297D2C7265706C616365576974683A66756E6374696F6E28297B76617220613D617267756D656E74735B305D3B72657475726E20746869732E646F6D4D616E697028617267756D656E74732C66756E63';
wwv_flow_api.g_varchar2_table(542) := '74696F6E2862297B613D746869732E706172656E744E6F64652C6E2E636C65616E44617461287662287468697329292C612626612E7265706C6163654368696C6428622C74686973297D292C61262628612E6C656E6774687C7C612E6E6F646554797065';
wwv_flow_api.g_varchar2_table(543) := '293F746869733A746869732E72656D6F766528297D2C6465746163683A66756E6374696F6E2861297B72657475726E20746869732E72656D6F766528612C2130297D2C646F6D4D616E69703A66756E6374696F6E28612C62297B613D652E6170706C7928';
wwv_flow_api.g_varchar2_table(544) := '5B5D2C61293B76617220632C642C662C672C682C692C6A3D302C6B3D746869732E6C656E6774682C6D3D746869732C6F3D6B2D312C703D615B305D2C713D6E2E697346756E6374696F6E2870293B696628717C7C6B3E31262622737472696E67223D3D74';
wwv_flow_api.g_varchar2_table(545) := '7970656F6620702626216C2E636865636B436C6F6E6526266F622E746573742870292972657475726E20746869732E656163682866756E6374696F6E2863297B76617220643D6D2E65712863293B71262628615B305D3D702E63616C6C28746869732C63';
wwv_flow_api.g_varchar2_table(546) := '2C642E68746D6C282929292C642E646F6D4D616E697028612C62297D293B6966286B262628693D6E2E6275696C64467261676D656E7428612C746869735B305D2E6F776E6572446F63756D656E742C21312C74686973292C633D692E6669727374436869';
wwv_flow_api.g_varchar2_table(547) := '6C642C313D3D3D692E6368696C644E6F6465732E6C656E677468262628693D63292C6329297B666F7228673D6E2E6D617028766228692C2273637269707422292C7962292C663D672E6C656E6774683B6B3E6A3B6A2B2B29643D692C6A213D3D6F262628';
wwv_flow_api.g_varchar2_table(548) := '643D6E2E636C6F6E6528642C21302C2130292C6626266E2E6D6572676528672C766228642C22736372697074222929292C622E63616C6C28746869735B6A5D2C642C6A293B6966286629666F7228683D675B672E6C656E6774682D315D2E6F776E657244';
wwv_flow_api.g_varchar2_table(549) := '6F63756D656E742C6E2E6D617028672C7A62292C6A3D303B663E6A3B6A2B2B29643D675B6A5D2C70622E7465737428642E747970657C7C2222292626216E2E5F6461746128642C22676C6F62616C4576616C222926266E2E636F6E7461696E7328682C64';
wwv_flow_api.g_varchar2_table(550) := '29262628642E7372633F6E2E5F6576616C55726C26266E2E5F6576616C55726C28642E737263293A6E2E676C6F62616C4576616C2828642E746578747C7C642E74657874436F6E74656E747C7C642E696E6E657248544D4C7C7C2222292E7265706C6163';
wwv_flow_api.g_varchar2_table(551) := '652872622C22222929293B693D633D6E756C6C7D72657475726E20746869737D7D292C6E2E65616368287B617070656E64546F3A22617070656E64222C70726570656E64546F3A2270726570656E64222C696E736572744265666F72653A226265666F72';
wwv_flow_api.g_varchar2_table(552) := '65222C696E7365727441667465723A226166746572222C7265706C616365416C6C3A227265706C61636557697468227D2C66756E6374696F6E28612C62297B6E2E666E5B615D3D66756E6374696F6E2861297B666F722876617220632C643D302C653D5B';
wwv_flow_api.g_varchar2_table(553) := '5D2C673D6E2861292C683D672E6C656E6774682D313B683E3D643B642B2B29633D643D3D3D683F746869733A746869732E636C6F6E65282130292C6E28675B645D295B625D2863292C662E6170706C7928652C632E6765742829293B72657475726E2074';
wwv_flow_api.g_varchar2_table(554) := '6869732E70757368537461636B2865297D7D293B7661722044622C45623D7B7D3B66756E6374696F6E20466228622C63297B76617220643D6E28632E637265617465456C656D656E74286229292E617070656E64546F28632E626F6479292C653D612E67';
wwv_flow_api.g_varchar2_table(555) := '657444656661756C74436F6D70757465645374796C653F612E67657444656661756C74436F6D70757465645374796C6528645B305D292E646973706C61793A6E2E63737328645B305D2C22646973706C617922293B72657475726E20642E646574616368';
wwv_flow_api.g_varchar2_table(556) := '28292C657D66756E6374696F6E2047622861297B76617220623D7A2C633D45625B615D3B72657475726E20637C7C28633D466228612C62292C226E6F6E6522213D3D632626637C7C2844623D2844627C7C6E28223C696672616D65206672616D65626F72';
wwv_flow_api.g_varchar2_table(557) := '6465723D2730272077696474683D273027206865696768743D2730272F3E2229292E617070656E64546F28622E646F63756D656E74456C656D656E74292C623D2844625B305D2E636F6E74656E7457696E646F777C7C44625B305D2E636F6E74656E7444';
wwv_flow_api.g_varchar2_table(558) := '6F63756D656E74292E646F63756D656E742C622E777269746528292C622E636C6F736528292C633D466228612C62292C44622E6465746163682829292C45625B615D3D63292C637D2166756E6374696F6E28297B76617220612C622C633D7A2E63726561';
wwv_flow_api.g_varchar2_table(559) := '7465456C656D656E74282264697622292C643D222D7765626B69742D626F782D73697A696E673A636F6E74656E742D626F783B2D6D6F7A2D626F782D73697A696E673A636F6E74656E742D626F783B626F782D73697A696E673A636F6E74656E742D626F';
wwv_flow_api.g_varchar2_table(560) := '783B646973706C61793A626C6F636B3B70616464696E673A303B6D617267696E3A303B626F726465723A30223B632E696E6E657248544D4C3D2220203C6C696E6B2F3E3C7461626C653E3C2F7461626C653E3C6120687265663D272F61273E613C2F613E';
wwv_flow_api.g_varchar2_table(561) := '3C696E70757420747970653D27636865636B626F78272F3E222C613D632E676574456C656D656E747342795461674E616D6528226122295B305D2C612E7374796C652E637373546578743D22666C6F61743A6C6566743B6F7061636974793A2E35222C6C';
wwv_flow_api.g_varchar2_table(562) := '2E6F7061636974793D2F5E302E352F2E7465737428612E7374796C652E6F706163697479292C6C2E637373466C6F61743D2121612E7374796C652E637373466C6F61742C632E7374796C652E6261636B67726F756E64436C69703D22636F6E74656E742D';
wwv_flow_api.g_varchar2_table(563) := '626F78222C632E636C6F6E654E6F6465282130292E7374796C652E6261636B67726F756E64436C69703D22222C6C2E636C656172436C6F6E655374796C653D22636F6E74656E742D626F78223D3D3D632E7374796C652E6261636B67726F756E64436C69';
wwv_flow_api.g_varchar2_table(564) := '702C613D633D6E756C6C2C6C2E736872696E6B57726170426C6F636B733D66756E6374696F6E28297B76617220612C632C652C663B6966286E756C6C3D3D62297B696628613D7A2E676574456C656D656E747342795461674E616D652822626F64792229';
wwv_flow_api.g_varchar2_table(565) := '5B305D2C21612972657475726E3B663D22626F726465723A303B77696474683A303B6865696768743A303B706F736974696F6E3A6162736F6C7574653B746F703A303B6C6566743A2D393939397078222C633D7A2E637265617465456C656D656E742822';
wwv_flow_api.g_varchar2_table(566) := '64697622292C653D7A2E637265617465456C656D656E74282264697622292C612E617070656E644368696C642863292E617070656E644368696C642865292C623D21312C747970656F6620652E7374796C652E7A6F6F6D213D3D4C262628652E7374796C';
wwv_flow_api.g_varchar2_table(567) := '652E637373546578743D642B223B77696474683A3170783B70616464696E673A3170783B7A6F6F6D3A31222C652E696E6E657248544D4C3D223C6469763E3C2F6469763E222C652E66697273744368696C642E7374796C652E77696474683D2235707822';
wwv_flow_api.g_varchar2_table(568) := '2C623D33213D3D652E6F66667365745769647468292C612E72656D6F76654368696C642863292C613D633D653D6E756C6C7D72657475726E20627D7D28293B7661722048623D2F5E6D617267696E2F2C49623D6E65772052656745787028225E28222B54';
wwv_flow_api.g_varchar2_table(569) := '2B2229283F217078295B612D7A255D2B24222C226922292C4A622C4B622C4C623D2F5E28746F707C72696768747C626F74746F6D7C6C65667429242F3B612E676574436F6D70757465645374796C653F284A623D66756E6374696F6E2861297B72657475';
wwv_flow_api.g_varchar2_table(570) := '726E20612E6F776E6572446F63756D656E742E64656661756C74566965772E676574436F6D70757465645374796C6528612C6E756C6C297D2C4B623D66756E6374696F6E28612C622C63297B76617220642C652C662C672C683D612E7374796C653B7265';
wwv_flow_api.g_varchar2_table(571) := '7475726E20633D637C7C4A622861292C673D633F632E67657450726F706572747956616C75652862297C7C635B625D3A766F696420302C632626282222213D3D677C7C6E2E636F6E7461696E7328612E6F776E6572446F63756D656E742C61297C7C2867';
wwv_flow_api.g_varchar2_table(572) := '3D6E2E7374796C6528612C6229292C49622E74657374286729262648622E74657374286229262628643D682E77696474682C653D682E6D696E57696474682C663D682E6D617857696474682C682E6D696E57696474683D682E6D617857696474683D682E';
wwv_flow_api.g_varchar2_table(573) := '77696474683D672C673D632E77696474682C682E77696474683D642C682E6D696E57696474683D652C682E6D617857696474683D6629292C766F696420303D3D3D673F673A672B22227D293A7A2E646F63756D656E74456C656D656E742E63757272656E';
wwv_flow_api.g_varchar2_table(574) := '745374796C652626284A623D66756E6374696F6E2861297B72657475726E20612E63757272656E745374796C657D2C4B623D66756E6374696F6E28612C622C63297B76617220642C652C662C672C683D612E7374796C653B72657475726E20633D637C7C';
wwv_flow_api.g_varchar2_table(575) := '4A622861292C673D633F635B625D3A766F696420302C6E756C6C3D3D672626682626685B625D262628673D685B625D292C49622E746573742867292626214C622E74657374286229262628643D682E6C6566742C653D612E72756E74696D655374796C65';
wwv_flow_api.g_varchar2_table(576) := '2C663D652626652E6C6566742C66262628652E6C6566743D612E63757272656E745374796C652E6C656674292C682E6C6566743D22666F6E7453697A65223D3D3D623F2231656D223A672C673D682E706978656C4C6566742B227078222C682E6C656674';
wwv_flow_api.g_varchar2_table(577) := '3D642C66262628652E6C6566743D6629292C766F696420303D3D3D673F673A672B22227C7C226175746F227D293B66756E6374696F6E204D6228612C62297B72657475726E7B6765743A66756E6374696F6E28297B76617220633D6128293B6966286E75';
wwv_flow_api.g_varchar2_table(578) := '6C6C213D632972657475726E20633F766F69642064656C65746520746869732E6765743A28746869732E6765743D62292E6170706C7928746869732C617267756D656E7473297D7D7D2166756E6374696F6E28297B76617220622C632C642C652C662C67';
wwv_flow_api.g_varchar2_table(579) := '2C683D7A2E637265617465456C656D656E74282264697622292C693D22626F726465723A303B77696474683A303B6865696768743A303B706F736974696F6E3A6162736F6C7574653B746F703A303B6C6566743A2D393939397078222C6A3D222D776562';
wwv_flow_api.g_varchar2_table(580) := '6B69742D626F782D73697A696E673A636F6E74656E742D626F783B2D6D6F7A2D626F782D73697A696E673A636F6E74656E742D626F783B626F782D73697A696E673A636F6E74656E742D626F783B646973706C61793A626C6F636B3B70616464696E673A';
wwv_flow_api.g_varchar2_table(581) := '303B6D617267696E3A303B626F726465723A30223B682E696E6E657248544D4C3D2220203C6C696E6B2F3E3C7461626C653E3C2F7461626C653E3C6120687265663D272F61273E613C2F613E3C696E70757420747970653D27636865636B626F78272F3E';
wwv_flow_api.g_varchar2_table(582) := '222C623D682E676574456C656D656E747342795461674E616D6528226122295B305D2C622E7374796C652E637373546578743D22666C6F61743A6C6566743B6F7061636974793A2E35222C6C2E6F7061636974793D2F5E302E352F2E7465737428622E73';
wwv_flow_api.g_varchar2_table(583) := '74796C652E6F706163697479292C6C2E637373466C6F61743D2121622E7374796C652E637373466C6F61742C682E7374796C652E6261636B67726F756E64436C69703D22636F6E74656E742D626F78222C682E636C6F6E654E6F6465282130292E737479';
wwv_flow_api.g_varchar2_table(584) := '6C652E6261636B67726F756E64436C69703D22222C6C2E636C656172436C6F6E655374796C653D22636F6E74656E742D626F78223D3D3D682E7374796C652E6261636B67726F756E64436C69702C623D683D6E756C6C2C6E2E657874656E64286C2C7B72';
wwv_flow_api.g_varchar2_table(585) := '656C6961626C6548696464656E4F6666736574733A66756E6374696F6E28297B6966286E756C6C213D632972657475726E20633B76617220612C622C642C653D7A2E637265617465456C656D656E74282264697622292C663D7A2E676574456C656D656E';
wwv_flow_api.g_varchar2_table(586) := '747342795461674E616D652822626F647922295B305D3B696628662972657475726E20652E7365744174747269627574652822636C6173734E616D65222C227422292C652E696E6E657248544D4C3D2220203C6C696E6B2F3E3C7461626C653E3C2F7461';
wwv_flow_api.g_varchar2_table(587) := '626C653E3C6120687265663D272F61273E613C2F613E3C696E70757420747970653D27636865636B626F78272F3E222C613D7A2E637265617465456C656D656E74282264697622292C612E7374796C652E637373546578743D692C662E617070656E6443';
wwv_flow_api.g_varchar2_table(588) := '68696C642861292E617070656E644368696C642865292C652E696E6E657248544D4C3D223C7461626C653E3C74723E3C74643E3C2F74643E3C74643E743C2F74643E3C2F74723E3C2F7461626C653E222C623D652E676574456C656D656E747342795461';
wwv_flow_api.g_varchar2_table(589) := '674E616D652822746422292C625B305D2E7374796C652E637373546578743D2270616464696E673A303B6D617267696E3A303B626F726465723A303B646973706C61793A6E6F6E65222C643D303D3D3D625B305D2E6F66667365744865696768742C625B';
wwv_flow_api.g_varchar2_table(590) := '305D2E7374796C652E646973706C61793D22222C625B315D2E7374796C652E646973706C61793D226E6F6E65222C633D642626303D3D3D625B305D2E6F66667365744865696768742C662E72656D6F76654368696C642861292C653D663D6E756C6C2C63';
wwv_flow_api.g_varchar2_table(591) := '7D2C626F7853697A696E673A66756E6374696F6E28297B72657475726E206E756C6C3D3D6426266B28292C647D2C626F7853697A696E6752656C6961626C653A66756E6374696F6E28297B72657475726E206E756C6C3D3D6526266B28292C657D2C7069';
wwv_flow_api.g_varchar2_table(592) := '78656C506F736974696F6E3A66756E6374696F6E28297B72657475726E206E756C6C3D3D6626266B28292C667D2C72656C6961626C654D617267696E52696768743A66756E6374696F6E28297B76617220622C632C642C653B6966286E756C6C3D3D6726';
wwv_flow_api.g_varchar2_table(593) := '26612E676574436F6D70757465645374796C65297B696628623D7A2E676574456C656D656E747342795461674E616D652822626F647922295B305D2C21622972657475726E3B633D7A2E637265617465456C656D656E74282264697622292C643D7A2E63';
wwv_flow_api.g_varchar2_table(594) := '7265617465456C656D656E74282264697622292C632E7374796C652E637373546578743D692C622E617070656E644368696C642863292E617070656E644368696C642864292C653D642E617070656E644368696C64287A2E637265617465456C656D656E';
wwv_flow_api.g_varchar2_table(595) := '7428226469762229292C652E7374796C652E637373546578743D642E7374796C652E637373546578743D6A2C652E7374796C652E6D617267696E52696768743D652E7374796C652E77696474683D2230222C642E7374796C652E77696474683D22317078';
wwv_flow_api.g_varchar2_table(596) := '222C673D217061727365466C6F61742828612E676574436F6D70757465645374796C6528652C6E756C6C297C7C7B7D292E6D617267696E5269676874292C622E72656D6F76654368696C642863297D72657475726E20677D7D293B66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(597) := '6B28297B76617220622C632C683D7A2E676574456C656D656E747342795461674E616D652822626F647922295B305D3B68262628623D7A2E637265617465456C656D656E74282264697622292C633D7A2E637265617465456C656D656E74282264697622';
wwv_flow_api.g_varchar2_table(598) := '292C622E7374796C652E637373546578743D692C682E617070656E644368696C642862292E617070656E644368696C642863292C632E7374796C652E637373546578743D222D7765626B69742D626F782D73697A696E673A626F726465722D626F783B2D';
wwv_flow_api.g_varchar2_table(599) := '6D6F7A2D626F782D73697A696E673A626F726465722D626F783B626F782D73697A696E673A626F726465722D626F783B706F736974696F6E3A6162736F6C7574653B646973706C61793A626C6F636B3B70616464696E673A3170783B626F726465723A31';
wwv_flow_api.g_varchar2_table(600) := '70783B77696474683A3470783B6D617267696E2D746F703A31253B746F703A3125222C6E2E7377617028682C6E756C6C213D682E7374796C652E7A6F6F6D3F7B7A6F6F6D3A317D3A7B7D2C66756E6374696F6E28297B643D343D3D3D632E6F6666736574';
wwv_flow_api.g_varchar2_table(601) := '57696474687D292C653D21302C663D21312C673D21302C612E676574436F6D70757465645374796C65262628663D22312522213D3D28612E676574436F6D70757465645374796C6528632C6E756C6C297C7C7B7D292E746F702C653D22347078223D3D3D';
wwv_flow_api.g_varchar2_table(602) := '28612E676574436F6D70757465645374796C6528632C6E756C6C297C7C7B77696474683A22347078227D292E7769647468292C682E72656D6F76654368696C642862292C633D683D6E756C6C297D7D28292C6E2E737761703D66756E6374696F6E28612C';
wwv_flow_api.g_varchar2_table(603) := '622C632C64297B76617220652C662C673D7B7D3B666F72286620696E206229675B665D3D612E7374796C655B665D2C612E7374796C655B665D3D625B665D3B653D632E6170706C7928612C647C7C5B5D293B666F72286620696E206229612E7374796C65';
wwv_flow_api.g_varchar2_table(604) := '5B665D3D675B665D3B72657475726E20657D3B766172204E623D2F616C7068615C285B5E295D2A5C292F692C4F623D2F6F7061636974795C732A3D5C732A285B5E295D2A292F2C50623D2F5E286E6F6E657C7461626C65283F212D635B65615D292E2B29';
wwv_flow_api.g_varchar2_table(605) := '2F2C51623D6E65772052656745787028225E28222B542B2229282E2A2924222C226922292C52623D6E65772052656745787028225E285B2B2D5D293D28222B542B2229222C226922292C53623D7B706F736974696F6E3A226162736F6C757465222C7669';
wwv_flow_api.g_varchar2_table(606) := '736962696C6974793A2268696464656E222C646973706C61793A22626C6F636B227D2C54623D7B6C657474657253706163696E673A302C666F6E745765696768743A3430307D2C55623D5B225765626B6974222C224F222C224D6F7A222C226D73225D3B';
wwv_flow_api.g_varchar2_table(607) := '66756E6374696F6E20566228612C62297B6966286220696E20612972657475726E20623B76617220633D622E6368617241742830292E746F55707065724361736528292B622E736C6963652831292C643D622C653D55622E6C656E6774683B7768696C65';
wwv_flow_api.g_varchar2_table(608) := '28652D2D29696628623D55625B655D2B632C6220696E20612972657475726E20623B72657475726E20647D66756E6374696F6E20576228612C62297B666F722876617220632C642C652C663D5B5D2C673D302C683D612E6C656E6774683B683E673B672B';
wwv_flow_api.g_varchar2_table(609) := '2B29643D615B675D2C642E7374796C65262628665B675D3D6E2E5F6461746128642C226F6C64646973706C617922292C633D642E7374796C652E646973706C61792C623F28665B675D7C7C226E6F6E6522213D3D637C7C28642E7374796C652E64697370';
wwv_flow_api.g_varchar2_table(610) := '6C61793D2222292C22223D3D3D642E7374796C652E646973706C6179262656286429262628665B675D3D6E2E5F6461746128642C226F6C64646973706C6179222C476228642E6E6F64654E616D65292929293A665B675D7C7C28653D562864292C286326';
wwv_flow_api.g_varchar2_table(611) := '26226E6F6E6522213D3D637C7C21652926266E2E5F6461746128642C226F6C64646973706C6179222C653F633A6E2E63737328642C22646973706C617922292929293B666F7228673D303B683E673B672B2B29643D615B675D2C642E7374796C65262628';
wwv_flow_api.g_varchar2_table(612) := '622626226E6F6E6522213D3D642E7374796C652E646973706C617926262222213D3D642E7374796C652E646973706C61797C7C28642E7374796C652E646973706C61793D623F665B675D7C7C22223A226E6F6E652229293B72657475726E20617D66756E';
wwv_flow_api.g_varchar2_table(613) := '6374696F6E20586228612C622C63297B76617220643D51622E657865632862293B72657475726E20643F4D6174682E6D617828302C645B315D2D28637C7C3029292B28645B325D7C7C22707822293A627D66756E6374696F6E20596228612C622C632C64';
wwv_flow_api.g_varchar2_table(614) := '2C65297B666F722876617220663D633D3D3D28643F22626F72646572223A22636F6E74656E7422293F343A227769647468223D3D3D623F313A302C673D303B343E663B662B3D3229226D617267696E223D3D3D63262628672B3D6E2E63737328612C632B';
wwv_flow_api.g_varchar2_table(615) := '555B665D2C21302C6529292C643F2822636F6E74656E74223D3D3D63262628672D3D6E2E63737328612C2270616464696E67222B555B665D2C21302C6529292C226D617267696E22213D3D63262628672D3D6E2E63737328612C22626F72646572222B55';
wwv_flow_api.g_varchar2_table(616) := '5B665D2B225769647468222C21302C652929293A28672B3D6E2E63737328612C2270616464696E67222B555B665D2C21302C65292C2270616464696E6722213D3D63262628672B3D6E2E63737328612C22626F72646572222B555B665D2B225769647468';
wwv_flow_api.g_varchar2_table(617) := '222C21302C652929293B72657475726E20677D66756E6374696F6E205A6228612C622C63297B76617220643D21302C653D227769647468223D3D3D623F612E6F666673657457696474683A612E6F66667365744865696768742C663D4A622861292C673D';
wwv_flow_api.g_varchar2_table(618) := '6C2E626F7853697A696E672829262622626F726465722D626F78223D3D3D6E2E63737328612C22626F7853697A696E67222C21312C66293B696628303E3D657C7C6E756C6C3D3D65297B696628653D4B6228612C622C66292C28303E657C7C6E756C6C3D';
wwv_flow_api.g_varchar2_table(619) := '3D6529262628653D612E7374796C655B625D292C49622E746573742865292972657475726E20653B643D672626286C2E626F7853697A696E6752656C6961626C6528297C7C653D3D3D612E7374796C655B625D292C653D7061727365466C6F6174286529';
wwv_flow_api.g_varchar2_table(620) := '7C7C307D72657475726E20652B596228612C622C637C7C28673F22626F72646572223A22636F6E74656E7422292C642C66292B227078227D6E2E657874656E64287B637373486F6F6B733A7B6F7061636974793A7B6765743A66756E6374696F6E28612C';
wwv_flow_api.g_varchar2_table(621) := '62297B69662862297B76617220633D4B6228612C226F70616369747922293B72657475726E22223D3D3D633F2231223A637D7D7D7D2C6373734E756D6265723A7B636F6C756D6E436F756E743A21302C66696C6C4F7061636974793A21302C666F6E7457';
wwv_flow_api.g_varchar2_table(622) := '65696768743A21302C6C696E654865696768743A21302C6F7061636974793A21302C6F726465723A21302C6F727068616E733A21302C7769646F77733A21302C7A496E6465783A21302C7A6F6F6D3A21307D2C63737350726F70733A7B22666C6F617422';
wwv_flow_api.g_varchar2_table(623) := '3A6C2E637373466C6F61743F22637373466C6F6174223A227374796C65466C6F6174227D2C7374796C653A66756E6374696F6E28612C622C632C64297B69662861262633213D3D612E6E6F646554797065262638213D3D612E6E6F646554797065262661';
wwv_flow_api.g_varchar2_table(624) := '2E7374796C65297B76617220652C662C672C683D6E2E63616D656C436173652862292C693D612E7374796C653B696628623D6E2E63737350726F70735B685D7C7C286E2E63737350726F70735B685D3D566228692C6829292C673D6E2E637373486F6F6B';
wwv_flow_api.g_varchar2_table(625) := '735B625D7C7C6E2E637373486F6F6B735B685D2C766F696420303D3D3D632972657475726E206726262267657422696E20672626766F69642030213D3D28653D672E67657428612C21312C6429293F653A695B625D3B696628663D747970656F6620632C';
wwv_flow_api.g_varchar2_table(626) := '22737472696E67223D3D3D66262628653D52622E6578656328632929262628633D28655B315D2B31292A655B325D2B7061727365466C6F6174286E2E63737328612C6229292C663D226E756D62657222292C6E756C6C213D632626633D3D3D6326262822';
wwv_flow_api.g_varchar2_table(627) := '6E756D62657222213D3D667C7C6E2E6373734E756D6265725B685D7C7C28632B3D22707822292C6C2E636C656172436C6F6E655374796C657C7C2222213D3D637C7C30213D3D622E696E6465784F6628226261636B67726F756E6422297C7C28695B625D';
wwv_flow_api.g_varchar2_table(628) := '3D22696E686572697422292C21286726262273657422696E20672626766F696420303D3D3D28633D672E73657428612C632C6429292929297472797B695B625D3D22222C695B625D3D637D6361746368286A297B7D7D7D2C6373733A66756E6374696F6E';
wwv_flow_api.g_varchar2_table(629) := '28612C622C632C64297B76617220652C662C672C683D6E2E63616D656C436173652862293B72657475726E20623D6E2E63737350726F70735B685D7C7C286E2E63737350726F70735B685D3D566228612E7374796C652C6829292C673D6E2E637373486F';
wwv_flow_api.g_varchar2_table(630) := '6F6B735B625D7C7C6E2E637373486F6F6B735B685D2C6726262267657422696E2067262628663D672E67657428612C21302C6329292C766F696420303D3D3D66262628663D4B6228612C622C6429292C226E6F726D616C223D3D3D6626266220696E2054';
wwv_flow_api.g_varchar2_table(631) := '62262628663D54625B625D292C22223D3D3D637C7C633F28653D7061727365466C6F61742866292C633D3D3D21307C7C6E2E69734E756D657269632865293F657C7C303A66293A667D7D292C6E2E65616368285B22686569676874222C22776964746822';
wwv_flow_api.g_varchar2_table(632) := '5D2C66756E6374696F6E28612C62297B6E2E637373486F6F6B735B625D3D7B6765743A66756E6374696F6E28612C632C64297B72657475726E20633F303D3D3D612E6F66667365745769647468262650622E74657374286E2E63737328612C2264697370';
wwv_flow_api.g_varchar2_table(633) := '6C61792229293F6E2E7377617028612C53622C66756E6374696F6E28297B72657475726E205A6228612C622C64297D293A5A6228612C622C64293A766F696420307D2C7365743A66756E6374696F6E28612C632C64297B76617220653D6426264A622861';
wwv_flow_api.g_varchar2_table(634) := '293B72657475726E20586228612C632C643F596228612C622C642C6C2E626F7853697A696E672829262622626F726465722D626F78223D3D3D6E2E63737328612C22626F7853697A696E67222C21312C65292C65293A30297D7D7D292C6C2E6F70616369';
wwv_flow_api.g_varchar2_table(635) := '74797C7C286E2E637373486F6F6B732E6F7061636974793D7B6765743A66756E6374696F6E28612C62297B72657475726E204F622E746573742828622626612E63757272656E745374796C653F612E63757272656E745374796C652E66696C7465723A61';
wwv_flow_api.g_varchar2_table(636) := '2E7374796C652E66696C746572297C7C2222293F2E30312A7061727365466C6F6174285265674578702E2431292B22223A623F2231223A22227D2C7365743A66756E6374696F6E28612C62297B76617220633D612E7374796C652C643D612E6375727265';
wwv_flow_api.g_varchar2_table(637) := '6E745374796C652C653D6E2E69734E756D657269632862293F22616C706861286F7061636974793D222B3130302A622B2229223A22222C663D642626642E66696C7465727C7C632E66696C7465727C7C22223B632E7A6F6F6D3D312C28623E3D317C7C22';
wwv_flow_api.g_varchar2_table(638) := '223D3D3D6229262622223D3D3D6E2E7472696D28662E7265706C616365284E622C222229292626632E72656D6F7665417474726962757465262628632E72656D6F7665417474726962757465282266696C74657222292C22223D3D3D627C7C6426262164';
wwv_flow_api.g_varchar2_table(639) := '2E66696C746572297C7C28632E66696C7465723D4E622E746573742866293F662E7265706C616365284E622C65293A662B2220222B65297D7D292C6E2E637373486F6F6B732E6D617267696E52696768743D4D62286C2E72656C6961626C654D61726769';
wwv_flow_api.g_varchar2_table(640) := '6E52696768742C66756E6374696F6E28612C62297B72657475726E20623F6E2E7377617028612C7B646973706C61793A22696E6C696E652D626C6F636B227D2C4B622C5B612C226D617267696E5269676874225D293A766F696420307D292C6E2E656163';
wwv_flow_api.g_varchar2_table(641) := '68287B6D617267696E3A22222C70616464696E673A22222C626F726465723A225769647468227D2C66756E6374696F6E28612C62297B6E2E637373486F6F6B735B612B625D3D7B657870616E643A66756E6374696F6E2863297B666F722876617220643D';
wwv_flow_api.g_varchar2_table(642) := '302C653D7B7D2C663D22737472696E67223D3D747970656F6620633F632E73706C697428222022293A5B635D3B343E643B642B2B29655B612B555B645D2B625D3D665B645D7C7C665B642D325D7C7C665B305D3B72657475726E20657D7D2C48622E7465';
wwv_flow_api.g_varchar2_table(643) := '73742861297C7C286E2E637373486F6F6B735B612B625D2E7365743D5862297D292C6E2E666E2E657874656E64287B6373733A66756E6374696F6E28612C62297B72657475726E205728746869732C66756E6374696F6E28612C622C63297B7661722064';
wwv_flow_api.g_varchar2_table(644) := '2C652C663D7B7D2C673D303B6966286E2E69734172726179286229297B666F7228643D4A622861292C653D622E6C656E6774683B653E673B672B2B29665B625B675D5D3D6E2E63737328612C625B675D2C21312C64293B72657475726E20667D72657475';
wwv_flow_api.g_varchar2_table(645) := '726E20766F69642030213D3D633F6E2E7374796C6528612C622C63293A6E2E63737328612C62290D0A7D2C612C622C617267756D656E74732E6C656E6774683E31297D2C73686F773A66756E6374696F6E28297B72657475726E20576228746869732C21';
wwv_flow_api.g_varchar2_table(646) := '30297D2C686964653A66756E6374696F6E28297B72657475726E2057622874686973297D2C746F67676C653A66756E6374696F6E2861297B72657475726E22626F6F6C65616E223D3D747970656F6620613F613F746869732E73686F7728293A74686973';
wwv_flow_api.g_varchar2_table(647) := '2E6869646528293A746869732E656163682866756E6374696F6E28297B562874686973293F6E2874686973292E73686F7728293A6E2874686973292E6869646528297D297D7D293B66756E6374696F6E20246228612C622C632C642C65297B7265747572';
wwv_flow_api.g_varchar2_table(648) := '6E206E65772024622E70726F746F747970652E696E697428612C622C632C642C65297D6E2E547765656E3D24622C24622E70726F746F747970653D7B636F6E7374727563746F723A24622C696E69743A66756E6374696F6E28612C622C632C642C652C66';
wwv_flow_api.g_varchar2_table(649) := '297B746869732E656C656D3D612C746869732E70726F703D632C746869732E656173696E673D657C7C227377696E67222C746869732E6F7074696F6E733D622C746869732E73746172743D746869732E6E6F773D746869732E63757228292C746869732E';
wwv_flow_api.g_varchar2_table(650) := '656E643D642C746869732E756E69743D667C7C286E2E6373734E756D6265725B635D3F22223A22707822297D2C6375723A66756E6374696F6E28297B76617220613D24622E70726F70486F6F6B735B746869732E70726F705D3B72657475726E20612626';
wwv_flow_api.g_varchar2_table(651) := '612E6765743F612E6765742874686973293A24622E70726F70486F6F6B732E5F64656661756C742E6765742874686973297D2C72756E3A66756E6374696F6E2861297B76617220622C633D24622E70726F70486F6F6B735B746869732E70726F705D3B72';
wwv_flow_api.g_varchar2_table(652) := '657475726E20746869732E706F733D623D746869732E6F7074696F6E732E6475726174696F6E3F6E2E656173696E675B746869732E656173696E675D28612C746869732E6F7074696F6E732E6475726174696F6E2A612C302C312C746869732E6F707469';
wwv_flow_api.g_varchar2_table(653) := '6F6E732E6475726174696F6E293A612C746869732E6E6F773D28746869732E656E642D746869732E7374617274292A622B746869732E73746172742C746869732E6F7074696F6E732E737465702626746869732E6F7074696F6E732E737465702E63616C';
wwv_flow_api.g_varchar2_table(654) := '6C28746869732E656C656D2C746869732E6E6F772C74686973292C632626632E7365743F632E7365742874686973293A24622E70726F70486F6F6B732E5F64656661756C742E7365742874686973292C746869737D7D2C24622E70726F746F747970652E';
wwv_flow_api.g_varchar2_table(655) := '696E69742E70726F746F747970653D24622E70726F746F747970652C24622E70726F70486F6F6B733D7B5F64656661756C743A7B6765743A66756E6374696F6E2861297B76617220623B72657475726E206E756C6C3D3D612E656C656D5B612E70726F70';
wwv_flow_api.g_varchar2_table(656) := '5D7C7C612E656C656D2E7374796C6526266E756C6C213D612E656C656D2E7374796C655B612E70726F705D3F28623D6E2E63737328612E656C656D2C612E70726F702C2222292C622626226175746F22213D3D623F623A30293A612E656C656D5B612E70';
wwv_flow_api.g_varchar2_table(657) := '726F705D7D2C7365743A66756E6374696F6E2861297B6E2E66782E737465705B612E70726F705D3F6E2E66782E737465705B612E70726F705D2861293A612E656C656D2E7374796C652626286E756C6C213D612E656C656D2E7374796C655B6E2E637373';
wwv_flow_api.g_varchar2_table(658) := '50726F70735B612E70726F705D5D7C7C6E2E637373486F6F6B735B612E70726F705D293F6E2E7374796C6528612E656C656D2C612E70726F702C612E6E6F772B612E756E6974293A612E656C656D5B612E70726F705D3D612E6E6F777D7D7D2C24622E70';
wwv_flow_api.g_varchar2_table(659) := '726F70486F6F6B732E7363726F6C6C546F703D24622E70726F70486F6F6B732E7363726F6C6C4C6566743D7B7365743A66756E6374696F6E2861297B612E656C656D2E6E6F6465547970652626612E656C656D2E706172656E744E6F6465262628612E65';
wwv_flow_api.g_varchar2_table(660) := '6C656D5B612E70726F705D3D612E6E6F77297D7D2C6E2E656173696E673D7B6C696E6561723A66756E6374696F6E2861297B72657475726E20617D2C7377696E673A66756E6374696F6E2861297B72657475726E2E352D4D6174682E636F7328612A4D61';
wwv_flow_api.g_varchar2_table(661) := '74682E5049292F327D7D2C6E2E66783D24622E70726F746F747970652E696E69742C6E2E66782E737465703D7B7D3B766172205F622C61632C62633D2F5E283F3A746F67676C657C73686F777C6869646529242F2C63633D6E6577205265674578702822';
wwv_flow_api.g_varchar2_table(662) := '5E283F3A285B2B2D5D293D7C2928222B542B2229285B612D7A255D2A2924222C226922292C64633D2F7175657565486F6F6B73242F2C65633D5B6A635D2C66633D7B222A223A5B66756E6374696F6E28612C62297B76617220633D746869732E63726561';
wwv_flow_api.g_varchar2_table(663) := '7465547765656E28612C62292C643D632E63757228292C653D63632E657865632862292C663D652626655B335D7C7C286E2E6373734E756D6265725B615D3F22223A22707822292C673D286E2E6373734E756D6265725B615D7C7C22707822213D3D6626';
wwv_flow_api.g_varchar2_table(664) := '262B6429262663632E65786563286E2E63737328632E656C656D2C6129292C683D312C693D32303B696628672626675B335D213D3D66297B663D667C7C675B335D2C653D657C7C5B5D2C673D2B647C7C313B646F20683D687C7C222E35222C672F3D682C';
wwv_flow_api.g_varchar2_table(665) := '6E2E7374796C6528632E656C656D2C612C672B66293B7768696C652868213D3D28683D632E63757228292F6429262631213D3D6826262D2D69297D72657475726E2065262628673D632E73746172743D2B677C7C2B647C7C302C632E756E69743D662C63';
wwv_flow_api.g_varchar2_table(666) := '2E656E643D655B315D3F672B28655B315D2B31292A655B325D3A2B655B325D292C637D5D7D3B66756E6374696F6E20676328297B72657475726E2073657454696D656F75742866756E6374696F6E28297B5F623D766F696420307D292C5F623D6E2E6E6F';
wwv_flow_api.g_varchar2_table(667) := '7728297D66756E6374696F6E20686328612C62297B76617220632C643D7B6865696768743A617D2C653D303B666F7228623D623F313A303B343E653B652B3D322D6229633D555B655D2C645B226D617267696E222B635D3D645B2270616464696E67222B';
wwv_flow_api.g_varchar2_table(668) := '635D3D613B72657475726E2062262628642E6F7061636974793D642E77696474683D61292C647D66756E6374696F6E20696328612C622C63297B666F722876617220642C653D2866635B625D7C7C5B5D292E636F6E6361742866635B222A225D292C663D';
wwv_flow_api.g_varchar2_table(669) := '302C673D652E6C656E6774683B673E663B662B2B29696628643D655B665D2E63616C6C28632C622C61292972657475726E20647D66756E6374696F6E206A6328612C622C63297B76617220642C652C662C672C682C692C6A2C6B2C6D3D746869732C6F3D';
wwv_flow_api.g_varchar2_table(670) := '7B7D2C703D612E7374796C652C713D612E6E6F6465547970652626562861292C723D6E2E5F6461746128612C22667873686F7722293B632E71756575657C7C28683D6E2E5F7175657565486F6F6B7328612C22667822292C6E756C6C3D3D682E756E7175';
wwv_flow_api.g_varchar2_table(671) := '65756564262628682E756E7175657565643D302C693D682E656D7074792E666972652C682E656D7074792E666972653D66756E6374696F6E28297B682E756E7175657565647C7C6928297D292C682E756E7175657565642B2B2C6D2E616C776179732866';
wwv_flow_api.g_varchar2_table(672) := '756E6374696F6E28297B6D2E616C776179732866756E6374696F6E28297B682E756E7175657565642D2D2C6E2E717565756528612C22667822292E6C656E6774687C7C682E656D7074792E6669726528297D297D29292C313D3D3D612E6E6F6465547970';
wwv_flow_api.g_varchar2_table(673) := '652626282268656967687422696E20627C7C22776964746822696E206229262628632E6F766572666C6F773D5B702E6F766572666C6F772C702E6F766572666C6F77582C702E6F766572666C6F77595D2C6A3D6E2E63737328612C22646973706C617922';
wwv_flow_api.g_varchar2_table(674) := '292C6B3D476228612E6E6F64654E616D65292C226E6F6E65223D3D3D6A2626286A3D6B292C22696E6C696E65223D3D3D6A2626226E6F6E65223D3D3D6E2E63737328612C22666C6F617422292626286C2E696E6C696E65426C6F636B4E656564734C6179';
wwv_flow_api.g_varchar2_table(675) := '6F7574262622696E6C696E6522213D3D6B3F702E7A6F6F6D3D313A702E646973706C61793D22696E6C696E652D626C6F636B2229292C632E6F766572666C6F77262628702E6F766572666C6F773D2268696464656E222C6C2E736872696E6B5772617042';
wwv_flow_api.g_varchar2_table(676) := '6C6F636B7328297C7C6D2E616C776179732866756E6374696F6E28297B702E6F766572666C6F773D632E6F766572666C6F775B305D2C702E6F766572666C6F77583D632E6F766572666C6F775B315D2C702E6F766572666C6F77593D632E6F766572666C';
wwv_flow_api.g_varchar2_table(677) := '6F775B325D7D29293B666F72286420696E206229696628653D625B645D2C62632E65786563286529297B69662864656C65746520625B645D2C663D667C7C22746F67676C65223D3D3D652C653D3D3D28713F2268696465223A2273686F772229297B6966';
wwv_flow_api.g_varchar2_table(678) := '282273686F7722213D3D657C7C21727C7C766F696420303D3D3D725B645D29636F6E74696E75653B713D21307D6F5B645D3D722626725B645D7C7C6E2E7374796C6528612C64297D696628216E2E6973456D7074794F626A656374286F29297B723F2268';
wwv_flow_api.g_varchar2_table(679) := '696464656E22696E2072262628713D722E68696464656E293A723D6E2E5F6461746128612C22667873686F77222C7B7D292C66262628722E68696464656E3D2171292C713F6E2861292E73686F7728293A6D2E646F6E652866756E6374696F6E28297B6E';
wwv_flow_api.g_varchar2_table(680) := '2861292E6869646528297D292C6D2E646F6E652866756E6374696F6E28297B76617220623B6E2E5F72656D6F76654461746128612C22667873686F7722293B666F72286220696E206F296E2E7374796C6528612C622C6F5B625D297D293B666F72286420';
wwv_flow_api.g_varchar2_table(681) := '696E206F29673D696328713F725B645D3A302C642C6D292C6420696E20727C7C28725B645D3D672E73746172742C71262628672E656E643D672E73746172742C672E73746172743D227769647468223D3D3D647C7C22686569676874223D3D3D643F313A';
wwv_flow_api.g_varchar2_table(682) := '3029297D7D66756E6374696F6E206B6328612C62297B76617220632C642C652C662C673B666F72286320696E206129696628643D6E2E63616D656C436173652863292C653D625B645D2C663D615B635D2C6E2E69734172726179286629262628653D665B';
wwv_flow_api.g_varchar2_table(683) := '315D2C663D615B635D3D665B305D292C63213D3D64262628615B645D3D662C64656C65746520615B635D292C673D6E2E637373486F6F6B735B645D2C67262622657870616E6422696E2067297B663D672E657870616E642866292C64656C65746520615B';
wwv_flow_api.g_varchar2_table(684) := '645D3B666F72286320696E2066296320696E20617C7C28615B635D3D665B635D2C625B635D3D65297D656C736520625B645D3D657D66756E6374696F6E206C6328612C622C63297B76617220642C652C663D302C673D65632E6C656E6774682C683D6E2E';
wwv_flow_api.g_varchar2_table(685) := '446566657272656428292E616C776179732866756E6374696F6E28297B64656C65746520692E656C656D7D292C693D66756E6374696F6E28297B696628652972657475726E21313B666F722876617220623D5F627C7C676328292C633D4D6174682E6D61';
wwv_flow_api.g_varchar2_table(686) := '7828302C6A2E737461727454696D652B6A2E6475726174696F6E2D62292C643D632F6A2E6475726174696F6E7C7C302C663D312D642C673D302C693D6A2E747765656E732E6C656E6774683B693E673B672B2B296A2E747765656E735B675D2E72756E28';
wwv_flow_api.g_varchar2_table(687) := '66293B72657475726E20682E6E6F746966795769746828612C5B6A2C662C635D292C313E662626693F633A28682E7265736F6C76655769746828612C5B6A5D292C2131297D2C6A3D682E70726F6D697365287B656C656D3A612C70726F70733A6E2E6578';
wwv_flow_api.g_varchar2_table(688) := '74656E64287B7D2C62292C6F7074733A6E2E657874656E642821302C7B7370656369616C456173696E673A7B7D7D2C63292C6F726967696E616C50726F706572746965733A622C6F726967696E616C4F7074696F6E733A632C737461727454696D653A5F';
wwv_flow_api.g_varchar2_table(689) := '627C7C676328292C6475726174696F6E3A632E6475726174696F6E2C747765656E733A5B5D2C637265617465547765656E3A66756E6374696F6E28622C63297B76617220643D6E2E547765656E28612C6A2E6F7074732C622C632C6A2E6F7074732E7370';
wwv_flow_api.g_varchar2_table(690) := '656369616C456173696E675B625D7C7C6A2E6F7074732E656173696E67293B72657475726E206A2E747765656E732E707573682864292C647D2C73746F703A66756E6374696F6E2862297B76617220633D302C643D623F6A2E747765656E732E6C656E67';
wwv_flow_api.g_varchar2_table(691) := '74683A303B696628652972657475726E20746869733B666F7228653D21303B643E633B632B2B296A2E747765656E735B635D2E72756E2831293B72657475726E20623F682E7265736F6C76655769746828612C5B6A2C625D293A682E72656A6563745769';
wwv_flow_api.g_varchar2_table(692) := '746828612C5B6A2C625D292C746869737D7D292C6B3D6A2E70726F70733B666F72286B63286B2C6A2E6F7074732E7370656369616C456173696E67293B673E663B662B2B29696628643D65635B665D2E63616C6C286A2C612C6B2C6A2E6F707473292972';
wwv_flow_api.g_varchar2_table(693) := '657475726E20643B72657475726E206E2E6D6170286B2C69632C6A292C6E2E697346756E6374696F6E286A2E6F7074732E73746172742926266A2E6F7074732E73746172742E63616C6C28612C6A292C6E2E66782E74696D6572286E2E657874656E6428';
wwv_flow_api.g_varchar2_table(694) := '692C7B656C656D3A612C616E696D3A6A2C71756575653A6A2E6F7074732E71756575657D29292C6A2E70726F6772657373286A2E6F7074732E70726F6772657373292E646F6E65286A2E6F7074732E646F6E652C6A2E6F7074732E636F6D706C65746529';
wwv_flow_api.g_varchar2_table(695) := '2E6661696C286A2E6F7074732E6661696C292E616C77617973286A2E6F7074732E616C77617973297D6E2E416E696D6174696F6E3D6E2E657874656E64286C632C7B747765656E65723A66756E6374696F6E28612C62297B6E2E697346756E6374696F6E';
wwv_flow_api.g_varchar2_table(696) := '2861293F28623D612C613D5B222A225D293A613D612E73706C697428222022293B666F722876617220632C643D302C653D612E6C656E6774683B653E643B642B2B29633D615B645D2C66635B635D3D66635B635D7C7C5B5D2C66635B635D2E756E736869';
wwv_flow_api.g_varchar2_table(697) := '66742862297D2C70726566696C7465723A66756E6374696F6E28612C62297B623F65632E756E73686966742861293A65632E707573682861297D7D292C6E2E73706565643D66756E6374696F6E28612C622C63297B76617220643D612626226F626A6563';
wwv_flow_api.g_varchar2_table(698) := '74223D3D747970656F6620613F6E2E657874656E64287B7D2C61293A7B636F6D706C6574653A637C7C21632626627C7C6E2E697346756E6374696F6E2861292626612C6475726174696F6E3A612C656173696E673A632626627C7C622626216E2E697346';
wwv_flow_api.g_varchar2_table(699) := '756E6374696F6E2862292626627D3B72657475726E20642E6475726174696F6E3D6E2E66782E6F66663F303A226E756D626572223D3D747970656F6620642E6475726174696F6E3F642E6475726174696F6E3A642E6475726174696F6E20696E206E2E66';
wwv_flow_api.g_varchar2_table(700) := '782E7370656564733F6E2E66782E7370656564735B642E6475726174696F6E5D3A6E2E66782E7370656564732E5F64656661756C742C286E756C6C3D3D642E71756575657C7C642E71756575653D3D3D213029262628642E71756575653D22667822292C';
wwv_flow_api.g_varchar2_table(701) := '642E6F6C643D642E636F6D706C6574652C642E636F6D706C6574653D66756E6374696F6E28297B6E2E697346756E6374696F6E28642E6F6C64292626642E6F6C642E63616C6C2874686973292C642E717565756526266E2E646571756575652874686973';
wwv_flow_api.g_varchar2_table(702) := '2C642E7175657565297D2C647D2C6E2E666E2E657874656E64287B66616465546F3A66756E6374696F6E28612C622C632C64297B72657475726E20746869732E66696C7465722856292E63737328226F706163697479222C30292E73686F7728292E656E';
wwv_flow_api.g_varchar2_table(703) := '6428292E616E696D617465287B6F7061636974793A627D2C612C632C64297D2C616E696D6174653A66756E6374696F6E28612C622C632C64297B76617220653D6E2E6973456D7074794F626A6563742861292C663D6E2E737065656428622C632C64292C';
wwv_flow_api.g_varchar2_table(704) := '673D66756E6374696F6E28297B76617220623D6C6328746869732C6E2E657874656E64287B7D2C61292C66293B28657C7C6E2E5F6461746128746869732C2266696E6973682229292626622E73746F70282130297D3B72657475726E20672E66696E6973';
wwv_flow_api.g_varchar2_table(705) := '683D672C657C7C662E71756575653D3D3D21313F746869732E656163682867293A746869732E717565756528662E71756575652C67297D2C73746F703A66756E6374696F6E28612C622C63297B76617220643D66756E6374696F6E2861297B7661722062';
wwv_flow_api.g_varchar2_table(706) := '3D612E73746F703B64656C65746520612E73746F702C622863297D3B72657475726E22737472696E6722213D747970656F662061262628633D622C623D612C613D766F69642030292C62262661213D3D21312626746869732E717565756528617C7C2266';
wwv_flow_api.g_varchar2_table(707) := '78222C5B5D292C746869732E656163682866756E6374696F6E28297B76617220623D21302C653D6E756C6C213D612626612B227175657565486F6F6B73222C663D6E2E74696D6572732C673D6E2E5F646174612874686973293B6966286529675B655D26';
wwv_flow_api.g_varchar2_table(708) := '26675B655D2E73746F7026266428675B655D293B656C736520666F72286520696E206729675B655D2626675B655D2E73746F70262664632E7465737428652926266428675B655D293B666F7228653D662E6C656E6774683B652D2D3B29665B655D2E656C';
wwv_flow_api.g_varchar2_table(709) := '656D213D3D746869737C7C6E756C6C213D612626665B655D2E7175657565213D3D617C7C28665B655D2E616E696D2E73746F702863292C623D21312C662E73706C69636528652C3129293B28627C7C21632926266E2E6465717565756528746869732C61';
wwv_flow_api.g_varchar2_table(710) := '297D297D2C66696E6973683A66756E6374696F6E2861297B72657475726E2061213D3D2131262628613D617C7C22667822292C746869732E656163682866756E6374696F6E28297B76617220622C633D6E2E5F646174612874686973292C643D635B612B';
wwv_flow_api.g_varchar2_table(711) := '227175657565225D2C653D635B612B227175657565486F6F6B73225D2C663D6E2E74696D6572732C673D643F642E6C656E6774683A303B666F7228632E66696E6973683D21302C6E2E717565756528746869732C612C5B5D292C652626652E73746F7026';
wwv_flow_api.g_varchar2_table(712) := '26652E73746F702E63616C6C28746869732C2130292C623D662E6C656E6774683B622D2D3B29665B625D2E656C656D3D3D3D746869732626665B625D2E71756575653D3D3D61262628665B625D2E616E696D2E73746F70282130292C662E73706C696365';
wwv_flow_api.g_varchar2_table(713) := '28622C3129293B666F7228623D303B673E623B622B2B29645B625D2626645B625D2E66696E6973682626645B625D2E66696E6973682E63616C6C2874686973293B64656C65746520632E66696E6973687D297D7D292C6E2E65616368285B22746F67676C';
wwv_flow_api.g_varchar2_table(714) := '65222C2273686F77222C2268696465225D2C66756E6374696F6E28612C62297B76617220633D6E2E666E5B625D3B6E2E666E5B625D3D66756E6374696F6E28612C642C65297B72657475726E206E756C6C3D3D617C7C22626F6F6C65616E223D3D747970';
wwv_flow_api.g_varchar2_table(715) := '656F6620613F632E6170706C7928746869732C617267756D656E7473293A746869732E616E696D61746528686328622C2130292C612C642C65297D7D292C6E2E65616368287B736C696465446F776E3A6863282273686F7722292C736C69646555703A68';
wwv_flow_api.g_varchar2_table(716) := '6328226869646522292C736C696465546F67676C653A68632822746F67676C6522292C66616465496E3A7B6F7061636974793A2273686F77227D2C666164654F75743A7B6F7061636974793A2268696465227D2C66616465546F67676C653A7B6F706163';
wwv_flow_api.g_varchar2_table(717) := '6974793A22746F67676C65227D7D2C66756E6374696F6E28612C62297B6E2E666E5B615D3D66756E6374696F6E28612C632C64297B72657475726E20746869732E616E696D61746528622C612C632C64297D7D292C6E2E74696D6572733D5B5D2C6E2E66';
wwv_flow_api.g_varchar2_table(718) := '782E7469636B3D66756E6374696F6E28297B76617220612C623D6E2E74696D6572732C633D303B666F72285F623D6E2E6E6F7728293B633C622E6C656E6774683B632B2B29613D625B635D2C6128297C7C625B635D213D3D617C7C622E73706C69636528';
wwv_flow_api.g_varchar2_table(719) := '632D2D2C31293B622E6C656E6774687C7C6E2E66782E73746F7028292C5F623D766F696420307D2C6E2E66782E74696D65723D66756E6374696F6E2861297B6E2E74696D6572732E707573682861292C6128293F6E2E66782E737461727428293A6E2E74';
wwv_flow_api.g_varchar2_table(720) := '696D6572732E706F7028297D2C6E2E66782E696E74657276616C3D31332C6E2E66782E73746172743D66756E6374696F6E28297B61637C7C2861633D736574496E74657276616C286E2E66782E7469636B2C6E2E66782E696E74657276616C29297D2C6E';
wwv_flow_api.g_varchar2_table(721) := '2E66782E73746F703D66756E6374696F6E28297B636C656172496E74657276616C286163292C61633D6E756C6C7D2C6E2E66782E7370656564733D7B736C6F773A3630302C666173743A3230302C5F64656661756C743A3430307D2C6E2E666E2E64656C';
wwv_flow_api.g_varchar2_table(722) := '61793D66756E6374696F6E28612C62297B72657475726E20613D6E2E66783F6E2E66782E7370656564735B615D7C7C613A612C623D627C7C226678222C746869732E717565756528622C66756E6374696F6E28622C63297B76617220643D73657454696D';
wwv_flow_api.g_varchar2_table(723) := '656F757428622C61293B632E73746F703D66756E6374696F6E28297B636C65617254696D656F75742864297D7D297D2C66756E6374696F6E28297B76617220612C622C632C642C653D7A2E637265617465456C656D656E74282264697622293B652E7365';
wwv_flow_api.g_varchar2_table(724) := '744174747269627574652822636C6173734E616D65222C227422292C652E696E6E657248544D4C3D2220203C6C696E6B2F3E3C7461626C653E3C2F7461626C653E3C6120687265663D272F61273E613C2F613E3C696E70757420747970653D2763686563';
wwv_flow_api.g_varchar2_table(725) := '6B626F78272F3E222C613D652E676574456C656D656E747342795461674E616D6528226122295B305D2C633D7A2E637265617465456C656D656E74282273656C65637422292C643D632E617070656E644368696C64287A2E637265617465456C656D656E';
wwv_flow_api.g_varchar2_table(726) := '7428226F7074696F6E2229292C623D652E676574456C656D656E747342795461674E616D652822696E70757422295B305D2C612E7374796C652E637373546578743D22746F703A317078222C6C2E6765745365744174747269627574653D227422213D3D';
wwv_flow_api.g_varchar2_table(727) := '652E636C6173734E616D652C6C2E7374796C653D2F746F702F2E7465737428612E67657441747472696275746528227374796C652229292C6C2E687265664E6F726D616C697A65643D222F61223D3D3D612E676574417474726962757465282268726566';
wwv_flow_api.g_varchar2_table(728) := '22292C6C2E636865636B4F6E3D2121622E76616C75652C6C2E6F707453656C65637465643D642E73656C65637465642C6C2E656E63747970653D21217A2E637265617465456C656D656E742822666F726D22292E656E63747970652C632E64697361626C';
wwv_flow_api.g_varchar2_table(729) := '65643D21302C6C2E6F707444697361626C65643D21642E64697361626C65642C623D7A2E637265617465456C656D656E742822696E70757422292C622E736574417474726962757465282276616C7565222C2222292C6C2E696E7075743D22223D3D3D62';
wwv_flow_api.g_varchar2_table(730) := '2E676574417474726962757465282276616C756522292C622E76616C75653D2274222C622E736574417474726962757465282274797065222C22726164696F22292C6C2E726164696F56616C75653D2274223D3D3D622E76616C75652C613D623D633D64';
wwv_flow_api.g_varchar2_table(731) := '3D653D6E756C6C7D28293B766172206D633D2F5C722F673B6E2E666E2E657874656E64287B76616C3A66756E6374696F6E2861297B76617220622C632C642C653D746869735B305D3B7B696628617267756D656E74732E6C656E6774682972657475726E';
wwv_flow_api.g_varchar2_table(732) := '20643D6E2E697346756E6374696F6E2861292C746869732E656163682866756E6374696F6E2863297B76617220653B313D3D3D746869732E6E6F646554797065262628653D643F612E63616C6C28746869732C632C6E2874686973292E76616C2829293A';
wwv_flow_api.g_varchar2_table(733) := '612C6E756C6C3D3D653F653D22223A226E756D626572223D3D747970656F6620653F652B3D22223A6E2E69734172726179286529262628653D6E2E6D617028652C66756E6374696F6E2861297B72657475726E206E756C6C3D3D613F22223A612B22227D';
wwv_flow_api.g_varchar2_table(734) := '29292C623D6E2E76616C486F6F6B735B746869732E747970655D7C7C6E2E76616C486F6F6B735B746869732E6E6F64654E616D652E746F4C6F7765724361736528295D2C6226262273657422696E20622626766F69642030213D3D622E73657428746869';
wwv_flow_api.g_varchar2_table(735) := '732C652C2276616C756522297C7C28746869732E76616C75653D6529297D293B696628652972657475726E20623D6E2E76616C486F6F6B735B652E747970655D7C7C6E2E76616C486F6F6B735B652E6E6F64654E616D652E746F4C6F7765724361736528';
wwv_flow_api.g_varchar2_table(736) := '295D2C6226262267657422696E20622626766F69642030213D3D28633D622E67657428652C2276616C75652229293F633A28633D652E76616C75652C22737472696E67223D3D747970656F6620633F632E7265706C616365286D632C2222293A6E756C6C';
wwv_flow_api.g_varchar2_table(737) := '3D3D633F22223A63297D7D7D292C6E2E657874656E64287B76616C486F6F6B733A7B6F7074696F6E3A7B6765743A66756E6374696F6E2861297B76617220623D6E2E66696E642E6174747228612C2276616C756522293B72657475726E206E756C6C213D';
wwv_flow_api.g_varchar2_table(738) := '623F623A6E2E746578742861297D7D2C73656C6563743A7B6765743A66756E6374696F6E2861297B666F722876617220622C632C643D612E6F7074696F6E732C653D612E73656C6563746564496E6465782C663D2273656C6563742D6F6E65223D3D3D61';
wwv_flow_api.g_varchar2_table(739) := '2E747970657C7C303E652C673D663F6E756C6C3A5B5D2C683D663F652B313A642E6C656E6774682C693D303E653F683A663F653A303B683E693B692B2B29696628633D645B695D2C212821632E73656C6563746564262669213D3D657C7C286C2E6F7074';
wwv_flow_api.g_varchar2_table(740) := '44697361626C65643F632E64697361626C65643A6E756C6C213D3D632E676574417474726962757465282264697361626C65642229297C7C632E706172656E744E6F64652E64697361626C656426266E2E6E6F64654E616D6528632E706172656E744E6F';
wwv_flow_api.g_varchar2_table(741) := '64652C226F707467726F7570222929297B696628623D6E2863292E76616C28292C662972657475726E20623B672E707573682862297D72657475726E20677D2C7365743A66756E6374696F6E28612C62297B76617220632C642C653D612E6F7074696F6E';
wwv_flow_api.g_varchar2_table(742) := '732C663D6E2E6D616B6541727261792862292C673D652E6C656E6774683B7768696C6528672D2D29696628643D655B675D2C6E2E696E4172726179286E2E76616C486F6F6B732E6F7074696F6E2E6765742864292C66293E3D30297472797B642E73656C';
wwv_flow_api.g_varchar2_table(743) := '65637465643D633D21307D63617463682868297B642E7363726F6C6C4865696768747D656C736520642E73656C65637465643D21313B72657475726E20637C7C28612E73656C6563746564496E6465783D2D31292C657D7D7D7D292C6E2E65616368285B';
wwv_flow_api.g_varchar2_table(744) := '22726164696F222C22636865636B626F78225D2C66756E6374696F6E28297B6E2E76616C486F6F6B735B746869735D3D7B7365743A66756E6374696F6E28612C62297B72657475726E206E2E697341727261792862293F612E636865636B65643D6E2E69';
wwv_flow_api.g_varchar2_table(745) := '6E4172726179286E2861292E76616C28292C62293E3D303A766F696420307D7D2C6C2E636865636B4F6E7C7C286E2E76616C486F6F6B735B746869735D2E6765743D66756E6374696F6E2861297B72657475726E206E756C6C3D3D3D612E676574417474';
wwv_flow_api.g_varchar2_table(746) := '726962757465282276616C756522293F226F6E223A612E76616C75657D297D293B766172206E632C6F632C70633D6E2E657870722E6174747248616E646C652C71633D2F5E283F3A636865636B65647C73656C656374656429242F692C72633D6C2E6765';
wwv_flow_api.g_varchar2_table(747) := '745365744174747269627574652C73633D6C2E696E7075743B6E2E666E2E657874656E64287B617474723A66756E6374696F6E28612C62297B72657475726E205728746869732C6E2E617474722C612C622C617267756D656E74732E6C656E6774683E31';
wwv_flow_api.g_varchar2_table(748) := '297D2C72656D6F7665417474723A66756E6374696F6E2861297B72657475726E20746869732E656163682866756E6374696F6E28297B6E2E72656D6F76654174747228746869732C61297D297D7D292C6E2E657874656E64287B617474723A66756E6374';
wwv_flow_api.g_varchar2_table(749) := '696F6E28612C622C63297B76617220642C652C663D612E6E6F6465547970653B69662861262633213D3D66262638213D3D66262632213D3D662972657475726E20747970656F6620612E6765744174747269627574653D3D3D4C3F6E2E70726F7028612C';
wwv_flow_api.g_varchar2_table(750) := '622C63293A28313D3D3D6626266E2E6973584D4C446F632861297C7C28623D622E746F4C6F7765724361736528292C643D6E2E61747472486F6F6B735B625D7C7C286E2E657870722E6D617463682E626F6F6C2E746573742862293F6F633A6E6329292C';
wwv_flow_api.g_varchar2_table(751) := '766F696420303D3D3D633F6426262267657422696E206426266E756C6C213D3D28653D642E67657428612C6229293F653A28653D6E2E66696E642E6174747228612C62292C6E756C6C3D3D653F766F696420303A65293A6E756C6C213D3D633F64262622';
wwv_flow_api.g_varchar2_table(752) := '73657422696E20642626766F69642030213D3D28653D642E73657428612C632C6229293F653A28612E73657441747472696275746528622C632B2222292C63293A766F6964206E2E72656D6F76654174747228612C6229297D2C72656D6F766541747472';
wwv_flow_api.g_varchar2_table(753) := '3A66756E6374696F6E28612C62297B76617220632C642C653D302C663D622626622E6D617463682846293B696628662626313D3D3D612E6E6F646554797065297768696C6528633D665B652B2B5D29643D6E2E70726F704669785B635D7C7C632C6E2E65';
wwv_flow_api.g_varchar2_table(754) := '7870722E6D617463682E626F6F6C2E746573742863293F7363262672637C7C2171632E746573742863293F615B645D3D21313A615B6E2E63616D656C43617365282264656661756C742D222B63295D3D615B645D3D21313A6E2E6174747228612C632C22';
wwv_flow_api.g_varchar2_table(755) := '22292C612E72656D6F76654174747269627574652872633F633A64297D2C61747472486F6F6B733A7B747970653A7B7365743A66756E6374696F6E28612C62297B696628216C2E726164696F56616C7565262622726164696F223D3D3D6226266E2E6E6F';
wwv_flow_api.g_varchar2_table(756) := '64654E616D6528612C22696E7075742229297B76617220633D612E76616C75653B72657475726E20612E736574417474726962757465282274797065222C62292C63262628612E76616C75653D63292C627D7D7D7D7D292C6F633D7B7365743A66756E63';
wwv_flow_api.g_varchar2_table(757) := '74696F6E28612C622C63297B72657475726E20623D3D3D21313F6E2E72656D6F76654174747228612C63293A7363262672637C7C2171632E746573742863293F612E7365744174747269627574652821726326266E2E70726F704669785B635D7C7C632C';
wwv_flow_api.g_varchar2_table(758) := '63293A615B6E2E63616D656C43617365282264656661756C742D222B63295D3D615B635D3D21302C637D7D2C6E2E65616368286E2E657870722E6D617463682E626F6F6C2E736F757263652E6D61746368282F5C772B2F67292C66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(759) := '2C62297B76617220633D70635B625D7C7C6E2E66696E642E617474723B70635B625D3D7363262672637C7C2171632E746573742862293F66756E6374696F6E28612C622C64297B76617220652C663B72657475726E20647C7C28663D70635B625D2C7063';
wwv_flow_api.g_varchar2_table(760) := '5B625D3D652C653D6E756C6C213D6328612C622C64293F622E746F4C6F7765724361736528293A6E756C6C2C70635B625D3D66292C657D3A66756E6374696F6E28612C622C63297B72657475726E20633F766F696420303A615B6E2E63616D656C436173';
wwv_flow_api.g_varchar2_table(761) := '65282264656661756C742D222B62295D3F622E746F4C6F7765724361736528293A6E756C6C7D7D292C7363262672637C7C286E2E61747472486F6F6B732E76616C75653D7B7365743A66756E6374696F6E28612C622C63297B72657475726E206E2E6E6F';
wwv_flow_api.g_varchar2_table(762) := '64654E616D6528612C22696E70757422293F766F696428612E64656661756C7456616C75653D62293A6E6326266E632E73657428612C622C63297D7D292C72637C7C286E633D7B7365743A66756E6374696F6E28612C622C63297B76617220643D612E67';
wwv_flow_api.g_varchar2_table(763) := '65744174747269627574654E6F64652863293B72657475726E20647C7C612E7365744174747269627574654E6F646528643D612E6F776E6572446F63756D656E742E637265617465417474726962757465286329292C642E76616C75653D622B3D22222C';
wwv_flow_api.g_varchar2_table(764) := '2276616C7565223D3D3D637C7C623D3D3D612E6765744174747269627574652863293F623A766F696420307D7D2C70632E69643D70632E6E616D653D70632E636F6F7264733D66756E6374696F6E28612C622C63297B76617220643B72657475726E2063';
wwv_flow_api.g_varchar2_table(765) := '3F766F696420303A28643D612E6765744174747269627574654E6F64652862292926262222213D3D642E76616C75653F642E76616C75653A6E756C6C7D2C6E2E76616C486F6F6B732E627574746F6E3D7B6765743A66756E6374696F6E28612C62297B76';
wwv_flow_api.g_varchar2_table(766) := '617220633D612E6765744174747269627574654E6F64652862293B72657475726E20632626632E7370656369666965643F632E76616C75653A766F696420307D2C7365743A6E632E7365747D2C6E2E61747472486F6F6B732E636F6E74656E7465646974';
wwv_flow_api.g_varchar2_table(767) := '61626C653D7B7365743A66756E6374696F6E28612C622C63297B6E632E73657428612C22223D3D3D623F21313A622C63297D7D2C6E2E65616368285B227769647468222C22686569676874225D2C66756E6374696F6E28612C62297B6E2E61747472486F';
wwv_flow_api.g_varchar2_table(768) := '6F6B735B625D3D7B7365743A66756E6374696F6E28612C63297B72657475726E22223D3D3D633F28612E73657441747472696275746528622C226175746F22292C63293A766F696420307D7D7D29292C6C2E7374796C657C7C286E2E61747472486F6F6B';
wwv_flow_api.g_varchar2_table(769) := '732E7374796C653D7B6765743A66756E6374696F6E2861297B72657475726E20612E7374796C652E637373546578747C7C766F696420307D2C7365743A66756E6374696F6E28612C62297B72657475726E20612E7374796C652E637373546578743D622B';
wwv_flow_api.g_varchar2_table(770) := '22227D7D293B7661722074633D2F5E283F3A696E7075747C73656C6563747C74657874617265617C627574746F6E7C6F626A65637429242F692C75633D2F5E283F3A617C6172656129242F693B6E2E666E2E657874656E64287B70726F703A66756E6374';
wwv_flow_api.g_varchar2_table(771) := '696F6E28612C62297B72657475726E205728746869732C6E2E70726F702C612C622C617267756D656E74732E6C656E6774683E31297D2C72656D6F766550726F703A66756E6374696F6E2861297B72657475726E20613D6E2E70726F704669785B615D7C';
wwv_flow_api.g_varchar2_table(772) := '7C612C746869732E656163682866756E6374696F6E28297B7472797B746869735B615D3D766F696420302C64656C65746520746869735B615D7D63617463682862297B7D7D297D7D292C6E2E657874656E64287B70726F704669783A7B22666F72223A22';
wwv_flow_api.g_varchar2_table(773) := '68746D6C466F72222C22636C617373223A22636C6173734E616D65227D2C70726F703A66756E6374696F6E28612C622C63297B76617220642C652C662C673D612E6E6F6465547970653B69662861262633213D3D67262638213D3D67262632213D3D6729';
wwv_flow_api.g_varchar2_table(774) := '72657475726E20663D31213D3D677C7C216E2E6973584D4C446F632861292C66262628623D6E2E70726F704669785B625D7C7C622C653D6E2E70726F70486F6F6B735B625D292C766F69642030213D3D633F6526262273657422696E20652626766F6964';
wwv_flow_api.g_varchar2_table(775) := '2030213D3D28643D652E73657428612C632C6229293F643A615B625D3D633A6526262267657422696E206526266E756C6C213D3D28643D652E67657428612C6229293F643A615B625D7D2C70726F70486F6F6B733A7B746162496E6465783A7B6765743A';
wwv_flow_api.g_varchar2_table(776) := '66756E6374696F6E2861297B76617220623D6E2E66696E642E6174747228612C22746162696E64657822293B72657475726E20623F7061727365496E7428622C3130293A74632E7465737428612E6E6F64654E616D65297C7C75632E7465737428612E6E';
wwv_flow_api.g_varchar2_table(777) := '6F64654E616D65292626612E687265663F303A2D317D7D7D7D292C6C2E687265664E6F726D616C697A65647C7C6E2E65616368285B2268726566222C22737263225D2C66756E6374696F6E28612C62297B6E2E70726F70486F6F6B735B625D3D7B676574';
wwv_flow_api.g_varchar2_table(778) := '3A66756E6374696F6E2861297B72657475726E20612E67657441747472696275746528622C34297D7D7D292C6C2E6F707453656C65637465647C7C286E2E70726F70486F6F6B732E73656C65637465643D7B6765743A66756E6374696F6E2861297B7661';
wwv_flow_api.g_varchar2_table(779) := '7220623D612E706172656E744E6F64653B72657475726E2062262628622E73656C6563746564496E6465782C622E706172656E744E6F64652626622E706172656E744E6F64652E73656C6563746564496E646578292C6E756C6C7D7D292C6E2E65616368';
wwv_flow_api.g_varchar2_table(780) := '285B22746162496E646578222C22726561644F6E6C79222C226D61784C656E677468222C2263656C6C53706163696E67222C2263656C6C50616464696E67222C22726F775370616E222C22636F6C5370616E222C227573654D6170222C226672616D6542';
wwv_flow_api.g_varchar2_table(781) := '6F72646572222C22636F6E74656E744564697461626C65225D2C66756E6374696F6E28297B6E2E70726F704669785B746869732E746F4C6F7765724361736528295D3D746869737D292C6C2E656E63747970657C7C286E2E70726F704669782E656E6374';
wwv_flow_api.g_varchar2_table(782) := '7970653D22656E636F64696E6722293B7661722076633D2F5B5C745C725C6E5C665D2F673B6E2E666E2E657874656E64287B616464436C6173733A66756E6374696F6E2861297B76617220622C632C642C652C662C672C683D302C693D746869732E6C65';
wwv_flow_api.g_varchar2_table(783) := '6E6774682C6A3D22737472696E67223D3D747970656F6620612626613B6966286E2E697346756E6374696F6E2861292972657475726E20746869732E656163682866756E6374696F6E2862297B6E2874686973292E616464436C61737328612E63616C6C';
wwv_flow_api.g_varchar2_table(784) := '28746869732C622C746869732E636C6173734E616D6529297D293B6966286A29666F7228623D28617C7C2222292E6D617463682846297C7C5B5D3B693E683B682B2B29696628633D746869735B685D2C643D313D3D3D632E6E6F64655479706526262863';
wwv_flow_api.g_varchar2_table(785) := '2E636C6173734E616D653F282220222B632E636C6173734E616D652B222022292E7265706C6163652876632C222022293A22202229297B663D303B7768696C6528653D625B662B2B5D29642E696E6465784F66282220222B652B222022293C3026262864';
wwv_flow_api.g_varchar2_table(786) := '2B3D652B222022293B673D6E2E7472696D2864292C632E636C6173734E616D65213D3D67262628632E636C6173734E616D653D67297D72657475726E20746869737D2C72656D6F7665436C6173733A66756E6374696F6E2861297B76617220622C632C64';
wwv_flow_api.g_varchar2_table(787) := '2C652C662C672C683D302C693D746869732E6C656E6774682C6A3D303D3D3D617267756D656E74732E6C656E6774687C7C22737472696E67223D3D747970656F6620612626613B6966286E2E697346756E6374696F6E2861292972657475726E20746869';
wwv_flow_api.g_varchar2_table(788) := '732E656163682866756E6374696F6E2862297B6E2874686973292E72656D6F7665436C61737328612E63616C6C28746869732C622C746869732E636C6173734E616D6529297D293B6966286A29666F7228623D28617C7C2222292E6D617463682846297C';
wwv_flow_api.g_varchar2_table(789) := '7C5B5D3B693E683B682B2B29696628633D746869735B685D2C643D313D3D3D632E6E6F646554797065262628632E636C6173734E616D653F282220222B632E636C6173734E616D652B222022292E7265706C6163652876632C222022293A222229297B66';
wwv_flow_api.g_varchar2_table(790) := '3D303B7768696C6528653D625B662B2B5D297768696C6528642E696E6465784F66282220222B652B222022293E3D3029643D642E7265706C616365282220222B652B2220222C222022293B673D613F6E2E7472696D2864293A22222C632E636C6173734E';
wwv_flow_api.g_varchar2_table(791) := '616D65213D3D67262628632E636C6173734E616D653D67297D72657475726E20746869737D2C746F67676C65436C6173733A66756E6374696F6E28612C62297B76617220633D747970656F6620613B72657475726E22626F6F6C65616E223D3D74797065';
wwv_flow_api.g_varchar2_table(792) := '6F662062262622737472696E67223D3D3D633F623F746869732E616464436C6173732861293A746869732E72656D6F7665436C6173732861293A746869732E65616368286E2E697346756E6374696F6E2861293F66756E6374696F6E2863297B6E287468';
wwv_flow_api.g_varchar2_table(793) := '6973292E746F67676C65436C61737328612E63616C6C28746869732C632C746869732E636C6173734E616D652C62292C62297D3A66756E6374696F6E28297B69662822737472696E67223D3D3D63297B76617220622C643D302C653D6E2874686973292C';
wwv_flow_api.g_varchar2_table(794) := '663D612E6D617463682846297C7C5B5D3B7768696C6528623D665B642B2B5D29652E686173436C6173732862293F652E72656D6F7665436C6173732862293A652E616464436C6173732862297D656C736528633D3D3D4C7C7C22626F6F6C65616E223D3D';
wwv_flow_api.g_varchar2_table(795) := '3D6329262628746869732E636C6173734E616D6526266E2E5F6461746128746869732C225F5F636C6173734E616D655F5F222C746869732E636C6173734E616D65292C746869732E636C6173734E616D653D746869732E636C6173734E616D657C7C613D';
wwv_flow_api.g_varchar2_table(796) := '3D3D21313F22223A6E2E5F6461746128746869732C225F5F636C6173734E616D655F5F22297C7C2222297D297D2C686173436C6173733A66756E6374696F6E2861297B666F722876617220623D2220222B612B2220222C633D302C643D746869732E6C65';
wwv_flow_api.g_varchar2_table(797) := '6E6774683B643E633B632B2B29696628313D3D3D746869735B635D2E6E6F6465547970652626282220222B746869735B635D2E636C6173734E616D652B222022292E7265706C6163652876632C222022292E696E6465784F662862293E3D302972657475';
wwv_flow_api.g_varchar2_table(798) := '726E21303B72657475726E21317D7D292C6E2E656163682822626C757220666F63757320666F637573696E20666F6375736F7574206C6F616420726573697A65207363726F6C6C20756E6C6F616420636C69636B2064626C636C69636B206D6F75736564';
wwv_flow_api.g_varchar2_table(799) := '6F776E206D6F7573657570206D6F7573656D6F7665206D6F7573656F766572206D6F7573656F7574206D6F757365656E746572206D6F7573656C65617665206368616E67652073656C656374207375626D6974206B6579646F776E206B65797072657373';
wwv_flow_api.g_varchar2_table(800) := '206B65797570206572726F7220636F6E746578746D656E75222E73706C697428222022292C66756E6374696F6E28612C62297B6E2E666E5B625D3D66756E6374696F6E28612C63297B72657475726E20617267756D656E74732E6C656E6774683E303F74';
wwv_flow_api.g_varchar2_table(801) := '6869732E6F6E28622C6E756C6C2C612C63293A746869732E747269676765722862297D7D292C6E2E666E2E657874656E64287B686F7665723A66756E6374696F6E28612C62297B72657475726E20746869732E6D6F757365656E7465722861292E6D6F75';
wwv_flow_api.g_varchar2_table(802) := '73656C6561766528627C7C61297D2C62696E643A66756E6374696F6E28612C622C63297B72657475726E20746869732E6F6E28612C6E756C6C2C622C63297D2C756E62696E643A66756E6374696F6E28612C62297B72657475726E20746869732E6F6666';
wwv_flow_api.g_varchar2_table(803) := '28612C6E756C6C2C62297D2C64656C65676174653A66756E6374696F6E28612C622C632C64297B72657475726E20746869732E6F6E28622C612C632C64297D2C756E64656C65676174653A66756E6374696F6E28612C622C63297B72657475726E20313D';
wwv_flow_api.g_varchar2_table(804) := '3D3D617267756D656E74732E6C656E6774683F746869732E6F666628612C222A2A22293A746869732E6F666628622C617C7C222A2A222C63297D7D293B7661722077633D6E2E6E6F7728292C78633D2F5C3F2F2C79633D2F282C297C285C5B7C7B297C28';
wwv_flow_api.g_varchar2_table(805) := '7D7C5D297C22283F3A5B5E225C5C5C725C6E5D7C5C5C5B225C5C5C2F62666E72745D7C5C5C755B5C64612D66412D465D7B347D292A225C732A3A3F7C747275657C66616C73657C6E756C6C7C2D3F283F21305C64295C642B283F3A5C2E5C642B7C29283F';
wwv_flow_api.g_varchar2_table(806) := '3A5B65455D5B2B2D5D3F5C642B7C292F673B6E2E70617273654A534F4E3D66756E6374696F6E2862297B696628612E4A534F4E2626612E4A534F4E2E70617273652972657475726E20612E4A534F4E2E706172736528622B2222293B76617220632C643D';
wwv_flow_api.g_varchar2_table(807) := '6E756C6C2C653D6E2E7472696D28622B2222293B72657475726E20652626216E2E7472696D28652E7265706C6163652879632C66756E6374696F6E28612C622C652C66297B72657475726E2063262662262628643D30292C303D3D3D643F613A28633D65';
wwv_flow_api.g_varchar2_table(808) := '7C7C622C642B3D21662D21652C2222297D29293F46756E6374696F6E282272657475726E20222B652928293A6E2E6572726F722822496E76616C6964204A534F4E3A20222B62297D2C6E2E7061727365584D4C3D66756E6374696F6E2862297B76617220';
wwv_flow_api.g_varchar2_table(809) := '632C643B69662821627C7C22737472696E6722213D747970656F6620622972657475726E206E756C6C3B7472797B612E444F4D5061727365723F28643D6E657720444F4D5061727365722C633D642E706172736546726F6D537472696E6728622C227465';
wwv_flow_api.g_varchar2_table(810) := '78742F786D6C2229293A28633D6E657720416374697665584F626A65637428224D6963726F736F66742E584D4C444F4D22292C632E6173796E633D2266616C7365222C632E6C6F6164584D4C286229297D63617463682865297B633D766F696420307D72';
wwv_flow_api.g_varchar2_table(811) := '657475726E20632626632E646F63756D656E74456C656D656E74262621632E676574456C656D656E747342795461674E616D6528227061727365726572726F7222292E6C656E6774687C7C6E2E6572726F722822496E76616C696420584D4C3A20222B62';
wwv_flow_api.g_varchar2_table(812) := '292C637D3B766172207A632C41632C42633D2F232E2A242F2C43633D2F285B3F265D295F3D5B5E265D2A2F2C44633D2F5E282E2A3F293A5B205C745D2A285B5E5C725C6E5D2A295C723F242F676D2C45633D2F5E283F3A61626F75747C6170707C617070';
wwv_flow_api.g_varchar2_table(813) := '2D73746F726167657C2E2B2D657874656E73696F6E7C66696C657C7265737C776964676574293A242F2C46633D2F5E283F3A4745547C4845414429242F2C47633D2F5E5C2F5C2F2F2C48633D2F5E285B5C772E2B2D5D2B3A29283F3A5C2F5C2F283F3A5B';
wwv_flow_api.g_varchar2_table(814) := '5E5C2F3F235D2A407C29285B5E5C2F3F233A5D2A29283F3A3A285C642B297C297C292F2C49633D7B7D2C4A633D7B7D2C4B633D222A2F222E636F6E63617428222A22293B7472797B41633D6C6F636174696F6E2E687265667D6361746368284C63297B41';
wwv_flow_api.g_varchar2_table(815) := '633D7A2E637265617465456C656D656E7428226122292C41632E687265663D22222C41633D41632E687265667D7A633D48632E657865632841632E746F4C6F776572436173652829297C7C5B5D3B66756E6374696F6E204D632861297B72657475726E20';
wwv_flow_api.g_varchar2_table(816) := '66756E6374696F6E28622C63297B22737472696E6722213D747970656F662062262628633D622C623D222A22293B76617220642C653D302C663D622E746F4C6F7765724361736528292E6D617463682846297C7C5B5D3B6966286E2E697346756E637469';
wwv_flow_api.g_varchar2_table(817) := '6F6E286329297768696C6528643D665B652B2B5D29222B223D3D3D642E6368617241742830293F28643D642E736C6963652831297C7C222A222C28615B645D3D615B645D7C7C5B5D292E756E7368696674286329293A28615B645D3D615B645D7C7C5B5D';
wwv_flow_api.g_varchar2_table(818) := '292E707573682863297D7D66756E6374696F6E204E6328612C622C632C64297B76617220653D7B7D2C663D613D3D3D4A633B66756E6374696F6E20672868297B76617220693B72657475726E20655B685D3D21302C6E2E6561636828615B685D7C7C5B5D';
wwv_flow_api.g_varchar2_table(819) := '2C66756E6374696F6E28612C68297B766172206A3D6828622C632C64293B72657475726E22737472696E6722213D747970656F66206A7C7C667C7C655B6A5D3F663F2128693D6A293A766F696420303A28622E6461746154797065732E756E7368696674';
wwv_flow_api.g_varchar2_table(820) := '286A292C67286A292C2131297D292C697D72657475726E206728622E6461746154797065735B305D297C7C21655B222A225D26266728222A22297D66756E6374696F6E204F6328612C62297B76617220632C642C653D6E2E616A617853657474696E6773';
wwv_flow_api.g_varchar2_table(821) := '2E666C61744F7074696F6E737C7C7B7D3B666F72286420696E206229766F69642030213D3D625B645D26262828655B645D3F613A637C7C28633D7B7D29295B645D3D625B645D293B72657475726E206326266E2E657874656E642821302C612C63292C61';
wwv_flow_api.g_varchar2_table(822) := '7D66756E6374696F6E20506328612C622C63297B76617220642C652C662C672C683D612E636F6E74656E74732C693D612E6461746154797065733B7768696C6528222A223D3D3D695B305D29692E736869667428292C766F696420303D3D3D6526262865';
wwv_flow_api.g_varchar2_table(823) := '3D612E6D696D65547970657C7C622E676574526573706F6E73654865616465722822436F6E74656E742D547970652229293B6966286529666F72286720696E206829696628685B675D2626685B675D2E74657374286529297B692E756E73686966742867';
wwv_flow_api.g_varchar2_table(824) := '293B627265616B7D696628695B305D696E206329663D695B305D3B656C73657B666F72286720696E2063297B69662821695B305D7C7C612E636F6E766572746572735B672B2220222B695B305D5D297B663D673B627265616B7D647C7C28643D67297D66';
wwv_flow_api.g_varchar2_table(825) := '3D667C7C647D72657475726E20663F2866213D3D695B305D2626692E756E73686966742866292C635B665D293A766F696420307D66756E6374696F6E20516328612C622C632C64297B76617220652C662C672C682C692C6A3D7B7D2C6B3D612E64617461';
wwv_flow_api.g_varchar2_table(826) := '54797065732E736C69636528293B6966286B5B315D29666F72286720696E20612E636F6E76657274657273296A5B672E746F4C6F7765724361736528295D3D612E636F6E766572746572735B675D3B663D6B2E736869667428293B7768696C6528662969';
wwv_flow_api.g_varchar2_table(827) := '6628612E726573706F6E73654669656C64735B665D262628635B612E726573706F6E73654669656C64735B665D5D3D62292C21692626642626612E6461746146696C746572262628623D612E6461746146696C74657228622C612E646174615479706529';
wwv_flow_api.g_varchar2_table(828) := '292C693D662C663D6B2E7368696674282929696628222A223D3D3D6629663D693B656C736520696628222A22213D3D69262669213D3D66297B696628673D6A5B692B2220222B665D7C7C6A5B222A20222B665D2C216729666F72286520696E206A296966';
wwv_flow_api.g_varchar2_table(829) := '28683D652E73706C697428222022292C685B315D3D3D3D66262628673D6A5B692B2220222B685B305D5D7C7C6A5B222A20222B685B305D5D29297B673D3D3D21303F673D6A5B655D3A6A5B655D213D3D2130262628663D685B305D2C6B2E756E73686966';
wwv_flow_api.g_varchar2_table(830) := '7428685B315D29293B627265616B7D69662867213D3D213029696628672626615B227468726F7773225D29623D672862293B656C7365207472797B623D672862297D6361746368286C297B72657475726E7B73746174653A227061727365726572726F72';
wwv_flow_api.g_varchar2_table(831) := '222C6572726F723A673F6C3A224E6F20636F6E76657273696F6E2066726F6D20222B692B2220746F20222B667D7D7D72657475726E7B73746174653A2273756363657373222C646174613A627D7D6E2E657874656E64287B6163746976653A302C6C6173';
wwv_flow_api.g_varchar2_table(832) := '744D6F6469666965643A7B7D2C657461673A7B7D2C616A617853657474696E67733A7B75726C3A41632C747970653A22474554222C69734C6F63616C3A45632E74657374287A635B315D292C676C6F62616C3A21302C70726F63657373446174613A2130';
wwv_flow_api.g_varchar2_table(833) := '2C6173796E633A21302C636F6E74656E74547970653A226170706C69636174696F6E2F782D7777772D666F726D2D75726C656E636F6465643B20636861727365743D5554462D38222C616363657074733A7B222A223A4B632C746578743A22746578742F';
wwv_flow_api.g_varchar2_table(834) := '706C61696E222C68746D6C3A22746578742F68746D6C222C786D6C3A226170706C69636174696F6E2F786D6C2C20746578742F786D6C222C6A736F6E3A226170706C69636174696F6E2F6A736F6E2C20746578742F6A617661736372697074227D2C636F';
wwv_flow_api.g_varchar2_table(835) := '6E74656E74733A7B786D6C3A2F786D6C2F2C68746D6C3A2F68746D6C2F2C6A736F6E3A2F6A736F6E2F7D2C726573706F6E73654669656C64733A7B786D6C3A22726573706F6E7365584D4C222C746578743A22726573706F6E736554657874222C6A736F';
wwv_flow_api.g_varchar2_table(836) := '6E3A22726573706F6E73654A534F4E227D2C636F6E766572746572733A7B222A2074657874223A537472696E672C22746578742068746D6C223A21302C2274657874206A736F6E223A6E2E70617273654A534F4E2C227465787420786D6C223A6E2E7061';
wwv_flow_api.g_varchar2_table(837) := '727365584D4C7D2C666C61744F7074696F6E733A7B75726C3A21302C636F6E746578743A21307D7D2C616A617853657475703A66756E6374696F6E28612C62297B72657475726E20623F4F63284F6328612C6E2E616A617853657474696E6773292C6229';
wwv_flow_api.g_varchar2_table(838) := '3A4F63286E2E616A617853657474696E67732C61297D2C616A617850726566696C7465723A4D63284963292C616A61785472616E73706F72743A4D63284A63292C616A61783A66756E6374696F6E28612C62297B226F626A656374223D3D747970656F66';
wwv_flow_api.g_varchar2_table(839) := '2061262628623D612C613D766F69642030292C623D627C7C7B7D3B76617220632C642C652C662C672C682C692C6A2C6B3D6E2E616A61785365747570287B7D2C62292C6C3D6B2E636F6E746578747C7C6B2C6D3D6B2E636F6E746578742626286C2E6E6F';
wwv_flow_api.g_varchar2_table(840) := '6465547970657C7C6C2E6A7175657279293F6E286C293A6E2E6576656E742C6F3D6E2E446566657272656428292C703D6E2E43616C6C6261636B7328226F6E6365206D656D6F727922292C713D6B2E737461747573436F64657C7C7B7D2C723D7B7D2C73';
wwv_flow_api.g_varchar2_table(841) := '3D7B7D2C743D302C753D2263616E63656C6564222C763D7B726561647953746174653A302C676574526573706F6E73654865616465723A66756E6374696F6E2861297B76617220623B696628323D3D3D74297B696628216A297B6A3D7B7D3B7768696C65';
wwv_flow_api.g_varchar2_table(842) := '28623D44632E65786563286629296A5B625B315D2E746F4C6F7765724361736528295D3D625B325D7D623D6A5B612E746F4C6F7765724361736528295D7D72657475726E206E756C6C3D3D623F6E756C6C3A627D2C676574416C6C526573706F6E736548';
wwv_flow_api.g_varchar2_table(843) := '6561646572733A66756E6374696F6E28297B72657475726E20323D3D3D743F663A6E756C6C7D2C736574526571756573744865616465723A66756E6374696F6E28612C62297B76617220633D612E746F4C6F7765724361736528293B72657475726E2074';
wwv_flow_api.g_varchar2_table(844) := '7C7C28613D735B635D3D735B635D7C7C612C725B615D3D62292C746869737D2C6F766572726964654D696D65547970653A66756E6374696F6E2861297B72657475726E20747C7C286B2E6D696D65547970653D61292C746869737D2C737461747573436F';
wwv_flow_api.g_varchar2_table(845) := '64653A66756E6374696F6E2861297B76617220623B6966286129696628323E7429666F72286220696E206129715B625D3D5B715B625D2C615B625D5D3B656C736520762E616C7761797328615B762E7374617475735D293B72657475726E20746869737D';
wwv_flow_api.g_varchar2_table(846) := '2C61626F72743A66756E6374696F6E2861297B76617220623D617C7C753B72657475726E20692626692E61626F72742862292C7828302C62292C746869737D7D3B6966286F2E70726F6D6973652876292E636F6D706C6574653D702E6164642C762E7375';
wwv_flow_api.g_varchar2_table(847) := '63636573733D762E646F6E652C762E6572726F723D762E6661696C2C6B2E75726C3D2828617C7C6B2E75726C7C7C4163292B2222292E7265706C6163652842632C2222292E7265706C6163652847632C7A635B315D2B222F2F22292C6B2E747970653D62';
wwv_flow_api.g_varchar2_table(848) := '2E6D6574686F647C7C622E747970657C7C6B2E6D6574686F647C7C6B2E747970652C6B2E6461746154797065733D6E2E7472696D286B2E64617461547970657C7C222A22292E746F4C6F7765724361736528292E6D617463682846297C7C5B22225D2C6E';
wwv_flow_api.g_varchar2_table(849) := '756C6C3D3D6B2E63726F7373446F6D61696E262628633D48632E65786563286B2E75726C2E746F4C6F776572436173652829292C6B2E63726F7373446F6D61696E3D212821637C7C635B315D3D3D3D7A635B315D2626635B325D3D3D3D7A635B325D2626';
wwv_flow_api.g_varchar2_table(850) := '28635B335D7C7C2822687474703A223D3D3D635B315D3F223830223A223434332229293D3D3D287A635B335D7C7C2822687474703A223D3D3D7A635B315D3F223830223A2234343322292929292C6B2E6461746126266B2E70726F636573734461746126';
wwv_flow_api.g_varchar2_table(851) := '2622737472696E6722213D747970656F66206B2E646174612626286B2E646174613D6E2E706172616D286B2E646174612C6B2E747261646974696F6E616C29292C4E632849632C6B2C622C76292C323D3D3D742972657475726E20763B683D6B2E676C6F';
wwv_flow_api.g_varchar2_table(852) := '62616C2C682626303D3D3D6E2E6163746976652B2B26266E2E6576656E742E747269676765722822616A6178537461727422292C6B2E747970653D6B2E747970652E746F55707065724361736528292C6B2E686173436F6E74656E743D2146632E746573';
wwv_flow_api.g_varchar2_table(853) := '74286B2E74797065292C653D6B2E75726C2C6B2E686173436F6E74656E747C7C286B2E64617461262628653D6B2E75726C2B3D2878632E746573742865293F2226223A223F22292B6B2E646174612C64656C657465206B2E64617461292C6B2E63616368';
wwv_flow_api.g_varchar2_table(854) := '653D3D3D21312626286B2E75726C3D43632E746573742865293F652E7265706C6163652843632C2224315F3D222B77632B2B293A652B2878632E746573742865293F2226223A223F22292B225F3D222B77632B2B29292C6B2E69664D6F64696669656426';
wwv_flow_api.g_varchar2_table(855) := '26286E2E6C6173744D6F6469666965645B655D2626762E73657452657175657374486561646572282249662D4D6F6469666965642D53696E6365222C6E2E6C6173744D6F6469666965645B655D292C6E2E657461675B655D2626762E7365745265717565';
wwv_flow_api.g_varchar2_table(856) := '7374486561646572282249662D4E6F6E652D4D61746368222C6E2E657461675B655D29292C286B2E6461746126266B2E686173436F6E74656E7426266B2E636F6E74656E7454797065213D3D21317C7C622E636F6E74656E7454797065292626762E7365';
wwv_flow_api.g_varchar2_table(857) := '74526571756573744865616465722822436F6E74656E742D54797065222C6B2E636F6E74656E7454797065292C762E736574526571756573744865616465722822416363657074222C6B2E6461746154797065735B305D26266B2E616363657074735B6B';
wwv_flow_api.g_varchar2_table(858) := '2E6461746154797065735B305D5D3F6B2E616363657074735B6B2E6461746154797065735B305D5D2B28222A22213D3D6B2E6461746154797065735B305D3F222C20222B4B632B223B20713D302E3031223A2222293A6B2E616363657074735B222A225D';
wwv_flow_api.g_varchar2_table(859) := '293B666F72286420696E206B2E6865616465727329762E7365745265717565737448656164657228642C6B2E686561646572735B645D293B6966286B2E6265666F726553656E642626286B2E6265666F726553656E642E63616C6C286C2C762C6B293D3D';
wwv_flow_api.g_varchar2_table(860) := '3D21317C7C323D3D3D74292972657475726E20762E61626F727428293B753D2261626F7274223B666F72286420696E7B737563636573733A312C6572726F723A312C636F6D706C6574653A317D29765B645D286B5B645D293B696628693D4E63284A632C';
wwv_flow_api.g_varchar2_table(861) := '6B2C622C7629297B762E726561647953746174653D312C6826266D2E747269676765722822616A617853656E64222C5B762C6B5D292C6B2E6173796E6326266B2E74696D656F75743E30262628673D73657454696D656F75742866756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(862) := '7B762E61626F7274282274696D656F757422297D2C6B2E74696D656F757429293B7472797B743D312C692E73656E6428722C78297D63617463682877297B6966282128323E7429297468726F7720773B78282D312C77297D7D656C73652078282D312C22';
wwv_flow_api.g_varchar2_table(863) := '4E6F205472616E73706F727422293B66756E6374696F6E207828612C622C632C64297B766172206A2C722C732C752C772C783D623B32213D3D74262628743D322C672626636C65617254696D656F75742867292C693D766F696420302C663D647C7C2222';
wwv_flow_api.g_varchar2_table(864) := '2C762E726561647953746174653D613E303F343A302C6A3D613E3D32303026263330303E617C7C3330343D3D3D612C63262628753D5063286B2C762C6329292C753D5163286B2C752C762C6A292C6A3F286B2E69664D6F646966696564262628773D762E';
wwv_flow_api.g_varchar2_table(865) := '676574526573706F6E736548656164657228224C6173742D4D6F64696669656422292C772626286E2E6C6173744D6F6469666965645B655D3D77292C773D762E676574526573706F6E736548656164657228226574616722292C772626286E2E65746167';
wwv_flow_api.g_varchar2_table(866) := '5B655D3D7729292C3230343D3D3D617C7C2248454144223D3D3D6B2E747970653F783D226E6F636F6E74656E74223A3330343D3D3D613F783D226E6F746D6F646966696564223A28783D752E73746174652C723D752E646174612C733D752E6572726F72';
wwv_flow_api.g_varchar2_table(867) := '2C6A3D217329293A28733D782C28617C7C217829262628783D226572726F72222C303E61262628613D302929292C762E7374617475733D612C762E737461747573546578743D28627C7C78292B22222C6A3F6F2E7265736F6C766557697468286C2C5B72';
wwv_flow_api.g_varchar2_table(868) := '2C782C765D293A6F2E72656A65637457697468286C2C5B762C782C735D292C762E737461747573436F64652871292C713D766F696420302C6826266D2E74726967676572286A3F22616A617853756363657373223A22616A61784572726F72222C5B762C';
wwv_flow_api.g_varchar2_table(869) := '6B2C6A3F723A735D292C702E6669726557697468286C2C5B762C785D292C682626286D2E747269676765722822616A6178436F6D706C657465222C5B762C6B5D292C2D2D6E2E6163746976657C7C6E2E6576656E742E747269676765722822616A617853';
wwv_flow_api.g_varchar2_table(870) := '746F70222929297D72657475726E20767D2C6765744A534F4E3A66756E6374696F6E28612C622C63297B72657475726E206E2E67657428612C622C632C226A736F6E22297D2C6765745363726970743A66756E6374696F6E28612C62297B72657475726E';
wwv_flow_api.g_varchar2_table(871) := '206E2E67657428612C766F696420302C622C2273637269707422297D7D292C6E2E65616368285B22676574222C22706F7374225D2C66756E6374696F6E28612C62297B6E5B625D3D66756E6374696F6E28612C632C642C65297B72657475726E206E2E69';
wwv_flow_api.g_varchar2_table(872) := '7346756E6374696F6E286329262628653D657C7C642C643D632C633D766F69642030292C6E2E616A6178287B75726C3A612C747970653A622C64617461547970653A652C646174613A632C737563636573733A647D297D7D292C6E2E65616368285B2261';
wwv_flow_api.g_varchar2_table(873) := '6A61785374617274222C22616A617853746F70222C22616A6178436F6D706C657465222C22616A61784572726F72222C22616A617853756363657373222C22616A617853656E64225D2C66756E6374696F6E28612C62297B6E2E666E5B625D3D66756E63';
wwv_flow_api.g_varchar2_table(874) := '74696F6E2861297B72657475726E20746869732E6F6E28622C61297D7D292C6E2E5F6576616C55726C3D66756E6374696F6E2861297B72657475726E206E2E616A6178287B75726C3A612C747970653A22474554222C64617461547970653A2273637269';
wwv_flow_api.g_varchar2_table(875) := '7074222C6173796E633A21312C676C6F62616C3A21312C227468726F7773223A21307D297D2C6E2E666E2E657874656E64287B77726170416C6C3A66756E6374696F6E2861297B6966286E2E697346756E6374696F6E2861292972657475726E20746869';
wwv_flow_api.g_varchar2_table(876) := '732E656163682866756E6374696F6E2862297B6E2874686973292E77726170416C6C28612E63616C6C28746869732C6229297D293B696628746869735B305D297B76617220623D6E28612C746869735B305D2E6F776E6572446F63756D656E74292E6571';
wwv_flow_api.g_varchar2_table(877) := '2830292E636C6F6E65282130293B746869735B305D2E706172656E744E6F64652626622E696E736572744265666F726528746869735B305D292C622E6D61702866756E6374696F6E28297B76617220613D746869733B7768696C6528612E666972737443';
wwv_flow_api.g_varchar2_table(878) := '68696C642626313D3D3D612E66697273744368696C642E6E6F64655479706529613D612E66697273744368696C643B72657475726E20617D292E617070656E642874686973297D72657475726E20746869737D2C77726170496E6E65723A66756E637469';
wwv_flow_api.g_varchar2_table(879) := '6F6E2861297B72657475726E20746869732E65616368286E2E697346756E6374696F6E2861293F66756E6374696F6E2862297B6E2874686973292E77726170496E6E657228612E63616C6C28746869732C6229297D3A66756E6374696F6E28297B766172';
wwv_flow_api.g_varchar2_table(880) := '20623D6E2874686973292C633D622E636F6E74656E747328293B632E6C656E6774683F632E77726170416C6C2861293A622E617070656E642861297D297D2C777261703A66756E6374696F6E2861297B76617220623D6E2E697346756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(881) := '293B72657475726E20746869732E656163682866756E6374696F6E2863297B6E2874686973292E77726170416C6C28623F612E63616C6C28746869732C63293A61297D297D2C756E777261703A66756E6374696F6E28297B72657475726E20746869732E';
wwv_flow_api.g_varchar2_table(882) := '706172656E7428292E656163682866756E6374696F6E28297B6E2E6E6F64654E616D6528746869732C22626F647922297C7C6E2874686973292E7265706C6163655769746828746869732E6368696C644E6F646573297D292E656E6428297D7D292C6E2E';
wwv_flow_api.g_varchar2_table(883) := '657870722E66696C746572732E68696464656E3D66756E6374696F6E2861297B72657475726E20612E6F666673657457696474683C3D302626612E6F66667365744865696768743C3D307C7C216C2E72656C6961626C6548696464656E4F666673657473';
wwv_flow_api.g_varchar2_table(884) := '28292626226E6F6E65223D3D3D28612E7374796C652626612E7374796C652E646973706C61797C7C6E2E63737328612C22646973706C61792229297D2C6E2E657870722E66696C746572732E76697369626C653D66756E6374696F6E2861297B72657475';
wwv_flow_api.g_varchar2_table(885) := '726E216E2E657870722E66696C746572732E68696464656E2861297D3B7661722052633D2F2532302F672C53633D2F5C5B5C5D242F2C54633D2F5C723F5C6E2F672C55633D2F5E283F3A7375626D69747C627574746F6E7C696D6167657C72657365747C';
wwv_flow_api.g_varchar2_table(886) := '66696C6529242F692C56633D2F5E283F3A696E7075747C73656C6563747C74657874617265617C6B657967656E292F693B66756E6374696F6E20576328612C622C632C64297B76617220653B6966286E2E69734172726179286229296E2E656163682862';
wwv_flow_api.g_varchar2_table(887) := '2C66756E6374696F6E28622C65297B637C7C53632E746573742861293F6428612C65293A576328612B225B222B28226F626A656374223D3D747970656F6620653F623A2222292B225D222C652C632C64297D293B656C736520696628637C7C226F626A65';
wwv_flow_api.g_varchar2_table(888) := '637422213D3D6E2E74797065286229296428612C62293B656C736520666F72286520696E206229576328612B225B222B652B225D222C625B655D2C632C64297D6E2E706172616D3D66756E6374696F6E28612C62297B76617220632C643D5B5D2C653D66';
wwv_flow_api.g_varchar2_table(889) := '756E6374696F6E28612C62297B623D6E2E697346756E6374696F6E2862293F6228293A6E756C6C3D3D623F22223A622C645B642E6C656E6774685D3D656E636F6465555249436F6D706F6E656E742861292B223D222B656E636F6465555249436F6D706F';
wwv_flow_api.g_varchar2_table(890) := '6E656E742862297D3B696628766F696420303D3D3D62262628623D6E2E616A617853657474696E677326266E2E616A617853657474696E67732E747261646974696F6E616C292C6E2E697341727261792861297C7C612E6A71756572792626216E2E6973';
wwv_flow_api.g_varchar2_table(891) := '506C61696E4F626A656374286129296E2E6561636828612C66756E6374696F6E28297B6528746869732E6E616D652C746869732E76616C7565297D293B656C736520666F72286320696E206129576328632C615B635D2C622C65293B72657475726E2064';
wwv_flow_api.g_varchar2_table(892) := '2E6A6F696E28222622292E7265706C6163652852632C222B22297D2C6E2E666E2E657874656E64287B73657269616C697A653A66756E6374696F6E28297B72657475726E206E2E706172616D28746869732E73657269616C697A6541727261792829297D';
wwv_flow_api.g_varchar2_table(893) := '2C73657269616C697A6541727261793A66756E6374696F6E28297B72657475726E20746869732E6D61702866756E6374696F6E28297B76617220613D6E2E70726F7028746869732C22656C656D656E747322293B72657475726E20613F6E2E6D616B6541';
wwv_flow_api.g_varchar2_table(894) := '727261792861293A746869737D292E66696C7465722866756E6374696F6E28297B76617220613D746869732E747970653B72657475726E20746869732E6E616D652626216E2874686973292E697328223A64697361626C65642229262656632E74657374';
wwv_flow_api.g_varchar2_table(895) := '28746869732E6E6F64654E616D652926262155632E74657374286129262628746869732E636865636B65647C7C21582E74657374286129297D292E6D61702866756E6374696F6E28612C62297B76617220633D6E2874686973292E76616C28293B726574';
wwv_flow_api.g_varchar2_table(896) := '75726E206E756C6C3D3D633F6E756C6C3A6E2E697341727261792863293F6E2E6D617028632C66756E6374696F6E2861297B72657475726E7B6E616D653A622E6E616D652C76616C75653A612E7265706C6163652854632C225C725C6E22297D7D293A7B';
wwv_flow_api.g_varchar2_table(897) := '6E616D653A622E6E616D652C76616C75653A632E7265706C6163652854632C225C725C6E22297D7D292E67657428297D7D292C6E2E616A617853657474696E67732E7868723D766F69642030213D3D612E416374697665584F626A6563743F66756E6374';
wwv_flow_api.g_varchar2_table(898) := '696F6E28297B72657475726E21746869732E69734C6F63616C26262F5E286765747C706F73747C686561647C7075747C64656C6574657C6F7074696F6E7329242F692E7465737428746869732E74797065292626246328297C7C5F6328297D3A24633B76';
wwv_flow_api.g_varchar2_table(899) := '61722058633D302C59633D7B7D2C5A633D6E2E616A617853657474696E67732E78687228293B612E416374697665584F626A65637426266E2861292E6F6E2822756E6C6F6164222C66756E6374696F6E28297B666F7228766172206120696E2059632959';
wwv_flow_api.g_varchar2_table(900) := '635B615D28766F696420302C2130297D292C6C2E636F72733D21215A632626227769746843726564656E7469616C7322696E205A632C5A633D6C2E616A61783D21215A632C5A6326266E2E616A61785472616E73706F72742866756E6374696F6E286129';
wwv_flow_api.g_varchar2_table(901) := '7B69662821612E63726F7373446F6D61696E7C7C6C2E636F7273297B76617220623B72657475726E7B73656E643A66756E6374696F6E28632C64297B76617220652C663D612E78687228292C673D2B2B58633B696628662E6F70656E28612E747970652C';
wwv_flow_api.g_varchar2_table(902) := '612E75726C2C612E6173796E632C612E757365726E616D652C612E70617373776F7264292C612E7868724669656C647329666F72286520696E20612E7868724669656C647329665B655D3D612E7868724669656C64735B655D3B612E6D696D6554797065';
wwv_flow_api.g_varchar2_table(903) := '2626662E6F766572726964654D696D65547970652626662E6F766572726964654D696D655479706528612E6D696D6554797065292C612E63726F7373446F6D61696E7C7C635B22582D5265717565737465642D57697468225D7C7C28635B22582D526571';
wwv_flow_api.g_varchar2_table(904) := '7565737465642D57697468225D3D22584D4C487474705265717565737422293B666F72286520696E206329766F69642030213D3D635B655D2626662E7365745265717565737448656164657228652C635B655D2B2222293B662E73656E6428612E686173';
wwv_flow_api.g_varchar2_table(905) := '436F6E74656E742626612E646174617C7C6E756C6C292C623D66756E6374696F6E28632C65297B76617220682C692C6A3B69662862262628657C7C343D3D3D662E72656164795374617465292969662864656C6574652059635B675D2C623D766F696420';
wwv_flow_api.g_varchar2_table(906) := '302C662E6F6E726561647973746174656368616E67653D6E2E6E6F6F702C652934213D3D662E726561647953746174652626662E61626F727428293B656C73657B6A3D7B7D2C683D662E7374617475732C22737472696E67223D3D747970656F6620662E';
wwv_flow_api.g_varchar2_table(907) := '726573706F6E7365546578742626286A2E746578743D662E726573706F6E736554657874293B7472797B693D662E737461747573546578747D6361746368286B297B693D22227D687C7C21612E69734C6F63616C7C7C612E63726F7373446F6D61696E3F';
wwv_flow_api.g_varchar2_table(908) := '313232333D3D3D68262628683D323034293A683D6A2E746578743F3230303A3430347D6A26266428682C692C6A2C662E676574416C6C526573706F6E7365486561646572732829297D2C612E6173796E633F343D3D3D662E726561647953746174653F73';
wwv_flow_api.g_varchar2_table(909) := '657454696D656F75742862293A662E6F6E726561647973746174656368616E67653D59635B675D3D623A6228297D2C61626F72743A66756E6374696F6E28297B6226266228766F696420302C2130297D7D7D7D293B66756E6374696F6E20246328297B74';
wwv_flow_api.g_varchar2_table(910) := '72797B72657475726E206E657720612E584D4C48747470526571756573747D63617463682862297B7D7D66756E6374696F6E205F6328297B7472797B72657475726E206E657720612E416374697665584F626A65637428224D6963726F736F66742E584D';
wwv_flow_api.g_varchar2_table(911) := '4C4854545022297D63617463682862297B7D7D6E2E616A61785365747570287B616363657074733A7B7363726970743A22746578742F6A6176617363726970742C206170706C69636174696F6E2F6A6176617363726970742C206170706C69636174696F';
wwv_flow_api.g_varchar2_table(912) := '6E2F65636D617363726970742C206170706C69636174696F6E2F782D65636D61736372697074227D2C636F6E74656E74733A7B7363726970743A2F283F3A6A6176617C65636D61297363726970742F7D2C636F6E766572746572733A7B22746578742073';
wwv_flow_api.g_varchar2_table(913) := '6372697074223A66756E6374696F6E2861297B72657475726E206E2E676C6F62616C4576616C2861292C617D7D7D292C6E2E616A617850726566696C7465722822736372697074222C66756E6374696F6E2861297B766F696420303D3D3D612E63616368';
wwv_flow_api.g_varchar2_table(914) := '65262628612E63616368653D2131292C612E63726F7373446F6D61696E262628612E747970653D22474554222C612E676C6F62616C3D2131297D292C6E2E616A61785472616E73706F72742822736372697074222C66756E6374696F6E2861297B696628';
wwv_flow_api.g_varchar2_table(915) := '612E63726F7373446F6D61696E297B76617220622C633D7A2E686561647C7C6E28226865616422295B305D7C7C7A2E646F63756D656E74456C656D656E743B72657475726E7B73656E643A66756E6374696F6E28642C65297B623D7A2E63726561746545';
wwv_flow_api.g_varchar2_table(916) := '6C656D656E74282273637269707422292C622E6173796E633D21302C612E73637269707443686172736574262628622E636861727365743D612E73637269707443686172736574292C622E7372633D612E75726C2C622E6F6E6C6F61643D622E6F6E7265';
wwv_flow_api.g_varchar2_table(917) := '61647973746174656368616E67653D66756E6374696F6E28612C63297B28637C7C21622E726561647953746174657C7C2F6C6F616465647C636F6D706C6574652F2E7465737428622E726561647953746174652929262628622E6F6E6C6F61643D622E6F';
wwv_flow_api.g_varchar2_table(918) := '6E726561647973746174656368616E67653D6E756C6C2C622E706172656E744E6F64652626622E706172656E744E6F64652E72656D6F76654368696C642862292C623D6E756C6C2C637C7C65283230302C22737563636573732229297D2C632E696E7365';
wwv_flow_api.g_varchar2_table(919) := '72744265666F726528622C632E66697273744368696C64297D2C61626F72743A66756E6374696F6E28297B622626622E6F6E6C6F616428766F696420302C2130297D7D7D7D293B7661722061643D5B5D2C62643D2F283D295C3F283F3D267C24297C5C3F';
wwv_flow_api.g_varchar2_table(920) := '5C3F2F3B6E2E616A61785365747570287B6A736F6E703A2263616C6C6261636B222C6A736F6E7043616C6C6261636B3A66756E6374696F6E28297B76617220613D61642E706F7028297C7C6E2E657870616E646F2B225F222B77632B2B3B72657475726E';
wwv_flow_api.g_varchar2_table(921) := '20746869735B615D3D21302C617D7D292C6E2E616A617850726566696C74657228226A736F6E206A736F6E70222C66756E6374696F6E28622C632C64297B76617220652C662C672C683D622E6A736F6E70213D3D213126262862642E7465737428622E75';
wwv_flow_api.g_varchar2_table(922) := '726C293F2275726C223A22737472696E67223D3D747970656F6620622E6461746126262128622E636F6E74656E74547970657C7C2222292E696E6465784F6628226170706C69636174696F6E2F782D7777772D666F726D2D75726C656E636F6465642229';
wwv_flow_api.g_varchar2_table(923) := '262662642E7465737428622E64617461292626226461746122293B72657475726E20687C7C226A736F6E70223D3D3D622E6461746154797065735B305D3F28653D622E6A736F6E7043616C6C6261636B3D6E2E697346756E6374696F6E28622E6A736F6E';
wwv_flow_api.g_varchar2_table(924) := '7043616C6C6261636B293F622E6A736F6E7043616C6C6261636B28293A622E6A736F6E7043616C6C6261636B2C683F625B685D3D625B685D2E7265706C6163652862642C222431222B65293A622E6A736F6E70213D3D2131262628622E75726C2B3D2878';
wwv_flow_api.g_varchar2_table(925) := '632E7465737428622E75726C293F2226223A223F22292B622E6A736F6E702B223D222B65292C622E636F6E766572746572735B22736372697074206A736F6E225D3D66756E6374696F6E28297B72657475726E20677C7C6E2E6572726F7228652B222077';
wwv_flow_api.g_varchar2_table(926) := '6173206E6F742063616C6C656422292C675B305D7D2C622E6461746154797065735B305D3D226A736F6E222C663D615B655D2C615B655D3D66756E6374696F6E28297B673D617267756D656E74737D2C642E616C776179732866756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(927) := '615B655D3D662C625B655D262628622E6A736F6E7043616C6C6261636B3D632E6A736F6E7043616C6C6261636B2C61642E70757368286529292C6726266E2E697346756E6374696F6E28662926266628675B305D292C673D663D766F696420307D292C22';
wwv_flow_api.g_varchar2_table(928) := '73637269707422293A766F696420307D292C6E2E706172736548544D4C3D66756E6374696F6E28612C622C63297B69662821617C7C22737472696E6722213D747970656F6620612972657475726E206E756C6C3B22626F6F6C65616E223D3D747970656F';
wwv_flow_api.g_varchar2_table(929) := '662062262628633D622C623D2131292C623D627C7C7A3B76617220643D762E657865632861292C653D216326265B5D3B72657475726E20643F5B622E637265617465456C656D656E7428645B315D295D3A28643D6E2E6275696C64467261676D656E7428';
wwv_flow_api.g_varchar2_table(930) := '5B615D2C622C65292C652626652E6C656E67746826266E2865292E72656D6F766528292C6E2E6D65726765285B5D2C642E6368696C644E6F64657329297D3B7661722063643D6E2E666E2E6C6F61643B6E2E666E2E6C6F61643D66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(931) := '2C622C63297B69662822737472696E6722213D747970656F662061262663642972657475726E2063642E6170706C7928746869732C617267756D656E7473293B76617220642C652C662C673D746869732C683D612E696E6465784F6628222022293B7265';
wwv_flow_api.g_varchar2_table(932) := '7475726E20683E3D30262628643D612E736C69636528682C612E6C656E677468292C613D612E736C69636528302C6829292C6E2E697346756E6374696F6E2862293F28633D622C623D766F69642030293A622626226F626A656374223D3D747970656F66';
wwv_flow_api.g_varchar2_table(933) := '2062262628663D22504F535422292C672E6C656E6774683E3026266E2E616A6178287B75726C3A612C747970653A662C64617461547970653A2268746D6C222C646174613A627D292E646F6E652866756E6374696F6E2861297B653D617267756D656E74';
wwv_flow_api.g_varchar2_table(934) := '732C672E68746D6C28643F6E28223C6469763E22292E617070656E64286E2E706172736548544D4C286129292E66696E642864293A61297D292E636F6D706C6574652863262666756E6374696F6E28612C62297B672E6561636828632C657C7C5B612E72';
wwv_flow_api.g_varchar2_table(935) := '6573706F6E7365546578742C622C615D297D292C746869737D2C6E2E657870722E66696C746572732E616E696D617465643D66756E6374696F6E2861297B72657475726E206E2E67726570286E2E74696D6572732C66756E6374696F6E2862297B726574';
wwv_flow_api.g_varchar2_table(936) := '75726E20613D3D3D622E656C656D7D292E6C656E6774687D3B7661722064643D612E646F63756D656E742E646F63756D656E74456C656D656E743B66756E6374696F6E2065642861297B72657475726E206E2E697357696E646F772861293F613A393D3D';
wwv_flow_api.g_varchar2_table(937) := '3D612E6E6F6465547970653F612E64656661756C74566965777C7C612E706172656E7457696E646F773A21317D6E2E6F66667365743D7B7365744F66667365743A66756E6374696F6E28612C622C63297B76617220642C652C662C672C682C692C6A2C6B';
wwv_flow_api.g_varchar2_table(938) := '3D6E2E63737328612C22706F736974696F6E22292C6C3D6E2861292C6D3D7B7D3B22737461746963223D3D3D6B262628612E7374796C652E706F736974696F6E3D2272656C617469766522292C683D6C2E6F666673657428292C663D6E2E63737328612C';
wwv_flow_api.g_varchar2_table(939) := '22746F7022292C693D6E2E63737328612C226C65667422292C6A3D28226162736F6C757465223D3D3D6B7C7C226669786564223D3D3D6B2926266E2E696E417272617928226175746F222C5B662C695D293E2D312C6A3F28643D6C2E706F736974696F6E';
wwv_flow_api.g_varchar2_table(940) := '28292C673D642E746F702C653D642E6C656674293A28673D7061727365466C6F61742866297C7C302C653D7061727365466C6F61742869297C7C30292C6E2E697346756E6374696F6E286229262628623D622E63616C6C28612C632C6829292C6E756C6C';
wwv_flow_api.g_varchar2_table(941) := '213D622E746F702626286D2E746F703D622E746F702D682E746F702B67292C6E756C6C213D622E6C6566742626286D2E6C6566743D622E6C6566742D682E6C6566742B65292C227573696E6722696E20623F622E7573696E672E63616C6C28612C6D293A';
wwv_flow_api.g_varchar2_table(942) := '6C2E637373286D297D7D2C6E2E666E2E657874656E64287B6F66667365743A66756E6374696F6E2861297B696628617267756D656E74732E6C656E6774682972657475726E20766F696420303D3D3D613F746869733A746869732E656163682866756E63';
wwv_flow_api.g_varchar2_table(943) := '74696F6E2862297B6E2E6F66667365742E7365744F666673657428746869732C612C62297D293B76617220622C632C643D7B746F703A302C6C6566743A307D2C653D746869735B305D2C663D652626652E6F776E6572446F63756D656E743B6966286629';
wwv_flow_api.g_varchar2_table(944) := '72657475726E20623D662E646F63756D656E74456C656D656E742C6E2E636F6E7461696E7328622C65293F28747970656F6620652E676574426F756E64696E67436C69656E7452656374213D3D4C262628643D652E676574426F756E64696E67436C6965';
wwv_flow_api.g_varchar2_table(945) := '6E74526563742829292C633D65642866292C7B746F703A642E746F702B28632E70616765594F66667365747C7C622E7363726F6C6C546F70292D28622E636C69656E74546F707C7C30292C6C6566743A642E6C6566742B28632E70616765584F66667365';
wwv_flow_api.g_varchar2_table(946) := '747C7C622E7363726F6C6C4C656674292D28622E636C69656E744C6566747C7C30297D293A647D2C706F736974696F6E3A66756E6374696F6E28297B696628746869735B305D297B76617220612C622C633D7B746F703A302C6C6566743A307D2C643D74';
wwv_flow_api.g_varchar2_table(947) := '6869735B305D3B72657475726E226669786564223D3D3D6E2E63737328642C22706F736974696F6E22293F623D642E676574426F756E64696E67436C69656E745265637428293A28613D746869732E6F6666736574506172656E7428292C623D74686973';
wwv_flow_api.g_varchar2_table(948) := '2E6F666673657428292C6E2E6E6F64654E616D6528615B305D2C2268746D6C22297C7C28633D612E6F66667365742829292C632E746F702B3D6E2E63737328615B305D2C22626F72646572546F705769647468222C2130292C632E6C6566742B3D6E2E63';
wwv_flow_api.g_varchar2_table(949) := '737328615B305D2C22626F726465724C6566745769647468222C213029292C7B746F703A622E746F702D632E746F702D6E2E63737328642C226D617267696E546F70222C2130292C6C6566743A622E6C6566742D632E6C6566742D6E2E63737328642C22';
wwv_flow_api.g_varchar2_table(950) := '6D617267696E4C656674222C2130297D7D7D2C6F6666736574506172656E743A66756E6374696F6E28297B72657475726E20746869732E6D61702866756E6374696F6E28297B76617220613D746869732E6F6666736574506172656E747C7C64643B7768';
wwv_flow_api.g_varchar2_table(951) := '696C6528612626216E2E6E6F64654E616D6528612C2268746D6C2229262622737461746963223D3D3D6E2E63737328612C22706F736974696F6E222929613D612E6F6666736574506172656E743B72657475726E20617C7C64647D297D7D292C6E2E6561';
wwv_flow_api.g_varchar2_table(952) := '6368287B7363726F6C6C4C6566743A2270616765584F6666736574222C7363726F6C6C546F703A2270616765594F6666736574227D2C66756E6374696F6E28612C62297B76617220633D2F592F2E746573742862293B6E2E666E5B615D3D66756E637469';
wwv_flow_api.g_varchar2_table(953) := '6F6E2864297B72657475726E205728746869732C66756E6374696F6E28612C642C65297B76617220663D65642861293B72657475726E20766F696420303D3D3D653F663F6220696E20663F665B625D3A662E646F63756D656E742E646F63756D656E7445';
wwv_flow_api.g_varchar2_table(954) := '6C656D656E745B645D3A615B645D3A766F696428663F662E7363726F6C6C546F28633F6E2866292E7363726F6C6C4C65667428293A652C633F653A6E2866292E7363726F6C6C546F702829293A615B645D3D65297D2C612C642C617267756D656E74732E';
wwv_flow_api.g_varchar2_table(955) := '6C656E6774682C6E756C6C297D7D292C6E2E65616368285B22746F70222C226C656674225D2C66756E6374696F6E28612C62297B6E2E637373486F6F6B735B625D3D4D62286C2E706978656C506F736974696F6E2C66756E6374696F6E28612C63297B72';
wwv_flow_api.g_varchar2_table(956) := '657475726E20633F28633D4B6228612C62292C49622E746573742863293F6E2861292E706F736974696F6E28295B625D2B227078223A63293A766F696420307D297D292C6E2E65616368287B4865696768743A22686569676874222C57696474683A2277';
wwv_flow_api.g_varchar2_table(957) := '69647468227D2C66756E6374696F6E28612C62297B6E2E65616368287B70616464696E673A22696E6E6572222B612C636F6E74656E743A622C22223A226F75746572222B617D2C66756E6374696F6E28632C64297B6E2E666E5B645D3D66756E6374696F';
wwv_flow_api.g_varchar2_table(958) := '6E28642C65297B76617220663D617267756D656E74732E6C656E677468262628637C7C22626F6F6C65616E22213D747970656F662064292C673D637C7C28643D3D3D21307C7C653D3D3D21303F226D617267696E223A22626F7264657222293B72657475';
wwv_flow_api.g_varchar2_table(959) := '726E205728746869732C66756E6374696F6E28622C632C64297B76617220653B72657475726E206E2E697357696E646F772862293F622E646F63756D656E742E646F63756D656E74456C656D656E745B22636C69656E74222B615D3A393D3D3D622E6E6F';
wwv_flow_api.g_varchar2_table(960) := '6465547970653F28653D622E646F63756D656E74456C656D656E742C4D6174682E6D617828622E626F64795B227363726F6C6C222B615D2C655B227363726F6C6C222B615D2C622E626F64795B226F6666736574222B615D2C655B226F6666736574222B';
wwv_flow_api.g_varchar2_table(961) := '615D2C655B22636C69656E74222B615D29293A766F696420303D3D3D643F6E2E63737328622C632C67293A6E2E7374796C6528622C632C642C67297D2C622C663F643A766F696420302C662C6E756C6C297D7D297D292C6E2E666E2E73697A653D66756E';
wwv_flow_api.g_varchar2_table(962) := '6374696F6E28297B72657475726E20746869732E6C656E6774687D2C6E2E666E2E616E6453656C663D6E2E666E2E6164644261636B2C2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D642626646566696E6528';
wwv_flow_api.g_varchar2_table(963) := '226A7175657279222C5B5D2C66756E6374696F6E28297B72657475726E206E7D293B7661722066643D612E6A51756572792C67643D612E243B72657475726E206E2E6E6F436F6E666C6963743D66756E6374696F6E2862297B72657475726E20612E243D';
wwv_flow_api.g_varchar2_table(964) := '3D3D6E262628612E243D6764292C622626612E6A51756572793D3D3D6E262628612E6A51756572793D6664292C6E7D2C747970656F6620623D3D3D4C262628612E6A51756572793D612E243D6E292C6E7D293B0D0A0D0A766172206A517565727950414C';
wwv_flow_api.g_varchar2_table(965) := '203D206A51756572792E6E6F436F6E666C6963742874727565293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(62256112038550713)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'jquery1.11.js'
,p_mime_type=>'application/javascript'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A210A202A20426F6F7473747261702076332E312E312028687474703A2F2F676574626F6F7473747261702E636F6D290A202A20436F7079726967687420323031312D3230313420547769747465722C20496E632E0A202A204C6963656E7365642075';
wwv_flow_api.g_varchar2_table(2) := '6E646572204D4954202868747470733A2F2F6769746875622E636F6D2F747762732F626F6F7473747261702F626C6F622F6D61737465722F4C4943454E5345290A202A2F0A2866756E6374696F6E286A5175657279297B0A2B66756E6374696F6E286129';
wwv_flow_api.g_varchar2_table(3) := '7B2275736520737472696374223B76617220623D66756E6374696F6E28612C62297B746869732E747970653D746869732E6F7074696F6E733D746869732E656E61626C65643D746869732E74696D656F75743D746869732E686F76657253746174653D74';
wwv_flow_api.g_varchar2_table(4) := '6869732E24656C656D656E743D6E756C6C2C746869732E696E69742822746F6F6C746970222C612C62297D3B622E44454641554C54533D7B616E696D6174696F6E3A21302C706C6163656D656E743A22746F70222C73656C6563746F723A21312C74656D';
wwv_flow_api.g_varchar2_table(5) := '706C6174653A273C64697620636C6173733D22746F6F6C746970223E3C64697620636C6173733D22746F6F6C7469702D6172726F77223E3C2F6469763E3C64697620636C6173733D22746F6F6C7469702D696E6E6572223E3C2F6469763E3C2F6469763E';
wwv_flow_api.g_varchar2_table(6) := '272C747269676765723A22686F76657220666F637573222C7469746C653A22222C64656C61793A302C68746D6C3A21312C636F6E7461696E65723A21317D2C622E70726F746F747970652E696E69743D66756E6374696F6E28622C632C64297B74686973';
wwv_flow_api.g_varchar2_table(7) := '2E656E61626C65643D21302C746869732E747970653D622C746869732E24656C656D656E743D612863292C746869732E6F7074696F6E733D746869732E6765744F7074696F6E732864293B76617220653D746869732E6F7074696F6E732E747269676765';
wwv_flow_api.g_varchar2_table(8) := '722E73706C697428222022293B666F722876617220663D652E6C656E6774683B662D2D3B297B76617220673D655B665D3B696628673D3D22636C69636B2229746869732E24656C656D656E742E6F6E2822636C69636B2E222B746869732E747970652C74';
wwv_flow_api.g_varchar2_table(9) := '6869732E6F7074696F6E732E73656C6563746F722C612E70726F787928746869732E746F67676C652C7468697329293B656C73652069662867213D226D616E75616C22297B76617220683D673D3D22686F766572223F226D6F757365656E746572223A22';
wwv_flow_api.g_varchar2_table(10) := '666F637573696E222C693D673D3D22686F766572223F226D6F7573656C65617665223A22666F6375736F7574223B746869732E24656C656D656E742E6F6E28682B222E222B746869732E747970652C746869732E6F7074696F6E732E73656C6563746F72';
wwv_flow_api.g_varchar2_table(11) := '2C612E70726F787928746869732E656E7465722C7468697329292C746869732E24656C656D656E742E6F6E28692B222E222B746869732E747970652C746869732E6F7074696F6E732E73656C6563746F722C612E70726F787928746869732E6C65617665';
wwv_flow_api.g_varchar2_table(12) := '2C7468697329297D7D746869732E6F7074696F6E732E73656C6563746F723F746869732E5F6F7074696F6E733D612E657874656E64287B7D2C746869732E6F7074696F6E732C7B747269676765723A226D616E75616C222C73656C6563746F723A22227D';
wwv_flow_api.g_varchar2_table(13) := '293A746869732E6669785469746C6528297D2C622E70726F746F747970652E67657444656661756C74733D66756E6374696F6E28297B72657475726E20622E44454641554C54537D2C622E70726F746F747970652E6765744F7074696F6E733D66756E63';
wwv_flow_api.g_varchar2_table(14) := '74696F6E2862297B72657475726E20623D612E657874656E64287B7D2C746869732E67657444656661756C747328292C746869732E24656C656D656E742E6461746128292C62292C622E64656C61792626747970656F6620622E64656C61793D3D226E75';
wwv_flow_api.g_varchar2_table(15) := '6D62657222262628622E64656C61793D7B73686F773A622E64656C61792C686964653A622E64656C61797D292C627D2C622E70726F746F747970652E67657444656C65676174654F7074696F6E733D66756E6374696F6E28297B76617220623D7B7D2C63';
wwv_flow_api.g_varchar2_table(16) := '3D746869732E67657444656661756C747328293B72657475726E20746869732E5F6F7074696F6E732626612E6561636828746869732E5F6F7074696F6E732C66756E6374696F6E28612C64297B635B615D213D64262628625B615D3D64297D292C627D2C';
wwv_flow_api.g_varchar2_table(17) := '622E70726F746F747970652E656E7465723D66756E6374696F6E2862297B76617220633D6220696E7374616E63656F6620746869732E636F6E7374727563746F723F623A6128622E63757272656E74546172676574295B746869732E747970655D287468';
wwv_flow_api.g_varchar2_table(18) := '69732E67657444656C65676174654F7074696F6E732829292E64617461282262732E222B746869732E74797065293B636C65617254696D656F757428632E74696D656F7574292C632E686F76657253746174653D22696E223B69662821632E6F7074696F';
wwv_flow_api.g_varchar2_table(19) := '6E732E64656C61797C7C21632E6F7074696F6E732E64656C61792E73686F772972657475726E20632E73686F7728293B632E74696D656F75743D73657454696D656F75742866756E6374696F6E28297B632E686F76657253746174653D3D22696E222626';
wwv_flow_api.g_varchar2_table(20) := '632E73686F7728297D2C632E6F7074696F6E732E64656C61792E73686F77297D2C622E70726F746F747970652E6C656176653D66756E6374696F6E2862297B76617220633D6220696E7374616E63656F6620746869732E636F6E7374727563746F723F62';
wwv_flow_api.g_varchar2_table(21) := '3A6128622E63757272656E74546172676574295B746869732E747970655D28746869732E67657444656C65676174654F7074696F6E732829292E64617461282262732E222B746869732E74797065293B636C65617254696D656F757428632E74696D656F';
wwv_flow_api.g_varchar2_table(22) := '7574292C632E686F76657253746174653D226F7574223B69662821632E6F7074696F6E732E64656C61797C7C21632E6F7074696F6E732E64656C61792E686964652972657475726E20632E6869646528293B632E74696D656F75743D73657454696D656F';
wwv_flow_api.g_varchar2_table(23) := '75742866756E6374696F6E28297B632E686F76657253746174653D3D226F7574222626632E6869646528297D2C632E6F7074696F6E732E64656C61792E68696465297D2C622E70726F746F747970652E73686F773D66756E6374696F6E28297B76617220';
wwv_flow_api.g_varchar2_table(24) := '623D612E4576656E74282273686F772E62732E222B746869732E74797065293B696628746869732E686173436F6E74656E7428292626746869732E656E61626C6564297B746869732E24656C656D656E742E747269676765722862293B696628622E6973';
wwv_flow_api.g_varchar2_table(25) := '44656661756C7450726576656E74656428292972657475726E3B76617220633D746869732C643D746869732E74697028293B746869732E736574436F6E74656E7428292C746869732E6F7074696F6E732E616E696D6174696F6E2626642E616464436C61';
wwv_flow_api.g_varchar2_table(26) := '737328226661646522293B76617220653D747970656F6620746869732E6F7074696F6E732E706C6163656D656E743D3D2266756E6374696F6E223F746869732E6F7074696F6E732E706C6163656D656E742E63616C6C28746869732C645B305D2C746869';
wwv_flow_api.g_varchar2_table(27) := '732E24656C656D656E745B305D293A746869732E6F7074696F6E732E706C6163656D656E742C663D2F5C733F6175746F3F5C733F2F692C673D662E746573742865293B67262628653D652E7265706C61636528662C2222297C7C22746F7022292C642E64';
wwv_flow_api.g_varchar2_table(28) := '657461636828292E637373287B746F703A302C6C6566743A302C646973706C61793A22626C6F636B227D292E616464436C6173732865292C746869732E6F7074696F6E732E636F6E7461696E65723F642E617070656E64546F28746869732E6F7074696F';
wwv_flow_api.g_varchar2_table(29) := '6E732E636F6E7461696E6572293A642E696E73657274416674657228746869732E24656C656D656E74293B76617220683D746869732E676574506F736974696F6E28292C693D645B305D2E6F666673657457696474682C6A3D645B305D2E6F6666736574';
wwv_flow_api.g_varchar2_table(30) := '4865696768743B69662867297B766172206B3D746869732E24656C656D656E742E706172656E7428292C6C3D652C6D3D646F63756D656E742E646F63756D656E74456C656D656E742E7363726F6C6C546F707C7C646F63756D656E742E626F64792E7363';
wwv_flow_api.g_varchar2_table(31) := '726F6C6C546F702C6E3D746869732E6F7074696F6E732E636F6E7461696E65723D3D22626F6479223F77696E646F772E696E6E657257696474683A6B2E6F75746572576964746828292C6F3D746869732E6F7074696F6E732E636F6E7461696E65723D3D';
wwv_flow_api.g_varchar2_table(32) := '22626F6479223F77696E646F772E696E6E65724865696768743A6B2E6F7574657248656967687428292C703D746869732E6F7074696F6E732E636F6E7461696E65723D3D22626F6479223F303A6B2E6F666673657428292E6C6566743B653D653D3D2262';
wwv_flow_api.g_varchar2_table(33) := '6F74746F6D222626682E746F702B682E6865696768742B6A2D6D3E6F3F22746F70223A653D3D22746F70222626682E746F702D6D2D6A3C303F22626F74746F6D223A653D3D227269676874222626682E72696768742B693E6E3F226C656674223A653D3D';
wwv_flow_api.g_varchar2_table(34) := '226C656674222626682E6C6566742D693C703F227269676874223A652C642E72656D6F7665436C617373286C292E616464436C6173732865297D76617220713D746869732E67657443616C63756C617465644F666673657428652C682C692C6A293B7468';
wwv_flow_api.g_varchar2_table(35) := '69732E6170706C79506C6163656D656E7428712C65292C746869732E686F76657253746174653D6E756C6C3B76617220723D66756E6374696F6E28297B632E24656C656D656E742E74726967676572282273686F776E2E62732E222B632E74797065297D';
wwv_flow_api.g_varchar2_table(36) := '3B612E737570706F72742E7472616E736974696F6E2626746869732E247469702E686173436C61737328226661646522293F642E6F6E6528612E737570706F72742E7472616E736974696F6E2E656E642C72292E656D756C6174655472616E736974696F';
wwv_flow_api.g_varchar2_table(37) := '6E456E6428313530293A7228297D7D2C622E70726F746F747970652E6170706C79506C6163656D656E743D66756E6374696F6E28622C63297B76617220642C653D746869732E74697028292C663D655B305D2E6F666673657457696474682C673D655B30';
wwv_flow_api.g_varchar2_table(38) := '5D2E6F66667365744865696768742C683D7061727365496E7428652E63737328226D617267696E2D746F7022292C3130292C693D7061727365496E7428652E63737328226D617267696E2D6C65667422292C3130293B69734E614E286829262628683D30';
wwv_flow_api.g_varchar2_table(39) := '292C69734E614E286929262628693D30292C622E746F703D622E746F702B682C622E6C6566743D622E6C6566742B692C612E6F66667365742E7365744F666673657428655B305D2C612E657874656E64287B7573696E673A66756E6374696F6E2861297B';
wwv_flow_api.g_varchar2_table(40) := '652E637373287B746F703A4D6174682E726F756E6428612E746F70292C6C6566743A4D6174682E726F756E6428612E6C656674297D297D7D2C62292C30292C652E616464436C6173732822696E22293B766172206A3D655B305D2E6F6666736574576964';
wwv_flow_api.g_varchar2_table(41) := '74682C6B3D655B305D2E6F66667365744865696768743B633D3D22746F702226266B213D67262628643D21302C622E746F703D622E746F702B672D6B293B6966282F626F74746F6D7C746F702F2E74657374286329297B766172206C3D303B622E6C6566';
wwv_flow_api.g_varchar2_table(42) := '743C302626286C3D622E6C6566742A2D322C622E6C6566743D302C652E6F66667365742862292C6A3D655B305D2E6F666673657457696474682C6B3D655B305D2E6F6666736574486569676874292C746869732E7265706C6163654172726F77286C2D66';
wwv_flow_api.g_varchar2_table(43) := '2B6A2C6A2C226C65667422297D656C736520746869732E7265706C6163654172726F77286B2D672C6B2C22746F7022293B642626652E6F66667365742862297D2C622E70726F746F747970652E7265706C6163654172726F773D66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(44) := '2C622C63297B746869732E6172726F7728292E63737328632C613F35302A28312D612F62292B2225223A2222297D2C622E70726F746F747970652E736574436F6E74656E743D66756E6374696F6E28297B76617220613D746869732E74697028292C623D';
wwv_flow_api.g_varchar2_table(45) := '746869732E6765745469746C6528293B612E66696E6428222E746F6F6C7469702D696E6E657222295B746869732E6F7074696F6E732E68746D6C3F2268746D6C223A2274657874225D2862292C612E72656D6F7665436C61737328226661646520696E20';
wwv_flow_api.g_varchar2_table(46) := '746F7020626F74746F6D206C65667420726967687422297D2C622E70726F746F747970652E686964653D66756E6374696F6E28297B66756E6374696F6E206528297B622E686F7665725374617465213D22696E222626632E64657461636828292C622E24';
wwv_flow_api.g_varchar2_table(47) := '656C656D656E742E74726967676572282268696464656E2E62732E222B622E74797065297D76617220623D746869732C633D746869732E74697028292C643D612E4576656E742822686964652E62732E222B746869732E74797065293B746869732E2465';
wwv_flow_api.g_varchar2_table(48) := '6C656D656E742E747269676765722864293B696628642E697344656661756C7450726576656E74656428292972657475726E3B72657475726E20632E72656D6F7665436C6173732822696E22292C612E737570706F72742E7472616E736974696F6E2626';
wwv_flow_api.g_varchar2_table(49) := '746869732E247469702E686173436C61737328226661646522293F632E6F6E6528612E737570706F72742E7472616E736974696F6E2E656E642C65292E656D756C6174655472616E736974696F6E456E6428313530293A6528292C746869732E686F7665';
wwv_flow_api.g_varchar2_table(50) := '7253746174653D6E756C6C2C746869737D2C622E70726F746F747970652E6669785469746C653D66756E6374696F6E28297B76617220613D746869732E24656C656D656E743B28612E6174747228227469746C6522297C7C747970656F6620612E617474';
wwv_flow_api.g_varchar2_table(51) := '722822646174612D6F726967696E616C2D7469746C652229213D22737472696E6722292626612E617474722822646174612D6F726967696E616C2D7469746C65222C612E6174747228227469746C6522297C7C2222292E6174747228227469746C65222C';
wwv_flow_api.g_varchar2_table(52) := '2222297D2C622E70726F746F747970652E686173436F6E74656E743D66756E6374696F6E28297B72657475726E20746869732E6765745469746C6528297D2C622E70726F746F747970652E676574506F736974696F6E3D66756E6374696F6E28297B7661';
wwv_flow_api.g_varchar2_table(53) := '7220623D746869732E24656C656D656E745B305D3B72657475726E20612E657874656E64287B7D2C747970656F6620622E676574426F756E64696E67436C69656E74526563743D3D2266756E6374696F6E223F622E676574426F756E64696E67436C6965';
wwv_flow_api.g_varchar2_table(54) := '6E745265637428293A7B77696474683A622E6F666673657457696474682C6865696768743A622E6F66667365744865696768747D2C746869732E24656C656D656E742E6F66667365742829297D2C622E70726F746F747970652E67657443616C63756C61';
wwv_flow_api.g_varchar2_table(55) := '7465644F66667365743D66756E6374696F6E28612C622C632C64297B72657475726E20613D3D22626F74746F6D223F7B746F703A622E746F702B622E6865696768742C6C6566743A622E6C6566742B622E77696474682F322D632F327D3A613D3D22746F';
wwv_flow_api.g_varchar2_table(56) := '70223F7B746F703A622E746F702D642C6C6566743A622E6C6566742B622E77696474682F322D632F327D3A613D3D226C656674223F7B746F703A622E746F702B622E6865696768742F322D642F322C6C6566743A622E6C6566742D637D3A7B746F703A62';
wwv_flow_api.g_varchar2_table(57) := '2E746F702B622E6865696768742F322D642F322C6C6566743A622E6C6566742B622E77696474687D7D2C622E70726F746F747970652E6765745469746C653D66756E6374696F6E28297B76617220612C623D746869732E24656C656D656E742C633D7468';
wwv_flow_api.g_varchar2_table(58) := '69732E6F7074696F6E733B72657475726E20613D622E617474722822646174612D6F726967696E616C2D7469746C6522297C7C28747970656F6620632E7469746C653D3D2266756E6374696F6E223F632E7469746C652E63616C6C28625B305D293A632E';
wwv_flow_api.g_varchar2_table(59) := '7469746C65292C617D2C622E70726F746F747970652E7469703D66756E6374696F6E28297B72657475726E20746869732E247469703D746869732E247469707C7C6128746869732E6F7074696F6E732E74656D706C617465297D2C622E70726F746F7479';
wwv_flow_api.g_varchar2_table(60) := '70652E6172726F773D66756E6374696F6E28297B72657475726E20746869732E246172726F773D746869732E246172726F777C7C746869732E74697028292E66696E6428222E746F6F6C7469702D6172726F7722297D2C622E70726F746F747970652E76';
wwv_flow_api.g_varchar2_table(61) := '616C69646174653D66756E6374696F6E28297B746869732E24656C656D656E745B305D2E706172656E744E6F64657C7C28746869732E6869646528292C746869732E24656C656D656E743D6E756C6C2C746869732E6F7074696F6E733D6E756C6C297D2C';
wwv_flow_api.g_varchar2_table(62) := '622E70726F746F747970652E656E61626C653D66756E6374696F6E28297B746869732E656E61626C65643D21307D2C622E70726F746F747970652E64697361626C653D66756E6374696F6E28297B746869732E656E61626C65643D21317D2C622E70726F';
wwv_flow_api.g_varchar2_table(63) := '746F747970652E746F67676C65456E61626C65643D66756E6374696F6E28297B746869732E656E61626C65643D21746869732E656E61626C65647D2C622E70726F746F747970652E746F67676C653D66756E6374696F6E2862297B76617220633D623F61';
wwv_flow_api.g_varchar2_table(64) := '28622E63757272656E74546172676574295B746869732E747970655D28746869732E67657444656C65676174654F7074696F6E732829292E64617461282262732E222B746869732E74797065293A746869733B632E74697028292E686173436C61737328';
wwv_flow_api.g_varchar2_table(65) := '22696E22293F632E6C656176652863293A632E656E7465722863297D2C622E70726F746F747970652E64657374726F793D66756E6374696F6E28297B636C65617254696D656F757428746869732E74696D656F7574292C746869732E6869646528292E24';
wwv_flow_api.g_varchar2_table(66) := '656C656D656E742E6F666628222E222B746869732E74797065292E72656D6F766544617461282262732E222B746869732E74797065297D3B76617220633D612E666E2E746F6F6C7469703B612E666E2E746F6F6C7469703D66756E6374696F6E2863297B';
wwv_flow_api.g_varchar2_table(67) := '72657475726E20746869732E656163682866756E6374696F6E28297B76617220643D612874686973292C653D642E64617461282262732E746F6F6C74697022292C663D747970656F6620633D3D226F626A656374222626633B69662821652626633D3D22';
wwv_flow_api.g_varchar2_table(68) := '64657374726F79222972657475726E3B657C7C642E64617461282262732E746F6F6C746970222C653D6E6577206228746869732C6629292C747970656F6620633D3D22737472696E67222626655B635D28297D297D2C612E666E2E746F6F6C7469702E43';
wwv_flow_api.g_varchar2_table(69) := '6F6E7374727563746F723D622C612E666E2E746F6F6C7469702E6E6F436F6E666C6963743D66756E6374696F6E28297B72657475726E20612E666E2E746F6F6C7469703D632C746869737D7D286A5175657279292C2B66756E6374696F6E2861297B2275';
wwv_flow_api.g_varchar2_table(70) := '736520737472696374223B76617220623D66756E6374696F6E28612C62297B746869732E696E69742822706F706F766572222C612C62297D3B69662821612E666E2E746F6F6C746970297468726F77206E6577204572726F722822506F706F7665722072';
wwv_flow_api.g_varchar2_table(71) := '6571756972657320746F6F6C7469702E6A7322293B622E44454641554C54533D612E657874656E64287B7D2C612E666E2E746F6F6C7469702E436F6E7374727563746F722E44454641554C54532C7B706C6163656D656E743A227269676874222C747269';
wwv_flow_api.g_varchar2_table(72) := '676765723A22636C69636B222C636F6E74656E743A22222C74656D706C6174653A273C64697620636C6173733D22706F706F766572223E3C64697620636C6173733D226172726F77223E3C2F6469763E3C683320636C6173733D22706F706F7665722D74';
wwv_flow_api.g_varchar2_table(73) := '69746C65223E3C2F68333E3C64697620636C6173733D22706F706F7665722D636F6E74656E74223E3C2F6469763E3C2F6469763E277D292C622E70726F746F747970653D612E657874656E64287B7D2C612E666E2E746F6F6C7469702E436F6E73747275';
wwv_flow_api.g_varchar2_table(74) := '63746F722E70726F746F74797065292C622E70726F746F747970652E636F6E7374727563746F723D622C622E70726F746F747970652E67657444656661756C74733D66756E6374696F6E28297B72657475726E20622E44454641554C54537D2C622E7072';
wwv_flow_api.g_varchar2_table(75) := '6F746F747970652E736574436F6E74656E743D66756E6374696F6E28297B76617220613D746869732E74697028292C623D746869732E6765745469746C6528292C633D746869732E676574436F6E74656E7428293B612E66696E6428222E706F706F7665';
wwv_flow_api.g_varchar2_table(76) := '722D7469746C6522295B746869732E6F7074696F6E732E68746D6C3F2268746D6C223A2274657874225D2862292C612E66696E6428222E706F706F7665722D636F6E74656E7422295B746869732E6F7074696F6E732E68746D6C3F747970656F6620633D';
wwv_flow_api.g_varchar2_table(77) := '3D22737472696E67223F2268746D6C223A22617070656E64223A2274657874225D2863292C612E72656D6F7665436C61737328226661646520746F7020626F74746F6D206C65667420726967687420696E22292C612E66696E6428222E706F706F766572';
wwv_flow_api.g_varchar2_table(78) := '2D7469746C6522292E68746D6C28297C7C612E66696E6428222E706F706F7665722D7469746C6522292E6869646528297D2C622E70726F746F747970652E686173436F6E74656E743D66756E6374696F6E28297B72657475726E20746869732E67657454';
wwv_flow_api.g_varchar2_table(79) := '69746C6528297C7C746869732E676574436F6E74656E7428297D2C622E70726F746F747970652E676574436F6E74656E743D66756E6374696F6E28297B76617220613D746869732E24656C656D656E742C623D746869732E6F7074696F6E733B72657475';
wwv_flow_api.g_varchar2_table(80) := '726E20612E617474722822646174612D636F6E74656E7422297C7C28747970656F6620622E636F6E74656E743D3D2266756E6374696F6E223F622E636F6E74656E742E63616C6C28615B305D293A622E636F6E74656E74297D2C622E70726F746F747970';
wwv_flow_api.g_varchar2_table(81) := '652E6172726F773D66756E6374696F6E28297B72657475726E20746869732E246172726F773D746869732E246172726F777C7C746869732E74697028292E66696E6428222E6172726F7722297D2C622E70726F746F747970652E7469703D66756E637469';
wwv_flow_api.g_varchar2_table(82) := '6F6E28297B72657475726E20746869732E247469707C7C28746869732E247469703D6128746869732E6F7074696F6E732E74656D706C61746529292C746869732E247469707D3B76617220633D612E666E2E706F706F7665723B612E666E2E706F706F76';
wwv_flow_api.g_varchar2_table(83) := '65723D66756E6374696F6E2863297B72657475726E20746869732E656163682866756E6374696F6E28297B76617220643D612874686973292C653D642E64617461282262732E706F706F76657222292C663D747970656F6620633D3D226F626A65637422';
wwv_flow_api.g_varchar2_table(84) := '2626633B69662821652626633D3D2264657374726F79222972657475726E3B657C7C642E64617461282262732E706F706F766572222C653D6E6577206228746869732C6629292C747970656F6620633D3D22737472696E67222626655B635D28297D297D';
wwv_flow_api.g_varchar2_table(85) := '2C612E666E2E706F706F7665722E436F6E7374727563746F723D622C612E666E2E706F706F7665722E6E6F436F6E666C6963743D66756E6374696F6E28297B72657475726E20612E666E2E706F706F7665723D632C746869737D7D286A51756572792920';
wwv_flow_api.g_varchar2_table(86) := '200D0A7D29286A517565727950414C290A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(62256907928567844)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'bootstrap.min-popover.js'
,p_mime_type=>'application/javascript'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '47494638396112000E00910200000000FFFFFFFFFFFF00000021FF0B584D502044617461584D503C3F787061636B657420626567696E3D22EFBBBF222069643D2257354D304D7043656869487A7265537A4E54637A6B633964223F3E203C783A786D706D';
wwv_flow_api.g_varchar2_table(2) := '65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A786D70746B3D2241646F626520584D5020436F726520352E302D633036302036312E3133343737372C20323031302F30322F31322D31373A33323A30302020202020202020';
wwv_flow_api.g_varchar2_table(3) := '223E203C7264663A52444620786D6C6E733A7264663D22687474703A2F2F7777772E77332E6F72672F313939392F30322F32322D7264662D73796E7461782D6E7323223E203C7264663A4465736372697074696F6E207264663A61626F75743D22222078';
wwv_flow_api.g_varchar2_table(4) := '6D6C6E733A786D703D22687474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F2220786D6C6E733A786D704D4D3D22687474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F6D6D2F2220786D6C6E733A73745265663D2268';
wwv_flow_api.g_varchar2_table(5) := '7474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F73547970652F5265736F75726365526566232220786D703A43726561746F72546F6F6C3D2241646F62652050686F746F73686F70204353352057696E646F77732220786D704D4D3A49';
wwv_flow_api.g_varchar2_table(6) := '6E7374616E636549443D22786D702E6969643A44393731373735304630343831314531394232444346313530373430333931392220786D704D4D3A446F63756D656E7449443D22786D702E6469643A443937313737353146303438313145313942324443';
wwv_flow_api.g_varchar2_table(7) := '4631353037343033393139223E203C786D704D4D3A4465726976656446726F6D2073745265663A696E7374616E636549443D22786D702E6969643A4439373137373445463034383131453139423244434631353037343033393139222073745265663A64';
wwv_flow_api.g_varchar2_table(8) := '6F63756D656E7449443D22786D702E6469643A4439373137373446463034383131453139423244434631353037343033393139222F3E203C2F7264663A4465736372697074696F6E3E203C2F7264663A5244463E203C2F783A786D706D6574613E203C3F';
wwv_flow_api.g_varchar2_table(9) := '787061636B657420656E643D2272223F3E01FFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0EFEEEDECEBEAE9E8E7E6E5E4E3E2E1E0DFDEDDDCDBDAD9D8D7D6D5D4D3D2D1D0CFCECDCCCBCAC9C8C7C6C5C4C3C2C1C0BFBEBDBCBBBAB9B8B7B6B5B4B3B2B1B0AFAE';
wwv_flow_api.g_varchar2_table(10) := 'ADACABAAA9A8A7A6A5A4A3A2A1A09F9E9D9C9B9A999897969594939291908F8E8D8C8B8A898887868584838281807F7E7D7C7B7A797877767574737271706F6E6D6C6B6A696867666564636261605F5E5D5C5B5A595857565554535251504F4E4D4C4B4A';
wwv_flow_api.g_varchar2_table(11) := '494847464544434241403F3E3D3C3B3A393837363534333231302F2E2D2C2B2A292827262524232221201F1E1D1C1B1A191817161514131211100F0E0D0C0B0A090807060504030201000021F90401000002002C0000000012000E00000232940F09C7A8';
wwv_flow_api.g_varchar2_table(12) := '10C25B0C46986494F5EE6D514638651CF2A560F795090BA62FDACAA760C58AA48CB67ACA794A372250D470F50A003B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(149113922525527735)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'pasted-icon.gif'
,p_mime_type=>'image/gif'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A210A202A206D757374616368652E6A73202D204C6F6769632D6C657373207B7B6D757374616368657D7D2074656D706C617465732077697468204A6176615363726970740A202A20687474703A2F2F6769746875622E636F6D2F6A616E6C2F6D7573';
wwv_flow_api.g_varchar2_table(2) := '74616368652E6A730A202A2F0A0A2F2A676C6F62616C20646566696E653A2066616C73652A2F0A0A2866756E6374696F6E2028676C6F62616C2C20666163746F727929207B0A202069662028747970656F66206578706F727473203D3D3D20226F626A65';
wwv_flow_api.g_varchar2_table(3) := '637422202626206578706F72747329207B0A20202020666163746F7279286578706F727473293B202F2F20436F6D6D6F6E4A530A20207D20656C73652069662028747970656F6620646566696E65203D3D3D202266756E6374696F6E2220262620646566';
wwv_flow_api.g_varchar2_table(4) := '696E652E616D6429207B0A20202020646566696E6528666163746F7279287B7D29293B202F2F20414D440A20207D20656C7365207B0A20202020676C6F62616C2E4D75737461636865203D20666163746F7279287B7D293B202F2F203C7363726970743E';
wwv_flow_api.g_varchar2_table(5) := '0A20207D0A7D28746869732C2066756E6374696F6E20286D7573746163686529207B0A0A2020766172204F626A6563745F746F537472696E67203D204F626A6563742E70726F746F747970652E746F537472696E673B0A20207661722069734172726179';
wwv_flow_api.g_varchar2_table(6) := '203D2041727261792E69734172726179207C7C2066756E6374696F6E20286F626A65637429207B0A2020202072657475726E204F626A6563745F746F537472696E672E63616C6C286F626A65637429203D3D3D20275B6F626A6563742041727261795D27';
wwv_flow_api.g_varchar2_table(7) := '3B0A20207D3B0A0A202066756E6374696F6E20697346756E6374696F6E286F626A65637429207B0A2020202072657475726E20747970656F66206F626A656374203D3D3D202766756E6374696F6E273B0A20207D0A0A202066756E6374696F6E20657363';
wwv_flow_api.g_varchar2_table(8) := '61706552656745787028737472696E6729207B0A2020202072657475726E20737472696E672E7265706C616365282F5B5C2D5C5B5C5D7B7D28292A2B3F2E2C5C5C5C5E247C235C735D2F672C20225C5C242622293B0A20207D0A0A20202F2F20576F726B';
wwv_flow_api.g_varchar2_table(9) := '61726F756E6420666F722068747470733A2F2F6973737565732E6170616368652E6F72672F6A6972612F62726F7773652F434F55434844422D3537370A20202F2F205365652068747470733A2F2F6769746875622E636F6D2F6A616E6C2F6D7573746163';
wwv_flow_api.g_varchar2_table(10) := '68652E6A732F6973737565732F3138390A2020766172205265674578705F74657374203D205265674578702E70726F746F747970652E746573743B0A202066756E6374696F6E20746573745265674578702872652C20737472696E6729207B0A20202020';
wwv_flow_api.g_varchar2_table(11) := '72657475726E205265674578705F746573742E63616C6C2872652C20737472696E67293B0A20207D0A0A2020766172206E6F6E53706163655265203D202F5C532F3B0A202066756E6374696F6E2069735768697465737061636528737472696E6729207B';
wwv_flow_api.g_varchar2_table(12) := '0A2020202072657475726E202174657374526567457870286E6F6E537061636552652C20737472696E67293B0A20207D0A20200A202076617220656E746974794D6170203D207B0A202020202226223A202226616D703B222C0A20202020223C223A2022';
wwv_flow_api.g_varchar2_table(13) := '266C743B222C0A20202020223E223A20222667743B222C0A202020202722273A20272671756F743B272C0A202020202227223A2027262333393B272C0A20202020222F223A202726237832463B270A20207D3B0A0A202066756E6374696F6E2065736361';
wwv_flow_api.g_varchar2_table(14) := '706548746D6C28737472696E6729207B0A2020202072657475726E20537472696E6728737472696E67292E7265706C616365282F5B263C3E22275C2F5D2F672C2066756E6374696F6E20287329207B0A20202020202072657475726E20656E746974794D';
wwv_flow_api.g_varchar2_table(15) := '61705B735D3B0A202020207D293B0A20207D0A0A20207661722077686974655265203D202F5C732A2F3B0A20207661722073706163655265203D202F5C732B2F3B0A202076617220657175616C735265203D202F5C732A3D2F3B0A202076617220637572';
wwv_flow_api.g_varchar2_table(16) := '6C795265203D202F5C732A5C7D2F3B0A2020766172207461675265203D202F237C5C5E7C5C2F7C3E7C5C7B7C267C3D7C212F3B0A0A20202F2A2A0A2020202A20427265616B732075702074686520676976656E206074656D706C6174656020737472696E';
wwv_flow_api.g_varchar2_table(17) := '6720696E746F20612074726565206F6620746F6B656E732E20496620746865206074616773600A2020202A20617267756D656E7420697320676976656E2068657265206974206D75737420626520616E20617272617920776974682074776F2073747269';
wwv_flow_api.g_varchar2_table(18) := '6E672076616C7565733A207468650A2020202A206F70656E696E6720616E6420636C6F73696E672074616773207573656420696E207468652074656D706C6174652028652E672E205B20223C25222C2022253E22205D292E204F660A2020202A20636F75';
wwv_flow_api.g_varchar2_table(19) := '7273652C207468652064656661756C7420697320746F20757365206D75737461636865732028692E652E206D757374616368652E74616773292E0A2020202A0A2020202A204120746F6B656E20697320616E2061727261792077697468206174206C6561';
wwv_flow_api.g_varchar2_table(20) := '7374203420656C656D656E74732E2054686520666972737420656C656D656E74206973207468650A2020202A206D757374616368652073796D626F6C207468617420776173207573656420696E7369646520746865207461672C20652E672E2022232220';
wwv_flow_api.g_varchar2_table(21) := '6F72202226222E20496620746865207461670A2020202A20646964206E6F7420636F6E7461696E20612073796D626F6C2028692E652E207B7B6D7956616C75657D7D29207468697320656C656D656E7420697320226E616D65222E20466F720A2020202A';
wwv_flow_api.g_varchar2_table(22) := '20616C6C207465787420746861742061707065617273206F75747369646520612073796D626F6C207468697320656C656D656E74206973202274657874222E0A2020202A0A2020202A20546865207365636F6E6420656C656D656E74206F66206120746F';
wwv_flow_api.g_varchar2_table(23) := '6B656E20697320697473202276616C7565222E20466F72206D75737461636865207461677320746869732069730A2020202A20776861746576657220656C73652077617320696E736964652074686520746167206265736964657320746865206F70656E';
wwv_flow_api.g_varchar2_table(24) := '696E672073796D626F6C2E20466F72207465787420746F6B656E730A2020202A207468697320697320746865207465787420697473656C662E0A2020202A0A2020202A2054686520746869726420616E6420666F7572746820656C656D656E7473206F66';
wwv_flow_api.g_varchar2_table(25) := '2074686520746F6B656E206172652074686520737461727420616E6420656E6420696E64696365732C0A2020202A20726573706563746976656C792C206F662074686520746F6B656E20696E20746865206F726967696E616C2074656D706C6174652E0A';
wwv_flow_api.g_varchar2_table(26) := '2020202A0A2020202A20546F6B656E732074686174206172652074686520726F6F74206E6F6465206F662061207375627472656520636F6E7461696E2074776F206D6F726520656C656D656E74733A20312920616E0A2020202A206172726179206F6620';
wwv_flow_api.g_varchar2_table(27) := '746F6B656E7320696E20746865207375627472656520616E642032292074686520696E64657820696E20746865206F726967696E616C2074656D706C6174652061740A2020202A2077686963682074686520636C6F73696E672074616720666F72207468';
wwv_flow_api.g_varchar2_table(28) := '61742073656374696F6E20626567696E732E0A2020202A2F0A202066756E6374696F6E20706172736554656D706C6174652874656D706C6174652C207461677329207B0A20202020696620282174656D706C617465290A20202020202072657475726E20';
wwv_flow_api.g_varchar2_table(29) := '5B5D3B0A0A202020207661722073656374696F6E73203D205B5D3B20202020202F2F20537461636B20746F20686F6C642073656374696F6E20746F6B656E730A2020202076617220746F6B656E73203D205B5D3B202020202020202F2F20427566666572';
wwv_flow_api.g_varchar2_table(30) := '20746F20686F6C642074686520746F6B656E730A2020202076617220737061636573203D205B5D3B202020202020202F2F20496E6469636573206F66207768697465737061636520746F6B656E73206F6E207468652063757272656E74206C696E650A20';
wwv_flow_api.g_varchar2_table(31) := '20202076617220686173546167203D2066616C73653B202020202F2F2049732074686572652061207B7B7461677D7D206F6E207468652063757272656E74206C696E653F0A20202020766172206E6F6E5370616365203D2066616C73653B20202F2F2049';
wwv_flow_api.g_varchar2_table(32) := '732074686572652061206E6F6E2D73706163652063686172206F6E207468652063757272656E74206C696E653F0A0A202020202F2F2053747269707320616C6C207768697465737061636520746F6B656E7320617272617920666F722074686520637572';
wwv_flow_api.g_varchar2_table(33) := '72656E74206C696E650A202020202F2F206966207468657265207761732061207B7B237461677D7D206F6E20697420616E64206F7468657277697365206F6E6C792073706163652E0A2020202066756E6374696F6E20737472697053706163652829207B';
wwv_flow_api.g_varchar2_table(34) := '0A2020202020206966202868617354616720262620216E6F6E537061636529207B0A20202020202020207768696C6520287370616365732E6C656E677468290A2020202020202020202064656C65746520746F6B656E735B7370616365732E706F702829';
wwv_flow_api.g_varchar2_table(35) := '5D3B0A2020202020207D20656C7365207B0A2020202020202020737061636573203D205B5D3B0A2020202020207D0A0A202020202020686173546167203D2066616C73653B0A2020202020206E6F6E5370616365203D2066616C73653B0A202020207D0A';
wwv_flow_api.g_varchar2_table(36) := '0A20202020766172206F70656E696E6754616752652C20636C6F73696E6754616752652C20636C6F73696E674375726C7952653B0A2020202066756E6374696F6E20636F6D70696C6554616773287461677329207B0A2020202020206966202874797065';
wwv_flow_api.g_varchar2_table(37) := '6F662074616773203D3D3D2027737472696E6727290A202020202020202074616773203D20746167732E73706C697428737061636552652C2032293B0A0A202020202020696620282169734172726179287461677329207C7C20746167732E6C656E6774';
wwv_flow_api.g_varchar2_table(38) := '6820213D3D2032290A20202020202020207468726F77206E6577204572726F722827496E76616C696420746167733A2027202B2074616773293B0A0A2020202020206F70656E696E675461675265203D206E657720526567457870286573636170655265';
wwv_flow_api.g_varchar2_table(39) := '6745787028746167735B305D29202B20275C5C732A27293B0A202020202020636C6F73696E675461675265203D206E65772052656745787028275C5C732A27202B2065736361706552656745787028746167735B315D29293B0A202020202020636C6F73';
wwv_flow_api.g_varchar2_table(40) := '696E674375726C795265203D206E65772052656745787028275C5C732A27202B2065736361706552656745787028277D27202B20746167735B315D29293B0A202020207D0A0A20202020636F6D70696C65546167732874616773207C7C206D7573746163';
wwv_flow_api.g_varchar2_table(41) := '68652E74616773293B0A0A20202020766172207363616E6E6572203D206E6577205363616E6E65722874656D706C617465293B0A0A202020207661722073746172742C20747970652C2076616C75652C206368722C20746F6B656E2C206F70656E536563';
wwv_flow_api.g_varchar2_table(42) := '74696F6E3B0A202020207768696C652028217363616E6E65722E656F73282929207B0A2020202020207374617274203D207363616E6E65722E706F733B0A0A2020202020202F2F204D6174636820616E792074657874206265747765656E20746167732E';
wwv_flow_api.g_varchar2_table(43) := '0A20202020202076616C7565203D207363616E6E65722E7363616E556E74696C286F70656E696E675461675265293B0A0A2020202020206966202876616C756529207B0A2020202020202020666F7220287661722069203D20302C2076616C75654C656E';
wwv_flow_api.g_varchar2_table(44) := '677468203D2076616C75652E6C656E6774683B2069203C2076616C75654C656E6774683B202B2B6929207B0A20202020202020202020636872203D2076616C75652E6368617241742869293B0A0A20202020202020202020696620286973576869746573';
wwv_flow_api.g_varchar2_table(45) := '70616365286368722929207B0A2020202020202020202020207370616365732E7075736828746F6B656E732E6C656E677468293B0A202020202020202020207D20656C7365207B0A2020202020202020202020206E6F6E5370616365203D20747275653B';
wwv_flow_api.g_varchar2_table(46) := '0A202020202020202020207D0A0A20202020202020202020746F6B656E732E70757368285B202774657874272C206368722C2073746172742C207374617274202B2031205D293B0A202020202020202020207374617274202B3D20313B0A0A2020202020';
wwv_flow_api.g_varchar2_table(47) := '20202020202F2F20436865636B20666F722077686974657370616365206F6E207468652063757272656E74206C696E652E0A2020202020202020202069662028636872203D3D3D20275C6E27290A20202020202020202020202073747269705370616365';
wwv_flow_api.g_varchar2_table(48) := '28293B0A20202020202020207D0A2020202020207D0A0A2020202020202F2F204D6174636820746865206F70656E696E67207461672E0A20202020202069662028217363616E6E65722E7363616E286F70656E696E67546167526529290A202020202020';
wwv_flow_api.g_varchar2_table(49) := '2020627265616B3B0A0A202020202020686173546167203D20747275653B0A0A2020202020202F2F20476574207468652074616720747970652E0A20202020202074797065203D207363616E6E65722E7363616E28746167526529207C7C20276E616D65';
wwv_flow_api.g_varchar2_table(50) := '273B0A2020202020207363616E6E65722E7363616E2877686974655265293B0A0A2020202020202F2F2047657420746865207461672076616C75652E0A2020202020206966202874797065203D3D3D20273D2729207B0A202020202020202076616C7565';
wwv_flow_api.g_varchar2_table(51) := '203D207363616E6E65722E7363616E556E74696C28657175616C735265293B0A20202020202020207363616E6E65722E7363616E28657175616C735265293B0A20202020202020207363616E6E65722E7363616E556E74696C28636C6F73696E67546167';
wwv_flow_api.g_varchar2_table(52) := '5265293B0A2020202020207D20656C7365206966202874797065203D3D3D20277B2729207B0A202020202020202076616C7565203D207363616E6E65722E7363616E556E74696C28636C6F73696E674375726C795265293B0A2020202020202020736361';
wwv_flow_api.g_varchar2_table(53) := '6E6E65722E7363616E286375726C795265293B0A20202020202020207363616E6E65722E7363616E556E74696C28636C6F73696E675461675265293B0A202020202020202074797065203D202726273B0A2020202020207D20656C7365207B0A20202020';
wwv_flow_api.g_varchar2_table(54) := '2020202076616C7565203D207363616E6E65722E7363616E556E74696C28636C6F73696E675461675265293B0A2020202020207D0A0A2020202020202F2F204D617463682074686520636C6F73696E67207461672E0A2020202020206966202821736361';
wwv_flow_api.g_varchar2_table(55) := '6E6E65722E7363616E28636C6F73696E67546167526529290A20202020202020207468726F77206E6577204572726F722827556E636C6F736564207461672061742027202B207363616E6E65722E706F73293B0A0A202020202020746F6B656E203D205B';
wwv_flow_api.g_varchar2_table(56) := '20747970652C2076616C75652C2073746172742C207363616E6E65722E706F73205D3B0A202020202020746F6B656E732E7075736828746F6B656E293B0A0A2020202020206966202874797065203D3D3D20272327207C7C2074797065203D3D3D20275E';
wwv_flow_api.g_varchar2_table(57) := '2729207B0A202020202020202073656374696F6E732E7075736828746F6B656E293B0A2020202020207D20656C7365206966202874797065203D3D3D20272F2729207B0A20202020202020202F2F20436865636B2073656374696F6E206E657374696E67';
wwv_flow_api.g_varchar2_table(58) := '2E0A20202020202020206F70656E53656374696F6E203D2073656374696F6E732E706F7028293B0A0A202020202020202069662028216F70656E53656374696F6E290A202020202020202020207468726F77206E6577204572726F722827556E6F70656E';
wwv_flow_api.g_varchar2_table(59) := '65642073656374696F6E202227202B2076616C7565202B2027222061742027202B207374617274293B0A0A2020202020202020696620286F70656E53656374696F6E5B315D20213D3D2076616C7565290A202020202020202020207468726F77206E6577';
wwv_flow_api.g_varchar2_table(60) := '204572726F722827556E636C6F7365642073656374696F6E202227202B206F70656E53656374696F6E5B315D202B2027222061742027202B207374617274293B0A2020202020207D20656C7365206966202874797065203D3D3D20276E616D6527207C7C';
wwv_flow_api.g_varchar2_table(61) := '2074797065203D3D3D20277B27207C7C2074797065203D3D3D2027262729207B0A20202020202020206E6F6E5370616365203D20747275653B0A2020202020207D20656C7365206966202874797065203D3D3D20273D2729207B0A20202020202020202F';
wwv_flow_api.g_varchar2_table(62) := '2F2053657420746865207461677320666F7220746865206E6578742074696D652061726F756E642E0A2020202020202020636F6D70696C65546167732876616C7565293B0A2020202020207D0A202020207D0A0A202020202F2F204D616B652073757265';
wwv_flow_api.g_varchar2_table(63) := '20746865726520617265206E6F206F70656E2073656374696F6E73207768656E20776527726520646F6E652E0A202020206F70656E53656374696F6E203D2073656374696F6E732E706F7028293B0A0A20202020696620286F70656E53656374696F6E29';
wwv_flow_api.g_varchar2_table(64) := '0A2020202020207468726F77206E6577204572726F722827556E636C6F7365642073656374696F6E202227202B206F70656E53656374696F6E5B315D202B2027222061742027202B207363616E6E65722E706F73293B0A0A2020202072657475726E206E';
wwv_flow_api.g_varchar2_table(65) := '657374546F6B656E7328737175617368546F6B656E7328746F6B656E7329293B0A20207D0A0A20202F2A2A0A2020202A20436F6D62696E6573207468652076616C756573206F6620636F6E7365637574697665207465787420746F6B656E7320696E2074';
wwv_flow_api.g_varchar2_table(66) := '686520676976656E2060746F6B656E73602061727261790A2020202A20746F20612073696E676C6520746F6B656E2E0A2020202A2F0A202066756E6374696F6E20737175617368546F6B656E7328746F6B656E7329207B0A202020207661722073717561';
wwv_flow_api.g_varchar2_table(67) := '73686564546F6B656E73203D205B5D3B0A0A2020202076617220746F6B656E2C206C617374546F6B656E3B0A20202020666F7220287661722069203D20302C206E756D546F6B656E73203D20746F6B656E732E6C656E6774683B2069203C206E756D546F';
wwv_flow_api.g_varchar2_table(68) := '6B656E733B202B2B6929207B0A202020202020746F6B656E203D20746F6B656E735B695D3B0A0A20202020202069662028746F6B656E29207B0A202020202020202069662028746F6B656E5B305D203D3D3D20277465787427202626206C617374546F6B';
wwv_flow_api.g_varchar2_table(69) := '656E202626206C617374546F6B656E5B305D203D3D3D2027746578742729207B0A202020202020202020206C617374546F6B656E5B315D202B3D20746F6B656E5B315D3B0A202020202020202020206C617374546F6B656E5B335D203D20746F6B656E5B';
wwv_flow_api.g_varchar2_table(70) := '335D3B0A20202020202020207D20656C7365207B0A202020202020202020207371756173686564546F6B656E732E7075736828746F6B656E293B0A202020202020202020206C617374546F6B656E203D20746F6B656E3B0A20202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(71) := '202020207D0A202020207D0A0A2020202072657475726E207371756173686564546F6B656E733B0A20207D0A0A20202F2A2A0A2020202A20466F726D732074686520676976656E206172726179206F662060746F6B656E736020696E746F2061206E6573';
wwv_flow_api.g_varchar2_table(72) := '7465642074726565207374727563747572652077686572650A2020202A20746F6B656E73207468617420726570726573656E7420612073656374696F6E20686176652074776F206164646974696F6E616C206974656D733A20312920616E206172726179';
wwv_flow_api.g_varchar2_table(73) := '206F660A2020202A20616C6C20746F6B656E7320746861742061707065617220696E20746861742073656374696F6E20616E642032292074686520696E64657820696E20746865206F726967696E616C0A2020202A2074656D706C617465207468617420';
wwv_flow_api.g_varchar2_table(74) := '726570726573656E74732074686520656E64206F6620746861742073656374696F6E2E0A2020202A2F0A202066756E6374696F6E206E657374546F6B656E7328746F6B656E7329207B0A20202020766172206E6573746564546F6B656E73203D205B5D3B';
wwv_flow_api.g_varchar2_table(75) := '0A2020202076617220636F6C6C6563746F72203D206E6573746564546F6B656E733B0A202020207661722073656374696F6E73203D205B5D3B0A0A2020202076617220746F6B656E2C2073656374696F6E3B0A20202020666F7220287661722069203D20';
wwv_flow_api.g_varchar2_table(76) := '302C206E756D546F6B656E73203D20746F6B656E732E6C656E6774683B2069203C206E756D546F6B656E733B202B2B6929207B0A202020202020746F6B656E203D20746F6B656E735B695D3B0A0A2020202020207377697463682028746F6B656E5B305D';
wwv_flow_api.g_varchar2_table(77) := '29207B0A20202020202063617365202723273A0A2020202020206361736520275E273A0A2020202020202020636F6C6C6563746F722E7075736828746F6B656E293B0A202020202020202073656374696F6E732E7075736828746F6B656E293B0A202020';
wwv_flow_api.g_varchar2_table(78) := '2020202020636F6C6C6563746F72203D20746F6B656E5B345D203D205B5D3B0A2020202020202020627265616B3B0A2020202020206361736520272F273A0A202020202020202073656374696F6E203D2073656374696F6E732E706F7028293B0A202020';
wwv_flow_api.g_varchar2_table(79) := '202020202073656374696F6E5B355D203D20746F6B656E5B325D3B0A2020202020202020636F6C6C6563746F72203D2073656374696F6E732E6C656E677468203E2030203F2073656374696F6E735B73656374696F6E732E6C656E677468202D20315D5B';
wwv_flow_api.g_varchar2_table(80) := '345D203A206E6573746564546F6B656E733B0A2020202020202020627265616B3B0A20202020202064656661756C743A0A2020202020202020636F6C6C6563746F722E7075736828746F6B656E293B0A2020202020207D0A202020207D0A0A2020202072';
wwv_flow_api.g_varchar2_table(81) := '657475726E206E6573746564546F6B656E733B0A20207D0A0A20202F2A2A0A2020202A20412073696D706C6520737472696E67207363616E6E657220746861742069732075736564206279207468652074656D706C6174652070617273657220746F2066';
wwv_flow_api.g_varchar2_table(82) := '696E640A2020202A20746F6B656E7320696E2074656D706C61746520737472696E67732E0A2020202A2F0A202066756E6374696F6E205363616E6E657228737472696E6729207B0A20202020746869732E737472696E67203D20737472696E673B0A2020';
wwv_flow_api.g_varchar2_table(83) := '2020746869732E7461696C203D20737472696E673B0A20202020746869732E706F73203D20303B0A20207D0A0A20202F2A2A0A2020202A2052657475726E732060747275656020696620746865207461696C20697320656D7074792028656E64206F6620';
wwv_flow_api.g_varchar2_table(84) := '737472696E67292E0A2020202A2F0A20205363616E6E65722E70726F746F747970652E656F73203D2066756E6374696F6E202829207B0A2020202072657475726E20746869732E7461696C203D3D3D2022223B0A20207D3B0A0A20202F2A2A0A2020202A';
wwv_flow_api.g_varchar2_table(85) := '20547269657320746F206D617463682074686520676976656E20726567756C61722065787072657373696F6E206174207468652063757272656E7420706F736974696F6E2E0A2020202A2052657475726E7320746865206D617463686564207465787420';
wwv_flow_api.g_varchar2_table(86) := '69662069742063616E206D617463682C2074686520656D70747920737472696E67206F74686572776973652E0A2020202A2F0A20205363616E6E65722E70726F746F747970652E7363616E203D2066756E6374696F6E2028726529207B0A202020207661';
wwv_flow_api.g_varchar2_table(87) := '72206D61746368203D20746869732E7461696C2E6D61746368287265293B0A0A2020202069662028216D61746368207C7C206D617463682E696E64657820213D3D2030290A20202020202072657475726E2027273B0A0A2020202076617220737472696E';
wwv_flow_api.g_varchar2_table(88) := '67203D206D617463685B305D3B0A0A20202020746869732E7461696C203D20746869732E7461696C2E737562737472696E6728737472696E672E6C656E677468293B0A20202020746869732E706F73202B3D20737472696E672E6C656E6774683B0A0A20';
wwv_flow_api.g_varchar2_table(89) := '20202072657475726E20737472696E673B0A20207D3B0A0A20202F2A2A0A2020202A20536B69707320616C6C207465787420756E74696C2074686520676976656E20726567756C61722065787072657373696F6E2063616E206265206D6174636865642E';
wwv_flow_api.g_varchar2_table(90) := '2052657475726E730A2020202A2074686520736B697070656420737472696E672C2077686963682069732074686520656E74697265207461696C206966206E6F206D617463682063616E206265206D6164652E0A2020202A2F0A20205363616E6E65722E';
wwv_flow_api.g_varchar2_table(91) := '70726F746F747970652E7363616E556E74696C203D2066756E6374696F6E2028726529207B0A2020202076617220696E646578203D20746869732E7461696C2E736561726368287265292C206D617463683B0A0A202020207377697463682028696E6465';
wwv_flow_api.g_varchar2_table(92) := '7829207B0A2020202063617365202D313A0A2020202020206D61746368203D20746869732E7461696C3B0A202020202020746869732E7461696C203D2022223B0A202020202020627265616B3B0A202020206361736520303A0A2020202020206D617463';
wwv_flow_api.g_varchar2_table(93) := '68203D2022223B0A202020202020627265616B3B0A2020202064656661756C743A0A2020202020206D61746368203D20746869732E7461696C2E737562737472696E6728302C20696E646578293B0A202020202020746869732E7461696C203D20746869';
wwv_flow_api.g_varchar2_table(94) := '732E7461696C2E737562737472696E6728696E646578293B0A202020207D0A0A20202020746869732E706F73202B3D206D617463682E6C656E6774683B0A0A2020202072657475726E206D617463683B0A20207D3B0A0A20202F2A2A0A2020202A205265';
wwv_flow_api.g_varchar2_table(95) := '70726573656E747320612072656E646572696E6720636F6E74657874206279207772617070696E6720612076696577206F626A65637420616E640A2020202A206D61696E7461696E696E672061207265666572656E636520746F2074686520706172656E';
wwv_flow_api.g_varchar2_table(96) := '7420636F6E746578742E0A2020202A2F0A202066756E6374696F6E20436F6E7465787428766965772C20706172656E74436F6E7465787429207B0A20202020746869732E76696577203D2076696577203D3D206E756C6C203F207B7D203A20766965773B';
wwv_flow_api.g_varchar2_table(97) := '0A20202020746869732E6361636865203D207B20272E273A20746869732E76696577207D3B0A20202020746869732E706172656E74203D20706172656E74436F6E746578743B0A20207D0A0A20202F2A2A0A2020202A20437265617465732061206E6577';
wwv_flow_api.g_varchar2_table(98) := '20636F6E74657874207573696E672074686520676976656E20766965772077697468207468697320636F6E746578740A2020202A2061732074686520706172656E742E0A2020202A2F0A2020436F6E746578742E70726F746F747970652E70757368203D';
wwv_flow_api.g_varchar2_table(99) := '2066756E6374696F6E20287669657729207B0A2020202072657475726E206E657720436F6E7465787428766965772C2074686973293B0A20207D3B0A0A20202F2A2A0A2020202A2052657475726E73207468652076616C7565206F662074686520676976';
wwv_flow_api.g_varchar2_table(100) := '656E206E616D6520696E207468697320636F6E746578742C2074726176657273696E670A2020202A2075702074686520636F6E7465787420686965726172636879206966207468652076616C756520697320616273656E7420696E207468697320636F6E';
wwv_flow_api.g_varchar2_table(101) := '74657874277320766965772E0A2020202A2F0A2020436F6E746578742E70726F746F747970652E6C6F6F6B7570203D2066756E6374696F6E20286E616D6529207B0A20202020766172206361636865203D20746869732E63616368653B0A0A2020202076';
wwv_flow_api.g_varchar2_table(102) := '61722076616C75653B0A20202020696620286E616D6520696E20636163686529207B0A20202020202076616C7565203D2063616368655B6E616D655D3B0A202020207D20656C7365207B0A20202020202076617220636F6E74657874203D20746869732C';
wwv_flow_api.g_varchar2_table(103) := '206E616D65732C20696E6465783B0A0A2020202020207768696C652028636F6E7465787429207B0A2020202020202020696620286E616D652E696E6465784F6628272E2729203E203029207B0A2020202020202020202076616C7565203D20636F6E7465';
wwv_flow_api.g_varchar2_table(104) := '78742E766965773B0A202020202020202020206E616D6573203D206E616D652E73706C697428272E27293B0A20202020202020202020696E646578203D20303B0A0A202020202020202020207768696C65202876616C756520213D206E756C6C20262620';
wwv_flow_api.g_varchar2_table(105) := '696E646578203C206E616D65732E6C656E677468290A20202020202020202020202076616C7565203D2076616C75655B6E616D65735B696E6465782B2B5D5D3B0A20202020202020207D20656C7365207B0A2020202020202020202076616C7565203D20';
wwv_flow_api.g_varchar2_table(106) := '636F6E746578742E766965775B6E616D655D3B0A20202020202020207D0A0A20202020202020206966202876616C756520213D206E756C6C290A20202020202020202020627265616B3B0A0A2020202020202020636F6E74657874203D20636F6E746578';
wwv_flow_api.g_varchar2_table(107) := '742E706172656E743B0A2020202020207D0A0A20202020202063616368655B6E616D655D203D2076616C75653B0A202020207D0A0A2020202069662028697346756E6374696F6E2876616C756529290A20202020202076616C7565203D2076616C75652E';
wwv_flow_api.g_varchar2_table(108) := '63616C6C28746869732E76696577293B0A0A2020202072657475726E2076616C75653B0A20207D3B0A0A20202F2A2A0A2020202A204120577269746572206B6E6F777320686F7720746F2074616B6520612073747265616D206F6620746F6B656E732061';
wwv_flow_api.g_varchar2_table(109) := '6E642072656E646572207468656D20746F20610A2020202A20737472696E672C20676976656E206120636F6E746578742E20497420616C736F206D61696E7461696E732061206361636865206F662074656D706C6174657320746F0A2020202A2061766F';
wwv_flow_api.g_varchar2_table(110) := '696420746865206E65656420746F207061727365207468652073616D652074656D706C6174652074776963652E0A2020202A2F0A202066756E6374696F6E205772697465722829207B0A20202020746869732E6361636865203D207B7D3B0A20207D0A0A';
wwv_flow_api.g_varchar2_table(111) := '20202F2A2A0A2020202A20436C6561727320616C6C206361636865642074656D706C6174657320696E2074686973207772697465722E0A2020202A2F0A20205772697465722E70726F746F747970652E636C6561724361636865203D2066756E6374696F';
wwv_flow_api.g_varchar2_table(112) := '6E202829207B0A20202020746869732E6361636865203D207B7D3B0A20207D3B0A0A20202F2A2A0A2020202A2050617273657320616E64206361636865732074686520676976656E206074656D706C6174656020616E642072657475726E732074686520';
wwv_flow_api.g_varchar2_table(113) := '6172726179206F6620746F6B656E730A2020202A20746861742069732067656E6572617465642066726F6D207468652070617273652E0A2020202A2F0A20205772697465722E70726F746F747970652E7061727365203D2066756E6374696F6E20287465';
wwv_flow_api.g_varchar2_table(114) := '6D706C6174652C207461677329207B0A20202020766172206361636865203D20746869732E63616368653B0A2020202076617220746F6B656E73203D2063616368655B74656D706C6174655D3B0A0A2020202069662028746F6B656E73203D3D206E756C';
wwv_flow_api.g_varchar2_table(115) := '6C290A202020202020746F6B656E73203D2063616368655B74656D706C6174655D203D20706172736554656D706C6174652874656D706C6174652C2074616773293B0A0A2020202072657475726E20746F6B656E733B0A20207D3B0A0A20202F2A2A0A20';
wwv_flow_api.g_varchar2_table(116) := '20202A20486967682D6C6576656C206D6574686F642074686174206973207573656420746F2072656E6465722074686520676976656E206074656D706C6174656020776974680A2020202A2074686520676976656E206076696577602E0A2020202A0A20';
wwv_flow_api.g_varchar2_table(117) := '20202A20546865206F7074696F6E616C20607061727469616C736020617267756D656E74206D617920626520616E206F626A656374207468617420636F6E7461696E73207468650A2020202A206E616D657320616E642074656D706C61746573206F6620';
wwv_flow_api.g_varchar2_table(118) := '7061727469616C73207468617420617265207573656420696E207468652074656D706C6174652E204974206D61790A2020202A20616C736F20626520612066756E6374696F6E2074686174206973207573656420746F206C6F6164207061727469616C20';
wwv_flow_api.g_varchar2_table(119) := '74656D706C61746573206F6E2074686520666C790A2020202A20746861742074616B657320612073696E676C6520617267756D656E743A20746865206E616D65206F6620746865207061727469616C2E0A2020202A2F0A20205772697465722E70726F74';
wwv_flow_api.g_varchar2_table(120) := '6F747970652E72656E646572203D2066756E6374696F6E202874656D706C6174652C20766965772C207061727469616C7329207B0A2020202076617220746F6B656E73203D20746869732E70617273652874656D706C617465293B0A2020202076617220';
wwv_flow_api.g_varchar2_table(121) := '636F6E74657874203D20287669657720696E7374616E63656F6620436F6E7465787429203F2076696577203A206E657720436F6E746578742876696577293B0A2020202072657475726E20746869732E72656E646572546F6B656E7328746F6B656E732C';
wwv_flow_api.g_varchar2_table(122) := '20636F6E746578742C207061727469616C732C2074656D706C617465293B0A20207D3B0A0A20202F2A2A0A2020202A204C6F772D6C6576656C206D6574686F6420746861742072656E646572732074686520676976656E206172726179206F662060746F';
wwv_flow_api.g_varchar2_table(123) := '6B656E7360207573696E670A2020202A2074686520676976656E2060636F6E746578746020616E6420607061727469616C73602E0A2020202A0A2020202A204E6F74653A2054686520606F726967696E616C54656D706C61746560206973206F6E6C7920';
wwv_flow_api.g_varchar2_table(124) := '65766572207573656420746F20657874726163742074686520706F7274696F6E0A2020202A206F6620746865206F726967696E616C2074656D706C61746520746861742077617320636F6E7461696E656420696E2061206869676865722D6F7264657220';
wwv_flow_api.g_varchar2_table(125) := '73656374696F6E2E0A2020202A204966207468652074656D706C61746520646F65736E277420757365206869676865722D6F726465722073656374696F6E732C207468697320617267756D656E74206D61790A2020202A206265206F6D69747465642E0A';
wwv_flow_api.g_varchar2_table(126) := '2020202A2F0A20205772697465722E70726F746F747970652E72656E646572546F6B656E73203D2066756E6374696F6E2028746F6B656E732C20636F6E746578742C207061727469616C732C206F726967696E616C54656D706C61746529207B0A202020';
wwv_flow_api.g_varchar2_table(127) := '2076617220627566666572203D2027273B0A0A202020202F2F20546869732066756E6374696F6E206973207573656420746F2072656E64657220616E206172626974726172792074656D706C6174650A202020202F2F20696E207468652063757272656E';
wwv_flow_api.g_varchar2_table(128) := '7420636F6E74657874206279206869676865722D6F726465722073656374696F6E732E0A202020207661722073656C66203D20746869733B0A2020202066756E6374696F6E2073756252656E6465722874656D706C61746529207B0A2020202020207265';
wwv_flow_api.g_varchar2_table(129) := '7475726E2073656C662E72656E6465722874656D706C6174652C20636F6E746578742C207061727469616C73293B0A202020207D0A0A2020202076617220746F6B656E2C2076616C75653B0A20202020666F7220287661722069203D20302C206E756D54';
wwv_flow_api.g_varchar2_table(130) := '6F6B656E73203D20746F6B656E732E6C656E6774683B2069203C206E756D546F6B656E733B202B2B6929207B0A202020202020746F6B656E203D20746F6B656E735B695D3B0A0A2020202020207377697463682028746F6B656E5B305D29207B0A202020';
wwv_flow_api.g_varchar2_table(131) := '20202063617365202723273A0A202020202020202076616C7565203D20636F6E746578742E6C6F6F6B757028746F6B656E5B315D293B0A0A2020202020202020696620282176616C7565290A20202020202020202020636F6E74696E75653B0A0A202020';
wwv_flow_api.g_varchar2_table(132) := '202020202069662028697341727261792876616C75652929207B0A20202020202020202020666F722028766172206A203D20302C2076616C75654C656E677468203D2076616C75652E6C656E6774683B206A203C2076616C75654C656E6774683B202B2B';
wwv_flow_api.g_varchar2_table(133) := '6A29207B0A202020202020202020202020627566666572202B3D20746869732E72656E646572546F6B656E7328746F6B656E5B345D2C20636F6E746578742E707573682876616C75655B6A5D292C207061727469616C732C206F726967696E616C54656D';
wwv_flow_api.g_varchar2_table(134) := '706C617465293B0A202020202020202020207D0A20202020202020207D20656C73652069662028747970656F662076616C7565203D3D3D20276F626A65637427207C7C20747970656F662076616C7565203D3D3D2027737472696E672729207B0A202020';
wwv_flow_api.g_varchar2_table(135) := '20202020202020627566666572202B3D20746869732E72656E646572546F6B656E7328746F6B656E5B345D2C20636F6E746578742E707573682876616C7565292C207061727469616C732C206F726967696E616C54656D706C617465293B0A2020202020';
wwv_flow_api.g_varchar2_table(136) := '2020207D20656C73652069662028697346756E6374696F6E2876616C75652929207B0A2020202020202020202069662028747970656F66206F726967696E616C54656D706C61746520213D3D2027737472696E6727290A20202020202020202020202074';
wwv_flow_api.g_varchar2_table(137) := '68726F77206E6577204572726F72282743616E6E6F7420757365206869676865722D6F726465722073656374696F6E7320776974686F757420746865206F726967696E616C2074656D706C61746527293B0A0A202020202020202020202F2F2045787472';
wwv_flow_api.g_varchar2_table(138) := '6163742074686520706F7274696F6E206F6620746865206F726967696E616C2074656D706C6174652074686174207468652073656374696F6E20636F6E7461696E732E0A2020202020202020202076616C7565203D2076616C75652E63616C6C28636F6E';
wwv_flow_api.g_varchar2_table(139) := '746578742E766965772C206F726967696E616C54656D706C6174652E736C69636528746F6B656E5B335D2C20746F6B656E5B355D292C2073756252656E646572293B0A0A202020202020202020206966202876616C756520213D206E756C6C290A202020';
wwv_flow_api.g_varchar2_table(140) := '202020202020202020627566666572202B3D2076616C75653B0A20202020202020207D20656C7365207B0A20202020202020202020627566666572202B3D20746869732E72656E646572546F6B656E7328746F6B656E5B345D2C20636F6E746578742C20';
wwv_flow_api.g_varchar2_table(141) := '7061727469616C732C206F726967696E616C54656D706C617465293B0A20202020202020207D0A0A2020202020202020627265616B3B0A2020202020206361736520275E273A0A202020202020202076616C7565203D20636F6E746578742E6C6F6F6B75';
wwv_flow_api.g_varchar2_table(142) := '7028746F6B656E5B315D293B0A0A20202020202020202F2F20557365204A617661536372697074277320646566696E6974696F6E206F662066616C73792E20496E636C75646520656D707479206172726179732E0A20202020202020202F2F2053656520';
wwv_flow_api.g_varchar2_table(143) := '68747470733A2F2F6769746875622E636F6D2F6A616E6C2F6D757374616368652E6A732F6973737565732F3138360A2020202020202020696620282176616C7565207C7C2028697341727261792876616C7565292026262076616C75652E6C656E677468';
wwv_flow_api.g_varchar2_table(144) := '203D3D3D203029290A20202020202020202020627566666572202B3D20746869732E72656E646572546F6B656E7328746F6B656E5B345D2C20636F6E746578742C207061727469616C732C206F726967696E616C54656D706C617465293B0A0A20202020';
wwv_flow_api.g_varchar2_table(145) := '20202020627265616B3B0A2020202020206361736520273E273A0A202020202020202069662028217061727469616C73290A20202020202020202020636F6E74696E75653B0A0A202020202020202076616C7565203D20697346756E6374696F6E287061';
wwv_flow_api.g_varchar2_table(146) := '727469616C7329203F207061727469616C7328746F6B656E5B315D29203A207061727469616C735B746F6B656E5B315D5D3B0A0A20202020202020206966202876616C756520213D206E756C6C290A20202020202020202020627566666572202B3D2074';
wwv_flow_api.g_varchar2_table(147) := '6869732E72656E646572546F6B656E7328746869732E70617273652876616C7565292C20636F6E746578742C207061727469616C732C2076616C7565293B0A0A2020202020202020627265616B3B0A20202020202063617365202726273A0A2020202020';
wwv_flow_api.g_varchar2_table(148) := '20202076616C7565203D20636F6E746578742E6C6F6F6B757028746F6B656E5B315D293B0A0A20202020202020206966202876616C756520213D206E756C6C290A20202020202020202020627566666572202B3D2076616C75653B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(149) := '20627265616B3B0A2020202020206361736520276E616D65273A0A202020202020202076616C7565203D20636F6E746578742E6C6F6F6B757028746F6B656E5B315D293B0A0A20202020202020206966202876616C756520213D206E756C6C290A202020';
wwv_flow_api.g_varchar2_table(150) := '20202020202020627566666572202B3D206D757374616368652E6573636170652876616C7565293B0A0A2020202020202020627265616B3B0A20202020202063617365202774657874273A0A2020202020202020627566666572202B3D20746F6B656E5B';
wwv_flow_api.g_varchar2_table(151) := '315D3B0A2020202020202020627265616B3B0A2020202020207D0A202020207D0A0A2020202072657475726E206275666665723B0A20207D3B0A0A20206D757374616368652E6E616D65203D20226D757374616368652E6A73223B0A20206D7573746163';
wwv_flow_api.g_varchar2_table(152) := '68652E76657273696F6E203D2022302E382E31223B0A20206D757374616368652E74616773203D205B20227B7B222C20227D7D22205D3B0A0A20202F2F20416C6C20686967682D6C6576656C206D757374616368652E2A2066756E6374696F6E73207573';
wwv_flow_api.g_varchar2_table(153) := '652074686973207772697465722E0A20207661722064656661756C74577269746572203D206E65772057726974657228293B0A0A20202F2A2A0A2020202A20436C6561727320616C6C206361636865642074656D706C6174657320696E20746865206465';
wwv_flow_api.g_varchar2_table(154) := '6661756C74207772697465722E0A2020202A2F0A20206D757374616368652E636C6561724361636865203D2066756E6374696F6E202829207B0A2020202072657475726E2064656661756C745772697465722E636C656172436163686528293B0A20207D';
wwv_flow_api.g_varchar2_table(155) := '3B0A0A20202F2A2A0A2020202A2050617273657320616E64206361636865732074686520676976656E2074656D706C61746520696E207468652064656661756C742077726974657220616E642072657475726E73207468650A2020202A20617272617920';
wwv_flow_api.g_varchar2_table(156) := '6F6620746F6B656E7320697420636F6E7461696E732E20446F696E672074686973206168656164206F662074696D652061766F69647320746865206E65656420746F0A2020202A2070617273652074656D706C61746573206F6E2074686520666C792061';
wwv_flow_api.g_varchar2_table(157) := '732074686579206172652072656E64657265642E0A2020202A2F0A20206D757374616368652E7061727365203D2066756E6374696F6E202874656D706C6174652C207461677329207B0A2020202072657475726E2064656661756C745772697465722E70';
wwv_flow_api.g_varchar2_table(158) := '617273652874656D706C6174652C2074616773293B0A20207D3B0A0A20202F2A2A0A2020202A2052656E6465727320746865206074656D706C6174656020776974682074686520676976656E2060766965776020616E6420607061727469616C73602075';
wwv_flow_api.g_varchar2_table(159) := '73696E67207468650A2020202A2064656661756C74207772697465722E0A2020202A2F0A20206D757374616368652E72656E646572203D2066756E6374696F6E202874656D706C6174652C20766965772C207061727469616C7329207B0A202020207265';
wwv_flow_api.g_varchar2_table(160) := '7475726E2064656661756C745772697465722E72656E6465722874656D706C6174652C20766965772C207061727469616C73293B0A20207D3B0A0A20202F2F2054686973206973206865726520666F72206261636B776172647320636F6D706174696269';
wwv_flow_api.g_varchar2_table(161) := '6C697479207769746820302E342E782E0A20206D757374616368652E746F5F68746D6C203D2066756E6374696F6E202874656D706C6174652C20766965772C207061727469616C732C2073656E6429207B0A2020202076617220726573756C74203D206D';
wwv_flow_api.g_varchar2_table(162) := '757374616368652E72656E6465722874656D706C6174652C20766965772C207061727469616C73293B0A0A2020202069662028697346756E6374696F6E2873656E642929207B0A20202020202073656E6428726573756C74293B0A202020207D20656C73';
wwv_flow_api.g_varchar2_table(163) := '65207B0A20202020202072657475726E20726573756C743B0A202020207D0A20207D3B0A0A20202F2F204578706F727420746865206573636170696E672066756E6374696F6E20736F2074686174207468652075736572206D6179206F76657272696465';
wwv_flow_api.g_varchar2_table(164) := '2069742E0A20202F2F205365652068747470733A2F2F6769746875622E636F6D2F6A616E6C2F6D757374616368652E6A732F6973737565732F3234340A20206D757374616368652E657363617065203D2065736361706548746D6C3B0A0A20202F2F2045';
wwv_flow_api.g_varchar2_table(165) := '78706F7274207468657365206D61696E6C7920666F722074657374696E672C2062757420616C736F20666F7220616476616E6365642075736167652E0A20206D757374616368652E5363616E6E6572203D205363616E6E65723B0A20206D757374616368';
wwv_flow_api.g_varchar2_table(166) := '652E436F6E74657874203D20436F6E746578743B0A20206D757374616368652E577269746572203D205772697465723B0A0A202072657475726E206D757374616368653B0A0A7D29293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(149115319721528994)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'mustache.js'
,p_mime_type=>'application/javascript'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0D0A202A0D0A202A20436F7079726967687420286329203230313020432E20462E2C20576F6E6720283C6120687265663D22687474703A2F2F636C6F756467656E2E77306E672E686B223E436C6F756467656E204578616D706C65742053746F7265';
wwv_flow_api.g_varchar2_table(2) := '3C2F613E290D0A202A204C6963656E73656420756E64657220746865204D4954204C6963656E73653A0D0A202A20687474703A2F2F7777772E6F70656E736F757263652E6F72672F6C6963656E7365732F6D69742D6C6963656E73652E7068700D0A202A';
wwv_flow_api.g_varchar2_table(3) := '0D0A202A2F0D0A2866756E6374696F6E20286B2C20652C20692C206A29207B0D0A202020206B2E666E2E6361726574203D2066756E6374696F6E2028622C206C29207B0D0A202020202020202076617220612C20632C2066203D20746869735B305D2C0D';
wwv_flow_api.g_varchar2_table(4) := '0A20202020202020202020202064203D206B2E62726F777365722E6D7369653B0D0A202020202020202069662028747970656F662062203D3D3D20226F626A6563742220262620747970656F6620622E7374617274203D3D3D20226E756D626572222026';
wwv_flow_api.g_varchar2_table(5) := '2620747970656F6620622E656E64203D3D3D20226E756D6265722229207B0D0A20202020202020202020202061203D20622E73746172743B0D0A20202020202020202020202063203D20622E656E640D0A20202020202020207D20656C73652069662028';
wwv_flow_api.g_varchar2_table(6) := '747970656F662062203D3D3D20226E756D6265722220262620747970656F66206C203D3D3D20226E756D6265722229207B0D0A20202020202020202020202061203D20623B0D0A20202020202020202020202063203D206C0D0A20202020202020207D20';
wwv_flow_api.g_varchar2_table(7) := '656C73652069662028747970656F662062203D3D3D2022737472696E6722290D0A202020202020202020202020696620282861203D20662E76616C75652E696E6465784F6628622929203E202D31292063203D2061202B20625B655D3B0D0A2020202020';
wwv_flow_api.g_varchar2_table(8) := '20202020202020656C73652061203D206E756C6C3B0D0A2020202020202020656C736520696620284F626A6563742E70726F746F747970652E746F537472696E672E63616C6C286229203D3D3D20225B6F626A656374205265674578705D2229207B0D0A';
wwv_flow_api.g_varchar2_table(9) := '20202020202020202020202062203D20622E6578656328662E76616C7565293B0D0A202020202020202020202020696620286220213D206E756C6C29207B0D0A2020202020202020202020202020202061203D20622E696E6465783B0D0A202020202020';
wwv_flow_api.g_varchar2_table(10) := '2020202020202020202063203D2061202B20625B305D5B655D0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020202020202069662028747970656F66206120213D2022756E646566696E65642229207B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(11) := '2020202020696620286429207B0D0A2020202020202020202020202020202064203D20746869735B305D2E6372656174655465787452616E676528293B0D0A20202020202020202020202020202020642E636F6C6C617073652874727565293B0D0A2020';
wwv_flow_api.g_varchar2_table(12) := '2020202020202020202020202020642E6D6F766553746172742822636861726163746572222C2061293B0D0A20202020202020202020202020202020642E6D6F7665456E642822636861726163746572222C2063202D2061293B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(13) := '2020202020202020642E73656C65637428290D0A2020202020202020202020207D20656C7365207B0D0A20202020202020202020202020202020746869735B305D2E73656C656374696F6E5374617274203D20613B0D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(14) := '202020746869735B305D2E73656C656374696F6E456E64203D20630D0A2020202020202020202020207D0D0A202020202020202020202020746869735B305D2E666F63757328293B0D0A20202020202020202020202072657475726E20746869730D0A20';
wwv_flow_api.g_varchar2_table(15) := '202020202020207D20656C7365207B0D0A202020202020202020202020696620286429207B0D0A2020202020202020202020202020202063203D20646F63756D656E742E73656C656374696F6E3B0D0A2020202020202020202020202020202069662028';
wwv_flow_api.g_varchar2_table(16) := '746869735B305D2E7461674E616D652E746F4C6F77657243617365282920213D202274657874617265612229207B0D0A202020202020202020202020202020202020202064203D20746869732E76616C28293B0D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(17) := '202020202061203D20635B695D28295B6A5D28293B0D0A2020202020202020202020202020202020202020612E6D6F7665456E642822636861726163746572222C20645B655D293B0D0A2020202020202020202020202020202020202020766172206720';
wwv_flow_api.g_varchar2_table(18) := '3D20612E74657874203D3D202222203F20645B655D203A20642E6C617374496E6465784F6628612E74657874293B0D0A202020202020202020202020202020202020202061203D20635B695D28295B6A5D28293B0D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(19) := '202020202020612E6D6F766553746172742822636861726163746572222C202D645B655D293B0D0A20202020202020202020202020202020202020207661722068203D20612E746578745B655D0D0A202020202020202020202020202020207D20656C73';
wwv_flow_api.g_varchar2_table(20) := '65207B0D0A202020202020202020202020202020202020202061203D20635B695D28293B0D0A202020202020202020202020202020202020202063203D20615B6A5D28293B0D0A2020202020202020202020202020202020202020632E6D6F7665546F45';
wwv_flow_api.g_varchar2_table(21) := '6C656D656E745465787428746869735B305D293B0D0A2020202020202020202020202020202020202020632E736574456E64506F696E742822456E64546F456E64222C2061293B0D0A202020202020202020202020202020202020202067203D20632E74';
wwv_flow_api.g_varchar2_table(22) := '6578745B655D202D20612E746578745B655D3B0D0A202020202020202020202020202020202020202068203D2067202B20612E746578745B655D0D0A202020202020202020202020202020207D0D0A2020202020202020202020207D20656C7365207B0D';
wwv_flow_api.g_varchar2_table(23) := '0A2020202020202020202020202020202067203D0D0A2020202020202020202020202020202020202020662E73656C656374696F6E53746172743B0D0A2020202020202020202020202020202068203D20662E73656C656374696F6E456E640D0A202020';
wwv_flow_api.g_varchar2_table(24) := '2020202020202020207D0D0A20202020202020202020202061203D20662E76616C75652E737562737472696E6728672C2068293B0D0A20202020202020202020202072657475726E207B0D0A2020202020202020202020202020202073746172743A2067';
wwv_flow_api.g_varchar2_table(25) := '2C0D0A20202020202020202020202020202020656E643A20682C0D0A20202020202020202020202020202020746578743A20612C0D0A202020202020202020202020202020207265706C6163653A2066756E6374696F6E20286D29207B0D0A2020202020';
wwv_flow_api.g_varchar2_table(26) := '20202020202020202020202020202072657475726E20662E76616C75652E737562737472696E6728302C206729202B206D202B20662E76616C75652E737562737472696E6728682C20662E76616C75655B655D290D0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(27) := '20207D0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020207D0D0A7D29286A517565727950414C2C20226C656E677468222C202263726561746552616E6765222C20226475706C696361746522293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(149116017780529945)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'jquery.caret.1.02.min2.js'
,p_mime_type=>'application/javascript'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A210A202A20426F6F7473747261702076332E312E312028687474703A2F2F676574626F6F7473747261702E636F6D290A202A20436F7079726967687420323031312D3230313420547769747465722C20496E632E0A202A204C6963656E7365642075';
wwv_flow_api.g_varchar2_table(2) := '6E646572204D4954202868747470733A2F2F6769746875622E636F6D2F747762732F626F6F7473747261702F626C6F622F6D61737465722F4C4943454E5345290A202A2F0A0A2E706F706F7665727B706F736974696F6E3A6162736F6C7574653B746F70';
wwv_flow_api.g_varchar2_table(3) := '3A303B6C6566743A303B7A2D696E6465783A313031303B646973706C61793A6E6F6E653B6D61782D77696474683A32373670783B70616464696E673A3170783B746578742D616C69676E3A6C6566743B6261636B67726F756E642D636F6C6F723A236666';
wwv_flow_api.g_varchar2_table(4) := '663B6261636B67726F756E642D636C69703A70616464696E672D626F783B626F726465723A31707820736F6C696420236363633B626F726465723A31707820736F6C6964207267626128302C302C302C302E32293B626F726465722D7261646975733A36';
wwv_flow_api.g_varchar2_table(5) := '70783B2D7765626B69742D626F782D736861646F773A30203570782031307078207267626128302C302C302C302E32293B626F782D736861646F773A30203570782031307078207267626128302C302C302C302E32293B77686974652D73706163653A6E';
wwv_flow_api.g_varchar2_table(6) := '6F726D616C7D2E706F706F7665722E746F707B6D617267696E2D746F703A2D313070787D2E706F706F7665722E72696768747B6D617267696E2D6C6566743A313070787D2E706F706F7665722E626F74746F6D7B6D617267696E2D746F703A313070787D';
wwv_flow_api.g_varchar2_table(7) := '2E706F706F7665722E6C6566747B6D617267696E2D6C6566743A2D313070787D2E706F706F7665722D7469746C657B6D617267696E3A303B70616464696E673A38707820313470783B666F6E742D73697A653A313470783B666F6E742D7765696768743A';
wwv_flow_api.g_varchar2_table(8) := '6E6F726D616C3B6C696E652D6865696768743A313870783B6261636B67726F756E642D636F6C6F723A236637663766373B626F726465722D626F74746F6D3A31707820736F6C696420236562656265623B626F726465722D7261646975733A3570782035';
wwv_flow_api.g_varchar2_table(9) := '7078203020307D2E706F706F7665722D636F6E74656E747B70616464696E673A39707820313470787D2E706F706F7665723E2E6172726F772C2E706F706F7665723E2E6172726F773A61667465727B706F736974696F6E3A6162736F6C7574653B646973';
wwv_flow_api.g_varchar2_table(10) := '706C61793A626C6F636B3B77696474683A303B6865696768743A303B626F726465722D636F6C6F723A7472616E73706172656E743B626F726465722D7374796C653A736F6C69647D2E706F706F7665723E2E6172726F777B626F726465722D7769647468';
wwv_flow_api.g_varchar2_table(11) := '3A313170787D2E706F706F7665723E2E6172726F773A61667465727B626F726465722D77696474683A313070783B636F6E74656E743A22227D2E706F706F7665722E746F703E2E6172726F777B6C6566743A3530253B6D617267696E2D6C6566743A2D31';
wwv_flow_api.g_varchar2_table(12) := '3170783B626F726465722D626F74746F6D2D77696474683A303B626F726465722D746F702D636F6C6F723A233939393B626F726465722D746F702D636F6C6F723A7267626128302C302C302C302E3235293B626F74746F6D3A2D313170787D2E706F706F';
wwv_flow_api.g_varchar2_table(13) := '7665722E746F703E2E6172726F773A61667465727B636F6E74656E743A2220223B626F74746F6D3A3170783B6D617267696E2D6C6566743A2D313070783B626F726465722D626F74746F6D2D77696474683A303B626F726465722D746F702D636F6C6F72';
wwv_flow_api.g_varchar2_table(14) := '3A236666667D2E706F706F7665722E72696768743E2E6172726F777B746F703A3530253B6C6566743A2D313170783B6D617267696E2D746F703A2D313170783B626F726465722D6C6566742D77696474683A303B626F726465722D72696768742D636F6C';
wwv_flow_api.g_varchar2_table(15) := '6F723A233939393B626F726465722D72696768742D636F6C6F723A7267626128302C302C302C302E3235297D2E706F706F7665722E72696768743E2E6172726F773A61667465727B636F6E74656E743A2220223B6C6566743A3170783B626F74746F6D3A';
wwv_flow_api.g_varchar2_table(16) := '2D313070783B626F726465722D6C6566742D77696474683A303B626F726465722D72696768742D636F6C6F723A236666667D2E706F706F7665722E626F74746F6D3E2E6172726F777B6C6566743A3530253B6D617267696E2D6C6566743A2D313170783B';
wwv_flow_api.g_varchar2_table(17) := '626F726465722D746F702D77696474683A303B626F726465722D626F74746F6D2D636F6C6F723A233939393B626F726465722D626F74746F6D2D636F6C6F723A7267626128302C302C302C302E3235293B746F703A2D313170787D2E706F706F7665722E';
wwv_flow_api.g_varchar2_table(18) := '626F74746F6D3E2E6172726F773A61667465727B636F6E74656E743A2220223B746F703A3170783B6D617267696E2D6C6566743A2D313070783B626F726465722D746F702D77696474683A303B626F726465722D626F74746F6D2D636F6C6F723A236666';
wwv_flow_api.g_varchar2_table(19) := '667D2E706F706F7665722E6C6566743E2E6172726F777B746F703A3530253B72696768743A2D313170783B6D617267696E2D746F703A2D313170783B626F726465722D72696768742D77696474683A303B626F726465722D6C6566742D636F6C6F723A23';
wwv_flow_api.g_varchar2_table(20) := '3939393B626F726465722D6C6566742D636F6C6F723A7267626128302C302C302C302E3235297D2E706F706F7665722E6C6566743E2E6172726F773A61667465727B636F6E74656E743A2220223B72696768743A3170783B626F726465722D7269676874';
wwv_flow_api.g_varchar2_table(21) := '2D77696474683A303B626F726465722D6C6566742D636F6C6F723A236666663B626F74746F6D3A2D313070787D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(149118810664533188)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'bootstrap.min-popover.css'
,p_mime_type=>'text/css'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A436F70797269676874202863292032303131205365616E2043757361636B0A0A4D49542D4C4943454E53453A0A0A5065726D697373696F6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E';
wwv_flow_api.g_varchar2_table(2) := '7920706572736F6E206F627461696E696E670A6120636F7079206F66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F6E2066696C657320287468650A22536F66747761726522292C20746F2064';
wwv_flow_api.g_varchar2_table(3) := '65616C20696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E670A776974686F7574206C696D69746174696F6E207468652072696768747320746F207573652C20636F70792C206D6F646966';
wwv_flow_api.g_varchar2_table(4) := '792C206D657267652C207075626C6973682C0A646973747269627574652C207375626C6963656E73652C20616E642F6F722073656C6C20636F70696573206F662074686520536F6674776172652C20616E6420746F0A7065726D697420706572736F6E73';
wwv_flow_api.g_varchar2_table(5) := '20746F2077686F6D2074686520536F667477617265206973206675726E697368656420746F20646F20736F2C207375626A65637420746F0A74686520666F6C6C6F77696E6720636F6E646974696F6E733A0A0A5468652061626F766520636F7079726967';
wwv_flow_api.g_varchar2_table(6) := '6874206E6F7469636520616E642074686973207065726D697373696F6E206E6F74696365207368616C6C2062650A696E636C7564656420696E20616C6C20636F70696573206F72207375627374616E7469616C20706F7274696F6E73206F662074686520';
wwv_flow_api.g_varchar2_table(7) := '536F6674776172652E0A0A54484520534F4654574152452049532050524F564944454420224153204953222C20574954484F55542057415252414E5459204F4620414E59204B494E442C0A45585052455353204F5220494D504C4945442C20494E434C55';
wwv_flow_api.g_varchar2_table(8) := '44494E4720425554204E4F54204C494D4954454420544F205448452057415252414E54494553204F460A4D45524348414E544142494C4954592C204649544E45535320464F52204120504152544943554C415220505552504F534520414E440A4E4F4E49';
wwv_flow_api.g_varchar2_table(9) := '4E4652494E47454D454E542E20494E204E4F204556454E54205348414C4C2054484520415554484F5253204F5220434F5059524947485420484F4C444552532042450A4C4941424C4520464F5220414E5920434C41494D2C2044414D41474553204F5220';
wwv_flow_api.g_varchar2_table(10) := '4F54484552204C494142494C4954592C205748455448455220494E20414E20414354494F4E0A4F4620434F4E54524143542C20544F5254204F52204F54484552574953452C2041524953494E472046524F4D2C204F5554204F46204F5220494E20434F4E';
wwv_flow_api.g_varchar2_table(11) := '4E454354494F4E0A574954482054484520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E2054484520534F4654574152452E0A2A2F0A0A2866756E6374696F6E286A517565727950414C297B0A0A20';
wwv_flow_api.g_varchar2_table(12) := '207661722054455854415245415F4944203D20276A71756572792D636174636870617374652D7465787461726561273B0A202066756E6374696F6E2067657454657874417265612829207B0A20202020766172207461203D206A517565727950414C2822';
wwv_flow_api.g_varchar2_table(13) := '23222B54455854415245415F4944293B0A202020206966282074612E6C656E677468203C3D20302029207461203D206A517565727950414C28273C74657874617265612069643D22272B54455854415245415F49442B27223E27292E63737328226C6566';
wwv_flow_api.g_varchar2_table(14) := '74222C222D39393939707822292E6373732822706F736974696F6E222C226162736F6C75746522292E63737328227769647468222C2231707822292E6373732822686569676874222C2231707822292E617070656E64546F2822626F647922293B0A2020';
wwv_flow_api.g_varchar2_table(15) := '202072657475726E2074613B0A20207D0A0A202066756E6374696F6E2077616974466F72506173746544617461282063616C6C6261636B2C206F7074696F6E732C2072657475726E486572655768656E446F6E652029207B0A202020202F2F2074686520';
wwv_flow_api.g_varchar2_table(16) := '22746869732220686572652069732074686520746172676574206F662074686520706173746520636F6D6D616E642C20736F20746865203C696E7075743E0A20202020766172207465787461726561203D20676574546578744172656128293B0A202020';
wwv_flow_api.g_varchar2_table(17) := '2074657874617265612E6373732822646973706C6179222C22626C6F636B22292E76616C282222293B0A2020202076617220746172676574203D206A517565727950414C2874686973293B0A2020202066756E6374696F6E2072657475726E5768656E44';
wwv_flow_api.g_varchar2_table(18) := '6F6E65286576656E7429207B0A2020202020202F2F207468652022746869732220686572652069732074686520746172676574206F6620746865206B65797570206576656E742C20736F20746865203C74657874617265613E0A2020202020206A517565';
wwv_flow_api.g_varchar2_table(19) := '727950414C287465787461726561292E6373732822646973706C6179222C226E6F6E6522293B0A2020202020206A517565727950414C287465787461726561292E756E62696E6428226B6579757022293B0A20202020202076617220706173746564203D';
wwv_flow_api.g_varchar2_table(20) := '206A517565727950414C287465787461726561292E76616C28293B0A2020202020207661722063616C6C6564203D2063616C6C6261636B2E63616C6C28206A517565727950414C28746172676574292C207061737465642C206F7074696F6E7320293B0A';
wwv_flow_api.g_varchar2_table(21) := '2020202020202F2F636F6E736F6C652E6C6F67287061737465642C63616C6C6564293B0A2020202020206A517565727950414C28746172676574292E666F63757328293B0A2020202020206966282063616C6C656420213D3D206E756C6C20290A202020';
wwv_flow_api.g_varchar2_table(22) := '2020207B0A20202020202020206A517565727950414C28746172676574292E76616C28206A517565727950414C28746172676574292E636172657428292E7265706C616365282063616C6C6564202920293B0A2020202020207D0A202020207D0A202020';
wwv_flow_api.g_varchar2_table(23) := '2074657874617265612E666F63757328293B0A2020202074657874617265612E62696E642820226B65797570222C2072657475726E5768656E446F6E6520293B0A20207D0A0A20202F2F207768793F2074686572652773206E6F206C6F676963616C2077';
wwv_flow_api.g_varchar2_table(24) := '617920287468617420692063616E2066696E642920746F2074726170207465787420746861742773206265696E67206472616767656420696E2C20696E636C7564696E67206E65776C696E65730A20202F2F202D2D3E206279207468652074696D652069';
wwv_flow_api.g_varchar2_table(25) := '7420686974732074686520696E7075742C20746865206E65776C696E65732068617665206265656E2073747269707065642C20616E64206265666F7265207468617420706F696E742C2074686572652773206E6F0A20202F2F202020202077617920746F';
wwv_flow_api.g_varchar2_table(26) := '2072657472696576652069742066726F6D20746865206576656E7473206C656164696E6720757020746F2069742C20666F72207468696E6773206472616767656420696E20746861742077657265206E6F74206578706C696369746C790A20202F2F2020';
wwv_flow_api.g_varchar2_table(27) := '20202073657420746F20647261676761626C652028616E6420746875732063616E20626520747261636B6564206E6963656C7929410A20202F2F2077687920646F2069207468696E6B207468697320697320696D706F737369626C653F20626563617573';
wwv_flow_api.g_varchar2_table(28) := '65206576656E20676F6F676C65646F63732073707265616473686565747320646F6E277420737570706F72742069742E20514544203A2D500A202066756E6374696F6E2063616E63656C4472616744726F70286576656E7429207B0A202020206576656E';
wwv_flow_api.g_varchar2_table(29) := '742E73746F7050726F7061676174696F6E28293B200A202020206576656E742E70726576656E7444656661756C7428293B0A2020202072657475726E2066616C73653B0A20207D0A20200A20207661722049535F46495245464F58203D206E756C6C3B0A';
wwv_flow_api.g_varchar2_table(30) := '0A096A517565727950414C2E666E2E63617463687061737465203D2066756E6374696F6E282063616C6C6261636B2C206F7074696F6E732029207B0A202020202F2F636F6E736F6C652E6C6F672863616C6C6261636B2C6F7074696F6E73293B0A090969';
wwv_flow_api.g_varchar2_table(31) := '66282021206F7074696F6E73202029206F7074696F6E73203D207B7D3B0A202020206966282049535F46495245464F58203D3D3D206E756C6C20290A202020207B0A202020202020696628202820226D6F7A696C6C612220696E20242E62726F77736572';
wwv_flow_api.g_varchar2_table(32) := '202920262620242E62726F777365725B226D6F7A696C6C61225D20292049535F46495245464F58203D20747275653B0A202020202020656C7365202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(33) := '202020202020202020202049535F46495245464F58203D2066616C73653B0A202020207D0A202020206966282049535F46495245464F5820290A202020207B0A2020202020202F2F20776F726B7320666F722046697265666F783A0A2020202020207661';
wwv_flow_api.g_varchar2_table(34) := '722070617374654576656E742020203D20226B6579646F776E223B0A202020202020766172207061737465436C6F73757265203D2066756E6374696F6E286576656E7429207B0A20202020202020202F2F20746865202274686973222068657265206973';
wwv_flow_api.g_varchar2_table(35) := '2074686520746172676574206F662074686520706173746520636F6D6D616E642C20736F20746865203C696E7075743E0A202020202020202069662820282028206576656E742E6B6579436F6465203D3D2038362029207C7C2028206576656E742E6B65';
wwv_flow_api.g_varchar2_table(36) := '79436F6465203D3D20313138202920292026262028206576656E742E6D6574614B6579207C7C206576656E742E6374726C4B6579202920290A20202020202020207B202F2F204354524C2D56206F7220434F4D4D414E442D560A20202020202020202020';
wwv_flow_api.g_varchar2_table(37) := '77616974466F725061737465446174612E63616C6C28206A517565727950414C2874686973292C2063616C6C6261636B2C206F7074696F6E7320293B0A20202020202020207D0A2020202020207D0A202020207D0A20202020656C73650A202020207B0A';
wwv_flow_api.g_varchar2_table(38) := '2020202020202F2F20776F726B7320666F72204368726F6D6520616E64205361666172693A0A2020202020207661722070617374654576656E742020203D20227061737465223B0A202020202020766172207061737465436C6F73757265203D2066756E';
wwv_flow_api.g_varchar2_table(39) := '6374696F6E286576656E7429207B0A20202020202020202F2F207468652022746869732220686572652069732074686520746172676574206F662074686520706173746520636F6D6D616E642C20736F20746865203C696E7075743E0A20202020202020';
wwv_flow_api.g_varchar2_table(40) := '2077616974466F725061737465446174612E63616C6C28206A517565727950414C2874686973292C2063616C6C6261636B2C206F7074696F6E7320293B0A2020202020207D0A202020207D0A2020202072657475726E206A517565727950414C28746869';
wwv_flow_api.g_varchar2_table(41) := '73292E65616368282066756E6374696F6E2829207B206A517565727950414C2874686973292E62696E64282070617374654576656E742C207061737465436C6F7375726520293B206A517565727950414C2874686973292E62696E642822647261676F76';
wwv_flow_api.g_varchar2_table(42) := '6572222C63616E63656C4472616744726F70293B207D20293B0A097D3B0A0A7D29286A517565727950414C293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(149120239981534852)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'jquery-catchpaste-1.0.0.js'
,p_mime_type=>'application/javascript'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '47494638396110001000F60000DFDFB82D42F1C1C4C0939CCF6F7DDA5969E25B6BE17985D79EA5CCC7C9BF9EA6CB4557E8485AE74E5FE55262E45867E27783D8AFB4C64052EA7C88D6D2D3BBD2D4BBB4B9C48D97D16473DE6E7BDBB1B6C5BEC1C15464E3';
wwv_flow_api.g_varchar2_table(2) := '3C4FEB8E97D1A3AACA6C7ADB838DD4CACDBD8A94D2364AED7581D999A1CD7380D9ABB1C75D6CE03347EEA7AEC9959ECE3D50EB3045EFCED0BCD7D8B9808BD58892D2D8D9B98792D3A2A9CADBDCB8DDDDB7B2B8C5BABEC3DADAB8C2C5C0A6ACC9D4D5BABF';
wwv_flow_api.g_varchar2_table(3) := 'C3C1CCCEBDC7CABEBCC0C2B6BBC4B0B6C6C9CBBEC3C6C0D6D7BAC5C8BF828DD5ABB1C8A9AFC86170DF6573DE6C79DC717EDA5A69E15666E3B6BBC47F8AD64F60E5D0D2BB495BE78F99D06A78DC4B5CE64154E99CA4CC6371DE384CEC8B95D1727FDA5061';
wwv_flow_api.g_varchar2_table(4) := 'E4B8BDC3BBBFC2CDCFBCADB3C7848FD4939CCF9BA2CD6876DD919AD05F6EDF5F6EE04356E8A0A7CB384BEC3448EDA5ACC92F43EF98A0CD4759E73A4DEC5464E37D88D64C5EE63246EE7B86D74355E96775DD7783D88690D300000000000000000021FF0B';
wwv_flow_api.g_varchar2_table(5) := '4E45545343415045322E30030100000021FE1A43726561746564207769746820616A61786C6F61642E696E666F0021F904090A0000002C000000001000100000078D800082838485851B23292D8685081C242A2E82363A37850A0B1D252B2F8237303D36';
wwv_flow_api.g_varchar2_table(6) := '830206121E863614149600030B138C003D3F3D82040C11B133403F82050D14B1003B4582060E15B137413E82070F16B114423B82080617B13E4344820910181F863B2B164683111920261B30330938083CDD841A21270731341E2C3C098C2250B090E1A1';
wwv_flow_api.g_varchar2_table(7) := '468E60C21206020021F904090A0000002C000000001000100000078C800082838485853B0357580C5B5D1B86003C18550B592D5C245F26854A4F53481114544A5E2A5C844704509B8532850A062390823783484B51B3003A3682044C3DBA464682274DC4';
wwv_flow_api.g_varchar2_table(8) := 'B3141582174E41B33A62CB00491008B35440C1003F17521A862F0244BD8239323449093A3A2F45601BD3834126562C5A1F4A436154905439496AAC10920086AE830002010021F904090A0000002C000000001000100000078980008283848585090A1369';
wwv_flow_api.g_varchar2_table(9) := '065E2C02860043074B060F0E0D0C6A6C85385E676851151543526B0C088322644E3C86682D501B826310669000106D5D822C133EB74A6E6A82324830B7542E2D821E3433B785351747D084606543B7363A83141F66BF853A3DCF8347351F415437373014';
wwv_flow_api.g_varchar2_table(10) := '2F1536854043284342413B402FDC8646091B72F82012AF5AB5400021F904090A0000002C000000001000100000078F800082838485853F281E104E216C4786003917072719675B6A4E4A854123486C1B463D425D0F4F3C835426323886665F4C3B823956';
wwv_flow_api.g_varchar2_table(11) := '289000480C03824A2C09B7116B57826C663AB7141255826F6CC790541D7282163C62B74A6D4B8247283EB74E2A23824660382290700D41832F603922308237F40071851445020922543D33366EE9A020460C0518016F291C14080021F904090A0000002C';
wwv_flow_api.g_varchar2_table(12) := '000000001000100000078C8000828384858514616F651E26113F8600092B716517344813321685443C0A16403333020A25101A8346383C3B864A2013408240631B9000655B6C823E3854B7426A7582614237B7150F4BBC41C790150E06B30230B743765E';
wwv_flow_api.g_varchar2_table(13) := '821509BF907572038236623FD5851E5929028333541433832B27730B0A853646303A822E6E7408B76E383330C2D6AD838202010021F904090A0000002C000000001000100000078980008283848585304039282B1141148600544138634A1F08710A3E85';
wwv_flow_api.g_varchar2_table(14) := '151B604754363A221A5656418336403E2F8642346562823D09AD906F52118254443390003E0768BBB2BF465E0782158FC64D2782304637BF424C64823633D3905D6A6C8337DB85260F4E4786042B54546331534F4A8676776E5C2D5972183C904123690B';
wwv_flow_api.g_varchar2_table(15) := '0CCE94D9F1ABE0A0400021F904090A0000002C000000001000100000078880008283848585373D3F3B3E3B223086003A5444090241423851228536152F15330037153B28494084303D3A86471F4A15823733AC90516641B2369082442C3CBC85331E65C1';
wwv_flow_api.g_varchar2_table(16) := '8433341E82062EC09002312682322A5EBC5A0711821B0E5C17863C4E7C9B825A6B2D7863141516567A5E3885084F7972760E0F6A7B43CF65190F060E204860CC58200021F904090A0000002C000000001000100000078B80008283848586373A46151546';
wwv_flow_api.g_varchar2_table(17) := '368683363346146244443D8526863A14453B1483410D2E8F54413E3382232A4E8F00091644824B242BAE144339820B5C54AE364A63820C2DBE8F3A1FB600675928AE445A1182650B75AE112C4182024B587186161708C6006F507432513D46416C21171B';
wwv_flow_api.g_varchar2_table(18) := '852B204F6A4C4D5E071E618F470831194E5C40F1C395C1418100003B000000000000000000';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(149120938471535492)
,p_plugin_id=>wwv_flow_api.id(149091135813470623)
,p_file_name=>'ajax-loader.gif'
,p_mime_type=>'image/gif'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
