{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    desktop.desktopEnvironment.plasma6.okular = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable okular.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.desktopEnvironment.plasma6.okular.enable {
    xdg.dataFile."kxmlgui5/gwenview/gwenviewui.rc".text = ''
      <!DOCTYPE gui>
      <gui name="gwenview" translationDomain="kxmlgui6" version="71">
       <MenuBar alreadyVisited="1">
        <Menu alreadyVisited="1" name="file" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;File</text>
         <Action name="file_open"/>
         <Action name="file_open_recent"/>
         <Separator weakSeparator="1"/>
         <Action name="file_save"/>
         <Action name="file_save_as"/>
         <Separator weakSeparator="1"/>
         <Action name="file_print"/>
         <Action name="file_print_preview"/>
         <Separator weakSeparator="1"/>
         <Action name="file_save"/>
         <Action name="file_save_as"/>
         <Separator/>
         <Action name="reload"/>
         <Action name="file_print"/>
         <Action name="file_print_preview"/>
         <Separator/>
         <ActionList name="file_action_list"/>
         <Separator/>
         <Action name="add_folder_to_places"/>
         <Separator/>
         <Action name="quit"/>
         <Separator weakSeparator="1"/>
         <Action name="file_quit"/>
        </Menu>
        <Menu alreadyVisited="1" name="edit" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;Edit</text>
         <Action name="edit_undo"/>
         <Action name="edit_redo"/>
         <Separator weakSeparator="1"/>
         <Action name="edit_cut"/>
         <Action name="edit_copy"/>
         <Action name="edit_paste"/>
         <Separator weakSeparator="1"/>
         <Action name="edit_undo"/>
         <Action name="edit_redo"/>
         <Separator/>
         <Action name="edit_cut"/>
         <Action name="edit_copy"/>
         <Action name="edit_paste"/>
         <Separator/>
         <Action name="edit_tags"/>
         <Menu name="rating" noMerge="1">
          <text translationDomain="gwenview">&amp;Rating</text>
          <Action name="rate_0"/>
          <Action name="rate_1"/>
          <Action name="rate_2"/>
          <Action name="rate_3"/>
          <Action name="rate_4"/>
          <Action name="rate_5"/>
         </Menu>
         <Separator/>
         <Action name="rotate_left"/>
         <Action name="rotate_right"/>
         <Action name="mirror"/>
         <Action name="flip"/>
         <Separator/>
         <Action name="resize"/>
         <Action name="crop"/>
         <Action name="brightness_contrast_gamma"/>
         <Action name="red_eye_reduction"/>
         <Action name="annotate"/>
        </Menu>
        <Menu alreadyVisited="1" name="view" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;View</text>
         <Action name="view_actual_size"/>
         <Separator weakSeparator="1"/>
         <Action name="view_zoom_in"/>
         <Action name="view_zoom_out"/>
         <Separator weakSeparator="1"/>
         <Action name="browse"/>
         <Action name="view"/>
         <Separator/>
         <Action name="view_toggle_spotlightmode"/>
         <Separator/>
         <Action name="fullscreen"/>
         <Separator/>
         <Action name="toggle_slideshow"/>
         <Separator/>
         <Action name="view_actual_size"/>
         <Action name="view_zoom_to_fit"/>
         <Action name="view_zoom_in"/>
         <Action name="view_zoom_out"/>
         <Action name="view_toggle_birdeyeview"/>
         <Separator/>
         <Action name="view_background_colormode_auto"/>
         <Action name="view_background_colormode_light"/>
         <Action name="view_background_colormode_neutral"/>
         <Action name="view_background_colormode_dark"/>
         <Separator/>
         <Action name="sort_by"/>
         <Action name="thumbnail_details"/>
         <Action name="view_toggle_showhiddenfiles"/>
         <Separator/>
         <Action name="toggle_sidebar"/>
         <Separator weakSeparator="1"/>
         <Action name="fullscreen"/>
        </Menu>
        <Menu alreadyVisited="1" name="go" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;Go</text>
         <Action name="go_up"/>
         <Separator weakSeparator="1"/>
         <Action name="go_previous"/>
         <Action name="go_next"/>
         <Separator weakSeparator="1"/>
         <Action name="go_first"/>
         <Action name="go_last"/>
         <Separator weakSeparator="1"/>
         <Action name="go_first"/>
         <Action name="go_previous"/>
         <Action name="go_next"/>
         <Action name="go_last"/>
         <Separator/>
         <Action name="go_up"/>
         <Separator/>
         <Action name="go_start_page"/>
        </Menu>
        <Menu alreadyVisited="1" name="settings" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;Settings</text>
         <Action group="show_merge" name="window-colorscheme-menu"/>
         <Separator weakSeparator="1"/>
         <Action name="options_show_menubar"/>
         <Merge name="StandardToolBarMenuHandler"/>
         <Merge name="KMDIViewActions"/>
         <Action name="options_show_statusbar"/>
         <Separator weakSeparator="1"/>
         <Action name="switch_application_language"/>
         <Action name="options_configure_keybinding"/>
         <Action name="options_configure_toolbars"/>
         <Action name="options_configure"/>
        </Menu>
        <Separator weakSeparator="1"/>
        <Menu name="help" noMerge="1">
         <text translationDomain="kxmlgui6">&amp;Help</text>
         <Action name="help_contents"/>
         <Action name="help_whats_this"/>
         <Action name="open_kcommand_bar"/>
         <Separator weakSeparator="1"/>
         <Action name="help_report_bug"/>
         <Separator weakSeparator="1"/>
         <Action name="help_donate"/>
         <Separator weakSeparator="1"/>
         <Action name="help_about_app"/>
         <Action name="help_about_kde"/>
        </Menu>
       </MenuBar>
       <ToolBar alreadyVisited="1" name="mainToolBar" noMerge="1">
        <text translationDomain="gwenview">Main Toolbar</text>
        <Action name="go_start_page"/>
        <Separator name="separator_0"/>
        <Action name="browse"/>
        <Action name="view"/>
        <Action name="align_with_sidebar"/>
        <Separator name="separator_1"/>
        <Action name="toggle_slideshow"/>
        <Action name="go_previous"/>
        <Action name="go_next"/>
        <Action name="toggle_operations_sidebar"/>
        <Action name="edit_redo"/>
        <Spacer name="spacer_0"/>
        <Action name="file_trash"/>
        <Action name="fullscreen"/>
        <Action name="hamburger_menu"/>
       </ToolBar>
       <ActionProperties scheme="Default">
        <Action name="fullscreen" priority="0"/>
        <Action name="toggle_operations_sidebar" priority="0"/>
        <Action name="file_trash" priority="0"/>
        <Action name="toggle_slideshow" priority="0"/>
        <Action name="edit_redo" priority="0"/>
       </ActionProperties>
      </gui>
    '';
  };
}
