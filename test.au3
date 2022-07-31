#RequireAdmin
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Tesseract.au3>
#include <File.au3>
#include <FileConstants.au3>

$token = ""
If FileExists("token.txt") == 1 Then
	$tokenFile = FileOpen("token.txt", 0)
	While 1
		$line = FileReadLine($tokenFile)
		If @error = -1 Then ExitLoop
		$token = $line
	WEnd
	FileClose($tokenFile)
;~ 	MsgBox(0, '', 'Line token in(token.txt):' & $token)
Else
	MsgBox(0, '', 'Line token in(token.txt) not found')
	Exit
EndIf

$comName = @ComputerName

Local $sCoords[4]
$sCoords[0] = 240
$sCoords[1] = 110
If $comName == "DESKTOP-DRGSMAA" Then
	$sCoords[2] = 450
	$sCoords[3] = 400
ElseIf $comName == "DESKTOP-S1LHRJQ" Then
	$sCoords[0] = 240
	$sCoords[1] = 115
	$sCoords[2] = 500
	$sCoords[3] = 420
Else
	$sCoords[2] = 470
	$sCoords[3] = 410
EndIf
$lastBoss = ""
;Please note that these examples might not work as the match pictures have to be found with the exact same size on your screen.

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Boss Notify", 250, 70, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")
$btnStartStop = GUICtrlCreateButton("Start", 168, 8, 75, 25)
GUICtrlSetOnEvent(-1, "btnStartStopClick")
$btnOCR = GUICtrlCreateButton("OCR", 168, 38, 75, 25)
GUICtrlSetOnEvent(-1, "btnOCRClick")
$ComboVM = GUICtrlCreateCombo("", 16, 8, 145, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetOnEvent(-1, "ComboVMChange")
$Combo1 = GUICtrlCreateCombo("", 16, 38, 145, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetOnEvent(-1, "Combo1Change")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Local $vmList = "Blue|LD"

GUICtrlSetData($ComboVM, $vmList)

Global $start = False




While 1
	Sleep(5000)
	If $start == True Then
		btnOCRClick()
	EndIf
WEnd

Func writeTextTofile($msg)
	; Create file in same folder as script
	$sFileName = @ScriptDir &"\boss_log.txt"

	; Open file - deleting any existing content
	$hFilehandle = FileOpen($sFileName, $FO_APPEND)

	; Prove it exists
	If FileExists($sFileName) Then
		; Append a line
		FileWrite($hFilehandle, @CRLF & $msg)
	Else
		; Write a line
		FileWrite($hFilehandle, $msg)
	EndIf

	; Close the file handle
	FileClose($hFilehandle)
EndFunc

Func lineNotify($message)

	$url = 'curl.exe -i  -X POST "https://notify-api.line.me/api/notify" --header "Content-Type:application/x-www-form-urlencoded" --header "Authorization: Bearer '&$token&'"  -d "message='&$message&'" '

	Dim $iPidCurl = Run($url, @ScriptDir, @SW_HIDE,2+4)
	Dim $sOut
	While 1
		$sOut &= StdoutRead($iPidCurl)
		If @error Then ExitLoop
	WEnd
	While 1
		$sOut &= StderrRead($iPidCurl)
		If @error Then ExitLoop
	WEnd
	ConsoleWrite($sOut&@LF&"*********"&@LF)

EndFunc

Func btnStartStopClick()
	If $start == True Then
		$start = False
		ConsoleWrite(@LF&"STOP"&@LF)
		GUICtrlSetData($btnStartStop, "START")
	ElseIf $start == False Then
		$start = True
		ConsoleWrite(@LF&"START"&@LF)
		GUICtrlSetData($btnStartStop, "STOP")
	EndIf
EndFunc
Func _CheckAllWords(Const $sMainString, Const $asArray_Substrings)
If Not IsArray($asArray_Substrings) Then Return SetError(1, 0, -1)

Local $fRet = 1
;Very easy solution this way
For $i = 0 To UBound( $asArray_Substrings) -1
$fRet = BitAND( $fRet, StringRegExp( $sMainString, $asArray_Substrings[$i] ))
Next
Return $fRet
EndFunc   ;==>_StringInStrEx
Func btnOCRClick()
	Local $selected = GuiCtrlRead($Combo1)

	; Get OCR Text without Line Breaks


;~ 	_MarkMatch($sCoords)
;~ 	WinActivate($selected)
	;$pos = WinGetPos("Screenshot_20220727-134833.png ‎- Photos")
;~ 	$pos = WinGetClientSize("ROX-Beer")
;~ 	$leftPercent = 68.3
;~ 	$topPercent = 73.3
;~ 	$rightPercent = 34
;~ 	$botPercent = 2.5
;~ 	$left = Floor($pos[0]-($pos[0]*$leftPercent/100))
;~ 	$top = Floor($pos[1]-($pos[1]*$topPercent/100))
;~ 	$right = Floor($pos[0]-($pos[0]*$rightPercent/100))
;~ 	$bot = Floor($pos[1]-($pos[1]*$botPercent/100))
;~ 	;240
;~ 	ConsoleWrite(@LF&"$left: "&$left&@LF)
;~ 	;115
;~ 	ConsoleWrite(@LF&"$top: "&$top&@LF)
;~ 	;500
;~ 	ConsoleWrite(@LF&"$right: "&$right&@LF)
;~ 	;420
;~ 	ConsoleWrite(@LF&"$bot: "&$bot&@LF)
	;_ArrayDisplay($pos)
	$hTimer = TimerInit()
	; Screenshot_20220727-134833.png ‎- Photos
	;~ 	$sOCRTextResult = 'MVP/Mini: Kraken'
	;~ 	$sOCRTextResult = _TesseractScreenCapture(0, "", 1, 2, 191, 80, 350,200, 0)

	;$sOCRTextResult = _TesseractWinCapture("Screenshot_20220727-134833.png ‎- Photos","",0, "", 1, 6, $left, $top, $right, $bot, 0)
	;$sOCRTextResult = _TesseractWinCapture($selected,"",0, "", 1, 6, $left, $top, $right, $bot, 0)
	$sOCRTextResult = _TesseractWinCapture($selected,"",0, "", 1, 6, $sCoords[0], $sCoords[1], $sCoords[2], $sCoords[3], 0)
	ConsoleWrite("Time Elapsed: " & TimerDiff($hTimer)& $sOCRTextResult & @CRLF)
	Local $sString = 'MVP/Mini: Kraken'
	Local $bossFullNameList[] = ["Phreeoni","Mistress","Eddga","Kraken","Orc Hero","Pharaoh","Orc Lord","Eclipse","Dragon Fly","Mastering","Ghostring","King Dramoh","Toad","Deviling","Angeling","Vagabond Wolf","Dark Priest", "Amon Ra"]
	Local $bossList[] = ["Phre","Mist","Edd","Kra","Hero","Phar","Lord","Eclip","Fly","Mas","Ghost","King","Toad","Devil","Angel","Wolf","Priest", "Amon"]
	Local $miniPosition = StringInStr(	$sOCRTextResult, "Mini")
	Local $mvpPosition = StringInStr(	$sOCRTextResult, "MVP")
	Local $abyssPosition = StringInStr(	$sOCRTextResult, "Abys")
	If ($miniPosition > 0 Or $mvpPosition > 0) And $abyssPosition == 0 Then
		For $i = 0 To UBound($bossList)-1 Step +1
			Local $bossPosition = StringInStr(	$sOCRTextResult, $bossList[$i])
			If $bossPosition > 0 And $bossFullNameList[$i] <> $lastBoss Then
				$hTimer = TimerInit()
				lineNotify($bossFullNameList[$i]&" Refreshing soon")
				$lastBoss = $bossFullNameList[$i]
				writeTextTofile($sOCRTextResult)
				ConsoleWrite("Time Elapsed lineNotify: " & TimerDiff($hTimer)& $bossPosition & @CRLF)
			Else
				ConsoleWrite(@LF&$sOCRTextResult&@LF)
			EndIf
		Next
	Else
		ConsoleWrite(@LF&$sOCRTextResult&@LF)
	EndIf





EndFunc
Func Combo1Change()

EndFunc
Func ComboVMChange()

	Local $selected = GuiCtrlRead($ComboVM)
	ConsoleWrite("$selected: " & $selected & @CRLF)
	Local $winList = ""
	GUICtrlSetData($Combo1, $winList)
	If $selected == "LD" Then
		$winList = WinList("[CLASS:LDPlayerMainFrame]")
		;~ Local $pidList = ProcessList("LdVBoxHeadless.exe")
		For $i = 1 To $winList[0][0] Step +1
			GUICtrlSetData($Combo1, $winList[$i][0], $winList[1][0])
		Next
	ElseIf $selected == "Blue" Then
		$winList = WinList("[CLASS:Qt5154QWindowOwnDCIcon]")
		For $i = 1 To $winList[0][0] Step +1
			GUICtrlSetData($Combo1, $winList[$i][0], $winList[1][0])
		Next
	EndIf
EndFunc
Func Form1Close()
	Exit
EndFunc
Func Form1Maximize()

EndFunc
Func Form1Minimize()

EndFunc
Func Form1Restore()

EndFunc
