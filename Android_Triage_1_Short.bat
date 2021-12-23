::V1.1 23/12/21
::V1.0 20/12/21
cls
:echo Attemping to run short triage dump from android phone.
:echo Android Triage script - short version
:echo windows adapation by James Firth
:echo Based on the work of Mattia Epifani
:echo https://blog.digital-forensics.it/2021/03/triaging-modern-android-devices-aka.html
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

echo Android Triage Script - Short Version V1.1
echo Windows Adapation by 2392 James FIRTH of Cambridgeshire Constabulary
echo Based on the work of Mattia Epifani
echo https://blog.digital-forensics.it/2021/03/triaging-modern-android-devices-aka.html

if %Month% LSS 10 set Month=0%Month%
if %Day% LSS 10 set Day=0%Day%
if %Min% LSS 10 set Minute=0%Minute%
if %Hour% LSS 10 set Hour=0%Hour%

set now=%year%-%month%-%day%_%hour%-%min%-%sec%
set now=%now%
set start_time=%hour%:%min%:%sec%


set file=%now%
set info_output=%file%/%file%
echo.
echo.
echo Data is Being Output to : %file%
echo Attemping to run short triage dump from android phone.
echo This normally takes around less than a minute... no time for coffee
echo.
echo.
md %file%
:: Unsure why getting an error here.
date /T > %file%/%file%.txt
echo System Time: >> %file%/%file%.txt
:time /T >> %file%/%file%.txt
echo %start_time% >> %file%/%file%.txt

@echo off
:: Success! On to the next.
:adb shell dumpsys account > %file%/dumpsys_account.txt
:adb shell dumpsys activity > %file%/dumpsys_activity.txt
:adb shell dumpsys alarm > %file%/dumpsys_alarm.txt
:adb shell dumpsys appops > %file%/dumpsys_appops.txt
:adb shell dumpsys audio > %file%/dumpsys_audio.txt
:adb shell dumpsys autofill > %file%/dumpsys_autofill.txt
:adb shell dumpsys backup > %file%/dumpsys_backup.txt
:adb shell dumpsys battery > %file%/dumpsys_battery.txt
:adb shell dumpsys batteryproperties > %file%/dumpsys_batteryproperties.txt
:adb shell dumpsys batterystats > %file%/dumpsys_batterystats.txt
adb shell dumpsys bluetooth_manager > %file%/dumpsys_bluetooth_manager.txt
:adb shell dumpsys carrier_config > %file%/dumpsys_carrier_config.txt
:adb shell dumpsys clipboard > %file%/dumpsys_clipboard.txt
:adb shell dumpsys connectivity > %file%/dumpsys_connectivity.txt
:adb shell dumpsys content > %file%/dumpsys_content.txt
:adb shell dumpsys cpuinfo > %file%/dumpsys_cpuinfo.txt
:adb shell dumpsys dbinfo > %file%/dumpsys_dbinfo.txt
:adb shell dumpsys device_policy > %file%/dumpsys_device_policy.txt
:adb shell dumpsys devicestoragemonitor > %file%/dumpsys_devicestoragemonitor.txt
:adb shell dumpsys diskstats > %file%/dumpsys_diskstats.txt
:adb shell dumpsys display > %file%/dumpsys_display.txt
:adb shell dumpsys dropbox > %file%/dumpsys_dropbox.txt
:adb shell dumpsys gfxinfo > %file%/dumpsys_gfxinfo.txt
:adb shell dumpsys iphonesubinfo > %file%/dumpsys_iphonesubinfo.txt
:adb shell dumpsys jobscheduler > %file%/dumpsys_jobscheduler.txt
:adb shell dumpsys location > %file%/dumpsys_location.txt
:adb shell dumpsys meminfo -a > %file%/dumpsys_meminfo.txt
:adb shell dumpsys mount > %file%/dumpsys_mount.txt
:adb shell dumpsys netpolicy > %file%/dumpsys_netpolicy.txt
:adb shell dumpsys netstats > %file%/dumpsys_netstats.txt
:adb shell dumpsys network_management > %file%/dumpsys_network_management.txt
:adb shell dumpsys network_score > %file%/dumpsys_network_score.txt
:adb shell dumpsys notification > %file%/dumpsys_notification.txt
:adb shell dumpsys package > %file%/dumpsys_package.txt
:adb shell dumpsys password_policy > %file%/dumpsys_password_policy.txt
:adb shell dumpsys permission > %file%/dumpsys_permission.txt
:adb shell dumpsys phone > %file%/dumpsys_phone.txt
:adb shell dumpsys power > %file%/dumpsys_power.txt
:adb shell dumpsys procstats --full-details > %file%/dumpsys_procstats.txt
:adb shell dumpsys restriction_policy > %file%/dumpsys_restriction_policy.txt
:adb shell dumpsys sdhms > %file%/dumpsys_sdhms.txt
:adb shell dumpsys sec_location > %file%/dumpsys_sec_location.txt
:adb shell dumpsys secims > %file%/dumpsys_secims.txt
:adb shell dumpsys search > %file%/dumpsys_search.txt
:adb shell dumpsys sensorservice > %file%/dumpsys_sensorservice.txt
:adb shell dumpsys settings > %file%/dumpsys_settings.txt
:adb shell dumpsys shortcut > %file%/dumpsys_shortcut.txt
:adb shell dumpsys stats > %file%/dumpsys_stats.txt
:adb shell dumpsys statusbar > %file%/dumpsys_statusbar.txt
:adb shell dumpsys storaged > %file%/dumpsys_storaged.txt
adb shell dumpsys telecom > %file%/dumpsys_telecom.txt
adb shell dumpsys usagestats > %file%/dumpsys_usagestats.txt
:adb shell dumpsys user > %file%/dumpsys_user.txt
:adb shell dumpsys usb > %file%/dumpsys_usb.txt
:adb shell dumpsys vibrator > %file%/dumpsys_vibrator.txt
:adb shell dumpsys wallpaper > %file%/dumpsys_wallpaper.txt
adb shell dumpsys wifi > %file%/dumpsys_wifi.txt
:adb shell dumpsys window > %file%/dumpsys_window.txt
:: Partial Success! On to the next.


:echo.
:echo Harvest Complete >> %drive%/%file%/%file%.txt
:echo.d
:echo.
echo.



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
@echo off
xcopy android_triage_1_short.bat %file% >nul 2>nul
@echo off
ren %file%\android_triage_1_short.bat android_triage_1_short.backup >nul 2>nul
cls
echo Android Triage Process Complete.
echo We are done here. 
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




