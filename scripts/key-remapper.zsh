#!/usr/bin/env zsh

# Default values
PRODUCT="Apple Internal Keyboard / Trackpad"
KEY_MAPPINGS=()
DRY_RUN=false

display_help() {
  cat << EOF
Usage: key-remapper.zsh [OPTIONS] "<action>:<source-keycode>:<destination-keycode>" ...

Options:
  -k, --keyboard <keyboardName>   Specify the keyboard name (default: "$PRODUCT")
  -d, --dry-run                                    Print the hidutil command without invoking it
  -h, --help                                         Show this help message and exit

Actions:
  remap                                              Remap a single key
  swap                                                Swap the mappings of two keys

Example for remapping:
  key-remapper.zsh --keyboard "My Keyboard" "remap:0x7000000e7:0x7000000e6" "remap:0x700000035:0x700000064"

Example for swapping:
  key-remapper.zsh --keyboard "My Keyboard" "swap:0x7000000e7:0x7000000e6" "swap:0x700000035:0x700000064"
EOF
}

parse_arguments() {
  while (( "$#" )); do
    case "$1" in
      -k|--keyboard)
        PRODUCT="$2"; shift 2 ;;
      -d|--dry-run)
        DRY_RUN=true; shift ;;
      -h|--help)
        display_help; exit 0 ;;
      --)
        shift ;;
      *)
        if [[ $1 != -* && $1 != --* ]]; then
          KEYCODE_PAIRS+=("$1")
          shift
        else
          echo "Invalid option: $1" 1>&2; display_help; exit 1
        fi ;;
    esac
  done

  if [ ${#KEYCODE_PAIRS[@]} -eq 0 ]; then
    echo "Error: No source-destination keycode pairs given."
    display_help
    exit 1
  fi
}

validate_keycode() {
  local keycode="$1"
  if [[ $keycode != 0x7* ]]; then
    echo "Error: Keycode $keycode does not start with 0x7."
    exit 1
  fi
}

remap_key() {
  local source="$1"
  local destination="$2"
  KEY_MAPPINGS+=("{\"HIDKeyboardModifierMappingSrc\": $source, \"HIDKeyboardModifierMappingDst\": $destination}")
  echo " - registered remap from $source to $destination"
}

remap_keys() {
  echo "\n preparing to remap keys ...\n --------------------------------------------------"
  for keycode_pair in "${KEYCODE_PAIRS[@]}"; do
    IFS=':' read -r ACTION SOURCE DESTINATION <<< "$keycode_pair"
    if [[ -n "$ACTION" && -n "$SOURCE" && -n "$DESTINATION" ]]; then
      validate_keycode "$SOURCE"
      validate_keycode "$DESTINATION"
      if [ "$ACTION" = "remap" ]; then
        remap_key "$SOURCE" "$DESTINATION"
      elif [ "$ACTION" = "swap" ]; then
        remap_key "$SOURCE" "$DESTINATION"
        remap_key "$DESTINATION" "$SOURCE"
      else
        echo "Unknown action for keycode pair: $keycode_pair"
        display_help
        exit 1
      fi
    else
      echo "Invalid keycode pair: $keycode_pair"
      display_help
      exit 1
    fi
  done
}

main() {
  parse_arguments "$@"
  remap_keys

  local -r matchingJson='{"Product": "'$PRODUCT'"}'

  local configJson='{
    "UserKeyMapping": ['
  for mapping in "${KEY_MAPPINGS[@]}"; do
    configJson+="$mapping,"
  done
  configJson=${configJson%,}
  configJson+=']
  }'


  if [ "$DRY_RUN" = true ]; then
    echo "\n-------------------------------------------------------------------------"
    echo "\nDry run, no changes will be made. The following command would be executed:"
    echo "\nhidutil property --matching '$matchingJson' --set '$configJson'"
  else
    hidutil property --matching "$matchingJson" --set "$configJson"
    echo "\n-------------------------------------------------------------------------"
    echo "\nRemapping completed, check your current configuration by running command:"
    echo "\nhidutil property --matching '$matchingJson' --get"
  fi

  echo ""
}

main "$@"
