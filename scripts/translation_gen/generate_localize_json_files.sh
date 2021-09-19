#!/bin/bash

echo -e "fetching data from spreadsheets..."
dart run scripts/translation_gen/fetch_json.dart

echo -e "\nspliting key with dot to recover json structure..."
node scripts/translation_gen/split_json_key.js

echo "done!"
exit
