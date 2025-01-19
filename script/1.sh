#!/bin/bash

# Скрипт для настройки GNOME в стиле XFCE
# Устанавливает необходимые расширения, темы и приложения.

# ==========================
# 1. Обновление системы
# ==========================
echo "Обновление системы..."
sudo pacman -Syu --noconfirm

# ==========================
# 2. Установка необходимых пакетов
# ==========================
echo "Установка необходимых пакетов..."
sudo pacman -S --noconfirm \
    gnome-tweaks \
    thunar \
    arc-gtk-theme \
    papirus-icon-theme \
    gnome-shell-extensions

# ==========================
# 3. Установка расширений GNOME
# ==========================
echo "Установка расширений GNOME..."

# Установить расширение Dash to Panel
if ! gnome-extensions list | grep -q "dash-to-panel"; then
    echo "Установка Dash to Panel..."
    gnome-extensions install https://extensions.gnome.org/extension/1160/dash-to-panel/
fi

# Установить расширение Arc Menu
if ! gnome-extensions list | grep -q "arc-menu"; then
    echo "Установка Arc Menu..."
    gnome-extensions install https://extensions.gnome.org/extension/3628/arc-menu/
fi

# Установить расширение Put Windows
if ! gnome-extensions list | grep -q "put-windows"; then
    echo "Установка Put Windows..."
    gnome-extensions install https://extensions.gnome.org/extension/1281/put-windows/
fi

# ==========================
# 4. Настройка тем и иконок
# ==========================
echo "Настройка тем и иконок..."
gsettings set org.gnome.desktop.interface gtk-theme "Arc"
gsettings set org.gnome.desktop.interface icon-theme "Papirus"

# ==========================
# 5. Отключение анимации
# ==========================
echo "Отключение анимации..."
gsettings set org.gnome.desktop.interface enable-animations false

# ==========================
# 6. Перезагрузка GNOME Shell
# ==========================
echo "Перезагрузка GNOME Shell для применения изменений..."
if command -v gnome-shell > /dev/null; then
    gnome-shell --replace &
fi

echo "Настройка завершена! Перезагрузите систему для полного применения изменений."