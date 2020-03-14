#!/usr/bin/env bats

load test_helper
source lib/array.sh

@test "array.join with a pipe" {
  declare -a array=("a string" "test2000" "hello" "one")
  result=$(array.join '|' "${array[@]}")
  echo ${result}
  [[ "${result}" == "a string|test2000|hello|one" ]]
}

@test "array.join with comma" {
  unset result array code status
  declare -a array=(uno dos tres quatro cinco seis)
  set -e
  result=$(array.join ', ' "${array[@]}")
  [[ ${result} == "uno, dos, tres, quatro, cinco, seis" ]]
  [[ $status -eq 0 ]]
}

@test "array.to.piped-list" {
  declare -a array=(orange yellow red)
  [[ $(array.to.piped-list "${array[@]}") == "orange | yellow | red" ]]
  [[ $status -eq 0 ]]
}

@test "array.includes() when one element exists" {
  declare -a array=("a string" "test2000" "hello" "one")
  array.includes test2000 "${array[@]}" && true
}

@test "array.includes() when another element exists" {
  declare -a array=("a string" "test2000" "hello" "one")
  set +e
  array.includes "one" "${array[@]}"; code=$?
  set -e
  [[ ${code} -eq 0 ]]
}

@test "array.includes() when element does not exist" {
  declare -a array=("a string" "test2000" "hello" "one")
  set +e
  array.includes "two" "${array[@]}"; local code=$?
  set -e
  [[ ${code} -eq 1 ]]
}

@test "array.has-element() when element exists" {
  declare -a array=("a string" "test2000" "hello" "one")
  array.has-element test2000 "${array[@]}" && true
}

@test "array.has-element() when element exists and has a space" {
  declare -a array=("a string" "test2000" "hello" "one")
  array.has-element "a string" "${array[@]}" && true
}

@test "array.has-element() when element exists, using return value" {
  declare -a array=("a string" "test2000" "hello" "one")
  set +e
  array.has-element test2000 "${array[@]}"; code=$?
  set -e
  [[ ${code} -eq 0 ]]
}

@test "array.has-element() when element exists" {
  declare -a array=("a string" "test2000" "hello" "one")
  [[ $(array.has-element hello "${array[@]}") == "true" ]]
}

@test "array.has-element() when element is a substring of an existing element" {
  declare -a array=("a string" "test2000" "hello" "one")
  [[ $(array.has-element hell "${array[@]}") == "false" ]]
}

@test "array.has-element when element does not exist" {
  declare -a array=("a string" "test2000" "hello" "one")
  [[ $(array.has-element 123 "${array[@]}")  == "false" ]]
}

@test "array.has-element when element does not exist and is a space " {
  declare -a array=("a string" "test2000" "hello" "one")
  [[ $(array.has-element ' ' "${array[@]}")  == "false" ]]
}

@test "array.to.bullet-list" {
  declare -a array=(kig pig)
  tmp=$(mktemp)
  array.to.bullet-list "${array[@]}" > ${tmp}

  lines=$(cat "${tmp}" | wc -l | tr -d ' ')
  echo "${tmp}"

  result="$(cat "${tmp}")"
  [[ ${lines} -eq 2                              ]]
  [[ $(cat "${tmp}" | egrep -c ' • kig') -eq 1  ]]
  [[ $(cat "${tmp}" | egrep -c ' • pig') -eq 1  ]]
}
