#!/bin/bash

VARGS=$@
set -e nounset

script_directory(){
  local source="${BASH_SOURCE[0]}"
  local dir=""

  while [ -h "$source" ]; do # resolve $source until the file is no longer a symlink
    dir="$( cd -P "$( dirname "$source" )" && pwd )"
    source="$(readlink "$source")"
    [[ $source != /* ]] && source="$dir/$source" # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done

  dir="$( cd -P "$( dirname "$source" )" && pwd )"

  echo "$dir"
}

version(){
  local directory="$(script_directory)"
  local version=$(cat "$directory/VERSION")

  echo "$version"
  exit 0
}

main(){
  local first_arg="$1"

  if [ "$first_arg" == "--version" -o "$first_arg" == "-v" ]; then
    version
  fi

  fleetctl ssh $@
}
main $VARGS
