#!/usr/bin/env bash

dependency_versions="${1:-locked}"
additional_composer_options="${2}"
working_directory="${3}"
php_path="${4:-$(which php)}"
composer_path="${5:-$(which composer)}"
composer_lock="${6}"

composer_command="update"
composer_options=("--no-interaction" "--no-progress" "--ansi")

case "${dependency_versions}" in
    highest) composer_command="update" ;;
    lowest) composer_options+=("--prefer-lowest" "--prefer-stable") ;;
    *) composer_command="install" ;;
esac

# If there is no composer.lock file, then use the `update` command.
if [ -z "${composer_lock}" ]; then
    composer_command="update"
fi

read -r -a additional_options <<<"${additional_composer_options}"
composer_options+=("${additional_options[@]}")

if [ -n "${working_directory}" ]; then
    composer_options+=("--working-dir" "${working_directory}")
fi

full_command="${php_path} ${composer_path} ${composer_command} ${composer_options[*]}"
echo "Using the following Composer command: '${full_command}'"
# $full_command
