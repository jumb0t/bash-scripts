#!/bin/bash

# Скрипт для настройки GNOME с использованием Dash to Panel и Arc Menu
# Выполняет установку расширений и полную настройку их параметров для максимальной производительности и удобства.

# ==========================
# 1. Установка необходимых пакетов
# ==========================
echo "Установка необходимых пакетов..."
sudo pacman -S --noconfirm \
    gnome-tweaks \
    gnome-shell-extensions

# ==========================
# 2. Установка и включение расширений
# ==========================
echo "Установка и включение расширений..."

# Установка Dash to Panel
if ! gnome-extensions list | grep -q "dash-to-panel"; then
    echo "Установка Dash to Panel..."
    gnome-extensions install https://extensions.gnome.org/extension/1160/dash-to-panel/
    gnome-extensions enable dash-to-panel@jderose9.github.com
fi

# Установка Arc Menu
if ! gnome-extensions list | grep -q "arc-menu"; then
    echo "Установка Arc Menu..."
    gnome-extensions install https://extensions.gnome.org/extension/3628/arc-menu/
    gnome-extensions enable arc-menu@linxgem33.com
fi

# ==========================
# 3. Полная настройка Dash to Panel
# ==========================
echo "Настройка Dash to Panel..."

# Настройка стиля панели
gsettings set org.gnome.shell.extensions.dash-to-panel panel-size 36 # Размер панели
gsettings set org.gnome.shell.extensions.dash-to-panel panel-position 'TOP' # Позиция панели (TOP, BOTTOM, LEFT, RIGHT)
gsettings set org.gnome.shell.extensions.dash-to-panel panel-appearance 'transparent' # Прозрачный стиль панели

# Настройка поведения панели
gsettings set org.gnome.shell.extensions.dash-to-panel animate-show-apps false # Отключить анимацию "Показать все приложения"
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide false # Отключить автоматическое скрытие панели
gsettings set org.gnome.shell.extensions.dash-to-panel isolate-workspaces false # Отключить изоляцию рабочих пространств
gsettings set org.gnome.shell.extensions.dash-to-panel show-favorites true # Показывать избранные приложения на панели

# Настройка кнопок и иконок
gsettings set org.gnome.shell.extensions.dash-to-panel show-apps-icon false # Отключить иконку "Показать все приложения"
gsettings set org.gnome.shell.extensions.dash-to-panel show-showdesktop-button true # Показать кнопку "Показать рабочий стол"
gsettings set org.gnome.shell.extensions.dash-to-panel show-mpris true # Включить отображение управляющих элементов аудио
gsettings set org.gnome.shell.extensions.dash-to-panel hotkeys-overlay false # Отключить наложение горячих клавиш

# Настройка всплывающих окон
gsettings set org.gnome.shell.extensions.dash-to-panel group-apps false # Отключить группировку окон
gsettings set org.gnome.shell.extensions.dash-to-panel show-previews true # Включить показ превью окон
gsettings set org.gnome.shell.extensions.dash-to-panel preview-size 'large' # Размер превью окон (small, normal, large)

# ==========================
# 4. Полная настройка Arc Menu
# ==========================
echo "Настройка Arc Menu..."

# Настройка внешнего вида меню
gsettings set org.gnome.shell.extensions.arc-menu menu-layout 'XFCE' # Макет меню в стиле XFCE
gsettings set org.gnome.shell.extensions.arc-menu menu-size 800 # Размер меню
gsettings set org.gnome.shell.extensions.arc-menu custom-icon 'true' # Включить использование пользовательской иконки
gsettings set org.gnome.shell.extensions.arc-menu user-theme 'true' # Использовать тему пользователя для иконок

# Настройка поведения меню
gsettings set org.gnome.shell.extensions.arc-menu open-with-arrow false # Отключить открытие меню стрелкой
gsettings set org.gnome.shell.extensions.arc-menu dock-position 'panel' # Позиция дока (panel, dash-to-panel)
gsettings set org.gnome.shell.extensions.arc-menu enable-keyboard-nav true # Включить навигацию с помощью клавиатуры
gsettings set org.gnome.shell.extensions.arc-menu enable-recent-files true # Включить показ последних файлов

# Настройка стиля и анимаций
gsettings set org.gnome.shell.extensions.arc-menu enable-background-animation false # Отключить анимацию фона
gsettings set org.gnome.shell.extensions.arc-menu enable-hover-animation false # Отключить анимацию при наведении
gsettings set org.gnome.shell.extensions.arc-menu custom-menu-radius 15 # Радиус углов меню

# Настройка иконок в меню
gsettings set org.gnome.shell.extensions.arc-menu enable-grid true # Использовать сетку для отображения иконок
gsettings set org.gnome.shell.extensions.arc-menu grid-icon-size 48 # Размер иконок в меню
gsettings set org.gnome.shell.extensions.arc-menu grid-icon-padding 12 # Отступы иконок в сетке

# ==========================
# 5. Перезагрузка GNOME Shell для применения изменений
# ==========================
echo "Перезагрузка GNOME Shell для применения изменений..."
if command -v gnome-shell > /dev/null; then
    gnome-shell --replace &
fi

echo "Полная настройка Dash to Panel и Arc Menu завершена! Перезагрузите систему для полного применения изменений."