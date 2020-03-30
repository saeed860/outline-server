#!/bin/bash -eu
#
# Copyright 2018 The Outline Authors
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

readonly CSC_LINK=${CSC_LINK:-unset}

if [ "$CSC_LINK" == "unset" ]; then
  echo "must specify CSC_LINK"
  exit 1
fi

yarn do server_manager/electron_app/build
yarn do server_manager/electron_app/write_environment_variables

# Produces dmg and zip images. The latter is required for auto-update.
$ROOT_DIR/src/server_manager/node_modules/.bin/electron-builder \
  --projectDir=build/server_manager/electron_app/static \
  --config.asarUnpack=server_manager/web_app/images \
  --publish=never \
  --config.publish.provider=generic \
  --config.publish.url=https://raw.githubusercontent.com/Jigsaw-Code/outline-releases/master/manager/ \
  --mac default \
  --config.mac.icon=icons/mac/icon.icns \
  --config.artifactName='Outline-Manager.${ext}'
