#!/bin/bash

# Copyright (C) 2012 Mozilla Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

EXTRACT_RC="$PWD/extract.rc"

install_blobs() {
    mkdir -p download-$1 &&
    (cd download-$1 && shasum -p -c $2) ||
    rm -rf download-$1/fp2-sibon-2.0.0-blobs.* &&
    curl http://code.fairphone.com/downloads/FP2/blobs/fp2-sibon-2.0.0-blobs.tgz -o download-$1/fp2-sibon-2.0.0-blobs.tgz || exit -1 &&
    tar xvfz download-$1/fp2-sibon-2.0.0-blobs.tgz -C download-$1 || exit -1 &&
    BASH_ENV="$EXTRACT_RC" bash download-$1/fp2-sibon-2.0.0-blobs.sh || exit -1
    # Execute the contents of any vendorsetup.sh files we can find in the vendor blobs
    for f in `test -d vendor && find -L vendor -maxdepth 4 -name 'vendorsetup.sh' 2> /dev/null`
    do
         echo "including $f"
         . $f
    done
    unset f
}

CSUM_LIST="$PWD/blob-shasums"

cd ../../.. &&
install_blobs fairphone2 "$CSUM_LIST"
