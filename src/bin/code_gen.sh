#!/usr/bin/env bash

no_args="true"
while getopts ":f" optKey; do
  case "$optKey" in
    f)
      flutter pub run build_runner build --delete-conflicting-outputs
      ;;
    *) echo "ex. bin/code-gen [-f]" 1>&2;
  esac
  no_args="false"
done
[[ "$no_args" == "true" ]] && flutter pub run build_runner build
