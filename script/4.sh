#!/bin/bash

# Скрипт для настройки GNOME с Wayland и Weston
# Выполняет установку необходимых драйверов, конфигурирование системы и оптимизацию производительности.

# ==========================
# 1. Обновление системы
# ==========================
echo "Обновление системы..."
sudo pacman -Syu --noconfirm

# ==========================
# 2. Установка драйверов
# ==========================
echo "Проверка и установка драйверов видеокарты..."

# Для Intel и AMD драйверы обычно уже установлены.
# Установка драйверов для NVIDIA (проприетарный драйвер)
if lspci | grep -i 'vga' | grep -qi 'nvidia'; then
    echo "Установка проприетарных драйверов NVIDIA..."
    sudo mhwd -a pci nonfree 0300
fi

# ==========================
# 3. Включение Wayland в GDM
# ==========================
echo "Проверка конфигурации GDM для Wayland..."
GDM_CONFIG="/etc/gdm/custom.conf"
if grep -q "^WaylandEnable=false" $GDM_CONFIG; then
    echo "Закомментируем или удалим WaylandEnable=false в $GDM_CONFIG..."
    sudo sed -i '/^WaylandEnable=false/s/^/#/' $GDM_CONFIG
fi

# ==========================
# 4. Установка и настройка Weston
# ==========================
echo "Установка композитора Weston..."
sudo pacman -S weston --noconfirm

# Создание конфигурационного файла Weston
echo "Создание файла конфигурации для Weston..."
mkdir -p ~/.config
cat <<EOL > ~/.config/weston.ini
[core]
backend=wayland-backend.so

[shell]
panel-position=top

[input-method]
# Optional input method settings here

[terminal]
font=DroidSansMono, 14
EOL

# ==========================
# 5. Оптимизация GNOME для производительности
# ==========================
echo "Оптимизация GNOME..."

# Отключение анимаций
gsettings set org.gnome.desktop.interface enable-animations false

# Отключение плавной прокрутки
gsettings set org.gnome.settings-daemon.peripherals.touchpad natural-scroll false

# Отключение индексации файлов
echo "Отключение индексирования файлов..."
systemctl --user mask tracker-miner-fs-3.service
systemctl --user mask tracker-extract-3.service

# Отключение ненужных расширений GNOME
echo "Отключение ненужных расширений GNOME..."
gnome-extensions disable appindicatorsupport@rgcjonas.gmail.com || true
gnome-extensions disable TopIcons@phocean.net || true

# ==========================
# 6. Настройки окружения для оптимизации Shell
# ==========================
echo "Настройка окружения для оптимизации GNOME Shell..."
cat <<EOL >> ~/.profile
export CLUTTER_DEFAULT_FPS=60
export CLUTTER_VBLANK=none
export MUTTER_PAINT=disable-clipped-redraws:disable-culling
export NO_AT_BRIDGE=1
EOL

# ==========================
# 7. Установка и настройка zram для оптимизации swap
# ==========================
echo "Установка и настройка zram для оптимизации swap..."
sudo pacman -S zram-generator --noconfirm

# Создание конфигурационного файла для zram
echo "Создание файла конфигурации для zram..."
sudo tee /etc/systemd/zram-generator.conf > /dev/null <<EOL
[zram0]
zram-size = min(ram, 8192) # 8 GB или 50% от RAM, что меньше
compression-algorithm = zstd
EOL

# ==========================
# 8. Перезагрузка системы для применения изменений
# ==========================
echo "Перезагрузка системы для применения изменений..."
read -p "Перезагрузить систему сейчас? (y/n): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
    sudo reboot
else
    echo "Пожалуйста, перезагрузите систему позже для применения изменений."
fi