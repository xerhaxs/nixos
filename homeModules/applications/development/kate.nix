{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.development.kate = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kate.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.enable {
    programs.plasma.configFile."katerc" = {
      "General" = {
        "Allow Tab Scrolling".value = true;
        "Auto Hide Tabs".value = false;
        "Close After Last".value = true;
        "Close documents with window".value = true;
        "Cycle To First Tab".value = true;
        "Days Meta Infos".value = 30;
        "Diagnostics Limit".value = 12000;
        "Diff Show Style".value = 0;
        "Elide Tab Text".value = false;
        "Enable Context ToolView".value = false;
        "Expand Tabs".value = false;
        "Icon size for left and right sidebar buttons".value = 32;
        "Modified Notification".value = false;
        "Mouse back button action".value = 0;
        "Mouse forward button action".value = 0;
        "Open New Tab To The Right Of Current".value = false;
        "Output History Limit".value = 100;
        "Output With Date".value = false;
        "PinnedDocuments".value = "";
        "Recent File List Entry Count".value = 10;
        "Restore Window Configuration".value = true;
        "SDI Mode".value = false;
        "Save Meta Infos".value = true;
        "Show Full Path in Title".value = false;
        "Show Menu Bar".value = true;
        "Show Status Bar".value = true;
        "Show Symbol In Navigation Bar".value = true;
        "Show Tab Bar".value = true;
        "Show Tabs Close Button".value = true;
        "Show Url Nav Bar".value = true;
        "Show output view for message type".value = 1;
        "Show text for left and right sidebar".value = false;
        "Show welcome view for new window".value = false;
        "Startup Session".value = "new";
        "Stash new unsaved files".value = true;
        "Stash unsaved file changes".value = false;
        "Sync section size with tab positions".value = false;
        "Tab Double Click New Document".value = true;
        "Tab Middle Click Close Document".value = true;
        "Tabbar Tab Limit".value = 0;
      };

      "KTextEditor Document" = {
        "Allow End of Line Detection".value = true;
        "Auto Detect Indent".value = true;
        "Auto Reload If Any External Changes Occurs".value = false;
        "Auto Reload If State Is In Version Control".value = true;
        "Auto Save".value = false;
        "Auto Save Interval".value = 0;
        "Auto Save On Focus Out".value = false;
        "BOM".value = false;
        "Backup Local".value = false;
        "Backup Prefix".value = "";
        "Backup Remote".value = false;
        "Backup Suffix".value = "~";
        "Camel Cursor".value = true;
        "Encoding".value = "UTF-8";
        "End of Line".value = 0;
        "Indent On Backspace".value = true;
        "Indent On Tab".value = true;
        "Indent On Text Paste".value = true;
        "Indentation Mode".value = "normal";
        "Indentation Width".value = 2;
        "Keep Extra Spaces".value = false;
        "Line Length Limit".value = 10000;
        "Newline at End of File".value = true;
        "On-The-Fly Spellcheck".value = false;
        "Overwrite Mode".value = false;
        "PageUp/PageDown Moves Cursor".value = false;
        "Remove Spaces".value = 1;
        "ReplaceTabsDyn".value = true;
        "Show Spaces".value = 0;
        "Show Tabs".value = true;
        "Smart Home".value = true;
        "Swap File Mode".value = 1;
        "Swap Sync Interval".value = 15;
        "Tab Handling".value = 2;
        "Tab Width".value = 4;
        "Trailing Marker Size".value = 1;
        "Use Editor Config".value = true;
        "Word Wrap".value = false;
        "Word Wrap Column".value = 80;
      };

      "KTextEditor Renderer" = {
        "Animate Bracket Matching".value = false;
        "Auto Color Theme Selection".value = true;
        "Color Theme".value = "Catppuccin ${osConfig.nixos.theme.catppuccin.flavor}";
        "Line Height Multiplier".value = 1;
        "Show Indentation Lines".value = true;
        "Show Whole Bracket Expression".value = true;
        "Text Font".value = "Hack,10,-1,7,400,0,0,0,0,0,0,0,0,0,0,1";
        "Text Font Features".value = "";
        "Word Wrap Marker".value = false;
      };

      "KTextEditor View" = {
        "Allow Mark Menu".value = true;
        "Auto Brackets".value = true;
        "Auto Center Lines".value = 0;
        "Auto Completion".value = true;
        "Auto Completion Preselect First Entry".value = true;
        "Backspace Remove Composed Characters".value = false;
        "Bookmark Menu Sorting".value = 0;
        "Bracket Match Preview".value = true;
        "Cycle Through Bookmarks".value = true;
        "Default Mark Type".value = 1;
        "Disable bracket match highlight if inactive".value = false;
        "Disable current line highlight if inactive".value = false;
        "Dynamic Word Wrap".value = true;
        "Dynamic Word Wrap Align Indent".value = 80;
        "Dynamic Word Wrap At Static Marker".value = false;
        "Dynamic Word Wrap Indicators".value = 0;
        "Dynamic Wrap not at word boundaries".value = false;
        "Enable Accessibility".value = true;
        "Enable Tab completion".value = false;
        "Enter To Insert Completion".value = true;
        "Fold First Line".value = false;
        "Folding Bar".value = true;
        "Folding Preview".value = true;
        "Hide cursor if inactive".value = false;
        "Icon Bar".value = true;
        "Input Mode".value = 0;
        "Keyword Completion".value = true;
        "Line Modification".value = true;
        "Line Numbers".value = true;
        "Max Clipboard History Entries".value = 20;
        "Maximum Search History Size".value = 100;
        "Mouse Paste At Cursor Position".value = false;
        "Multiple Cursor Modifier".value = 134217728;
        "Persistent Selection".value = false;
        "Scroll Bar Marks".value = true;
        "Scroll Bar Mini Map All".value = true;
        "Scroll Bar Mini Map Width".value = 60;
        "Scroll Bar MiniMap".value = true;
        "Scroll Bar Preview".value = true;
        "Scroll Past End".value = false;
        "Search/Replace Flags".value = 140;
        "Shoe Line Ending Type in Statusbar".value = false;
        "Show Documentation With Completion".value = true;
        "Show File Encoding".value = true;
        "Show Folding Icons On Hover Only".value = true;
        "Show Line Count".value = true;
        "Show Scrollbars".value = 0;
        "Show Statusbar Dictionary".value = true;
        "Show Statusbar Highlighting Mode".value = true;
        "Show Statusbar Input Mode".value = true;
        "Show Statusbar Line Column".value = true;
        "Show Statusbar Tab Settings".value = true;
        "Show Word Count".value = true;
        "Smart Copy Cut".value = true;
        "Statusbar Line Column Compact Mode".value = true;
        "Text Drag And Drop".value = true;
        "User Sets Of Chars To Enclose Selection".value = "";
        "Vi Input Mode Steal Keys".value = false;
        "Vi Relative Line Numbers".value = false;
        "Word Completion".value = true;
        "Word Completion Minimal Word Length".value = 3;
        "Word Completion Remove Tail".value = true;
      };

      "Konsole" = {
        "AutoSyncronize".value = true;
        "AutoSyncronizeMode".value = 0;
        "KonsoleEscKeyBehaviour".value = true;
        "KonsoleEscKeyExceptions".value = "vi,vim,nvim,git";
        "RemoveExtension".value = false;
        "RunPrefix".value = "";
        "SetEditor".value = false;
      };

      "filetree" = {
        "editShade".value = "110,80,65";
        "listMode".value = false;
        "middleClickToClose".value = false;
        "shadingEnabled".value = true;
        "showCloseButton".value = false;
        "showFullPathOnRoots".value = false;
        "showToolbar".value = true;
        "sortRole".value = 0;
        "viewShade".value = "98,68,134";
      };

      "lspclient" = {
        "AllowedServerCommandLines".value = "";
        "AutoHover".value = true;
        "AutoImport".value = true;
        "BlockedServerCommandLines".value = "";
        "CompletionDocumentation".value = true;
        "CompletionParens".value = true;
        "Diagnostics".value = true;
        "FormatOnSave".value = false;
        "HighlightGoto".value = true;
        "HighlightSymbol".value = true;
        "IncrementalSync".value = false;
        "InlayHints".value = false;
        "Messages".value = true;
        "ReferencesDeclaration".value = true;
        "SemanticHighlighting".value = true;
        "ServerConfiguration".value = "";
        "ShowCompletions".value = true;
        "SignatureHelp".value = true;
        "SymbolDetails".value = false;
        "SymbolExpand".value = true;
        "SymbolSort".value = false;
        "SymbolTree".value = true;
        "TypeFormatting".value = true;
      };
    };
    
    xdg.dataFile."kxmlgui5/kate/kateui.rc".text = ''
      <!DOCTYPE gui>
      <gui name="kate" translationDomain="kate" version="110">
       <MenuBar alreadyVisited="1">
        <Menu alreadyVisited="1" name="file" noMerge="1">
         <text translationDomain="kate">&amp;File</text>
         <Action name="file_new"/>
         <Action name="view_new_view"/>
         <DefineGroup name="new_merge"/>
         <Separator/>
         <Action name="file_open"/>
         <Action name="file_open_recent"/>
         <Action name="file_open_with"/>
         <DefineGroup name="open_merge"/>
         <Separator/>
         <DefineGroup name="save_merge"/>
         <Action name="file_save_all"/>
         <Separator/>
         <DefineGroup name="revert_merge"/>
         <Action name="file_reload_all"/>
         <DefineGroup name="print_merge"/>
         <DefineGroup name="export_merge"/>
         <Separator/>
         <Action name="file_close"/>
         <Action name="file_close_other"/>
         <Action name="file_close_all"/>
         <Action name="file_close_orphaned"/>
         <Action name="file_close_window"/>
         <DefineGroup name="close_merge"/>
         <Separator/>
         <Menu name="file_file_actions" noMerge="1">
          <text translationDomain="kate">File Act&amp;ions</text>
          <Action name="file_rename"/>
          <Action name="file_delete"/>
          <Action name="file_compare"/>
          <Separator/>
          <Action name="file_copy_filepath"/>
          <Action name="file_copy_filename"/>
          <Action name="file_open_containing_folder"/>
          <Action name="file_properties"/>
         </Menu>
         <Separator/>
         <Action name="file_quit"/>
        </Menu>
        <Menu alreadyVisited="1" name="edit" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;Edit</text>
         <DefineGroup name="edit_undo_merge"/>
         <Separator group="edit_undo_merge"/>
         <DefineGroup name="edit_paste_merge"/>
         <Separator/>
         <DefineGroup name="edit_select_merge"/>
         <Separator/>
         <DefineGroup name="edit_find_merge"/>
         <Separator/>
        </Menu>
        <Menu append="before_view" name="selection" noMerge="1">
         <text translationDomain="kate">Sele&amp;ction</text>
        </Menu>
        <Menu alreadyVisited="1" name="view" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;View</text>
         <Menu name="view-split" noMerge="1">
          <text translationDomain="kate">Split View</text>
          <Action name="go_prev_split_view"/>
          <Action name="go_next_split_view"/>
          <Separator/>
          <Action name="go_left_split_view"/>
          <Action name="go_right_split_view"/>
          <Action name="go_upward_split_view"/>
          <Action name="go_downward_split_view"/>
          <Separator/>
          <Action name="view_split_vert"/>
          <Action name="view_split_horiz"/>
          <Action name="view_split_vert_move_doc"/>
          <Action name="view_split_horiz_move_doc"/>
          <Action name="view_split_toggle"/>
          <Separator/>
          <Action name="view_close_current_space"/>
          <Action name="view_close_others"/>
          <Separator/>
          <Action name="view_hide_others"/>
          <Action name="toggle_active_viewspace_scroll_sync"/>
          <Separator/>
          <Action name="view_split_move_left"/>
          <Action name="view_split_move_right"/>
          <Action name="view_split_move_up"/>
          <Action name="view_split_move_down"/>
         </Menu>
         <Separator/>
         <Merge name="kate_mdi_view_actions"/>
         <Action name="view_windows"/>
         <Separator/>
         <DefineGroup name="view_operations"/>
         <Separator weakSeparator="1"/>
         <Action name="fullscreen"/>
        </Menu>
        <Menu alreadyVisited="1" name="go" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;Go</text>
         <Action name="view_quick_open"/>
         <DefineGroup name="view_switch_tab"/>
         <Separator/>
         <DefineGroup name="edit_goto"/>
         <DefineGroup name="switch_document"/>
         <Separator/>
         <Action name="view_next_tab"/>
         <Action name="view_prev_tab"/>
         <Separator/>
         <Action name="view_history_back"/>
         <Action name="view_history_forward"/>
         <Separator/>
         <DefineGroup name="edit_goto2"/>
        </Menu>
        <DefineGroup name="after_view"/>
        <Merge/>
        <DefineGroup name="before_tools"/>
        <Action name="sessions"/>
        <Menu alreadyVisited="1" name="tools" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;Tools</text>
         <Action name="tools_external"/>
         <Separator/>
         <DefineGroup name="tools_operations"/>
         <DefineGroup name="tools_konsole"/>
         <Separator group="tools_konsole"/>
         <DefineGroup name="tools_snippet"/>
         <Separator group="tools_snippet"/>
         <DefineGroup name="tools_operations2"/>
         <Separator group="tools_operations2"/>
         <DefineGroup name="tools_git_blame"/>
         <Separator group="tools_git_blame"/>
         <DefineGroup name="tools_spelling"/>
         <DefineGroup name="tools_operations3"/>
         <Merge name="tools_diagnosticsview">
          <text translationDomain="kate">Diagnostics View</text>
         </Merge>
        </Menu>
        <Menu alreadyVisited="1" name="settings" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;Settings</text>
         <Action name="settings_style"/>
         <Action group="color" name="colorscheme_menu"/>
         <DefineGroup name="color"/>
         <Separator weakSeparator="1"/>
         <Action name="options_show_menubar"/>
         <Merge name="StandardToolBarMenuHandler"/>
         <Merge name="KMDIViewActions"/>
         <Action name="options_show_statusbar"/>
         <Action append="show_merge" name="settings_show_tab_bar"/>
         <Action append="show_merge" name="settings_show_full_path"/>
         <Action append="show_merge" name="settings_show_url_nav_bar"/>
         <Separator weakSeparator="1"/>
         <Action name="switch_application_language"/>
         <Action name="options_configure_keybinding"/>
         <Action name="options_configure_toolbars"/>
         <Action name="options_configure"/>
        </Menu>
        <Separator weakSeparator="1"/>
        <Menu alreadyVisited="1" name="help" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;Help</text>
         <Action name="help_contents"/>
         <Action name="help_whats_this"/>
         <Action name="open_kcommand_bar"/>
         <Separator weakSeparator="1"/>
         <Action name="help_welcome_page"/>
         <Action name="help_report_bug"/>
         <Separator weakSeparator="1"/>
         <Action name="help_donate"/>
         <Separator weakSeparator="1"/>
         <Action name="help_about_app"/>
         <Action name="help_about_kde"/>
        </Menu>
       </MenuBar>
       <ToolBar alreadyVisited="1" name="mainToolBar" noMerge="1">
        <text translationDomain="kate">Main Toolbar</text>
        <Action name="file_new"/>
        <Action name="file_open"/>
        <Action name="file_copy_filename"/>
        <Action name="file_copy_filepath"/>
        <Separator name="separator_0"/>
        <DefineGroup name="file_operations"/>
        <DefineGroup name="print_merge"/>
        <DefineGroup name="edit_operations"/>
        <DefineGroup name="find_operations"/>
        <DefineGroup name="zoom_operations"/>
       </ToolBar>
       <Merge/>
       <ToolBar name="hamburgerBar" noMerge="1">
        <text translationDomain="kate">Hamburger Menu Toolbar</text>
        <Spacer/>
        <Action name="hamburger_menu"/>
       </ToolBar>
       <Menu name="viewspace_popup" noMerge="1">
        <Action name="view_split_vert"/>
        <Action name="view_split_horiz"/>
        <Separator/>
        <Action name="view_close_current_space"/>
        <Separator/>
        <Action name="go_back"/>
        <Action name="go_forward"/>
        <Action name="doc_list"/>
        <Menu name="viewspace_popup_statusbar" noMerge="1">
         <text translationDomain="kate">&amp;Status Bar Items</text>
         <Action name="show_cursor_pos"/>
         <Action name="show_char_count"/>
         <Action name="show_insert_mode"/>
         <Action name="show_select_mode"/>
         <Action name="show_encoding"/>
         <Action name="show_doc_name"/>
        </Menu>
       </Menu>
       <ActionProperties scheme="Default">
        <Action name="file_new" priority="128"/>
        <Action name="file_open" priority="128"/>
       </ActionProperties>
      </gui>
    '';

    xdg.dataFile."kxmlgui5/katepart/katepart5ui.rc".text = ''
      <!DOCTYPE gui>
      <gui name="KatePartView" translationDomain="ktexteditor6" version="111">
       <MenuBar>
        <Menu name="file" noMerge="1">
         <text translationDomain="ktexteditor6">&amp;File</text>
         <Action group="save_merge" name="file_save"/>
         <Action group="save_merge" name="file_save_as"/>
         <Action group="save_merge" name="file_save_as_with_encoding"/>
         <Action group="save_merge" name="file_save_copy_as"/>
         <Action group="revert_merge" name="file_reload"/>
         <Menu group="print_merge" name="file_export" noMerge="1">
          <text translationDomain="ktexteditor6">&amp;Print/Export</text>
          <Action group="print_merge" name="file_print"/>
          <Action group="print_merge" name="file_print_preview"/>
          <Action group="print_merge" name="file_export_html"/>
         </Menu>
        </Menu>
        <Menu name="edit" noMerge="1">
         <text translationDomain="ktexteditor6">&amp;Edit</text>
         <Action group="edit_undo_merge" name="edit_undo"/>
         <Action group="edit_undo_merge" name="edit_redo"/>
         <Separator group="edit_undo_merge"/>
         <Action group="edit_paste_merge" name="edit_cut"/>
         <Action group="edit_paste_merge" name="edit_copy"/>
         <Action group="edit_paste_merge" name="edit_copy_html"/>
         <Action group="edit_paste_merge" name="edit_copy_file_location"/>
         <Action group="edit_paste_merge" name="edit_paste"/>
         <Action group="edit_paste_merge" name="edit_paste_selection"/>
         <Action group="edit_paste_merge" name="edit_paste_from_file"/>
         <Action group="edit_paste_merge" name="edit_swap_with_clipboard"/>
         <Action group="edit_paste_merge" name="clipboard_history_paste"/>/>
          <Separator group="edit_select_merge"/>
         <Action group="edit_select_merge" name="view_input_modes"/>
         <Action group="edit_select_merge" name="set_insert"/>
         <Action group="edit_select_merge" name="tools_toggle_write_lock"/>
         <Separator group="edit_select_merge"/>
         <Action group="edit_find_merge" name="edit_find"/>
         <Menu group="edit_find_merge" name="edit_find_menu" noMerge="1">
          <text translationDomain="ktexteditor6">Find Variants</text>
          <Action group="edit_find_merge" name="edit_find_next"/>
          <Action group="edit_find_merge" name="edit_find_prev"/>
          <Action group="edit_find_merge" name="edit_find_selected"/>
          <Action group="edit_find_merge" name="edit_find_selected_backwards"/>
         </Menu>
         <Action group="edit_find_merge" name="edit_replace"/>
         <Separator group="edit_find_merge"/>
        </Menu>
        <Menu name="selection" noMerge="1">
         <text translationDomain="ktexteditor6">Selection</text>
         <Action group="edit_selection" name="edit_select_all"/>
         <Action group="edit_selection" name="edit_deselect"/>
         <Action group="edit_selection" name="set_verticalSelect"/>
         <Separator group="edit_selection"/>
         <Action group="edit_selection" name="tools_toggle_comment"/>
         <Action group="edit_selection" name="tools_join_lines"/>
         <Menu group="edit_selection" name="capitalization" noMerge="1">
          <text translationDomain="ktexteditor6">Capitalization</text>
          <Action group="edit_selection" name="tools_uppercase"/>
          <Action group="edit_selection" name="tools_lowercase"/>
          <Action group="edit_selection" name="tools_capitalize"/>
         </Menu>
         <Separator group="edit_selection"/>
         <Action group="edit_selection" name="tools_cleanIndent"/>
         <Action group="edit_selection" name="tools_convertTabsSpaces"/>
         <Action group="edit_selection" name="tools_convertSpacesTabs"/>
         <Action group="edit_selection" name="tools_formatIndent"/>
         <Action group="edit_selection" name="tools_alignOn"/>
         <Action group="edit_selection" name="tools_apply_wordwrap"/>
         <Separator group="edit_selection"/>
         <Action group="edit_selection" name="edit_create_multi_cursor_up"/>
         <Action group="edit_selection" name="edit_create_multi_cursor_down"/>
         <Action group="edit_selection" name="edit_create_multi_cursor_from_sel"/>
         <Action group="edit_selection" name="edit_find_multicursor_next_occurrence"/>
         <Action group="edit_selection" name="edit_find_multicursor_all_occurrences"/>
        </Menu>
        <Menu name="view" noMerge="1">
         <text translationDomain="ktexteditor6">&amp;View</text>
         <Action group="view_operations" name="view_inc_font_sizes"/>
         <Action group="view_operations" name="view_dec_font_sizes"/>
         <Action group="view_operations" name="view_reset_font_sizes"/>
         <Separator group="view_operations"/>
         <Menu group="view_operations" name="view_menu_word_wrap" noMerge="1">
          <text translationDomain="ktexteditor6">Word Wrap</text>
          <Action group="view_operations" name="view_dynamic_word_wrap"/>
          <Action group="view_operations" name="dynamic_word_wrap_indicators"/>
          <Action group="view_operations" name="view_static_word_wrap"/>
          <Action group="view_operations" name="view_word_wrap_marker"/>
         </Menu>
         <Menu group="view_operations" name="view_menu_borders" noMerge="1">
          <text translationDomain="ktexteditor6">Borders</text>
          <Action group="view_operations" name="view_border"/>
          <Action group="view_operations" name="view_line_numbers"/>
          <Action group="view_operations" name="view_scrollbar_marks"/>
          <Action group="view_operations" name="view_scrollbar_minimap"/>
          <Action group="view_operations" name="view_scrollbar_minimap_all"/>
         </Menu>
         <Separator group="view_operations"/>
         <Menu group="view_operations" name="codefolding" noMerge="1">
          <text translationDomain="ktexteditor6">&amp;Code Folding</text>
          <Action group="view_operations" name="view_folding_markers"/>
          <Separator group="view_operations"/>
          <Action group="view_operations" name="folding_toggle_current"/>
          <Action group="view_operations" name="folding_toggle_in_current"/>
          <Action group="view_operations" name="folding_expandall"/>
          <Separator group="view_operations"/>
          <Action group="view_operations" name="folding_toplevel"/>
          <Action group="view_operations" name="folding_expandtoplevel"/>
         </Menu>
         <Separator group="view_operations"/>
         <Action group="view_operations" name="view_auto_reload"/>
         <Action group="view_operations" name="view_non_printable_spaces"/>
         <Action group="edit_select_merge" name="force_rtl_direction"/>
         <Action group="view_operations" name="view_word_count"/>
        </Menu>
        <Menu name="go" noMerge="1">
         <text translationDomain="ktexteditor6">&amp;Go</text>
         <Action group="edit_goto" name="go_goto_line"/>
         <Separator group="edit_goto"/>
         <Action group="edit_goto2" name="Previous Editing Line"/>
         <Action group="edit_goto2" name="Next Editing Line"/>
         <Separator group="edit_goto2"/>
         <Action group="edit_goto2" name="modified_line_up"/>
         <Action group="edit_goto2" name="modified_line_down"/>
         <Separator group="edit_goto2"/>
         <Action group="edit_goto2" name="to_matching_bracket"/>
         <Action group="edit_goto2" name="select_matching_bracket"/>
         <Separator group="edit_goto2"/>
         <Action group="edit_goto2" name="bookmarks"/>
        </Menu>
        <Menu name="tools" noMerge="1">
         <text translationDomain="ktexteditor6">&amp;Tools</text>
         <Action group="tools_operations" name="tools_mode"/>
         <Action group="tools_operations" name="tools_highlighting"/>
         <Action group="tools_operations" name="tools_indentation"/>
         <Separator group="tools_operations"/>
         <Action group="tools_operations" name="set_encoding"/>
         <Action group="tools_operations" name="add_bom"/>
         <Action group="tools_operations" name="set_eol"/>
         <Separator group="tools_operations"/>
         <Action group="tools_operations2" name="tools_scripts"/>
         <Separator group="tools_operations2"/>
         <Action group="tools_operations2" name="switch_to_cmd_line"/>
         <Separator group="tools_operations2"/>
         <Action group="tools_operations2" name="tools_invoke_code_completion"/>
         <Menu group="tools_operations2" name="wordcompletion" noMerge="1">
          <text translationDomain="ktexteditor6">Word Completion</text>
          <Action name="doccomplete_fw"/>
          <Action name="doccomplete_bw"/>
          <Action name="doccomplete_sh"/>
         </Menu>
         <Separator group="tools_operations2"/>
         <Menu group="tools_spelling" name="spelling" noMerge="1">
          <text translationDomain="ktexteditor6">Spelling</text>
          <Action group="tools_spelling" name="tools_toggle_automatic_spell_checking"/>
          <Action group="tools_spelling" name="tools_spelling"/>
          <Action group="tools_spelling" name="tools_spelling_from_cursor"/>
          <Action group="tools_spelling" name="tools_spelling_selection"/>
          <Action group="tools_spelling" name="tools_change_dictionary"/>
          <Action group="tools_spelling" name="tools_clear_dictionary_ranges"/>
         </Menu>
         <Separator group="tools_operations2"/>
         <Menu group="tools_speech" name="speech" noMerge="1">
          <text translationDomain="ktexteditor6">Text to Speech</text>
          <Action group="tools_speech" name="tools_speech_say"/>
          <Action group="tools_speech" name="tools_speech_stop"/>
          <Action group="tools_speech" name="tools_speech_pause"/>
          <Action group="tools_speech" name="tools_speech_resume"/>
         </Menu>
        </Menu>
        <Menu name="settings" noMerge="1">
         <text translationDomain="ktexteditor6">&amp;Settings</text>
         <Action group="color" name="view_schemas"/>
         <Action group="configure_merge" name="set_confdlg"/>
        </Menu>
       </MenuBar>
       <Menu name="ktexteditor_popup" noMerge="1">
        <Action group="popup_operations" name="spelling_suggestions"/>
        <Separator group="popup_operations"/>
        <Action group="popup_operations" name="edit_cut"/>
        <Action group="popup_operations" name="edit_copy"/>
        <Action group="popup_operations" name="edit_copy_html"/>
        <Action group="popup_operations" name="edit_paste"/>
        <Action group="popup_operations" name="edit_paste_selection"/>
        <Action group="popup_operations" name="edit_swap_with_clipboard"/>
        <Action group="popup_operations" name="text_screenshot_selection"/>
        <Separator group="popup_operations"/>
        <Action group="popup_operations" name="tools_scripts_Editing"/>
        <Separator group="popup_operations"/>
        <Action group="popup_operations" name="bookmarks"/>
        <Separator group="popup_operations"/>
        <Action group="popup_operations" name="tools_create_snippet"/>
        <Separator group="popup_operations"/>
        <Menu group="popup_operations" name="speech" noMerge="1">
         <text translationDomain="ktexteditor6">Text to Speech</text>
         <Action group="popup_operations" name="tools_speech_stop"/>
         <Action group="popup_operations" name="tools_speech_pause"/>
         <Action group="popup_operations" name="tools_speech_resume"/>
        </Menu>
        <Action group="popup_operations" name="tools_speech_say"/>
       </Menu>
       <ToolBar name="mainToolBar" noMerge="1">
        <text translationDomain="ktexteditor6">Main Toolbar</text>
        <Action group="file_operations" name="file_save"/>
        <Action group="file_operations" name="file_save_as"/>
        <Action group="edit_operations" name="edit_undo"/>
        <Action group="edit_operations" name="edit_redo"/>
       </ToolBar>
      </gui>
    '';
  };
}
