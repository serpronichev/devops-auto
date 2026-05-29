#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]
then
	echo "Аргументы не были переданны" >&2
	exit 1
fi

if [ ! -d "$1" ]; then
echo "Ошибка: директория $1 не существует!" >&2
exit 1
else
	find "$1" -type f -name "*.log" -mtime "+$2" -exec gzip {} \;



