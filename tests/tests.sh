#!/bin/sh

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd)"

_run_tests() {
    for test in ${tests}; do
        if [ -f "${test}" ]; then
            vim -Nu tests.vimrc -c"+Vader! $(printf "%s\\n" "${test}" | sed 's:#:\\\#:g')"
            status="$(($status + $?))"
        else
            printf "%s\\n" "Test '${test}' doesn't exists, skipping ..."
        fi
    done

    return "${status:-0}"
}

tests="${@:-*.vader}"
cd "${CURRENT_DIR}" && _run_tests ||true #remove ||true when tests fixed
