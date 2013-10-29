#!/bin/bash
# Copyright 2013 Johan Rydberg.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# First we bootstrap the scheduler, which happens to be quite
# cumbersome and somewhat complex.  That's why we do it in a special
# image.

set -x

# We pass the release configuration in an environment variable.  The
# scheduler bootstrap script will pick it up.

gilliam-cli -f scheduler run \
    --env GILLIAM_SERVICE_REGISTRY \
    --env RELEASE="$(cat releases/scheduler.yml)" \
    --release releases/scheduler.yml --service _bootstrap

# Create router formation and scale up store and API.
gilliam-cli -f router launch releases/router.yml
gilliam-cli -f router scale 1 _store=1
gilliam-cli -f router scale 1 api=1

# For each identified router, spawn a router instance.
if [ -n "$ROUTERS" ]; then
  for router in $ROUTERS; do
    gilliam-cli -f router spawn --assign-to $router --port 8080:80 router
  done
fi
