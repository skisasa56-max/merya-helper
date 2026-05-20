; ====================================================================================================
; ÐœÐ­Ð Ð˜Ð¯ HELPER v18.1
; ====================================================================================================
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%

; ====================================================================================================
; ÐÐÐ¡Ð¢Ð ÐžÐ™ÐšÐ˜ ÐÐ’Ð¢ÐžÐžÐ‘ÐÐžÐ’Ð›Ð•ÐÐ˜Ð¯ (Ð¡Ð˜ÐÐ¥Ð ÐžÐÐÐÐ¯ ÐŸÐ ÐžÐ’Ð•Ð ÐšÐ)
; ====================================================================================================
global ScriptVersion := "18.2"
global UpdateCheckUrl := "https://raw.githubusercontent.com/skisasa56-max/merya-helper/main/version.txt"
global ScriptDownloadUrl := "https://raw.githubusercontent.com/skisasa56-max/merya-helper/main/AutoHotkey%20Script%20(2).ahk"
global UpdateTempFile := A_Temp "\mhelper_new.ahk"

; Ð¤Ð£ÐÐšÐ¦Ð˜Ð˜ ÐžÐ‘ÐÐžÐ’Ð›Ð•ÐÐ˜Ð¯ (Ð”ÐžÐ›Ð–ÐÐ« Ð‘Ð«Ð¢Ð¬ ÐžÐŸÐ Ð•Ð”Ð•Ð›Ð•ÐÐ« Ð”Ðž Ð’Ð«Ð—ÐžÐ’Ð)
CheckForUpdates(showMsg := false) {
    global ScriptVersion, UpdateCheckUrl, ScriptDownloadUrl, UpdateTempFile
    tempVerFile := A_Temp "\mhelper_ver.txt"
    URLDownloadToFile, %UpdateCheckUrl%, %tempVerFile%
    if ErrorLevel {
        if showMsg
            MsgBox, 4096, ÐžÑˆÐ¸Ð±ÐºÐ°, ÐÐµ ÑƒÐ´Ð°Ð»Ð¾ÑÑŒ ÑÐ¾ÐµÐ´Ð¸Ð½Ð¸Ñ‚ÑŒÑÑ Ñ ÑÐµÑ€Ð²ÐµÑ€Ð¾Ð¼.
        return 0
    }
    FileRead, remoteVer, %tempVerFile%
    FileDelete, %tempVerFile%
    remoteVer := Trim(remoteVer)
    if (remoteVer = "") {
        if showMsg
            MsgBox, 4096, ÐžÑˆÐ¸Ð±ÐºÐ°, ÐŸÑƒÑÑ‚Ð°Ñ Ð²ÐµÑ€ÑÐ¸Ñ Ð½Ð° ÑÐµÑ€Ð²ÐµÑ€Ðµ.
        return 0
    }
    if (remoteVer != ScriptVersion) {
        msgText = Ð’ÐµÑ€ÑÐ¸Ñ %remoteVer% ÑƒÐ¶Ðµ Ð´Ð¾ÑÑ‚ÑƒÐ¿Ð½Ð°. Ð£ Ð²Ð°Ñ Ð²ÐµÑ€ÑÐ¸Ñ %ScriptVersion%. ÐžÐ±Ð½Ð¾Ð²Ð¸Ñ‚ÑŒ ÑÐµÐ¹Ñ‡Ð°Ñ?
        answer := MsgBox, 4132, Ð”Ð¾ÑÑ‚ÑƒÐ¿Ð½Ð¾ Ð¾Ð±Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ðµ, %msgText%
        if (answer = "Yes") {
            URLDownloadToFile, %ScriptDownloadUrl%, %UpdateTempFile%
            if ErrorLevel {
                MsgBox, 4096, ÐžÑˆÐ¸Ð±ÐºÐ°, ÐÐµ ÑƒÐ´Ð°Ð»Ð¾ÑÑŒ ÑÐºÐ°Ñ‡Ð°Ñ‚ÑŒ Ð¾Ð±Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ðµ.
                return 0
            }
            FileCopy, %UpdateTempFile%, %A_ScriptFullPath%, 1
            if ErrorLevel {
                MsgBox, 4096, ÐžÑˆÐ¸Ð±ÐºÐ°, ÐÐµ ÑƒÐ´Ð°Ð»Ð¾ÑÑŒ Ð·Ð°Ð¼ÐµÐ½Ð¸Ñ‚ÑŒ Ñ„Ð°Ð¹Ð». Ð—Ð°Ð¿ÑƒÑÑ‚Ð¸Ñ‚Ðµ Ð¾Ñ‚ Ð°Ð´Ð¼Ð¸Ð½Ð¸ÑÑ‚Ñ€Ð°Ñ‚Ð¾Ñ€Ð°.
                return 0
            }
            Run, "%A_ScriptFullPath%"
            ExitApp
        }
        return 0
    }
    if showMsg
        MsgBox, 4096, ÐžÐ±Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ñ, Ð£ Ð²Ð°Ñ Ð¿Ð¾ÑÐ»ÐµÐ´Ð½ÑÑ Ð²ÐµÑ€ÑÐ¸Ñ %ScriptVersion%.
    return 1
}

; Ð¡Ð˜ÐÐ¥Ð ÐžÐÐÐÐ¯ ÐŸÐ ÐžÐ’Ð•Ð ÐšÐ ÐŸÐ Ð˜ Ð¡Ð¢ÐÐ Ð¢Ð• (Ð•Ð¡Ð›Ð˜ ÐÐ•Ð¢ Ð˜ÐÐ¢Ð•Ð ÐÐ•Ð¢Ð â€“ Ð—ÐÐšÐ Ð«Ð’ÐÐ•ÐœÐ¡Ð¯)
CheckForUpdates(true)
if (ScriptVersion != "18.2") { ; ÐµÑÐ»Ð¸ Ð²ÐµÑ€ÑÐ¸Ñ Ð¿Ð¾Ð¼ÐµÐ½ÑÐ»Ð°ÑÑŒ Ð²Ð½ÑƒÑ‚Ñ€Ð¸, Ð½Ð¾ Ð¿Ñ€Ð¾Ð²ÐµÑ€ÐºÐ° Ð½Ðµ Ð¿Ñ€Ð¾ÑˆÐ»Ð°
    MsgBox, 4096, ÐšÑ€Ð¸Ñ‚Ð¸Ñ‡ÐµÑÐºÐ°Ñ Ð¾ÑˆÐ¸Ð±ÐºÐ°, ÐÐµ ÑƒÐ´Ð°Ð»Ð¾ÑÑŒ Ð¿Ð¾Ð´Ñ‚Ð²ÐµÑ€Ð´Ð¸Ñ‚ÑŒ Ð²ÐµÑ€ÑÐ¸ÑŽ. Ð¡ÐºÑ€Ð¸Ð¿Ñ‚ Ð·Ð°ÐºÑ€Ñ‹Ñ‚.
    ExitApp
}

OnExit, SaveOnExit
SetTimer, ForceOpenMainGui, -500

; ====================================================================================================
; ÐÐÐ¡Ð¢Ð ÐžÐ™ÐšÐ˜ Ð¢Ð Ð•Ð¯
; ====================================================================================================
Menu, Tray, NoStandard
Menu, Tray, Add, Ð Ð°Ð·Ð²ÐµÑ€Ð½ÑƒÑ‚ÑŒ, RestoreFromTray
Menu, Tray, Add, ÐŸÑ€Ð¾Ð²ÐµÑ€Ð¸Ñ‚ÑŒ Ð¾Ð±Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ñ, CheckUpdatesManual
Menu, Tray, Add, Ðž Ð¿Ñ€Ð¾Ð³Ñ€Ð°Ð¼Ð¼Ðµ, ShowAbout
Menu, Tray, Add  ; Ñ€Ð°Ð·Ð´ÐµÐ»Ð¸Ñ‚ÐµÐ»ÑŒ
Menu, Tray, Add, Ð—Ð°ÐºÑ€Ñ‹Ñ‚ÑŒ, ExitScript

; ====================================================================================================
; ÐŸÐžÐ”ÐšÐ›Ð®Ð§Ð•ÐÐ˜Ð• Ð‘Ð˜Ð‘Ð›Ð˜ÐžÐ¢Ð•Ðš
; ====================================================================================================
#Include %A_ScriptDir%\SAMP.ahk
#Include %A_ScriptDir%\Class_CtlColors.ahk

; ====================================================================================================
; Ð“Ð›ÐžÐ‘ÐÐ›Ð¬ÐÐ«Ð• ÐŸÐ•Ð Ð•ÐœÐ•ÐÐÐ«Ð• (ÐžÐ¡ÐÐžÐ’ÐÐ«Ð•)
; ====================================================================================================
global BindDir := A_MyDocuments "\Binds"
global BindIni := BindDir "\settings.ini"
global TimerHandles := []
global CurrentTimers := []
global UserNick := ""
global UserAccNumber := ""
global Gender := 2
global SelectedTimerRow := 0
global TimerGuiHwnd := 0
global MainGuiHwnd := 0

global Binders := []
global CurrentPage := 1
global SelectedBinderRow := 0
global BinderGuiHwnd := 0
global BinderPages := 2
global HotkeyHandles := []
global WaitingForKey := 0
global TempKeyBind := ""

global AutoProfileActive := 0
global AutoProfileStep := 0
global AutoProfilePressCount := 0
global AutoProfileAccNumber := ""
global AutoProfileName := ""
global AutoProfileLastTime := 0

global AutoRouletteActive := 0
global AutoTimeActive := 0
global PrizeHistory := []
global RouletteAwaitingPrize := 0
global AutoTimeTimerHandle := 0
global LastChatLine := ""
global GameWasMinimized := 0
global RouletteProcessing := 0
global _warnedChat := 0
global LastSmsTime := 0
global LastSmsMessage := ""

global SmsHistory := []
global SmsHistoryFile := BindDir "\sms_history.ini"
global SmsHistoryGuiHwnd := 0
global CurrentSmsNumber := ""
global NotificationGuiHwnd := 0
global CurrentNotificationNumber := ""
global CurrentNotificationName := ""
global CurrentNotificationText := ""
global _historyReplyNumber := ""
global _historyReplyName := ""
global _historyReplyText := ""
global CurrentReplyName := ""
global CityCode := "LV"
global CityName := "Ð›Ð°Ñ-Ð’ÐµÐ½Ñ‚ÑƒÑ€Ð°Ñ"
global LastActivityTime := 0
global UserIsActive := 1
global LicensesOrderGuiHwnd := 0
global InstructionsGuiHwnd := 0


global Tag := "ÐœÑÑ€Ð¸Ñ"
global PendingCaseID := ""
global PendingAcc := ""
global SmsSent := false
global LicenseMenuMode := 0
global TempTotal := 0
global LastPrice := 0
global TargetID := ""
global TargetName := ""
global LicenseProcess := 0
global WaitingForPayment := false
global LawyerResult := 0 ; 0 - Ð½ÐµÑ‚, 1 - Ð¾Ð¿Ñ€Ð°Ð²Ð´Ð°Ð½, 2 - Ð¾Ñ‚ÐºÐ°Ð·
global LawyerTargetName := ""

global LicNames := ["ÑƒÐ¿Ñ€Ð°Ð²Ð»ÐµÐ½Ð¸Ðµ Ð½Ð°Ð·ÐµÐ¼Ð½Ñ‹Ð¼ Ñ‚Ñ€Ð°Ð½ÑÐ¿Ð¾Ñ€Ñ‚Ð¾Ð¼", "Ð¿Ñ€Ð¸Ð¾Ð±Ñ€ÐµÑ‚ÐµÐ½Ð¸Ðµ Ð¸ Ð½Ð¾ÑˆÐµÐ½Ð¸Ðµ Ð¾Ñ€ÑƒÐ¶Ð¸Ñ", "ÑƒÐ¿Ñ€Ð°Ð²Ð»ÐµÐ½Ð¸Ðµ Ð²Ð¾Ð´Ð½Ñ‹Ð¼Ð¸ ÑÑƒÐ´Ð°Ð¼Ð¸", "ÑÐºÑÐ¿Ð»ÑƒÐ°Ñ‚Ð°Ñ†Ð¸ÑŽ Ð¸Ð½Ð´Ð¸Ð²Ð¸Ð´ÑƒÐ°Ð»ÑŒÐ½Ñ‹Ñ… Ð»ÐµÑ‚Ð°Ñ‚ÐµÐ»ÑŒÐ½Ñ‹Ñ… Ð°Ð¿Ð¿Ð°Ñ€Ð°Ñ‚Ð¾Ð²", "Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ðµ Ð²Ñ‹ÑÐ¾Ñ‚Ð½Ñ‹Ñ… Ð¿Ð¾Ð»ÐµÑ‚Ð¾Ð²", "ÑƒÐ¿Ñ€Ð°Ð²Ð»ÐµÐ½Ð¸Ðµ Ð²Ð¾Ð·Ð´ÑƒÑˆÐ½Ñ‹Ð¼ Ñ‚Ñ€Ð°Ð½ÑÐ¿Ð¾Ñ€Ñ‚Ð¾Ð¼", "Ð²ÐµÐ´ÐµÐ½Ð¸Ðµ Ð¿Ñ€ÐµÐ´Ð¿Ñ€Ð¸Ð½Ð¸Ð¼Ð°Ñ‚ÐµÐ»ÑŒÑÐºÐ¾Ð¹ Ð´ÐµÑÑ‚ÐµÐ»ÑŒÐ½Ð¾ÑÑ‚Ð¸"]
global LicPrices := [400, 125000, 25000, 5000, 15000, 30000, 250000]

; ====================================================================================================
; Ð˜ÐÐ˜Ð¦Ð˜ÐÐ›Ð˜Ð—ÐÐ¦Ð˜Ð¯
; ====================================================================================================
if !FileExist(BindDir)
    FileCreateDir, %BindDir%

LoadSmsHistory()
IniRead, UserNick, %BindIni%, Settings, Nick,
if (UserNick = "ERROR")
    UserNick := ""
IniRead, UserAccNumber, %BindIni%, Settings, AccNumber,
if (UserAccNumber = "ERROR")
    UserAccNumber := ""
IniRead, Gender, %BindIni%, Settings, Gender, 2
IniRead, CityCode, %BindIni%, Settings, City, LV
if (CityCode != "LV" && CityCode != "SF" && CityCode != "LS")
    CityCode := "LV"
UpdateCityName()
IniRead, AutoRouletteActive, %BindIni%, Settings, AutoRoulette, 0
IniRead, AutoTimeActive, %BindIni%, Settings, AutoTime, 0
LoadTimers()
LoadBinders()
LoadPrizeHistory()
RegisterAllBinderHotkeys()
SetTimer, CheckAutoProfile, 25
SetTimer, MonitorChat, 300
SetTimer, CheckIdle, 60000   ; Ð¿Ñ€Ð¾Ð²ÐµÑ€ÐºÐ° ÐºÐ°Ð¶Ð´ÑƒÑŽ Ð¼Ð¸Ð½ÑƒÑ‚Ñƒ
if (AutoTimeActive = 1)
    StartAutoTime()

; ^!m:: ShowMainGui()
; ^!t:: ShowTimerManager()
; ^!b:: ShowBinderManager()
; ^!r::
;     SaveAllSettings()
;     Reload
; return

; ÐÐ´Ð²Ð¾ÐºÐ°Ñ‚ÑÐºÐ¸Ðµ Ð³Ð¾Ñ€ÑÑ‡Ð¸Ðµ ÐºÐ»Ð°Ð²Ð¸ÑˆÐ¸
^1:: LawyerConditions()          ; Ctrl+1 - ÑƒÑÐ»Ð¾Ð²Ð¸Ñ Ð°Ð´Ð²Ð¾ÐºÐ°Ñ‚Ð°
!1::
    if (UserNick = "")
        SendChat(".Ñ„Ð´ Ð¯ â€” ÑÐ¾Ñ‚Ñ€ÑƒÐ´Ð½Ð¸Ðº Ð¼ÑÑ€Ð¸Ð¸ " CityName "*ÐºÐ¾ÑÐ½ÑƒÐ²ÑˆÐ¸ÑÑŒ Ð¿Ð°Ð»ÑŒÑ†ÐµÐ¼ Ð±ÐµÐ¹Ð´Ð¶Ð°")
    else if (Gender == 1)
        SendChat(".Ñ„Ð´ Ð¯ â€” " UserNick ", ÑÐ¾Ñ‚Ñ€ÑƒÐ´Ð½Ð¸Ðº Ð¼ÑÑ€Ð¸Ð¸ " CityName "*ÐºÐ¾ÑÐ½ÑƒÐ²ÑˆÐ¸ÑÑŒ Ð¿Ð°Ð»ÑŒÑ†ÐµÐ¼ Ð±ÐµÐ¹Ð´Ð¶Ð°")
    else
        SendChat(".Ñ„Ð´ Ð¯ â€” " UserNick ", ÑÐ¾Ñ‚Ñ€ÑƒÐ´Ð½Ð¸Ñ†Ð° Ð¼ÑÑ€Ð¸Ð¸ " CityName "*ÐºÐ¾ÑÐ½ÑƒÐ²ÑˆÐ¸ÑÑŒ Ð¿Ð°Ð»ÑŒÑ†ÐµÐ¼ Ð±ÐµÐ¹Ð´Ð¶Ð°")
return
!2:: ShowLicensesList()
!3::
    LicenseMenuMode := 1
    addChatMessage("{FF0000}[" Tag "] {33AAFF}Ð ÐµÐ¶Ð¸Ð¼ Ñ†ÐµÐ½Ñ‹: {FFFFFF}ÐÐ°Ð¶Ð¼Ð¸Ñ‚Ðµ {FFFF00}1-7 {FFFFFF}Ð´Ð»Ñ Ð¾Ð³Ð»Ð°ÑˆÐµÐ½Ð¸Ñ ÑÑ‚Ð¾Ð¸Ð¼Ð¾ÑÑ‚Ð¸.")
return
!4::
    LicenseMenuMode := 2
    TempTotal := 0
    LastPrice := 0
    addChatMessage("{FF0000}[" Tag "] {00FF00}Ð ÐµÐ¶Ð¸Ð¼ ÑÑƒÐ¼Ð¼Ñ‹: {FFFFFF}Ð’Ñ‹Ð±Ð¸Ñ€Ð°Ð¹Ñ‚Ðµ {FFFF00}1-7{FFFFFF}. Ð˜Ñ‚Ð¾Ð³: {FFA500}Backspace{FFFFFF}. ÐžÑ‚Ð¼ÐµÐ½Ð°: {FF4500}Delete{FFFFFF}.")
return

#If WinActive("ahk_exe gta_sa.exe")
NumpadAdd:: SendInput, {F6}/pagesize 30{Enter}
NumpadSub:: SendInput, {F6}/pagesize 10{Enter}
#If

Home:: SendChat("/Ñ„Ñ€Ð°ÐºÑ†Ð¸Ñ")

!Delete::
    addChatMessage("{00FF00}[" Tag "] ÐŸÐµÑ€ÐµÐ·Ð°Ð³Ñ€ÑƒÐ·ÐºÐ° Ð±Ð¸Ð½Ð´ÐµÑ€Ð°, ÑÑ‚Ð¾ Ð¼Ð¾Ð¶ÐµÑ‚ Ð·Ð°Ð½ÑÑ‚ÑŒ Ð½ÐµÑÐºÐ¾Ð»ÑŒÐºÐ¾ ÑÐµÐºÑƒÐ½Ð´...")
    if (TimerGuiHwnd)
        Gui, TimerGui:Destroy
    if (BinderGuiHwnd)
        Gui, BinderGui:Destroy
    if (InstructionsGuiHwnd)
        Gui, InstructionsGui:Destroy
    if (HotkeysGuiHwnd)
        Gui, HotkeysGui:Destroy
    if (LicensesOrderGuiHwnd)
        Gui, LicensesOrderGui:Destroy
    if (SmsHistoryGuiHwnd)
        Gui, SmsHistoryGui:Destroy
    if (HistoryGuiHwnd)
        Gui, HistoryGui:Destroy
    SaveAllSettings()
    Reload
return

:O:/Ð°Ð²Ñ‚Ð¾Ð¿Ñ€Ð¾Ñ„Ð¸Ð»ÑŒ::
    AutoProfileActive := 1
    AutoProfileStep := 0
    AutoProfilePressCount := 0
    AutoProfileAccNumber := ""
    AutoProfileName := ""
    Sleep, 100
    SendInput, {Y}
    AutoProfileStep := 1
    AutoProfilePressCount := 0
    AutoProfileLastTime := A_TickCount
return

; ====================================================================================================
; ÐŸÐ•Ð Ð•Ð¥Ð’ÐÐ¢ ENTER Ð”Ð›Ð¯ ÐšÐžÐœÐÐÐ”
; ====================================================================================================
~$Enter::
~$NumpadEnter::
    if (WinActive("ahk_exe gta_sa.exe") && isInChat() && !isDialogOpen()) {
        SavedClipboard := ClipboardAll
        Clipboard := ""
        SendInput, {Home}+{End}^c
        ClipWait, 0.1
        chatText := Clipboard

        ; ÐšÐ¾Ð¼Ð°Ð½Ð´Ð° /Ð»Ð¸Ñ†Ð°
        if (RegExMatch(chatText, "i)^[/\.](Ð»Ð¸Ñ†Ð°|lics)\s+(\d+)", Match)) {
            SendInput, {CtrlDown}a{CtrlUp}{Backspace}{Enter}
            TargetID := Match2
            RawName := getPlayerNameById(TargetID)
            TargetName := StrReplace(RawName, "_", " ")
            if (TargetName == "") {
                addChatMessage("{FF0000}[" Tag "] {FFFFFF}Ð˜Ð³Ñ€Ð¾Ðº Ñ Ñ‚Ð°ÐºÐ¸Ð¼ ID Ð½Ðµ Ð½Ð°Ð¹Ð´ÐµÐ½.")
                return
            }
            addChatMessage("{FF0000}[" Tag "] {00FF00}ÐŸÑ€Ð¾Ð´Ð°ÑŽ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸ÑŽ: {FFFFFF}" TargetName)
            LicenseProcess := 1
            SendChat("ÐŸÐ¾Ð¶Ð°Ð»ÑƒÐ¹ÑÑ‚Ð°, Ð¿Ñ€ÐµÐ´ÑŠÑÐ²Ð¸Ñ‚Ðµ Ð²Ð°Ñˆ Ð¿Ð°ÑÐ¿Ð¾Ñ€Ñ‚ Ð´Ð»Ñ Ð¾Ñ„Ð¾Ñ€Ð¼Ð»ÐµÐ½Ð¸Ñ Ð´Ð¾ÐºÑƒÐ¼ÐµÐ½Ñ‚Ð¾Ð².")
            Clipboard := SavedClipboard
            return
        }

        ; ÐšÐ¾Ð¼Ð°Ð½Ð´Ð° /Ð²Ñ‹Ð¿
        if (RegExMatch(chatText, "i)^[/\.](Ð²Ñ‹Ð¿|ÐºÐ¿Ð·|vip)\s+(\d+)", Match)) {
            SendInput, {CtrlDown}a{CtrlUp}{Backspace}{Enter}
            TargetID_Law := Match2
            LawRawName := getPlayerNameById(TargetID_Law)
            LawFullName := LawRawName ? StrReplace(LawRawName, "_", " ") : TargetID_Law
            addChatMessage("{FF0000}[" Tag "] {FFFFFF}Ð Ð°Ð±Ð¾Ñ‚Ð°ÑŽ Ð¿Ð¾: {33AAFF}" LawFullName)
            Data := GetDataFromIngameDialog(TargetID_Law, false)
            if (Data.Acc != "") {
                PendingAcc := Data.Acc
                PendingCaseID := TargetID_Law
                LawyerTargetName := Data.Name
                LawyerResult := 0
                SetTimer, StartLawyerRP, -100
            }
            Clipboard := SavedClipboard
            return
        }

        ; ÐšÐ¾Ð¼Ð°Ð½Ð´Ð° /Ð¸Ð½Ñ„
        if (RegExMatch(chatText, "i)^[/\.](Ð¸Ð½Ñ„|inf)\s+(.+)", Match)) {
            SendInput, {CtrlDown}a{CtrlUp}{Backspace}{Enter}
            Target := Match2
            if (RegExMatch(Target, "^\d+$")) {
                pName := getPlayerNameById(Target)
                addChatMessage("{FF0000}[" Tag "] {FFFFFF}Ð¡Ð¾Ð±Ð¸Ñ€Ð°ÑŽ Ð¸Ð½Ñ„Ð¾Ñ€Ð¼Ð°Ð¸Ñ†ÑŽ Ð½Ð°: {33AAFF}" (pName ? StrReplace(pName, "_", " ") : Target) "...")
                Data := GetDataFromIngameDialog(Target, true)
                if (Data.Acc != "") {
                    addChatMessage("{FF0000}============ Ð˜Ð½Ñ„Ð¾Ñ€Ð¼Ð°Ñ†Ð¸Ñ Ð¾ Ð¸Ð³Ñ€Ð¾ÐºÐµ ============")
                    addChatMessage("{FFFFFF}ÐÐ¸Ðº: {33AAFF}" Data.Name " {FFFFFF}| ÐÐºÐºÐ°ÑƒÐ½Ñ‚: {FFFF00}" Data.Acc)
                    addChatMessage("{FFFFFF}Ð£Ñ€Ð¾Ð²ÐµÐ½ÑŒ: {00FF00}" Data.LVL " {FFFFFF}")
                    if (Data.Bday)
                        addChatMessage("{FFFFFF}Ð”Ð°Ñ‚Ð° Ñ€Ð¾Ð¶Ð´ÐµÐ½Ð¸Ñ: {33AAFF}" Data.Bday)
                    if (Data.Org)
                        addChatMessage("{FFFFFF}ÐžÑ€Ð³Ð°Ð½Ð¸Ð·Ð°Ñ†Ð¸Ñ: {33AAFF}" Data.Org)
                    if (Data.House)
                        addChatMessage("{FFFFFF}Ð”Ð¾Ð¼: {33AAFF}" Data.House)
                    if (Data.Car)
                        addChatMessage("{FFFFFF}Ð¢Ñ€Ð°Ð½ÑÐ¿Ð¾Ñ€Ñ‚: {33AAFF}" Data.Car)
                    if (Data.Family != "" && Data.Family != "Ð¡ÐºÑ€Ñ‹Ñ‚Ð¾")
                        addChatMessage("{FFFFFF}Ð¡ÐµÐ¼ÑŒÑ: {33AAFF}" Data.Family)
                    if (Data.Rep)
                        addChatMessage("{FFFFFF}Ð ÐµÐ¿ÑƒÑ‚Ð°Ñ†Ð¸Ñ: {00FF00}" Data.Rep)
                    addChatMessage("{FF0000}====================================")
                }
            }
            Clipboard := SavedClipboard
            return
        }

        Clipboard := SavedClipboard
    }
    SendInput, {Enter}
return

; ====================================================================================================
; Ð’Ð¡ÐŸÐžÐœÐžÐ“ÐÐ¢Ð•Ð›Ð¬ÐÐ«Ð• Ð¤Ð£ÐÐšÐ¦Ð˜Ð˜
; ====================================================================================================
ShowNotification(title, message, timeoutMs := 5000) {
    TrayTip, %title%, %message%, 20, 1
    SetTimer, ClearTrayTip, % -timeoutMs
}
ClearTrayTip:
    TrayTip
return

LawyerConditions() {
    if (WaitingForPayment) {
        SendChat("ÐÐ°Ð·Ð¾Ð²Ð¸Ñ‚Ðµ Ð˜Ð¼Ñ Ð¸ Ð¤Ð°Ð¼Ð¸Ð»Ð¸ÑŽ Ð·Ð°Ð´ÐµÑ€Ð¶Ð°Ð½Ð½Ð¾Ð³Ð¾")
    } else {
        SendChat("Ð¯ Ð°Ð´Ð²Ð¾ÐºÐ°Ñ‚ Ð³Ð¾Ñ€Ð¾Ð´Ð° " CityName ". Ð”Ð°Ð²Ð°Ð¹Ñ‚Ðµ Ð¿ÐµÑ€ÐµÐ¹Ð´ÐµÐ¼ Ðº Ð´ÐµÐ»Ñƒ.")
        Sleep 1950
        SendChat("ÐžÐ·Ð²ÑƒÑ‡Ñƒ Ð²Ð°Ð¼ ÑƒÑÐ»Ð¾Ð²Ð¸Ñ Ð½Ð°ÑˆÐµÐ¹ Ñ€Ð°Ð±Ð¾Ñ‚Ñ‹:")
        Sleep 1950
        SendChat("Ð’Ð¾-Ð¿ÐµÑ€Ð²Ñ‹Ñ…: Ð¸Ð½Ñ‚ÐµÑ€Ð²Ð°Ð» Ð¼ÐµÐ¶Ð´Ñƒ Ð¿Ð¾Ð²Ñ‚Ð¾Ñ€Ð½Ñ‹Ð¼Ð¸ Ð·Ð°Ð¿Ñ€Ð¾ÑÐ°Ð¼Ð¸ Ð½Ð° Ð¾Ð´Ð½Ð¾Ð³Ð¾ Ñ‡ÐµÐ»Ð¾Ð²ÐµÐºÐ° ÑÐ¾ÑÑ‚Ð°Ð²Ð»ÑÐµÑ‚ 14 Ñ‡Ð°ÑÐ¾Ð².")
        Sleep 1950
        SendChat("Ð’Ð¾-Ð²Ñ‚Ð¾Ñ€Ñ‹Ñ…: Ð´ÐµÐ½ÐµÐ¶Ð½Ñ‹Ðµ ÑÑ€ÐµÐ´ÑÑ‚Ð²Ð° Ð½Ðµ Ð²Ð¾Ð·Ð²Ñ€Ð°Ñ‰Ð°ÑŽÑ‚ÑÑ, ÐµÑÐ»Ð¸ Ð¿Ð¾ Ð´ÐµÐ»Ð¾ Ð±Ñ‹Ð» Ð¿Ð¾Ð»ÑƒÑ‡ÐµÐ½ Ð¾Ñ‚ÐºÐ°Ð·.")
        Sleep 1950
        SendChat("Ð’-Ñ‚Ñ€ÐµÑ‚ÑŒÐ¸Ñ…: Ð¼Ð°ÐºÑÐ¸Ð¼Ð°Ð»ÑŒÐ½Ñ‹Ð¹ ÑÑ€Ð¾Ðº Ð¾Ñ‚Ð±Ñ‹Ð²Ð°Ð½Ð¸Ñ Ð½Ðµ Ð´Ð¾Ð»Ð¶ÐµÐ½ Ð¿Ñ€ÐµÐ²Ñ‹ÑˆÐ°Ñ‚ÑŒ 2-Ñ… Ñ‡Ð°ÑÐ¾Ð².")
        Sleep 1950
        SendChat("Ð•ÑÐ»Ð¸ ÑƒÑÐ»Ð¾Ð²Ð¸Ñ Ð²Ð°Ð¼ Ð¿Ð¾Ð½ÑÑ‚Ð½Ñ‹ Ð¸ Ð²Ñ‹ Ð¸Ñ… Ð¿Ñ€Ð¸Ð½Ð¸Ð¼Ð°ÐµÑ‚Ðµ, Ð½Ð°Ð·Ð¾Ð²Ð¸Ñ‚Ðµ Ð¸Ð¼Ñ Ð¸ Ñ„Ð°Ð¼Ð¸Ð»Ð¸ÑŽ Ð·Ð°ÐºÐ»ÑŽÑ‡ÐµÐ½Ð½Ð¾Ð³Ð¾")
        Sleep 1950
        SendChat("Ð¸ Ð¿Ñ€Ð¾Ð¸Ð·Ð²ÐµÐ´Ð¸Ñ‚Ðµ Ð¾Ð¿Ð»Ð°Ñ‚Ñƒ Ð² Ñ€Ð°Ð·Ð¼ÐµÑ€Ðµ 50.000$.")
        WaitingForPayment := true
    }
}

ShowLicensesList() {
    addChatMessage("{FF0000}[" Tag "] {33AAFF}ÐŸÐµÑ€ÐµÑ‡ÐµÐ½ÑŒ Ð¸ ÑÑ‚Ð¾Ð¸Ð¼Ð¾ÑÑ‚ÑŒ Ð³Ð¾ÑÑƒÐ´Ð°Ñ€ÑÑ‚Ð²ÐµÐ½Ð½Ñ‹Ñ… Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹")
    Sleep, 150
    SendChat("Ð›Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ Ð½Ð° ÑƒÐ¿Ñ€Ð°Ð²Ð»ÐµÐ½Ð¸Ðµ Ð½Ð°Ð·ÐµÐ¼Ð½Ñ‹Ð¼ Ñ‚Ñ€Ð°Ð½ÑÐ¿Ð¾Ñ€Ñ‚Ð¾Ð¼ â€” 400$")
    Sleep, 1950
    SendChat("Ð›Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ Ð½Ð° Ð¿Ñ€Ð¸Ð¾Ð±Ñ€ÐµÑ‚ÐµÐ½Ð¸Ðµ Ð¸ Ð½Ð¾ÑˆÐµÐ½Ð¸Ðµ Ð¾Ñ€ÑƒÐ¶Ð¸Ñ â€” 125.000$")
    Sleep, 1950
    SendChat("Ð›Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ Ð½Ð° ÑƒÐ¿Ñ€Ð°Ð²Ð»ÐµÐ½Ð¸Ðµ Ð²Ð¾Ð´Ð½Ñ‹Ð¼Ð¸ ÑÑƒÐ´Ð°Ð¼Ð¸ â€” 25.000$")
    Sleep, 1950
    SendChat("Ð Ð°Ð·Ñ€ÐµÑˆÐµÐ½Ð¸Ðµ Ð½Ð° ÑÐºÑÐ¿Ð»ÑƒÐ°Ñ‚Ð°Ñ†Ð¸ÑŽ Ð¸Ð½Ð´Ð¸Ð²Ð¸Ð´ÑƒÐ°Ð»ÑŒÐ½Ñ‹Ñ… Ð»ÐµÑ‚Ð°Ñ‚ÐµÐ»ÑŒÐ½Ñ‹Ñ… Ð°Ð¿Ð¿Ð°Ñ€Ð°Ñ‚Ð¾Ð² â€” 5.000$")
    Sleep, 1950
    SendChat("Ð Ð°Ð·Ñ€ÐµÑˆÐµÐ½Ð¸Ðµ Ð½Ð° Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ðµ Ð²Ñ‹ÑÐ¾Ñ‚Ð½Ñ‹Ñ… Ð¿Ð¾Ð»ÐµÑ‚Ð¾Ð² â€” 15.000$")
    Sleep, 1950
    SendChat("Ð›Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ Ð½Ð° ÑƒÐ¿Ñ€Ð°Ð²Ð»ÐµÐ½Ð¸Ðµ Ð²Ð¾Ð·Ð´ÑƒÑˆÐ½Ñ‹Ð¼ Ñ‚Ñ€Ð°Ð½ÑÐ¿Ð¾Ñ€Ñ‚Ð¾Ð¼ â€” 30.000$")
    Sleep, 1950
    SendChat("Ð›Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ Ð½Ð° Ð²ÐµÐ´ÐµÐ½Ð¸Ðµ Ð¿Ñ€ÐµÐ´Ð¿Ñ€Ð¸Ð½Ð¸Ð¼Ð°Ñ‚ÐµÐ»ÑŒÑÐºÐ¾Ð¹ Ð´ÐµÑÑ‚ÐµÐ»ÑŒÐ½Ð¾ÑÑ‚Ð¸ â€” 250.000$")
}

GetDataFromIngameDialog(ID, FullScan := false) {
    Result := {Name: "", Acc: "", LVL: "", Phone: "", Org: "", Bday: "", House: "", Family: "", Rep: "", Car: ""}
    RawName := getPlayerNameById(ID)
    Result.Name := StrReplace(RawName, "_", " ")
    SendChat("/Ð¸ " ID)
    Loop, 15 {
        if isDialogOpen()
            break
        Sleep, 100
    }
    if !isDialogOpen()
        return Result
    Sleep, 300
    Loop, 15 {
        Send, {Up}
        Sleep, 20
    }
    SendInput, {Enter}
    Sleep, 850
    Loop, 45 {
        Line := getDialogLine(A_Index)
        if (Line == "")
            continue
        CleanLine := RegExReplace(Line, "\{[a-fA-F0-9]{6}\}", "")
        if (RegExMatch(CleanLine, "i)Ð˜Ð¼Ñ:\s*([A-Za-z_]+)", M))
            Result.Name := StrReplace(M1, "_", " ")
        if (RegExMatch(CleanLine, "i)ÐÐ¾Ð¼ÐµÑ€ Ð°ÐºÐºÐ°ÑƒÐ½Ñ‚Ð°:.*?[^\d]*(\d+)", M))
            Result.Acc := M1
        if (RegExMatch(CleanLine, "i)Ð£Ñ€Ð¾Ð²ÐµÐ½ÑŒ:.*?[^\d]*(\d+)", M))
            Result.LVL := M1
        if (RegExMatch(CleanLine, "i)Ð”ÐµÐ½ÑŒ Ñ€Ð¾Ð¶Ð´ÐµÐ½Ð¸Ñ:\s*(\d{1,2})\s(\d{1,2})\s(\d{4})", M))
            Result.Bday := M1 "/" M2 "/" M3
        if (RegExMatch(CleanLine, "i)Ð”Ð¾Ð¼:\s*(\d+)\s*\((.*?)\)", M))
            Result.House := M1 ": " M2
        if (RegExMatch(CleanLine, "i)ÐžÑ€Ð³Ð°Ð½Ð¸Ð·Ð°Ñ†Ð¸Ñ:\s*(.*)", M))
            Result.Org := Trim(M1)
        if (RegExMatch(CleanLine, "i)Ð ÐµÐ¿ÑƒÑ‚Ð°Ñ†Ð¸Ñ:\s*([\+\-]?\d+)", M))
            Result.Rep := M1
        if (RegExMatch(CleanLine, "i)Ð¢Ñ€Ð°Ð½ÑÐ¿Ð¾Ñ€Ñ‚:\s*(.*)", M))
            Result.Car := Trim(M1)
        if (!FullScan && Result.Acc != "")
            break
    }
    Send, {Esc}
    Sleep, 150
    Send, {Esc}
    return Result
}

StartLawyerRP:
    if (PendingAcc = "")
        return
    SendChat("/todo Ð¡ÐµÐ¹Ñ‡Ð°Ñ Ð¿Ð¾ÑÐ¼Ð¾Ñ‚Ñ€Ð¸Ð¼ Ñ‡Ñ‚Ð¾ Ð²Ð¾Ð·Ð¼Ð¾Ð¶Ð½Ð¾ Ñ‚ÑƒÑ‚ Ñ€ÐµÑˆÐ¸Ñ‚ÑŒ*Ð²ÐºÐ»ÑŽÑ‡Ð°Ñ ÐºÐ¾Ð¼Ð¿ÑŒÑŽÑ‚ÐµÑ€")
    Sleep 2099
    SendChat("/do ÐšÐ¾Ð¼Ð¿ÑŒÑŽÑ‚ÐµÑ€ Ð²ÐºÐ»ÑŽÑ‡Ñ‘Ð½")
    Sleep 2099
    if (Gender == 1)
        SendChat("/me Ð·Ð°Ð¿ÑƒÑÑ‚Ð¸Ð» Ð±Ð°Ð·Ñƒ Ð´Ð°Ð½Ð½Ñ‹Ñ… ÐœÐ’Ð” Ð¸ Ð²Ð²Ñ‘Ð» ÐºÐ¾Ð´ Ð³Ð¾ÑÑƒÐ´Ð°Ñ€ÑÑ‚Ð²ÐµÐ½Ð½Ð¾Ð³Ð¾ Ð°Ð´Ð²Ð¾ÐºÐ°Ñ‚Ð°")
    else
        SendChat("/me Ð·Ð°Ð¿ÑƒÑÑ‚Ð¸Ð»Ð° Ð±Ð°Ð·Ñƒ Ð´Ð°Ð½Ð½Ñ‹Ñ… ÐœÐ’Ð” Ð¸ Ð²Ð²ÐµÐ»Ð° ÐºÐ¾Ð´ Ð³Ð¾ÑÑƒÐ´Ð°Ñ€ÑÑ‚Ð²ÐµÐ½Ð½Ð¾Ð³Ð¾ Ð°Ð´Ð²Ð¾ÐºÐ°Ñ‚Ð°")
    Sleep 2099
    if (Gender == 1)
        SendChat("/me Ð½Ð°ÑˆÑ‘Ð» Ð»Ð¸Ñ‡Ð½Ð¾Ðµ Ð´ÐµÐ»Ð¾ ÐºÐ»Ð¸ÐµÐ½Ñ‚Ð° Ð² Ð±Ð°Ð·Ðµ Ð´Ð°Ð½Ð½Ñ‹Ñ…")
    else
        SendChat("/me Ð½Ð°ÑˆÐ»Ð° Ð»Ð¸Ñ‡Ð½Ð¾Ðµ Ð´ÐµÐ»Ð¾ ÐºÐ»Ð¸ÐµÐ½Ñ‚Ð° Ð² Ð±Ð°Ð·Ðµ Ð´Ð°Ð½Ð½Ñ‹Ñ…")
    Sleep 2099
    if (Gender == 1)
        SendChat("/me Ð¾Ñ‚ÐºÑ€Ñ‹Ð» Ð´ÐµÐ»Ð¾ â„–" PendingAcc " Ð¸ Ð¸Ð·ÑƒÑ‡Ð¸Ð» Ð¼Ð°Ñ‚ÐµÑ€Ð¸Ð°Ð»Ñ‹")
    else
        SendChat("/me Ð¾Ñ‚ÐºÑ€Ñ‹Ð»Ð° Ð´ÐµÐ»Ð¾ â„–" PendingAcc " Ð¸ Ð¸Ð·ÑƒÑ‡Ð¸Ð»Ð° Ð¼Ð°Ñ‚ÐµÑ€Ð¸Ð°Ð»Ñ‹")
    Sleep 1000
    SendChat("/ÑÐ¼Ñ 5055 ÐŸÐµÑ€ÐµÐ´Ð°ÑŽ Ð½Ð° Ñ€Ð°ÑÑÐ¼Ð¾Ñ‚Ñ€ÐµÐ½Ð¸Ðµ Ð´ÐµÐ»Ð¾ â„–" PendingAcc "/" PendingCaseID)
    SmsSent := true
    SetTimer, LawyerSmsTimeout, -10000
return

LawyerSmsTimeout:
    if (SmsSent) {
        addChatMessage("{FF0000}[" Tag "] {FFFFFF}Ð—Ð°Ð¿Ñ€Ð¾Ñ Ð¾Ñ‚Ð¿Ñ€Ð°Ð²Ð»ÐµÐ½. {00FF00}1 - ÐžÐº {FFFFFF}| {FF0000}0 - ÐžÑ‚Ð¼ÐµÐ½Ð°")
    }
return

StartLicenseRP:
    if (Gender == 1)
        SendChat("/me Ð´Ð¾ÑÑ‚Ð°Ð» Ð¸Ð· ÐºÐ°Ñ€Ð¼Ð°Ð½Ð° ÑÐ»ÑƒÐ¶ÐµÐ±Ð½Ñ‹Ð¹ Ð¿Ð»Ð°Ð½ÑˆÐµÑ‚, Ñ€Ð°Ð·Ð±Ð»Ð¾ÐºÐ¸Ñ€Ð¾Ð²Ð°Ð² ÐµÐ³Ð¾ Ð¾Ñ‚Ð¿ÐµÑ‡Ð°Ñ‚ÐºÐ¾Ð¼ Ð¿Ð°Ð»ÑŒÑ†Ð°.")
    else
        SendChat("/me Ð´Ð¾ÑÑ‚Ð°Ð»Ð° Ð¸Ð· ÐºÐ°Ñ€Ð¼Ð°Ð½Ð° ÑÐ»ÑƒÐ¶ÐµÐ±Ð½Ñ‹Ð¹ Ð¿Ð»Ð°Ð½ÑˆÐµÑ‚, Ñ€Ð°Ð·Ð±Ð»Ð¾ÐºÐ¸Ñ€Ð¾Ð²Ð°Ð² ÐµÐ³Ð¾ Ð¾Ñ‚Ð¿ÐµÑ‡Ð°Ñ‚ÐºÐ¾Ð¼ Ð¿Ð°Ð»ÑŒÑ†Ð°.")
    Sleep 2070
    if (Gender == 1)
        SendChat("/me Ð·Ð°ÑˆÑ‘Ð» Ð² ÑÐ»ÐµÐºÑ‚Ñ€Ð¾Ð½Ð½ÑƒÑŽ Ð±Ð°Ð·Ñƒ Ð´Ð°Ð½Ð½Ñ‹Ñ… Ð¶Ð¸Ñ‚ÐµÐ»ÐµÐ¹ ÑˆÑ‚Ð°Ñ‚Ð° Ð¸ Ð½Ð°ÑˆÑ‘Ð» Ð´Ð°Ð½Ð½Ñ‹Ðµ Ð¾ ÐºÐ»Ð¸ÐµÐ½Ñ‚Ðµ")
    else
        SendChat("/me Ð·Ð°ÑˆÐ»Ð° Ð² ÑÐ»ÐµÐºÑ‚Ñ€Ð¾Ð½Ð½ÑƒÑŽ Ð±Ð°Ð·Ñƒ Ð´Ð°Ð½Ð½Ñ‹Ñ… Ð¶Ð¸Ñ‚ÐµÐ»ÐµÐ¹ ÑˆÑ‚Ð°Ñ‚Ð° Ð¸ Ð½Ð°ÑˆÐ»Ð° Ð´Ð°Ð½Ð½Ñ‹Ðµ Ð¾ ÐºÐ»Ð¸ÐµÐ½Ñ‚Ðµ")
    Sleep 2070
    if (Gender == 1)
        SendChat("/me Ð¾Ñ‚ÐºÑ€Ñ‹Ð» Ð² Ð½Ð¾Ð²Ð¾Ð¹ Ð²ÐºÐ»Ð°Ð´ÐºÐµ Ð±Ð°Ð·Ñƒ Ð´Ð°Ð½Ð½Ñ‹Ñ… Ð”ÐµÐ¿Ð°Ñ€Ñ‚Ð°Ð¼ÐµÐ½Ñ‚Ð° Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ€Ð¾Ð²Ð°Ð½Ð¸Ñ")
    else
        SendChat("/me Ð¾Ñ‚ÐºÑ€Ñ‹Ð»Ð° Ð² Ð½Ð¾Ð²Ð¾Ð¹ Ð²ÐºÐ»Ð°Ð´ÐºÐµ Ð±Ð°Ð·Ñƒ Ð´Ð°Ð½Ð½Ñ‹Ñ… Ð”ÐµÐ¿Ð°Ñ€Ñ‚Ð°Ð¼ÐµÐ½Ñ‚Ð° Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ€Ð¾Ð²Ð°Ð½Ð¸Ñ")
    Sleep 2070
    if (Gender == 1)
        SendChat("/me Ð²Ñ‹Ð±Ñ€Ð°Ð» Ð½ÑƒÐ¶Ð½Ñ‹Ðµ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¸ Ð¸ ÑÐºÐ¾Ð¿Ð¸Ñ€Ð¾Ð²Ð°Ð» Ð´Ð°Ð½Ð½Ñ‹Ðµ ÐºÐ»Ð¸ÐµÐ½Ñ‚Ð° Ð¸Ð· Ð¾Ð±Ñ‰ÐµÐ¹ Ð±Ð°Ð·Ñ‹ Ð² Ð±Ð°Ð·Ñƒ Ð”Ð›")
    else
        SendChat("/me Ð²Ñ‹Ð±Ñ€Ð°Ð»Ð° Ð½ÑƒÐ¶Ð½Ñ‹Ðµ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¸ Ð¸ ÑÐºÐ¾Ð¿Ð¸Ñ€Ð¾Ð²Ð°Ð»Ð° Ð´Ð°Ð½Ð½Ñ‹Ðµ ÐºÐ»Ð¸ÐµÐ½Ñ‚Ð° Ð¸Ð· Ð¾Ð±Ñ‰ÐµÐ¹ Ð±Ð°Ð·Ñ‹ Ð² Ð±Ð°Ð·Ñƒ Ð”Ð›")
    Sleep 2070
    if (Gender == 1)
        SendChat("/me ÑÑ„Ð¾Ñ€Ð¼Ð¸Ñ€Ð¾Ð²Ð°Ð» ÑÐ»ÐµÐºÑ‚Ñ€Ð¾Ð½Ð½Ñ‹Ð¹ Ð±Ð»Ð°Ð½Ðº Ð¾Ð¿Ð»Ð°Ñ‚Ñ‹, Ð²Ð½ÐµÑÑ ÑÑƒÐ¼Ð¼Ñƒ Ð¾Ð¿Ð»Ð°Ñ‚Ñ‹ Ð¸ Ð´Ð°Ñ‚Ñƒ Ð²Ñ‹Ð´Ð°Ñ‡Ð¸ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹")
    else
        SendChat("/me ÑÑ„Ð¾Ñ€Ð¼Ð¸Ñ€Ð¾Ð²Ð°Ð»Ð° ÑÐ»ÐµÐºÑ‚Ñ€Ð¾Ð½Ð½Ñ‹Ð¹ Ð±Ð»Ð°Ð½Ðº Ð¾Ð¿Ð»Ð°Ñ‚Ñ‹, Ð²Ð½ÐµÑÑ ÑÑƒÐ¼Ð¼Ñƒ Ð¾Ð¿Ð»Ð°Ñ‚Ñ‹ Ð¸ Ð´Ð°Ñ‚Ñƒ Ð²Ñ‹Ð´Ð°Ñ‡Ð¸ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹")
    Sleep 2070
    SendChat("/todo ÐÑƒÐ¶Ð½Ð° Ð¸Ð´ÐµÐ½Ñ‚Ð¸Ñ„Ð¸ÐºÐ°Ñ†Ð¸Ñ Ð»Ð¸Ñ‡Ð½Ð¾ÑÑ‚Ð¸ Ñ‡ÐµÑ€ÐµÐ· Face ID*Ð½Ð°Ð²Ð¾Ð´Ñ Ð¾Ð±ÑŠÐµÐºÑ‚Ð¸Ð² Ð½Ð° ÐºÐ»Ð¸ÐµÐ½Ñ‚Ð°")
    Sleep 2070
    SendChat("/todo ÐŸÐ¾ÑÐ¼Ð¾Ñ‚Ñ€Ð¸Ñ‚Ðµ, Ð¿Ð¾Ð¶Ð°Ð»ÑƒÐ¹ÑÑ‚Ð°, Ð¿Ñ€ÑÐ¼Ð¾ Ð² ÐºÐ°Ð¼ÐµÑ€Ñƒ*ÑÐ´ÐµÐ»Ð°Ð² ÑÐ½Ð¸Ð¼Ð¾Ðº Ð»Ð¸Ñ†Ð° ÐºÐ»Ð¸ÐµÐ½Ñ‚Ð°")
    Sleep 2070
    SendChat("/todo ÐŸÐ¾ÑÑ‚Ð°Ð²ÑŒÑ‚Ðµ ÑÐ»ÐµÐºÑ‚Ñ€Ð¾Ð½Ð½ÑƒÑŽ Ð¿Ð¾Ð´Ð¿Ð¸ÑÑŒ*Ð¿ÐµÑ€ÐµÐ´Ð°Ð²Ð°Ñ Ð¿Ð»Ð°Ð½ÑˆÐµÑ‚ Ñ‡ÐµÐ»Ð¾Ð²ÐµÐºÑƒ Ð½Ð°Ð¿Ñ€Ð¾Ñ‚Ð¸Ð²")
    Sleep 2080
    SendChat("*/me Ð²Ð·ÑÐ» Ð¿Ð»Ð°Ð½ÑˆÐµÑ‚ Ð¸ Ð¿Ð¾ÑÑ‚Ð°Ð²Ð¸Ð» ÑÐ»ÐµÐºÑ‚Ñ€Ð¾Ð½Ð½ÑƒÑŽ Ð¿Ð¾Ð´Ð¿Ð¸ÑÑŒ")
    Sleep 500
    SendChat("/time")
    Sleep 50
    addChatMessage("{FF0000}[" Tag "] {00FF00} ÐŸÐ¾ÑÐ»Ðµ Ð¿Ð¾Ð»ÑƒÑ‡ÐµÐ½Ð¸Ñ Ð¿Ð¾Ð´Ð¿Ð¸ÑÐ¸: {FFFF00}Backspace{00FF00} - Ð´Ð°Ð»ÐµÐµ, {FF4500}Delete{00FF00} - Ð¾Ñ‚Ð¼ÐµÐ½Ð°.")
    LicenseProcess := 2
return

; ====================================================================================================
; Ð˜Ð¡Ð¢ÐžÐ Ð˜Ð¯ ÐŸÐ Ð˜Ð—ÐžÐ’
; ====================================================================================================
LoadPrizeHistory() {
    global PrizeHistory, BindIni
    PrizeHistory := []
    IniRead, Count, %BindIni%, PrizeHistory, Count, 0
    if Count is not number
        Count := 0
    Loop, %Count% {
        IniRead, prizeTime, %BindIni%, PrizeHistory%A_Index%, Time,
        IniRead, prizeText, %BindIni%, PrizeHistory%A_Index%, Text,
        if (prizeTime != "" && prizeText != "")
            PrizeHistory.Push({"time": prizeTime, "text": prizeText})
    }
    while PrizeHistory.Length() > 10
        PrizeHistory.RemoveAt(1)
}
SavePrizeHistory() {
    global PrizeHistory, BindIni
    IniDelete, %BindIni%, PrizeHistory
    IniWrite, % PrizeHistory.Length(), %BindIni%, PrizeHistory, Count
    For index, prize in PrizeHistory {
        IniWrite, % prize.time, %BindIni%, PrizeHistory%index%, Time
        IniWrite, % prize.text, %BindIni%, PrizeHistory%index%, Text
    }
}
AddPrizeToHistory(prizeText) {
    global PrizeHistory
    FormatTime, timestamp,, HH:MM:SS
    PrizeHistory.Push({"time": timestamp, "text": prizeText})
    if (PrizeHistory.Length() > 10)
        PrizeHistory.RemoveAt(1)
    SavePrizeHistory()
    if (HistoryGuiHwnd && WinExist("ahk_id " HistoryGuiHwnd))
        RefreshHistoryListFunc()   ; Ð¸ÑÐ¿Ñ€Ð°Ð²Ð»ÐµÐ½Ð¾: Ð²Ñ‹Ð·Ð¾Ð² Ñ„ÑƒÐ½ÐºÑ†Ð¸Ð¸ Ð²Ð¼ÐµÑÑ‚Ð¾ Gosub
}
RefreshHistoryListFunc() {         ; Ð½Ð¾Ð²Ð°Ñ Ñ„ÑƒÐ½ÐºÑ†Ð¸Ñ Ð´Ð»Ñ Ð¾Ð±Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ñ ÑÐ¿Ð¸ÑÐºÐ°
    global PrizeHistory
    Gui, HistoryGui:Default
    LV_Delete()
    For index, prize in PrizeHistory
        LV_Add("", prize.time, prize.text)
}

; ====================================================================================================
; ÐÐ’Ð¢ÐžÐ¢ÐÐ™Ðœ
; ====================================================================================================
StartAutoTime() {
    global AutoTimeTimerHandle, AutoTimeActive
    if (AutoTimeTimerHandle) {
        SetTimer, SendAutoTime, Off
        AutoTimeTimerHandle := 0
    }
    if (AutoTimeActive) {
        SetTimer, SendAutoTime, 45000
        AutoTimeTimerHandle := 1
    }
}
SendAutoTime:
    if (AutoTimeActive)
        SendChat("/time")
return
StopAutoTime() {
    global AutoTimeTimerHandle
    if (AutoTimeTimerHandle) {
        SetTimer, SendAutoTime, Off
        AutoTimeTimerHandle := 0
    }
}

; ====================================================================================================
; ÐÐ’Ð¢ÐžÐ Ð£Ð›Ð•Ð¢ÐšÐ
; ====================================================================================================
StartRouletteSequence() {
    global RouletteAwaitingPrize, GameWasMinimized, RouletteProcessing
    if (RouletteAwaitingPrize)
        return
    WinGet, winState, MinMax, ahk_exe gta_sa.exe
    if (winState = -1) {
        GameWasMinimized := 1
        WinActivate, ahk_exe gta_sa.exe
        Sleep, 1500
    } else {
        GameWasMinimized := 0
    }
    SendChat("/Ñ€ÑƒÐ»ÐµÑ‚ÐºÐ°")
    Sleep, 500
    SendInput, {Enter}
    if (GameWasMinimized)
        WinMinimize, ahk_exe gta_sa.exe
    RouletteAwaitingPrize := 1
    SetTimer, ResetRouletteState, -60000
}
ResetRouletteState:
    global RouletteAwaitingPrize, RouletteProcessing
    RouletteAwaitingPrize := 0
    RouletteProcessing := 0
return

; ====================================================================================================
; ÐŸÐÐ Ð¡Ð˜ÐÐ“ Ð¡ÐœÐ¡
; ====================================================================================================
ParseSmsMessage(line) {
    if !RegExMatch(line, "i)Ð¡ÐœÐ¡\s+Ð¾Ñ‚\s+(.+?)\s*\[(\d+)\]:\s*(.*)$", match)
        return ["", "", ""]
    return [Trim(match1), Trim(match2), Trim(match3)]
}

; ====================================================================================================
; Ð¤Ð£ÐÐšÐ¦Ð˜Ð¯ Ð£Ð’Ð•Ð”ÐžÐœÐ›Ð•ÐÐ˜Ð¯ (Ð¸ÑÐ¿Ñ€Ð°Ð²Ð»ÐµÐ½Ð°: Ð½Ðµ Ð¿Ð¾ÐºÐ°Ð·Ñ‹Ð²Ð°Ñ‚ÑŒ Ð¿Ñ€Ð¸ Ð°ÐºÑ‚Ð¸Ð²Ð½Ð¾Ð¹ Ð¸Ð³Ñ€Ðµ)
; ====================================================================================================
ShowClickableNotification(senderName, senderNumber, msgText) {
    if WinActive("ahk_exe gta_sa.exe")
        return
    global NotificationGuiHwnd, CurrentNotificationNumber, CurrentNotificationName, CurrentNotificationText
    if (NotificationGuiHwnd && WinExist("ahk_id " NotificationGuiHwnd))
        Gui, Notification:Destroy
    CurrentNotificationNumber := senderNumber
    CurrentNotificationName := senderName
    CurrentNotificationText := msgText
    Gui, Notification:New, +AlwaysOnTop +ToolWindow -Caption +LastFound
    NotificationGuiHwnd := WinExist()
    Gui, Notification:Color, 2D2D2D
    Gui, Notification:Font, s10 Bold, Segoe UI
    Gui, Notification:Add, Text, x10 y5 cFFD700, âœ‰ ÐÐ¾Ð²Ð¾Ðµ Ð¡ÐœÐ¡ Ð¾Ñ‚ %senderName%
    Gui, Notification:Font, s9 cWhite, Segoe UI
    Gui, Notification:Add, Text, x10 y30, %msgText%
    Gui, Notification:Add, Button, gOpenReplyFromNotification x10 y55 w80 h25, ðŸ’¬ ÐžÑ‚Ð²ÐµÑ‚Ð¸Ñ‚ÑŒ
    Gui, Notification:Add, Button, gCloseNotification x95 y55 w80 h25, âŒ Ð—Ð°ÐºÑ€Ñ‹Ñ‚ÑŒ
    SysGet, workArea, MonitorWorkArea
    winWidth := 200
    winHeight := 100
    posX := workAreaRight - winWidth - 10
    posY := workAreaBottom - winHeight - 10
    Gui, Notification:Show, x%posX% y%posY% w%winWidth% h%winHeight% NoActivate
    WinSet, Transparent, 240, ahk_id %NotificationGuiHwnd%
    SetTimer, AutoCloseNotification, -10000
}

; ====================================================================================================
; ÐœÐžÐÐ˜Ð¢ÐžÐ Ð˜ÐÐ“ Ð§ÐÐ¢Ð (Ð¸ÑÐ¿Ñ€Ð°Ð²Ð»ÐµÐ½: Ñ„Ð¸Ð»ÑŒÑ‚Ñ€ Admin 5055 + ÑƒÐ´Ð°Ð»ÐµÐ½Ð¾ Ð´ÑƒÐ±Ð»Ð¸Ñ€Ð¾Ð²Ð°Ð½Ð¸Ðµ Ñ„ÑƒÐ½ÐºÑ†Ð¸Ð¸)
; ====================================================================================================
MonitorChat:
    if (!IsFunc("GetChatLine")) {
        global _warnedChat
        if (!_warnedChat) {
            _warnedChat := 1
            addChatMessage("{FF0000}[ÐœÐ­Ð Ð˜Ð¯] Ð¤ÑƒÐ½ÐºÑ†Ð¸Ñ GetChatLine Ð½Ðµ Ð½Ð°Ð¹Ð´ÐµÐ½Ð°.")
        }
        return
    }
    GetChatLine(0, msg)
    if (msg == "")
        return
    cleanMsg := RegExReplace(msg, "\{[a-fA-F0-9]{6}\}", "")
    cleanMsg := Trim(cleanMsg)

    ; Ð Ð£Ð›Ð•Ð¢ÐšÐ
    global RouletteProcessing, AutoRouletteActive, RouletteAwaitingPrize
    if (AutoRouletteActive && InStr(cleanMsg, "Ð ÑƒÐ»ÐµÑ‚ÐºÐ° Ð³Ð¾Ñ‚Ð¾Ð²Ð°") && !RouletteProcessing) {
        RouletteProcessing := 1
        SetTimer, StartRouletteSequence, -10
    }
    if (RouletteAwaitingPrize && InStr(cleanMsg, "ÐŸÑ€Ð¸Ð·:")) {
        prizeStart := InStr(cleanMsg, "ÐŸÑ€Ð¸Ð·:") + 5
        prizeText := Trim(SubStr(cleanMsg, prizeStart))
        if (prizeText != "") {
            AddPrizeToHistory(prizeText)
            SoundPlay, *-1
        }
        RouletteAwaitingPrize := 0
        RouletteProcessing := 0
    }

    ; ÐžÐ‘Ð ÐÐ‘ÐžÐ¢ÐšÐ Ð¡ÐœÐ¡ (Ñ Ñ„Ð¸Ð»ÑŒÑ‚Ñ€Ð¾Ð¼ Admin 5055)
    if InStr(cleanMsg, "Ð¡ÐœÐ¡") {
        global LastSmsTime, LastSmsMessage
        if (cleanMsg = LastSmsMessage)
            return
        if (A_TickCount - LastSmsTime < 3000)
            return
        result := ParseSmsMessage(cleanMsg)
        sender := result[1]
        number := result[2]
        text := result[3]

        ; Ð˜Ð³Ð½Ð¾Ñ€Ð¸Ñ€ÑƒÐµÐ¼ ÑƒÐ²ÐµÐ´Ð¾Ð¼Ð»ÐµÐ½Ð¸Ñ Ð¸ Ð¸ÑÑ‚Ð¾Ñ€Ð¸ÑŽ Ð´Ð»Ñ Ð¡ÐœÐ¡ Ð¾Ñ‚ Admin 5055
        isAdmin5055 := (number = "5055" && InStr(sender, "Admin"))
        if (!isAdmin5055 && sender != "" && text != "") {
            LastSmsTime := A_TickCount
            LastSmsMessage := cleanMsg
            AddSmsRecord("in", number, sender, text)
            ShowClickableNotification(sender, number, text)
        }
        ; Ð•ÑÐ»Ð¸ ÑÑ‚Ð¾ ÑÐ¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ðµ Ð¾Ñ‚ 5055, Ð¾Ð½Ð¾ Ð½Ðµ ÑÐ¾Ñ…Ñ€Ð°Ð½ÑÐµÑ‚ÑÑ Ð¸ Ð½Ðµ Ð¿Ð¾ÐºÐ°Ð·Ñ‹Ð²Ð°ÐµÑ‚ ÑƒÐ²ÐµÐ´Ð¾Ð¼Ð»ÐµÐ½Ð¸Ðµ,
        ; Ð½Ð¾ Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ðµ ÑÐºÑ€Ð¸Ð¿Ñ‚Ð° Ð¿Ñ€Ð¾Ð´Ð¾Ð»Ð¶Ð°ÐµÑ‚ÑÑ â€“ Ð½Ð¸Ð¶ÐµÑÑ‚Ð¾ÑÑ‰Ð¸Ðµ Ð¿Ñ€Ð¾Ð²ÐµÑ€ÐºÐ¸ (Ð½Ð°Ð¿Ñ€Ð¸Ð¼ÐµÑ€, Ð¾Ñ‚Ð²ÐµÑ‚ Ð°Ð´Ð¼Ð¸Ð½Ð° Ð´Ð»Ñ Ð°Ð´Ð²Ð¾ÐºÐ°Ñ‚Ð°) ÑÑ€Ð°Ð±Ð¾Ñ‚Ð°ÑŽÑ‚.
    }

; ÐŸÑ€Ð¾Ð²ÐµÑ€ÐºÐ° Ð¿Ñ€ÐµÐ´ÑŠÑÐ²Ð»ÐµÐ½Ð¸Ñ Ð¿Ð°ÑÐ¿Ð¾Ñ€Ñ‚Ð° (Ð´Ð»Ñ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹) - Ñ Ð¿Ð¾Ð¸ÑÐºÐ¾Ð¼ Ð¿Ð¾ Ð¿Ð¾ÑÐ»ÐµÐ´Ð½Ð¸Ð¼ 4 ÑÑ‚Ñ€Ð¾ÐºÐ°Ð¼
if (LicenseProcess == 1) {
    nameWithSpaces := TargetName
    nameWithUnderscores := StrReplace(TargetName, " ", "_")
    found := false
    ; ÐŸÑ€Ð¾Ð²ÐµÑ€ÑÐµÐ¼ ÑÑ‚Ñ€Ð¾ÐºÐ¸: Ñ‚ÐµÐºÑƒÑ‰ÑƒÑŽ, -1, -2, -3
    Loop, 4 {
        idx := A_Index - 1   ; 0, -1, -2, -3
        if (idx = 0)
            checkMsg := cleanMsg
        else
            GetChatLine(idx, checkMsg)
        if (checkMsg = "")
            continue
        if (RegExMatch(checkMsg, "i)" nameWithSpaces " Ð¿Ð¾ÐºÐ°Ð·Ð°Ð»[Ð°]? Ð¿Ð°ÑÐ¿Ð¾Ñ€Ñ‚")
            || RegExMatch(checkMsg, "i)" nameWithUnderscores " Ð¿Ð¾ÐºÐ°Ð·Ð°Ð»[Ð°]? Ð¿Ð°ÑÐ¿Ð¾Ñ€Ñ‚")) {
            found := true
            break
        }
    }
    if (found) {
        LicenseProcess := 0
        SetTimer, StartLicenseRP, -500
        addChatMessage("{00FF00}[" Tag "]{00FF00} ÐŸÐ°ÑÐ¿Ð¾Ñ€Ñ‚ Ð¿Ð¾Ð»ÑƒÑ‡ÐµÐ½, Ð·Ð°Ð¿ÑƒÑÐºÐ°ÑŽ Ð¾Ñ„Ð¾Ñ€Ð¼Ð»ÐµÐ½Ð¸Ðµ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹.")
    }
}

    ; ÐŸÑ€Ð¾Ð²ÐµÑ€ÐºÐ° Ð¿Ð¾Ð´Ð¿Ð¸ÑÐ¸ (Ð´Ð»Ñ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹)
    if (LicenseProcess == 2) {
        if (RegExMatch(cleanMsg, "i)" TargetName ".*? Ð²Ð·ÑÐ»[Ð°]? Ð¿Ð»Ð°Ð½ÑˆÐµÑ‚ Ð¸ Ð¿Ð¾ÑÑ‚Ð°Ð²Ð¸Ð»[Ð°]? ÑÐ»ÐµÐºÑ‚Ñ€Ð¾Ð½Ð½ÑƒÑŽ Ð¿Ð¾Ð´Ð¿Ð¸ÑÑŒ")) {
            addChatMessage("{FF0000}[" Tag "] {00FF00}ÐŸÐ¾Ð´Ð¿Ð¸ÑÑŒ Ð¿Ð¾Ð»ÑƒÑ‡ÐµÐ½Ð°! {FFFFFF}ÐÐ°Ð¶Ð¼Ð¸Ñ‚Ðµ {FFFF00}Backspace{FFFFFF} Ð´Ð»Ñ Ð¿Ñ€Ð¾Ð´Ð¾Ð»Ð¶ÐµÐ½Ð¸Ñ.")
        }
    }

; ÐŸÑ€Ð¾Ð²ÐµÑ€ÐºÐ° Ð¾Ð¿Ð»Ð°Ñ‚Ñ‹ Ð´Ð»Ñ Ð°Ð´Ð²Ð¾ÐºÐ°Ñ‚Ð° (Ð»ÑŽÐ±Ð°Ñ ÑÑƒÐ¼Ð¼Ð°)
if (WaitingForPayment) {
    if (RegExMatch(cleanMsg, "i)Ð¢ÐµÐ±Ðµ Ð¿ÐµÑ€ÐµÐ´Ð°Ð½Ð¾ \$([\d\s]+) Ð¾Ñ‚ (.*)", Match)) {
        sumRaw := Match1
        sumClean := RegExReplace(sumRaw, "\s", "")   ; ÑƒÐ±Ð¸Ñ€Ð°ÐµÐ¼ Ð¿Ñ€Ð¾Ð±ÐµÐ»Ñ‹ (50 000 -> 50000)
        Payer := StrReplace(Match2, "_", " ")
        SendChat("Ð¥Ð¾Ñ€Ð¾ÑˆÐ¾ " Payer ", Ð¾Ð¿Ð»Ð°Ñ‚Ñƒ Ð² Ñ€Ð°Ð·Ð¼ÐµÑ€Ðµ " sumRaw "$ Ð²Ð¸Ð¶Ñƒ. ÐÐ°Ñ‡Ð¸Ð½Ð°ÑŽ Ñ€Ð°ÑÑÐ¼Ð¾Ñ‚Ñ€ÐµÐ½Ð¸Ðµ Ð´ÐµÐ»Ð°.")
        WaitingForPayment := false
    }
}

    ; ÐŸÑ€Ð¾Ð²ÐµÑ€ÐºÐ° Ð¾Ñ‚Ð²ÐµÑ‚Ð° Ð¾Ñ‚ Ð°Ð´Ð¼Ð¸Ð½Ð° (5055)
    if (SmsSent) {
        if (RegExMatch(cleanMsg, "i)Ð¡ÐœÐ¡ Ð¾Ñ‚ Admin \[5055\].*?" PendingAcc "/" PendingCaseID ".*?Ð¾Ñ‚ÐºÐ°Ð·")) {
            SmsSent := false
            LawyerResult := 2
            Sleep 1500
            if (Gender == 1)
    SendChat("/me Ð·Ð°ÐºÑ€Ñ‹Ð» Ð´ÐµÐ»Ð¾ Ð¸ Ð²Ñ‹ÐºÐ»ÑŽÑ‡Ð¸Ð» ÐºÐ¾Ð¼Ð¿ÑŒÑŽÑ‚ÐµÑ€")
else
    SendChat("/me Ð·Ð°ÐºÑ€Ñ‹Ð»Ð° Ð´ÐµÐ»Ð¾ Ð¸ Ð²Ñ‹ÐºÐ»ÑŽÑ‡Ð¸Ð»Ð° ÐºÐ¾Ð¼Ð¿ÑŒÑŽÑ‚ÐµÑ€")
 Sleep 50
            SendChat("/time")
            addChatMessage("{FF0000}[" Tag "] {FFFFFF}ÐÐ°Ð¶Ð¼Ð¸Ñ‚Ðµ {FF0000}Backspace{FFFFFF} Ñ‡Ñ‚Ð¾Ð±Ñ‹ ÑÐ¾Ð¾Ð±Ñ‰Ð¸Ñ‚ÑŒ Ð¸Ñ‚Ð¾Ð³ Ð´ÐµÐ»Ð° â„–{FF0000}" PendingAcc " {FFFFFF}Ð¸Ð»Ð¸ {FF0000}Delete {FFFFFF}Ð´Ð»Ñ Ð¾Ñ‚Ð¼ÐµÐ½Ñ‹")
        }
        else if (RegExMatch(cleanMsg, "i)Ð¡ÐœÐ¡ Ð¾Ñ‚ Admin \[5055\].*?" PendingAcc "/" PendingCaseID ".*?Ð¾Ð¿Ñ€Ð°Ð²Ð´Ð°Ð½")) {
            SmsSent := false
            LawyerResult := 1
            Sleep 1500
                       if (Gender == 1)
    SendChat("/me Ð·Ð°ÐºÑ€Ñ‹Ð» Ð´ÐµÐ»Ð¾ Ð¸ Ð²Ñ‹ÐºÐ»ÑŽÑ‡Ð¸Ð» ÐºÐ¾Ð¼Ð¿ÑŒÑŽÑ‚ÐµÑ€")
else
    SendChat("/me Ð·Ð°ÐºÑ€Ñ‹Ð»Ð° Ð´ÐµÐ»Ð¾ Ð¸ Ð²Ñ‹ÐºÐ»ÑŽÑ‡Ð¸Ð»Ð° ÐºÐ¾Ð¼Ð¿ÑŒÑŽÑ‚ÐµÑ€")
            Sleep 50
            SendChat("/time")
            addChatMessage("{FF0000}[" Tag "] {FFFFFF}ÐÐ°Ð¶Ð¼Ð¸Ñ‚Ðµ {FF0000}Backspace{FFFFFF} Ñ‡Ñ‚Ð¾Ð±Ñ‹ ÑÐ¾Ð¾Ð±Ñ‰Ð¸Ñ‚ÑŒ Ð¸Ñ‚Ð¾Ð³ Ð´ÐµÐ»Ð° â„–{FF0000}" PendingAcc " {FFFFFF}Ð¸Ð»Ð¸ {FF0000}Delete {FFFFFF}Ð´Ð»Ñ Ð¾Ñ‚Ð¼ÐµÐ½Ñ‹")
        }
    }
return

; ====================================================================================================
; ÐÐ’Ð¢ÐžÐŸÐ ÐžÐ¤Ð˜Ð›Ð¬
; ====================================================================================================
CheckAutoProfile:
    if (AutoProfileActive = 0)
        return
    if (AutoProfileStep = 1) {
        if isDialogOpen() {
            AutoProfileStep := 2
            AutoProfilePressCount := 0
            AutoProfileLastTime := A_TickCount
        }
    }
    else if (AutoProfileStep = 2) {
        if (A_TickCount - AutoProfileLastTime >= 500) {
            IfWinNotActive, ahk_exe gta_sa.exe
                WinActivate, ahk_exe gta_sa.exe
            AutoProfileStep := 3
            AutoProfilePressCount := 0
            AutoProfileLastTime := A_TickCount
        }
    }
    else if (AutoProfileStep = 3) {
        if (AutoProfilePressCount < 15) {
            if (A_TickCount - AutoProfileLastTime >= 25) {
                SendInput, {Up}
                AutoProfilePressCount++
                AutoProfileLastTime := A_TickCount
            }
        } else {
            AutoProfileStep := 4
            AutoProfileLastTime := A_TickCount
        }
    }
    else if (AutoProfileStep = 4) {
        if (A_TickCount - AutoProfileLastTime >= 15) {
            SendInput, {Enter}
            AutoProfileStep := 5
            AutoProfileLastTime := A_TickCount
        }
    }
    else if (AutoProfileStep = 5) {
        if (A_TickCount - AutoProfileLastTime >= 400) {
            AutoProfileName := ""
            AutoProfileAccNumber := ""
            Loop, 45 {
                line := getDialogLine(A_Index)
                if (line == "")
                    continue
                CleanLine := RegExReplace(line, "\{[a-fA-F0-9]{6}\}", "")
                if (RegExMatch(CleanLine, "i)Ð¤Ð°Ð¼Ð¸Ð»Ð¸Ñ:[^\s]*\s+([A-Za-z_\s]+)", M))
                    AutoProfileName := StrReplace(Trim(M1), "_", " ")
                if (RegExMatch(CleanLine, "i)ÐÐ¾Ð¼ÐµÑ€ Ð°ÐºÐºÐ°ÑƒÐ½Ñ‚Ð°:.*?[^\d]*(\d+)", M))
                    AutoProfileAccNumber := M1
            }
            SendInput, {Esc}
            Sleep, 125
            SendInput, {Esc}
            if (AutoProfileName != "") {
                UserNick := AutoProfileName
                GuiControl, Main:, NickEdit, %UserNick%
                IniWrite, %UserNick%, %BindIni%, Settings, Nick
            }
            if (AutoProfileAccNumber != "") {
                UserAccNumber := AutoProfileAccNumber
                GuiControl, Main:, AccNumberEdit, %UserAccNumber%
                IniWrite, %UserAccNumber%, %BindIni%, Settings, AccNumber
            }
            if (AutoProfileName != "" || AutoProfileAccNumber != "") {
                addChatMessage("{FF0000}[" Tag "] {FFFFFF}ÐŸÑ€Ð¾Ñ„Ð¸Ð»ÑŒ Ð¾Ð±Ð½Ð¾Ð²Ð»ÐµÐ½:")
                Sleep, 12
                addChatMessage("{FF0000}[" Tag "] {FFFFFF}Ð˜Ð¼Ñ:{FF0000} " UserNick)
                Sleep, 12
                addChatMessage("{FF0000}[" Tag "] {FFFFFF}ÐÐ¾Ð¼ÐµÑ€ Ð°ÐºÐºÐ°ÑƒÐ½Ñ‚Ð°:{FF0000} " UserAccNumber)
                try UpdatePreviewFunc()
                SoundPlay, *-1
            } else {
                addChatMessage("{FF0000}[" Tag "] ÐžÑˆÐ¸Ð±ÐºÐ°: Ð”Ð°Ð½Ð½Ñ‹Ðµ Ð½Ðµ Ð½Ð°Ð¹Ð´ÐµÐ½Ñ‹.")
                SoundPlay, *-1
            }
            AutoProfileActive := 0
            AutoProfileStep := 0
        }
    }
return

; ====================================================================================================
; ÐžÐšÐÐž Ð˜Ð¡Ð¢ÐžÐ Ð˜Ð˜ ÐŸÐ Ð˜Ð—ÐžÐ’
; ====================================================================================================
global HistoryGuiHwnd := 0
ShowPrizeHistory() {
    global HistoryGuiHwnd, PrizeHistory, HistoryList
    if (HistoryGuiHwnd && WinExist("ahk_id " HistoryGuiHwnd)) {
        Gui, HistoryGui:Show
        return
    }
    Gui, HistoryGui:New, +ToolWindow -Caption +LastFound +Owner%MainGuiHwnd%
HistoryGuiHwnd := WinExist()
Gui, HistoryGui:Color, 1A1A1A
Gui, HistoryGui:Font, s14 Bold, Segoe UI
Gui, HistoryGui:Add, Text, x25 y15 gDragHistory cFFD700, ðŸŽ² Ð˜ÑÑ‚Ð¾Ñ€Ð¸Ñ Ð¿Ñ€Ð¸Ð·Ð¾Ð² (10 Ð¿Ð¾ÑÐ»ÐµÐ´Ð½Ð¸Ñ…)
Gui, HistoryGui:Font, s10, Segoe UI
Gui, HistoryGui:Add, Text, x25 y50 cWhite, â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
Gui, HistoryGui:Font, s11 Bold, Segoe UI
Gui, HistoryGui:Add, ListView, vHistoryList x25 y70 w400 h300 cFFD700 Background2D2D2D, Ð’Ñ€ÐµÐ¼Ñ|ÐŸÑ€Ð¸Ð·
LV_ModifyCol(1, 80)
LV_ModifyCol(2, 300)
Gui, HistoryGui:Font, s11 Bold cWhite, Segoe UI
Gui, HistoryGui:Add, Button, gCloseHistory x150 y390 w150 h35, ðŸ”„ Ð—Ð°ÐºÑ€Ñ‹Ñ‚ÑŒ
RefreshHistoryListFunc()
Gui, HistoryGui:Show, w450 h450, Ð˜ÑÑ‚Ð¾Ñ€Ð¸Ñ Ð¿Ñ€Ð¸Ð·Ð¾Ð²
Gui, Main:+Disabled
WinActivate, ahk_id %HistoryGuiHwnd%
}
CloseHistory:
    Gui, HistoryGui:Destroy
    Gui, Main:-Disabled
    WinActivate, ahk_id %MainGuiHwnd%
return
DragHistory:
    PostMessage, 0xA1, 2,,, A
return

; ====================================================================================================
; Ð¤Ð£ÐÐšÐ¦Ð˜Ð˜ Ð”Ð›Ð¯ Ð˜Ð¡Ð¢ÐžÐ Ð˜Ð˜ Ð¡ÐœÐ¡ Ð˜ Ð£Ð’Ð•Ð”ÐžÐœÐ›Ð•ÐÐ˜Ð™
; ====================================================================================================
LoadSmsHistory() {
    global SmsHistory, SmsHistoryFile
    SmsHistory := []
    if !FileExist(SmsHistoryFile)
        return
    IniRead, count, %SmsHistoryFile%, General, Count, 0
    Loop %count% {
        IniRead, type, %SmsHistoryFile%, Record%A_Index%, Type
        IniRead, number, %SmsHistoryFile%, Record%A_Index%, Number
        IniRead, name, %SmsHistoryFile%, Record%A_Index%, Name
        IniRead, text, %SmsHistoryFile%, Record%A_Index%, Text
        IniRead, time, %SmsHistoryFile%, Record%A_Index%, Time
        if (type != "ERROR")
            SmsHistory.Push({type: type, number: number, name: name, text: text, time: time})
    }
    while (SmsHistory.Length() > 30)
        SmsHistory.RemoveAt(1)
}
SaveSmsHistory() {
    global SmsHistory, SmsHistoryFile
    FileDelete, %SmsHistoryFile%
    IniWrite, % SmsHistory.Length(), %SmsHistoryFile%, General, Count
    for i, rec in SmsHistory {
        IniWrite, % rec.type, %SmsHistoryFile%, Record%i%, Type
        IniWrite, % rec.number, %SmsHistoryFile%, Record%i%, Number
        IniWrite, % rec.name, %SmsHistoryFile%, Record%i%, Name
        IniWrite, % rec.text, %SmsHistoryFile%, Record%i%, Text
        IniWrite, % rec.time, %SmsHistoryFile%, Record%i%, Time
    }
}
AddSmsRecord(type, number, name, text) {
    global SmsHistory
    FormatTime, timestamp,, HH:MM:SS
    SmsHistory.Push({type: type, number: number, name: name, text: text, time: timestamp})
    if (SmsHistory.Length() > 30)
        SmsHistory.RemoveAt(1)
    SaveSmsHistory()
    if (SmsHistoryGuiHwnd && WinExist("ahk_id " SmsHistoryGuiHwnd))
        RefreshSmsHistoryList()
}
OpenReplyFromNotification:
    Gosub, CloseNotification
    CreateSmsReplyGui(CurrentNotificationNumber, CurrentNotificationName, CurrentNotificationText)
return
CloseNotification:
    Gui, Notification:Destroy
    SetTimer, AutoCloseNotification, Off
return
AutoCloseNotification:
    Gui, Notification:Destroy
return
CreateSmsReplyGui(number, name, originalText := "") {
    global CurrentSmsNumber
    CurrentSmsNumber := number
    CurrentReplyName := name
    Gui, SmsReply:New, +AlwaysOnTop +ToolWindow -Caption +LastFound
    Gui, SmsReply:Color, 1A1A1A
    Gui, SmsReply:Font, s12 Bold, Segoe UI
    Gui, SmsReply:Add, Text, x10 y10 cFFD700, âœ‰ ÐžÑ‚Ð²ÐµÑ‚Ð¸Ñ‚ÑŒ %name% [%number%]
    Gui, SmsReply:Font, s10 cWhite, Segoe UI
    if (originalText != "")
        Gui, SmsReply:Add, Text, x10 y40, Ð¡Ð¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ðµ: %originalText%
    Gui, SmsReply:Font, s11, Segoe UI
    Gui, SmsReply:Add, Edit, vSmsReplyText x10 y70 w280 h60
    GuiControlGet, hEdit, SmsReply:Hwnd, SmsReplyText
    CtlColors.Attach(hEdit, "2D2D2D", "FFD700")
    Gui, SmsReply:Add, Button, gSendSmsReply x10 y140 w130 h30, ðŸ“¨ ÐžÑ‚Ð¿Ñ€Ð°Ð²Ð¸Ñ‚ÑŒ
    Gui, SmsReply:Add, Button, gCloseSmsReply x160 y140 w130 h30, âŒ ÐžÑ‚Ð¼ÐµÐ½Ð°
    Gui, SmsReply:Show, w300 h190, Ð‘Ñ‹ÑÑ‚Ñ€Ñ‹Ð¹ Ð¾Ñ‚Ð²ÐµÑ‚
    SetTimer, AutoCloseSmsReply, -30000
}
SendSmsReply:
    Gui, SmsReply:Submit, NoHide
    if (SmsReplyText != "") {
        SendChat("/sms " CurrentSmsNumber " " SmsReplyText)
        AddSmsRecord("out", CurrentSmsNumber, CurrentReplyName, SmsReplyText)
    }
    Gosub, CloseSmsReply
return

CloseSmsReply:
    Gui, SmsReply:Destroy
    SetTimer, AutoCloseSmsReply, Off
return
AutoCloseSmsReply:
    Gosub, CloseSmsReply
return
RefreshSmsHistoryList() {
    global SmsHistory, SmsHistoryList
    Gui, SmsHistoryGui:Default
    LV_Delete()
    Loop % SmsHistory.Length() {
        i := SmsHistory.Length() - A_Index + 1
        rec := SmsHistory[i]
        typeIcon := (rec.type = "in") ? "ðŸ“©" : "ðŸ“¤"
        typeName := (rec.type = "in") ? "" : ""

        ; ÐžÑ‚Ð¾Ð±Ñ€Ð°Ð¶ÐµÐ½Ð¸Ðµ Ð¸Ð¼ÐµÐ½Ð¸/Ð½Ð¾Ð¼ÐµÑ€Ð° Ð´Ð»Ñ Ð²Ñ…Ð¾Ð´ÑÑ‰Ð¸Ñ… Ð¸ Ð¸ÑÑ…Ð¾Ð´ÑÑ‰Ð¸Ñ…
        if (rec.type = "out") {
            ; Ð”Ð»Ñ Ð¸ÑÑ…Ð¾Ð´ÑÑ‰Ð¸Ñ… Ð¿Ð¾ÐºÐ°Ð·Ñ‹Ð²Ð°ÐµÐ¼ "â†’ Ð½Ð¾Ð¼ÐµÑ€" Ð¸Ð»Ð¸ "â†’ Ð¸Ð¼Ñ", ÐµÑÐ»Ð¸ Ð¸Ð¼Ñ ÐµÑÑ‚ÑŒ
            if (rec.name != "")
                displayName := "â†’ " rec.name " [" rec.number "]"
            else
                displayName := "â†’ [" rec.number "]"
        } else {
            ; Ð’Ñ…Ð¾Ð´ÑÑ‰Ð¸Ðµ: Ð¸Ð¼Ñ [Ð½Ð¾Ð¼ÐµÑ€]
            displayName := (rec.name != "") ? rec.name " [" rec.number "]" : "[" rec.number "]"
        }

        LV_Add("", rec.time, typeIcon " " typeName, displayName, rec.text)
    }
}
ShowSmsHistory() {
    global SmsHistoryGuiHwnd, SmsHistory, SmsHistoryList
    if (SmsHistoryGuiHwnd && WinExist("ahk_id " SmsHistoryGuiHwnd)) {
        Gui, SmsHistoryGui:Show
        WinActivate, ahk_id %SmsHistoryGuiHwnd%
        return
    }
    Gui, SmsHistoryGui:New, +ToolWindow -Caption +LastFound +Owner%MainGuiHwnd%
    SmsHistoryGuiHwnd := WinExist()
    Gui, SmsHistoryGui:Color, 1A1A1A
    Gui, SmsHistoryGui:Font, s14 Bold, Segoe UI
    Gui, SmsHistoryGui:Add, Text, x25 y15 gDragSmsHistory cFFD700, ðŸ“œ Ð˜ÑÑ‚Ð¾Ñ€Ð¸Ñ Ð¡ÐœÐ¡ (30 Ð¿Ð¾ÑÐ»ÐµÐ´Ð½Ð¸Ñ…)
    Gui, SmsHistoryGui:Font, s10, Segoe UI
    Gui, SmsHistoryGui:Add, Text, x25 y50 cWhite, â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    Gui, SmsHistoryGui:Font, s11 Bold, Segoe UI
    Gui, SmsHistoryGui:Add, ListView, vSmsHistoryList x25 y70 w500 h300 cFFD700 Background2D2D2D gSmsHistoryClick, Ð’Ñ€ÐµÐ¼Ñ|Ð¢Ð¸Ð¿|ÐÐ¾Ð¼ÐµÑ€/Ð˜Ð¼Ñ|Ð¢ÐµÐºÑÑ‚
    LV_ModifyCol(1, 70)
    LV_ModifyCol(2, 60)
    LV_ModifyCol(3, 120)
    LV_ModifyCol(4, 250)
    Gui, SmsHistoryGui:Font, s11 Bold cWhite, Segoe UI
    Gui, SmsHistoryGui:Add, Button, gCloseSmsHistory x200 y390 w150 h35, ðŸ”„ Ð—Ð°ÐºÑ€Ñ‹Ñ‚ÑŒ
    RefreshSmsHistoryList()
    Gui, SmsHistoryGui:Show, w550 h460, Ð˜ÑÑ‚Ð¾Ñ€Ð¸Ñ Ð¡ÐœÐ¡
    WinActivate, ahk_id %SmsHistoryGuiHwnd%
    Gui, Main:+Disabled
    WinActivate, ahk_id %HotkeysGuiHwnd%
}
SmsHistoryClick:
    Gui, SmsHistoryGui:Default
    if (A_GuiEvent = "DoubleClick") {
        RowNumber := A_EventInfo
        if (RowNumber = 0)
            return
        LV_GetText(numberName, RowNumber, 3)
        if RegExMatch(numberName, "\[(\d+)\]", match)
            number := match1
        else
            return
        name := Trim(RegExReplace(numberName, "\s*\[.*\]$", ""))
        if (name = "")
            name := number
        LV_GetText(text, RowNumber, 4)
        CreateSmsReplyGui(number, name, text)
        return
    }
    if (A_GuiEvent = "RightClick") {
        RowNumber := A_EventInfo
        if (RowNumber = 0)
            return
        LV_GetText(typeCol, RowNumber, 2)
        if InStr(typeCol, "ðŸ“©") {
            LV_GetText(numberName, RowNumber, 3)
            if RegExMatch(numberName, "\[(\d+)\]", match)
                number := match1
            else
                return
            LV_GetText(text, RowNumber, 4)
            name := Trim(RegExReplace(numberName, "\s*\[.*\]$", ""))
            if (name = "")
                name := number
            global _historyReplyNumber, _historyReplyName, _historyReplyText
            _historyReplyNumber := number
            _historyReplyName := name
            _historyReplyText := text
            Menu, SmsContextMenu, Add, ÐžÑ‚Ð²ÐµÑ‚Ð¸Ñ‚ÑŒ, ReplyFromHistory
            Menu, SmsContextMenu, Show
        }
    }
return
ReplyFromHistory:
    global _historyReplyNumber, _historyReplyName, _historyReplyText
    if (_historyReplyNumber != "") {
        CreateSmsReplyGui(_historyReplyNumber, _historyReplyName, _historyReplyText)
    }
return
DragSmsHistory:
    PostMessage, 0xA1, 2,,, A
return
CloseSmsHistory:
    Gui, SmsHistoryGui:Destroy
    Gui, Main:-Disabled
    WinActivate, ahk_id %MainGuiHwnd%
return

; ====================================================================================================
; Ð‘Ð˜ÐÐ”Ð•Ð Ð«
; ====================================================================================================
LoadBinders() {
    global
    Binders := []
    IniRead, BinderCount, %BindIni%, Binders, Count, 0
    if BinderCount is not number
        BinderCount := 0
    Loop, %BinderCount% {
        IniRead, name, %BindIni%, Binder%A_Index%, Name,
        IniRead, text, %BindIni%, Binder%A_Index%, Text,
        IniRead, key, %BindIni%, Binder%A_Index%, Key,
        IniRead, active, %BindIni%, Binder%A_Index%, Active, 1
        processedText := ParseTextWithDelays(text)
        Binders.Push({"id": A_Index, "name": name, "text": text, "key": key, "active": active, "processedText": processedText})
    }
    while Binders.Length() < 20
        Binders.Push({"id": Binders.Length()+1, "name": "", "text": "", "key": "", "active": 0, "processedText": ""})
}
SaveBinders() {
    global
    IniDelete, %BindIni%, Binders
    localCount := 0
    For index, binder in Binders {
        if (binder.text != "" || binder.key != "" || binder.name != "") {
            localCount++
            IniWrite, % binder.name, %BindIni%, Binder%localCount%, Name
            IniWrite, % binder.text, %BindIni%, Binder%localCount%, Text
            IniWrite, % binder.key, %BindIni%, Binder%localCount%, Key
            IniWrite, % binder.active, %BindIni%, Binder%localCount%, Active
        }
    }
    IniWrite, %localCount%, %BindIni%, Binders, Count
}
ParseTextWithDelays(text) {
    parts := []
    Loop, Parse, text, `n, `r
    {
        line := A_LoopField
        if (RegExMatch(line, "^\s*time\s+(\d+)\s*$", match))
            parts.Push({"type": "delay", "value": match1})
        else if (line != "")
            parts.Push({"type": "command", "value": line})
    }
    return parts
}
ExecuteBinder(binder) {
    if (!binder.active || binder.text == "")
        return
    parts := binder.processedText
    For index, part in parts {
        if (part.type == "command")
            SendChat(part.value)
        else if (part.type == "delay")
            Sleep, % part.value
    }
}
RegisterAllBinderHotkeys() {
    global
    for i, handle in HotkeyHandles
        Hotkey, % handle.key, % handle.label, Off UseErrorLevel
    HotkeyHandles := []
    For index, binder in Binders {
        if (binder.active && binder.key != "") {
            label := "BinderHotkey_" . index
            if (!IsLabel(label))
                Gosub, CreateHotkeyLabel
            Hotkey, % binder.key, % label, On UseErrorLevel
            if (ErrorLevel = 0)
                HotkeyHandles.Push({"key": binder.key, "label": label, "index": index})
        }
    }
}
CreateHotkeyLabel:
    Loop, 20 {
        label := "BinderHotkey_" . A_Index
        if (!IsLabel(label))
            Hotkey, % "$", % label, Off UseErrorLevel
    }
return

BinderHotkey_1:
    ExecuteBinder(Binders[1])
return
BinderHotkey_2:
    ExecuteBinder(Binders[2])
return
BinderHotkey_3:
    ExecuteBinder(Binders[3])
return
BinderHotkey_4:
    ExecuteBinder(Binders[4])
return
BinderHotkey_5:
    ExecuteBinder(Binders[5])
return
BinderHotkey_6:
    ExecuteBinder(Binders[6])
return
BinderHotkey_7:
    ExecuteBinder(Binders[7])
return
BinderHotkey_8:
    ExecuteBinder(Binders[8])
return
BinderHotkey_9:
    ExecuteBinder(Binders[9])
return
BinderHotkey_10:
    ExecuteBinder(Binders[10])
return
BinderHotkey_11:
    ExecuteBinder(Binders[11])
return
BinderHotkey_12:
    ExecuteBinder(Binders[12])
return
BinderHotkey_13:
    ExecuteBinder(Binders[13])
return
BinderHotkey_14:
    ExecuteBinder(Binders[14])
return
BinderHotkey_15:
    ExecuteBinder(Binders[15])
return
BinderHotkey_16:
    ExecuteBinder(Binders[16])
return
BinderHotkey_17:
    ExecuteBinder(Binders[17])
return
BinderHotkey_18:
    ExecuteBinder(Binders[18])
return
BinderHotkey_19:
    ExecuteBinder(Binders[19])
return
BinderHotkey_20:
    ExecuteBinder(Binders[20])
return

; ====================================================================================================
; Ð¢ÐÐ™ÐœÐ•Ð Ð«
; ====================================================================================================
LoadTimers() {
    global
    CurrentTimers := []
    IniRead, TimerCount, %BindIni%, Timers, Count, 0
    if TimerCount is not number
        TimerCount := 0
    Loop, %TimerCount% {
        IniRead, cmd, %BindIni%, Timer%A_Index%, Command,
        IniRead, sec, %BindIni%, Timer%A_Index%, Seconds, 0
        if (cmd != "" && sec > 0)
            CurrentTimers.Push({"id": A_Index, "command": cmd, "seconds": sec, "running": 0})
    }
}
SaveTimers() {
    global
    IniDelete, %BindIni%, Timers
    IniWrite, % CurrentTimers.Length(), %BindIni%, Timers, Count
    For index, timer in CurrentTimers {
        IniWrite, % timer.command, %BindIni%, Timer%index%, Command
        IniWrite, % timer.seconds, %BindIni%, Timer%index%, Seconds
    }
}
StopAllTimers() {
    global TimerHandles
    for index, timerObj in TimerHandles
        if (timerObj.timerName != "")
            SetTimer, % timerObj.timerName, Off
    TimerHandles := []
}
StartAllTimers() {
    global CurrentTimers, TimerHandles
    StopAllTimers()
    For index, timer in CurrentTimers {
        if (timer.seconds > 0 && timer.command != "") {
            timerName := "Timer_" . index
            if (!IsLabel(timerName))
                Gosub, CreateTimerLabels
            SetTimer, % timerName, % timer.seconds * 1000
            TimerHandles.Push({"index": index, "timerName": timerName})
            CurrentTimers[index].running := 1
        } else {
            CurrentTimers[index].running := 0
        }
    }
    SaveTimers()
}
CreateTimerLabels:
    Loop, 10 {
        label := "Timer_" . A_Index
        if (!IsLabel(label))
            Gosub, % label
    }
return
SendTimerCommand(timerId) {
    global CurrentTimers
    if (timerId <= CurrentTimers.Length() && CurrentTimers[timerId].command != "")
        SendChat(CurrentTimers[timerId].command)
}
Timer_1:
    SendTimerCommand(1)
return
Timer_2:
    SendTimerCommand(2)
return
Timer_3:
    SendTimerCommand(3)
return
Timer_4:
    SendTimerCommand(4)
return
Timer_5:
    SendTimerCommand(5)
return
Timer_6:
    SendTimerCommand(6)
return
Timer_7:
    SendTimerCommand(7)
return
Timer_8:
    SendTimerCommand(8)
return
Timer_9:
    SendTimerCommand(9)
return
Timer_10:
    SendTimerCommand(10)
return

StartTimerById(timerId) {
    global CurrentTimers, TimerHandles
    if (timerId <= CurrentTimers.Length()) {
        for i, handle in TimerHandles
            if (handle.index = timerId) {
                SetTimer, % handle.timerName, Off
                TimerHandles.RemoveAt(i)
                break
            }
        timerName := "Timer_" . timerId
        SetTimer, % timerName, % CurrentTimers[timerId].seconds * 1000
        TimerHandles.Push({"index": timerId, "timerName": timerName})
        CurrentTimers[timerId].running := 1
        SaveTimers()
        return true
    }
    return false
}
StopTimerById(timerId) {
    global CurrentTimers, TimerHandles
    for i, handle in TimerHandles
        if (handle.index = timerId) {
            SetTimer, % handle.timerName, Off
            TimerHandles.RemoveAt(i)
            break
        }
    if (timerId <= CurrentTimers.Length()) {
        CurrentTimers[timerId].running := 0
        SaveTimers()
        return true
    }
    return false
}

; ====================================================================================================
; Ð—ÐÐ“Ð Ð£Ð—ÐšÐ ÐšÐžÐÐ¤Ð˜Ð“Ð
; ====================================================================================================
LoadConfigFromFile() {
    global
    FileSelectFile, configFile, 3, %A_MyDesktop%, Ð’Ñ‹Ð±ÐµÑ€Ð¸Ñ‚Ðµ Ñ„Ð°Ð¹Ð» ÐºÐ¾Ð½Ñ„Ð¸Ð³ÑƒÑ€Ð°Ñ†Ð¸Ð¸ (*.txt), Text Files (*.txt)
    if (configFile = "")
        return
    FileRead, configContent, %configFile%
    if (ErrorLevel) {
        MsgBox, 4096, ÐžÑˆÐ¸Ð±ÐºÐ°, ÐÐµ ÑƒÐ´Ð°Ð»Ð¾ÑÑŒ Ð¿Ñ€Ð¾Ñ‡Ð¸Ñ‚Ð°Ñ‚ÑŒ Ñ„Ð°Ð¹Ð»!
        return
    }
    Loop, Parse, configContent, `n, `r
    {
        line := Trim(A_LoopField)
        if (line = "" || SubStr(line, 1, 1) = ";")
            continue
        if (RegExMatch(line, "i)^Nick\s*=\s*(.+)$", match))
            UserNick := match1
        else if (RegExMatch(line, "i)^Gender\s*=\s*(\d+)$", match))
            Gender := match1
        else if (RegExMatch(line, "i)^AccNumber\s*=\s*(\d+)$", match))
            UserAccNumber := match1
        else if (RegExMatch(line, "i)^AutoRoulette\s*=\s*(\d+)$", match))
            AutoRouletteActive := match1
else if (RegExMatch(line, "i)^AutoTime\s*=\s*(\d+)$", match))
    AutoTimeActive := match1
else if (RegExMatch(line, "i)^City\s*=\s*(.+)$", match)) {
    CityCode := match1
    UpdateCityName()
}
        else if (RegExMatch(line, "i)^Binder(\d+)_Name\s*=\s*(.*)$", match)) {
            idx := match1
            name := match2
            if (idx >= 1 && idx <= 20)
                Binders[idx].name := name
        }
        else if (RegExMatch(line, "i)^Binder(\d+)_Text\s*=\s*(.*)$", match)) {
            idx := match1
            text := match2
            if (idx >= 1 && idx <= 20)
                Binders[idx].text := text
        }
        else if (RegExMatch(line, "i)^Binder(\d+)_Key\s*=\s*(.*)$", match)) {
            idx := match1
            key := match2
            if (idx >= 1 && idx <= 20)
                Binders[idx].key := key
        }
        else if (RegExMatch(line, "i)^Binder(\d+)_Active\s*=\s*(\d+)$", match)) {
            idx := match1
            active := match2
            if (idx >= 1 && idx <= 20)
                Binders[idx].active := active
        }
        else if (RegExMatch(line, "i)^Timer(\d+)_Command\s*=\s*(.*)$", match)) {
            idx := match1
            cmd := match2
            if (idx >= 1 && idx <= 10) {
                if (CurrentTimers.Length() < idx)
                    CurrentTimers.Push({"command": "", "seconds": 30, "running": 0})
                CurrentTimers[idx].command := cmd
            }
        }
        else if (RegExMatch(line, "i)^Timer(\d+)_Seconds\s*=\s*(\d+)$", match)) {
            idx := match1
            sec := match2
            if (idx >= 1 && idx <= 10) {
                if (CurrentTimers.Length() < idx)
                    CurrentTimers.Push({"command": "", "seconds": 30, "running": 0})
                CurrentTimers[idx].seconds := sec
            }
        }
    }
    For idx, binder in Binders
        binder.processedText := ParseTextWithDelays(binder.text)
    IniWrite, %UserNick%, %BindIni%, Settings, Nick
    IniWrite, %UserAccNumber%, %BindIni%, Settings, AccNumber
    IniWrite, %Gender%, %BindIni%, Settings, Gender
    IniWrite, %AutoRouletteActive%, %BindIni%, Settings, AutoRoulette
    IniWrite, %AutoTimeActive%, %BindIni%, Settings, AutoTime
    SaveBinders()
    SaveTimers()
    GuiControl, Main:, NickEdit, %UserNick%
    GuiControl, Main:, AccNumberEdit, %UserAccNumber%
    if (Gender == 1)
        GuiControl, Main:, GenderRadioMale, 1
    else
        GuiControl, Main:, GenderRadioFemale, 1
    GuiControl, Main:, AutoRouletteCheck, %AutoRouletteActive%
    GuiControl, Main:, AutoTimeCheck, %AutoTimeActive%
    StartAllTimers()
    RegisterAllBinderHotkeys()
    if (AutoTimeActive)
        StartAutoTime()
    else
        StopAutoTime()
    UpdatePreviewFunc()
    SoundPlay, *-1
}

; ====================================================================================================
; Ð˜ÐÐ¢Ð•Ð Ð¤Ð•Ð™Ð¡ Ð“Ð›ÐÐ’ÐÐžÐ“Ðž ÐžÐšÐÐ
; ====================================================================================================
UpdatePreviewFunc() {
    global
    GuiControlGet, NickEdit, Main:
    GuiControlGet, AccNumberEdit, Main:
    GuiControl, Main:Text, PreviewName, %NickEdit%
    GuiControl, Main:Text, PreviewAccNumber, % "ÐÐ¾Ð¼ÐµÑ€ Ð°ÐºÐºÐ°ÑƒÐ½Ñ‚Ð°: " . (AccNumberEdit != "" ? AccNumberEdit : "â€”")
    if (GenderRadioMale = 1) {
        GuiControl, Main:Text, PreviewGender, ðŸ‘¨â€ðŸ’¼ ÐœÑƒÐ¶Ñ‡Ð¸Ð½Ð°
        GuiControl, Main:Text, PreviewRole, ðŸ‘® Ð¡Ð¾Ñ‚Ñ€ÑƒÐ´Ð½Ð¸Ðº
        GuiControl, Main:Text, PreviewAvatar, ðŸ‘¨â€ðŸ’¼
    } else {
        GuiControl, Main:Text, PreviewGender, ðŸ‘©â€ðŸ’¼ Ð–ÐµÐ½Ñ‰Ð¸Ð½Ð°
        GuiControl, Main:Text, PreviewRole, ðŸ‘®â€â™€ï¸ Ð¡Ð¾Ñ‚Ñ€ÑƒÐ´Ð½Ð¸Ñ†Ð°
        GuiControl, Main:Text, PreviewAvatar, ðŸ‘©â€ðŸ’¼
    }
}
ApplyThemeFunc() {
    global
    mainC := "FFD700"
    backC := "1A1A1A"
    editC := "2D2D2D"
    Gui, Main:Color, %backC%, %editC%
    Gui, Main:Font, cWhite
    GuiControl, Main:+c%mainC%, DragArea
    GuiControl, Main:+c%mainC%, MainGroup
    GuiControl, Main:+c%mainC%, LeftGroup
    GuiControl, Main:+c%mainC%, RightGroup
    GuiControl, Main:+c%mainC%, AvatarGroup
    GuiControl, Main:+c%mainC%, PreviewAvatar
    GuiControl, Main:+c%mainC%, Lbl1, Lbl2, Lbl3, Lbl4, Lbl5, Lbl6
    GuiControl, Main:+c%mainC%, PreviewName, PreviewAccNumber, PreviewGender, PreviewRole
}
UpdateStatusAndTime() {
    global
    FormatTime, currentTime,, HH:mm:ss
    EnvAdd, currentTime, 3, Hours
    FormatTime, mskTime, %currentTime%, HH:mm:ss

    activeCount := 0
    For index, binder in Binders
        if (binder.active && binder.key != "" && binder.text != "")
            activeCount++

    ; Ð¡Ñ‚Ð°Ñ‚ÑƒÑ: Ð°ÐºÑ‚Ð¸Ð²ÐµÐ½ Ñ‚Ð¾Ð»ÑŒÐºÐ¾ ÐµÑÐ»Ð¸ Ð½ÐµÑ‚ ÐÐ¤Ðš Ð¸ ÐµÑÑ‚ÑŒ Ð°ÐºÑ‚Ð¸Ð²Ð½Ñ‹Ðµ Ð±Ð¸Ð½Ð´ÐµÑ€Ñ‹
    isReallyActive := (UserIsActive && activeCount > 0)
    if (isReallyActive)
        statusColor := "ðŸŸ¢", statusText := "ÐÐºÑ‚Ð¸Ð²ÐµÐ½"
    else if (!UserIsActive)
        statusColor := "ðŸ”´", statusText := "ÐÐµÐ°ÐºÑ‚Ð¸Ð²ÐµÐ½"
    else
        statusColor := "ðŸŸ¡", statusText := "ÐžÐ¶Ð¸Ð´Ð°Ð½Ð¸Ðµ"

    autoRouletteStatus := AutoRouletteActive ? "ðŸŽ²" : "âšª"
    autoTimeStatus := AutoTimeActive ? "â±ï¸" : "âšª"
    GuiControl, Main:Text, StatusIndicator, %statusColor% %statusText% | ðŸ• %mskTime% ÐœÐ¡Ðš | ÐÐ²Ñ‚Ð¾: %autoRouletteStatus% %autoTimeStatus%
}

; ====================================================================================================
; ÐÐÐ˜ÐœÐÐ¦Ð˜Ð¯ ÐžÐšÐžÐ
; ====================================================================================================
AnimateWindowShow(hwnd, steps := 15, delay := 5) {
    if !hwnd
        return
    WinShow, ahk_id %hwnd%
    WinSet, Transparent, 0, ahk_id %hwnd%
    stepSize := 255 / steps
    Loop, % steps {
        transparency := Floor(A_Index * stepSize)
        WinSet, Transparent, %transparency%, ahk_id %hwnd%
        Sleep, delay
    }
    WinSet, Transparent, 255, ahk_id %hwnd%
}
AnimateWindowHide(hwnd, steps := 15, delay := 5) {
    if !hwnd
        return
    stepSize := 255 / steps
    Loop, % steps {
        transparency := 255 - Floor(A_Index * stepSize)
        WinSet, Transparent, %transparency%, ahk_id %hwnd%
        Sleep, delay
    }
    WinSet, Transparent, 255, ahk_id %hwnd%
    WinHide, ahk_id %hwnd%
}

; ====================================================================================================
; ÐŸÐžÐšÐÐ— Ð“Ð›ÐÐ’ÐÐžÐ“Ðž ÐžÐšÐÐ (Ð´Ð¾Ð±Ð°Ð²Ð»ÐµÐ½Ð° ÐºÐ½Ð¾Ð¿ÐºÐ° "Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ðµ ÐºÐ¾Ð¼Ð±Ð¸Ð½Ð°Ñ†Ð¸Ð¸")
; ====================================================================================================
ShowMainGui() {
    global
    if (MainGuiHwnd && WinExist("ahk_id " MainGuiHwnd)) {
        Gui, Main:Show, NoActivate
        AnimateWindowShow(MainGuiHwnd)
        WinActivate, ahk_id %MainGuiHwnd%
        SetTimer, UpdateStatusTimer, 1000
        return
    }
    Gui, Main:New, +LastFound -Caption +OwnDialogs
    MainGuiHwnd := WinExist()
    Gui, Main:Font, s22 Bold, Segoe UI
    Gui, Main:Add, Text, vDragArea x25 y20 gStartDrag cFFD700, âšœï¸ ÐœÐ­Ð Ð˜Ð¯ HELPER
    Gui, Main:Font, s11, Segoe UI
    Gui, Main:Add, Text, x25 y60 cWhite, â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    Gui, Main:Add, GroupBox, vMainGroup x25 y100 w800 h530 cFFD700
    Gui, Main:Add, GroupBox, vLeftGroup x55 y130 w480 h470 cFFD700
    Gui, Main:Add, GroupBox, vRightGroup x550 y130 w260 h470 cFFD700
    Gui, Main:Font, s11 Bold, Segoe UI
    Gui, Main:Add, Text, vLbl1 x75 y155 cFFD700, â–¸ Ð˜Ð³Ñ€Ð¾Ð²Ð¾Ð¹ Ð½Ð¸ÐºÐ½ÐµÐ¹Ð¼
    Gui, Main:Font, s14, Segoe UI
    Gui, Main:Add, Edit, vNickEdit gUpdatePreview x75 y180 w440 h35 Center cFFD700 Background000000, %UserNick%
    Gui, Main:Font, s11 Bold, Segoe UI
    Gui, Main:Add, Text, vLbl6 x75 y230 cFFD700, â–¸ ÐÐ¾Ð¼ÐµÑ€ Ð°ÐºÐºÐ°ÑƒÐ½Ñ‚Ð°
    Gui, Main:Font, s14, Segoe UI
    Gui, Main:Add, Edit, vAccNumberEdit gUpdatePreview x75 y255 w440 h35 Center cFFD700 Background000000, %UserAccNumber%
    Gui, Main:Font, s12 Bold cWhite, Segoe UI
    Gui, Main:Add, Button, gShowTimerManager x75 y320 w210 h40, â° Ð¢Ð°Ð¹Ð¼ÐµÑ€Ñ‹
    Gui, Main:Add, Button, gShowBinderManager x305 y320 w210 h40, ðŸ”— Ð‘Ð¸Ð½Ð´ÐµÑ€Ñ‹
    Gui, Main:Font, s11 Bold, Segoe UI
    Gui, Main:Add, Text, vLbl3 x75 y390 cFFD700, â–¸ ÐŸÐ¾Ð» Ð¿ÐµÑ€ÑÐ¾Ð½Ð°Ð¶Ð°
    Gui, Main:Font, s12 Bold cFFD700, Segoe UI
    Gui, Main:Add, Radio, vGenderRadioMale gGenderChanged x95 y415 w120 h30 Group, ðŸ‘¨â€ðŸ’¼ ÐœÑƒÐ¶ÑÐºÐ¾Ð¹
    Gui, Main:Add, Radio, vGenderRadioFemale gGenderChanged x225 y415 w120 h30, ðŸ‘©â€ðŸ’¼ Ð–ÐµÐ½ÑÐºÐ¸Ð¹
    if (Gender == 1)
        GuiControl, Main:, GenderRadioMale, 1
    else
        GuiControl, Main:, GenderRadioFemale, 1

       ; Ð›Ð•Ð’ÐÐ¯ ÐšÐžÐ›ÐžÐÐšÐ: Ñ‡ÐµÐºÐ±Ð¾ÐºÑÑ‹, ÐºÐ½Ð¾Ð¿ÐºÐ¸ Ð¸ÑÑ‚Ð¾Ñ€Ð¸Ð¸ Ð¸ Ð²Ñ‹Ð±Ð¾Ñ€ Ð³Ð¾Ñ€Ð¾Ð´Ð° (Ð²Ñ‹Ð¿Ð°Ð´Ð°ÑŽÑ‰Ð¸Ð¹ ÑÐ¿Ð¸ÑÐ¾Ðº)
    Gui, Main:Font, s10 Bold, Segoe UI
    Gui, Main:Add, Checkbox, vAutoRouletteCheck gToggleAutoRoulette x75 y455 w180 h25 cFFD700, ðŸŽ² ÐÐ²Ñ‚Ð¾-Ñ€ÑƒÐ»ÐµÑ‚ÐºÐ°
    Gui, Main:Add, Checkbox, vAutoTimeCheck gToggleAutoTime x75 y485 w200 h25 cFFD700, â±ï¸ ÐÐ²Ñ‚Ð¾-time (45 ÑÐµÐº)

    ; ÐšÐ½Ð¾Ð¿ÐºÐ° "Ð˜ÑÑ‚Ð¾Ñ€Ð¸Ñ Ð¿Ñ€Ð¸Ð·Ð¾Ð²"
    Gui, Main:Add, Button, gShowPrizeHistory x75 y520 w210 h25, ðŸ“œ Ð˜ÑÑ‚Ð¾Ñ€Ð¸Ñ Ð¿Ñ€Ð¸Ð·Ð¾Ð²

        ; Ð’Ñ‹Ð±Ð¾Ñ€ Ð³Ð¾Ñ€Ð¾Ð´Ð° (Ð²Ñ‹Ð¿Ð°Ð´Ð°ÑŽÑ‰Ð¸Ð¹ ÑÐ¿Ð¸ÑÐ¾Ðº, ÑˆÐ¸Ñ€Ð¸Ð½Ð° ÐºÐ°Ðº Ñƒ ÐºÐ½Ð¾Ð¿ÐºÐ¸, Ñ‚ÐµÐºÑÑ‚ Ð¿Ð¾ Ñ†ÐµÐ½Ñ‚Ñ€Ñƒ)
    Gui, Main:Font, s10 Bold, Segoe UI
    Gui, Main:Add, Text, x305 y525 cFFD700,   ; Ð¿ÑƒÑÑ‚Ð¾Ð¹ Ñ‚ÐµÐºÑÑ‚ (Ð¼Ð¾Ð¶Ð½Ð¾ ÑƒÐ´Ð°Ð»Ð¸Ñ‚ÑŒ)
    Gui, Main:Add, DropDownList, vCityList gCityChanged x300 y520 w210 +Center, ðŸ›ŽÐ›Ð°Ñ-Ð’ÐµÐ½Ñ‚ÑƒÑ€Ð°Ñ||ðŸ›ŽÐ¡Ð°Ð½-Ð¤Ð¸ÐµÑ€Ñ€Ð¾|ðŸ›ŽÐ›Ð¾Ñ-Ð¡Ð°Ð½Ñ‚Ð¾Ñ
    GuiControlGet, hCity, Main:Hwnd, CityList
    CtlColors.Attach(hCity, "2D2D2D", "FFD700")
    if (CityCode = "LV")
        GuiControl, Choose, CityList, 1
    else if (CityCode = "SF")
        GuiControl, Choose, CityList, 2
    else
        GuiControl, Choose, CityList, 3

    ; ÐšÐ½Ð¾Ð¿ÐºÐ° "Ð˜ÑÑ‚Ð¾Ñ€Ð¸Ñ Ð¡ÐœÐ¡" (Ð¾ÑÑ‚Ð°Ñ‘Ñ‚ÑÑ Ð½Ð° ÑÐ²Ð¾Ñ‘Ð¼ Ð¼ÐµÑÑ‚Ðµ)
    Gui, Main:Add, Button, gShowSmsHistory x75 y550 w210 h25, ðŸ“œ Ð˜ÑÑ‚Ð¾Ñ€Ð¸Ñ Ð¡ÐœÐ¡

    ; === ÐŸÐ ÐÐ’ÐÐ¯ ÐšÐžÐ›ÐžÐÐšÐ (Ð±ÐµÐ· Ð³Ð¾Ñ€Ð¾Ð´Ð°) ===
    Gui, Main:Font, s13 Bold, Segoe UI
    Gui, Main:Add, Text, vLbl5 x575 y155 cFFD700 Center w210, â­ ÐŸÑ€Ð¾Ñ„Ð¸Ð»ÑŒ
    Gui, Main:Font, s9 cWhite, Segoe UI
    Gui, Main:Add, Text, x575 y180 cWhite, â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    Gui, Main:Font, s14 Bold cWhite, Segoe UI
    Gui, Main:Add, Text, vPreviewName x570 y210 w220 Center, %UserNick%
    Gui, Main:Font, s10 cFFD700, Segoe UI
    Gui, Main:Add, Text, vPreviewAccNumber x570 y245 w220 Center, % "ÐÐ¾Ð¼ÐµÑ€ Ð°ÐºÐºÐ°ÑƒÐ½Ñ‚Ð°: " . (UserAccNumber != "" ? UserAccNumber : "â€”")
    Gui, Main:Font, s11 cFFD700, Segoe UI
    Gui, Main:Add, Text, vPreviewGender x570 y280 w220 Center
    Gui, Main:Add, Text, vPreviewRole x570 y310 w220 Center
    Gui, Main:Font, s10 Bold, Segoe UI
    Gui, Main:Add, Text, x575 y350 vStatusIndicator w220 Center cFFD700, ðŸŸ¢ Ð—Ð°Ð³Ñ€ÑƒÐ·ÐºÐ°...

    ; ÐÐ²Ð°Ñ‚Ð°Ñ€ (Ð¾ÑÑ‚Ð°Ñ‘Ñ‚ÑÑ Ð½Ð° Ð¼ÐµÑÑ‚Ðµ)
    Gui, Main:Add, GroupBox, vAvatarGroup x575 y380 w210 h200 cFFD700
    Gui, Main:Font, s85, Segoe UI
    Gui, Main:Add, Text, vPreviewAvatar x575 y400 w210 h160 Center cFFD700, ðŸ‘¨â€ðŸ’¼

    ; ÐÐ¸Ð¶Ð½Ð¸Ðµ ÐºÐ½Ð¾Ð¿ÐºÐ¸
    Gui, Main:Font, s14 Bold cWhite, Segoe UI
    Gui, Main:Add, Button, gReloadScriptFromGui x720 y25 w35 h35, ðŸ”„
    Gui, Main:Add, Button, gSupportVK x760 y25 w35 h35, â“
    Gui, Main:Add, Button, gExitApp x800 y25 w35 h35, âœ•
    Gui, Main:Font, s11 Bold cWhite, Segoe UI
    Gui, Main:Add, Button, gSaveSettings x80 y640 w110 h40, ðŸ’¾ Ð¡Ð¾Ñ…Ñ€Ð°Ð½Ð¸Ñ‚ÑŒ
    Gui, Main:Add, Button, gLoadConfigFromFile x210 y640 w110 h40, ðŸ“ Ð—Ð°Ð³Ñ€ÑƒÐ·Ð¸Ñ‚ÑŒ
    Gui, Main:Add, Button, gCloseSettings x340 y640 w110 h40, ðŸ”„ Ð¡Ð²ÐµÑ€Ð½ÑƒÑ‚ÑŒ
    Gui, Main:Add, Button, gShowInstructions x470 y640 w130 h40, ðŸ“– Ð˜Ð½ÑÑ‚Ñ€ÑƒÐºÑ†Ð¸Ñ
    Gui, Main:Add, Button, gShowHotkeysInfo x620 y640 w130 h40, âš™ï¸ ÐšÐ¾Ð¼Ð±Ð¸Ð½Ð°Ñ†Ð¸Ð¸

    ApplyThemeFunc()
    UpdatePreviewFunc()
    UpdateStatusAndTime()
    GuiControl, Main:, AutoRouletteCheck, %AutoRouletteActive%
    GuiControl, Main:, AutoTimeCheck, %AutoTimeActive%
    SetTimer, UpdateStatusTimer, 1000
    Gui, Main:Show, Hide
    AnimateWindowShow(MainGuiHwnd)
    WinActivate, ahk_id %MainGuiHwnd%
}

; ====================================================================================================
; ÐžÐšÐÐž Ð¡Ð˜Ð¡Ð¢Ð•ÐœÐÐ«Ð¥ ÐšÐžÐœÐ‘Ð˜ÐÐÐ¦Ð˜Ð™ (Ð’Ð«Ð ÐžÐ’ÐÐ•ÐÐž ÐŸÐž Ð¦Ð•ÐÐ¢Ð Ð£)
; ====================================================================================================
ShowHotkeysInfo() {
    global HotkeysGuiHwnd, MainGuiHwnd
    if (HotkeysGuiHwnd && WinExist("ahk_id " HotkeysGuiHwnd)) {
        Gui, HotkeysGui:Show
        WinActivate, ahk_id %HotkeysGuiHwnd%
        return
    }
    Gui, HotkeysGui:New, +ToolWindow -Caption +LastFound +Owner%MainGuiHwnd%
    HotkeysGuiHwnd := WinExist()
    Gui, HotkeysGui:Color, 1A1A1A
    Gui, HotkeysGui:Font, s16 Bold, Segoe UI
    Gui, HotkeysGui:Add, Text, x0 y15 w500 Center gDragHotkeys cFFD700, âŒ¨ï¸ Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ðµ ÐºÐ¾Ð¼Ð±Ð¸Ð½Ð°Ñ†Ð¸Ð¸
    Gui, HotkeysGui:Font, s10, Segoe UI
    Gui, HotkeysGui:Add, Text, x25 y50 w450 Center cWhite, â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

    ; Ð¡Ð¿Ð¸ÑÐ¾Ðº ÐºÐ¾Ð¼Ð°Ð½Ð´ Ñ Ñ€Ð°Ð·Ð´ÐµÐ»Ð¸Ñ‚ÐµÐ»ÑÐ¼Ð¸ Ð¸ Ñ†Ð²ÐµÑ‚Ð¾Ð¼
    Gui, HotkeysGui:Font, s11 cWhite, Segoe UI
    Gui, HotkeysGui:Add, Text, x25 y90 cFF5555,
    Gui, HotkeysGui:Add, Text, x25 y90 cWhite,  /Ð²Ñ‹Ð¿ [ID] - Ð²Ñ‹Ð¿ÑƒÑÑ‚Ð¸Ñ‚ÑŒ Ñ‡ÐµÐ»Ð¾Ð²ÐµÐºÐ° Ñ ÐšÐŸÐ—
    Gui, HotkeysGui:Add, Progress, x25 y108 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y120 cFF5555,
    Gui, HotkeysGui:Add, Text, x25 y120 cWhite,  /Ð»Ð¸Ñ†Ð° [ID] - Ð¿Ñ€Ð¾Ð´Ð°Ñ‚ÑŒ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸ÑŽ
    Gui, HotkeysGui:Add, Progress, x25 y138 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y150 cFF5555,
    Gui, HotkeysGui:Add, Text, x25 y150 cWhite,  /Ð¸Ð½Ñ„ [ID] - Ð¸Ð½Ñ„Ð¾Ñ€Ð¼Ð°Ñ†Ð¸Ñ Ð¾ Ð¸Ð³Ñ€Ð¾ÐºÐµ
    Gui, HotkeysGui:Add, Progress, x25 y168 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y180 cFF5555,
    Gui, HotkeysGui:Add, Text, x25 y180 cWhite,  /Ð°Ð²Ñ‚Ð¾Ð¿Ñ€Ð¾Ñ„Ð¸Ð»ÑŒ - Ð°Ð²Ñ‚Ð¾Ð¼Ð°Ñ‚Ð¸Ñ‡ÐµÑÐºÐ¾Ðµ Ð·Ð°Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ðµ Ð¿Ñ€Ð¾Ñ„Ð¸Ð»Ñ
    Gui, HotkeysGui:Add, Progress, x25 y198 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y210 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y210 cWhite,  Alt+1 - Ð¿Ñ€Ð¸Ð²ÐµÑ‚ÑÑ‚Ð²Ð¸Ðµ ÑÐ¾Ñ‚Ñ€ÑƒÐ´Ð½Ð¸ÐºÐ°
    Gui, HotkeysGui:Add, Progress, x25 y228 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y240 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y240 cWhite,  Alt+2 - ÑÐ¿Ð¸ÑÐ¾Ðº Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹ Ñ Ñ†ÐµÐ½Ð°Ð¼Ð¸
    Gui, HotkeysGui:Add, Progress, x25 y258 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y270 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y270 cWhite,  Alt+3 - Ñ†ÐµÐ½Ð° Ð¾Ñ‚Ð´ÐµÐ»ÑŒÐ½Ð¾Ð¹ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¸ (1-7)
    Gui, HotkeysGui:Add, Progress, x25 y288 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y300 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y300 cWhite,  Alt+4 - ÐºÐ°Ð»ÑŒÐºÑƒÐ»ÑÑ‚Ð¾Ñ€ ÑÑƒÐ¼Ð¼Ñ‹ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹ (1-7, Backspace, Delete)
    Gui, HotkeysGui:Add, Progress, x25 y318 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y330 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y330 cWhite,  Ctrl+1 - ÑƒÑÐ»Ð¾Ð²Ð¸Ñ Ð°Ð´Ð²Ð¾ÐºÐ°Ñ‚Ð°
    Gui, HotkeysGui:Add, Progress, x25 y348 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y360 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y360 cWhite,  Alt+Delete - Ð¿Ð¾Ð»Ð½Ð°Ñ Ð¿ÐµÑ€ÐµÐ·Ð°Ð³Ñ€ÑƒÐ·ÐºÐ° ÑÐºÑ€Ð¸Ð¿Ñ‚Ð°
    Gui, HotkeysGui:Add, Progress, x25 y378 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y390 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y390 cWhite,  Home - Ð¾Ñ‚Ð¿Ñ€Ð°Ð²Ð¸Ñ‚ÑŒ /Ñ„Ñ€Ð°ÐºÑ†Ð¸Ñ
    Gui, HotkeysGui:Add, Progress, x25 y408 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y420 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y420 cWhite,  NumPad+ - ÑƒÑÑ‚Ð°Ð½Ð¾Ð²Ð¸Ñ‚ÑŒ 30 ÑÑ‚Ñ€Ð¾Ðº Ð² Ñ‡Ð°Ñ‚Ðµ
    Gui, HotkeysGui:Add, Progress, x25 y438 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y450 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y450 cWhite,  NumPad- - ÑƒÑÑ‚Ð°Ð½Ð¾Ð²Ð¸Ñ‚ÑŒ 10 ÑÑ‚Ñ€Ð¾Ðº Ð² Ñ‡Ð°Ñ‚Ðµ
    Gui, HotkeysGui:Add, Progress, x25 y468 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Font, s11 Bold cWhite, Segoe UI
    Gui, HotkeysGui:Add, Button, gCloseHotkeys x175 y500 w150 h35, ðŸ”„ Ð—Ð°ÐºÑ€Ñ‹Ñ‚ÑŒ
    Gui, HotkeysGui:Show, w500 h570, Ð¡Ð¸ÑÑ‚ÐµÐ¼Ð½Ñ‹Ðµ ÐºÐ¾Ð¼Ð±Ð¸Ð½Ð°Ñ†Ð¸Ð¸
    Gui, Main:+Disabled
    WinActivate, ahk_id %HotkeysGuiHwnd%
}
DragHotkeys:
    PostMessage, 0xA1, 2,,, A
return
CloseHotkeys:
    Gui, HotkeysGui:Destroy
    Gui, Main:-Disabled
    WinActivate, ahk_id %MainGuiHwnd%
return

GenderChanged:
    GuiControlGet, GenderRadioMale, Main:
    GuiControlGet, GenderRadioFemale, Main:
    if (GenderRadioMale)
        Gender := 1
    else
        Gender := 2
    IniWrite, %Gender%, %BindIni%, Settings, Gender
    UpdatePreviewFunc()
    SoundPlay, *-1
return
CityChanged:
    GuiControlGet, CityList, Main:
   if (CityList = "ðŸ›ŽÐ›Ð°Ñ-Ð’ÐµÐ½Ñ‚ÑƒÑ€Ð°Ñ")
    CityCode := "LV"
else if (CityList = "ðŸ›ŽÐ¡Ð°Ð½-Ð¤Ð¸ÐµÑ€Ñ€Ð¾")
    CityCode := "SF"
else if (CityList = "ðŸ›ŽÐ›Ð¾Ñ-Ð¡Ð°Ð½Ñ‚Ð¾Ñ")
    CityCode := "LS"
    UpdateCityName()
    IniWrite, %CityCode%, %BindIni%, Settings, City
return

; ====================================================================================================
; ÐžÐ‘Ð ÐÐ‘ÐžÐ¢Ð§Ð˜ÐšÐ˜ GUI
; ====================================================================================================
ToggleAutoRoulette:
    GuiControlGet, AutoRouletteCheck, Main:
    AutoRouletteActive := AutoRouletteCheck
    IniWrite, %AutoRouletteActive%, %BindIni%, Settings, AutoRoulette
    UpdateStatusAndTime()
    SoundPlay, *-1
return
ToggleAutoTime:
    GuiControlGet, AutoTimeCheck, Main:
    AutoTimeActive := AutoTimeCheck
    IniWrite, %AutoTimeActive%, %BindIni%, Settings, AutoTime
    if (AutoTimeActive)
        StartAutoTime()
    else
        StopAutoTime()
    UpdateStatusAndTime()
    SoundPlay, *-1
return
ShowPrizeHistory:
    ShowPrizeHistory()
return
ShowSmsHistory:
    ShowSmsHistory()
return

ReloadScriptFromGui:
    SoundPlay, *-1
    SaveAllSettings()
    Reload
return

ShowInstructions:
    Gui, InstructionsGui:Destroy
    Gui, InstructionsGui:New, +ToolWindow -Caption +LastFound +Owner%MainGuiHwnd%
    InstructionsGuiHwnd := WinExist()
    Gui, InstructionsGui:Color, 1A1A1A
    Gui, InstructionsGui:Font, s18 Bold, Segoe UI
    Gui, InstructionsGui:Add, Text, x0 y15 w700 Center gStartInstrDrag cFFD700, ðŸ“– Ð˜Ð½ÑÑ‚Ñ€ÑƒÐºÑ†Ð¸Ñ Ð¿Ð¾ Ð±Ð¸Ð½Ð´ÐµÑ€Ð°Ð¼
    Gui, InstructionsGui:Font, s10, Segoe UI
    Gui, InstructionsGui:Add, Text, x0 y50 w700 Center cWhite, â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    Gui, InstructionsGui:Font, s11 cFFD700, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y90, â–¸ Ð§Ñ‚Ð¾ Ñ‚Ð°ÐºÐ¾Ðµ Ð±Ð¸Ð½Ð´ÐµÑ€?
    Gui, InstructionsGui:Font, s10 cWhite, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y115, Ð‘Ð¸Ð½Ð´ÐµÑ€ - ÑÑ‚Ð¾ Ð¸Ð½ÑÑ‚Ñ€ÑƒÐ¼ÐµÐ½Ñ‚ Ð´Ð»Ñ Ð°Ð²Ñ‚Ð¾Ð¼Ð°Ñ‚Ð¸Ñ‡ÐµÑÐºÐ¾Ð¹ Ð¾Ñ‚Ð¿Ñ€Ð°Ð²ÐºÐ¸ ÐºÐ¾Ð¼Ð°Ð½Ð´ Ð² Ñ‡Ð°Ñ‚.
    Gui, InstructionsGui:Add, Text, x25 y140, Ð’Ñ‹ Ð½Ð°Ð¶Ð¸Ð¼Ð°ÐµÑ‚Ðµ Ð½Ð°Ð·Ð½Ð°Ñ‡ÐµÐ½Ð½ÑƒÑŽ ÐºÐ»Ð°Ð²Ð¸ÑˆÑƒ - Ð±Ð¾Ñ‚ Ð¾Ñ‚Ð¿Ñ€Ð°Ð²Ð»ÑÐµÑ‚ Ð·Ð°Ñ€Ð°Ð½ÐµÐµ Ð·Ð°Ð´Ð°Ð½Ð½ÑƒÑŽ ÐºÐ¾Ð¼Ð°Ð½Ð´Ñƒ.
    Gui, InstructionsGui:Font, s11 cFFD700, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y180, â–¸ ÐšÐ°Ðº Ð½Ð°ÑÑ‚Ñ€Ð¾Ð¸Ñ‚ÑŒ?
    Gui, InstructionsGui:Font, s10 cWhite, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y205, 1. ÐžÑ‚ÐºÑ€Ð¾Ð¹Ñ‚Ðµ Ð¼ÐµÐ½ÑŽ Ð‘Ð¸Ð½Ð´ÐµÑ€Ñ‹ (Ctrl+Alt+B)
    Gui, InstructionsGui:Add, Text, x25 y230, 2. Ð’Ñ‹Ð±ÐµÑ€Ð¸Ñ‚Ðµ Ð½ÑƒÐ¶Ð½ÑƒÑŽ ÑÑ‚Ñ€Ð¾ÐºÑƒ (â„–1-10 Ð½Ð° ÑÑ‚Ñ€Ð°Ð½Ð¸Ñ†Ðµ)
    Gui, InstructionsGui:Add, Text, x25 y255, 3. Ð’Ð²ÐµÐ´Ð¸Ñ‚Ðµ Ð½Ð°Ð·Ð²Ð°Ð½Ð¸Ðµ Ð±Ð¸Ð½Ð´ÐµÑ€Ð° (Ð½Ð°Ð¿Ñ€Ð¸Ð¼ÐµÑ€, "Ð”Ð¾ÐºÑƒÐ¼ÐµÐ½Ñ‚Ñ‹")
    Gui, InstructionsGui:Add, Text, x25 y280, 4. Ð’ Ð±Ð¾Ð»ÑŒÑˆÐ¾Ðµ Ð¿Ð¾Ð»Ðµ Ð²Ð²ÐµÐ´Ð¸Ñ‚Ðµ ÐºÐ¾Ð¼Ð°Ð½Ð´Ñ‹ (Ð¿Ð¾ Ð¾Ð´Ð½Ð¾Ð¹ Ð½Ð° ÑÑ‚Ñ€Ð¾ÐºÑƒ)
    Gui, InstructionsGui:Add, Text, x25 y305, 5. Ð§Ñ‚Ð¾Ð±Ñ‹ Ð´Ð¾Ð±Ð°Ð²Ð¸Ñ‚ÑŒ Ð·Ð°Ð´ÐµÑ€Ð¶ÐºÑƒ, Ð½Ð°Ð¿Ð¸ÑˆÐ¸Ñ‚Ðµ: time 2000 (Ð¶Ð´Ñ‘Ñ‚ 2 ÑÐµÐº)
    Gui, InstructionsGui:Add, Text, x25 y330, 6. ÐÐ°Ð¶Ð¼Ð¸Ñ‚Ðµ Ð½Ð° ÐºÐ½Ð¾Ð¿ÐºÑƒ Ñ ÐºÐ»Ð°Ð²Ð¸Ð°Ñ‚ÑƒÑ€Ð¾Ð¹ Ð¸ Ð½Ð°Ð¶Ð¼Ð¸Ñ‚Ðµ Ð½ÑƒÐ¶Ð½ÑƒÑŽ ÐºÐ»Ð°Ð²Ð¸ÑˆÑƒ
    Gui, InstructionsGui:Add, Text, x25 y355, 7. ÐŸÐ¾ÑÑ‚Ð°Ð²ÑŒÑ‚Ðµ Ð³Ð°Ð»Ð¾Ñ‡ÐºÑƒ "ÐÐºÑ‚Ð¸Ð²ÐµÐ½" Ð¸ Ð½Ð°Ð¶Ð¼Ð¸Ñ‚Ðµ "Ð¡Ð¾Ñ…Ñ€Ð°Ð½Ð¸Ñ‚ÑŒ"
    Gui, InstructionsGui:Font, s11 cFFD700, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y395, â–¸ ÐŸÑ€Ð¸Ð¼ÐµÑ€ Ð½Ð°ÑÑ‚Ñ€Ð¾Ð¹ÐºÐ¸:
    Gui, InstructionsGui:Font, s10 cWhite, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y420, ÐÐ°Ð·Ð²Ð°Ð½Ð¸Ðµ: "ÐŸÐ¾ÐºÐ°Ð·Ð°Ñ‚ÑŒ ÑƒÐ´Ð¾ÑÑ‚Ð¾Ð²ÐµÑ€ÐµÐ½Ð¸Ðµ"
    Gui, InstructionsGui:Add, Text, x25 y440, /me Ð´Ð¾ÑÑ‚Ð°Ð» ÑƒÐ´Ð¾ÑÑ‚Ð¾Ð²ÐµÑ€ÐµÐ½Ð¸Ðµ
    Gui, InstructionsGui:Add, Text, x25 y460, time 1000
    Gui, InstructionsGui:Add, Text, x25 y480, /do Ð”Ð¾ÐºÑƒÐ¼ÐµÐ½Ñ‚Ñ‹ ÐœÐ’Ð”
    Gui, InstructionsGui:Font, s11 cFFD700, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y520, â–¸ ÐŸÑ€Ð¸Ð¼ÐµÑ‡Ð°Ð½Ð¸Ñ:
    Gui, InstructionsGui:Font, s10 cWhite, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y545, â€¢ ÐÐµÐ»ÑŒÐ·Ñ Ð¸ÑÐ¿Ð¾Ð»ÑŒÐ·Ð¾Ð²Ð°Ñ‚ÑŒ Ctrl+Alt+M (Ð¾Ñ‚ÐºÑ€Ñ‹Ñ‚Ð¸Ðµ Ð¼ÐµÐ½ÑŽ)
    Gui, InstructionsGui:Add, Text, x25 y570, â€¢ Ð’ÑÐµÐ³Ð¾ Ð´Ð¾ÑÑ‚ÑƒÐ¿Ð½Ð¾ 20 Ð±Ð¸Ð½Ð´ÐµÑ€Ð¾Ð² (2 ÑÑ‚Ñ€Ð°Ð½Ð¸Ñ†Ñ‹ Ð¿Ð¾ 10)
    Gui, InstructionsGui:Add, Text, x25 y595, â€¢ Ð—Ð°Ð´ÐµÑ€Ð¶ÐºÐ° ÑƒÐºÐ°Ð·Ñ‹Ð²Ð°ÐµÑ‚ÑÑ Ð² Ð¼Ð¸Ð»Ð»Ð¸ÑÐµÐºÑƒÐ½Ð´Ð°Ñ… (1000 = 1 ÑÐµÐºÑƒÐ½Ð´Ð°)
    Gui, InstructionsGui:Font, s11 Bold cWhite, Segoe UI
    ; ÐšÐ½Ð¾Ð¿ÐºÐ¸ Ñ€Ð°ÑÐ¿Ð¾Ð»Ð¾Ð¶ÐµÐ½Ñ‹ Ð¿Ð¾ Ñ†ÐµÐ½Ñ‚Ñ€Ñƒ, Ð½Ð° Ð¾Ð´Ð¸Ð½Ð°ÐºÐ¾Ð²Ð¾Ð¼ Ñ€Ð°ÑÑÑ‚Ð¾ÑÐ½Ð¸Ð¸
    Gui, InstructionsGui:Add, Button, gShowLicensesOrder x180 y650 w160 h40, ðŸ“œ ÐŸÐ¾Ð¾Ñ‡ÐµÑ€Ñ‘Ð´Ð½Ð¾ÑÑ‚ÑŒ
    Gui, InstructionsGui:Add, Button, gCloseInstructions x380 y650 w160 h40, ðŸ”„ Ð—Ð°ÐºÑ€Ñ‹Ñ‚ÑŒ
    Gui, InstructionsGui:Show, w700 h730, Ð˜Ð½ÑÑ‚Ñ€ÑƒÐºÑ†Ð¸Ñ
    Gui, Main:+Disabled
    WinActivate, ahk_id %InstructionsGuiHwnd%
return

StartInstrDrag:
    PostMessage, 0xA1, 2,,, A
return
CloseInstructions:
    Gui, InstructionsGui:Destroy
    Gui, Main:-Disabled
    WinActivate, ahk_id %MainGuiHwnd%
return
UpdateStatusTimer:
    UpdateStatusAndTime()
return

; ====================================================================================================
; Ð¢ÐÐ™ÐœÐ•Ð Ð« GUI
; ====================================================================================================
ShowTimerManager() {
    global
    if (TimerGuiHwnd && WinExist("ahk_id " TimerGuiHwnd)) {
        Gui, TimerGui:Show, NoActivate
        AnimateWindowShow(TimerGuiHwnd)
        WinActivate, ahk_id %TimerGuiHwnd%
        return
    }
    Gui, TimerGui:New, +ToolWindow -Caption +LastFound
    TimerGuiHwnd := WinExist()
    Gui, TimerGui:Color, 1A1A1A
    Gui, TimerGui:Font, s18 Bold, Segoe UI
    Gui, TimerGui:Add, Text, vTimerDragArea x25 y15 gStartTimerDrag cFFD700, â° Ð£Ð¿Ñ€Ð°Ð²Ð»ÐµÐ½Ð¸Ðµ Ñ‚Ð°Ð¹Ð¼ÐµÑ€Ð°Ð¼Ð¸
    Gui, TimerGui:Font, s10, Segoe UI
    Gui, TimerGui:Add, Text, x25 y50 cWhite, â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    Gui, TimerGui:Font, s11 Bold, Segoe UI
    Gui, TimerGui:Add, ListView, vTimerListView x25 y70 w450 h250 cFFD700 Background2D2D2D AltSubmit gTimerListClick, â„–|ÐšÐ¾Ð¼Ð°Ð½Ð´Ð°|Ð˜Ð½Ñ‚ÐµÑ€Ð²Ð°Ð» (ÑÐµÐº)|Ð¡Ñ‚Ð°Ñ‚ÑƒÑ
    IniRead, Col1, %BindIni%, TimerListView, Col1, 40
    IniRead, Col2, %BindIni%, TimerListView, Col2, 180
    IniRead, Col3, %BindIni%, TimerListView, Col3, 100
    IniRead, Col4, %BindIni%, TimerListView, Col4, 120
    LV_ModifyCol(1, Col1)
    LV_ModifyCol(2, Col2)
    LV_ModifyCol(3, Col3)
    LV_ModifyCol(4, Col4)
    Gui, TimerGui:Font, s10 Bold cFFD700, Segoe UI
    Gui, TimerGui:Add, Text, x25 y340, âž• Ð”Ð¾Ð±Ð°Ð²Ð¸Ñ‚ÑŒ Ð½Ð¾Ð²Ñ‹Ð¹ Ñ‚Ð°Ð¹Ð¼ÐµÑ€:
    Gui, TimerGui:Font, s11 cWhite, Segoe UI
    Gui, TimerGui:Add, Text, x25 y370, ÐšÐ¾Ð¼Ð°Ð½Ð´Ð°:
    Gui, TimerGui:Add, Edit, vNewCommand x25 y395 w250 h35 cFFD700 Background000000, /time
    Gui, TimerGui:Add, Text, x290 y370, Ð¡ÐµÐºÑƒÐ½Ð´Ñ‹:
    Gui, TimerGui:Add, Edit, vNewSeconds x290 y395 w100 h35 cFFD700 Background000000, 30
    GuiControlGet, hTimerCmd, TimerGui:Hwnd, NewCommand
    GuiControlGet, hTimerSec, TimerGui:Hwnd, NewSeconds
    CtlColors.Attach(hTimerCmd, "2D2D2D", "FFD700")
    CtlColors.Attach(hTimerSec, "2D2D2D", "FFD700")
    Gui, TimerGui:Font, s11 Bold cWhite, Segoe UI
    Gui, TimerGui:Add, Button, gAddNewTimer x400 y395 w75 h35, âœ… Ð”Ð¾Ð±Ð°Ð²Ð¸Ñ‚ÑŒ
    Gui, TimerGui:Add, Button, gStartSelectedTimer x25 y460 w140 h40, â–¶ Ð—Ð°Ð¿ÑƒÑÑ‚Ð¸Ñ‚ÑŒ
    Gui, TimerGui:Add, Button, gStopSelectedTimer x175 y460 w140 h40, â¸ ÐžÑÑ‚Ð°Ð½Ð¾Ð²Ð¸Ñ‚ÑŒ
    Gui, TimerGui:Add, Button, gRemoveSelectedTimer x325 y460 w140 h40, âŒ Ð£Ð´Ð°Ð»Ð¸Ñ‚ÑŒ
    Gui, TimerGui:Add, Button, gStartAllTimersBtn x25 y515 w220 h40, ðŸŸ¢ Ð—Ð°Ð¿ÑƒÑÑ‚Ð¸Ñ‚ÑŒ Ð²ÑÐµ
    Gui, TimerGui:Add, Button, gStopAllTimersBtn x255 y515 w220 h40, ðŸ”´ ÐžÑÑ‚Ð°Ð½Ð¾Ð²Ð¸Ñ‚ÑŒ Ð²ÑÐµ
    Gui, TimerGui:Add, Button, gCloseTimerManager x25 y570 w220 h40, ðŸ”„ ÐÐ°Ð·Ð°Ð´ Ðº Ð½Ð°ÑÑ‚Ñ€Ð¾Ð¹ÐºÐ°Ð¼
    Gui, TimerGui:Add, Button, gSaveTimersAndRestart x255 y570 w220 h40, ðŸ’¾ Ð¡Ð¾Ñ…Ñ€Ð°Ð½Ð¸Ñ‚ÑŒ Ð¸ Ð·Ð°Ð¿ÑƒÑÑ‚Ð¸Ñ‚ÑŒ
    Gosub, RefreshTimerList
    Gui, TimerGui:Show, Hide
    AnimateWindowShow(TimerGuiHwnd)
    Gui, Main:Hide
}
OpenTimerManager:
    ShowTimerManager()
return
TimerListClick:
    Gui, TimerGui:Default
    SelectedTimerRow := LV_GetNext()
return
StartTimerDrag:
    PostMessage, 0xA1, 2,,, A
return
AddNewTimer:
    Gui, TimerGui:Submit, NoHide
    if (NewCommand != "" && NewSeconds > 0) {
        CurrentTimers.Push({"command": NewCommand, "seconds": NewSeconds, "running": 0})
        SaveTimers()
        Gosub, RefreshTimerList
        GuiControl, TimerGui:, NewCommand, /time
        GuiControl, TimerGui:, NewSeconds, 30
        SoundPlay, *-1
    } else
        SoundPlay, *-1
return
RefreshTimerList:
    Gui, TimerGui:Default
    LV_Delete()
    For index, timer in CurrentTimers {
        status := timer.running ? "âœ… ÐÐºÑ‚Ð¸Ð²ÐµÐ½" : "â¸ ÐžÑÑ‚Ð°Ð½Ð¾Ð²Ð»ÐµÐ½"
        LV_Add("", index, timer.command, timer.seconds, status)
    }
return
StartSelectedTimer:
    Gui, TimerGui:Default
    SelectedTimerRow := LV_GetNext()
    if (SelectedTimerRow > 0) {
        LV_GetText(id, SelectedTimerRow, 1)
        if (StartTimerById(id))
            Gosub, RefreshTimerList
        SoundPlay, *-1
    } else
        SoundPlay, *-1
return
StopSelectedTimer:
    Gui, TimerGui:Default
    SelectedTimerRow := LV_GetNext()
    if (SelectedTimerRow > 0) {
        LV_GetText(id, SelectedTimerRow, 1)
        if (StopTimerById(id))
            Gosub, RefreshTimerList
        SoundPlay, *-1
    } else
        SoundPlay, *-1
return
RemoveSelectedTimer:
    Gui, TimerGui:Default
    SelectedTimerRow := LV_GetNext()
    if (SelectedTimerRow > 0) {
        LV_GetText(id, SelectedTimerRow, 1)
        StopTimerById(id)
        CurrentTimers.RemoveAt(id)
        newTimers := []
        For index, timer in CurrentTimers
            newTimers.Push({"command": timer.command, "seconds": timer.seconds, "running": timer.running})
        CurrentTimers := newTimers
        SaveTimers()
        Gosub, RefreshTimerList
        SoundPlay, *-1
    } else
        SoundPlay, *-1
return
StartAllTimersBtn:
    StartAllTimers()
    Gosub, RefreshTimerList
    SoundPlay, *-1
return
StopAllTimersBtn:
    StopAllTimers()
    for index, timer in CurrentTimers
        CurrentTimers[index].running := 0
    SaveTimers()
    Gosub, RefreshTimerList
    SoundPlay, *-1
return
SaveTimersAndRestart:
    SaveTimers()
    StartAllTimers()
    Gosub, RefreshTimerList
    SoundPlay, *-1
return
CloseTimerManager:
    SaveTimerListColumns()
    AnimateWindowHide(TimerGuiHwnd)
    ShowMainGui()
return
SaveTimerListColumns() {
    global BindIni, TimerGuiHwnd
    Gui, TimerGui:Default
    ControlGet, hLV, Hwnd, , TimerListView, ahk_id %TimerGuiHwnd%
    if !hLV
        return
    Loop, 4 {
        SendMessage, 0x101D, A_Index-1, 0, , ahk_id %hLV%
        width := ErrorLevel ? ErrorLevel : 60
        IniWrite, %width%, %BindIni%, TimerListView, Col%A_Index%
    }
}

; ====================================================================================================
; Ð‘Ð˜ÐÐ”Ð•Ð Ð« GUI
; ====================================================================================================
ShowBinderManager() {
    global
    if (BinderGuiHwnd && WinExist("ahk_id " BinderGuiHwnd)) {
        Gui, BinderGui:Show, NoActivate
        AnimateWindowShow(BinderGuiHwnd)
        WinActivate, ahk_id %BinderGuiHwnd%
        return
    }
    Gui, BinderGui:New, +ToolWindow -Caption +LastFound
    BinderGuiHwnd := WinExist()
    Gui, BinderGui:Color, 1A1A1A
    Gui, BinderGui:Font, s18 Bold, Segoe UI
    Gui, BinderGui:Add, Text, vBinderDragArea x25 y15 gStartBinderDrag cFFD700, ðŸ”— Ð£Ð¿Ñ€Ð°Ð²Ð»ÐµÐ½Ð¸Ðµ Ð±Ð¸Ð½Ð´ÐµÑ€Ð°Ð¼Ð¸
    Gui, BinderGui:Font, s10, Segoe UI
    Gui, BinderGui:Add, Text, x25 y50 cWhite, â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    Gui, BinderGui:Font, s11 Bold, Segoe UI
    Gui, BinderGui:Add, ListView, vBinderListView x25 y70 w590 h250 cFFD700 Background2D2D2D AltSubmit gBinderListClick, â„–|Ð¡Ñ‚Ð°Ñ‚ÑƒÑ|ÐšÐ»Ð°Ð²Ð¸ÑˆÐ°|ÐÐ°Ð·Ð²Ð°Ð½Ð¸Ðµ
    IniRead, BCol1, %BindIni%, BinderListView, Col1, 35
    IniRead, BCol2, %BindIni%, BinderListView, Col2, 45
    IniRead, BCol3, %BindIni%, BinderListView, Col3, 100
    IniRead, BCol4, %BindIni%, BinderListView, Col4, 380
    LV_ModifyCol(1, BCol1)
    LV_ModifyCol(2, BCol2)
    LV_ModifyCol(3, BCol3)
    LV_ModifyCol(4, BCol4)
    Gui, BinderGui:Font, s9 cWhite, Segoe UI
    Gui, BinderGui:Font, s10 Bold cFFD700, Segoe UI
    Gui, BinderGui:Add, Text, x25 y340, âœï¸ Ð ÐµÐ´Ð°ÐºÑ‚Ð¸Ñ€Ð¾Ð²Ð°Ð½Ð¸Ðµ Ð²Ñ‹Ð±Ñ€Ð°Ð½Ð½Ð¾Ð³Ð¾ Ð±Ð¸Ð½Ð´ÐµÑ€Ð°:
    Gui, BinderGui:Font, s11 cWhite, Segoe UI
    Gui, BinderGui:Add, Text, x25 y365, ÐÐ°Ð·Ð²Ð°Ð½Ð¸Ðµ Ð±Ð¸Ð½Ð´ÐµÑ€Ð° (Ð¾Ñ‚Ð¾Ð±Ñ€Ð°Ð¶Ð°ÐµÑ‚ÑÑ Ð² ÑÐ¿Ð¸ÑÐºÐµ, Ð¼Ð°ÐºÑÐ¸Ð¼ÑƒÐ¼ 8 ÑÐ¸Ð¼Ð²Ð¾Ð»Ð¾Ð²):
    Gui, BinderGui:Add, Edit, vEditBinderName x25 y385 w590 h30 Center cFFD700 Background000000 -E0x200 Limit8,
    Gui, BinderGui:Add, Text, x25 y425, ÐšÐ¾Ð¼Ð°Ð½Ð´Ñ‹ (time 2000 = Ð·Ð°Ð´ÐµÑ€Ð¶ÐºÐ° 2 ÑÐµÐº):
    Gui, BinderGui:Add, Edit, vEditBinderText x25 y445 w590 h80 cFFD700 Background000000 -E0x200,
    GuiControlGet, hEditName, BinderGui:Hwnd, EditBinderName
    GuiControlGet, hEditText, BinderGui:Hwnd, EditBinderText
    CtlColors.Attach(hEditName, "2D2D2D", "FFD700")
    CtlColors.Attach(hEditText, "2D2D2D", "FFD700")
    Gui, BinderGui:Font, s11 cWhite, Segoe UI
    Gui, BinderGui:Add, Text, x170 y540, ÐšÐ»Ð°Ð²Ð¸ÑˆÐ° (Ð½Ð°Ð¶Ð¼Ð¸Ñ‚Ðµ Ð½Ð° ÐºÐ½Ð¾Ð¿ÐºÑƒ Ð¸ Ð½Ð°Ð¶Ð¼Ð¸Ñ‚Ðµ ÐºÐ»Ð°Ð²Ð¸ÑˆÑƒ):
    Gui, BinderGui:Add, Edit, vEditBinderKeyReadOnly x250 y565 w150 h35 cFFD700 Background000000 ReadOnly Center,
    Gui, BinderGui:Add, Button, vCaptureKeyBtn gStartKeyCapture x410 y565 w35 h35, âŒ¨ï¸
    Gui, BinderGui:Add, Checkbox, vCheckboxActive x470 y565 w100 h35 cFFD700, ÐÐºÑ‚Ð¸Ð²ÐµÐ½
    Gui, BinderGui:Font, s11 Bold cWhite, Segoe UI
    Gui, BinderGui:Add, Button, gSaveCurrentBinder x25 y620 w140 h35, ðŸ’¾ Ð¡Ð¾Ñ…Ñ€Ð°Ð½Ð¸Ñ‚ÑŒ
    Gui, BinderGui:Add, Button, gClearCurrentBinder x180 y620 w140 h35, ðŸ—‘ï¸ ÐžÑ‡Ð¸ÑÑ‚Ð¸Ñ‚ÑŒ
    Gui, BinderGui:Add, Button, gPrevBinderPage x335 y620 w70 h35, â—€
    Gui, BinderGui:Add, Text, vPageInfo x410 y628 w80 h25 Center cFFD700, Ð¡Ñ‚Ñ€Ð°Ð½Ð¸Ñ†Ð° 1/2
    Gui, BinderGui:Add, Button, gNextBinderPage x495 y620 w70 h35, â–¶
    Gui, BinderGui:Add, Button, gCloseBinderManager x580 y620 w35 h35, âœ•
    Gui, BinderGui:Add, Button, gSaveAllBinders x25 y660 w620 h30, ðŸ’¾ Ð¡Ð¾Ñ…Ñ€Ð°Ð½Ð¸Ñ‚ÑŒ Ð²ÑÐµ Ð¸Ð·Ð¼ÐµÐ½ÐµÐ½Ð¸Ñ
    Gosub, RefreshBinderListSub
    SelectedBinderRow := 0
    Gui, BinderGui:Show, Hide
    AnimateWindowShow(BinderGuiHwnd)
    Gui, Main:Hide
}
OpenBinderManager:
    ShowBinderManager()
return
StartKeyCapture:
    WaitingForKey := 1
    TempKeyBind := ""
    GuiControl, BinderGui:, EditBinderKeyReadOnly, [ÐžÐ¶Ð¸Ð´Ð°Ð½Ð¸Ðµ Ð½Ð°Ð¶Ð°Ñ‚Ð¸Ñ...]
return
#If (WaitingForKey = 1)
~*LButton:: return
~*RButton:: return
~*MButton:: return
~*a:: return
~*b:: return
~*c:: return
~*d:: return
~*e:: return
~*f:: return
~*g:: return
~*h:: return
~*i:: return
~*j:: return
~*k:: return
~*l:: return
~*m:: return
~*n:: return
~*o:: return
~*p:: return
~*q:: return
~*r:: return
~*s:: return
~*t:: return
~*u:: return
~*v:: return
~*w:: return
~*x:: return
~*y:: return
~*z:: return
~*0:: return
~*1:: return
~*2:: return
~*3:: return
~*4:: return
~*5:: return
~*6:: return
~*7:: return
~*8:: return
~*9:: return
~*F1:: return
~*F2:: return
~*F3:: return
~*F4:: return
~*F5:: return
~*F6:: return
~*F7:: return
~*F8:: return
~*F9:: return
~*F10:: return
~*F11:: return
~*F12:: return
~*Space:: return
~*Enter:: return
~*Tab:: return
~*Delete:: return
~*Insert:: return
~*Home:: return
~*End:: return
~*PgUp:: return
~*PgDn:: return
~*Up:: return
~*Down:: return
~*Left:: return
~*Right:: return
~*Numpad0:: return
~*Numpad1:: return
~*Numpad2:: return
~*Numpad3:: return
~*Numpad4:: return
~*Numpad5:: return
~*Numpad6:: return
~*Numpad7:: return
~*Numpad8:: return
~*Numpad9:: return
~*NumpadDiv:: return
~*NumpadMult:: return
~*NumpadAdd:: return
~*NumpadSub:: return
~*NumpadEnter:: return
~*NumpadDot:: return
#If
RefreshBinderListSub:
    Gosub, RefreshBinderList
return
StartBinderDrag:
    PostMessage, 0xA1, 2,,, A
return
BinderListClick:
    Gui, BinderGui:Default
    SelectedBinderRow := LV_GetNext()
    if (SelectedBinderRow > 0)
        Gosub, UpdateBinderEditFieldsSub
return
UpdateBinderEditFieldsSub:
    Gui, BinderGui:Default
    if (SelectedBinderRow >= 1 && SelectedBinderRow <= 10) {
        idx := (CurrentPage - 1) * 10 + SelectedBinderRow
        if (idx <= Binders.Length()) {
            binder := Binders[idx]
            GuiControl, BinderGui:, EditBinderName, % binder.name
            GuiControl, BinderGui:, EditBinderText, % binder.text
            displayKey := binder.key
            if (displayKey != "") {
                tempDisplay := ""
                if InStr(displayKey, "^")
                    tempDisplay .= "Ctrl+"
                if InStr(displayKey, "!")
                    tempDisplay .= "Alt+"
                if InStr(displayKey, "+")
                    tempDisplay .= "Shift+"
                keyPart := StrReplace(StrReplace(StrReplace(displayKey, "^", ""), "!", ""), "+", "")
                if (keyPart = "Space")
                    keyPart := "ÐŸÑ€Ð¾Ð±ÐµÐ»"
                else if (keyPart = "Enter")
                    keyPart := "Enter"
                else if (keyPart = "Tab")
                    keyPart := "Tab"
                else if (keyPart = "Delete")
                    keyPart := "Delete"
                else if (keyPart = "Up")
                    keyPart := "â†‘"
                else if (keyPart = "Down")
                    keyPart := "â†“"
                else if (keyPart = "Left")
                    keyPart := "â†"
                else if (keyPart = "Right")
                    keyPart := "â†’"
                else if (RegExMatch(keyPart, "^F\d+$"))
                    keyPart := keyPart
                else if (StrLen(keyPart) = 1)
                    StringUpper, keyPart, keyPart
                displayKey := tempDisplay . keyPart
            }
            GuiControl, BinderGui:, EditBinderKeyReadOnly, % displayKey
            GuiControl, BinderGui:, CheckboxActive, % binder.active
        }
    }
return
SaveCurrentBinder:
    Gui, BinderGui:Submit, NoHide
    if (SelectedBinderRow >= 1 && SelectedBinderRow <= 10) {
        idx := (CurrentPage - 1) * 10 + SelectedBinderRow
        if (idx <= Binders.Length()) {
            Binders[idx].name := EditBinderName
            Binders[idx].text := EditBinderText
            Binders[idx].key := TempKeyBind
            Binders[idx].active := CheckboxActive
            Binders[idx].processedText := ParseTextWithDelays(EditBinderText)
            SaveBinders()
            RegisterAllBinderHotkeys()
            Gosub, RefreshBinderListSub
            Gosub, UpdateStatusAndTimeSub
            SoundPlay, *-1
        }
    }
return
ClearCurrentBinder:
    if (SelectedBinderRow >= 1 && SelectedBinderRow <= 10) {
        idx := (CurrentPage - 1) * 10 + SelectedBinderRow
        if (idx <= Binders.Length()) {
            Binders[idx].name := ""
            Binders[idx].text := ""
            Binders[idx].key := ""
            Binders[idx].active := 0
            Binders[idx].processedText := ""
            SaveBinders()
            RegisterAllBinderHotkeys()
            Gosub, RefreshBinderListSub
            GuiControl, BinderGui:, EditBinderName,
            GuiControl, BinderGui:, EditBinderText,
            GuiControl, BinderGui:, EditBinderKeyReadOnly,
            GuiControl, BinderGui:, CheckboxActive, 0
            Gosub, UpdateStatusAndTimeSub
            SoundPlay, *-1
        }
    }
return
PrevBinderPage:
    if (CurrentPage > 1) {
        CurrentPage--
        SelectedBinderRow := 0
        Gosub, RefreshBinderListSub
        GuiControl, BinderGui:, EditBinderName,
        GuiControl, BinderGui:, EditBinderText,
        GuiControl, BinderGui:, EditBinderKeyReadOnly,
        GuiControl, BinderGui:, CheckboxActive, 0
        TempKeyBind := ""
        SoundPlay, *-1
    }
return
NextBinderPage:
    if (CurrentPage < BinderPages) {
        CurrentPage++
        SelectedBinderRow := 0
        Gosub, RefreshBinderListSub
        GuiControl, BinderGui:, EditBinderName,
        GuiControl, BinderGui:, EditBinderText,
        GuiControl, BinderGui:, EditBinderKeyReadOnly,
        GuiControl, BinderGui:, CheckboxActive, 0
        TempKeyBind := ""
        SoundPlay, *-1
    }
return
SaveAllBinders:
    SaveBinders()
    RegisterAllBinderHotkeys()
    Gosub, UpdateStatusAndTimeSub
    SoundPlay, *-1
return
UpdateStatusAndTimeSub:
    UpdateStatusAndTime()
return
CloseBinderManager:
    SaveBinderListColumns()
    AnimateWindowHide(BinderGuiHwnd)
    ShowMainGui()
return
SaveBinderListColumns() {
    global BindIni, BinderGuiHwnd
    Gui, BinderGui:Default
    ControlGet, hLV, Hwnd, , BinderListView, ahk_id %BinderGuiHwnd%
    if !hLV
        return
    Loop, 4 {
        SendMessage, 0x101D, A_Index-1, 0, , ahk_id %hLV%
        width := ErrorLevel ? ErrorLevel : 60
        IniWrite, %width%, %BindIni%, BinderListView, Col%A_Index%
    }
}

; ====================================================================================================
; ÐžÐ‘Ð©Ð˜Ð• ÐŸÐžÐ”ÐŸÐ ÐžÐ“Ð ÐÐœÐœÐ«
; ====================================================================================================
UpdatePreview:
    UpdatePreviewFunc()
return

UpdateCityName() {
    global CityCode, CityName
    if (CityCode = "LV")
        CityName := "Ð›Ð°Ñ-Ð’ÐµÐ½Ñ‚ÑƒÑ€Ð°Ñ"
    else if (CityCode = "SF")
        CityName := "Ð¡Ð°Ð½-Ð¤Ð¸ÐµÑ€Ñ€Ð¾"
    else if (CityCode = "LS")
        CityName := "Ð›Ð¾Ñ-Ð¡Ð°Ð½Ñ‚Ð¾Ñ"
    else
        CityName := "Ð›Ð°Ñ-Ð’ÐµÐ½Ñ‚ÑƒÑ€Ð°Ñ"
}

ApplyTheme:
    ApplyThemeFunc()
return
StartDrag:
    PostMessage, 0xA1, 2,,, A
return
SaveSettings:
    Gui, Main:Submit, NoHide
    IniWrite, %NickEdit%, %BindIni%, Settings, Nick
    IniWrite, %AccNumberEdit%, %BindIni%, Settings, AccNumber
    IniWrite, % (GenderRadioMale ? 1 : 2), %BindIni%, Settings, Gender
    IniWrite, %AutoRouletteActive%, %BindIni%, Settings, AutoRoulette
    IniWrite, %AutoTimeActive%, %BindIni%, Settings, AutoTime
    IniWrite, %CityCode%, %BindIni%, Settings, City
    UserNick := NickEdit
    UserAccNumber := AccNumberEdit
    Gender := (GenderRadioMale ? 1 : 2)
    UpdatePreviewFunc()
    SoundPlay, *-1
return
CloseSettings:
    Gui, Main:Hide
return
RestoreFromTray:
    if (MainGuiHwnd && WinExist("ahk_id " MainGuiHwnd)) {
        Gui, Main:Show, NoActivate
        AnimateWindowShow(MainGuiHwnd)
        WinActivate, ahk_id %MainGuiHwnd%
    } else if (BinderGuiHwnd && WinExist("ahk_id " BinderGuiHwnd)) {
        Gui, BinderGui:Show, NoActivate
        AnimateWindowShow(BinderGuiHwnd)
        WinActivate, ahk_id %BinderGuiHwnd%
    } else {
        ShowMainGui()
    }
return

ExitScript:
    SaveAllSettings()
    ExitApp
return

SupportVK:
    Run, https://vk.com/im?sel=-238715705
return

ReloadScript:
    Reload
return

CheckUpdatesManual:
    CheckForUpdates(true)
return

ShowAbout:
    MsgBox, 4096, Ðž Ð¿Ñ€Ð¾Ð³Ñ€Ð°Ð¼Ð¼Ðµ,
    (
        ÐœÐ­Ð Ð˜Ð¯ HELPER v%ScriptVersion%

        ÐÐ²Ñ‚Ð¾Ñ€: Melanie Vanerlon
        GitHub: https://github.com/skisasa56-max/merya-helper

        ÐŸÑ€Ð¸ Ð·Ð°Ð¿ÑƒÑÐºÐµ Ð°Ð²Ñ‚Ð¾Ð¼Ð°Ñ‚Ð¸Ñ‡ÐµÑÐºÐ¸ Ð¿Ñ€Ð¾Ð²ÐµÑ€ÑÐµÑ‚ÑÑ Ð½Ð°Ð»Ð¸Ñ‡Ð¸Ðµ Ð¾Ð±Ð½Ð¾Ð²Ð»ÐµÐ½Ð¸Ð¹.
    )
return

MarkActivity() {
    global LastActivityTime, UserIsActive
    LastActivityTime := A_TickCount
    if (!UserIsActive) {
        UserIsActive := 1
        UpdateStatusAndTime()
    }
}

ExitApp:
    SaveAllSettings()
    ExitApp
return

RefreshBinderList:
    Gui, BinderGui:Default
    LV_Delete()
    startIdx := (CurrentPage - 1) * 10 + 1
    rowNum := 1
    Loop, 10 {
        idx := startIdx + A_Index - 1
        if (idx <= Binders.Length()) {
            binder := Binders[idx]
            status := binder.active ? "ðŸŸ¢" : "ðŸ”´"
            keyDisplay := binder.key
            if (keyDisplay != "") {
                tempDisplay := ""
                if InStr(keyDisplay, "^")
                    tempDisplay .= "Ctrl+"
                if InStr(keyDisplay, "!")
                    tempDisplay .= "Alt+"
                if InStr(keyDisplay, "+")
                    tempDisplay .= "Shift+"
                keyPart := StrReplace(StrReplace(StrReplace(keyDisplay, "^", ""), "!", ""), "+", "")
                if (keyPart = "Space")
                    keyPart := "ÐŸÑ€Ð¾Ð±ÐµÐ»"
                else if (keyPart = "Enter")
                    keyPart := "Enter"
                else if (keyPart = "Tab")
                    keyPart := "Tab"
                else if (keyPart = "Delete")
                    keyPart := "Delete"
                else if (keyPart = "Up")
                    keyPart := "â†‘"
                else if (keyPart = "Down")
                    keyPart := "â†“"
                else if (keyPart = "Left")
                    keyPart := "â†"
                else if (keyPart = "Right")
                    keyPart := "â†’"
                else if (RegExMatch(keyPart, "^F\d+$"))
                    keyPart := keyPart
                else if (StrLen(keyPart) = 1)
                    StringUpper, keyPart, keyPart
                keyDisplay := tempDisplay . keyPart
            } else
                keyDisplay := "â€”"
            displayName := binder.name
            if (displayName = "")
                displayName := SubStr(binder.text, 1, 27)
            if (displayName = "")
                displayName := "â€”"
            LV_Add("", rowNum, status, keyDisplay, displayName)
        } else
            LV_Add("", rowNum, "âšª", "â€”", "â€”")
        rowNum++
    }
return

; ====================================================================================================
; ÐšÐžÐÐ¢Ð•ÐšÐ¡Ð¢ÐÐ«Ð• Ð“ÐžÐ Ð¯Ð§Ð˜Ð• ÐšÐ›ÐÐ’Ð˜Ð¨Ð˜ Ð”Ð›Ð¯ ÐÐ”Ð’ÐžÐšÐÐ¢Ð¡ÐšÐžÐ“Ðž ÐœÐžÐ”Ð£Ð›Ð¯
; ====================================================================================================
#If WinActive("ahk_exe gta_sa.exe") && (LicenseMenuMode > 0)
$1::
$2::
$3::
$4::
$5::
$6::
$7::
    Idx := SubStr(A_ThisHotkey, 2, 1)
    Name := LicNames[Idx]
    Price := LicPrices[Idx]
    FormattedPrice := RegExReplace(Price, "\G\d+?(?=(\d{3})+(?!\d))", "$0.")
    if (LicenseMenuMode == 1) {
        SendChat("Ð¡Ñ‚Ð¾Ð¸Ð¼Ð¾ÑÑ‚ÑŒ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¸ Ð½Ð° " Name " - " FormattedPrice "$.")
        LicenseMenuMode := 0
    } else if (LicenseMenuMode == 2) {
        TempTotal += Price
        LastPrice := Price
        FormattedTotal := RegExReplace(TempTotal, "\G\d+?(?=(\d{3})+(?!\d))", "$0.")
        addChatMessage("{FF0000}[" Tag "] {00FF00}Ð”Ð¾Ð±Ð°Ð²Ð»ÐµÐ½Ð¾: {FFFFFF}" Name ". Ð˜Ñ‚Ð¾Ð³Ð¾: {FFFF00}" FormattedTotal "$")
    }
return
#If WinActive("ahk_exe gta_sa.exe")

#If WinActive("ahk_exe gta_sa.exe") && (LicenseMenuMode == 2)
$Delete::
    if (LastPrice > 0) {
        TempTotal -= LastPrice
        LastPrice := 0
        FormattedTotal := RegExReplace(TempTotal, "\G\d+?(?=(\d{3})+(?!\d))", "$0.")
        addChatMessage("{FF0000}[" Tag "] {FF4500}ÐŸÐ¾ÑÐ»ÐµÐ´Ð½ÐµÐµ Ð´ÐµÐ¹ÑÑ‚Ð²Ð¸Ðµ Ð¾Ñ‚Ð¼ÐµÐ½ÐµÐ½Ð¾. {FFFFFF}Ð¢ÐµÐºÑƒÑ‰Ð°Ñ ÑÑƒÐ¼Ð¼Ð°: {FFFF00}" FormattedTotal "$")
    }
return
$Backspace::
    if (TempTotal > 0) {
        FormattedTotal := RegExReplace(TempTotal, "\G\d+?(?=(\d{3})+(?!\d))", "$0.")
        SendChat("ÐžÐ±Ñ‰Ð°Ñ ÑÑ‚Ð¾Ð¸Ð¼Ð¾ÑÑ‚ÑŒ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹ ÑÐ¾ÑÑ‚Ð°Ð²Ð»ÑÐµÑ‚ " FormattedTotal "$. Ð’Ñ‹ ÑÐ¾Ð³Ð»Ð°ÑÐ½Ñ‹?")
    }
    LicenseMenuMode := 0
return
#If WinActive("ahk_exe gta_sa.exe")

#If WinActive("ahk_exe gta_sa.exe") && (LicenseProcess == 2)
$Backspace::
    LicenseProcess := 3
    addChatMessage("{FF0000}[" Tag "] {00FF00}ÐŸÑ€Ð¾Ð´Ð¾Ð»Ð¶Ð°ÐµÐ¼. {FFFFFF}ÐžÑ‚ÐºÑ€Ñ‹Ð²Ð°ÑŽ Ð¼ÐµÐ½ÑŽ...")
    SendChat("/Ð¸ " TargetID)
    Sleep 1000
    Loop, 10 {
        Send, {Up}
        Sleep, 50
    }
    Loop, 5 {
        Send, {Down}
        Sleep, 50
    }
    Send, {Enter}
    addChatMessage("{FF0000}[" Tag "] {FFFFFF}ÐŸÑ€Ð¾Ð´Ð°Ð¹ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¸ Ð¸ Ð½Ð°Ð¶Ð¼Ð¸ {FFFF00}Backspace{FFFFFF} Ð´Ð»Ñ Ñ„Ð¸Ð½Ð°Ð»Ð°.")
return
$Delete::
    LicenseProcess := 0
    addChatMessage("{FF0000}[" Tag "] {FF4500}ÐŸÑ€Ð¾Ð´Ð°Ð¶Ð° Ð¾Ñ‚Ð¼ÐµÐ½ÐµÐ½Ð°.")
return
#If WinActive("ahk_exe gta_sa.exe")

#If WinActive("ahk_exe gta_sa.exe") && (LicenseProcess == 3)
$Backspace::
    LicenseProcess := 0
    if (Gender == 1)
        SendChat("/me Ð·Ð°Ñ„Ð¸ÐºÑÐ¸Ñ€Ð¾Ð²Ð°Ð» Ñ„Ð°ÐºÑ‚ Ð¾Ð¿Ð»Ð°Ñ‚Ñ‹")
    else
        SendChat("/me Ð·Ð°Ñ„Ð¸ÐºÑÐ¸Ñ€Ð¾Ð²Ð°Ð»Ð° Ñ„Ð°ÐºÑ‚ Ð¾Ð¿Ð»Ð°Ñ‚Ñ‹")
    Sleep 1960
    SendChat("/todo Ð’ÑÐµÐ³Ð¾ Ð²Ð°Ð¼ Ð´Ð¾Ð±Ñ€Ð¾Ð³Ð¾*Ð²Ð½Ð¾ÑÑ Ð² ÑÐ»ÐµÐºÑ‚Ñ€Ð¾Ð½Ð½Ñ‹Ð¹ Ñ€ÐµÐµÑÑ‚Ñ€ Ð¿Ñ€Ð¸Ð¾Ð±Ñ€ÐµÑ‚Ñ‘Ð½Ð½Ñ‹Ðµ Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¸")
    Sleep 1960
    SendChat("*ÐŸÐ¾ÑÐ¼Ð¾Ñ‚Ñ€ÐµÑ‚ÑŒ ÑÐ¿Ð¸ÑÐ¾Ðº Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹ Ð¼Ð¾Ð¶Ð½Ð¾, Ð¿Ñ€Ð¾Ð¿Ð¸ÑÐ°Ð²: /Ð»Ð¸Ñ† ID")
    Sleep 60
    SendChat("/time")
return

#If WinActive("ahk_exe gta_sa.exe")

#If WinActive("ahk_exe gta_sa.exe") && SmsSent
~$1::
    SmsSent := false
    if (Gender == 1)
        SendChat("/me Ð·Ð°ÐºÑ€Ñ‹Ð» Ð´ÐµÐ»Ð¾ Ð¸ Ð²Ñ‹ÐºÐ»ÑŽÑ‡Ð¸Ð» ÐºÐ¾Ð¼Ð¿ÑŒÑŽÑ‚ÐµÑ€")
    else
        SendChat("/me Ð·Ð°ÐºÑ€Ñ‹Ð»Ð° Ð´ÐµÐ»Ð¾ Ð¸ Ð²Ñ‹ÐºÐ»ÑŽÑ‡Ð¸Ð»Ð° ÐºÐ¾Ð¼Ð¿ÑŒÑŽÑ‚ÐµÑ€")
    Sleep 50
    SendChat("/time")
return
~$0::
    SmsSent := false
    addChatMessage("{FF0000}[" Tag "] {FFFFFF}ÐžÑ‚Ð¼ÐµÐ½Ð°.")
return
#If WinActive("ahk_exe gta_sa.exe")

#If WinActive("ahk_exe gta_sa.exe") && (LawyerResult > 0)
$Backspace::
    if (LawyerResult == 1) {
        SendChat("Ð“Ñ€Ð°Ð¶Ð´Ð°Ð½Ð¸Ð½ " LawyerTargetName " ÑƒÑÐ¿ÐµÑˆÐ½Ð¾ Ð¾Ð¿Ñ€Ð°Ð²Ð´Ð°Ð½ Ð¸ Ð²Ñ‹Ð¿ÑƒÑ‰ÐµÐ½ Ð½Ð° ÑÐ²Ð¾Ð±Ð¾Ð´Ñƒ. Ð’ÑÐµÐ³Ð¾ Ñ…Ð¾Ñ€Ð¾ÑˆÐµÐ³Ð¾, Ð¾Ð±Ñ€Ð°Ñ‰Ð°Ð¹Ñ‚ÐµÑÑŒ ÐµÑ‰Ñ‘!")
    } else if (LawyerResult == 2) {
        SendChat("Ðš ÑÐ¾Ð¶Ð°Ð»ÐµÐ½Ð¸ÑŽ Ð³Ñ€Ð°Ð¶Ð´Ð°Ð½Ð¸Ð½ " LawyerTargetName " Ð½Ðµ Ð¿Ð¾Ð»ÑƒÑ‡Ð¸Ð»Ð¾ÑÑŒ Ð¾Ð¿Ñ€Ð°Ð²Ð´Ð°Ñ‚ÑŒ. Ð¡Ð¾Ð¶Ð°Ð»ÐµÑŽ.")
    }
    LawyerResult := 0
return
$Delete::
    LawyerResult := 0
    addChatMessage("{FF0000}[" Tag "] {FFFFFF}ÐžÑ‚Ð¼ÐµÐ½Ð° Ð¾Ñ‚Ð¿Ñ€Ð°Ð²ÐºÐ¸ Ð¸Ñ‚Ð¾Ð³Ð°.")
return
#If WinActive("ahk_exe gta_sa.exe")

; ====================================================================================================
; ÐÐ’Ð¢ÐžÐ—ÐÐŸÐ£Ð¡Ðš
; ====================================================================================================
LoadTimers()
LoadBinders()
LoadPrizeHistory()
StartAllTimers()
RegisterAllBinderHotkeys()
SetTimer, UpdateStatusTimer, 1000
SetTimer, CheckAutoProfile, 100
ShowMainGui()
; Ð¡Ð¾Ð¾Ð±Ñ‰ÐµÐ½Ð¸Ðµ Ð¾ Ð·Ð°Ð¿ÑƒÑÐºÐµ, ÐµÑÐ»Ð¸ Ð¸Ð³Ñ€Ð° Ð°ÐºÑ‚Ð¸Ð²Ð½Ð°
if WinActive("ahk_exe gta_sa.exe")
    addChatMessage("{00FF00}[" Tag "] Ð‘Ð¸Ð½Ð´ÐµÑ€ Ð·Ð°Ð¿ÑƒÑ‰ÐµÐ½, Ð³Ð¾Ñ‚Ð¾Ð² Ðº Ñ€Ð°Ð±Ð¾Ñ‚Ðµ!")
WinActivate, ahk_id %MainGuiHwnd%
WinShow, ahk_id %MainGuiHwnd%
WinRestore, ahk_id %MainGuiHwnd%
return

SaveAllSettings() {
    global
    if (MainGuiHwnd && WinExist("ahk_id " MainGuiHwnd)) {
        Gui, Main:Submit, NoHide
        IniWrite, %NickEdit%, %BindIni%, Settings, Nick
        IniWrite, %AccNumberEdit%, %BindIni%, Settings, AccNumber
        IniWrite, % (GenderRadioMale ? 1 : 2), %BindIni%, Settings, Gender
        IniWrite, %AutoRouletteActive%, %BindIni%, Settings, AutoRoulette
        IniWrite, %AutoTimeActive%, %BindIni%, Settings, AutoTime
        IniWrite, %CityCode%, %BindIni%, Settings, City
        UserNick := NickEdit
        UserAccNumber := AccNumberEdit
        Gender := (GenderRadioMale ? 1 : 2)
    } else {
        IniWrite, %UserNick%, %BindIni%, Settings, Nick
        IniWrite, %UserAccNumber%, %BindIni%, Settings, AccNumber
        IniWrite, %Gender%, %BindIni%, Settings, Gender
        IniWrite, %AutoRouletteActive%, %BindIni%, Settings, AutoRoulette
        IniWrite, %AutoTimeActive%, %BindIni%, Settings, AutoTime
        IniWrite, %CityCode%, %BindIni%, Settings, City
    }
    SaveBinders()
    SaveTimers()
}

; ====================================================================================================
; ÐžÐ¢Ð¡Ð›Ð•Ð–Ð˜Ð’ÐÐÐ˜Ð• ÐÐšÐ¢Ð˜Ð’ÐÐžÐ¡Ð¢Ð˜ Ð’ Ð˜Ð“Ð Ð• (Ð½Ðµ Ñ‚Ñ€ÐµÐ±ÑƒÐµÑ‚ Ð¿Ñ€Ð°Ð²ÐºÐ¸ SAMP.ahk)
; ====================================================================================================
#IfWinActive, ahk_exe gta_sa.exe
~*LButton:: MarkActivity()
~*RButton:: MarkActivity()
~*MButton:: MarkActivity()
~*WheelUp:: MarkActivity()
~*WheelDown:: MarkActivity()
~*a:: MarkActivity()
~*b:: MarkActivity()
~*c:: MarkActivity()
~*d:: MarkActivity()
~*e:: MarkActivity()
~*f:: MarkActivity()
~*g:: MarkActivity()
~*h:: MarkActivity()
~*i:: MarkActivity()
~*j:: MarkActivity()
~*k:: MarkActivity()
~*l:: MarkActivity()
~*m:: MarkActivity()
~*n:: MarkActivity()
~*o:: MarkActivity()
~*p:: MarkActivity()
~*q:: MarkActivity()
~*r:: MarkActivity()
~*s:: MarkActivity()
~*t:: MarkActivity()
~*u:: MarkActivity()
~*v:: MarkActivity()
~*w:: MarkActivity()
~*x:: MarkActivity()
~*y:: MarkActivity()
~*z:: MarkActivity()
~*0:: MarkActivity()
~*1:: MarkActivity()
~*2:: MarkActivity()
~*3:: MarkActivity()
~*4:: MarkActivity()
~*5:: MarkActivity()
~*6:: MarkActivity()
~*7:: MarkActivity()
~*8:: MarkActivity()
~*9:: MarkActivity()
~*Space:: MarkActivity()
~*Enter:: MarkActivity()
~*Tab:: MarkActivity()
~*Delete:: MarkActivity()
~*Up:: MarkActivity()
~*Down:: MarkActivity()
~*Left:: MarkActivity()
~*Right:: MarkActivity()
#IfWinActive

SaveOnExit:
    SaveAllSettings()
    ExitApp
return

CheckIdle:
    global LastActivityTime, UserIsActive
    if (A_TickCount - LastActivityTime > 600000) {  ; 10 Ð¼Ð¸Ð½ÑƒÑ‚
        if (UserIsActive) {
            UserIsActive := 0
            UpdateStatusAndTime()
        }
    }
return

; ====================================================================================================
; ÐžÐšÐÐž Ð¡ÐŸÐ˜Ð¡ÐšÐ Ð›Ð˜Ð¦Ð•ÐÐ—Ð˜Ð™ (Ð”Ð›Ð¯ ÐŸÐžÐžÐ§Ð•Ð ÐÐ”ÐÐžÐ¡Ð¢Ð˜) - Ð£Ð’Ð•Ð›Ð˜Ð§Ð•ÐÐž Ð˜ Ð’Ð«Ð ÐžÐ’ÐÐ•ÐÐž
; ====================================================================================================
ShowLicensesOrder() {
    global LicensesOrderGuiHwnd, MainGuiHwnd
    if (LicensesOrderGuiHwnd && WinExist("ahk_id " LicensesOrderGuiHwnd)) {
        Gui, LicensesOrderGui:Show
        WinActivate, ahk_id %LicensesOrderGuiHwnd%
        return
    }
    Gui, LicensesOrderGui:New, +ToolWindow -Caption +LastFound +Owner%MainGuiHwnd%
    LicensesOrderGuiHwnd := WinExist()
    Gui, LicensesOrderGui:Color, 1A1A1A
    Gui, LicensesOrderGui:Font, s16 Bold, Segoe UI
    Gui, LicensesOrderGui:Add, Text, x0 y15 w500 Center gDragLicensesOrder cFFD700, ðŸ“œ Ð¡Ð¿Ð¸ÑÐ¾Ðº Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹ (Ð¿Ð¾Ð¾Ñ‡ÐµÑ€Ñ‘Ð´Ð½Ð¾ÑÑ‚ÑŒ)
    Gui, LicensesOrderGui:Font, s10, Segoe UI
    Gui, LicensesOrderGui:Add, Text, x0 y50 w500 Center cWhite, â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    Gui, LicensesOrderGui:Font, s12 cFFD700, Segoe UI
    Gui, LicensesOrderGui:Add, Text, x25 y90, 1. Ð›Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ Ð½Ð° Ð½Ð°Ð·ÐµÐ¼Ð½Ñ‹Ð¼ Ñ‚Ñ€Ð°Ð½ÑÐ¿Ð¾Ñ€Ñ‚Ð¾Ð¼ (400$)
    Gui, LicensesOrderGui:Add, Text, x25 y125, 2. Ð›Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ Ð½Ð° Ð½Ð¾ÑˆÐµÐ½Ð¸Ðµ Ð¾Ñ€ÑƒÐ¶Ð¸Ñ (125.000$)
    Gui, LicensesOrderGui:Add, Text, x25 y160, 3. Ð›Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ Ð½Ð° Ð²Ð¾Ð´Ð½Ñ‹Ð¹ Ñ‚Ñ€Ð°Ð½ÑÐ¿Ð¾Ñ€Ñ‚ (25.000$)
    Gui, LicensesOrderGui:Add, Text, x25 y195, 4. Ð Ð°Ð·Ñ€ÐµÑˆÐµÐ½Ð¸Ðµ Ð½Ð° Ð¿Ð¾Ð»Ñ‘Ñ‚Ñ‹ Ð½Ð° Ð´Ð¶ÐµÑ‚Ð¿Ð°ÐºÑƒ (5.000$)
    Gui, LicensesOrderGui:Add, Text, x25 y230, 5. Ð Ð°Ð·Ñ€ÐµÑˆÐµÐ½Ð¸Ðµ Ð½Ð° Ð²Ñ‹Ð¿Ð¾Ð»Ð½ÐµÐ½Ð¸Ðµ Ð²Ñ‹ÑÐ¾Ñ‚Ð½Ñ‹Ñ… Ð¿Ð¾Ð»ÐµÑ‚Ð¾Ð² (15.000$)
    Gui, LicensesOrderGui:Add, Text, x25 y265, 6. Ð›Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ Ð½Ð° Ð²Ð¾Ð·Ð´ÑƒÑˆÐ½Ñ‹Ð¹ Ñ‚Ñ€Ð°Ð½ÑÐ¿Ð¾Ñ€Ñ‚ (30.000$)
    Gui, LicensesOrderGui:Add, Text, x25 y300, 7. Ð›Ð¸Ñ†ÐµÐ½Ð·Ð¸Ñ Ð½Ð° Ð¿Ð¾ÐºÑƒÐ¿ÐºÑƒ Ð±Ð¸Ð·Ð½ÐµÑÐ° (250.000$)
    Gui, LicensesOrderGui:Font, s11 Bold cWhite, Segoe UI
    ; ÐšÐ½Ð¾Ð¿ÐºÐ° "Ð—Ð°ÐºÑ€Ñ‹Ñ‚ÑŒ" Ð¿Ð¾ Ñ†ÐµÐ½Ñ‚Ñ€Ñƒ
    Gui, LicensesOrderGui:Add, Button, gCloseLicensesOrder x175 y360 w150 h35, ðŸ”„ Ð—Ð°ÐºÑ€Ñ‹Ñ‚ÑŒ
    Gui, LicensesOrderGui:Show, w500 h450, Ð¡Ð¿Ð¸ÑÐ¾Ðº Ð»Ð¸Ñ†ÐµÐ½Ð·Ð¸Ð¹
    Gui, Main:+Disabled
    WinActivate, ahk_id %LicensesOrderGuiHwnd%
}
CloseLicensesOrder:
    Gui, LicensesOrderGui:Destroy
    Gui, Main:-Disabled
    WinActivate, ahk_id %MainGuiHwnd%
return
DragLicensesOrder:
    PostMessage, 0xA1, 2,,, A
return

ForceOpenMainGui:
    ; Ð•ÑÐ»Ð¸ Ð¾ÐºÐ½Ð¾ Ð¸Ð³Ñ€Ñ‹ Ð°ÐºÑ‚Ð¸Ð²Ð½Ð¾ (Ñ€Ð°Ð·Ð²Ñ‘Ñ€Ð½ÑƒÑ‚Ð¾), Ð½Ðµ Ð¿Ð¾ÐºÐ°Ð·Ñ‹Ð²Ð°ÐµÐ¼ Ð³Ð»Ð°Ð²Ð½Ð¾Ðµ Ð¾ÐºÐ½Ð¾, Ð¾ÑÑ‚Ð°Ð²Ð»ÑÐµÐ¼ ÑÐºÑ€Ð¸Ð¿Ñ‚ Ð² Ñ‚Ñ€ÐµÐµ
    if WinActive("ahk_exe gta_sa.exe")
        return
    ShowMainGui()
    WinShow, ahk_id %MainGuiHwnd%
    WinRestore, ahk_id %MainGuiHwnd%
    WinActivate, ahk_id %MainGuiHwnd%
return
