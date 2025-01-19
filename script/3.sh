#!/bin/bash

# Отключение ненужных GSD компонентов
echo "Отключение ненужных компонентов GNOME Settings Daemon..."
mkdir -p ~/.config/autostart
for service in \
    org.gnome.SettingsDaemon.A11ySettings \
    org.gnome.SettingsDaemon.Color \
    org.gnome.SettingsDaemon.Datetime \
    org.gnome.SettingsDaemon.Housekeeping \
    org.gnome.SettingsDaemon.Keyboard \
    org.gnome.SettingsDaemon.MediaKeys \
    org.gnome.SettingsDaemon.Power \
    org.gnome.SettingsDaemon.PrintNotifications \
    org.gnome.SettingsDaemon.Rfkill \
    org.gnome.SettingsDaemon.ScreensaverProxy \
    org.gnome.SettingsDaemon.Sharing \
    org.gnome.SettingsDaemon.Smartcard \
    org.gnome.SettingsDaemon.Sound \
    org.gnome.SettingsDaemon.UsbProtection \
    org.gnome.SettingsDaemon.Wacom; do
    echo -e "[Desktop Entry]\nType=Application\nHidden=true" > ~/.config/autostart/$service.desktop
done

# Отключение Evolution Calendar
echo "Отключение Evolution Calendar..."
echo -e "[Desktop Entry]\nType=Application\nHidden=true" > ~/.config/autostart/org.gnome.Evolution-alarm-notify.desktop
echo -e "[Desktop Entry]\nType=Application\nHidden=true" > ~/.config/autostart/org.gnome.evolution.dataserver.AddressBook.desktop
echo -e "[Desktop Entry]\nType=Application\nHidden=true" > ~/.config/autostart/org.gnome.evolution.dataserver.Calendar.desktop

# Остановка и отключение Evolution Data Server
systemctl --user stop evolution-addressbook-factory.service
systemctl --user stop evolution-calendar-factory.service
systemctl --user stop evolution-source-registry.service
systemctl --user mask evolution-addressbook-factory.service
systemctl --user mask evolution-calendar-factory.service
systemctl --user mask evolution-source-registry.service

echo "Готово! Перезагрузите систему, чтобы применить изменения."