WatchFBMessages:
  if (InitialFBCheck = 0)
    SetTimer, WatchFBMessages, 500
  if (InitialFBCheck < 21)
    InitialFBCheck++
  fbMessages := ""
  fbMessages := wbfb.document.querySelector("#notificationsCountValue")

  if (fbMessages != "" && fbMessages.textContent != 0) {
    GuiControl,, Facebook, %A_ScriptDir%\Widgets\facebook\facebooknew.png
    num := fbMessages.textContent
    GuiControl, Move, NumberOfFBMessages, w12 h12
    GuiControl,, NumberOfFBMessages, % num
  } else {
    GuiControl,, Facebook, %A_ScriptDir%\Widgets\facebook\facebook.png
    GuiControl, Move, NumberOfFBMessages, w0 h0
    GuiControl,, NumberOfFBMessages,
  }
  if (InitialFBCheck = 20)
    SetTimer, WatchFBMessages, 60000
  if (InitialFBCheck = 21)
    wbfb.navigate("http://www.facebook.com")
Return

CheckFBMessages:
  GuiControl,, Facebook, %A_ScriptDir%\Widgets\facebook\facebook.png
  GuiControl, Move, NumberOfFBMessages, w0 h0
  GuiControl,, NumberOfFBMessages,
;  Run, C:\Users\chris.stanley\AppData\Local\Vivaldi\Application\vivaldi.exe https://www.reddit.com/message/inbox/
Return

FacebookMessages:
  Run, C:\Users\chris.stanley\AppData\Local\Vivaldi\Application\vivaldi.exe https://www.facebook.com
return

QuitFB:
  wbfb.quit()
Return