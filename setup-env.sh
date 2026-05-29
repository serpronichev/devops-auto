#!/usr/bin/env bash
set -euo pipefail

if [ $UID -ne 0 ] || [ $EUID -ne 0 ]; then
echo "Пожалуйста, Запустите скрипт через sudo" >&2
exit 1
fi

USER_HOME="/home/${SUDO_USER:-$USER}"

if ! grep -q "alias lla=" "$USER_HOME/.bashrc"
then
	echo 'alias lla="ls -la"' >> "$USER_HOME/.bashrc"
fi

echo ">>> Обновление списка пакетов"
apt-get update -qq

echo ">>> Установка git, curl, jq, docker.io"
apt-get install -y git curl jq docker.io

echo "Все необходимые инструменты установлены"

echo 'Allias lla="ls -la" установлен. Используй команду: source ~/.bashrc для перезагрузки'
