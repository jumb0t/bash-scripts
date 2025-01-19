#!/bin/bash
#!/bin/bash

# -------------------------------
# Скрипт для создания виртуального окружения
# и обновления всех установленных pip-пакетов
# -------------------------------

# Задаём имя и путь к виртуальному окружению
VENV_DIR="$HOME/myenv"

# Функция для вывода сообщений
echo_info() {
    echo -e "\e[34m[INFO]\e[0m $1"
}

echo_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

# Шаг 1: Проверяем, установлен ли Python 3
if ! command -v python3 &> /dev/null
then
    echo_error "Python3 не найден. Установите Python3 через pacman:"
    echo "sudo pacman -S python"
    exit 1
fi

# Шаг 2: Проверяем наличие модуля venv
python3 -m venv --help &> /dev/null
if [ $? -ne 0 ]; then
    echo_error "Модуль venv не установлен. Установите пакет python-venv через pacman:"
    echo "sudo pacman -S python-venv"
    exit 1
fi

# Шаг 3: Создаём виртуальное окружение
if [ -d "$VENV_DIR" ]; then
    echo_info "Виртуальное окружение уже существует по пути $VENV_DIR."
else
    echo_info "Создаём виртуальное окружение в $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
    if [ $? -ne 0 ]; then
        echo_error "Не удалось создать виртуальное окружение."
        exit 1
    fi
    echo_info "Виртуальное окружение успешно создано."
fi

# Шаг 4: Активируем виртуальное окружение
echo_info "Активируем виртуальное окружение..."
source "$VENV_DIR/bin/activate"
if [ -z "$VIRTUAL_ENV" ]; then
    echo_error "Не удалось активировать виртуальное окружение."
    exit 1
fi
echo_info "Виртуальное окружение активировано."

# Шаг 5: Обновляем pip до последней версии
echo_info "Обновляем pip до последней версии..."
pip install --upgrade pip
if [ $? -ne 0 ]; then
    echo_error "Не удалось обновить pip."
    deactivate
    exit 1
fi
echo_info "pip успешно обновлён."

# Шаг 6: Находим устаревшие пакеты
echo_info "Ищем устаревшие пакеты..."
OUTDATED_PACKAGES=$(pip list --outdated --format=columns | tail -n +3 | awk '{print $1}')

if [ -z "$OUTDATED_PACKAGES" ]; then
    echo_info "Все пакеты уже обновлены."
else
    echo_info "Найдено устаревших пакетов: $OUTDATED_PACKAGES"
    # Обновляем каждый пакет по отдельности
    for package in $OUTDATED_PACKAGES
    do
        echo_info "Обновляем пакет: $package..."
        pip install --upgrade "$package"
        if [ $? -ne 0 ]; then
            echo_error "Не удалось обновить пакет: $package"
        else
            echo_info "Пакет $package успешно обновлён."
        fi
    done
    echo_info "Все доступные пакеты обновлены."
fi

# Альтернативный метод обновления всех пакетов сразу (может вызвать проблемы с зависимостями)
# Uncomment the following lines if you prefer этот метод
# echo_info "Обновляем все пакеты одновременно..."
# pip install --upgrade $(pip list --outdated --format=columns | tail -n +3 | awk '{print $1}')
# echo_info "Все пакеты обновлены."

# Шаг 7: Деактивируем виртуальное окружение
echo_info "Деактивируем виртуальное окружение..."
deactivate
echo_info "Виртуальное окружение деактивировано."

echo_info "Процесс обновления всех pip-пакетов завершён."
