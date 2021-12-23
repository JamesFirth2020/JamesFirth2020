::V1.1 23/12/21
::V1.0 20/12/21
cls

:echo This program comes with ABSOLUTELY NO WARRANTY.
:echo This is free software and you are welcome to redistribute or modify it
:echo.
:set drive=%cd:~0,2%
:if %drive%==x goto finish
:if %drive%==X goto finish
:If not exist %drive%\NUL goto error


@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "skip=1 tokens=1-6" %%A IN ('WMIC ^Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') DO (
    IF %%A GTR 0 (
	SET Day=%%A
	SET Hour=%%B
	SET Min=%%C
	SET Month=%%D
	SET Sec=%%E
	SET Year=%%F
    )
)

echo Android Triage Script - Long Version V1.1
echo Windows Adapation by James Firth
echo Based on the work of Mattia Epifani
echo https://blog.digital-forensics.it/2021/03/triaging-modern-android-devices-aka.html

if %Month% LSS 10 set Month=0%Month%
if %Day% LSS 10 set Day=0%Day%
if %Min% LSS 10 set Minute=0%Minute%
if %Hour% LSS 10 set Hour=0%Hour%

set now=%year%-%month%-%day%_%hour%-%min%-%sec%
set now=%now%


set file=%now%
set info_output=%file%/%file%
echo.
echo.
echo Data is Being Output to : %file%
md %file%
echo Attemping to run triage dump from android phone - There may be errors owing to permission denial.
echo This normally takes around two minutes ... time for coffee?
echo.
echo.

:: Unsure why getting an error here.
cd %file%
md %file%"_info"
md %file%"_live"
md %file%"_package_manager"
md %file%"_dumpsys"
:md %file%"_backup"
md %file%"_system"
md %file%"_system\etc"
md %file%"_system\fonts"
md %file%"_system\framework"
md %file%"_system\lib"
md %file%"_system\lib64"
md %file%"_system\priv-app"
md %file%"_system\vendor"
:md %file%"_sdcard"
:md %file%"_apk"
:md %file%"_data"
:md %file%"_vendor"
md %file%"_contentprovider"
cd..
date /T > %file%/%file%.txt
echo Batch Start Time: >> %file%/%file%.txt
:time /T >> %file%/%file%.txt
echo %start_time% >> %file%/%file%.txt

set info_output_folder = %file%/%file%"_info"
set live_output_folder = %file%/%file%"_live"
set package_manager_output_folder = %file%/%file%"_package_manager"
set dumpsys_output_folder = %file%/%file%"_dumpsys"
set backup_output_folder = %file%/%file%"_backup"
set system_output_folder = %file%/%file%"_system"
set sdcard_output_folder = %file%/%file%"_sdcard"
set apk_output_folder = %file%/%file%"_apk"
set data_output_folder = %file%/%file%"_data"
set vendor_output_folder = %file%/%file%"_vendor"
set contentprovider_output_folder = %file%/%file%"_contentprovider"

echo Getting Device Information [Stage 1 of 5]
set device_info = %info_output_folder%/device_info.txt
adb shell getprop > %file%/%file%"_info"/getprop.txt >nul 2>nul
adb shell settings list system > %file%/%file%"_info"/settings_system.txt
adb shell settings list secure > %file%/%file%"_info"/settings_secure.txt
adb shell settings list global > %file%/%file%"_info"/settings_global.txt

:set getprop = %file%/getprop.txt
set settings_global = %file%/settings_global.txt
set settings_secure = %file%/settings_secure.txt
set settings_system = %file%/settings_system.txt

@echo off
echo Device Manufacturer: > %file%/%file%"_info"/device_info.txt
adb shell getprop ro.product.manufacturer >> %file%/%file%"_info"/device_info.txt
echo Device Model: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ro.product.model >> %file%/%file%"_info"/device_info.txt
echo Secure Android ID: >> %file%/%file%"_info"/device_info.txt
adb shell settings get secure android_id >> %file%/%file%"_info"/device_info.txt
echo Serial Number: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ril.serialnumber >> %file%/%file%"_info"/device_info.txt
echo Product Code: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ro.product.code >> %file%/%file%"_info"/device_info.txt
echo Product Device: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ro.product.device >> %file%/%file%"_info"/device_info.txt
echo Product Name: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ro.product.name >> %file%/%file%"_info"/device_info.txt
echo Chip Name: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ro.chipname >> %file%/%file%"_info"/device_info.txt
echo Build Version: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ro.build.version.release >> %file%/%file%"_info"/device_info.txt
echo Fingerprint: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ro.build.fingerprint >> %file%/%file%"_info"/device_info.txt
echo Build Date: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ro.build.date >> %file%/%file%"_info"/device_info.txt
:adb shell ro.build.id >> %file%/%file%"_info"/device_info.txt
:adb shell ro.boot.bootloader >> %file%/%file%"_info"/device_info.txt
:adb shell ro.build.version.security_patch >> %file%/%file%"_info"/device_info.txt
echo Bluetooth MAC address: >> %file%/%file%"_info"/device_info.txt
adb shell settings get secure bluetooth_address >> %file%/%file%"_info"/device_info.txt
echo Bluetooth Name: >> %file%/%file%"_info"/device_info.txt
adb shell settings get secure bluetooth_name >> %file%/%file%"_info"/device_info.txt
echo System Time Zone: >> %file%/%file%"_info"/device_info.txt
adb shell getprop persist.sys.timezone >> %file%/%file%"_info"/device_info.txt
echo USB Config: >> %file%/%file%"_info"/device_info.txt
adb shell getprop persist.sys.usb.config >> %file%/%file%"_info"/device_info.txt
echo Storage MMC Size: >> %file%/%file%"_info"/device_info.txt
adb shell getprop storage.mmc.size >> %file%/%file%"_info"/device_info.txt
echo Notification Sound: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ro.config.notification_sound >> %file%/%file%"_info"/device_info.txt
echo Alarm Alert: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ro.config.alarm_alert >> %file%/%file%"_info"/device_info.txt
echo RingTone: >> %file%/%file%"_info"/device_info.txt
adb shell getprop ro.config.ringtone >> %file%/%file%"_info"/device_info.txt
echo Media Sound: >> %file%/%file%"_info"/device_info.txt
adb shell getprop rro.config.media_sound >> %file%/%file%"_info"/device_info.txt
echo Shell Date: >> %file%/%file%"_info"/device_info.txt
adb shell date >> %file%/%file%"_info"/device_info.txt
:: Success! On to the next.
echo Getting Live Information [Stage 2 of 5]
adb shell id > %file%/%file%"_live"/id.txt
adb shell uname -a > %file%/%file%"_live"/uname.txt
adb shell cat /proc/version > %file%/%file%"_live"/cat.txt
adb shell uptime > %file%/%file%"_live"/uptime.txt
adb shell printenv > %file%/%file%"_live"/printenv.txt
:adb shell cat /proc/partitions > %file%/%file%"_live"/partitions.txt
adb shell cat /proc/cpuinfo > %file%/%file%"_live"/cpuinfo.txt
:adb shell cat /proc/diskstats > %file%/%file%"_live"/diskstats.txt
adb shell df > %file%/%file%"_live"/df.txt
adb shell df -ah > %file%/%file%"_live"/df-ah.txt
adb shell mount > %file%/%file%"_live"/mount.txt
adb shell ip address show wlan0 > %file%/%file%"_live"/ip_address_show_wlan0.txt
adb shell ifconfig -a > %file%/%file%"_live"/ifconfig.txt
adb shell netstat -an > %file%/%file%"_live"/netstat.txt
adb shell lsof > %file%/%file%"_live"/lsof.txt
adb shell ps -ef > %file%/%file%"_live"/ps.txt
adb shell top -n 1 > %file%/%file%"_live"/top.txt
:adb shell cat /proc/sched_debug > %file%/%file%"_live"/sched_debug.txt
adb shell vmstat > %file%/%file%"_live"/vmstat.txt
@echo off
>NUL adb shell sysctl -a > %file%/%file%"_live"/sysctl.txt >nul 2>nul
adb shell ime list > %file%/%file%"_live"/ime_list.txt
adb shell service list > %file%/%file%"_live"/service_list.txt
adb shell logcat -S -b all > %file%/%file%"_live"/sound.txt
adb shell logcat -d -b all V:* > %file%/%file%"_live"/time.txt
:: Partial Success! On to the next.
echo Getting Package Manager Information [Stage 3 of 5]
adb shell pm get-max-users > %file%/%file%"_package_manager"/get-max-users.txt
adb shell pm list users > %file%/%file%"_package_manager"/list_users.txt
adb shell pm list features > %file%/%file%"_package_manager"/list_features.txt
adb shell pm list instrumentation > %file%/%file%"_package_manager"/list_instrumentation.txt
adb shell pm list libraries -f > %file%/%file%"_package_manager"/list_libraries.txt
adb shell pm list packages -f > %file%/%file%"_package_manager"/list_packages.txt
adb shell pm list packages -f -u > %file%/%file%"_package_manager"/list_packages.txt
adb shell pm list permissions -f > %file%/%file%"_package_manager"/list_permissions.txt
:adb shell cat /data/system/uiderrors.txt > %file%/%file%"_package_manager"/uiderrors.txt
:: Partial Success! On to the next.
echo Getting Dumpsys Information [Stage 4 of 5]
:adb bugreport > %file%/%file%"_dumpsys"/bugreport.txt
:adb shell dumpsys  > %file%/%file%"_dumpsys"/dumpsys.txt
adb shell dumpsys account > %file%/%file%"_dumpsys"/dumpsys_account.txt
adb shell dumpsys activity > %file%/%file%"_dumpsys"/dumpsys_activity.txt
adb shell dumpsys alarm > %file%/%file%"_dumpsys"/dumpsys_alarm.txt
adb shell dumpsys appops > %file%/%file%"_dumpsys"/dumpsys_appops.txt
adb shell dumpsys audio > %file%/%file%"_dumpsys"/dumpsys_audio.txt
adb shell dumpsys autofill > %file%/%file%"_dumpsys"/dumpsys_autofill.txt
adb shell dumpsys backup > %file%/%file%"_dumpsys"/dumpsys_backup.txt
adb shell dumpsys battery > %file%/%file%"_dumpsys"/dumpsys_battery.txt
adb shell dumpsys batteryproperties > %file%/%file%"_dumpsys"/dumpsys_batteryproperties.txt
adb shell dumpsys batterystats > %file%/%file%"_dumpsys"/dumpsys_batterystats.txt
adb shell dumpsys bluetooth_manager > %file%/%file%"_dumpsys"/dumpsys_bluetooth_manager.txt
adb shell dumpsys carrier_config > %file%/%file%"_dumpsys"/dumpsys_carrier_config.txt
adb shell dumpsys clipboard > %file%/%file%"_dumpsys"/dumpsys_clipboard.txt
adb shell dumpsys connectivity > %file%/%file%"_dumpsys"/dumpsys_connectivity.txt
adb shell dumpsys content > %file%/%file%"_dumpsys"/dumpsys_content.txt
adb shell dumpsys cpuinfo > %file%/%file%"_dumpsys"/dumpsys_cpuinfo.txt
adb shell dumpsys dbinfo > %file%/%file%"_dumpsys"/dumpsys_dbinfo.txt
adb shell dumpsys device_policy > %file%/%file%"_dumpsys"/dumpsys_device_policy.txt
adb shell dumpsys devicestoragemonitor > %file%/%file%"_dumpsys"/dumpsys_devicestoragemonitor.txt
adb shell dumpsys diskstats > %file%/%file%"_dumpsys"/dumpsys_diskstats.txt
adb shell dumpsys display > %file%/%file%"_dumpsys"/dumpsys_display.txt
adb shell dumpsys dropbox > %file%/%file%"_dumpsys"/dumpsys_dropbox.txt
adb shell dumpsys gfxinfo > %file%/%file%"_dumpsys"/dumpsys_gfxinfo.txt
adb shell dumpsys iphonesubinfo > %file%/%file%"_dumpsys"/dumpsys_iphonesubinfo.txt
adb shell dumpsys jobscheduler > %file%/%file%"_dumpsys"/dumpsys_jobscheduler.txt
adb shell dumpsys location > %file%/%file%"_dumpsys"/dumpsys_location.txt
adb shell dumpsys meminfo -a > %file%/%file%"_dumpsys"/dumpsys_meminfo.txt
adb shell dumpsys mount > %file%/%file%"_dumpsys"/dumpsys_mount.txt
adb shell dumpsys netpolicy > %file%/%file%"_dumpsys"/dumpsys_netpolicy.txt
adb shell dumpsys netstats > %file%/%file%"_dumpsys"/dumpsys_netstats.txt
adb shell dumpsys network_management > %file%/%file%"_dumpsys"/dumpsys_network_management.txt
adb shell dumpsys network_score > %file%/%file%"_dumpsys"/dumpsys_network_score.txt
adb shell dumpsys notification > %file%/%file%"_dumpsys"/dumpsys_notification.txt
adb shell dumpsys package > %file%/%file%"_dumpsys"/dumpsys_package.txt
:adb shell dumpsys password_policy > %file%/%file%"_dumpsys"/dumpsys_password_policy.txt
adb shell dumpsys permission > %file%/%file%"_dumpsys"/dumpsys_permission.txt
adb shell dumpsys phone > %file%/%file%"_dumpsys"/dumpsys_phone.txt
adb shell dumpsys power > %file%/%file%"_dumpsys"/dumpsys_power.txt
adb shell dumpsys procstats --full-details > %file%/%file%"_dumpsys"/dumpsys_procstats.txt
:adb shell dumpsys restriction_policy > %file%/%file%"_dumpsys"/dumpsys_restriction_policy.txt
:adb shell dumpsys sdhms > %file%/%file%"_dumpsys"/dumpsys_sdhms.txt
:adb shell dumpsys sec_location > %file%/%file%"_dumpsys"/dumpsys_sec_location.txt
:adb shell dumpsys secims > %file%/%file%"_dumpsys"/dumpsys_secims.txt
adb shell dumpsys search > %file%/%file%"_dumpsys"/dumpsys_search.txt
adb shell dumpsys sensorservice > %file%/%file%"_dumpsys"/dumpsys_sensorservice.txt
adb shell dumpsys settings > %file%/%file%"_dumpsys"/dumpsys_settings.txt
adb shell dumpsys shortcut > %file%/%file%"_dumpsys"/dumpsys_shortcut.txt
adb shell dumpsys stats > %file%/%file%"_dumpsys"/dumpsys_stats.txt
adb shell dumpsys statusbar > %file%/%file%"_dumpsys"/dumpsys_statusbar.txt
adb shell dumpsys storaged > %file%/%file%"_dumpsys"/dumpsys_storaged.txt
adb shell dumpsys telecom > %file%/%file%"_dumpsys"/dumpsys_telecom.txt
adb shell dumpsys usagestats > %file%/%file%"_dumpsys"/dumpsys_usagestats.txt
adb shell dumpsys user > %file%/%file%"_dumpsys"/dumpsys_user.txt
adb shell dumpsys usb > %file%/%file%"_dumpsys"/dumpsys_usb.txt
adb shell dumpsys vibrator > %file%/%file%"_dumpsys"/dumpsys_vibrator.txt
adb shell dumpsys wallpaper > %file%/%file%"_dumpsys"/dumpsys_wallpaper.txt
adb shell dumpsys wifi > %file%/%file%"_dumpsys"/dumpsys_wifi.txt
adb shell dumpsys window > %file%/%file%"_dumpsys"/dumpsys_window.txt
:: Partial Success! On to the next.

:adb backup -all -shared -system -apk -f > %file%/%file%"_backup"/backup.ab
:Leave this for now - onwards!
:might need to try robocopy and getting errors, probably from line one.
:adb pull /system/ > %file%/%file%"_system"/
:adb pull /system/app > %file%/%file%"_system"/
:adb pull /system/camerdata > %file%/%file%"_system"/camerdata.txt
:adb pull /system/cameradata > %file%/%file%"_system"/cameradata.txt
:adb pull /system/container > %file%/%file%"_system"/container.txt
:adb pull /system/etc > %file%/%file%"_system"/etc.txt
:adb pull /system/fake-libs > %file%/%file%"_system"/fake-libs.txt
:adb pull /system/fonts > %file%/%file%"_system"/fonts.txt
:adb pull /system/framework > %file%/%file%"_system"/framework.txt
:adb pull /system/hidden > %file%/%file%"_system"/hidden.txt
:adb pull /system/lib > %file%/%file%"_system"/lib.txt
:adb pull /system/lib64 > %file%/%file%"_system"/lib64.txt
:adb pull /system/media > %file%/%file%"_system"/media.txt
:adb pull /system/priv-app > %file%/%file%"_system"/priv-app.txt
:adb pull /system/saiv > %file%/%file%"_system"/saiv.txt
:adb pull /system/tts > %file%/%file%"_system"/tts.txt
:adb pull /system/usr > %file%/%file%"_system"/usr.txt
:adb pull /system/vendor > %file%/%file%"_system"/vendor.txt
:adb pull /system/xbin > %file%/%file%"_system"/xbin.txt

:xcopy usr\ %file%/%file%"_system/usr"\ /s /-y
:xcopy priv-app\ %file%/%file%"_system/priv-app"\ /s /-y
:xcopy vendor\ %file%/%file%"_system/vendor"\ /s /-y
:xcopy lib\ %file%/%file%"_system/lib"\ /s /-y
:xcopy lib64\ %file%/%file%"_system/lib64"\ /s /-y
:xcopy fonts\ %file%/%file%"_system/fonts"\ /s /-y
:xcopy framework\ %file%/%file%"_system/framework"\ /s /-y
:xcopy etc\ %file%/%file%"_system/etc"\ /s /-y
:rmdir usr /s /q
:rmdir priv-app /s /q
:rmdir vendor /s /q
:rmdir lib /s /q
:rmdir lib64 /s /q
:rmdir fonts /s /q
:rmdir framework /s /q
:rmdir etc /s /q

:Sucess!
:adb pull /sdcard
:xcopy sdcard\ %file%/%file%"_sdcard"\ /s /-y
:Next!
: This causes errors
echo Getting Content Provider Information [Stage 5 of 5 ... nearly done!!]
adb shell content query --uri content://com.android.calendar/calendar_entities > %file%/%file%"_contentprovider"/calendar_entities.txt
adb shell content query --uri content://com.android.calendar/calendars > %file%/%file%"_contentprovider"/calendars.txt
adb shell content query --uri content://com.android.calendar/attendees > %file%/%file%"_contentprovider"/attendees.txt
adb shell content query --uri content://com.android.calendar/event_entities > %file%/%file%"_contentprovider"/event_entities.txt
adb shell content query --uri content://com.android.calendar/events > %file%/%file%"_contentprovider"/events.txt
adb shell content query --uri content://com.android.calendar/properties > %file%/%file%"_contentprovider"/properties.txt
adb shell content query --uri content://com.android.calendar/reminders > %file%/%file%"_contentprovider"/reminders.txt
adb shell content query --uri content://com.android.calendar/calendar_alerts > %file%/%file%"_contentprovider"/calendar_alerts.txt
adb shell content query --uri content://com.android.calendar/colors > %file%/%file%"_contentprovider"/colors.txt
adb shell content query --uri content://com.android.calendar/extendedproperties > %file%/%file%"_contentprovider"/extendedproperties.txt
adb shell content query --uri content://com.android.calendar/syncstate > %file%/%file%"_contentprovider"/syncstate.txt
adb shell content query --uri content://com.android.contacts/raw_contacts > %file%/%file%"_contentprovider"/raw_contacts.txt
adb shell content query --uri content://com.android.contacts/directories > %file%/%file%"_contentprovider"/directories.txt
adb shell content query --uri content://com.android.contacts/syncstate > %file%/%file%"_contentprovider"/syncstate.txt
adb shell content query --uri content://com.android.contacts/profile/syncstate > %file%/%file%"_contentprovider"/profilesyncstate.txt
adb shell content query --uri content://com.android.contacts/contacts > %file%/%file%"_contentprovider"/contacts.txt
adb shell content query --uri content://com.android.contacts/profile/raw_contacts > %file%/%file%"_contentprovider"/profileraw_contacts.txt
adb shell content query --uri content://com.android.contacts/profile > %file%/%file%"_contentprovider"/profile.txt
adb shell content query --uri content://com.android.contacts/profile/as_vcard > %file%/%file%"_contentprovider"/profileas_vcard.txt
adb shell content query --uri content://com.android.contacts/stream_items > %file%/%file%"_contentprovider"/stream_items.txt
adb shell content query --uri content://com.android.contacts/stream_items/photo > %file%/%file%"_contentprovider"/stream_itemsphoto.txt
adb shell content query --uri content://com.android.contacts/stream_items_limit > %file%/%file%"_contentprovider"/stream_items_limit.txt
adb shell content query --uri content://com.android.contacts/data > %file%/%file%"_contentprovider"/data.txt
adb shell content query --uri content://com.android.contacts/raw_contact_entities > %file%/%file%"_contentprovider"/raw_contact_entities.txt
adb shell content query --uri content://com.android.contacts/profile/raw_contact_entities > %file%/%file%"_contentprovider"/profileraw_contact_entities.txt
adb shell content query --uri content://com.android.contacts/status_updates > %file%/%file%"_contentprovider"/status_updates.txt
adb shell content query --uri content://com.android.contacts/data/phones > %file%/%file%"_contentprovider"/dataphones.txt
adb shell content query --uri content://com.android.contacts/data/phones/filter > %file%/%file%"_contentprovider"/dataphonesfilter.txt
adb shell content query --uri content://com.android.contacts/data/emails/lookup > %file%/%file%"_contentprovider"/dataemailslookup.txt
adb shell content query --uri content://com.android.contacts/data/emails/filter > %file%/%file%"_contentprovider"/dataemailsfilter.txt
adb shell content query --uri content://com.android.contacts/data/emails > %file%/%file%"_contentprovider"/dataemails.txt
adb shell content query --uri content://com.android.contacts/data/postals > %file%/%file%"_contentprovider"/datapostals.txt
adb shell content query --uri content://com.android.contacts/groups > %file%/%file%"_contentprovider"/groups.txt
adb shell content query --uri content://com.android.contacts/groups_summary > %file%/%file%"_contentprovider"/groups_summary.txt
adb shell content query --uri content://com.android.contacts/aggregation_exceptions > %file%/%file%"_contentprovider"/aggregation_exceptions.txt
adb shell content query --uri content://com.android.contacts/settings > %file%/%file%"_contentprovider"/settings.txt
adb shell content query --uri content://com.android.contacts/provider_status > %file%/%file%"_contentprovider"/provider_status.txt
adb shell content query --uri content://com.android.contacts/photo_dimensions > %file%/%file%"_contentprovider"/photo_dimensions.txt
adb shell content query --uri content://com.android.contacts/deleted_contacts > %file%/%file%"_contentprovider"/deleted_contacts.txt
:adb shell content query --uri content://downloads/my_downloads > %file%/%file%"_contentprovider"/my_downloads.txt
:adb shell content query --uri content://downloads/download > %file%/%file%"_contentprovider"/download.txt
adb shell content query --uri content://media/external/file > %file%/%file%"_contentprovider"/externalfile.txt
adb shell content query --uri content://media/external/images/media > %file%/%file%"_contentprovider"/externalimagesmedia.txt
adb shell content query --uri content://media/external/images/thumbnails > %file%/%file%"_contentprovider"/externalimagesthumbnails.txt
adb shell content query --uri content://media/external/audio/media > %file%/%file%"_contentprovider"/externalaudiomedia.txt
adb shell content query --uri content://media/external/audio/genres > %file%/%file%"_contentprovider"/externalaudiogenres.txt
:adb shell content query --uri content://media/external/audio/playlists > %file%/%file%"_contentprovider"/externalaudioplaylists.txt
adb shell content query --uri content://media/external/audio/artists > %file%/%file%"_contentprovider"/externalaudioartists.txt
adb shell content query --uri content://media/external/audio/albums > %file%/%file%"_contentprovider"/externalaudioalbums.txt
adb shell content query --uri content://media/external/video/media > %file%/%file%"_contentprovider"/externalvideomedia.txt
adb shell content query --uri content://media/external/video/thumbnails > %file%/%file%"_contentprovider"/externalvideothumbnails.txt
adb shell content query --uri content://media/internal/file > %file%/%file%"_contentprovider"/internalfile.txt
adb shell content query --uri content://media/internal/images/media > %file%/%file%"_contentprovider"/internalimagesmedia.txt
adb shell content query --uri content://media/internal/images/thumbnails > %file%/%file%"_contentprovider"/internalimagesthumbnails.txt
adb shell content query --uri content://media/internal/audio/media > %file%/%file%"_contentprovider"/internalaudiomedia.txt
adb shell content query --uri content://media/internal/audio/genres > %file%/%file%"_contentprovider"/internalaudiogenres.txt
:adb shell content query --uri content://media/internal/audio/playlists > %file%/%file%"_contentprovider"/internalaudioplaylists.txt
adb shell content query --uri content://media/internal/audio/artists > %file%/%file%"_contentprovider"/internalaudioartists.txt
adb shell content query --uri content://media/internal/audio/albums > %file%/%file%"_contentprovider"/internalaudioalbums.txt
adb shell content query --uri content://media/internal/video/media > %file%/%file%"_contentprovider"/internalvideomedia.txt
adb shell content query --uri content://media/internal/video/thumbnails > %file%/%file%"_contentprovider"/internalvideothumbnails.txt
adb shell content query --uri content://settings/system > %file%/%file%"_contentprovider"/system.txt
adb shell content query --uri content://settings/system/ringtone > %file%/%file%"_contentprovider"/systemringtone.txt
adb shell content query --uri content://settings/system/alarm_alert > %file%/%file%"_contentprovider"/systemalarm_alert.txt
adb shell content query --uri content://settings/system/notification_sound > %file%/%file%"_contentprovider"/systemnotification_sound.txt
adb shell content query --uri content://settings/secure > %file%/%file%"_contentprovider"/secure.txt
adb shell content query --uri content://settings/global > %file%/%file%"_contentprovider"/global.txt
adb shell content query --uri content://settings/bookmarks > %file%/%file%"_contentprovider"/bookmarks.txt
adb shell content query --uri content://com.google.settings/partner > %file%/%file%"_contentprovider"/partner.txt
:adb shell content query --uri content://nwkinfo/nwkinfo/carriers > %file%/%file%"_contentprovider"/nwkinfocarriers.txt
:adb shell content query --uri content://com.android.settings.personalvibration.PersonalVibrationProvider/ > %file%/%file%"_contentprovider"/PersonalVibrationProvider.txt
adb shell content query --uri content://settings/system/bluetooth_devices > %file%/%file%"_contentprovider"/systembluetooth_devices.txt
adb shell content query --uri content://settings/system/powersavings_appsettings > %file%/%file%"_contentprovider"/systempowersavings_appsettings.txt
adb shell content query --uri content://user_dictionary/words > %file%/%file%"_contentprovider"/words.txt
adb shell content query --uri content://browser/bookmarks > %file%/%file%"_contentprovider"/bookmarks.txt
adb shell content query --uri content://browser/searches > %file%/%file%"_contentprovider"/searches.txt
adb shell content query --uri content://com.android.browser > %file%/%file%"_contentprovider"/browser.txt
adb shell content query --uri content://com.android.browser/accounts > %file%/%file%"_contentprovider"/accounts.txt
adb shell content query --uri content://com.android.browser/accounts/account_name > %file%/%file%"_contentprovider"/accountsaccount_name.txt
adb shell content query --uri content://com.android.browser/accounts/account_type > %file%/%file%"_contentprovider"/accountsaccount_type.txt
adb shell content query --uri content://com.android.browser/accounts/sourceid > %file%/%file%"_contentprovider"/accountssourceid.txt
adb shell content query --uri content://com.android.browser/settings > %file%/%file%"_contentprovider"/settings.txt
adb shell content query --uri content://com.android.browser/syncstate > %file%/%file%"_contentprovider"/syncstate.txt
adb shell content query --uri content://com.android.browser/images > %file%/%file%"_contentprovider"/images.txt
adb shell content query --uri content://com.android.browser/image_mappings > %file%/%file%"_contentprovider"/image_mappings.txt
adb shell content query --uri content://com.android.browser/bookmarks > %file%/%file%"_contentprovider"/bookmarks.txt
adb shell content query --uri content://com.android.browser/bookmarks/folder > %file%/%file%"_contentprovider"/bookmarksfolder.txt
adb shell content query --uri content://com.android.browser/history > %file%/%file%"_contentprovider"/history.txt
adb shell content query --uri content://com.android.browser/bookmarks/search_suggest_query > %file%/%file%"_contentprovider"/bookmarkssearch_suggest_query.txt
adb shell content query --uri content://com.android.browser/searches > %file%/%file%"_contentprovider"/searches.txt
adb shell content query --uri content://com.android.browser/combined > %file%/%file%"_contentprovider"/combined.txt


:echo.
:echo Harvest Complete >> %drive%/%file%/%file%.txt
:echo.d

@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "skip=1 tokens=1-6" %%A IN ('WMIC ^Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') DO (
    IF %%A GTR 0 (
	SET Hour=%%B
	SET Min=%%C
	SET Sec=%%E
    )
)

set now2=%hour%:%min%:%sec%

echo Batch Stop Time: >> %file%/%file%.txt
echo %now2% >> %file%/%file%.txt
echo.
echo Android Triage Process Complete.
:echo.
echo We are done here. 
echo.
@echo off
xcopy android_triage_2_long.bat %file% >nul 2>nul
@echo off
ren %file%\android_triage_2_long.bat android_triage_2_long.backup >nul 2>nul
pause
exit
:error
echo.
echo Error : the specified path does not exist. 
echo.
pause
goto harvest
:finish
echo.
echo Exiting now.
echo.
pause
exit




