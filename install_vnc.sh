#!/bin/bash

set -e  # Прекратить выполнение при ошибке

# Функция для отображения сообщений об ошибке
error() {
    echo "Ошибка: $1"
    exit 1
}

echo "Начинается установка VNC-сервера на Debian Bookworm..."

# Проверка на root-доступ
if [[ $EUID -ne 0 ]]; then
    error "Скрипт должен быть запущен от имени root. Используйте sudo."
fi

# Установка необходимых пакетов
echo "Установка пакетов..."
apt update && apt install -y xfce4 xfce4-goodies tigervnc-standalone-server tigervnc-common > /dev/null || error "Не удалось установить пакеты."

# Создание пользователя VNC (если он не существует)
VNC_USER="vncuser"
if ! id -u "$VNC_USER" > /dev/null 2>&1; then
    echo "Создание пользователя $VNC_USER..."
    adduser --disabled-password --gecos "" "$VNC_USER" || error "Не удалось создать пользователя $VNC_USER."
else
    echo "Пользователь $VNC_USER уже существует."
fi

# Настройка пароля для VNC
echo "Установка пароля для VNC..."
su - "$VNC_USER" -c "
    mkdir -p ~/.vnc
    echo 'Введите пароль для VNC (должен быть не менее 6 символов):'
    vncpasswd
" || error "Не удалось установить пароль для VNC."

# Создание файла конфигурации VNC
echo "Создание файла конфигурации VNC..."
cat <<EOF > /home/$VNC_USER/.vnc/xstartup
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
EOF
chmod +x /home/$VNC_USER/.vnc/xstartup
chown "$VNC_USER:$VNC_USER" /home/$VNC_USER/.vnc/xstartup

# Создание системного демона для VNC
echo "Настройка системного демона для VNC..."
cat <<EOF > /etc/systemd/system/vncserver@$VNC_USER.service
[Unit]
Description=Start TigerVNC server at user login
After=syslog.target network.target

[Service]
Type=forking
User=$VNC_USER
Group=$VNC_USER
WorkingDirectory=/home/$VNC_USER

ExecStart=/usr/bin/vncserver -localhost -geometry 1280x800 -depth 24 :1
ExecStop=/usr/bin/vncserver -kill :1

[Install]
WantedBy=multi-user.target
EOF

# Установка прав и обновление systemd
chmod 644 /etc/systemd/system/vncserver@$VNC_USER.service
systemctl daemon-reload
systemctl enable vncserver@$VNC_USER.service || error "Не удалось включить службу VNC."
systemctl start vncserver@$VNC_USER.service || error "Не удалось запустить службу VNC."

# Проверка статуса VNC-сервера
echo "Проверка статуса VNC-сервера..."
systemctl status vncserver@$VNC_USER.service || error "Служба VNC работает некорректно."

echo "Установка VNC-сервера завершена успешно!"
echo "Вы можете подключиться к серверу через VNC-клиент, используя адрес: localhost:5901"
