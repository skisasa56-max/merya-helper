; ====================================================================================================
; МЭРИЯ HELPER v18.1
; ====================================================================================================
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%

; ====================================================================================================
; НАСТРОЙКИ АВТООБНОВЛЕНИЯ (СИНХРОННАЯ ПРОВЕРКА)
; ====================================================================================================
global ScriptVersion := "18.3"
global UpdateCheckUrl := "https://raw.githubusercontent.com/skisasa56-max/merya-helper/main/version.txt"
global ScriptDownloadUrl := "https://raw.githubusercontent.com/skisasa56-max/merya-helper/main/AutoHotkey%20Script%20(2).ahk"
global UpdateTempFile := A_Temp "\mhelper_new.ahk"

CheckForUpdates(showMsg := false) {
    global ScriptVersion, UpdateCheckUrl, ScriptDownloadUrl, UpdateTempFile
    tempVerFile := A_Temp "\mhelper_ver.txt"
    URLDownloadToFile, %UpdateCheckUrl%, %tempVerFile%
    if ErrorLevel {
        if showMsg
            MsgBox, 4096, Ошибка, Не удалось соединиться с сервером.
        return 0
    }
    FileRead, remoteVer, %tempVerFile%
    FileDelete, %tempVerFile%
    remoteVer := Trim(remoteVer, " `t`r`n")
    if (remoteVer = "") {
        if showMsg
            MsgBox, 4096, Ошибка, Пустая версия на сервере.
        return 0
    }
    if (remoteVer = ScriptVersion) {
        if showMsg
            MsgBox, 4096, Обновления, У вас последняя версия %ScriptVersion%.
        return 1
    }
    msgText = Версия %remoteVer% уже доступна. У вас версия %ScriptVersion%. Обновить сейчас?
    MsgBox, 4132, Доступно обновление, %msgText%
    IfMsgBox Yes
    {
        URLDownloadToFile, %ScriptDownloadUrl%, %UpdateTempFile%
        if ErrorLevel {
            MsgBox, 4096, Ошибка, Не удалось скачать обновление.
            return 0
        }
        FileCopy, %UpdateTempFile%, %A_ScriptFullPath%, 1
        if ErrorLevel {
            MsgBox, 4096, Ошибка, Не удалось заменить файл. Запустите от имени администратора.
            return 0
        }
        Run, "%A_ScriptFullPath%"
        ExitApp
    }
    return 0
}

; СИНХРОННАЯ ПРОВЕРКА ПРИ СТАРТЕ – при любой ошибке закрываемся
if !CheckForUpdates(true) {
    MsgBox, 4096, Критическая ошибка, Не удалось проверить обновления. Скрипт закрыт.
    ExitApp
}

OnExit, SaveOnExit
SetTimer, ForceOpenMainGui, -500

; ====================================================================================================
; НАСТРОЙКИ ТРЕЯ
; ====================================================================================================
Menu, Tray, NoStandard
Menu, Tray, Add, Развернуть, RestoreFromTray
Menu, Tray, Add, Проверить обновления, CheckUpdatesManual
Menu, Tray, Add, О программе, ShowAbout
Menu, Tray, Add  ; разделитель
Menu, Tray, Add, Закрыть, ExitScript

; ====================================================================================================
; ПОДКЛЮЧЕНИЕ БИБЛИОТЕК
; ====================================================================================================
#Include %A_ScriptDir%\SAMP.ahk
#Include %A_ScriptDir%\Class_CtlColors.ahk

; ====================================================================================================
; ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ (ОСНОВНЫЕ)
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
global CityName := "Лас-Вентурас"
global LastActivityTime := 0
global UserIsActive := 1
global LicensesOrderGuiHwnd := 0
global InstructionsGuiHwnd := 0


global Tag := "Мэрия"
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
global LawyerResult := 0 ; 0 - нет, 1 - оправдан, 2 - отказ
global LawyerTargetName := ""

global LicNames := ["управление наземным транспортом", "приобретение и ношение оружия", "управление водными судами", "эксплуатацию индивидуальных летательных аппаратов", "выполнение высотных полетов", "управление воздушным транспортом", "ведение предпринимательской деятельности"]
global LicPrices := [400, 125000, 25000, 5000, 15000, 30000, 250000]

; ====================================================================================================
; ИНИЦИАЛИЗАЦИЯ
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
SetTimer, CheckIdle, 60000   ; проверка каждую минуту
if (AutoTimeActive = 1)
    StartAutoTime()

; ^!m:: ShowMainGui()
; ^!t:: ShowTimerManager()
; ^!b:: ShowBinderManager()
; ^!r::
;     SaveAllSettings()
;     Reload
; return

; Адвокатские горячие клавиши
^1:: LawyerConditions()          ; Ctrl+1 - условия адвоката
!1::
    if (UserNick = "")
        SendChat(".фд Я — сотрудник мэрии " CityName "*коснувшись пальцем бейджа")
    else if (Gender == 1)
        SendChat(".фд Я — " UserNick ", сотрудник мэрии " CityName "*коснувшись пальцем бейджа")
    else
        SendChat(".фд Я — " UserNick ", сотрудница мэрии " CityName "*коснувшись пальцем бейджа")
return
!2:: ShowLicensesList()
!3::
    LicenseMenuMode := 1
    addChatMessage("{FF0000}[" Tag "] {33AAFF}Режим цены: {FFFFFF}Нажмите {FFFF00}1-7 {FFFFFF}для оглашения стоимости.")
return
!4::
    LicenseMenuMode := 2
    TempTotal := 0
    LastPrice := 0
    addChatMessage("{FF0000}[" Tag "] {00FF00}Режим суммы: {FFFFFF}Выбирайте {FFFF00}1-7{FFFFFF}. Итог: {FFA500}Backspace{FFFFFF}. Отмена: {FF4500}Delete{FFFFFF}.")
return

#If WinActive("ahk_exe gta_sa.exe")
NumpadAdd:: SendInput, {F6}/pagesize 30{Enter}
NumpadSub:: SendInput, {F6}/pagesize 10{Enter}
#If

Home:: SendChat("/фракция")

!Delete::
    addChatMessage("{00FF00}[" Tag "] Перезагрузка биндера, это может занять несколько секунд...")
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

:O:/автопрофиль::
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
; ПЕРЕХВАТ ENTER ДЛЯ КОМАНД
; ====================================================================================================
~$Enter::
~$NumpadEnter::
    if (WinActive("ahk_exe gta_sa.exe") && isInChat() && !isDialogOpen()) {
        SavedClipboard := ClipboardAll
        Clipboard := ""
        SendInput, {Home}+{End}^c
        ClipWait, 0.1
        chatText := Clipboard

        ; Команда /лица
        if (RegExMatch(chatText, "i)^[/\.](лица|lics)\s+(\d+)", Match)) {
            SendInput, {CtrlDown}a{CtrlUp}{Backspace}{Enter}
            TargetID := Match2
            RawName := getPlayerNameById(TargetID)
            TargetName := StrReplace(RawName, "_", " ")
            if (TargetName == "") {
                addChatMessage("{FF0000}[" Tag "] {FFFFFF}Игрок с таким ID не найден.")
                return
            }
            addChatMessage("{FF0000}[" Tag "] {00FF00}Продаю лицензию: {FFFFFF}" TargetName)
            LicenseProcess := 1
            SendChat("Пожалуйста, предъявите ваш паспорт для оформления документов.")
            Clipboard := SavedClipboard
            return
        }

        ; Команда /вып
        if (RegExMatch(chatText, "i)^[/\.](вып|кпз|vip)\s+(\d+)", Match)) {
            SendInput, {CtrlDown}a{CtrlUp}{Backspace}{Enter}
            TargetID_Law := Match2
            LawRawName := getPlayerNameById(TargetID_Law)
            LawFullName := LawRawName ? StrReplace(LawRawName, "_", " ") : TargetID_Law
            addChatMessage("{FF0000}[" Tag "] {FFFFFF}Работаю по: {33AAFF}" LawFullName)
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

        ; Команда /инф
        if (RegExMatch(chatText, "i)^[/\.](инф|inf)\s+(.+)", Match)) {
            SendInput, {CtrlDown}a{CtrlUp}{Backspace}{Enter}
            Target := Match2
            if (RegExMatch(Target, "^\d+$")) {
                pName := getPlayerNameById(Target)
                addChatMessage("{FF0000}[" Tag "] {FFFFFF}Собираю информаицю на: {33AAFF}" (pName ? StrReplace(pName, "_", " ") : Target) "...")
                Data := GetDataFromIngameDialog(Target, true)
                if (Data.Acc != "") {
                    addChatMessage("{FF0000}============ Информация о игроке ============")
                    addChatMessage("{FFFFFF}Ник: {33AAFF}" Data.Name " {FFFFFF}| Аккаунт: {FFFF00}" Data.Acc)
                    addChatMessage("{FFFFFF}Уровень: {00FF00}" Data.LVL " {FFFFFF}")
                    if (Data.Bday)
                        addChatMessage("{FFFFFF}Дата рождения: {33AAFF}" Data.Bday)
                    if (Data.Org)
                        addChatMessage("{FFFFFF}Организация: {33AAFF}" Data.Org)
                    if (Data.House)
                        addChatMessage("{FFFFFF}Дом: {33AAFF}" Data.House)
                    if (Data.Car)
                        addChatMessage("{FFFFFF}Транспорт: {33AAFF}" Data.Car)
                    if (Data.Family != "" && Data.Family != "Скрыто")
                        addChatMessage("{FFFFFF}Семья: {33AAFF}" Data.Family)
                    if (Data.Rep)
                        addChatMessage("{FFFFFF}Репутация: {00FF00}" Data.Rep)
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
; ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
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
        SendChat("Назовите Имя и Фамилию задержанного")
    } else {
        SendChat("Я адвокат города " CityName ". Давайте перейдем к делу.")
        Sleep 1950
        SendChat("Озвучу вам условия нашей работы:")
        Sleep 1950
        SendChat("Во-первых: интервал между повторными запросами на одного человека составляет 14 часов.")
        Sleep 1950
        SendChat("Во-вторых: денежные средства не возвращаются, если по дело был получен отказ.")
        Sleep 1950
        SendChat("В-третьих: максимальный срок отбывания не должен превышать 2-х часов.")
        Sleep 1950
        SendChat("Если условия вам понятны и вы их принимаете, назовите имя и фамилию заключенного")
        Sleep 1950
        SendChat("и произведите оплату в размере 50.000$.")
        WaitingForPayment := true
    }
}

ShowLicensesList() {
    addChatMessage("{FF0000}[" Tag "] {33AAFF}Перечень и стоимость государственных лицензий")
    Sleep, 150
    SendChat("Лицензия на управление наземным транспортом — 400$")
    Sleep, 1950
    SendChat("Лицензия на приобретение и ношение оружия — 125.000$")
    Sleep, 1950
    SendChat("Лицензия на управление водными судами — 25.000$")
    Sleep, 1950
    SendChat("Разрешение на эксплуатацию индивидуальных летательных аппаратов — 5.000$")
    Sleep, 1950
    SendChat("Разрешение на выполнение высотных полетов — 15.000$")
    Sleep, 1950
    SendChat("Лицензия на управление воздушным транспортом — 30.000$")
    Sleep, 1950
    SendChat("Лицензия на ведение предпринимательской деятельности — 250.000$")
}

GetDataFromIngameDialog(ID, FullScan := false) {
    Result := {Name: "", Acc: "", LVL: "", Phone: "", Org: "", Bday: "", House: "", Family: "", Rep: "", Car: ""}
    RawName := getPlayerNameById(ID)
    Result.Name := StrReplace(RawName, "_", " ")
    SendChat("/и " ID)
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
        if (RegExMatch(CleanLine, "i)Имя:\s*([A-Za-z_]+)", M))
            Result.Name := StrReplace(M1, "_", " ")
        if (RegExMatch(CleanLine, "i)Номер аккаунта:.*?[^\d]*(\d+)", M))
            Result.Acc := M1
        if (RegExMatch(CleanLine, "i)Уровень:.*?[^\d]*(\d+)", M))
            Result.LVL := M1
        if (RegExMatch(CleanLine, "i)День рождения:\s*(\d{1,2})\s(\d{1,2})\s(\d{4})", M))
            Result.Bday := M1 "/" M2 "/" M3
        if (RegExMatch(CleanLine, "i)Дом:\s*(\d+)\s*\((.*?)\)", M))
            Result.House := M1 ": " M2
        if (RegExMatch(CleanLine, "i)Организация:\s*(.*)", M))
            Result.Org := Trim(M1)
        if (RegExMatch(CleanLine, "i)Репутация:\s*([\+\-]?\d+)", M))
            Result.Rep := M1
        if (RegExMatch(CleanLine, "i)Транспорт:\s*(.*)", M))
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
    SendChat("/todo Сейчас посмотрим что возможно тут решить*включая компьютер")
    Sleep 2099
    SendChat("/do Компьютер включён")
    Sleep 2099
    if (Gender == 1)
        SendChat("/me запустил базу данных МВД и ввёл код государственного адвоката")
    else
        SendChat("/me запустила базу данных МВД и ввела код государственного адвоката")
    Sleep 2099
    if (Gender == 1)
        SendChat("/me нашёл личное дело клиента в базе данных")
    else
        SendChat("/me нашла личное дело клиента в базе данных")
    Sleep 2099
    if (Gender == 1)
        SendChat("/me открыл дело №" PendingAcc " и изучил материалы")
    else
        SendChat("/me открыла дело №" PendingAcc " и изучила материалы")
    Sleep 1000
    SendChat("/смс 5055 Передаю на рассмотрение дело №" PendingAcc "/" PendingCaseID)
    SmsSent := true
    SetTimer, LawyerSmsTimeout, -10000
return

LawyerSmsTimeout:
    if (SmsSent) {
        addChatMessage("{FF0000}[" Tag "] {FFFFFF}Запрос отправлен. {00FF00}1 - Ок {FFFFFF}| {FF0000}0 - Отмена")
    }
return

StartLicenseRP:
    if (Gender == 1)
        SendChat("/me достал из кармана служебный планшет, разблокировав его отпечатком пальца.")
    else
        SendChat("/me достала из кармана служебный планшет, разблокировав его отпечатком пальца.")
    Sleep 2070
    if (Gender == 1)
        SendChat("/me зашёл в электронную базу данных жителей штата и нашёл данные о клиенте")
    else
        SendChat("/me зашла в электронную базу данных жителей штата и нашла данные о клиенте")
    Sleep 2070
    if (Gender == 1)
        SendChat("/me открыл в новой вкладке базу данных Департамента лицензирования")
    else
        SendChat("/me открыла в новой вкладке базу данных Департамента лицензирования")
    Sleep 2070
    if (Gender == 1)
        SendChat("/me выбрал нужные лицензии и скопировал данные клиента из общей базы в базу ДЛ")
    else
        SendChat("/me выбрала нужные лицензии и скопировала данные клиента из общей базы в базу ДЛ")
    Sleep 2070
    if (Gender == 1)
        SendChat("/me сформировал электронный бланк оплаты, внеся сумму оплаты и дату выдачи лицензий")
    else
        SendChat("/me сформировала электронный бланк оплаты, внеся сумму оплаты и дату выдачи лицензий")
    Sleep 2070
    SendChat("/todo Нужна идентификация личности через Face ID*наводя объектив на клиента")
    Sleep 2070
    SendChat("/todo Посмотрите, пожалуйста, прямо в камеру*сделав снимок лица клиента")
    Sleep 2070
    SendChat("/todo Поставьте электронную подпись*передавая планшет человеку напротив")
    Sleep 2080
    SendChat("*/me взял планшет и поставил электронную подпись")
    Sleep 500
    SendChat("/time")
    Sleep 50
    addChatMessage("{FF0000}[" Tag "] {00FF00} После получения подписи: {FFFF00}Backspace{00FF00} - далее, {FF4500}Delete{00FF00} - отмена.")
    LicenseProcess := 2
return

; ====================================================================================================
; ИСТОРИЯ ПРИЗОВ
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
        RefreshHistoryListFunc()   ; исправлено: вызов функции вместо Gosub
}
RefreshHistoryListFunc() {         ; новая функция для обновления списка
    global PrizeHistory
    Gui, HistoryGui:Default
    LV_Delete()
    For index, prize in PrizeHistory
        LV_Add("", prize.time, prize.text)
}

; ====================================================================================================
; АВТОТАЙМ
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
; АВТОРУЛЕТКА
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
    SendChat("/рулетка")
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
; ПАРСИНГ СМС
; ====================================================================================================
ParseSmsMessage(line) {
    if !RegExMatch(line, "i)СМС\s+от\s+(.+?)\s*\[(\d+)\]:\s*(.*)$", match)
        return ["", "", ""]
    return [Trim(match1), Trim(match2), Trim(match3)]
}

; ====================================================================================================
; ФУНКЦИЯ УВЕДОМЛЕНИЯ (исправлена: не показывать при активной игре)
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
    Gui, Notification:Add, Text, x10 y5 cFFD700, ✉ Новое СМС от %senderName%
    Gui, Notification:Font, s9 cWhite, Segoe UI
    Gui, Notification:Add, Text, x10 y30, %msgText%
    Gui, Notification:Add, Button, gOpenReplyFromNotification x10 y55 w80 h25, 💬 Ответить
    Gui, Notification:Add, Button, gCloseNotification x95 y55 w80 h25, ❌ Закрыть
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
; МОНИТОРИНГ ЧАТА (исправлен: фильтр Admin 5055 + удалено дублирование функции)
; ====================================================================================================
MonitorChat:
    if (!IsFunc("GetChatLine")) {
        global _warnedChat
        if (!_warnedChat) {
            _warnedChat := 1
            addChatMessage("{FF0000}[МЭРИЯ] Функция GetChatLine не найдена.")
        }
        return
    }
    GetChatLine(0, msg)
    if (msg == "")
        return
    cleanMsg := RegExReplace(msg, "\{[a-fA-F0-9]{6}\}", "")
    cleanMsg := Trim(cleanMsg)

    ; РУЛЕТКА
    global RouletteProcessing, AutoRouletteActive, RouletteAwaitingPrize
    if (AutoRouletteActive && InStr(cleanMsg, "Рулетка готова") && !RouletteProcessing) {
        RouletteProcessing := 1
        SetTimer, StartRouletteSequence, -10
    }
    if (RouletteAwaitingPrize && InStr(cleanMsg, "Приз:")) {
        prizeStart := InStr(cleanMsg, "Приз:") + 5
        prizeText := Trim(SubStr(cleanMsg, prizeStart))
        if (prizeText != "") {
            AddPrizeToHistory(prizeText)
            SoundPlay, *-1
        }
        RouletteAwaitingPrize := 0
        RouletteProcessing := 0
    }

    ; ОБРАБОТКА СМС (с фильтром Admin 5055)
    if InStr(cleanMsg, "СМС") {
        global LastSmsTime, LastSmsMessage
        if (cleanMsg = LastSmsMessage)
            return
        if (A_TickCount - LastSmsTime < 3000)
            return
        result := ParseSmsMessage(cleanMsg)
        sender := result[1]
        number := result[2]
        text := result[3]

        ; Игнорируем уведомления и историю для СМС от Admin 5055
        isAdmin5055 := (number = "5055" && InStr(sender, "Admin"))
        if (!isAdmin5055 && sender != "" && text != "") {
            LastSmsTime := A_TickCount
            LastSmsMessage := cleanMsg
            AddSmsRecord("in", number, sender, text)
            ShowClickableNotification(sender, number, text)
        }
        ; Если это сообщение от 5055, оно не сохраняется и не показывает уведомление,
        ; но выполнение скрипта продолжается – нижестоящие проверки (например, ответ админа для адвоката) сработают.
    }

; Проверка предъявления паспорта (для лицензий) - с поиском по последним 4 строкам
if (LicenseProcess == 1) {
    nameWithSpaces := TargetName
    nameWithUnderscores := StrReplace(TargetName, " ", "_")
    found := false
    ; Проверяем строки: текущую, -1, -2, -3
    Loop, 4 {
        idx := A_Index - 1   ; 0, -1, -2, -3
        if (idx = 0)
            checkMsg := cleanMsg
        else
            GetChatLine(idx, checkMsg)
        if (checkMsg = "")
            continue
        if (RegExMatch(checkMsg, "i)" nameWithSpaces " показал[а]? паспорт")
            || RegExMatch(checkMsg, "i)" nameWithUnderscores " показал[а]? паспорт")) {
            found := true
            break
        }
    }
    if (found) {
        LicenseProcess := 0
        SetTimer, StartLicenseRP, -500
        addChatMessage("{00FF00}[" Tag "]{00FF00} Паспорт получен, запускаю оформление лицензий.")
    }
}

    ; Проверка подписи (для лицензий)
    if (LicenseProcess == 2) {
        if (RegExMatch(cleanMsg, "i)" TargetName ".*? взял[а]? планшет и поставил[а]? электронную подпись")) {
            addChatMessage("{FF0000}[" Tag "] {00FF00}Подпись получена! {FFFFFF}Нажмите {FFFF00}Backspace{FFFFFF} для продолжения.")
        }
    }

; Проверка оплаты для адвоката (любая сумма)
if (WaitingForPayment) {
    if (RegExMatch(cleanMsg, "i)Тебе передано \$([\d\s]+) от (.*)", Match)) {
        sumRaw := Match1
        sumClean := RegExReplace(sumRaw, "\s", "")   ; убираем пробелы (50 000 -> 50000)
        Payer := StrReplace(Match2, "_", " ")
        SendChat("Хорошо " Payer ", оплату в размере " sumRaw "$ вижу. Начинаю рассмотрение дела.")
        WaitingForPayment := false
    }
}

    ; Проверка ответа от админа (5055)
    if (SmsSent) {
        if (RegExMatch(cleanMsg, "i)СМС от Admin \[5055\].*?" PendingAcc "/" PendingCaseID ".*?отказ")) {
            SmsSent := false
            LawyerResult := 2
            Sleep 1500
            if (Gender == 1)
    SendChat("/me закрыл дело и выключил компьютер")
else
    SendChat("/me закрыла дело и выключила компьютер")
 Sleep 50
            SendChat("/time")
            addChatMessage("{FF0000}[" Tag "] {FFFFFF}Нажмите {FF0000}Backspace{FFFFFF} чтобы сообщить итог дела №{FF0000}" PendingAcc " {FFFFFF}или {FF0000}Delete {FFFFFF}для отмены")
        }
        else if (RegExMatch(cleanMsg, "i)СМС от Admin \[5055\].*?" PendingAcc "/" PendingCaseID ".*?оправдан")) {
            SmsSent := false
            LawyerResult := 1
            Sleep 1500
                       if (Gender == 1)
    SendChat("/me закрыл дело и выключил компьютер")
else
    SendChat("/me закрыла дело и выключила компьютер")
            Sleep 50
            SendChat("/time")
            addChatMessage("{FF0000}[" Tag "] {FFFFFF}Нажмите {FF0000}Backspace{FFFFFF} чтобы сообщить итог дела №{FF0000}" PendingAcc " {FFFFFF}или {FF0000}Delete {FFFFFF}для отмены")
        }
    }
return

; ====================================================================================================
; АВТОПРОФИЛЬ
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
                if (RegExMatch(CleanLine, "i)Фамилия:[^\s]*\s+([A-Za-z_\s]+)", M))
                    AutoProfileName := StrReplace(Trim(M1), "_", " ")
                if (RegExMatch(CleanLine, "i)Номер аккаунта:.*?[^\d]*(\d+)", M))
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
                addChatMessage("{FF0000}[" Tag "] {FFFFFF}Профиль обновлен:")
                Sleep, 12
                addChatMessage("{FF0000}[" Tag "] {FFFFFF}Имя:{FF0000} " UserNick)
                Sleep, 12
                addChatMessage("{FF0000}[" Tag "] {FFFFFF}Номер аккаунта:{FF0000} " UserAccNumber)
                try UpdatePreviewFunc()
                SoundPlay, *-1
            } else {
                addChatMessage("{FF0000}[" Tag "] Ошибка: Данные не найдены.")
                SoundPlay, *-1
            }
            AutoProfileActive := 0
            AutoProfileStep := 0
        }
    }
return

; ====================================================================================================
; ОКНО ИСТОРИИ ПРИЗОВ
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
Gui, HistoryGui:Add, Text, x25 y15 gDragHistory cFFD700, 🎲 История призов (10 последних)
Gui, HistoryGui:Font, s10, Segoe UI
Gui, HistoryGui:Add, Text, x25 y50 cWhite, ═══════════════════════════════════════════════════════════════════
Gui, HistoryGui:Font, s11 Bold, Segoe UI
Gui, HistoryGui:Add, ListView, vHistoryList x25 y70 w400 h300 cFFD700 Background2D2D2D, Время|Приз
LV_ModifyCol(1, 80)
LV_ModifyCol(2, 300)
Gui, HistoryGui:Font, s11 Bold cWhite, Segoe UI
Gui, HistoryGui:Add, Button, gCloseHistory x150 y390 w150 h35, 🔄 Закрыть
RefreshHistoryListFunc()
Gui, HistoryGui:Show, w450 h450, История призов
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
; ФУНКЦИИ ДЛЯ ИСТОРИИ СМС И УВЕДОМЛЕНИЙ
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
    Gui, SmsReply:Add, Text, x10 y10 cFFD700, ✉ Ответить %name% [%number%]
    Gui, SmsReply:Font, s10 cWhite, Segoe UI
    if (originalText != "")
        Gui, SmsReply:Add, Text, x10 y40, Сообщение: %originalText%
    Gui, SmsReply:Font, s11, Segoe UI
    Gui, SmsReply:Add, Edit, vSmsReplyText x10 y70 w280 h60
    GuiControlGet, hEdit, SmsReply:Hwnd, SmsReplyText
    CtlColors.Attach(hEdit, "2D2D2D", "FFD700")
    Gui, SmsReply:Add, Button, gSendSmsReply x10 y140 w130 h30, 📨 Отправить
    Gui, SmsReply:Add, Button, gCloseSmsReply x160 y140 w130 h30, ❌ Отмена
    Gui, SmsReply:Show, w300 h190, Быстрый ответ
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
        typeIcon := (rec.type = "in") ? "📩" : "📤"
        typeName := (rec.type = "in") ? "" : ""

        ; Отображение имени/номера для входящих и исходящих
        if (rec.type = "out") {
            ; Для исходящих показываем "→ номер" или "→ имя", если имя есть
            if (rec.name != "")
                displayName := "→ " rec.name " [" rec.number "]"
            else
                displayName := "→ [" rec.number "]"
        } else {
            ; Входящие: имя [номер]
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
    Gui, SmsHistoryGui:Add, Text, x25 y15 gDragSmsHistory cFFD700, 📜 История СМС (30 последних)
    Gui, SmsHistoryGui:Font, s10, Segoe UI
    Gui, SmsHistoryGui:Add, Text, x25 y50 cWhite, ═══════════════════════════════════════════════════════════════════
    Gui, SmsHistoryGui:Font, s11 Bold, Segoe UI
    Gui, SmsHistoryGui:Add, ListView, vSmsHistoryList x25 y70 w500 h300 cFFD700 Background2D2D2D gSmsHistoryClick, Время|Тип|Номер/Имя|Текст
    LV_ModifyCol(1, 70)
    LV_ModifyCol(2, 60)
    LV_ModifyCol(3, 120)
    LV_ModifyCol(4, 250)
    Gui, SmsHistoryGui:Font, s11 Bold cWhite, Segoe UI
    Gui, SmsHistoryGui:Add, Button, gCloseSmsHistory x200 y390 w150 h35, 🔄 Закрыть
    RefreshSmsHistoryList()
    Gui, SmsHistoryGui:Show, w550 h460, История СМС
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
        if InStr(typeCol, "📩") {
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
            Menu, SmsContextMenu, Add, Ответить, ReplyFromHistory
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
; БИНДЕРЫ
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
; ТАЙМЕРЫ
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
; ЗАГРУЗКА КОНФИГА
; ====================================================================================================
LoadConfigFromFile() {
    global
    FileSelectFile, configFile, 3, %A_MyDesktop%, Выберите файл конфигурации (*.txt), Text Files (*.txt)
    if (configFile = "")
        return
    FileRead, configContent, %configFile%
    if (ErrorLevel) {
        MsgBox, 4096, Ошибка, Не удалось прочитать файл!
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
; ИНТЕРФЕЙС ГЛАВНОГО ОКНА
; ====================================================================================================
UpdatePreviewFunc() {
    global
    GuiControlGet, NickEdit, Main:
    GuiControlGet, AccNumberEdit, Main:
    GuiControl, Main:Text, PreviewName, %NickEdit%
    GuiControl, Main:Text, PreviewAccNumber, % "Номер аккаунта: " . (AccNumberEdit != "" ? AccNumberEdit : "—")
    if (GenderRadioMale = 1) {
        GuiControl, Main:Text, PreviewGender, 👨‍💼 Мужчина
        GuiControl, Main:Text, PreviewRole, 👮 Сотрудник
        GuiControl, Main:Text, PreviewAvatar, 👨‍💼
    } else {
        GuiControl, Main:Text, PreviewGender, 👩‍💼 Женщина
        GuiControl, Main:Text, PreviewRole, 👮‍♀️ Сотрудница
        GuiControl, Main:Text, PreviewAvatar, 👩‍💼
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

    ; Статус: активен только если нет АФК и есть активные биндеры
    isReallyActive := (UserIsActive && activeCount > 0)
    if (isReallyActive)
        statusColor := "🟢", statusText := "Активен"
    else if (!UserIsActive)
        statusColor := "🔴", statusText := "Неактивен"
    else
        statusColor := "🟡", statusText := "Ожидание"

    autoRouletteStatus := AutoRouletteActive ? "🎲" : "⚪"
    autoTimeStatus := AutoTimeActive ? "⏱️" : "⚪"
    GuiControl, Main:Text, StatusIndicator, %statusColor% %statusText% | 🕐 %mskTime% МСК | Авто: %autoRouletteStatus% %autoTimeStatus%
}

; ====================================================================================================
; АНИМАЦИЯ ОКОН
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
; ПОКАЗ ГЛАВНОГО ОКНА (добавлена кнопка "Системные комбинации")
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
    Gui, Main:Add, Text, vDragArea x25 y20 gStartDrag cFFD700, ⚜️ МЭРИЯ HELPER
    Gui, Main:Font, s11, Segoe UI
    Gui, Main:Add, Text, x25 y60 cWhite, ═════════════════════════════════════════════════════════════════════════════
    Gui, Main:Add, GroupBox, vMainGroup x25 y100 w800 h530 cFFD700
    Gui, Main:Add, GroupBox, vLeftGroup x55 y130 w480 h470 cFFD700
    Gui, Main:Add, GroupBox, vRightGroup x550 y130 w260 h470 cFFD700
    Gui, Main:Font, s11 Bold, Segoe UI
    Gui, Main:Add, Text, vLbl1 x75 y155 cFFD700, ▸ Игровой никнейм
    Gui, Main:Font, s14, Segoe UI
    Gui, Main:Add, Edit, vNickEdit gUpdatePreview x75 y180 w440 h35 Center cFFD700 Background000000, %UserNick%
    Gui, Main:Font, s11 Bold, Segoe UI
    Gui, Main:Add, Text, vLbl6 x75 y230 cFFD700, ▸ Номер аккаунта
    Gui, Main:Font, s14, Segoe UI
    Gui, Main:Add, Edit, vAccNumberEdit gUpdatePreview x75 y255 w440 h35 Center cFFD700 Background000000, %UserAccNumber%
    Gui, Main:Font, s12 Bold cWhite, Segoe UI
    Gui, Main:Add, Button, gShowTimerManager x75 y320 w210 h40, ⏰ Таймеры
    Gui, Main:Add, Button, gShowBinderManager x305 y320 w210 h40, 🔗 Биндеры
    Gui, Main:Font, s11 Bold, Segoe UI
    Gui, Main:Add, Text, vLbl3 x75 y390 cFFD700, ▸ Пол персонажа
    Gui, Main:Font, s12 Bold cFFD700, Segoe UI
    Gui, Main:Add, Radio, vGenderRadioMale gGenderChanged x95 y415 w120 h30 Group, 👨‍💼 Мужской
    Gui, Main:Add, Radio, vGenderRadioFemale gGenderChanged x225 y415 w120 h30, 👩‍💼 Женский
    if (Gender == 1)
        GuiControl, Main:, GenderRadioMale, 1
    else
        GuiControl, Main:, GenderRadioFemale, 1

       ; ЛЕВАЯ КОЛОНКА: чекбоксы, кнопки истории и выбор города (выпадающий список)
    Gui, Main:Font, s10 Bold, Segoe UI
    Gui, Main:Add, Checkbox, vAutoRouletteCheck gToggleAutoRoulette x75 y455 w180 h25 cFFD700, 🎲 Авто-рулетка
    Gui, Main:Add, Checkbox, vAutoTimeCheck gToggleAutoTime x75 y485 w200 h25 cFFD700, ⏱️ Авто-time (45 сек)

    ; Кнопка "История призов"
    Gui, Main:Add, Button, gShowPrizeHistory x75 y520 w210 h25, 📜 История призов

        ; Выбор города (выпадающий список, ширина как у кнопки, текст по центру)
    Gui, Main:Font, s10 Bold, Segoe UI
    Gui, Main:Add, Text, x305 y525 cFFD700,   ; пустой текст (можно удалить)
    Gui, Main:Add, DropDownList, vCityList gCityChanged x300 y520 w210 +Center, 🛎Лас-Вентурас||🛎Сан-Фиерро|🛎Лос-Сантос
    GuiControlGet, hCity, Main:Hwnd, CityList
    CtlColors.Attach(hCity, "2D2D2D", "FFD700")
    if (CityCode = "LV")
        GuiControl, Choose, CityList, 1
    else if (CityCode = "SF")
        GuiControl, Choose, CityList, 2
    else
        GuiControl, Choose, CityList, 3

    ; Кнопка "История СМС" (остаётся на своём месте)
    Gui, Main:Add, Button, gShowSmsHistory x75 y550 w210 h25, 📜 История СМС

    ; === ПРАВАЯ КОЛОНКА (без города) ===
    Gui, Main:Font, s13 Bold, Segoe UI
    Gui, Main:Add, Text, vLbl5 x575 y155 cFFD700 Center w210, ⭐ Профиль
    Gui, Main:Font, s9 cWhite, Segoe UI
    Gui, Main:Add, Text, x575 y180 cWhite, ─────────────────────────────
    Gui, Main:Font, s14 Bold cWhite, Segoe UI
    Gui, Main:Add, Text, vPreviewName x570 y210 w220 Center, %UserNick%
    Gui, Main:Font, s10 cFFD700, Segoe UI
    Gui, Main:Add, Text, vPreviewAccNumber x570 y245 w220 Center, % "Номер аккаунта: " . (UserAccNumber != "" ? UserAccNumber : "—")
    Gui, Main:Font, s11 cFFD700, Segoe UI
    Gui, Main:Add, Text, vPreviewGender x570 y280 w220 Center
    Gui, Main:Add, Text, vPreviewRole x570 y310 w220 Center
    Gui, Main:Font, s10 Bold, Segoe UI
    Gui, Main:Add, Text, x575 y350 vStatusIndicator w220 Center cFFD700, 🟢 Загрузка...

    ; Аватар (остаётся на месте)
    Gui, Main:Add, GroupBox, vAvatarGroup x575 y380 w210 h200 cFFD700
    Gui, Main:Font, s85, Segoe UI
    Gui, Main:Add, Text, vPreviewAvatar x575 y400 w210 h160 Center cFFD700, 👨‍💼

    ; Нижние кнопки
    Gui, Main:Font, s14 Bold cWhite, Segoe UI
    Gui, Main:Add, Button, gReloadScriptFromGui x720 y25 w35 h35, 🔄
    Gui, Main:Add, Button, gSupportVK x760 y25 w35 h35, ❓
    Gui, Main:Add, Button, gExitApp x800 y25 w35 h35, ✕
    Gui, Main:Font, s11 Bold cWhite, Segoe UI
    Gui, Main:Add, Button, gSaveSettings x80 y640 w110 h40, 💾 Сохранить
    Gui, Main:Add, Button, gLoadConfigFromFile x210 y640 w110 h40, 📁 Загрузить
    Gui, Main:Add, Button, gCloseSettings x340 y640 w110 h40, 🔄 Свернуть
    Gui, Main:Add, Button, gShowInstructions x470 y640 w130 h40, 📖 Инструкция
    Gui, Main:Add, Button, gShowHotkeysInfo x620 y640 w130 h40, ⚙️ Комбинации

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
; ОКНО СИСТЕМНЫХ КОМБИНАЦИЙ (ВЫРОВНЕНО ПО ЦЕНТРУ)
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
    Gui, HotkeysGui:Add, Text, x0 y15 w500 Center gDragHotkeys cFFD700, ⌨️ Системные комбинации
    Gui, HotkeysGui:Font, s10, Segoe UI
    Gui, HotkeysGui:Add, Text, x25 y50 w450 Center cWhite, ═══════════════════════════════════════════════════════════════════════════

    ; Список команд с разделителями и цветом
    Gui, HotkeysGui:Font, s11 cWhite, Segoe UI
    Gui, HotkeysGui:Add, Text, x25 y90 cFF5555,
    Gui, HotkeysGui:Add, Text, x25 y90 cWhite,  /вып [ID] - выпустить человека с КПЗ
    Gui, HotkeysGui:Add, Progress, x25 y108 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y120 cFF5555,
    Gui, HotkeysGui:Add, Text, x25 y120 cWhite,  /лица [ID] - продать лицензию
    Gui, HotkeysGui:Add, Progress, x25 y138 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y150 cFF5555,
    Gui, HotkeysGui:Add, Text, x25 y150 cWhite,  /инф [ID] - информация о игроке
    Gui, HotkeysGui:Add, Progress, x25 y168 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y180 cFF5555,
    Gui, HotkeysGui:Add, Text, x25 y180 cWhite,  /автопрофиль - автоматическое заполнение профиля
    Gui, HotkeysGui:Add, Progress, x25 y198 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y210 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y210 cWhite,  Alt+1 - приветствие сотрудника
    Gui, HotkeysGui:Add, Progress, x25 y228 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y240 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y240 cWhite,  Alt+2 - список лицензий с ценами
    Gui, HotkeysGui:Add, Progress, x25 y258 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y270 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y270 cWhite,  Alt+3 - цена отдельной лицензии (1-7)
    Gui, HotkeysGui:Add, Progress, x25 y288 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y300 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y300 cWhite,  Alt+4 - калькулятор суммы лицензий (1-7, Backspace, Delete)
    Gui, HotkeysGui:Add, Progress, x25 y318 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y330 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y330 cWhite,  Ctrl+1 - условия адвоката
    Gui, HotkeysGui:Add, Progress, x25 y348 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y360 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y360 cWhite,  Alt+Delete - полная перезагрузка скрипта
    Gui, HotkeysGui:Add, Progress, x25 y378 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y390 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y390 cWhite,  Home - отправить /фракция
    Gui, HotkeysGui:Add, Progress, x25 y408 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y420 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y420 cWhite,  NumPad+ - установить 30 строк в чате
    Gui, HotkeysGui:Add, Progress, x25 y438 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Add, Text, x25 y450 cFFD700,
    Gui, HotkeysGui:Add, Text, x25 y450 cWhite,  NumPad- - установить 10 строк в чате
    Gui, HotkeysGui:Add, Progress, x25 y468 w450 h1 c888888 Background888888

    Gui, HotkeysGui:Font, s11 Bold cWhite, Segoe UI
    Gui, HotkeysGui:Add, Button, gCloseHotkeys x175 y500 w150 h35, 🔄 Закрыть
    Gui, HotkeysGui:Show, w500 h570, Системные комбинации
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
   if (CityList = "🛎Лас-Вентурас")
    CityCode := "LV"
else if (CityList = "🛎Сан-Фиерро")
    CityCode := "SF"
else if (CityList = "🛎Лос-Сантос")
    CityCode := "LS"
    UpdateCityName()
    IniWrite, %CityCode%, %BindIni%, Settings, City
return

; ====================================================================================================
; ОБРАБОТЧИКИ GUI
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
    Gui, InstructionsGui:Add, Text, x0 y15 w700 Center gStartInstrDrag cFFD700, 📖 Инструкция по биндерам
    Gui, InstructionsGui:Font, s10, Segoe UI
    Gui, InstructionsGui:Add, Text, x0 y50 w700 Center cWhite, ═══════════════════════════════════════════════════════════════════════════════════════
    Gui, InstructionsGui:Font, s11 cFFD700, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y90, ▸ Что такое биндер?
    Gui, InstructionsGui:Font, s10 cWhite, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y115, Биндер - это инструмент для автоматической отправки команд в чат.
    Gui, InstructionsGui:Add, Text, x25 y140, Вы нажимаете назначенную клавишу - бот отправляет заранее заданную команду.
    Gui, InstructionsGui:Font, s11 cFFD700, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y180, ▸ Как настроить?
    Gui, InstructionsGui:Font, s10 cWhite, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y205, 1. Откройте меню Биндеры (Ctrl+Alt+B)
    Gui, InstructionsGui:Add, Text, x25 y230, 2. Выберите нужную строку (№1-10 на странице)
    Gui, InstructionsGui:Add, Text, x25 y255, 3. Введите название биндера (например, "Документы")
    Gui, InstructionsGui:Add, Text, x25 y280, 4. В большое поле введите команды (по одной на строку)
    Gui, InstructionsGui:Add, Text, x25 y305, 5. Чтобы добавить задержку, напишите: time 2000 (ждёт 2 сек)
    Gui, InstructionsGui:Add, Text, x25 y330, 6. Нажмите на кнопку с клавиатурой и нажмите нужную клавишу
    Gui, InstructionsGui:Add, Text, x25 y355, 7. Поставьте галочку "Активен" и нажмите "Сохранить"
    Gui, InstructionsGui:Font, s11 cFFD700, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y395, ▸ Пример настройки:
    Gui, InstructionsGui:Font, s10 cWhite, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y420, Название: "Показать удостоверение"
    Gui, InstructionsGui:Add, Text, x25 y440, /me достал удостоверение
    Gui, InstructionsGui:Add, Text, x25 y460, time 1000
    Gui, InstructionsGui:Add, Text, x25 y480, /do Документы МВД
    Gui, InstructionsGui:Font, s11 cFFD700, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y520, ▸ Примечания:
    Gui, InstructionsGui:Font, s10 cWhite, Segoe UI
    Gui, InstructionsGui:Add, Text, x25 y545, • Нельзя использовать Ctrl+Alt+M (открытие меню)
    Gui, InstructionsGui:Add, Text, x25 y570, • Всего доступно 20 биндеров (2 страницы по 10)
    Gui, InstructionsGui:Add, Text, x25 y595, • Задержка указывается в миллисекундах (1000 = 1 секунда)
    Gui, InstructionsGui:Font, s11 Bold cWhite, Segoe UI
    ; Кнопки расположены по центру, на одинаковом расстоянии
    Gui, InstructionsGui:Add, Button, gShowLicensesOrder x180 y650 w160 h40, 📜 Поочерёдность
    Gui, InstructionsGui:Add, Button, gCloseInstructions x380 y650 w160 h40, 🔄 Закрыть
    Gui, InstructionsGui:Show, w700 h730, Инструкция
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
; ТАЙМЕРЫ GUI
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
    Gui, TimerGui:Add, Text, vTimerDragArea x25 y15 gStartTimerDrag cFFD700, ⏰ Управление таймерами
    Gui, TimerGui:Font, s10, Segoe UI
    Gui, TimerGui:Add, Text, x25 y50 cWhite, ═══════════════════════════════════════════════════════════════════
    Gui, TimerGui:Font, s11 Bold, Segoe UI
    Gui, TimerGui:Add, ListView, vTimerListView x25 y70 w450 h250 cFFD700 Background2D2D2D AltSubmit gTimerListClick, №|Команда|Интервал (сек)|Статус
    IniRead, Col1, %BindIni%, TimerListView, Col1, 40
    IniRead, Col2, %BindIni%, TimerListView, Col2, 180
    IniRead, Col3, %BindIni%, TimerListView, Col3, 100
    IniRead, Col4, %BindIni%, TimerListView, Col4, 120
    LV_ModifyCol(1, Col1)
    LV_ModifyCol(2, Col2)
    LV_ModifyCol(3, Col3)
    LV_ModifyCol(4, Col4)
    Gui, TimerGui:Font, s10 Bold cFFD700, Segoe UI
    Gui, TimerGui:Add, Text, x25 y340, ➕ Добавить новый таймер:
    Gui, TimerGui:Font, s11 cWhite, Segoe UI
    Gui, TimerGui:Add, Text, x25 y370, Команда:
    Gui, TimerGui:Add, Edit, vNewCommand x25 y395 w250 h35 cFFD700 Background000000, /time
    Gui, TimerGui:Add, Text, x290 y370, Секунды:
    Gui, TimerGui:Add, Edit, vNewSeconds x290 y395 w100 h35 cFFD700 Background000000, 30
    GuiControlGet, hTimerCmd, TimerGui:Hwnd, NewCommand
    GuiControlGet, hTimerSec, TimerGui:Hwnd, NewSeconds
    CtlColors.Attach(hTimerCmd, "2D2D2D", "FFD700")
    CtlColors.Attach(hTimerSec, "2D2D2D", "FFD700")
    Gui, TimerGui:Font, s11 Bold cWhite, Segoe UI
    Gui, TimerGui:Add, Button, gAddNewTimer x400 y395 w75 h35, ✅ Добавить
    Gui, TimerGui:Add, Button, gStartSelectedTimer x25 y460 w140 h40, ▶ Запустить
    Gui, TimerGui:Add, Button, gStopSelectedTimer x175 y460 w140 h40, ⏸ Остановить
    Gui, TimerGui:Add, Button, gRemoveSelectedTimer x325 y460 w140 h40, ❌ Удалить
    Gui, TimerGui:Add, Button, gStartAllTimersBtn x25 y515 w220 h40, 🟢 Запустить все
    Gui, TimerGui:Add, Button, gStopAllTimersBtn x255 y515 w220 h40, 🔴 Остановить все
    Gui, TimerGui:Add, Button, gCloseTimerManager x25 y570 w220 h40, 🔄 Назад к настройкам
    Gui, TimerGui:Add, Button, gSaveTimersAndRestart x255 y570 w220 h40, 💾 Сохранить и запустить
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
        status := timer.running ? "✅ Активен" : "⏸ Остановлен"
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
; БИНДЕРЫ GUI
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
    Gui, BinderGui:Add, Text, vBinderDragArea x25 y15 gStartBinderDrag cFFD700, 🔗 Управление биндерами
    Gui, BinderGui:Font, s10, Segoe UI
    Gui, BinderGui:Add, Text, x25 y50 cWhite, ═══════════════════════════════════════════════════════════════════
    Gui, BinderGui:Font, s11 Bold, Segoe UI
    Gui, BinderGui:Add, ListView, vBinderListView x25 y70 w590 h250 cFFD700 Background2D2D2D AltSubmit gBinderListClick, №|Статус|Клавиша|Название
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
    Gui, BinderGui:Add, Text, x25 y340, ✏️ Редактирование выбранного биндера:
    Gui, BinderGui:Font, s11 cWhite, Segoe UI
    Gui, BinderGui:Add, Text, x25 y365, Название биндера (отображается в списке, максимум 8 символов):
    Gui, BinderGui:Add, Edit, vEditBinderName x25 y385 w590 h30 Center cFFD700 Background000000 -E0x200 Limit8,
    Gui, BinderGui:Add, Text, x25 y425, Команды (time 2000 = задержка 2 сек):
    Gui, BinderGui:Add, Edit, vEditBinderText x25 y445 w590 h80 cFFD700 Background000000 -E0x200,
    GuiControlGet, hEditName, BinderGui:Hwnd, EditBinderName
    GuiControlGet, hEditText, BinderGui:Hwnd, EditBinderText
    CtlColors.Attach(hEditName, "2D2D2D", "FFD700")
    CtlColors.Attach(hEditText, "2D2D2D", "FFD700")
    Gui, BinderGui:Font, s11 cWhite, Segoe UI
    Gui, BinderGui:Add, Text, x170 y540, Клавиша (нажмите на кнопку и нажмите клавишу):
    Gui, BinderGui:Add, Edit, vEditBinderKeyReadOnly x250 y565 w150 h35 cFFD700 Background000000 ReadOnly Center,
    Gui, BinderGui:Add, Button, vCaptureKeyBtn gStartKeyCapture x410 y565 w35 h35, ⌨️
    Gui, BinderGui:Add, Checkbox, vCheckboxActive x470 y565 w100 h35 cFFD700, Активен
    Gui, BinderGui:Font, s11 Bold cWhite, Segoe UI
    Gui, BinderGui:Add, Button, gSaveCurrentBinder x25 y620 w140 h35, 💾 Сохранить
    Gui, BinderGui:Add, Button, gClearCurrentBinder x180 y620 w140 h35, 🗑️ Очистить
    Gui, BinderGui:Add, Button, gPrevBinderPage x335 y620 w70 h35, ◀
    Gui, BinderGui:Add, Text, vPageInfo x410 y628 w80 h25 Center cFFD700, Страница 1/2
    Gui, BinderGui:Add, Button, gNextBinderPage x495 y620 w70 h35, ▶
    Gui, BinderGui:Add, Button, gCloseBinderManager x580 y620 w35 h35, ✕
    Gui, BinderGui:Add, Button, gSaveAllBinders x25 y660 w620 h30, 💾 Сохранить все изменения
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
    GuiControl, BinderGui:, EditBinderKeyReadOnly, [Ожидание нажатия...]
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
                    keyPart := "Пробел"
                else if (keyPart = "Enter")
                    keyPart := "Enter"
                else if (keyPart = "Tab")
                    keyPart := "Tab"
                else if (keyPart = "Delete")
                    keyPart := "Delete"
                else if (keyPart = "Up")
                    keyPart := "↑"
                else if (keyPart = "Down")
                    keyPart := "↓"
                else if (keyPart = "Left")
                    keyPart := "←"
                else if (keyPart = "Right")
                    keyPart := "→"
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
; ОБЩИЕ ПОДПРОГРАММЫ
; ====================================================================================================
UpdatePreview:
    UpdatePreviewFunc()
return

UpdateCityName() {
    global CityCode, CityName
    if (CityCode = "LV")
        CityName := "Лас-Вентурас"
    else if (CityCode = "SF")
        CityName := "Сан-Фиерро"
    else if (CityCode = "LS")
        CityName := "Лос-Сантос"
    else
        CityName := "Лас-Вентурас"
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
    MsgBox, 4096, О программе,
    (
        МЭРИЯ HELPER v%ScriptVersion%

        Автор: Melanie Vanerlon
        GitHub: https://github.com/skisasa56-max/merya-helper

        При запуске автоматически проверяется наличие обновлений.
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
            status := binder.active ? "🟢" : "🔴"
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
                    keyPart := "Пробел"
                else if (keyPart = "Enter")
                    keyPart := "Enter"
                else if (keyPart = "Tab")
                    keyPart := "Tab"
                else if (keyPart = "Delete")
                    keyPart := "Delete"
                else if (keyPart = "Up")
                    keyPart := "↑"
                else if (keyPart = "Down")
                    keyPart := "↓"
                else if (keyPart = "Left")
                    keyPart := "←"
                else if (keyPart = "Right")
                    keyPart := "→"
                else if (RegExMatch(keyPart, "^F\d+$"))
                    keyPart := keyPart
                else if (StrLen(keyPart) = 1)
                    StringUpper, keyPart, keyPart
                keyDisplay := tempDisplay . keyPart
            } else
                keyDisplay := "—"
            displayName := binder.name
            if (displayName = "")
                displayName := SubStr(binder.text, 1, 27)
            if (displayName = "")
                displayName := "—"
            LV_Add("", rowNum, status, keyDisplay, displayName)
        } else
            LV_Add("", rowNum, "⚪", "—", "—")
        rowNum++
    }
return

; ====================================================================================================
; КОНТЕКСТНЫЕ ГОРЯЧИЕ КЛАВИШИ ДЛЯ АДВОКАТСКОГО МОДУЛЯ
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
        SendChat("Стоимость лицензии на " Name " - " FormattedPrice "$.")
        LicenseMenuMode := 0
    } else if (LicenseMenuMode == 2) {
        TempTotal += Price
        LastPrice := Price
        FormattedTotal := RegExReplace(TempTotal, "\G\d+?(?=(\d{3})+(?!\d))", "$0.")
        addChatMessage("{FF0000}[" Tag "] {00FF00}Добавлено: {FFFFFF}" Name ". Итого: {FFFF00}" FormattedTotal "$")
    }
return
#If WinActive("ahk_exe gta_sa.exe")

#If WinActive("ahk_exe gta_sa.exe") && (LicenseMenuMode == 2)
$Delete::
    if (LastPrice > 0) {
        TempTotal -= LastPrice
        LastPrice := 0
        FormattedTotal := RegExReplace(TempTotal, "\G\d+?(?=(\d{3})+(?!\d))", "$0.")
        addChatMessage("{FF0000}[" Tag "] {FF4500}Последнее действие отменено. {FFFFFF}Текущая сумма: {FFFF00}" FormattedTotal "$")
    }
return
$Backspace::
    if (TempTotal > 0) {
        FormattedTotal := RegExReplace(TempTotal, "\G\d+?(?=(\d{3})+(?!\d))", "$0.")
        SendChat("Общая стоимость лицензий составляет " FormattedTotal "$. Вы согласны?")
    }
    LicenseMenuMode := 0
return
#If WinActive("ahk_exe gta_sa.exe")

#If WinActive("ahk_exe gta_sa.exe") && (LicenseProcess == 2)
$Backspace::
    LicenseProcess := 3
    addChatMessage("{FF0000}[" Tag "] {00FF00}Продолжаем. {FFFFFF}Открываю меню...")
    SendChat("/и " TargetID)
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
    addChatMessage("{FF0000}[" Tag "] {FFFFFF}Продай лицензии и нажми {FFFF00}Backspace{FFFFFF} для финала.")
return
$Delete::
    LicenseProcess := 0
    addChatMessage("{FF0000}[" Tag "] {FF4500}Продажа отменена.")
return
#If WinActive("ahk_exe gta_sa.exe")

#If WinActive("ahk_exe gta_sa.exe") && (LicenseProcess == 3)
$Backspace::
    LicenseProcess := 0
    if (Gender == 1)
        SendChat("/me зафиксировал факт оплаты")
    else
        SendChat("/me зафиксировала факт оплаты")
    Sleep 1960
    SendChat("/todo Всего вам доброго*внося в электронный реестр приобретённые лицензии")
    Sleep 1960
    SendChat("*Посмотреть список лицензий можно, прописав: /лиц ID")
    Sleep 60
    SendChat("/time")
return

#If WinActive("ahk_exe gta_sa.exe")

#If WinActive("ahk_exe gta_sa.exe") && SmsSent
~$1::
    SmsSent := false
    if (Gender == 1)
        SendChat("/me закрыл дело и выключил компьютер")
    else
        SendChat("/me закрыла дело и выключила компьютер")
    Sleep 50
    SendChat("/time")
return
~$0::
    SmsSent := false
    addChatMessage("{FF0000}[" Tag "] {FFFFFF}Отмена.")
return
#If WinActive("ahk_exe gta_sa.exe")

#If WinActive("ahk_exe gta_sa.exe") && (LawyerResult > 0)
$Backspace::
    if (LawyerResult == 1) {
        SendChat("Гражданин " LawyerTargetName " успешно оправдан и выпущен на свободу. Всего хорошего, обращайтесь ещё!")
    } else if (LawyerResult == 2) {
        SendChat("К сожалению гражданин " LawyerTargetName " не получилось оправдать. Сожалею.")
    }
    LawyerResult := 0
return
$Delete::
    LawyerResult := 0
    addChatMessage("{FF0000}[" Tag "] {FFFFFF}Отмена отправки итога.")
return
#If WinActive("ahk_exe gta_sa.exe")

; ====================================================================================================
; АВТОЗАПУСК
; ====================================================================================================
LoadTimers()
LoadBinders()
LoadPrizeHistory()
StartAllTimers()
RegisterAllBinderHotkeys()
SetTimer, UpdateStatusTimer, 1000
SetTimer, CheckAutoProfile, 100
ShowMainGui()
; Сообщение о запуске, если игра активна
if WinActive("ahk_exe gta_sa.exe")
    addChatMessage("{00FF00}[" Tag "] Биндер запущен, готов к работе!")
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
; ОТСЛЕЖИВАНИЕ АКТИВНОСТИ В ИГРЕ (не требует правки SAMP.ahk)
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
    if (A_TickCount - LastActivityTime > 600000) {  ; 10 минут
        if (UserIsActive) {
            UserIsActive := 0
            UpdateStatusAndTime()
        }
    }
return

; ====================================================================================================
; ОКНО СПИСКА ЛИЦЕНЗИЙ (ДЛЯ ПООЧЕРЁДНОСТИ) - УВЕЛИЧЕНО И ВЫРОВНЕНО
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
    Gui, LicensesOrderGui:Add, Text, x0 y15 w500 Center gDragLicensesOrder cFFD700, 📜 Список лицензий (поочерёдность)
    Gui, LicensesOrderGui:Font, s10, Segoe UI
    Gui, LicensesOrderGui:Add, Text, x0 y50 w500 Center cWhite, ═══════════════════════════════════════════════════════════
    Gui, LicensesOrderGui:Font, s12 cFFD700, Segoe UI
    Gui, LicensesOrderGui:Add, Text, x25 y90, 1. Лицензия на наземным транспортом (400$)
    Gui, LicensesOrderGui:Add, Text, x25 y125, 2. Лицензия на ношение оружия (125.000$)
    Gui, LicensesOrderGui:Add, Text, x25 y160, 3. Лицензия на водный транспорт (25.000$)
    Gui, LicensesOrderGui:Add, Text, x25 y195, 4. Разрешение на полёты на джетпаку (5.000$)
    Gui, LicensesOrderGui:Add, Text, x25 y230, 5. Разрешение на выполнение высотных полетов (15.000$)
    Gui, LicensesOrderGui:Add, Text, x25 y265, 6. Лицензия на воздушный транспорт (30.000$)
    Gui, LicensesOrderGui:Add, Text, x25 y300, 7. Лицензия на покупку бизнеса (250.000$)
    Gui, LicensesOrderGui:Font, s11 Bold cWhite, Segoe UI
    ; Кнопка "Закрыть" по центру
    Gui, LicensesOrderGui:Add, Button, gCloseLicensesOrder x175 y360 w150 h35, 🔄 Закрыть
    Gui, LicensesOrderGui:Show, w500 h450, Список лицензий
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

; ====================================================================================================
; ForceOpenMainGui (ОТКРЫТИЕ ОКНА ПРИ ЗАПУСКЕ)
; ====================================================================================================
ForceOpenMainGui:
    ; Если окно игры активно (развёрнуто), не показываем главное окно, оставляем скрипт в трее
    if WinActive("ahk_exe gta_sa.exe")
        return
    ShowMainGui()
    WinShow, ahk_id %MainGuiHwnd%
    WinRestore, ahk_id %MainGuiHwnd%
    WinActivate, ahk_id %MainGuiHwnd%
return
