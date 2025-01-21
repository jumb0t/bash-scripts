#!/bin/bash

# Скрипт для бэкапа до 100 репозиториев GitHub с использованием токена.
# Автор: [Ваше имя]
# Дата: [Дата]
#
# Этот скрипт:
# 1. Проверяет наличие необходимых утилит (curl, jq, git).
# 2. Получает список репозиториев через GitHub API (включая приватные).
# 3. Сохраняет список репозиториев в файл `repos.txt`.
# 4. Клонирует все репозитории в указанную папку, используя токен GitHub.
# 5. Добавляет паузу между клонированиями для предотвращения проблем с API.
# 6. Отображает прогресс выполнения.

# === Настройки ===
# Укажите ваш GitHub токен. Создайте его на https://github.com/settings/tokens.
GITHUB_TOKEN=""

# Укажите имя пользователя GitHub.
GITHUB_USER="jumb0t"

# Папка для сохранения репозиториев.
BACKUP_DIR="$HOME/github-backup"

# Файл для сохранения списка репозиториев.
REPO_LIST_FILE="$BACKUP_DIR/repos.txt"

# Пауза между клонированиями (в секундах).
PAUSE_SECONDS=2

# === Функции ===

# Проверка наличия необходимых утилит
function check_dependencies() {
  for cmd in curl jq git; do
    if ! command -v $cmd &>/dev/null; then
      echo "Ошибка: Утилита $cmd не установлена. Установите её и попробуйте снова." >&2
      exit 1
    fi
  done
}

# Создание папки для бэкапов
function create_backup_dir() {
  if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "Создана папка для бэкапов: $BACKUP_DIR"
  fi
}

# Получение списка репозиториев через GitHub API
function fetch_repos() {
  echo "Получение списка репозиториев для пользователя $GITHUB_USER..."
  curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/user/repos?per_page=100" | \
    jq -r '.[].clone_url' >"$REPO_LIST_FILE"

  if [ $? -ne 0 ] || [ ! -s "$REPO_LIST_FILE" ]; then
    echo "Ошибка: Не удалось получить список репозиториев. Проверьте токен и имя пользователя." >&2
    exit 1
  fi

  echo "Список репозиториев сохранён в файл: $REPO_LIST_FILE"
}

# Клонирование репозиториев
function clone_repos() {
  echo "Начинается клонирование репозиториев..."
  total=$(wc -l <"$REPO_LIST_FILE")
  count=0

  while IFS= read -r repo; do
    count=$((count + 1))
    echo "[$count/$total] Клонирование: $repo"
    
    # Добавляем токен в URL репозитория для доступа к приватным репозиториям
    auth_repo=$(echo "$repo" | sed "s|https://|https://$GITHUB_TOKEN@|")
    
    git clone "$auth_repo" "$BACKUP_DIR/$(basename "$repo" .git)" &>/dev/null
    if [ $? -ne 0 ]; then
      echo "Ошибка при клонировании репозитория: $repo" >&2
    fi

    # Пауза между запросами
    sleep $PAUSE_SECONDS
  done <"$REPO_LIST_FILE"

  echo "Клонирование завершено. Все репозитории сохранены в $BACKUP_DIR"
}

# === Основной код ===
echo "=== GitHub Backup Script ==="

check_dependencies
create_backup_dir
fetch_repos
clone_repos

echo "Бэкап завершён!"
