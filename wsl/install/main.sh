#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

update
upgrade

./nvm.sh
./dotnet.sh

./git.sh
./misc_tools.sh
./npm.sh
./vim.sh

./cleanup.sh
