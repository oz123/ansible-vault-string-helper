#!/bin/bash

decrypt_ansible_vault_string ()
{
    export FN=$1;
    export KEY=$2;
    ansible-vault view <(yq r "${FN}" "${KEY}")
}

encrypt_ansible_vault_string ()
{
    FILE=$1
    LOCATION=$2
    VALUE=$3

    yq n $2 "" > .tmp.yml

    echo "$(cat .tmp.yml) $(ansible-vault encrypt_string "${VALUE}" 2>/dev/null)" > .new.yml

    yq merge .new.yml "${FILE}" > .updated.yml

    mv .updated.yml "${FILE}"

    rm .tmp.yml .new.yml
    # darn, it seems yq merge -i isn't working
    #yq merge -i new.yml portknox.talk_signaling_server/vars/main.yml
}

print_usage ()
{
    echo "$(basename $0) [ --encrypt | --decrypt ]"
    echo ""
    echo "$(basename $0) --encrypt <file> <YAML path> <secret>"
    echo "$(basename $0) --decrypt <file> <YAML path>"
}

which yq >/dev/null 2>&1 || (echo "This script depends on https://github.com/mikefarah/yq" && exit 1)

for arg in "$@"; do
    shift
    case "$arg" in
        "--help")    set -- "$@" "-h";;
        "--encrypt") set -- "$@" "-e";;
        "--decrypt") set -- "$@" "-d";;
        *)           set -- "$@" "$arg";;
    esac
done

action=""
# Parse short options
OPTIND=1
while getopts "edh" opt
do
  case "$opt" in
    "h") print_usage; exit 0 ;;
    "e") action=encrypt ;;
    "d") action=decrypt ;;
    "?") print_usage >&2; exit 1 ;;
  esac
done
shift $(expr $OPTIND - 1) # remove options from positional parameters

if [ -z "${action}" ]; then print_usage >&2; exit 1 ; fi

if [ x"${action}" == x"encrypt" ]; then
    encrypt_ansible_vault_string "$@"
else
    decrypt_ansible_vault_string "$@"
fi
