# Заголовки та змінні
!define APP_NAME "MyApp"
!define APP_VERSION "1.0.0"
!define INSTALL_DIR "$PROGRAMFILES64\MyApp"

# Вихідний файл інсталятора
OutFile "build\windows\x64\runner\Release\MyApp_Setup.exe"

# Директорія встановлення за замовчуванням
InstallDir "${INSTALL_DIR}"

# Інформація про секції
Section "Install"
    SetOutPath "$INSTDIR"
    File /r "build\windows\x64\runner\Release\*" ; Копіюємо всі файли програми
SectionEnd

Section "Uninstall"
    Delete "$INSTDIR\*.*"
    RMDir "$INSTDIR"
SectionEnd