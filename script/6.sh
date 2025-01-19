#!/bin/bash

# ==========================
# Настройка окружения
# ==========================
# Определяем, какой интерпретатор используется: bash или zsh
SHELL_TYPE=$(ps -p $$ -ocomm=)
if [[ "$SHELL_TYPE" != "bash" && "$SHELL_TYPE" != "zsh" ]]; then
    echo "Этот скрипт должен выполняться с использованием bash или zsh."
    exit 1
fi

# ==========================
# 1. Установка необходимых пакетов
# ==========================
echo "Установка необходимых пакетов..."
# Устанавливаем необходимые пакеты через pacman
sudo pacman -S --noconfirm gnome-tweaks gnome-shell-extensions wget unzip

# ==========================
# 2. Функция для установки расширений
# ==========================
install_extension() {
    local extension_name=$1     # Название расширения (например, Dash to Panel)
    local extension_url=$2      # URL для скачивания расширения в формате .zip
    local extension_uuid=$3     # Уникальный идентификатор расширения

    # Проверяем, установлено ли расширение
    if ! gnome-extensions list | grep -q "$extension_uuid"; then
        echo "Попытка установки $extension_name через gnome-extensions install..."
        # Пытаемся установить расширение через gnome-extensions
        if gnome-extensions install "$extension_url"; then
            echo "$extension_name успешно установлено через gnome-extensions."
            gnome-extensions enable "$extension_uuid"
        else
            echo "Ошибка установки $extension_name через gnome-extensions. Попробую установить вручную..."

            # Создаем временную директорию для загрузки расширения
            local temp_dir=$(mktemp -d)
            local zip_file="$temp_dir/extension.zip"

            # Скачиваем расширение вручную
            if wget -O "$zip_file" "$extension_url"; then
                # Распаковываем расширение в директорию для локальных расширений GNOME
                unzip "$zip_file" -d ~/.local/share/gnome-shell/extensions/"$extension_uuid"
                gnome-extensions enable "$extension_uuid"
                echo "$extension_name установлен вручную."
            else
                echo "Не удалось скачать $extension_name. Пропускаю установку."
            fi

            # Удаляем временные файлы и директорию
            rm -rf "$temp_dir"
        fi
    else
        echo "$extension_name уже установлено."
    fi
}

# ==========================
# 3. Установка и включение расширений
# ==========================
echo "Установка и включение расширений..."

# Установка расширения Dash to Panel
install_extension "Dash to Panel" "https://extensions.gnome.org/extension-data/dash-to-paneljderose9.github.com.v50.shell-extension.zip" "dash-to-panel@jderose9.github.com"

# Установка расширения Arc Menu
install_extension "Arc Menu" "https://extensions.gnome.org/extension-data/arcmenu@linxgem33.com.v41.shell-extension.zip" "arc-menu@linxgem33.com"

# ==========================
# 4. Полная настройка Dash to Panel
# ==========================
echo "Настройка Dash to Panel..."

# Размер панели: можно настроить значение в пикселях (например, 36 для компактного вида).
gsettings set org.gnome.shell.extensions.dash-to-panel panel-size 36

# Позиция панели: доступные значения TOP, BOTTOM, LEFT, RIGHT.
gsettings set org.gnome.shell.extensions.dash-to-panel panel-position 'TOP'

# Прозрачный стиль панели: можно использовать 'transparent', 'solid', 'dynamic'.
gsettings set org.gnome.shell.extensions.dash-to-panel panel-appearance 'transparent'

# Отключение анимации "Показать все приложения".
gsettings set org.gnome.shell.extensions.dash-to-panel animate-show-apps false

# Отключение автоматического скрытия панели.
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide false

# Отключение изоляции рабочих пространств (показывает все окна на панели).
gsettings set org.gnome.shell.extensions.dash-to-panel isolate-workspaces false

# Показывать избранные приложения на панели.
gsettings set org.gnome.shell.extensions.dash-to-panel show-favorites true

# Отключить иконку "Показать все приложения".
gsettings set org.gnome.shell.extensions.dash-to-panel show-apps-icon false

# Показать кнопку "Показать рабочий стол".
gsettings set org.gnome.shell.extensions.dash-to-panel show-showdesktop-button true

# Включить отображение управляющих элементов аудио.
gsettings set org.gnome.shell.extensions.dash-to-panel show-mpris true

# Отключить наложение горячих клавиш.
gsettings set org.gnome.shell.extensions.dash-to-panel hotkeys-overlay false

# Отключить группировку окон.
gsettings set org.gnome.shell.extensions.dash-to-panel group-apps false

# Включить показ превью окон.
gsettings set org.gnome.shell.extensions.dash-to-panel show-previews true

# Размер превью окон: доступные значения 'small', 'normal', 'large'.
gsettings set org.gnome.shell.extensions.dash-to-panel preview-size 'large'

# ==========================
# 5. Полная настройка Arc Menu
# ==========================
echo "Настройка Arc Menu..."

# Макет меню: можно выбрать 'Classic', 'Modern', 'XFCE' и т.д.
gsettings set org.gnome.shell.extensions.arc-menu menu-layout 'XFCE'

# Размер меню в пикселях.
gsettings set org.gnome.shell.extensions.arc-menu menu-size 800

# Включить использование пользовательской иконки для кнопки меню.
gsettings set org.gnome.shell.extensions.arc-menu custom-icon 'true'

# Использовать тему пользователя для иконок в меню.
gsettings set org.gnome.shell.extensions.arc-menu user-theme 'true'

# Отключить открытие меню стрелкой (открытие по щелчку).
gsettings set org.gnome.shell.extensions.arc-menu open-with-arrow false

# Позиция дока: можно выбрать 'panel', 'dash-to-panel'.
gsettings set org.gnome.shell.extensions.arc-menu dock-position 'panel'

# Включить навигацию с помощью клавиатуры.
gsettings set org.gnome.shell.extensions.arc-menu enable-keyboard-nav true

# Включить показ последних файлов в меню.
gsettings set org.gnome.shell.extensions.arc-menu enable-recent-files true

# Отключить анимацию фона меню.
gsettings set org.gnome.shell.extensions.arc-menu enable-background-animation false

# Отключить анимацию при наведении на элементы меню.
gsettings set org.gnome.shell.extensions.arc-menu enable-hover-animation false

# Радиус углов меню (в пикселях).
gsettings set org.gnome.shell.extensions.arc-menu custom-menu-radius 15

# Использовать сетку для отображения иконок в меню.
gsettings set org.gnome.shell.extensions.arc-menu enable-grid true

# Размер иконок в меню (в пикселях).
gsettings set org.gnome.shell.extensions.arc-menu grid-icon-size 48

# Отступы иконок в сетке меню (в пикселях).
gsettings set org.gnome.shell.extensions.arc-menu grid-icon-padding 12

# ==========================
# 6. Оптимизация GNOME для повышения производительности
# ==========================
echo "Оптимизация GNOME для повышения производительности..."

# Отключение всех анимаций интерфейса.
gsettings set org.gnome.desktop.interface enable-animations false

# Отключение всех анимаций окон (максимально возможное).
gsettings set org.gnome.mutter experimental-features "['no-vblank', 'scale-monitor-framebuffer']"

# Отключение теней для окон, чтобы уменьшить нагрузку на GPU.
gsettings set org.gnome.desktop.wm.preferences theme 'Adwaita'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close'

# Отключение плавного скроллинга.
gsettings set org.gnome.desktop.interface gtk-enable-animations false

# Отключение автоматических обновлений приложений.
gsettings set org.gnome.software download-updates false

# Отключение анимаций в Nautilus.
gsettings set org.gnome.nautilus.preferences always-use-location-entry true

# Уменьшение времени блокировки экрана.
gsettings set org.gnome.desktop.session idle-delay 600

# Отключение автозапуска gnome-software при входе.
gsettings set org.gnome.software download-updates false

# Отключение поиска в GNOME Shell для повышения производительности.
gsettings set org.gnome.desktop.search-providers disabled \
    "['org.gnome.Contacts.desktop', 'org.gnome.Boxes.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Characters.desktop', 'org.gnome.clocks.desktop', 'org.gnome.Documents.desktop', 'org.gnome.Maps.desktop', 'org.gnome.Photos.desktop', 'org.gnome.Weather.desktop']"



# Отключение всех ненужных служб и расширений для поиска, чтобы снизить нагрузку.
gsettings set org.gnome.desktop.search-providers disable-external true

# Отключение ненужных расширений GNOME для повышения производительности.
# Пример: отключение расширения "desktop-icons" (если оно установлено).
if gnome-extensions list | grep -q 'desktop-icons@csoriano'; then
    gnome-extensions disable 'desktop-icons@csoriano'
fi

# ==========================
# 7. Дополнительные оптимизации для уменьшения нагрузки
# ==========================
echo "Применение дополнительных оптимизаций..."

# Отключение автозапуска приложений GNOME, которые не нужны:
# Эти команды отключают автозапуск демонов GNOME, которые могут замедлять работу системы.
gnome-session-properties

# Отключение доступа к облачным службам GNOME:
# Отключает сервисы интеграции с облачными учетными записями.
gsettings set org.gnome.desktop.privacy remember-recent-files false

# Отключение иконок на рабочем столе, если это еще не сделано.
gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
gsettings set org.gnome.shell.extensions.desktop-icons show-home false

# Оптимизация использования оперативной памяти:
# Отключение индексирования файлов для поиска.
tracker3 reset --hard
gsettings set org.freedesktop.Tracker3.Miner.Files index-recursive-directories '[]'

# Отключение функции 'tracker', чтобы уменьшить использование ресурсов.
systemctl --user mask tracker3-store
systemctl --user mask tracker3-miner-fs
systemctl --user mask tracker3-miner-apps

# Отключение процессов GNOME, которые не используются часто.
systemctl --user stop evolution-calendar-factory.service
systemctl --user stop evolution-addressbook-factory.service
systemctl --user stop evolution-source-registry.service
systemctl --user stop evolution-mail.service
systemctl --user stop evolution-alarm-notify.service
systemctl --user mask evolution-calendar-factory.service
systemctl --user mask evolution-addressbook-factory.service
systemctl --user mask evolution-source-registry.service
systemctl --user mask evolution-mail.service
systemctl --user mask evolution-alarm-notify.service

# ==========================
# 8. Перезагрузка GNOME Shell для применения изменений
# ==========================
echo "Перезагрузка GNOME Shell для применения изменений..."
if command -v gnome-shell > /dev/null; then
    gnome-shell --replace &
else
    echo "GNOME Shell не найден, пропускаю перезагрузку."
fi

echo "Полная настройка и оптимизация GNOME завершена! Перезагрузите систему для полного применения изменений."