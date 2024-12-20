#!/bin/bash

# Detect the operating system
detect_os() {
  case "$(uname)" in
    "Darwin")
      echo "$HOME/Library/Application Support/Cursor/User/globalStorage/storage.json" # macOS
      ;;
    "Linux")
      echo "$HOME/.config/Cursor/User/globalStorage/storage.json" # Linux
      ;;
    "CYGWIN"*|"MINGW"*)
      echo "$APPDATA\\Cursor\\User\\globalStorage\\storage.json" # Windows
      ;;
    *)
      echo "Unable to detect the operating system!" >&2
      exit 1
      ;;
  esac
}

# Get the JSON file path based on the OS
JSON_FILE=$(detect_os)

# Keys to be updated with new UUID
KEYS=("telemetry.machineId" "telemetry.macMachineId" "telemetry.devDeviceId" "telemetry.sqmId")

# Generate a new UUID
NEW_UUID=$(uuidgen)

# Check if the JSON file exists
if [ ! -f "$JSON_FILE" ]; then
  echo "File $JSON_FILE does not exist!"
  exit 1
fi

# Backup the original JSON file before making changes
cp "$JSON_FILE" "$JSON_FILE.bak"
echo "Backup of the original file created as $JSON_FILE.bak"

# Replace the values of the specified keys with the new UUID
for key in "${KEYS[@]}"; do
  jq --arg key "$key" --arg value "$NEW_UUID" \
    '.[$key] = $value' "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"
done

echo "Replaced the values of the keys with the new UUID: $NEW_UUID"
