#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
        && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'

update

print_in_purple "\n   .NET Core SDK\n\n"

install_package ".NET Core SDK" "dotnet-sdk-2.0.2"

