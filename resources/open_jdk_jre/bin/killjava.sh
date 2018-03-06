#!/usr/bin/env bash
# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013-2016 the original author or authors.
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

# Kill script for use as the parameter of OpenJDK's -XX:OnOutOfMemoryError

set -e

export PATH="$PATH:/home/vcap/app/.java-buildpack/open_jdk_jre/bin"

readonly LOG_DIR=/var/opt/cloudfoundry/app_logs/
readonly HOSTNAME=$(hostname)
readonly PID=$(pidof java)

echo "
$(date)

Process Status (Before)
=======================
$(ps -ef)

Process Tree (Before)
=====================
$(pstree)

ulimit (Before)
===============
$(ulimit -a)

Free Disk Space (Before)
========================
$(df -h)

Java Class Historgram
=====================
$(jmap -histo "${PID}")

Java Threads
============
$(kill -3 "${PID}")
" >> "${LOG_DIR}/${HOSTNAME}.crash"

pkill -9 -f .*-XX:OnOutOfMemoryError=.*killjava.*

echo "
Process Status (After)
======================
$(ps -ef)

Process Tree (After)
====================
$(pstree)

ulimit (After)
==============
$(ulimit -a)

Free Disk Space (After)
=======================
$(df -h)

" >> "${LOG_DIR}/${HOSTNAME}.crash"
