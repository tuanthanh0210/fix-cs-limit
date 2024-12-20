#!/bin/bash
JSON_FILE="/Users/thanhle/Library/Application Support/Cursor/User/globalStorage/storage.json"
KEYS=("telemetry.machineId" "telemetry.macMachineId" "telemetry.devDeviceId" "telemetry.sqmId")
NEW_UUID=$(uuidgen)
if [ ! -f "$JSON_FILE" ]; then
  echo "File $JSON_FILE does not exist!"
  exit 1
fi
cp "$JSON_FILE" "$JSON_FILE.bak"
echo "Backup file $JSON_FILE to $JSON_FILE.bak"
for key in "${KEYS[@]}"; do
  jq --arg key "$key" --arg value "$NEW_UUID" \
    '.[$key] = $value' "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"
done

echo "Replace all values with UUID: $NEW_UUID"
