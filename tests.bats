# Создаём ограниченное окружение для тестов
setup() {
# Создание временной папки.
TEST_DIR="/tmp/log_test_env"
mkdir -p "$TEST_DIR"

# Создаём устаревшие лог файлы.
for i in {1..3}; do
touch -d "10 days ago" "$TEST_DIR/old_file_${i}.log"
done

# Создаём 1 свежий лог файл
touch "$TEST_DIR/fresh_file.log"
}


# Очистка окруженя после тестов.
teardown() {
rm -rf "$TEST_DIR"
}

@test "Проверка ротациии: старые логи архивируются, новые остаются" {
# Запуск скрипта, и передаём ему путь к тестовому окружения и срок устаревших файлов.
run bash log-cleaner.sh "$TEST_DIR" 5

# Проверка что скрипт выполнен успешно.
[ "$status" -eq 0 ]

# Проверка что сарый файл .log исчез, и появился архив .log.gz
[ ! -f "$TEST_DIR/old_file_1.log" ]
[ -f "$TEST_DIR/old_file_1.log.gz" ]

# Проверка что свежий файл .log не был сжать
[ -f "$TEST_DIR/fresh_file.log" ]
[ ! -f "$TEST_DIR/fresh_file.log.gz" ]
}
