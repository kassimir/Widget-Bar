;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                          ;
;                      GLOBAL SETTINGS                     ;
;                                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Keep the script running
#Persistent
; Ensure it's the only version running
#SingleInstance, Force
; Used for all my window management scripts
CoordMode, Mouse, Screen
; Used for various things that rely on Window Title
SetTitleMatchMode, 2

clicker := false
interactor := false
zchester := false

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;               GROUP - NO FOREIGN CHARACTERS              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The purpose of this group is to not utilize the foreign language
; hotkeys I've got, because then they can fuck stuff up or they
; can impede other hotkeys from firing
; Guild Wars
GroupAdd, EnglishOnly, Guild Wars
; Guild Wars 2
;GroudAdd, EnglishOnly, ahk_exe Gw2-64.exe
; Morrowind
GroupAdd, EnglishOnly, ahk_exe Morrowind.exe
; SciTE4AutoHotkey
GroupAdd, EnglishOnly, ahk_exe SciTE.exe
; SF Fed Timesheet
GroupAdd, EnglishOnly, Welcome to AccelerationVMS
; Wizard101
GroupAdd, EnglishOnly, Wizard101 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     GUILD WARS LOGINS                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main account
::gwc::gw@chris.im{tab}Lawliet13{enter}
; Middy
::gwm::middy@chris.im{tab}Lawliet13{enter}
; Rory's account
::gwr::roryliberty@gmail.com{tab}kcitsmoob{enter}

return

::lpr::https://www.linkedin.com/in/cstanmo/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                       RELOAD SCRIPT                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
!space::reload

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                          ;
;                       MOUSE BUTTONS                      ;
;                                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Per Razer Synapse, using a Naga Trinity mouse with the 12
; button side panel, each button send Shift + F[number on button]
; Obviously, using the keyboard combo also works
; TODO: Remove redundant code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                      1 - MOVE WINDOW                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+F1::
  ; Move the window with zero delay... otherwise it looks laggy and gross
  SetWinDelay, 0
  ; Get Mouse position and Window under mouse
  MouseGetPos, mousestartX, mousestartY, mousewin
  ; Activate window
  WinActivate, ahk_id %mousewin%
  ; Get Window position  
  WinGetPos, winstartX, winstartY,,, ahk_id %mousewin%
  ; Watch the mouse move, and follow it with the window
  Loop
  {
    ; Check "virtual" state of Shift key
    if !GetKeyState("Shift")
      ; If it's not pressed (via Razer software) then stop looping
      break
    ; Get new mouse position
    MouseGetPos, newmouseX, newmouseY
    ; Configure offset amount for x
    offsetX := newmouseX - mousestartX
    ; Configure offset amount for y
    offsetY := newmouseY - mousestartY
    ; Configure new window x position based on offset
    newwindowX := winstartX + offsetX
    ; Configure new window y position based on offset
    newwindowY := winstartY + offsetY
    ; Move the window
    WinMove, ahk_id %mousewin%,, %newwindowX%, %newwindowY%
    ; Set the old starting coordinates to the new coordinates
  }
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     2 - RESIZE WINDOW                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+F2::
  ; Move the window with zero delay... otherwise it looks laggy and gross
  SetWinDelay, 0
  ; Get Mouse position and Window under mouse
  MouseGetPos, mousestartX, mousestartY, mousewin
  ; Activate window
  WinActivate, ahk_id %mousewin%
  ; Get Window position  
  WinGetPos,,, winstartW, winstartH, ahk_id %mousewin%
  ; Watch the mouse move, and follow it with the window
  Loop
  {
    ; Check "virtual" state of Shift key
    if !GetKeyState("Shift")
      ; If it's not pressed (via Razer software) then stop looping
      break
    ; Get new mouse position
    MouseGetPos, newmouseX, newmouseY
    ; Configure offset amount for x
    offsetX := newmouseX - mousestartX
    ; Configure offset amount for y
    offsetY := newmouseY - mousestartY
    ; Configure new window x position based on offset
    newwindowW := winstartW + offsetX
    ; Configure new window y position based on offset
    newwindowH := winstartH + offsetY
    ; Move the window
    WinMove, ahk_id %mousewin%,,,, %newwindowW%, %newwindowH%
    ; Set the old starting coordinates to the new coordinates
  }  
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                3 - MAXIMIZE/RESTORE WINDOW               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
+F3::
  getWin()
  WinGet, mm, MinMax, A
  if (mm)
    WinRestore, A
  else
    WinMaximize, A
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                       4 - CLOSE TAB                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+F4::
  getWin()
  Send, {LCtrl Down}{F4}{LCtrl Up}
return


+F6::
  getWin()
  WinMinimize, A
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                          ;
;                       BUTTON COMBOS                      ;
;                                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                CLOSE WINDOW (WINDOWS + 1)                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Closes window
#+F1::
  ; Get window
  win := getWin()
  ; Close window
  WinClose, ahk_id %win%
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                          ;
;                   GENERAL FUNCTIONALITY                  ;
;                                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                        AOT TOGGLE                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WHEN TOGGLING ON, UPDATES NAME TO 'ALWAYS ON TOP -'
; REMOVES THAT WHEN TOGGLING OFF
; NOTE: THIS SOMETIMES ONLY EFFECTS THE TASKBAR BUTTON 
; AND NOT THE WINDOW ITSELF
^!LButton::
  ; Get window under mouse
  MouseGetPos, x, y, win    
  ; Activate window
  WinActivate, ahk_id %win%
  ; Toggle Always On Top
  WinSet, AlwaysOnTop, Toggle, A    
  ; Get window title
  WinGetActiveTitle, WinTitle  
  ; Check Window title for "ALWAYS ON TOP - "
  TitleCheck := SubStr(WinTitle, 1, 16)  
  ; If it's there, remove it
  if (TitleCheck = "ALWAYS ON TOP - ") {
    ; Create new string sans "ALWAYS ON TOP - "
    NewTitle := SubStr(WinTitle, 17)
    ; Set new title
    WinSetTitle, A,, %NewTitle%
  } else {
    ; Check Always On Top status of window
    WinGet, ExStyle, ExStyle, A    
    ; If Always On Top
    if (ExStyle & 0x8)
      ; Set window title to have "ALWAYS ON TOP - "
      WinSetTitle, A,, ALWAYS ON TOP - %WinTitle%    
  }
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                       SCREEN SHADER                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FINDS ALL MONITORS AND CREATES A GUI TO COVER THEM
; IT'S A CLICK-THROUGH GUI, SO IT ONLY SERVES AS SHADE
; TODO: ADD A SLIDER OF SOME KIND TO ADJUST THE LIGHT/DARKNESS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SCREEN SHADER (CREATE)                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
trans := 0
+^F8::
trans := 255
^F8::
  trans := trans ? trans : 175
  ; Find number of monitors
  SysGet, monNum, MonitorCount
  ; Loop through them
  Loop, % monNum
  {
    ; Find specific monitor
    SysGet, mon, Monitor, %A_Index%
    ; Figure out its width
    width := monRight - monLeft
    ; Just in case it's ever a negative number
    if (width < 0) 
      ; Convert to positive one!
      width := width * -1
    ; Figure out its height
    height := monTop - monBottom
    ; Just in case it's ever a negative number
    if (height < 0)
      ; Convert to a positive one!
      height := height * -1
    ; Call function to build a gui for that specific monitor
    buildGui(monLeft, monTop, width, height, A_Index, trans)
  }
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  SCREEN SHADER (DESTROY)                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
^F9::
  IfWinActive, Guild Wars 
  {
    SendInput, {F9}
    return
  }
  ; Find number of monitors
  SysGet, monNum, MonitorCount
  ; Loop through them
  Loop, % monNum
  {
    ; Create name that correlates to gui creation
    gname := "gui" A_Index
    ; Destroy it
    Gui, %gname%:Destroy
  }
  trans := 0
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                       WINDOW RESET                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WITH ALL MY MONITOR MOVING AROUND, SOMETIMES WINDOWS 
; WANDER OFF INTO THE NETHER, SO THIS SCRIPT MOVES IT BACK
; TO THE CORNER OF THE MAIN MONITOR... 
; NOTE: WINDOW MUST BE THE ACTIVE WINDOW TO WORK
;^0::
;^Numpad0::
;  WinGet, id, ID, A
;  WinMove, ahk_id %id%,, 0, 0
;  WinSet, Transparent, 255, A
;return
;^1::
;^Numpad1::
;  WinGet, id, ID, A
;  WinMove, ahk_id %id%,, 3841, 0
;  WinSet, Transparent, 255, A
;return
^5::
^Numpad5::
  MouseGetPos, mx, my
  WinGet, id, ID, A
  WinMove, ahk_id %id%,, %mx%, %my%
  WinSet, Transparent, 255, A
return
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                        WINDOW INFO                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DISPLAY INFORMATION FROM A WINDOW:
;   TITLE
;   X (POSITION)
;   Y (POSITION)
;   WIDTH
;   HEIGHT
;   TRANSPARENCY VALUE
^Ins::
  WinGet, wpid, PID, A
  WinGet, wid, ID, A
  WinGetPos, wx, wy, ww, wh, ahk_id %wid%
  WinGetTitle, title, ahk_id %wid%
  WinGet, wt, Transparent, ahk_id %wid%
  MsgBox, 0, %title%, % "PID: " wpid "`nID: " wid "`nx: " wx "`ny: " wy "`nwidth: " ww "`nheight: " wh "`nTrans: " wt
return

; GINA GET DAT BITCH
; 501.831.9014
;~ ^Numpad2::
  ;~ WinGet, ctrls, ControlList, A
  ;~ MsgBox, Ok
  ;~ Loop, Parse, ctrls, `n
  ;~ {
    ;~ MsgBox, 4,, Control #%A_Index% is "%A_LoopField%". Continue?
    ;~ IfMsgBox, No
      ;~ break
  ;~ }
;~ return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                REMOVE APPLICATION CONTROL                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WINDOWS + RIGHT CLICK WILL HIDE A CONTROL ON AN APPLICATION
; BE VERY CAREFUL, BECAUSE THIS IS A VERY POWERFUL FEATURE
;#RButton::
;  MouseGetPos, ,, win, ctrl
;  Control, Hide,, %ctrl%, ahk_id %win%
;  MsgBox, % "win: " win "`nctrl: " ctrl " removed"  
;return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                         POLYGLOT                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Holding / and a chosen letter will show an alert to send an
; alternate version of that letter. Chooses uppercase or lowercase.
; Also defaults to first option if anything other than another
; number is chosen.

#IfWinNotActive, ahk_group EnglishOnly

:?*:a::
  switchFn(["Á", "À", "Â", "Ä"], ["á", "à", "â", "ä"], ["A", "a"])
return

:?*:c::
  switchFn(["Ç"], ["ç"], ["C", "c"])
return

:?*:e::
  switchFn(["É", "È", "Ê", "Ë"], ["é", "è", "ê", "ë"], ["E", "e"])
return

:?*:i::
  switchFn(["Í", "Ì", "Î", "Ï"], ["í", "ì", "î", "ï"], ["I", "i"])
return

:?*:n::
  switchFn(["Ñ"], ["ñ"], ["N", "n"])
return

:?*:o::
  switchFn(["Ó", "Ò", "Ô", "Ö", "Œ"], ["ó", "ò", "ô", "ö", "œ"], ["O", "o"])
return

:?*:s::
  switchFn(["ß"], ["ß"], ["S", "s"])
return

:?*:u::
  switchFn(["Ú", "Ù", "Û", "Ü"], ["ú", "ù", "û", "ü"], ["U", "u"])
return
 
::madres::madre
:?*://?::¿
:?*://!::¡

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                          ;
;                         FUNCTIONS                        ;
;                                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                     BUILD MONITOR GUI                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BUILDS/SHOWS A GUI FOR A SPECIFIC SIZE AND POSITION
; USED IN A FUNCTION TO BE ITERATIVE (SEE SCREEN SHADER)
; x: number
;   x position for gui
; y: number
;   y position for gui
; w: number
;   width of gui
; h: number
;   height of gui
; nm: number
;   number to be added to name for window purpose
buildGui(x, y, w, h, nm, t := 150)
{
  ; Create unique name for gui
  gname := "gui" nm
  ; Set properties of gui:
  ;   +AlwaysOnTop speaks for itself
  ;   -Caption removes title bar
  ;   +ToolWindow oddly enough removes taskbar button
  ;   +E0x20 allows the gui to be click-through
  ;   +LastFound Makes it the last found window for the Winset operation
  Gui, %gname%:+AlwaysOnTop -Caption +ToolWindow +E0x20 +LastFound
  ; Set color: 000000 is black
  Gui, %gname%:Color, 000000
  ; Show it with the options given
  Gui, %gname%:Show, x%x% y%y% w%w% h%h%, %gname%
  ; Set the transparency.... this might be an option later
  Winset, Trans, %t%
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  GET WINDOW UNDER MOUSE                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Grabs the ahk_id of the window under the mouse and returns
; it. Also activates that window. This functionality is use
; A LOT, so I figured I'd just make it a function
getWin()
{
  MouseGetPos,,, w
  WinActivate, ahk_id %w%
  return %w%
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                      POLYGLOT SWITCH                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This is fed an array of options, displays those options
; then waits for input to select one of those options
switchFn(upper, lower, dflt)
{
  ; Check to see if we want to just send the normal key or the hotkey
  default := GetKeyState("/", "P") ? 0 : 1
  
  ; Evaluate shift state
  shiftDown := GetKeyState("Shift", "P")
  ; Evaluate caps state
  capsOn := GetKeyState("CAPSLOCK", "T")
  ; Check if both are on, because they counter each other in Windows
  bothOn := shiftDown && capsOn
  ; If they're both on, it's like they're both off
  if (bothOn)
    ; Ensure AHK knows that
    sendUpper := 0
  ; Otherwise, let's capitalize
  else if (capsOn || shiftDown)
    ; Set it accordingly
    sendUpper := 1
  ; Other otherwise, let's not capitalize
  else
    ; Set it accordingly
    sendUpper := 0
  
  ; If we're to send it uppercase...
  if (sendUpper) {
    ; If we're sending normal key
    if (default) {
      ; Send uppercase
      Send % dflt[1]
      ; Leave function
      return
    ; For the ones with only one option
    } else if (upper.maxIndex() = 1) {
      ; Send that option
      Send % "{backspace}" upper[1]
      ; Leave function
      return
    }
    ; Otherwise, let's capitalize
    opts := upper
  ; Otherwise...
  } else {
    ; If we're sending normal key
    if (default) {
      ; Send lowercase
      Send % dflt[2]
      ; Leave function
      return
    } else if (lower.maxIndex() = 1) {
      ; Send that option
      Send % "{backspace}" lower[1] 
      ; Leave function
      return
    }
    ; Otherwise, we don't capitalize
    opts := lower
  }
  
  ; If we've decided we're going to be using the menu, then clear the variables
  ; Clear the Splashtext text
	splashtext := ""
  ; Clear the height
	splashheight := 0  
  
	; Start looping over the array to build text
	Loop, % opts.maxIndex()
	{
    ; Add text from array
		splashtext .= A_Index ":" opts[A_Index] "`n"
    ; Add height to the splashtext based on amount of options in array
		splashheight += 20
	}
  ; Send the information to the alert function
  alert(splashtext, {height: splashheight, title: "Awaiting Key Selection", width: 50, time: "i"})
  ; Await input
	Input, selection, L1
  ; Turn off SplashText once input is done
	SplashTextOff
  ; Remove the / hotkey trigger
  Send {backspace}
  ; Check if input is a number selection
	if selection is integer
    ; If it is then set the 's' variable
    s := opts[selection]
  ; Otherwise
  else
    ; Set it to the first option
    s := opts[1]
  ; Send the 's' variable
  Send, %s%
  ; The point in this is that if the input was NOT a number, 
  ; then it's to continue typing, so this sends the input value
  if selection is not integer
    ; Send the input value
    Send, %selection%
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                           ALERT                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TODO: Move this to its own file
; This pops up a SplashTextOn window, typically for troubleshooting
; other scripts, and it's non-blocking, so it won't stop the script
; Options:
;   width: number
;     width of text box
;   height: number
;     height of text box
;   title: string
;     title of text box
;   time: number (1000 = 1 second)
;     display time before closing
;   mouse: true/false (1/0)
;     set position of text box where the mouse is
alert(msg := "ALERT!", options := false)
{
  ; Set default opts, because AHK doesn't allow object defaults in functions
  ; All options are posted above
  opts := {width: 180, height: 50, title: "Prompt", time: 2000, mouse: 1}
  width := options.width ? options.width : opts.width
  height := options.height ? options.height : opts.height
  title := options.title ? options.title : opts.title
  time := options.time ? options.time : opts.time
  mouse := options.mouse ? options.mouse : opts.mouse
  ; Turn on the splash text with the options
  SplashTextOn, %width%, %height%, %title%, %msg%
  ; If 'mouse' option is true
  if (mouse) {
    ; Get mouse position
    MouseGetPos, mx, my
    ; Move alert message to the mouse position
    WinMove, %title%,, %mx%, %my%
  }
  ; "i" means "infinite" meaning don't set to turn off SplashText
  if (time != "i")
    ; Non-blocking way to turn off text
    SetTimer, TurnOffAlert, %time%
}

; Label to turn off the splash text box
TurnOffAlert:
  ; Turn it off
  SplashTextOff
  ; Turn off the timer, so it doesn't keep trying to turn off
  ; splash text that doesn't even exist any more (remove mem leak)
  SetTimer, TurnOffAlert, Off
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                          ;
;                     PROGRAM SPECIFIC                     ;
;                                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                           SCITE                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#IfWinActive, SciTE4AutoHotkey
; Set initial value
subheader := 0
::newsubheader::
  ; Change to 1 if subheader
  subheader := 1
::newheader::
  ; Length of the header line
  linelength := 60
  ; Length of spaces in the header
  spaceamount := 58
  
  ; Get Scite's Position
  WinGetPos, wx, wy, ww, wh, SciTE4AutoHotkey
  ; Calculate coordinates for input box
  ibx := wx + (ww / 2) - 75
  iby := wy + (wh / 2) - 90
  ; Pop up Input box to get title of header
  InputBox, title,, Name,, 180, 150, %ibx%, %iby%
  ; Capitalize it, because we're civilized in here
  StringUpper, title, title
  ; Calculate header line length from input
  strlng := StrLen(title)
  ; Find out if it's even or odd in length
  odd := Mod(strlng, 2)
  ; Use that info to configure the amount of space to be used in order to center it
  ; Left side of title spaces
  titlespace1 := odd ? (spaceamount - strlng + 1) / 2 : (spaceamount - strlng) / 2
  ; Right side of title spaces
  titlespace2 := (spaceamount - strlng) / 2
  ; Begin the semicolons!
  Send {; %linelength%}{enter}
  ; If it's not a subheader...
  if (!subheader)
    ; Add the extra block
    Send {;}{space %spaceAmount%}{;}{enter}
  ; Send the title with it's mathematically-configured spaces
  Send {;}{space %titlespace1%}%title%{space %titlespace2%}{;}{enter}
  ; If it's not a subheader...
  if (!subheader)
    ; Add the extra block
    Send {;}{space %spaceAmount%}{;}{enter}
  ; Final line
  Send {; %linelength%}{enter}
  ; reset value
  subheader := 0
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                            GW                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*
#IfWinActive, Guild Wars
!1::
  interactor := !interactor
  if (interactor)
    SetTimer, InteractLabel, 3000
return

!2::
  clicker := !clicker
  if (clicker) {
    log("Starting Clicker")
    SetTimer, ClickLabel, 250
  }
return

!3::
  CoordMode, Mouse, Screen

  zchester := !zchester
  if (zchester)
    SetTimer, ZChestClicker, 5000
  else
    SetTimer, ZChestClicker, Off
return

lootCheck := 0

!b::
  active := "loot"

  if !gwImg("zaishen")
    active := "z"
  else if !gwImg("gtob")
    active := "g"
  else if !gwImg("obby")
    active := "o"
MsgBox, % active
return

ZChestClicker:
  SendRaw, '
  active := "loot"
  log("Active set to 'loot'")

  if !gwImg("zaishen") {
    active := "z"
    log("Zaishen Chest active")
  } else if !gwImg("temple") {
    active := "g"
    log("Great Temple of Balthazar active")
  } else if !gwImg("obby") {
    active := "o"
    log("Obelisk Flag Stand active")
  }

  if (active = "loot") {
    log("Loot still active. Collecting")
    Send, {space}
    Sleep, 1000
    Send, {space}
    Sleep, 1000
    Send, {space}
    SetTimer, ZChestClicker, 2000
  }
  
  if (active = "g" || active = "o") {
    log("Cycling selection")
    SendRaw, '
    SetTimer, ZChestClicker, 2000
  }

  if (active = "z") {
    if (!lootCheck) {
      log("Loot check failed. Setting true and cycling selection")
      lootCheck := 1
      SetTimer, ZChestClicker, 2000
    } else {
      log("Loot check successful. Opening Zaishen Chest and restarting label")
      lootCheck := 0
      Send, {space}
      SetTimer, ZChestClicker, 2000
    }
  }
return

log(msg)
{
  msg := "`n" A_Hour ":" A_Min ":" A_Sec " - " msg
  FileAppend, %msg%, C:\ahk\ahk.log
}

gwImg(img)
{
  img := "C:\ahk\" img ".png"
  ImageSearch, FoundX, FoundY, 2200, 900, 2800, 1200, *30 %img%
  return ErrorLevel
}


InteractLabel:
  Send, {Space}
  if !interactor
    SetTimer, InteractLabel, Off
return

ClickLabel:
  if WinActive("Guild Wars")
    Click
  if !clicker
    SetTimer, ClickLabel, Off
return
*/
