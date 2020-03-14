#!/usr/bin/env bats


load test_helper

source lib/util.sh

set -e

@test "util.generate-password() generates correct length" {
  len=64

  pw1=$(util.generate-password ${len})
  pw2=$(util.generate-password ${len})

  [ ${#pw1} -eq ${len} ] &&
  [ ${#pw2} -eq ${len} ]
}

@test "util.generate-password() generates different passwords" {
  len=64

  pw1=$(util.generate-password ${len})
  pw2=$(util.generate-password ${len})

  [ "${pw1}" != "${pw2}" ]
}

moo() {
  export MOO_CALLED=true
}

@test "util.call-if-function() - when function exists" {
  set -e
  [[ -z ${MOO_CALLED} ]]

  util.call-if-function moo
  [[ ${MOO_CALLED} == "true" ]]
}

@test "util.call-if-function() - when function does not exist" {
  set +e
  util.call-if-function asdfasdfsdf
  code=$?
  set -e
  [[ ${code} -eq 1 ]]
}

@test "util.is-a-function() - when function exists" {
  util.is-a-function util.generate-password
}

@test "util.is-a-function() - when function does not exists" {
  set +e
  util.is-a-function util.generate-password123
  code=$?
  set -e
  [ $code -ne 0 ]
}

config-moo() {
  echo "config/moo.enc" | sedx 's/\.(sym|enc)$//g'
}

if [[ $(uname -s) == "Darwin" ]]; then

@test "sedx() with gnu-sed installed" {
  if [[ -n $(which brew) && -z $(which gsed) ]]; then
    brew install --force --quiet gnu-sed 2>&1 | cat >/dev/null
  fi
  result=$(config-moo)
  [[ "${result}" == "config/moo" ]]
}

@test "sedx() without gnu-sed installed" {
  if [[ -n $(which brew) ]]; then
    if [[ -n "${INTEGRATION_TEST}" ]]; then
      brew uninstall --force --quiet gnu-sed 2>&1 | cat >/dev/null
      result=$(config-moo)
      [[ "${result}" == "config/moo" ]]
    else
      true
    fi
  else
    false
  fi
}

fi

