#!/bin/bash

# Скрипт автоустановки fakegarant для Ubuntu
set -e

# 1. Установка Python и системных зависимостей
sudo apt update
sudo apt install -y python3 python3-pip python3-venv git

# 2. Создание системного пользователя
sudo useradd -r -s /bin/fakegarant fakegarant

# 3. Клонирование репозитория
sudo git clone https://github.com/svod011929/fakegarant.git /opt/fakegarant
sudo chown -R fakegarant:fakegarant /opt/fakegarant

# 4. Настройка виртуального окружения и установка зависимостей
sudo -u fakegarant python3 -m venv /opt/fakegarant/venv
sudo -u fakegarant /opt/fakegarant/venv/bin/pip install --no-cache-dir aiogram

# 5. Создание systemd сервиса
cat << EOF | sudo tee /etc/systemd/system/fakegarant.service
[Unit]
Description=Fakegarant Telegram Bot
After=network.target

[Service]
User=fakegarant
WorkingDirectory=/opt/fakegarant
ExecStart=/opt/fakegarant/venv/bin/python3 /opt/fakegarant/fakegarant.py
Restart=always
RestartSec=3
Environment="PYTHONUNBUFFERED=1"

[Install]
WantedBy=multi-user.target
EOF

# 6. Запуск сервиса
sudo systemctl daemon-reload
sudo systemctl enable fakegarant
sudo systemctl start fakegarant

# 7. Проверка статуса
sleep 3
echo -e "\n\033[32mУстановка завершена!\033[0m"
echo "Статус сервиса:"
sudo systemctl status fakegarant --no-pager
