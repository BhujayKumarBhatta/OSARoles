#!/usr/bin/env bash

# Copyright 2016, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# WARNING:
# This file is use by all OpenStack-Ansible roles for testing purposes.
# Any changes here will affect all OpenStack-Ansible role repositories
# with immediate effect.

# PURPOSE:
# This script executes a test Ansible playbook for the purpose of
# functionally testing the role. It supports a convergence test,
# check mode and an idempotence test.

## Shell Opts ----------------------------------------------------------------

set -e

## Vars ----------------------------------------------------------------------

export WORKING_DIR=${WORKING_DIR:-$(pwd)}
export ROLE_NAME=${ROLE_NAME:-''}

export COMMON_TESTS_PATH="${WORKING_DIR}/tests/common"

## Functions -----------------------------------------------------------------

function execute_ansible_playbook {

  export ANSIBLE_CLI_PARAMETERS="${ANSIBLE_PARAMETERS} -e @${ANSIBLE_OVERRIDES}"
  CMD_TO_EXECUTE="ansible-playbook ${TEST_PLAYBOOK} $@ ${ANSIBLE_CLI_PARAMETERS}"

  echo "Executing: ${CMD_TO_EXECUTE}"
  echo "With:"
  echo "    ANSIBLE_INVENTORY: ${ANSIBLE_INVENTORY}"
  echo "    ANSIBLE_LOG_PATH: ${ANSIBLE_LOG_PATH}"

  ${CMD_TO_EXECUTE}

}

function gate_job_exit_tasks {
  source "${COMMON_TESTS_PATH}/test-log-collect.sh"
}

## Main ----------------------------------------------------------------------

# Ensure that the Ansible environment is properly prepared
source "${COMMON_TESTS_PATH}/test-ansible-env-prep.sh"

# Set gate job exit traps, this is run regardless of exit state when the job finishes.
trap gate_job_exit_tasks EXIT

# Prepare environment for the setup of Region A
# NB we run against swift_all only since region B hosts don't exist yet.
export ANSIBLE_INVENTORY="${WORKING_DIR}/tests/inventory_MR_A"
export ANSIBLE_LOG_PATH="${ANSIBLE_LOG_DIR}/ansible-execute-install-MR_A.log"
export ANSIBLE_OVERRIDES="${WORKING_DIR}/tests/${ROLE_NAME}-overrides-MR-A.yml"
export ANSIBLE_PARAMETERS="-vvv -e swift_do_setup=True -e swift_do_sync=False -e swift_groups=swift_all"
export TEST_PLAYBOOK="${WORKING_DIR}/tests/test.yml"

# Execute the setup of Region A
execute_ansible_playbook

# Prepare environment for the setup of Region B
export ANSIBLE_INVENTORY="${WORKING_DIR}/tests/inventory_MR_B"
export ANSIBLE_LOG_PATH="${ANSIBLE_LOG_DIR}/ansible-execute-install-MR_B.log"
export ANSIBLE_OVERRIDES="${WORKING_DIR}/tests/${ROLE_NAME}-overrides-MR-B.yml"
export ANSIBLE_PARAMETERS="-vvv"
export TEST_PLAYBOOK="${COMMON_TESTS_PATH}/test-install-swift.yml"

# Execute the setup of Region B
execute_ansible_playbook

# Prepare the environment for synchronising the rings from Region A
export ANSIBLE_INVENTORY="${WORKING_DIR}/tests/inventory_MR_A"
export ANSIBLE_LOG_PATH="${ANSIBLE_LOG_DIR}/ansible-execute-sync-MR_A.log"
export ANSIBLE_OVERRIDES="${WORKING_DIR}/tests/${ROLE_NAME}-overrides-MR-A.yml"
export ANSIBLE_PARAMETERS="-vvv -e swift_do_setup=False -e swift_do_sync=True"
export TEST_PLAYBOOK="${COMMON_TESTS_PATH}/test-install-swift.yml"

# Synchronise the rings from Region A
execute_ansible_playbook

# Prepare the environment for functionally testing Region A
export ANSIBLE_INVENTORY="${WORKING_DIR}/tests/inventory_MR_A"
export ANSIBLE_LOG_PATH="${ANSIBLE_LOG_DIR}/ansible-execute-test-MR_A.log"
export ANSIBLE_OVERRIDES="${WORKING_DIR}/tests/${ROLE_NAME}-overrides-MR-A.yml"
export ANSIBLE_PARAMETERS="-vvv"
export TEST_PLAYBOOK="${WORKING_DIR}/tests/test-swift-functional.yml"

# Functionally test Region A
execute_ansible_playbook

# Prepare the environment for functionally testing Region B
export ANSIBLE_INVENTORY="${WORKING_DIR}/tests/inventory_MR_B"
export ANSIBLE_LOG_PATH="${ANSIBLE_LOG_DIR}/ansible-execute-test-MR_B.log"
export ANSIBLE_OVERRIDES="${WORKING_DIR}/tests/${ROLE_NAME}-overrides-MR-B.yml"
export ANSIBLE_PARAMETERS="-vvv"
export TEST_PLAYBOOK="${WORKING_DIR}/tests/test-swift-functional.yml"

# Functionally test Region B
execute_ansible_playbook
