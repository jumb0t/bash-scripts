#!/bin/bash

# Отключение композитора XFCE4 для ускорения графики
xfconf-query -c xfwm4 -p /general/use_compositing -s false

# Отключение анимации окон
xfconf-query -c xfwm4 -p /general/mousewheel_rollup -s false
xfconf-query -c xfwm4 -p /general/move_opacity -s 100
xfconf-query -c xfwm4 -p /general/resize_opacity -s 100

# Установка темы с минимальной нагрузкой
xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Adwaita"

# Удаление теней окон
xfconf-query -c xfwm4 -p /general/show_dock_shadow -s false
xfconf-query -c xfwm4 -p /general/show_frame_shadow -s false

# Отключение анимации панели
xfconf-query -c xfce4-panel -p /panels/panel-0/autohide-behavior -s 0

# Отключение прозрачности окон
xfconf-query -c xfwm4 -p /general/frame_opacity -s 100



# Оптимизация производительности GTK
echo "Добавление GTK-настроек..."
mkdir -p ~/.config/gtk-3.0
cat <<EOF > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-enable-animations=false
gtk-primary-button-warps-slider=false
gtk-font-name=Sans 10
gtk-cursor-theme-name=default
gtk-theme-name=Adwaita
gtk-icon-theme-name=Adwaita
EOF



# Отключение блокировки экрана
echo "Отключение блокировки экрана..."
xfconf-query -c xfce4-session -p /general/LockCommand -s ""

# Оптимизация конфигурации для VNC (предотвращение перезапуска X11)
export DISPLAY=:1
xset s off  # Отключить заставку
xset -dpms  # Отключить энергосберегающий режим
