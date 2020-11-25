#!/bin/bash
# generate sha512 encrypted password
# check version of openssl
version=$(openssl version)
use_python=0
# primitive version check
if [[ $version == *"1.1.0"* ]]; then
    # likely old version of openssl
    # otherwise assume 1.1 or newer
  use_python=1;
fi
if [[ $version == *"2.8.3"* ]]; then
    # likely libreSSL on mac
  use_python=1;
fi
if [[ $use_python == 1 ]]; then
    echo "use python"
    #python3 -c "import crypt; print(crypt.crypt(\"$1\", crypt.mksalt(crypt.METHOD_SHA512)))" > admin.shadow
    python -c "from passlib.hash import sha512_crypt; import getpass; print(sha512_crypt.using(rounds=5000).hash(\"$1\"))" > admin.shadow
else
    echo "use openssl"
   openssl passwd -6 -salt f5f5 $1 > admin.shadow    
fi

# check for python3 
