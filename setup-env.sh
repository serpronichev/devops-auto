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

echo "--- Настройка системного очистителя логов ---"

# Копируем скрипт в системную папку.
sudo cp ./log-cleaner.sh /usr/local/bin/log-cleaner
sudo chmod +x /usr/local/bin/log-cleaner

# Создаём тестовую папку, если её нет
mkdir -p /home/clack92/devops-auto/testlogs

# Прописываем задачу в cron для суперпользователя
(sudo crontab -l 2>/dev/null; echo "0 0 * * * /usr/local/bin/log-cleaner /home/clack92/devops-auto/testlogs 5 >> /var/log/log-cleaner.log 2>&1") | sudo crontab -
