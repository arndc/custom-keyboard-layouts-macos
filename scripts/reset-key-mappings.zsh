#!/usr/bin/env zsh

# Configuration JSON
readonly CONFIG_JSON='{"UserKeyMapping":[]}'

display_help() {
    cat << EOF
Usage: reset-key-mapping.zsh [OPTIONS]

Options:
    -k, --keyboard <keyboardName>   Specify the keyboard name
    -d, --dry-run                   Print the hidutil command without invoking it
    -h, --help                      Show this help message and exit
EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        key="$1"

        case $key in
            -k|--keyboard)
                keyboard="$2"; shift 2  ;;
            -d|--dry-run)
                DRY_RUN=true; shift ;;
            -h|--help)
                display_help; exit 0 ;;
            *) echo "Unknown option: $key\n"; display_help; exit 1 ;;
        esac
    done
}

main() {
    parse_arguments "$@"

    local hidutil_command=""
    local get_command=""

    if [ -z "$keyboard" ]; then
        hidutil_command="hidutil property --set '$CONFIG_JSON'"
        get_command="hidutil property --get 'UserKeyMapping'"
    else
        local -r matchingJson='{"Product": "'$keyboard'"}'
        hidutil_command="hidutil property --matching '$matchingJson' --set '$CONFIG_JSON'"
        get_command="hidutil property --matching '$matchingJson' --get 'UserKeyMapping'"
    fi

    if [ "$DRY_RUN" = true ]; then
        echo "\n-------------------------------------------------------------------------"
        echo "\nDry run, no changes will be made. The following command would be executed:"
        echo "\n$hidutil_command"
    else
        eval "$hidutil_command"
        echo "\n-------------------------------------------------------------------------"
        echo "\Reset completed, check your current configuration by running command:"
        echo "\n$get_command"
    fi

    echo ""
}

main "$@"
