{ config, lib, pkgs, ... }:

let
  homeDir = "${config.home-manager.users.${config.nixos.system.user.defaultuser.name}.home.homeDirectory}";
  configDir = "${homeDir}/.config/qalculate";
  configFile = "${configDir}/qalculate-gtk.cfg";
  configContent = ''
    [General]
    allow_multiple_instances=1
    width=800
    always_on_top=0
    enable_tooltips=1
    keep_function_dialog_open=0
    error_info_shown=1
    save_mode_on_exit=1
    save_definitions_on_exit=1
    clear_history_on_exit=0
    history_expression_type=2
    ignore_locale=0
    load_global_definitions=1
    auto_update_exchange_rates=-1
    local_currency_conversion=1
    use_binary_prefixes=0
    check_version=0
    show_keypad=1
    show_history=0
    history_height=0
    minimal_width=500
    show_stack=1
    show_convert=0
    persistent_keypad=0
    minimal_mode=0
    show_bases_keypad=1
    continuous_conversion=1
    set_missing_prefixes=0
    rpn_keys=1
    display_expression_status=1
    parsed_expression_in_resultview=0
    enable_completion=1
    enable_completion2=1
    completion_min=1
    completion_min2=1
    completion_delay=0
    calculate_as_you_type_history_delay=2000
    use_unicode_signs=1
    lower_case_numbers=0
    duodecimal_symbols=0
    exp_display=3
    imaginary_j=0
    base_display=1
    twos_complement=1
    hexadecimal_twos_complement=0
    twos_complement_input=0
    hexadecimal_twos_complement_input=0
    spell_out_logical_operators=1
    caret_as_xor=0
    close_with_esc=-1
    digit_grouping=1
    copy_ascii=0
    copy_ascii_without_units=0
    decimal_comma=-1
    dot_as_separator=-1
    comma_as_separator=0
    vertical_button_padding=-1
    horizontal_button_padding=-1
    use_custom_result_font=0
    use_custom_expression_font=0
    use_custom_status_font=0
    use_custom_keypad_font=0
    use_custom_history_font=0
    use_custom_application_font=0
    multiplication_sign=2
    division_sign=1

    [Mode]
    min_deci=0
    use_min_deci=0
    max_deci=2
    use_max_deci=0
    precision=10
    interval_arithmetic=1
    interval_display=0
    min_exp=-1
    negative_exponents=0
    sort_minus_last=1
    number_fraction_format=0
    complex_number_form=0
    use_prefixes=1
    use_prefixes_for_all_units=0
    use_prefixes_for_currencies=0
    abbreviate_names=1
    all_prefixes_enabled=0
    denominator_prefix_enabled=1
    place_units_separately=1
    auto_post_conversion=3
    mixed_units_conversion=3
    number_base=10
    number_base_expression=10
    read_precision=0
    assume_denominators_nonzero=1
    warn_about_denominators_assumed_nonzero=1
    structuring=1
    angle_unit=1
    functions_enabled=1
    variables_enabled=1
    calculate_functions=1
    calculate_variables=1
    variable_units_enabled=1
    sync_units=1
    unknownvariables_enabled=0
    units_enabled=1
    allow_complex=1
    allow_infinite=1
    indicate_infinite_series=0
    show_ending_zeroes=1
    rounding_mode=0
    approximation=1
    interval_calculation=1
    concise_uncertainty_input=0
    calculate_as_you_type=1
    in_rpn_mode=0
    chain_mode=0
    limit_implicit_multiplication=0
    parsing_mode=0
    simplified_percentage=-1
    spacious=1
    excessive_parenthesis=0
    visible_keypad=0
    short_multiplication=1
    default_assumption_type=4
    default_assumption_sign=0

    [Plotting]
    plot_legend_placement=2
    plot_style=0
    plot_smoothing=0
    plot_display_grid=1
    plot_full_border=0
    plot_min=0
    plot_max=10
    plot_step=1
    plot_sampling_rate=1001
    plot_use_sampling_rate=1
    plot_variable=x
    plot_rows=0
    plot_type=0
    plot_color=1
    plot_linewidth=2
  '';
in

{
  options.nixos = {
    userEnvironment.config.qalculate = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable qalculate config.";
      };
    };
  };

  config = lib.mkIf (config.nixos.userEnvironment.config.qalculate.enable) {
    systemd.services.qalculateConfigChecker = {
      description = "Check and create qalculate config if not present";

      script = ''
        if [ ! -d "${configDir}" ]; then
          mkdir -p "${configDir}"
        fi

        if [ ! -f "${configFile}" ]; then
          echo '${configContent}' > "${configFile}"
        fi

        chown -R ${config.nixos.system.user.defaultuser.name}:users ${configDir}
      '';

      wantedBy = [ "multi-user.target" ];
    };
  };
}
