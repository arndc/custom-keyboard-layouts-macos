#!/usr/bin/env zsh

scripts_dir="$(cd "$(dirname "$0")" && cd ../../scripts && pwd)"

display_help() {
        cat <<EOF
Usage: additional-key-mappings.zsh [OPTIONS]

Options:
    --fix-layout-on-external-keyboard <keyboard_name>                   Remap the key above the TAB key with the key right of the left shift key on the given external AZERTY keyboard
    --swap-right-cmd-and-right-opt-on-internal-keyboard                 Remap right command and right option keys on the internal keyboard
    --swap-left-cmd-and-left-opt-on-external-keyboard <keyboard_name>   Remap right command and right option keys on the internal keyboard
    --remove                                                            Remove all key mappings (WARNING: this will reset all key mappings)
    -h, --help                                                          Display this help message
EOF
}

swap_keycode_10_and_keycode_50() {
    local -r keyboard_name="$1"
    # Key code 10 is the key above the tab key
    local -r keycode_10=0x700000035
    # Key code 50 is the key right of the left shift key
    local -r keycode_50=0x700000064

    $scripts_dir/key-remapper.zsh --keyboard "$keyboard_name" "swap:$keycode_10:$keycode_50"
}

swap_right_cmd_and_right_opt_enable() {
    local -r keyboard_name="$1"
    local -r key_right_cmd=0x7000000e7
    local -r key_right_opt=0x7000000e6

    $scripts_dir/key-remapper.zsh --keyboard "$keyboard_name" "swap:$key_right_cmd:$key_right_opt"
}

swap_left_cmd_and_left_opt_enable() {
    local -r keyboard_name="$1"
    local -r key_left_cmd=0x7000000e3
    local -r key_left_opt=0x7000000e2

    $scripts_dir/key-remapper.zsh --keyboard "$keyboard_name" "swap:$key_left_cmd:$key_left_opt"
}

main() {
    local external_keyboard_for_fix=""
    local external_keyboard_for_swap=""
    local fix_layout_on_external_keyboard_enabled=false
    local swap_right_cmd_and_right_opt_enabled=false
    local swap_left_cmd_and_left_opt_enabled=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help) display_help; exit 0;;
            --fix-layout-on-external-keyboard)
                fix_layout_on_external_keyboard_enabled=true; external_keyboard_for_fix="$2"; shift ;;
            --swap-right-cmd-and-right-opt-on-internal-keyboard)
                swap_right_cmd_and_right_opt_enabled=true ;;
            --swap-left-cmd-and-left-opt-on-external-keyboard)
                swap_left_cmd_and_left_opt_enabled=true; external_keyboard_for_swap="$2"; shift ;;
            --remove)
                $scripts_dir/reset-key-mappings.zsh; exit 0 ;;
            *)
                echo "Unknown argument: $1"; exit 1 ;;
        esac
        shift
    done

    if [[ "$fix_layout_on_external_keyboard_enabled" = true ]]; then
        swap_keycode_10_and_keycode_50 "$external_keyboard_for_fix"
    fi

    if [[ "$swap_right_cmd_and_right_opt_enabled" = true ]]; then
        swap_right_cmd_and_right_opt_enabled "Apple Internal Keyboard / Trackpad"
    fi

    if [[ "$swap_left_cmd_and_left_opt_enabled" = true ]]; then
        swap_left_cmd_and_left_opt_enable "$external_keyboard_for_swap"
    fi
}

main "$@"
