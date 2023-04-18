
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 11 - WINDOW TRANSPARENCY                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This will trigger the ability to change a window's
; transparency by using the Scroll Wheel but only for
; a certain amount of time. Min transparency is 150
; TODO: Gui for displaying Trans Value

; Toggle for mouse wheel
setWindowTrans := false
; Mouse button actually only turns on the trans ability
; And also sets timer to turn it off
+F11::
  ; Turn on trans
  setWindowTrans := true
  ; Begin turn off timer
  SetTimer, TurnOffTrans, 2000
return

; Set up hotkey for trans
WheelDown::
  ; If trans isn't activated
  if (!setWindowTrans) {
    ; Send mouse wheel
    Send, {WheelDown}
    ; And return
    return
  }
  ; Call window trans function
  setTransVal("down")
return

; Set up hotkey for trans
WheelUp::
  ; If trans isn't activated
  if (!setWindowTrans) {
    ; Send Wheel Up
    Send, {WheelUp}
    ; And return
    return
  }
  ; Call window trans function
  setTransVal("up")
return

; Function that does the trans work
setTransVal(direction)
{
  ; Get window
  win := getWin()
  ; Get window trans value
  WinGet, winTransVal, Transparent, ahk_id %win%
  ; If wheel up, add to trans
  if (direction = "up")
    winTransVal += 15
  ; Otherwise, subtract from trans
  else
    winTransVal -= 15
  ; If it's less than CONSTANT
  if (winTransVal < MIN_WINDOW_TRANS)
    ; Set to CONSTANT
    winTransVal := MIN_WINDOW_TRANS
  ; If it's more than maximum amount
  if (winTransVal > 255)
    ; Set it to maximum amount (Side note: Windows won't allow
    ; trans to go higher than 255, so this isn't necessary, but
    ; I like error-handling
    winTransVal = 255
  ; Set window trans to new value
  WinSet, Transparent, %winTransVal%, ahk_id %win%
  ; Display trans in Tooltip {
  ToolTip, Transparency: %winTransVal%
  ; Set timer to turn off functionality (shorter than original)
  SetTimer, TurnOffTrans, 750
}

; Label/Timer to turn off trans functionality
TurnOffTrans:
  ; Turn off trans functionality
  setWindowTrans := false
  ; Reset default trans direction
  transDirection := "up"
  ; Turn off Tooltip
  ToolTip
return
