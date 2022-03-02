::V1.3 23/2/22
::Fixed error when hour is a single digit value (such as 09:59 which time returns as 9:59 and causes errors)
::V1.2 01/02/22
::Microsoft has culled WMIC so cannot get a reliable date stamp.
::V1.1 23/12/21
::V1.0 20/12/21
cls
:echo Attemping to run short triage dump from android phone.
:echo Android Triage script - short version
:echo windows adapation by James FIRTH
:echo Based on the work of Mattia Epifani
:echo https://blog.digital-forensics.it/2021/03/triaging-modern-android-devices-aka.html
:echo This program comes with ABSOLUTELY NO WARRANTY.
:echo \
:echo \
:echo This is free software and you are welcome to redistribute or modify it
:echo.
:set drive=%cd:~0,2%
:if %drive%==x goto finish
:if %drive%==X goto finish
:If not exist %drive%\NUL goto error


@echo off

echo Android Triage Script - Short Version V1.2
echo Windows Adapation by James FIRTH
echo Based on the work of Mattia Epifani
echo https://blog.digital-forensics.it/2021/03/triaging-modern-android-devices-aka.html
echo\ 
echo\ 
@echo off
set date=%date%
set start_time=%time%
set info_output=%date%%time%
Set info_output=%info_output:/=%
Set info_output=%info_output:.=%
Set info_output=%info_output::=%
Set day=%info_output:~0,2%
Set Month=%info_output:~2,2%
Set Year=%info_output:~4,4%
Set hour=%info_output:~8,2%
Set minute=%info_output:~10,2%
Set second=%info_output:~12,2%
Set semi=%info_output:~14,2%
Set hourcheck=%info_output:~8,1%

if "%hourcheck%"==" " (set hour=0%info_output:~9,1%)

set file=%year%-%day%-%month%_%hour%-%minute%-%second%
set log_output=%file%/%file%
echo %date%%time%%hour%
:Remove the starting ":" from the next two lines to allow a human created folder
:set /p file="Enter Exhibit Name For Output (ie JAF_01022022_001): "
:set file = %file%
echo.
echo.
echo Data is Being Output to : %file%
echo Attemping to run short triage dump from android phone.
echo This normally takes around less than a minute... no time for coffee
echo.
echo.
if exist %file% goto error
md %file%
echo %date% > %file%/%file%.txt
echo System Time: >> %file%/%file%.txt
echo %time% >> %file%/%file%.txt


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
adb shell dumpsys netstats > %file%/dumpsys_netstats.txt
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

echo Batch Stop Time: >> %file%/%file%.txt
echo %time% >> %file%/%file%.txt

@echo off
xcopy android_triage.bat %file% >nul 2>nul
@echo off
ren %file%\android_triage.bat android_triage.backup >nul 2>nul
cls
echo Android Triage Process Complete.
echo We are done here. 
pause
exit
:error
echo.
echo Error : the specified path exists! 
echo.
pause
goto harvest
:finish
echo.
echo Exiting now.
echo.
pause
exit




